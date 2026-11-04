from decimal import Decimal
from django.db import transaction
from rest_framework import serializers
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.exceptions import PermissionDenied, ValidationError
from django.shortcuts import get_object_or_404
from .models import TherapistApplication, Appointment, AppointmentMessage, User
from .therapy_services import balance


class ApplicationSerializer(serializers.ModelSerializer):
    class Meta:
        model = TherapistApplication
        fields = ['bio','credentials','license_number','location','modalities','status','review_note']
        read_only_fields = ['status','review_note']
        extra_kwargs = {f:{'allow_blank':False} for f in ['bio','credentials','license_number','location','modalities']}


class ApplicationView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        app = TherapistApplication.objects.filter(user=request.user).first()
        return Response(ApplicationSerializer(app).data if app else {'status':'not_applied'})
    def post(self, request):
        with transaction.atomic():
            User.objects.select_for_update().get(pk=request.user.pk)
            app = TherapistApplication.objects.filter(user=request.user).first()
            if app and app.status in ('pending','approved'):
                raise ValidationError('Your application is already under review or approved.')
            serializer = ApplicationSerializer(app, data=request.data)
            serializer.is_valid(raise_exception=True)
            serializer.save(user=request.user, status='pending', review_note='')
        return Response(serializer.data, status=201)


class PracticeProfileSerializer(serializers.ModelSerializer):
    last_login=serializers.DateTimeField(source="user.last_login",read_only=True)
    class Meta:
        from .models import Therapist
        model = Therapist
        fields = ['last_login','degrees','certifications','is_available','availability_status','referral_code','last_activity_confirmation','last_availability_update','verification_status']
        read_only_fields=['referral_code','last_activity_confirmation','last_availability_update','verification_status']
    def validate(self,attrs):
        if 'hourly_rate' in self.initial_data:raise ValidationError('Submit session durations and fees for administrator approval.')
        return attrs
    def validate_hourly_rate(self, value):
        if value is None or not value.is_finite() or value <= 0:
            raise ValidationError('Set a positive hourly rate.')
        return value


class PracticeProfileView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        if not request.user.is_therapist:
            raise PermissionDenied('Approved therapist account required.')
        return Response(PracticeProfileSerializer(request.user.therapist_profile).data)
    def patch(self, request):
        if not request.user.is_therapist:
            raise PermissionDenied('Approved therapist account required.')
        serializer = PracticeProfileSerializer(request.user.therapist_profile, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True); serializer.save(last_availability_update=__import__('django.utils.timezone',fromlist=['now']).now())
        return Response(serializer.data)


class AppointmentChatView(APIView):
    permission_classes = [IsAuthenticated]
    def appointment(self, request, pk):
        a = get_object_or_404(Appointment, pk=pk)
        if request.user.pk not in (a.user_id, a.therapist_id):
            raise PermissionDenied('This conversation is private to the appointment participants.')
        return a
    def get(self, request, pk):
        a = self.appointment(request, pk)
        return Response(list(a.messages.values('id','author_id','body','created_at')))
    def post(self, request, pk):
        a = self.appointment(request, pk)
        if a.status == 'CANCELED':
            raise ValidationError('This appointment was cancelled. Its conversation is read-only.')
        body = serializers.CharField(max_length=2000, trim_whitespace=True).run_validation(request.data.get('body'))
        message = AppointmentMessage.objects.create(appointment=a, author=request.user, body=body)
        return Response({'id':message.pk,'body':message.body,'author_id':message.author_id,'created_at':message.created_at},status=201)


class AppointmentPaymentView(APIView):
    permission_classes = [IsAuthenticated]
    def post(self,request,pk):
        from django.conf import settings
        from .billing import stripe_ready
        import stripe
        with transaction.atomic():
            a=get_object_or_404(Appointment.objects.select_for_update(),pk=pk,user=request.user,status='BOOKED')
            if a.payment_status!='pending' or a.fee<=0:
                raise ValidationError('This appointment cannot be charged.')
            if not stripe_ready():
                raise ValidationError('Payments are not configured yet.')
            if a.payment_intent_id:
                intent=stripe.PaymentIntent.retrieve(a.payment_intent_id,api_key=settings.STRIPE_SECRET_KEY)
            else:
                intent=stripe.PaymentIntent.create(amount=int(a.fee*100),currency=settings.HEARTELI_CURRENCY,
                    metadata={'appointment_id':str(a.pk)},automatic_payment_methods={'enabled':True},
                    idempotency_key=f'hearteli-appointment-{a.pk}',api_key=settings.STRIPE_SECRET_KEY)
                a.payment_intent_id=intent.id;a.save(update_fields=['payment_intent_id'])
            return Response({'client_secret':intent.client_secret,'amount':a.fee,'currency':settings.HEARTELI_CURRENCY,'platform_fee_percent':10})


class AppointmentCheckoutView(APIView):
    permission_classes=[IsAuthenticated]
    def post(self,request,pk):
        from .billing import appointment_checkout
        with transaction.atomic():
            a=get_object_or_404(Appointment.objects.select_for_update(),pk=pk,user=request.user)
            url=appointment_checkout(a)
        return Response({'url':url})

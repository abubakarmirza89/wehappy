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


APPLICATIONS_PAUSED = (
    'New therapist applications are not available while we update professional verification. '
    'Please check back here later.'
)


class ApplicationView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        app = TherapistApplication.objects.filter(user=request.user).first()
        return Response({
            'status': app.status if app else 'not_applied',
            'updated_at': app.updated_at if app else None,
            'applications_open': False,
        })

    def post(self, request):
        # The legacy form cannot verify jurisdiction-specific evidence and consent.
        return Response({
            'code': 'applications_paused',
            'detail': APPLICATIONS_PAUSED,
        }, status=409)


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


class AppointmentCheckoutView(APIView):
    permission_classes=[IsAuthenticated]
    def post(self,request,pk):
        from .billing import appointment_checkout
        with transaction.atomic():
            a=get_object_or_404(Appointment.objects.select_for_update(),pk=pk,user=request.user)
            url=appointment_checkout(a)
        return Response({'url':url})

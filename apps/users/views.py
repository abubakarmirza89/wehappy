from decimal import Decimal
import stripe
from django.conf import settings
from django.contrib.auth import get_user_model
from django.contrib.auth.tokens import default_token_generator
from django.core.mail import send_mail
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode
from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.generics import CreateAPIView, ListAPIView, RetrieveAPIView
from rest_framework.mixins import DestroyModelMixin, ListModelMixin, RetrieveModelMixin, UpdateModelMixin
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from django.contrib.auth import authenticate, login, logout
from rest_framework.authtoken.models import Token
from rest_framework.views import APIView
from django.db.models import Avg, Sum
from django.utils import timezone
from django.shortcuts import render
from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError as DjangoValidationError
from rest_framework.throttling import ScopedRateThrottle
from django.views.decorators.http import require_http_methods
from django.views.decorators.csrf import csrf_protect



from apps.users.models import Appointment, Brain_Health_Score, DeviceToken, Notification, UserHistory, WithdrawalRequest
from .serializers import (
    FeedbackSerializer,
    NotificationSerializer,
    TherapistAppointmentSerializer,
    UserAppointmentSerializer,
    UserHistorySerializer,
    UserSerializer,
    TherapistPublicSerializer,
    UserSignupSerializer,
    WithdrawalRequestSerializer,
)

stripe.api_key = settings.STRIPE_SECRET_KEY

User = get_user_model()


class LoginView(APIView):
    throttle_classes = [ScopedRateThrottle]
    throttle_scope = "hearteli_auth"
    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')
        user = authenticate(request, email=email, password=password)
        if user is not None:
            login(request, user)
            token, _ = Token.objects.get_or_create(user=user)
            
            # Create the response data
            user_data = {
                'token': token.key,
                'user_id': user.id,
                'user_name': user.name,
                'is_therapist': user.is_therapist,
            }
            return Response(user_data)
        else:
            return Response({'error': 'Invalid credentials.'}, status=status.HTTP_401_UNAUTHORIZED)
        
class LogoutView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        DeviceToken.objects.filter(user=request.user).update(is_active=False)
        Token.objects.filter(user=request.user).delete()
        logout(request)
        return Response({'message': 'Logout successful.'})


class DeviceTokenView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        token = request.data.get('token')
        platform = request.data.get('platform', 'unknown')
        if not token:
            return Response({'error': 'token is required.'}, status=status.HTTP_400_BAD_REQUEST)

        device_token, _ = DeviceToken.objects.update_or_create(
            token=token,
            defaults={'user': request.user, 'platform': platform, 'is_active': True},
        )
        return Response({'id': device_token.id, 'message': 'Device token registered.'}, status=status.HTTP_200_OK)

    def delete(self, request):
        token = request.data.get('token')
        if not token:
            return Response({'error': 'token is required.'}, status=status.HTTP_400_BAD_REQUEST)
        DeviceToken.objects.filter(user=request.user, token=token).update(is_active=False)
        return Response({'message': 'Device token removed.'}, status=status.HTTP_200_OK)


class ForgotPasswordView(APIView):
    permission_classes = []
    throttle_classes = [ScopedRateThrottle]
    throttle_scope = "hearteli_auth"

    def post(self, request):
        email = request.data.get('email')
        if not isinstance(email, str) or not email:
            return Response({'error': 'Email is required.'}, status=status.HTTP_400_BAD_REQUEST)

        from django.core.validators import validate_email
        try:
            validate_email(email)
        except DjangoValidationError:
            return Response({'error': 'Enter a valid email address.'}, status=400)
        from .communications import request_password_reset
        request_password_reset(email)
        return Response({'message': 'If an active account exists with this email, a reset link will be sent.'}, status=200)


class ResetPasswordView(APIView):
    permission_classes = []
    throttle_classes = [ScopedRateThrottle]
    throttle_scope = "hearteli_auth"

    def post(self, request):
        uid = request.data.get('uid')
        token = request.data.get('token')
        new_password = request.data.get('new_password')

        if not all(isinstance(value, str) and value for value in (uid, token, new_password)):
            return Response({'error': 'uid, token, and new_password are required.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user_id = urlsafe_base64_decode(uid).decode()
            user = User.objects.get(pk=user_id)
        except (AttributeError, TypeError, ValueError, OverflowError, User.DoesNotExist):
            return Response({'error': 'Invalid reset link.'}, status=status.HTTP_400_BAD_REQUEST)

        if not default_token_generator.check_token(user, token):
            return Response({'error': 'Invalid or expired reset token.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            validate_password(new_password, user=user)
        except DjangoValidationError as error:
            return Response({'new_password': error.messages}, status=status.HTTP_400_BAD_REQUEST)
        user.set_password(new_password)
        user.save(update_fields=['password'])
        DeviceToken.objects.filter(user=user).update(is_active=False)
        Token.objects.filter(user=user).delete()
        from .communications import password_changed
        password_changed(user)
        return Response({'message': 'Password reset successful.'}, status=status.HTTP_200_OK)


class SignupView(APIView):
    throttle_classes = [ScopedRateThrottle]
    throttle_scope = "hearteli_auth"
    def post(self, request):
        serializer = UserSignupSerializer(data=request.data)
        if serializer.is_valid():
            email = serializer.validated_data['email']
            username = serializer.validated_data['name']
            password = serializer.validated_data['password']
            phone_number = serializer.validated_data['phone_number']
            is_therapist = False
            if not User.objects.filter(name=username).exists():
                user = User.objects.create_user(
                    name=username, password=password, email=email, phone_number=phone_number, is_therapist=is_therapist)
                return Response({'message': 'Signup successful.'})
            else:
                return Response({'error': 'Username already exists.'}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class UserViewSet(RetrieveModelMixin, ListModelMixin, DestroyModelMixin, UpdateModelMixin, viewsets.GenericViewSet):
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return User.objects.filter(pk=self.request.user.pk)

    def destroy(self, request, *args, **kwargs):
        return Response({'detail': 'Use the password-confirmed Hearteli data deletion flow.'},
                        status=status.HTTP_405_METHOD_NOT_ALLOWED)


class TherapistListViewSet(ListAPIView):
    serializer_class = TherapistPublicSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return User.objects.filter(is_therapist=True, is_active=True)
    
class TherapistProfileViewSet(RetrieveAPIView):
    queryset = User.objects.all()
    serializer_class = TherapistPublicSerializer
    permission_classes = [IsAuthenticated]

    def retrieve(self, request, *args, **kwargs):
        try:
            therapist_id = self.kwargs['pk']
            therapist = self.queryset.get(id=therapist_id, is_therapist=True, is_active=True)
            serializer = self.get_serializer(therapist)
            return Response(serializer.data)
        except User.DoesNotExist:
            return Response({'error': 'Therapist not found'}, status=status.HTTP_404_NOT_FOUND)


class AppointmentViewSet(RetrieveModelMixin, ListModelMixin, DestroyModelMixin, UpdateModelMixin, viewsets.GenericViewSet):
    queryset = Appointment.objects.all()
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        if user.is_therapist:
            therapist = user
            return Appointment.objects.filter(therapist=therapist)
        else:
            return Appointment.objects.filter(user=user)

    def get_serializer_class(self):
        if not self.request.user.is_therapist:
            return UserAppointmentSerializer
        else:
            return TherapistAppointmentSerializer

    def perform_update(self, serializer):
        from django.db import transaction
        from rest_framework.exceptions import ValidationError
        instance = serializer.instance
        if instance.status not in ('BOOKED', 'IN_PROGRESS'):
            raise ValidationError('This appointment cannot be changed.')
        next_status = serializer.validated_data.get('status', instance.status)
        if self.request.user.is_therapist and next_status not in ('BOOKED', 'IN_PROGRESS', 'COMPLETED', 'CANCELED'):
            raise ValidationError({'status': 'Choose a valid appointment status.'})
        if instance.status == 'IN_PROGRESS' and next_status != 'COMPLETED':
            raise ValidationError('An in-progress appointment can only be completed.')
        with transaction.atomic():
            User.objects.select_for_update().get(pk=instance.therapist_id)
            date = serializer.validated_data.get('date', instance.date)
            time = serializer.validated_data.get('time', instance.time)
            if date != instance.date or time != instance.time:
                validate_appointment_slot(instance.therapist, date, time, exclude=instance.pk)
            serializer.save()

    @action(detail=True, methods=['post'])
    def cancel(self, request, pk=None):
        appointment = self.get_object()
        if appointment.status == 'CANCELED':
            return Response(self.get_serializer(appointment).data)
        if appointment.status != 'BOOKED':
            return Response({'detail': 'Only booked appointments can be cancelled.'}, status=400)
        # Refunds require a verified provider payment policy; never fabricate charges.
        appointment.status = 'CANCELED'
        appointment.save(update_fields=['status'])
        return Response(self.get_serializer(appointment).data)

    def destroy(self, request, *args, **kwargs):
        return Response({'detail': 'Cancel the appointment to preserve its history.'}, status=405)


def validate_appointment_slot(therapist, date, time, exclude=None):
    from datetime import datetime, timezone as dt_timezone
    from rest_framework.exceptions import ValidationError
    start = datetime.combine(date, time, tzinfo=dt_timezone.utc)
    if start <= timezone.now():
        raise ValidationError({'date': 'Choose a future appointment time (UTC).'})
    occupied = Appointment.objects.filter(therapist=therapist, date=date, time=time).exclude(status='CANCELED')
    if exclude:
        occupied = occupied.exclude(pk=exclude)
    if occupied.exists():
        raise ValidationError({'time': 'This time is already booked. Choose another time.'})


class TherapistDashboardView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        if not request.user.is_therapist:
            return Response({'error': 'Therapist access required.'}, status=status.HTTP_403_FORBIDDEN)
        appointments = Appointment.objects.filter(therapist=request.user)
        earned = appointments.filter(payment_status='paid').aggregate(total=Sum('therapist_earnings'))['total'] or Decimal('0')
        pending = WithdrawalRequest.objects.filter(therapist=request.user, status='pending').aggregate(total=Sum('amount'))['total'] or Decimal('0')
        profile = request.user.therapist_profile
        return Response({'appointments': TherapistAppointmentSerializer(appointments, many=True).data, 'total_earned': earned, 'pending_withdrawals': pending, 'hourly_rate': profile.hourly_rate, 'is_available': profile.is_available})


class TherapistSettingsView(APIView):
    permission_classes = [IsAuthenticated]

    def patch(self, request):
        if not request.user.is_therapist:
            return Response({'error': 'Therapist access required.'}, status=status.HTTP_403_FORBIDDEN)
        profile = request.user.therapist_profile
        if 'hourly_rate' in request.data:
            try:
                hourly_rate = Decimal(str(request.data['hourly_rate']))
            except Exception:
                return Response({'error': 'hourly_rate must be numeric.'}, status=status.HTTP_400_BAD_REQUEST)
            if hourly_rate < 0:
                return Response({'error': 'hourly_rate cannot be negative.'}, status=status.HTTP_400_BAD_REQUEST)
            profile.hourly_rate = hourly_rate
        if 'is_available' in request.data:
            profile.is_available = bool(request.data['is_available'])
        profile.save(update_fields=['hourly_rate', 'is_available'])
        return Response({'hourly_rate': profile.hourly_rate, 'is_available': profile.is_available})


class WithdrawalRequestView(CreateAPIView, ListAPIView):
    serializer_class = WithdrawalRequestSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return WithdrawalRequest.objects.filter(therapist=self.request.user)

    def perform_create(self, serializer):
        if not self.request.user.is_therapist:
            from rest_framework.exceptions import PermissionDenied
            raise PermissionDenied('Therapist access required.')
        amount = serializer.validated_data['amount']
        available = Appointment.objects.filter(therapist=self.request.user, payment_status='paid').aggregate(total=Sum('therapist_earnings'))['total'] or Decimal('0')
        if amount <= 0 or amount > available:
            from rest_framework.exceptions import ValidationError
            raise ValidationError({'amount': 'Amount exceeds available therapist earnings.'})
        serializer.save(therapist=self.request.user)


class CreateAppointmentViewSet(CreateAPIView):
    serializer_class = UserAppointmentSerializer
    queryset = Appointment.objects.all()
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):
        user = self.request.user
        therapist_id = self.kwargs.get("pk")
        therapist = User.objects.filter(pk=therapist_id, is_therapist=True, is_active=True).first()
        if therapist is None or not hasattr(therapist, 'therapist_profile'):
            from rest_framework.exceptions import NotFound
            raise NotFound('Therapist not found or unavailable.')
        fee = therapist.therapist_profile.hourly_rate or Decimal('0')
        commission = (fee * settings.THERAPIST_COMMISSION_PERCENT / Decimal('100')).quantize(Decimal('0.01'))
        earnings = fee - commission
        from django.db import transaction
        with transaction.atomic():
            User.objects.select_for_update().get(pk=therapist.pk)
            validate_appointment_slot(therapist, serializer.validated_data['date'], serializer.validated_data['time'])
            serializer.save(user=user, therapist=therapist, fee=fee, commission=commission, therapist_earnings=earnings)


class FeedbackCreateView(CreateAPIView):
    serializer_class = FeedbackSerializer
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):
        therapist_id = self.kwargs.get("pk")
        therapist = User.objects.get(pk=therapist_id)
        appointment_id = self.request.data.get("appointment_id")
        appointment = Appointment.objects.get(pk=appointment_id)

        serializer.save(user=self.request.user,
                        therapist=therapist, appointment=appointment)


class NotificationViewSet(viewsets.ReadOnlyModelViewSet):
    serializer_class = NotificationSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        return Notification.objects.filter(recipient=user)

    @action(detail=True, methods=['post'])
    def mark_read(self, request, pk=None):
        notification = self.get_object()
        notification.read = True
        notification.save(update_fields=['read'])
        return Response(self.get_serializer(notification).data)


class UserHistoryListAPIView(ListAPIView):
    serializer_class = UserHistorySerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return UserHistory.objects.filter(user=self.request.user)


def landing_page(request):
    return render(request, 'home.html')

@csrf_protect
@require_http_methods(["GET", "POST"])
def reset_password_page(request):
    uid = request.GET.get('uid') or request.POST.get('uid')
    token = request.GET.get('token') or request.POST.get('token')
    error = None
    completed = False
    try:
        user = User.objects.get(pk=urlsafe_base64_decode(uid).decode())
        valid = default_token_generator.check_token(user, token)
    except (AttributeError, TypeError, ValueError, OverflowError, User.DoesNotExist):
        user = None
        valid = False
    if request.method == 'POST' and valid:
        password = request.POST.get('password', '')
        try:
            if password != request.POST.get('confirm_password'):
                raise DjangoValidationError('Passwords do not match.')
            validate_password(password, user=user)
            user.set_password(password)
            user.save(update_fields=['password'])
            DeviceToken.objects.filter(user=user).update(is_active=False)
            Token.objects.filter(user=user).delete()
            from .communications import password_changed
            password_changed(user)
            completed = True
        except DjangoValidationError as exc:
            error = ' '.join(exc.messages)
    return render(request, 'reset_password.html', {
        'uid': uid, 'token': token, 'valid': valid, 'completed': completed, 'error': error})


@csrf_protect
@require_http_methods(['GET', 'POST'])
def forgot_password_page(request):
    from django import forms
    from django.core.cache import cache
    from .communications import request_password_reset
    class ResetForm(forms.Form):
        email = forms.EmailField()
    form = ResetForm(request.POST or None)
    submitted = False
    if request.method == 'POST' and form.is_valid():
        import hashlib
        address = form.cleaned_data['email'].lower()
        key = 'hearteli-reset:' + hashlib.sha256(address.encode()).hexdigest()
        if cache.add(key, True, 60):
            request_password_reset(address)
        submitted = True
    return render(request, 'work/forgot_password.html', {'form': form, 'submitted': submitted})

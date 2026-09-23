from decimal import Decimal
import stripe
from django.conf import settings
from django.contrib.auth import get_user_model
from django.contrib.auth.tokens import default_token_generator
from django.core.mail import send_mail
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode
from rest_framework import viewsets
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



from apps.users.models import Appointment, Brain_Health_Score, DeviceToken, Notification, UserHistory, WithdrawalRequest
from .serializers import (
    FeedbackSerializer,
    NotificationSerializer,
    TherapistAppointmentSerializer,
    UserAppointmentSerializer,
    UserHistorySerializer,
    UserSerializer,
    UserSignupSerializer,
    WithdrawalRequestSerializer,
)

stripe.api_key = settings.STRIPE_SECRET_KEY

User = get_user_model()


class LoginView(APIView):
    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')
        user = authenticate(request, email=email, password=password)
        if user is not None:
            login(request, user)
            token, _ = Token.objects.get_or_create(user=user)
            
            # Fetch the average brain health score
            average_brain_health_score = Brain_Health_Score.objects.aggregate(avg_score=Avg('rating'))['avg_score']
            
            # Set average brain health score to 100 if it's null
            if average_brain_health_score is None:
                average_brain_health_score = 100

            # Create the response data
            user_data = {
                'token': token.key,
                'user_id': user.id,
                'user_name': user.name,
                'is_therapist': user.is_therapist,
                'average_brain_health_score': average_brain_health_score
            }
            return Response(user_data)
        else:
            return Response({'error': 'Invalid credentials.'}, status=status.HTTP_401_UNAUTHORIZED)
        
class LogoutView(APIView):
    def post(self, request):
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

    def post(self, request):
        email = request.data.get('email')
        if not email:
            return Response({'error': 'Email is required.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response({'message': 'If an account exists with this email, a reset link has been sent.'}, status=status.HTTP_200_OK)

        uid = urlsafe_base64_encode(force_bytes(user.pk))
        token = default_token_generator.make_token(user)
        reset_link = f"{request.build_absolute_uri('/reset-password/')}?uid={uid}&token={token}"

        send_mail(
            subject='Reset your WeHappy password',
            message=(
                f"Hi {user.name},\n\n"
                f"Use the following link to reset your password:\n{reset_link}\n\n"
                "If you did not request this, you can ignore this email."
            ),
            from_email=settings.DEFAULT_FROM_EMAIL or 'noreply@wehappy.local',
            recipient_list=[user.email],
            fail_silently=False,
        )

        return Response({'message': 'If an account exists with this email, a reset link has been sent.'}, status=status.HTTP_200_OK)


class ResetPasswordView(APIView):
    permission_classes = []

    def post(self, request):
        uid = request.data.get('uid')
        token = request.data.get('token')
        new_password = request.data.get('new_password')

        if not uid or not token or not new_password:
            return Response({'error': 'uid, token, and new_password are required.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user_id = urlsafe_base64_decode(uid).decode()
            user = User.objects.get(pk=user_id)
        except (TypeError, ValueError, OverflowError, User.DoesNotExist):
            return Response({'error': 'Invalid reset link.'}, status=status.HTTP_400_BAD_REQUEST)

        if not default_token_generator.check_token(user, token):
            return Response({'error': 'Invalid or expired reset token.'}, status=status.HTTP_400_BAD_REQUEST)

        user.set_password(new_password)
        user.save()
        return Response({'message': 'Password reset successful.'}, status=status.HTTP_200_OK)


class SignupView(APIView):
    def post(self, request):
        serializer = UserSignupSerializer(data=request.data)
        if serializer.is_valid():
            email = serializer.validated_data['email']
            username = serializer.validated_data['name']
            password = serializer.validated_data['password']
            phone_number = serializer.validated_data['phone_number']
            is_therapist = serializer.validated_data['is_therapist']
            if not User.objects.filter(name=username).exists():
                user = User.objects.create_user(
                    name=username, password=password, email=email, phone_number=phone_number, is_therapist=is_therapist)
                return Response({'message': 'Signup successful.'})
            else:
                return Response({'error': 'Username already exists.'}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class UserViewSet(RetrieveModelMixin, ListModelMixin, DestroyModelMixin, UpdateModelMixin, viewsets.GenericViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer


class TherapistListViewSet(ListAPIView):
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return User.objects.filter(is_therapist=True, is_active=True)
    
class TherapistProfileViewSet(RetrieveAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
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
        instance = serializer.instance
        if self.request.user.is_therapist:
            status = serializer.validated_data.get("status")
            if status in ["completed", "cancelled"]:
                if status == "cancelled":
                    # Calculate the refund amount (80%)
                    total_amount = instance.hourly_rate * instance.duration
                    refund_amount = total_amount * Decimal("0.8")
                    # Charge 20% as cancellation fee
                    cancellation_fee = total_amount * Decimal("0.2")
                    # Perform refund and charge operations with Stripe
                    stripe.Refund.create(
                        payment_intent=instance.payment_intent_id,
                        amount=int(refund_amount * 100),  # Convert to cents
                    )
                    stripe.Charge.create(
                        amount=int(cancellation_fee * 100),  # Convert to cents
                        currency="usd",
                        customer=instance.customer_id,
                        description="Cancellation fee",
                    )

                if status == "completed":
                    # Calculate the charge amount (including 10% additional fee)
                    total_amount = instance.hourly_rate * instance.duration
                    charge_amount = total_amount * Decimal("1.1")
                    # Perform charge operation with Stripe
                    stripe.Charge.create(
                        amount=int(charge_amount * 100),  # Convert to cents
                        currency="usd",
                        customer=instance.customer_id,
                        description="Appointment charge",
                    )
        serializer.save()


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

    def get_queryset(self):
        user = self.request.user
        return Notification.objects.filter(recipient=user)


class UserHistoryListAPIView(ListAPIView):
    queryset = UserHistory.objects.all()
    serializer_class = UserHistorySerializer


def landing_page(request):
    return render(request, 'home.html')
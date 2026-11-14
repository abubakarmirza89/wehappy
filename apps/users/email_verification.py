"""Verify possession of new self-service account email addresses."""
from django.contrib.auth.tokens import PasswordResetTokenGenerator
from django.db import transaction
from django.shortcuts import render
from django.urls import reverse
from django.utils import timezone
from django.views.decorators.http import require_http_methods
from rest_framework.response import Response
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.authtoken.models import Token
from rest_framework.exceptions import PermissionDenied
from rest_framework.throttling import ScopedRateThrottle
from rest_framework.views import APIView

from .communications import dispatch_email_batch, queue_email
from .models import User


class EmailToken(PasswordResetTokenGenerator):
    key_salt = 'hearteli.email-verification.v1'

    def _make_hash_value(self, user, timestamp):
        return f'{user.pk}:{user.password}:{user.email}:{user.email_verified_at}:{timestamp}'


email_token = EmailToken()


def needs_verification(user):
    return user.email_verification_required and not user.email_verified_at


def queue_verification(user):
    if not needs_verification(user):
        return
    # Bucket retries to avoid duplicate emails and preserve outbox retries.
    bucket = int(timezone.now().timestamp()) // 300
    path = reverse('verify-hearteli-email', args=[user.pk, email_token.make_token(user)])
    delivery = queue_email(
        user, 'verify_email', 'Confirm your email for Hearteli',
        "Welcome to Hearteli! Please confirm your email address so we can finish setting up your account. If you didn't create a Hearteli account, you can ignore this email.",
        key=f'verify-email:{user.pk}:{bucket}', path=path, sensitive=True,
    )
    if delivery and delivery.status in ('pending', 'retry'):
        transaction.on_commit(lambda: dispatch_email_batch(limit=1, delivery_ids=[delivery.pk]), robust=True)


class VerifiedObtainAuthToken(ObtainAuthToken):
    throttle_classes = [ScopedRateThrottle]
    throttle_scope = 'hearteli_auth'

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data, context={'request': request})
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        if needs_verification(user):
            raise PermissionDenied('Verify your email before signing in.')
        token, _ = Token.objects.get_or_create(user=user)
        return Response({'token': token.key})


class ResendVerificationView(APIView):
    permission_classes = []
    throttle_classes = [ScopedRateThrottle]
    throttle_scope = 'hearteli_auth'

    def post(self, request):
        email = request.data.get('email')
        if isinstance(email, str) and len(email) <= 254:
            user = User.objects.filter(email__iexact=email.strip(), is_active=True).first()
            if user:
                queue_verification(user)
        return Response({'message': 'If verification is pending, we will send a link.'})


@require_http_methods(['GET', 'POST'])
def verify_email(request, pk, token):
    with transaction.atomic():
        user = User.objects.select_for_update().filter(pk=pk, is_active=True).first()
        valid = bool(user and needs_verification(user) and email_token.check_token(user, token))
        verified = valid and request.method == 'POST'
        if verified:
            user.email_verified_at = timezone.now()
            user.save(update_fields=['email_verified_at'])
    response = render(request, 'work/verify_email.html', {'valid': valid, 'verified': verified,
                       'circle_next': request.session.get('circle_invitation_next') if verified else None},
                      status=200 if valid else 400)
    response['Cache-Control'] = 'no-store'
    response['Referrer-Policy'] = 'no-referrer'
    return response


def verification_pending(request):
    return render(request, 'work/verify_email.html', {'pending': True})

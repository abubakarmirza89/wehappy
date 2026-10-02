"""Durable transactional email: SMTP acceptance is not proof of delivery/read."""
from datetime import timedelta
from urllib.parse import urlencode
from zoneinfo import ZoneInfo
from django.conf import settings
from django.contrib.auth.tokens import default_token_generator
from django.core.mail import EmailMultiAlternatives
from django.db import transaction
from django.template.loader import render_to_string
from django.utils import timezone
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from .models import EmailDelivery, Notification


def queue_email(user, kind, subject, message, *, key, path='', target_id=None, sensitive=False):
    if not user.is_active:
        return None
    delivery, created = EmailDelivery.objects.get_or_create(event_key=key, defaults={
        'recipient': user, 'kind': kind, 'subject': subject, 'message': message,
        'path': path, 'target_id': target_id, 'sensitive': sensitive})
    if created and kind not in ('password_reset', 'password_changed'):
        Notification.objects.create(recipient=user, verb=message[:255])
    if created and kind not in ('welcome', 'password_reset', 'password_changed'):
        EmailDelivery.objects.get_or_create(event_key=key + ':push', defaults={
            'recipient': user, 'kind': kind, 'channel': 'push', 'subject': subject,
            'message': message, 'path': path, 'target_id': target_id, 'sensitive': sensitive})
    return delivery


def request_password_reset(email):
    from .models import User
    user = User.objects.filter(email__iexact=email, is_active=True).first()
    if not user or not user.has_usable_password():
        return
    import uuid
    query = urlencode({'uid': urlsafe_base64_encode(force_bytes(user.pk)),
                       'token': default_token_generator.make_token(user)})
    queue_email(user, 'password_reset', 'Reset your Hearteli password',
        'Use the secure link below to choose a new password. If you did not request this, ignore this email.',
        key=f'reset:{user.pk}:{uuid.uuid4()}', path=f'/reset-password/?{query}')


def password_changed(user):
    import uuid
    queue_email(user, 'password_changed', 'Your Hearteli password changed',
        'Your password was changed. If this was not you, request a password reset and contact support.',
        key=f'password-changed:{user.pk}:{uuid.uuid4()}', path='/forgot-password/')


def delivery_allowed(delivery):
    """Recheck preferences and consent immediately before sending a queued event."""
    from apps.tracking.models import CircleConnection, EmpathyNudge, HearteliPreferences
    from .models import Appointment
    user = delivery.recipient
    if not user.is_active:
        return 'suppress'
    if delivery.kind in ('welcome', 'password_reset', 'password_changed'):
        if delivery.kind == 'password_reset':
            from urllib.parse import urlsplit, parse_qs
            token = parse_qs(urlsplit(delivery.path).query).get('token', [''])[0]
            if not default_token_generator.check_token(user, token):
                return 'suppress'
        return 'send'
    pref, _ = HearteliPreferences.objects.get_or_create(user=user)
    if delivery.channel == 'email' and not pref.email_notifications:
        return 'suppress'
    if delivery.kind == 'circle_invite' and not CircleConnection.objects.filter(pk=delivery.target_id, recipient=user).exists():
        return 'suppress'
    if delivery.kind == 'workspace':
        from apps.tracking.models import WorkspaceMembership
        if not WorkspaceMembership.objects.filter(pk=delivery.target_id, user=user).exists():
            return 'suppress'
    if delivery.kind in ('nudge', 'acknowledgement', 'support_message'):
        nudge = EmpathyNudge.objects.filter(pk=delivery.target_id).first()
        if not nudge or not CircleConnection.objects.filter(owner=nudge.sender,
            recipient=nudge.recipient, accepted_at__isnull=False, may_receive_nudges=True).exists():
            return 'suppress'
        if not pref.nudge_notifications:
            return 'suppress'
    if delivery.kind == 'reminder':
        from apps.tracking.models import MoodCheckIn
        local_date = timezone.now().astimezone(ZoneInfo(pref.timezone_name)).date()
        if not pref.reminder_enabled or not delivery.event_key.endswith(str(local_date)) or MoodCheckIn.objects.filter(user=user, date=local_date).exists():
            return 'suppress'
    if delivery.kind == 'support_outcome':
        from apps.tracking.models import SupportOutcome
        if SupportOutcome.objects.filter(nudge_id=delivery.target_id).exists():
            return 'suppress'
    if delivery.kind == 'appointment_reminder':
        if not Appointment.objects.filter(pk=delivery.target_id, status='BOOKED').exists():
            return 'suppress'
    local = timezone.now().astimezone(ZoneInfo(pref.timezone_name)).time().replace(tzinfo=None)
    if pref.quiet_start is not None and pref.quiet_end is not None:
        start, end = pref.quiet_start, pref.quiet_end
        quiet = start <= local < end if start < end else local >= start or local < end
        if quiet:
            return 'defer'
    return 'send'


def dispatch_email_batch(limit=100):
    """Row locks prevent concurrent workers. Failed SMTP submissions retry with backoff.

    SMTP cannot guarantee exactly-once delivery across a worker crash after acceptance.
    Stable Message-ID and event keys help providers deduplicate retries.
    """
    totals = {'sent': 0, 'failed': 0, 'suppressed': 0, 'deferred': 0}
    ids = list(EmailDelivery.objects.filter(status__in=['pending', 'retry'],
        next_attempt_at__lte=timezone.now()).order_by('id').values_list('id', flat=True)[:limit])
    for delivery_id in ids:
        with transaction.atomic():
            delivery = EmailDelivery.objects.select_for_update().select_related('recipient').get(pk=delivery_id)
            if delivery.status not in ('pending', 'retry') or delivery.next_attempt_at > timezone.now():
                continue
            decision = delivery_allowed(delivery)
            if decision == 'suppress':
                delivery.status = 'suppressed'; totals['suppressed'] += 1
            elif decision == 'defer':
                delivery.next_attempt_at = timezone.now() + timedelta(minutes=5); totals['deferred'] += 1
            else:
                if delivery.channel == 'push':
                    from .firebase import send_push_notification
                    tokens = list(delivery.recipient.device_tokens.filter(is_active=True).values_list('token', flat=True))
                    if not tokens:
                        delivery.status = 'suppressed'; totals['suppressed'] += 1
                    elif not settings.FIREBASE_CREDENTIALS_PATH:
                        delivery.next_attempt_at = timezone.now() + timedelta(minutes=5)
                        delivery.error_code = 'FCMNotConfigured'; totals['deferred'] += 1
                    else:
                        delivery.attempts += 1
                        try:
                            result = send_push_notification(tokens, delivery.subject, delivery.message,
                                data={'kind': delivery.kind, 'target_id': delivery.target_id or ''})
                            if result.get('sent', 0) == 0:
                                raise RuntimeError('No push accepted')
                            delivery.status = 'sent'; delivery.sent_at = timezone.now(); delivery.error_code = ''
                            totals['sent'] += 1
                        except Exception as exc:
                            delivery.status = 'failed' if delivery.attempts >= 5 else 'retry'
                            delivery.error_code = type(exc).__name__
                            delivery.next_attempt_at = timezone.now() + timedelta(minutes=2 ** delivery.attempts)
                            totals['failed'] += 1
                    delivery.save()
                    continue
                delivery.attempts += 1
                url = settings.HEARTELI_PUBLIC_URL.rstrip('/') + delivery.path if delivery.path else settings.HEARTELI_PUBLIC_URL
                context = {'name': delivery.recipient.name, 'subject': delivery.subject,
                           'message': delivery.message, 'url': url,
                           'security': delivery.kind in ('password_reset', 'password_changed')}
                text = f"Hi {delivery.recipient.name},\n\n{delivery.message}\n\n{url}\n\nHearteli — Know when to be there."
                mail = EmailMultiAlternatives(delivery.subject, text, settings.DEFAULT_FROM_EMAIL,
                    [delivery.recipient.email], headers={'Message-ID': f'<hearteli-{delivery.pk}@{settings.HEARTELI_EMAIL_MESSAGE_DOMAIN}>'})
                mail.attach_alternative(render_to_string('emails/transactional.html', context), 'text/html')
                try:
                    if mail.send(fail_silently=False) != 1:
                        raise RuntimeError('SMTP did not accept the message')
                    delivery.status = 'sent'; delivery.sent_at = timezone.now(); delivery.error_code = ''
                    totals['sent'] += 1
                    if delivery.kind == 'password_reset':
                        delivery.path = ''  # Do not retain a usable reset token after submission.
                    if delivery.kind == 'nudge':
                        from apps.tracking.models import EmpathyNudge
                        EmpathyNudge.objects.filter(pk=delivery.target_id, delivery_status__in=['created', 'queued', 'failed']).update(delivery_status='sent')
                except Exception as exc:
                    delivery.status = 'failed' if delivery.attempts >= 5 else 'retry'
                    delivery.error_code = type(exc).__name__  # Never store provider text/credentials.
                    delivery.next_attempt_at = timezone.now() + timedelta(minutes=2 ** delivery.attempts)
                    totals['failed'] += 1
                    if delivery.kind == 'nudge' and delivery.status == 'failed':
                        from apps.tracking.models import EmpathyNudge
                        nudge = EmpathyNudge.objects.filter(pk=delivery.target_id).first()
                        if nudge:
                            EmpathyNudge.objects.filter(pk=nudge.pk).exclude(delivery_status='opened').update(delivery_status='failed')
                            queue_email(nudge.sender, 'delivery_failure', 'Your Hearteli nudge could not be sent',
                                'We could not send the email notification. Check the app and choose another authorised person if you want.',
                                key=f'nudge-failure:{nudge.pk}', path='/notifications/')
            delivery.save()
    return totals

from datetime import time, timedelta
from unittest.mock import patch
from django.core import mail
from django.test import TestCase, override_settings
from django.utils import timezone
from rest_framework.test import APIClient
from apps.users.models import User, EmailDelivery, Notification, Appointment
from apps.users.communications import dispatch_email_batch, request_password_reset
from apps.users.reminders import queue_due_push_reminders, queue_due_reminders
from apps.tracking.models import CircleConnection, EmpathyNudge, MoodCheckIn, HearteliPreferences
import uuid

@override_settings(EMAIL_BACKEND='django.core.mail.backends.locmem.EmailBackend', HEARTELI_PUBLIC_URL='https://hearteli.example')
class CommunicationTests(TestCase):
    def setUp(self):
        self.member = User.objects.create_user(name='Email Member', email='member@example.com', password='StrongPass123!', phone_number='123')
        self.recipient = User.objects.create_user(name='Email Recipient', email='recipient@example.com', password='StrongPass123!', phone_number='456')
        self.client = APIClient()

    def clear_welcome(self):
        EmailDelivery.objects.update(status='suppressed')

    def nudge(self):
        self.connection = CircleConnection.objects.create(owner=self.member, recipient=self.recipient, accepted_at=timezone.now(), may_receive_nudges=True)
        checkin = MoodCheckIn.objects.create(user=self.member, feeling_category='struggling', notes='secret journal')
        return EmpathyNudge.objects.create(sender=self.member, recipient=self.recipient, check_in=checkin, message='sensitive message', idempotency_key=uuid.uuid4())

    def test_welcome_is_an_in_app_notification(self):
        self.member.save()
        self.assertFalse(EmailDelivery.objects.filter(kind='welcome', recipient=self.member).exists())
        self.assertEqual(
            Notification.objects.filter(
                recipient=self.member,
                verb__startswith='Welcome to Hearteli',
            ).count(),
            1,
        )
        dispatch_email_batch()
        self.assertEqual(len(mail.outbox), 0)

    def test_reset_uses_configured_origin_token_is_one_use_and_tokens_revoked(self):
        from urllib.parse import parse_qs, urlsplit
        from rest_framework.authtoken.models import Token
        self.clear_welcome()
        request_password_reset('MEMBER@example.com')
        self.assertEqual(len(mail.outbox), 1)
        reset_delivery = EmailDelivery.objects.get(kind='password_reset')
        self.assertEqual(reset_delivery.status, 'sent')
        dispatch_email_batch()
        self.assertEqual(len(mail.outbox), 1)
        self.assertIn('https://hearteli.example/reset-password/', mail.outbox[0].body)
        self.assertIn(
            'Warm regards,\nThe Hearteli Team\nKnow when to be there.',
            mail.outbox[0].body,
        )
        self.assertNotIn(self.member.name, mail.outbox[0].body)
        import re
        link = re.search(r'https://hearteli.example/reset-password/\?\S+', mail.outbox[0].body).group()
        query = parse_qs(urlsplit(link).query)
        token = Token.objects.create(user=self.member)
        payload = {'uid': query['uid'][0], 'token': query['token'][0], 'new_password': 'NewStrongPass456!'}
        self.assertEqual(self.client.post('/api/reset-password/', payload).status_code, 200)
        self.assertFalse(Token.objects.filter(pk=token.pk).exists())
        self.assertEqual(self.client.post('/api/reset-password/', payload).status_code, 400)
        self.assertTrue(EmailDelivery.objects.filter(kind='password_changed').exists())
        self.assertEqual(EmailDelivery.objects.get(kind='password_reset').path, '')

    def test_reset_unknown_or_inactive_account_has_same_response(self):
        self.member.is_active = False; self.member.save()
        a = self.client.post('/api/forgot-password/', {'email': self.member.email})
        b = self.client.post('/api/forgot-password/', {'email': 'missing@example.com'})
        self.assertEqual(a.status_code, b.status_code)
        self.assertEqual(a.data, b.data)
        self.assertFalse(EmailDelivery.objects.filter(kind='password_reset').exists())

    def test_nudge_push_has_no_sensitive_payload_and_opens_after_auth(self):
        self.clear_welcome(); nudge = self.nudge()
        delivery = EmailDelivery.objects.get(kind='nudge', channel='push')
        self.assertNotIn('sensitive message', delivery.message)
        self.assertNotIn('secret journal', delivery.message)
        self.assertFalse(EmailDelivery.objects.filter(kind='nudge', channel='email').exists())
        path = f'/notifications/nudges/{nudge.pk}/'
        self.assertEqual(self.client.get(path).status_code, 302)
        self.client.force_login(self.recipient)
        self.assertContains(self.client.get(path), 'sensitive message')
        self.connection.delete()
        self.assertEqual(self.client.get(path).status_code, 404)

    def test_circle_invite_uses_approved_email_and_neutral_push_copy(self):
        self.clear_welcome()
        CircleConnection.objects.create(
            owner=self.member,
            recipient=self.recipient,
        )
        push = EmailDelivery.objects.get(
            kind='circle_invite',
            channel='push',
            recipient=self.recipient,
        )
        self.assertEqual(push.subject, 'Someone wants you in their Circle')
        self.assertEqual(
            push.message,
            "You've received an invitation to connect on Hearteli.",
        )
        self.assertNotIn(self.member.name, push.subject + push.message)
        dispatch_email_batch()
        email = next(message for message in mail.outbox if message.subject == "You've been invited to connect on Hearteli")
        self.assertIn(
            'Someone you know would like to add you to their trusted Circle on Hearteli.',
            email.body,
        )
        self.assertIn('View invitation:', email.body)
        self.assertIn(
            'Warm regards,\nThe Hearteli Team\nKnow when to be there.',
            email.body,
        )
        self.assertNotIn(self.member.name, email.body)
        html = email.alternatives[0][0]
        self.assertIn('Warm regards,', html)
        self.assertIn('The Hearteli Team', html)
        self.assertNotIn(self.member.name, html)
        self.assertLess(html.index('View invitation'), html.index('Warm regards,'))
        self.assertEqual(
            Notification.objects.get(
                recipient=self.recipient,
                verb='Someone wants you in their Circle',
            ).verb,
            'Someone wants you in their Circle',
        )

    def test_revocation_before_dispatch_suppresses_nudge_push(self):
        self.clear_welcome(); self.nudge()
        self.connection.delete(); dispatch_email_batch()
        self.assertFalse(EmailDelivery.objects.filter(kind='nudge', status='sent').exists())

    def test_optout_suppresses_optional_emails_but_not_security(self):
        self.clear_welcome()
        HearteliPreferences.objects.create(user=self.recipient, email_notifications=False)
        CircleConnection.objects.create(
            owner=self.member,
            recipient=self.recipient,
            accepted_at=timezone.now(),
            may_receive_nudges=True,
        )
        request_password_reset(self.recipient.email); dispatch_email_batch()
        self.assertEqual(EmailDelivery.objects.get(kind='circle_invite', channel='email').status, 'suppressed')
        self.assertEqual(EmailDelivery.objects.get(kind='password_reset').status, 'sent')

    def test_quiet_hours_crossing_midnight_defer(self):
        self.clear_welcome()
        CircleConnection.objects.create(
            owner=self.member,
            recipient=self.recipient,
            accepted_at=timezone.now(),
            may_receive_nudges=True,
        )
        HearteliPreferences.objects.create(user=self.recipient, quiet_start=time(22), quiet_end=time(7))
        with patch('apps.users.communications.timezone.now', return_value=timezone.now().replace(hour=23)):
            dispatch_email_batch()
        self.assertEqual(EmailDelivery.objects.get(kind='circle_invite', channel='email').status, 'pending')

    def test_email_failure_retries_without_recreating_event(self):
        self.clear_welcome()
        CircleConnection.objects.create(
            owner=self.member,
            recipient=self.recipient,
            accepted_at=timezone.now(),
            may_receive_nudges=True,
        )
        with patch('apps.users.communications.EmailMultiAlternatives.send', side_effect=OSError('provider failure')):
            dispatch_email_batch()
        delivery = EmailDelivery.objects.get(kind='circle_invite', channel='email')
        self.assertEqual(delivery.status, 'retry'); self.assertEqual(delivery.error_code, 'OSError')
        EmailDelivery.objects.filter(status='retry').update(next_attempt_at=timezone.now())
        dispatch_email_batch(); delivery.refresh_from_db()
        self.assertEqual(delivery.status, 'sent'); self.assertEqual(delivery.attempts, 2)

    def test_private_checkin_never_notifies_anyone(self):
        self.clear_welcome()
        MoodCheckIn.objects.create(user=self.member, feeling_category='struggling', notes='secret')
        self.assertEqual(EmailDelivery.objects.filter(status='pending').count(), 0)

    def test_reminder_timezone_optin_and_deduplication(self):
        self.clear_welcome()
        HearteliPreferences.objects.create(user=self.member, reminder_enabled=True, timezone_name='Asia/Karachi', reminder_time=time(9))
        at = timezone.now().replace(hour=10)
        queue_due_reminders(at); queue_due_reminders(at)
        self.assertFalse(EmailDelivery.objects.filter(kind='reminder', channel='email').exists())
        self.assertFalse(EmailDelivery.objects.filter(kind='reminder', recipient=self.recipient).exists())

    def test_daily_push_prompt_uses_selected_local_time_and_is_idempotent(self):
        from datetime import datetime
        from zoneinfo import ZoneInfo
        from apps.users.models import DeviceToken

        self.clear_welcome()
        DeviceToken.objects.create(user=self.member, token='daily-prompt-device')
        HearteliPreferences.objects.create(
            user=self.member,
            reminder_enabled=True,
            timezone_name='Asia/Karachi',
            reminder_time=time(9),
        )
        local_time = datetime.combine(
            timezone.now().astimezone(ZoneInfo('Asia/Karachi')).date(),
            time(9),
            tzinfo=ZoneInfo('Asia/Karachi'),
        )
        queue_due_push_reminders(local_time - timedelta(minutes=1))
        self.assertFalse(EmailDelivery.objects.filter(kind='daily_prompt').exists())
        queue_due_push_reminders(local_time)
        queue_due_push_reminders(local_time)
        prompts = EmailDelivery.objects.filter(
            kind='daily_prompt',
            recipient=self.member,
            channel='push',
        )
        self.assertEqual(prompts.count(), 1)
        self.assertEqual(prompts.first().status, 'pending')
        self.assertEqual(prompts.first().subject, 'A little moment for you')
        self.assertEqual(
            prompts.first().message,
            'How are you feeling today? Take a moment to check in with yourself.',
        )
        self.assertFalse(EmailDelivery.objects.filter(
            kind='daily_prompt',
            recipient=self.recipient,
        ).exists())

    def test_daily_push_respects_opt_in_quiet_hours_and_checkin(self):
        from apps.users.communications import delivery_allowed
        from apps.users.models import DeviceToken
        from zoneinfo import ZoneInfo

        DeviceToken.objects.create(user=self.member, token='daily-gap-device')
        now = timezone.now()
        local = now.astimezone(ZoneInfo('UTC'))
        HearteliPreferences.objects.create(
            user=self.member,
            reminder_enabled=True,
            timezone_name='UTC',
            quiet_start=(local - timedelta(minutes=1)).time(),
            quiet_end=(local + timedelta(minutes=1)).time(),
        )
        delivery = EmailDelivery.objects.create(
            recipient=self.member,
            event_key=f'daily-prompt:{self.member.pk}:{local.date().isoformat()}',
            kind='daily_prompt',
            channel='push',
            subject='A little moment for you',
            message='Generic prompt.',
        )
        with patch('apps.users.communications.timezone.now', return_value=now):
            self.assertEqual(delivery_allowed(delivery), 'defer')
        HearteliPreferences.objects.filter(user=self.member).update(quiet_start=None, quiet_end=None)
        with patch('apps.users.communications.timezone.now', return_value=now):
            self.assertEqual(delivery_allowed(delivery), 'send')
        MoodCheckIn.objects.create(user=self.member, date=local.date(), feeling_category='good')
        with patch('apps.users.communications.timezone.now', return_value=now):
            self.assertEqual(delivery_allowed(delivery), 'suppress')

    def test_mark_read_is_scoped_to_recipient(self):
        notification = Notification.objects.filter(recipient=self.member).first()
        self.client.force_authenticate(self.recipient)
        path = f'/api/users/notifications/{notification.pk}/read/'
        self.assertEqual(self.client.post(path).status_code, 404)
        self.client.force_authenticate(self.member)
        self.assertEqual(self.client.post(path).status_code, 200)
        notification.refresh_from_db(); self.assertTrue(notification.read)

    def test_preference_validation(self):
        self.client.force_authenticate(self.member)
        path = '/api/tracking/hearteli/preferences/update_mine/'
        self.assertEqual(self.client.patch(path, {'timezone_name':'No/Such_Zone'}, format='json').status_code, 400)
        self.assertEqual(self.client.patch(path, {'quiet_start':'22:00'}, format='json').status_code, 400)
        self.assertEqual(self.client.patch(path, {'quiet_start':'22:00','quiet_end':'07:00'}, format='json').status_code, 200)

    def test_appointment_create_conflict_reschedule_cancel_and_emails(self):
        therapist = User.objects.create_user(name='Email Therapist', email='therapist@example.com', password='StrongPass123!', phone_number='789', is_therapist=True)
        from .billing_helpers import approved_provider
        option=approved_provider(therapist)
        therapist.therapist_profile.is_available=True
        therapist.therapist_profile.hourly_rate=100
        therapist.therapist_profile.save()
        self.client.force_authenticate(self.member)
        tomorrow = timezone.now().date() + timedelta(days=1)
        path = f'/api/users/create-appointment/{therapist.pk}/'
        data = {'offering_id':option.pk,'date':str(tomorrow),'time':'10:00','location':'Online','reason':'Support'}
        response = self.client.post(path, data)
        self.assertEqual(response.status_code, 201)
        appointment = Appointment.objects.get(pk=response.data['id'])
        self.assertEqual(EmailDelivery.objects.filter(kind='appointment', channel='email', target_id=appointment.pk).count(), 2)
        self.assertEqual(self.client.post(path, data).status_code, 400)
        self.assertEqual(self.client.patch(f'/api/users/appointment/{appointment.pk}/', {'time':'11:00'}).status_code, 200)
        self.assertEqual(self.client.post(f'/api/users/appointment/{appointment.pk}/cancel/').status_code, 200)
        self.assertEqual(self.client.post(path, data).status_code, 201)
        self.client.force_authenticate(self.recipient)
        self.assertEqual(self.client.post(f'/api/users/appointment/{appointment.pk}/cancel/').status_code, 404)

    def test_pattern_prompt_is_optin_ask_first_and_never_sends(self):
        self.clear_welcome()
        connection = CircleConnection.objects.create(owner=self.member, recipient=self.recipient,
            accepted_at=timezone.now(), may_receive_nudges=True, ask_on_pattern=True)
        MoodCheckIn.objects.create(user=self.member, feeling_category='struggling')
        MoodCheckIn.objects.create(user=self.member, feeling_category='not_great')
        self.client.force_authenticate(self.member)
        path = '/api/tracking/hearteli/circle/pattern_prompt/'
        self.assertTrue(self.client.get(path).data['suggested'])
        self.assertEqual(EmpathyNudge.objects.count(), 0)
        connection.ask_on_pattern = False; connection.save()
        self.assertFalse(self.client.get(path).data['suggested'])

    def test_nudge_duplicate_pending_state_and_bad_retry_key_are_rejected(self):
        self.clear_welcome(); nudge = self.nudge()
        self.client.force_authenticate(self.member)
        path = '/api/tracking/hearteli/nudges/'
        payload = {'check_in':nudge.check_in_id,'recipient':self.recipient.pk,'message':'Check in?', 'idempotency_key':'bad'}
        self.assertEqual(self.client.post(path,payload).status_code,400)
        payload['idempotency_key'] = str(uuid.uuid4())
        self.assertEqual(self.client.post(path,payload).status_code,400)
        self.assertEqual(EmpathyNudge.objects.count(),1)

    def test_web_password_confirmation_and_invalid_link(self):
        from django.contrib.auth.tokens import default_token_generator
        from django.utils.http import urlsafe_base64_encode
        from django.utils.encoding import force_bytes
        uid = urlsafe_base64_encode(force_bytes(self.member.pk)); token = default_token_generator.make_token(self.member)
        path = '/reset-password/'
        response = self.client.post(path, {'uid':uid,'token':token,'password':'NewStrongPass456!','confirm_password':'different'})
        self.assertContains(response,'Passwords do not match')
        self.member.refresh_from_db(); self.assertTrue(self.member.check_password('StrongPass123!'))
        self.assertContains(self.client.get(path),'invalid or expired')

    @override_settings(FIREBASE_CREDENTIALS_PATH='/configured-for-mock')
    def test_push_is_queued_safe_and_uses_registered_devices(self):
        from apps.users.models import DeviceToken
        self.clear_welcome(); nudge = self.nudge()
        DeviceToken.objects.create(user=self.recipient, token='device-one')
        with patch('apps.users.firebase.send_push_notification', return_value={'sent':1}) as push:
            dispatch_email_batch()
        args, kwargs = push.call_args
        self.assertEqual(args[0], ['device-one'])
        self.assertNotIn('sensitive message', args[2])
        self.assertNotIn('secret journal', args[2])
        self.assertEqual(kwargs['data']['target_id'], nudge.pk)
        self.assertEqual(EmailDelivery.objects.get(kind='nudge',channel='push').status,'sent')

    def test_permanent_email_failure_is_recorded(self):
        self.clear_welcome()
        CircleConnection.objects.create(
            owner=self.member,
            recipient=self.recipient,
            accepted_at=timezone.now(),
            may_receive_nudges=True,
        )
        with patch('apps.users.communications.EmailMultiAlternatives.send', side_effect=OSError('failure')):
            for _ in range(5):
                EmailDelivery.objects.filter(kind='circle_invite',channel='email').update(next_attempt_at=timezone.now())
                dispatch_email_batch()
        delivery = EmailDelivery.objects.get(kind='circle_invite',channel='email')
        self.assertEqual(delivery.status,'failed')
        self.assertFalse(EmailDelivery.objects.filter(kind='delivery_failure',channel='email',recipient=self.member).exists())

    def test_acknowledgement_uses_neutral_push_and_specific_in_app_copy(self):
        self.clear_welcome(); nudge = self.nudge()
        self.client.force_authenticate(self.recipient)
        self.assertEqual(self.client.post(f'/api/tracking/hearteli/nudges/{nudge.pk}/respond/', {'choice':'cannot_help'}).status_code,200)
        delivery = EmailDelivery.objects.get(kind='acknowledgement',channel='push',recipient=self.member)
        self.assertEqual(delivery.subject, 'You have a Hearteli update')
        self.assertEqual(delivery.message, 'Open Hearteli to see it.')
        notification = Notification.objects.get(
            recipient=self.member,
            verb__contains="can't be there right now",
        )
        self.assertIn('reach out to someone else', notification.verb)
        self.assertFalse(EmailDelivery.objects.filter(kind='acknowledgement',channel='email').exists())

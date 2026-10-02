from datetime import time, timedelta
from unittest.mock import patch
from django.core import mail
from django.test import TestCase, override_settings
from django.utils import timezone
from rest_framework.test import APIClient
from apps.users.models import User, EmailDelivery, Notification, Appointment
from apps.users.communications import dispatch_email_batch, request_password_reset
from apps.users.reminders import queue_due_reminders
from apps.tracking.models import CircleConnection, EmpathyNudge, MoodCheckIn, HearteliPreferences, NudgeMessage
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

    def test_welcome_is_queued_once_and_has_html(self):
        self.member.save()
        self.assertEqual(EmailDelivery.objects.filter(kind='welcome', recipient=self.member).count(), 1)
        dispatch_email_batch()
        self.assertEqual(len(mail.outbox), 2)
        self.assertEqual(mail.outbox[0].alternatives[0][1], 'text/html')
        dispatch_email_batch()
        self.assertEqual(len(mail.outbox), 2)

    def test_reset_uses_configured_origin_token_is_one_use_and_tokens_revoked(self):
        from urllib.parse import parse_qs, urlsplit
        from rest_framework.authtoken.models import Token
        self.clear_welcome()
        request_password_reset('MEMBER@example.com')
        dispatch_email_batch()
        self.assertIn('https://hearteli.example/reset-password/', mail.outbox[0].body)
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

    def test_nudge_email_has_no_sensitive_payload_and_opens_after_auth(self):
        self.clear_welcome(); nudge = self.nudge()
        dispatch_email_batch()
        email = next(m for m in mail.outbox if m.subject == 'A gentle check-in from Hearteli')
        self.assertNotIn('sensitive message', email.body); self.assertNotIn('secret journal', email.body)
        path = f'/notifications/nudges/{nudge.pk}/'
        self.assertEqual(self.client.get(path).status_code, 302)
        self.client.force_login(self.recipient)
        self.assertContains(self.client.get(path), 'sensitive message')
        self.connection.delete()
        self.assertEqual(self.client.get(path).status_code, 404)

    def test_revocation_before_dispatch_suppresses_nudge_and_chat(self):
        self.clear_welcome(); nudge = self.nudge()
        NudgeMessage.objects.create(nudge=nudge, author=self.member, body='private chat')
        self.connection.delete(); dispatch_email_batch()
        self.assertFalse(EmailDelivery.objects.filter(kind__in=['nudge','support_message'], status='sent').exists())

    def test_optout_suppresses_optional_emails_but_not_security(self):
        self.clear_welcome(); self.nudge()
        HearteliPreferences.objects.create(user=self.recipient, email_notifications=False)
        request_password_reset(self.recipient.email); dispatch_email_batch()
        self.assertEqual(EmailDelivery.objects.get(kind='nudge', channel='email').status, 'suppressed')
        self.assertEqual(EmailDelivery.objects.get(kind='password_reset').status, 'sent')

    def test_quiet_hours_crossing_midnight_defer(self):
        self.clear_welcome(); self.nudge()
        HearteliPreferences.objects.create(user=self.recipient, quiet_start=time(22), quiet_end=time(7))
        with patch('apps.users.communications.timezone.now', return_value=timezone.now().replace(hour=23)):
            dispatch_email_batch()
        self.assertEqual(EmailDelivery.objects.get(kind='nudge', channel='email').status, 'pending')

    def test_smtp_failure_retries_without_recreating_event(self):
        self.clear_welcome(); self.nudge()
        with patch('apps.users.communications.EmailMultiAlternatives.send', side_effect=OSError('provider failure')):
            dispatch_email_batch()
        delivery = EmailDelivery.objects.get(kind='nudge', channel='email')
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
        self.assertEqual(EmailDelivery.objects.filter(kind='reminder', channel='email').count(), 1)
        self.assertFalse(EmailDelivery.objects.filter(kind='reminder', recipient=self.recipient).exists())

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
        self.client.force_authenticate(self.member)
        tomorrow = timezone.now().date() + timedelta(days=1)
        path = f'/api/users/create-appointment/{therapist.pk}/'
        data = {'date':str(tomorrow),'time':'10:00','location':'Online','reason':'Support'}
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

    def test_permanent_failure_notifies_sender_once(self):
        self.clear_welcome(); nudge = self.nudge()
        with patch('apps.users.communications.EmailMultiAlternatives.send', side_effect=OSError('failure')):
            for _ in range(5):
                EmailDelivery.objects.filter(kind='nudge',channel='email').update(next_attempt_at=timezone.now())
                dispatch_email_batch()
        delivery = EmailDelivery.objects.get(kind='nudge',channel='email')
        self.assertEqual(delivery.status,'failed')
        self.assertEqual(EmailDelivery.objects.filter(kind='delivery_failure',channel='email',recipient=self.member).count(),1)
        nudge.refresh_from_db(); self.assertEqual(nudge.delivery_status,'failed')

    def test_acknowledgement_notifies_sender_and_message_body_is_excluded(self):
        self.clear_welcome(); nudge = self.nudge()
        self.client.force_authenticate(self.recipient)
        self.assertEqual(self.client.post(f'/api/tracking/hearteli/nudges/{nudge.pk}/respond/', {'status':'cannot_help'}).status_code,200)
        self.assertEqual(EmailDelivery.objects.filter(kind='acknowledgement',channel='email',recipient=self.member).count(),1)
        NudgeMessage.objects.create(nudge=nudge, author=self.recipient, body='do not leak chat')
        self.assertNotIn('do not leak chat', str(list(EmailDelivery.objects.filter(kind='support_message').values('subject','message'))))

from django.contrib.auth import get_user_model
from django.core.files.uploadedfile import SimpleUploadedFile
from django.core import mail
from django.test import override_settings
from django.utils import timezone
from rest_framework.test import APITestCase
from apps.tracking.models import (CircleConnection, CircleInviteCode,
                                  CircleSignupInvitation, Mood, MoodCheckIn,
                                  EmpathyNudge, Suggestion, Message,
                                  ConsentEvent)
from apps.users.models import EmailDelivery, Notification, Send_To_Relative
from datetime import timedelta
import uuid
import hashlib

User = get_user_model()

class HearteliConsentTests(APITestCase):
    def setUp(self):
        self.sender = User.objects.create_user(email='sender@example.com', name='Sender', password='strongpassword', phone_number='123')
        self.recipient = User.objects.create_user(email='recipient@example.com', name='Recipient', password='strongpassword', phone_number='456')
        self.other = User.objects.create_user(email='other@example.com', name='Other', password='strongpassword', phone_number='789')
        self.mood = Mood.objects.create(name='Tough', img_emoji=SimpleUploadedFile('m.png', b'image'), score=30)
        self.checkin = MoodCheckIn.objects.create(user=self.sender, notes='Private note')
        self.checkin.moods.add(self.mood)
        self.client.force_authenticate(user=self.sender)

    def test_standalone_nudge_is_explicit_and_does_not_create_a_check_in(self):
        CircleConnection.objects.create(
            owner=self.sender, recipient=self.recipient,
            accepted_at=timezone.now(), may_receive_nudges=True,
        )
        before = MoodCheckIn.objects.count()
        chooser = self.client.get('/api/tracking/hearteli/circle/', {'nudge_eligible': 'true'})
        self.assertEqual(chooser.status_code, 200)
        self.assertEqual([row['recipient'] for row in chooser.data], [self.recipient.pk])
        self.assertFalse(EmpathyNudge.objects.exists())

        url = '/api/tracking/hearteli/nudges/'
        payload = {'recipient': self.recipient.pk, 'message': 'Can we talk?',
                   'idempotency_key': str(uuid.uuid4())}
        self.assertEqual(self.client.post(url, payload, format='json').status_code, 201)
        self.assertEqual(self.client.post(url, payload, format='json').status_code, 200)
        self.assertIsNone(EmpathyNudge.objects.get().check_in_id)
        self.assertEqual(MoodCheckIn.objects.count(), before)
        delivery = EmailDelivery.objects.get(kind='nudge', channel='push')
        self.assertNotIn(payload['message'], delivery.message)

    def test_nudge_chooser_excludes_ineligible_and_send_rechecks_permission(self):
        outgoing = CircleConnection.objects.create(
            owner=self.sender, recipient=self.recipient,
            accepted_at=timezone.now(), may_receive_nudges=True,
        )
        CircleConnection.objects.create(
            owner=self.other, recipient=self.sender,
            accepted_at=timezone.now(), may_receive_nudges=True,
        )
        chooser = '/api/tracking/hearteli/circle/'
        url = '/api/tracking/hearteli/nudges/'
        payload = {'recipient': self.recipient.pk, 'message': 'Hello',
                   'idempotency_key': str(uuid.uuid4())}
        outgoing.may_receive_nudges = False
        outgoing.save(update_fields=['may_receive_nudges'])
        self.assertEqual(self.client.get(chooser, {'nudge_eligible': 'true'}).data, [])
        self.assertEqual(self.client.post(url, payload, format='json').status_code, 400)

        outgoing.may_receive_nudges = True
        outgoing.save(update_fields=['may_receive_nudges'])
        self.recipient.is_active = False
        self.recipient.save(update_fields=['is_active'])
        self.assertEqual(self.client.get(chooser, {'nudge_eligible': 'true'}).data, [])
        self.assertEqual(self.client.post(url, payload, format='json').status_code, 400)
        self.assertFalse(EmpathyNudge.objects.exists())

    def test_circle_code_is_unique_rotated_and_expires(self):
        url = '/api/tracking/hearteli/circle/invite-code/'
        first = self.client.post(url, {'relationship': 'Friend'}, format='json')
        second = self.client.post(url, {'relationship': 'Partner'}, format='json')

        self.assertEqual(first.status_code, 201)
        self.assertEqual(second.status_code, 201)
        self.assertNotEqual(first.data['code'], second.data['code'])
        self.assertEqual(len(second.data['code']), 20)
        self.assertLessEqual(
            (second.data['expires_at'] - timezone.now()).total_seconds(),
            10 * 60,
        )
        self.assertFalse(
            CircleInviteCode.objects.get(
                code_hash=hashlib.sha256(first.data['code'].encode()).hexdigest(),
            ).expires_at > timezone.now()
        )

    def test_circle_code_redeems_once_and_joins_without_nudge_permission(self):
        issued = self.client.post(
            '/api/tracking/hearteli/circle/invite-code/',
            {'relationship': 'Family'},
            format='json',
        )
        code = issued.data['code']
        self.client.force_authenticate(user=self.recipient)

        response = self.client.post(
            '/api/tracking/hearteli/circle/redeem-invite/',
            {'code': f'{code[:5]}-{code[5:10]} {code[10:]}'},
            format='json',
        )

        self.assertEqual(response.status_code, 201)
        connection = CircleConnection.objects.get(
            owner=self.sender,
            recipient=self.recipient,
        )
        self.assertIsNotNone(connection.accepted_at)
        self.assertEqual(connection.relationship, 'Family')
        self.assertFalse(connection.may_receive_nudges)
        self.assertTrue(
            ConsentEvent.objects.filter(
                actor=self.recipient,
                connection=connection,
                event='invite_redeemed',
                categories=[],
            ).exists()
        )
        self.assertTrue(
            Notification.objects.filter(
                recipient=self.sender,
                verb__contains='has accepted your Circle invitation',
            ).exists()
        )
        self.assertEqual(
            self.client.post(
                '/api/tracking/hearteli/circle/redeem-invite/',
                {'code': code},
                format='json',
            ).status_code,
            400,
        )

    def test_circle_code_rejects_self_and_expired_codes(self):
        url = '/api/tracking/hearteli/circle/invite-code/'
        issued = self.client.post(url, {}, format='json')
        code = issued.data['code']
        redeem_url = '/api/tracking/hearteli/circle/redeem-invite/'
        self.client.force_authenticate(user=None)
        self.assertIn(
            self.client.post(redeem_url, {'code': code}, format='json').status_code,
            (401, 403),
        )

        self.client.force_authenticate(user=self.sender)
        self.assertEqual(
            self.client.post(redeem_url, {'code': code}, format='json').status_code,
            400,
        )

        self.client.force_authenticate(user=self.recipient)
        digest = hashlib.sha256(code.encode()).hexdigest()
        CircleInviteCode.objects.filter(code_hash=digest).update(
            expires_at=timezone.now() - timedelta(seconds=1),
        )
        self.assertEqual(
            self.client.post(redeem_url, {'code': code}, format='json').status_code,
            400,
        )

    def test_existing_member_can_be_invited_to_circle(self):
        response = self.client.post(
            '/api/tracking/hearteli/circle/',
            {
                'recipient_email_input': self.recipient.email.upper(),
                'relationship': 'Friend',
            },
            format='json',
        )

        self.assertEqual(response.status_code, 201)
        connection = CircleConnection.objects.get(
            owner=self.sender,
            recipient=self.recipient,
        )
        self.assertEqual(response.data['id'], connection.id)
        self.assertIsNone(connection.accepted_at)
        self.assertTrue(
            EmailDelivery.objects.filter(
                recipient=self.recipient,
                kind='circle_invite',
                channel='email',
                target_id=connection.id,
            ).exists()
        )

    @override_settings(
        EMAIL_BACKEND='django.core.mail.backends.locmem.EmailBackend',
        HEARTELI_PUBLIC_URL='https://hearteli.example',
    )
    def test_non_member_signup_invite_requires_explicit_acceptance(self):
        unknown_member = self.client.post(
            '/api/tracking/hearteli/circle/',
            {'recipient_email_input': 'new-person@example.com'},
            format='json',
        )
        self.assertEqual(unknown_member.status_code, 404)

        response = self.client.post(
            '/api/tracking/hearteli/circle/invite-signup/',
            {'email': 'new-person@example.com', 'relationship': 'Friend'},
            format='json',
        )

        self.assertEqual(response.status_code, 201)
        invitation = CircleSignupInvitation.objects.get(email='new-person@example.com')
        self.assertIsNotNone(invitation.last_sent_at)
        self.assertEqual(len(mail.outbox), 1)
        self.assertEqual(mail.outbox[0].to, ['new-person@example.com'])
        self.assertIn(self.sender.name, mail.outbox[0].body)
        self.assertIn('new-person@example.com', mail.outbox[0].body)
        self.assertIn('https://hearteli.example/', mail.outbox[0].body)
        self.assertIn('Warm regards,\nThe Hearteli Team', mail.outbox[0].body)

        new_member = User.objects.create_user(
            email='new-person@example.com',
            name='New Circle Member',
            password='strongpassword',
            phone_number='789',
        )
        from django.test import Client
        from apps.tracking.circle_invitation_web import invitation_path
        path = invitation_path(invitation)
        browser = Client()
        self.assertContains(browser.get(path), 'Create a Hearteli account')
        self.assertFalse(CircleConnection.objects.filter(recipient=new_member).exists())
        browser.force_login(self.other)
        self.assertContains(browser.post(path, {'decision': 'accept'}), 'matching the invited email')
        browser.force_login(new_member)
        self.assertContains(browser.get(path), 'Accept invitation')
        self.assertFalse(CircleConnection.objects.filter(recipient=new_member).exists())
        self.assertContains(browser.post(path, {'decision': 'accept'}), 'Invitation accepted')
        connection = CircleConnection.objects.get(owner=self.sender, recipient=new_member)
        self.assertEqual(connection.relationship, 'Friend')
        self.assertIsNotNone(connection.accepted_at)
        self.assertFalse(connection.may_receive_nudges)
        self.assertContains(browser.post(path, {'decision': 'accept'}), 'already used')

    @override_settings(EMAIL_BACKEND='django.core.mail.backends.locmem.EmailBackend')
    def test_existing_member_invite_retries_and_decline(self):
        from django.test import Client
        from apps.tracking.circle_invitation_web import invitation_path
        url = '/api/tracking/hearteli/circle/invite-signup/'
        for expected in (201, 200):
            result = self.client.post(url, {'email': self.recipient.email}, format='json')
            self.assertEqual(result.status_code, expected)
        self.assertEqual(len(mail.outbox), 1)
        invitation = CircleSignupInvitation.objects.get(email=self.recipient.email)
        browser = Client()
        browser.force_login(self.recipient)
        path = invitation_path(invitation)
        self.assertContains(browser.post(path, {'decision': 'decline'}), 'Invitation declined')
        self.assertContains(browser.post(path, {'decision': 'accept'}), 'already used')
        self.assertFalse(CircleConnection.objects.filter(recipient=self.recipient).exists())
        self.assertEqual(len(mail.outbox), 1)

    def test_nudge_requires_recipient_acceptance_and_respects_revoke(self):
        connection = CircleConnection.objects.create(owner=self.sender, recipient=self.recipient)
        payload = {'check_in': self.checkin.id, 'recipient': self.recipient.id,
                   'message': 'Could you call me?', 'idempotency_key': str(uuid.uuid4())}
        url = '/api/tracking/hearteli/nudges/'
        self.assertEqual(self.client.post(url, payload).status_code, 400)
        self.client.force_authenticate(user=self.recipient)
        self.assertEqual(self.client.patch(f'/api/tracking/hearteli/circle/{connection.id}/', {'accept': True, 'may_receive_nudges': True}, format='json').status_code, 200)
        self.client.force_authenticate(user=self.sender)
        self.assertEqual(self.client.post(url, payload).status_code, 201)
        self.assertEqual(self.client.post(url, payload).status_code, 200)
        self.assertEqual(EmpathyNudge.objects.count(), 1)
        self.client.force_authenticate(user=self.other)
        self.assertEqual(self.client.get(url).data, [])
        self.client.force_authenticate(user=self.recipient)
        self.assertNotIn('Private note', str(self.client.get(url).data))
        self.client.patch(f'/api/tracking/hearteli/circle/{connection.id}/', {'may_receive_nudges': False}, format='json')
        self.client.force_authenticate(user=self.sender)
        payload['idempotency_key'] = str(uuid.uuid4())
        self.assertEqual(self.client.post(url, payload).status_code, 400)

    def test_suggestion_get_does_not_share_mood(self):
        Suggestion.objects.create(mood=self.mood, suggestion_text='Rest.')
        Message.objects.create(mood=self.mood, message_text='Private')
        self.assertEqual(self.client.get('/api/tracking/suggestions/by-mood/?mood=Tough').status_code, 200)
        self.assertEqual(Send_To_Relative.objects.count(), 0)

    def test_circle_acceptance_queues_approved_owner_update(self):
        connection = CircleConnection.objects.create(
            owner=self.sender,
            recipient=self.recipient,
        )
        self.client.force_authenticate(user=self.recipient)
        response = self.client.patch(
            f'/api/tracking/hearteli/circle/{connection.id}/',
            {'accept': True, 'may_receive_nudges': True},
            format='json',
        )
        self.assertEqual(response.status_code, 200)
        push = EmailDelivery.objects.get(
            kind='circle_accepted',
            channel='push',
            recipient=self.sender,
        )
        self.assertEqual(push.subject, 'Your Circle has grown')
        self.assertEqual(push.message, 'Someone has accepted your Circle invitation.')
        self.assertNotIn(self.recipient.name, push.subject + push.message)
        self.assertEqual(
            Notification.objects.get(
                recipient=self.sender,
                verb='Recipient has accepted your Circle invitation.',
            ).verb,
            'Recipient has accepted your Circle invitation.',
        )

    def test_declined_circle_invitation_is_not_notified_to_inviter(self):
        connection = CircleConnection.objects.create(
            owner=self.sender,
            recipient=self.recipient,
        )
        owner_notifications = Notification.objects.filter(
            recipient=self.sender,
        ).count()
        self.client.force_authenticate(user=self.recipient)
        response = self.client.patch(
            f'/api/tracking/hearteli/circle/{connection.id}/',
            {'accept': False},
            format='json',
        )
        self.assertEqual(response.status_code, 200)
        self.assertIsNotNone(response.data['declined_at'])
        self.assertEqual(
            Notification.objects.filter(recipient=self.sender).count(),
            owner_notifications,
        )
        self.client.force_authenticate(user=self.sender)
        connections = self.client.get('/api/tracking/hearteli/circle/').data
        self.assertIsNotNone(connections[0]['declined_at'])
        self.client.force_authenticate(user=self.recipient)
        self.assertEqual(
            self.client.patch(
                f'/api/tracking/hearteli/circle/{connection.id}/',
                {'accept': True},
                format='json',
            ).status_code,
            400,
        )

class HearteliPrivacyBoundaryTests(APITestCase):
    def setUp(self):
        self.member = User.objects.create_user(email='member-boundary@example.com', name='Member Boundary',
                                               password='StrongPass123', phone_number='123')
        self.recipient = User.objects.create_user(email='recipient-boundary@example.com', name='Recipient Boundary',
                                                  password='StrongPass123', phone_number='456')
        self.therapist = User.objects.create_user(email='therapist-boundary@example.com', name='Therapist Boundary',
                                                  password='StrongPass123', phone_number='789', is_therapist=True)
        self.checkin = MoodCheckIn.objects.create(user=self.member, feeling_category='not_great', notes='Private journal')
        self.connection = CircleConnection.objects.create(owner=self.member, recipient=self.recipient,
            accepted_at=__import__('django.utils.timezone', fromlist=['now']).now(), may_receive_nudges=True)
        self.client.force_authenticate(user=self.member)

    def test_revoke_blocks_recipient_access_and_outcome_is_private(self):
        response = self.client.post('/api/tracking/hearteli/nudges/', {
            'recipient': self.recipient.id, 'check_in': self.checkin.id,
            'message': 'A short call could help.', 'idempotency_key': str(uuid.uuid4())}, format='json')
        self.assertEqual(response.status_code, 201)
        id = response.data['id']
        self.assertNotIn('Private journal', str(response.data))
        self.client.force_authenticate(user=self.recipient)
        self.assertEqual(self.client.get(f'/api/tracking/hearteli/nudges/{id}/').status_code, 200)
        self.client.force_authenticate(user=self.member)
        self.assertEqual(self.client.post('/api/tracking/hearteli/outcomes/', {
            'nudge': id, 'result': 'a_little', 'private_note': 'My own reflection'}, format='json').status_code, 201)
        self.client.delete(f'/api/tracking/hearteli/circle/{self.connection.id}/')
        self.client.force_authenticate(user=self.recipient)
        self.assertEqual(self.client.get(f'/api/tracking/hearteli/nudges/{id}/').status_code, 404)
        self.assertEqual(self.client.get('/api/tracking/hearteli/outcomes/').data, [])
        self.assertNotIn('Private journal', str(self.client.get('/api/tracking/hearteli/nudges/').data))

    def test_reserved_nudge_messaging_is_unavailable(self):
        response = self.client.post('/api/tracking/hearteli/nudges/', {
            'recipient': self.recipient.id, 'check_in': self.checkin.id,
            'message': 'Could you check in?', 'idempotency_key': str(uuid.uuid4())}, format='json')
        self.assertEqual(response.status_code, 201)
        path = f"/api/tracking/hearteli/nudges/{response.data['id']}/messages/"
        self.assertEqual(self.client.post(path, {'body': 'Thanks for being here.'}, format='json').status_code, 404)
        self.client.force_authenticate(user=self.recipient)
        self.assertEqual(self.client.get(path).status_code, 404)

    def test_recipient_can_save_each_specified_response(self):
        response = self.client.post('/api/tracking/hearteli/nudges/', {
            'recipient': self.recipient.id, 'check_in': self.checkin.id,
            'message': 'Could you check in?', 'idempotency_key': str(uuid.uuid4())}, format='json')
        self.assertEqual(response.status_code, 201)
        nudge_id = response.data['id']
        self.client.force_authenticate(user=self.recipient)
        path = f'/api/tracking/hearteli/nudges/{nudge_id}/respond/'
        response = self.client.post(path, {'choice': 'will_give_space'}, format='json')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data['recipient_choice'], 'will_give_space')
        self.assertEqual(response.data['status'], 'acknowledged')
        self.assertEqual(self.client.post(path, {'choice': 'cannot_help'}, format='json').status_code, 400)

    def test_therapy_grant_only_selected_context_and_revoke(self):
        other = MoodCheckIn.objects.create(user=self.member, feeling_category='good', notes='Never selected')
        from django.utils import timezone
        response = self.client.post('/api/tracking/hearteli/therapy-context/', {
            'therapist': self.therapist.id, 'check_in_ids': [self.checkin.id],
            'include_notes': False, 'expires_at': (timezone.now() + timezone.timedelta(days=1)).isoformat()}, format='json')
        self.assertEqual(response.status_code, 201)
        grant_id = response.data['id']
        self.client.force_authenticate(user=self.therapist)
        data = self.client.get('/api/tracking/hearteli/therapy-context/').data
        self.assertEqual(len(data), 1)
        self.assertEqual(len(data[0]['selected_context']), 1)
        self.assertNotIn('Private journal', str(data))
        self.assertNotIn('Never selected', str(data))
        self.client.force_authenticate(user=self.member)
        self.assertEqual(self.client.delete(f'/api/tracking/hearteli/therapy-context/{grant_id}/').status_code, 204)
        self.client.force_authenticate(user=self.therapist)
        self.assertEqual(self.client.get('/api/tracking/hearteli/therapy-context/').data, [])

    def test_other_user_cannot_read_or_change_account(self):
        self.client.force_authenticate(user=self.recipient)
        self.assertEqual(self.client.get(f'/api/users/users/{self.member.id}/').status_code, 404)
        self.assertEqual(self.client.patch(f'/api/users/users/{self.member.id}/', {'name': 'Changed'}).status_code, 404)
        self.assertEqual(self.client.get('/api/users/user-history/').data, [])

from django.contrib.auth import get_user_model
from django.core.files.uploadedfile import SimpleUploadedFile
from rest_framework.test import APITestCase
from apps.tracking.models import CircleConnection, Mood, MoodCheckIn, EmpathyNudge, Suggestion, Message
from apps.users.models import Send_To_Relative
import uuid

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

    def test_support_conversation_is_scoped_and_revocable(self):
        response = self.client.post('/api/tracking/hearteli/nudges/', {
            'recipient': self.recipient.id, 'check_in': self.checkin.id,
            'message': 'Could you check in?', 'idempotency_key': str(uuid.uuid4())}, format='json')
        self.assertEqual(response.status_code, 201)
        path = f"/api/tracking/hearteli/nudges/{response.data['id']}/messages/"
        self.assertEqual(self.client.post(path, {'body': 'Thanks for being here.'}, format='json').status_code, 201)
        self.client.force_authenticate(user=self.recipient)
        self.assertEqual(self.client.get(path).status_code, 200)
        self.assertEqual(self.client.post(path, {'body': 'How are you?'}, format='json').status_code, 201)
        self.client.force_authenticate(user=self.therapist)
        self.assertEqual(self.client.get(path).status_code, 404)
        self.client.force_authenticate(user=self.member)
        self.client.delete(f'/api/tracking/hearteli/circle/{self.connection.id}/')
        self.client.force_authenticate(user=self.recipient)
        self.assertEqual(self.client.get(path).status_code, 404)

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

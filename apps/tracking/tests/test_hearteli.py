from django.contrib.auth import get_user_model
from django.core.files.uploadedfile import SimpleUploadedFile
from rest_framework.test import APITestCase
from apps.tracking.models import CircleConnection, Mood, MoodCheckIn, EmpathyNudge, Suggestion, Message
from apps.users.models import Send_To_Relative

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
        payload = {'check_in': self.checkin.id, 'recipient': self.recipient.id, 'message': 'Could you call me?'}
        url = '/api/tracking/hearteli/nudges/'
        self.assertEqual(self.client.post(url, payload).status_code, 400)
        self.client.force_authenticate(user=self.recipient)
        self.assertEqual(self.client.patch(f'/api/tracking/hearteli/circle/{connection.id}/', {'accept': True, 'may_receive_nudges': True}, format='json').status_code, 200)
        self.client.force_authenticate(user=self.sender)
        self.assertEqual(self.client.post(url, payload).status_code, 201)
        self.client.force_authenticate(user=self.other)
        self.assertEqual(self.client.get(url).data, [])
        self.client.force_authenticate(user=self.recipient)
        self.assertNotIn('Private note', str(self.client.get(url).data))
        self.client.patch(f'/api/tracking/hearteli/circle/{connection.id}/', {'may_receive_nudges': False}, format='json')
        self.client.force_authenticate(user=self.sender)
        self.assertEqual(self.client.post(url, payload).status_code, 400)

    def test_suggestion_get_does_not_share_mood(self):
        Suggestion.objects.create(mood=self.mood, suggestion_text='Rest.')
        Message.objects.create(mood=self.mood, message_text='Private')
        self.assertEqual(self.client.get('/api/tracking/suggestions/by-mood/?mood=Tough').status_code, 200)
        self.assertEqual(Send_To_Relative.objects.count(), 0)

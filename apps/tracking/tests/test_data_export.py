from io import BytesIO
import json
from zipfile import ZipFile

from django.contrib.auth import get_user_model
from django.test import TestCase
from rest_framework.test import APIClient

from apps.tracking.models import ConsentEvent, MoodCheckIn


class DataExportTests(TestCase):
    def test_requires_current_password_and_exports_only_the_signed_in_account(self):
        users = get_user_model()
        mine = users.objects.create_user(email='export@example.test', name='Owner', password='Current123!', phone_number='551')
        other = users.objects.create_user(email='other-export@example.test', name='Other', password='Other123!', phone_number='552')
        MoodCheckIn.objects.create(user=mine, notes='My private reflection')
        MoodCheckIn.objects.create(user=other, notes='Someone else private reflection')
        ConsentEvent.objects.create(actor=mine, event='nudge_confirmed', categories=['message'])
        client = APIClient()
        url = '/api/tracking/hearteli/data/export/'
        self.assertIn(client.post(url, {'password': 'Current123!'}, format='json').status_code, [401, 403])
        client.force_authenticate(mine)
        self.assertEqual(client.post(url, {'password': 'wrong'}, format='json').status_code, 403)
        self.assertIn(client.get('/api/tracking/hearteli/data/').status_code, [404, 405])
        response = client.post(url, {'password': 'Current123!', 'user_id': other.pk}, format='json',
                               HTTP_ACCEPT='application/zip, application/json')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response['Content-Type'], 'application/zip')
        self.assertIn('no-store', response['Cache-Control'])
        with ZipFile(BytesIO(response.content)) as bundle:
            manifest = json.loads(bundle.read('manifest.json'))
            self.assertEqual(manifest['schema_version'], 1)
            for filename, count in manifest['record_counts'].items():
                self.assertEqual(len(json.loads(bundle.read(filename))), count)
            self.assertEqual(manifest['record_counts']['consent_events.json'], 1)
            self.assertEqual(manifest['record_counts']['nudges_sent.json'], 0)
            self.assertIn(b'My private reflection', bundle.read('check_ins.json'))
            self.assertNotIn(b'Someone else private', bundle.read('check_ins.json'))
            self.assertNotIn(b'password', bundle.read('account.json'))

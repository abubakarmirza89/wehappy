from datetime import date, time

from django.contrib.auth import get_user_model
from django.test import TestCase
from rest_framework.test import APIClient

from apps.tracking.models import HearteliPreferences
from apps.users.appointment_time import local_appointment
from apps.users.models import Appointment, EmailDelivery


class AppointmentTimeTests(TestCase):
    def setUp(self):
        user = get_user_model()
        self.client_user = user.objects.create_user(
            email='time-client@example.com', name='Time client', phone_number='001',
        )
        self.therapist = user.objects.create_user(
            email='time-provider@example.com', name='Time provider', phone_number='002',
            is_therapist=True,
        )
        self.prefs = HearteliPreferences.objects.create(
            user=self.client_user, timezone_name='Australia/Sydney',
        )
        self.appointment = Appointment.objects.create(
            user=self.client_user, therapist=self.therapist, date=date(2027, 1, 10),
            time=time(22, 30), duration_minutes=45, provider_timezone='Europe/London',
        )

    def test_display_and_calendar_share_one_instant(self):
        api = APIClient()
        api.force_authenticate(self.client_user)
        response = api.get('/api/users/appointment/')
        self.assertEqual(response.status_code, 200)
        value = response.data[0]
        self.assertEqual(value['date'], '2027-01-10')
        self.assertEqual(value['display_time'], {
            'starts_at': '2027-01-10T22:30:00+00:00',
            'local_date': '2027-01-11', 'local_time': '09:30',
            'timezone': 'Australia/Sydney', 'abbreviation': 'AEDT',
            'source_timezone': 'Europe/London',
        })
        delivery = EmailDelivery.objects.get(recipient=self.client_user, kind='appointment')
        self.assertIn('2027-01-11 at 09:30 Australia/Sydney (AEDT)', delivery.message)

        self.client.force_login(self.client_user)
        url = f'/practice/appointments/{self.appointment.pk}/calendar/'
        download = self.client.get(url)
        self.assertContains(download, 'DTSTART:20270110T223000Z')
        self.assertContains(download, 'DTEND:20270110T231500Z')

        self.prefs.timezone_name = 'Asia/Karachi'
        self.prefs.save(update_fields=['timezone_name'])
        self.client_user.refresh_from_db()
        self.assertEqual(local_appointment(self.appointment, self.client_user)['local_time'], '03:30')
        self.assertEqual(self.appointment.time, time(22, 30))

    def test_winter_offset_and_device_fallback(self):
        self.appointment.date = date(2027, 7, 10)
        self.assertEqual(local_appointment(self.appointment, self.client_user)['abbreviation'], 'AEST')
        self.prefs.timezone_name = 'UTC'
        self.prefs.save(update_fields=['timezone_name'])
        self.client_user.refresh_from_db()
        self.assertIsNone(local_appointment(self.appointment, self.client_user)['timezone'])
        api = APIClient()
        api.force_authenticate(self.client_user)
        response = api.patch('/api/tracking/hearteli/preferences/update_mine/',
                             {'timezone_name': 'UTC'}, format='json')
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.data['timezone_selected'])

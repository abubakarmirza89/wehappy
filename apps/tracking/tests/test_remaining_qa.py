from datetime import date, datetime, time, timezone
from unittest.mock import patch

from django.core.cache import cache
from django.db import DatabaseError
from django.test import TestCase, override_settings
from django.urls import reverse
from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient

from apps.tracking.models import HearteliPreferences, Workspace, WorkspaceMembership
from apps.users.models import CommercialAudit, DeviceToken, EmailDelivery, PrivacyPolicy, User
from apps.users.notification_time import notification_zone, reminder_occurrences


class RemainingQATests(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            email='member@example.test', name='Member', password='StrongPass123',
            phone_number='100',
        )
        self.api = APIClient()
        self.token = Token.objects.create(user=self.user)
        self.api.credentials(HTTP_AUTHORIZATION='Token ' + self.token.key)
        self.base = '/api/tracking/hearteli/'
        cache.clear()

    def test_deletion_revokes_account_token_devices_and_unsent_mail(self):
        DeviceToken.objects.create(user=self.user, token='test-deletion-device')
        EmailDelivery.objects.create(recipient=self.user, kind='daily_prompt', event_key='test-delete')
        url = self.base + 'data/delete_account/'
        self.assertEqual(self.api.post(url, {'password': []}, format='json').status_code, 400)
        self.assertEqual(self.api.post(url, {'password': 'wrong'}).data['code'], 'invalid_password')
        response = self.api.post(url, {'password': 'StrongPass123'})
        self.assertEqual(response.status_code, 200)
        self.assertTrue(CommercialAudit.objects.filter(object_id=response.data['reference'], action='completed').exists())
        self.assertFalse(User.objects.filter(pk=self.user.pk).exists())
        self.assertFalse(Token.objects.filter(key=self.token.key).exists())
        self.assertFalse(DeviceToken.objects.filter(token='test-deletion-device').exists())
        self.assertFalse(EmailDelivery.objects.filter(event_key='test-delete').exists())
        self.assertIn(self.api.post(url, {'password': 'StrongPass123'}).status_code, (401, 403))
        self.assertEqual(CommercialAudit.objects.filter(object_type='AccountDeletion').count(), 1)

    def test_delete_rolls_back_if_audit_cannot_be_saved(self):
        with patch('apps.users.models.CommercialAudit.objects.create', side_effect=DatabaseError):
            response = self.api.post(self.base + 'data/delete_account/', {'password': 'StrongPass123'})
        self.assertEqual(response.status_code, 503)
        self.assertEqual(response.data['code'], 'deletion_failed')
        self.assertTrue(User.objects.filter(pk=self.user.pk).exists())
        self.assertTrue(Token.objects.filter(key=self.token.key).exists())

    def test_device_timezone_does_not_override_manual_selection(self):
        url = self.base + 'preferences/'
        self.assertIn('Australia/Sydney', self.api.get(url + 'timezones/').data)
        response = self.api.patch(url + 'device_timezone/', {'timezone_name': 'Australia/Sydney'}, format='json')
        self.assertEqual(response.data['timezone_name'], 'Australia/Sydney')
        self.assertEqual(response.data['timezone_mode'], 'device')
        self.assertEqual(self.api.patch(url + 'update_mine/', {
            'timezone_mode': 'manual', 'timezone_name': 'Asia/Karachi',
        }, format='json').status_code, 200)
        self.api.patch(url + 'device_timezone/', {'timezone_name': 'Europe/London'}, format='json')
        self.assertEqual(self.api.get(url).data['timezone_name'], 'Asia/Karachi')
        self.assertEqual(self.api.patch(url + 'update_mine/', {
            'timezone_mode': 'device', 'timezone_name': 'Invalid/Zone',
        }, format='json').status_code, 400)
        self.assertTrue(HearteliPreferences.objects.get(user=self.user).timezone_selected)

    def test_sydney_reminder_handles_dst_gap_and_overlap(self):
        zone = notification_zone('Australia/Sydney')
        self.assertEqual(reminder_occurrences(date(2026, 10, 4), time(2, 30), zone),
                         {datetime(2026, 10, 3, 16, tzinfo=timezone.utc)})
        self.assertEqual(len(reminder_occurrences(date(2026, 4, 5), time(2, 30), zone)), 2)
        self.assertEqual(notification_zone('invalid').key, 'UTC')

    def test_new_unsubscribed_members_page_through_overview_and_sidebar(self):
        self.client.force_login(self.user)
        self.client.post(reverse('hearteli-work-create'), {'name': 'Fresh team'})
        workspace = Workspace.objects.get(owner=self.user)
        overview_url = reverse('hearteli-work-dashboard', args=[workspace.pk])
        members_url = reverse('business-page', args=[workspace.pk, 'members'])
        overview = self.client.get(overview_url)
        self.assertContains(overview, members_url)
        for _ in range(2):
            page = self.client.get(members_url)
            self.assertContains(page, 'Team members')
            self.assertContains(page, 'Invitations are unavailable until your subscription is active.')
            self.assertContains(page, reverse('business-billing', args=[workspace.pk]))
        self.assertEqual(WorkspaceMembership.objects.filter(workspace=workspace, user=self.user).count(), 1)

    @override_settings(HEARTELI_PLAY_STORE_URL='https://play.google.com/store/apps/details?id=test', HEARTELI_TERMS_URL='https://hearteli.example/terms/')
    def test_home_and_signup_links_use_configured_destinations(self):
        home = self.client.get('/')
        self.assertContains(home, 'Get it on Google Play', count=3)
        self.assertContains(home, '/privacy-policy/')
        self.assertContains(home, 'Bring your care to Hearteli')
        self.assertContains(self.client.get('/work/register/'), 'https://hearteli.example/terms/')

    def test_policy_draft_and_preview_are_private_and_publish_is_sanitized(self):
        policy = PrivacyPolicy.objects.create(draft='## Approved heading\n\n<a href="javascript:alert(1)">Unsafe URL</a>')
        public = reverse('hearteli-privacy-policy')
        preview = reverse('admin:privacy-policy-draft', args=[policy.pk])
        self.assertNotContains(self.client.get(public), 'Approved heading', status_code=503)
        self.client.force_login(self.user)
        self.assertEqual(self.client.get(preview).status_code, 302)
        self.user.is_staff = self.user.is_superuser = True
        self.user.save(update_fields=['is_staff', 'is_superuser'])
        self.client.force_login(self.user)
        self.assertContains(self.client.get(preview), 'Private draft preview')
        self.assertNotContains(self.client.get(preview), 'href="javascript:')
        self.client.post(reverse('admin:users_privacypolicy_changelist'), {
            'action': 'publish_reviewed_policy', '_selected_action': str(policy.pk),
        })
        response = self.client.get(public)
        self.assertContains(response, '<h2>Approved heading</h2>', html=True)
        self.assertNotContains(response, 'href="javascript:')
        PrivacyPolicy.objects.filter(pk=policy.pk).update(draft='Changed but not approved')
        self.assertNotContains(self.client.get(public), 'Changed but not approved')

from unittest.mock import patch

from django.contrib.auth import get_user_model
from django.core.cache import cache
from django.test import TestCase, override_settings
from django.urls import reverse

from apps.users.models import DeviceToken

User = get_user_model()


class NotificationTestWebTests(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            name="Notification Tester",
            email="notification-tester@example.com",
            password="StrongPass123",
            phone_number="123",
        )
        cache.delete(f"notification-test-cooldown:{self.user.pk}")
        self.url = reverse("notification-test")

    def test_requires_an_authenticated_account(self):
        response = self.client.get(self.url)

        self.assertEqual(response.status_code, 302)
        self.assertIn("/practice/login/", response.url)

    def test_reports_when_no_active_device_is_registered(self):
        self.client.force_login(self.user)

        response = self.client.post(self.url, {"confirm": "on"})

        self.assertContains(response, "No active device is registered")

    @override_settings(FIREBASE_CREDENTIALS_PATH="/configured-for-test")
    def test_sends_test_to_only_the_signed_in_users_active_devices(self):
        DeviceToken.objects.create(user=self.user, token="my-device")
        other_user = User.objects.create_user(
            name="Another Tester",
            email="another-tester@example.com",
            password="StrongPass123",
            phone_number="456",
        )
        DeviceToken.objects.create(user=other_user, token="other-device")
        self.client.force_login(self.user)

        with patch(
            "apps.users.firebase.send_push_notification",
            return_value={
                "sent": 1,
                "skipped": 0,
                "configured": True,
                "error_codes": [],
            },
        ) as send_push:
            response = self.client.post(self.url, {"confirm": "on"})

        self.assertContains(response, "Firebase accepted the test notification")
        send_push.assert_called_once_with(
            ["my-device"],
            "Hearteli test notification",
            "Your device is connected to Hearteli notifications.",
        )

    @override_settings(FIREBASE_CREDENTIALS_PATH="/configured-for-test")
    def test_reports_firebase_rejection_reason(self):
        DeviceToken.objects.create(user=self.user, token="my-device")
        self.client.force_login(self.user)

        with patch(
            "apps.users.firebase.send_push_notification",
            return_value={
                "sent": 0,
                "skipped": 1,
                "configured": True,
                "error_codes": ["UnregisteredError"],
            },
        ):
            response = self.client.post(self.url, {"confirm": "on"})

        self.assertContains(response, "UnregisteredError")

    @override_settings(FIREBASE_CREDENTIALS_PATH="")
    def test_reports_missing_firebase_configuration(self):
        DeviceToken.objects.create(user=self.user, token="my-device")
        self.client.force_login(self.user)

        response = self.client.post(self.url, {"confirm": "on"})

        self.assertContains(response, "Push delivery is not configured")

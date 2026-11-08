from unittest.mock import patch

from django.contrib.auth import get_user_model
from django.test import TestCase, override_settings
from django.urls import reverse

from apps.users.models import DeviceToken, EmailDelivery, Notification


User = get_user_model()


@override_settings(FIREBASE_CREDENTIALS_PATH="/configured-for-test")
class AdminPushNotificationTests(TestCase):
    def setUp(self):
        self.admin = User.objects.create_superuser(
            email="push-admin@example.com",
            name="Push Admin",
            password="StrongPass123!",
            phone_number="1",
        )
        self.recipient = User.objects.create_user(
            email="push-recipient@example.com",
            name="Push Recipient",
            password="StrongPass123!",
            phone_number="2",
        )
        DeviceToken.objects.create(
            user=self.recipient,
            token="registered-test-device",
            platform="android",
        )
        self.client.force_login(self.admin)
        self.url = reverse("admin:users_user_changelist")

    def post_action(self, **fields):
        return self.client.post(
            self.url,
            {
                "action": "send_manual_push",
                "index": "0",
                "_selected_action": [str(self.recipient.pk)],
                **fields,
            },
        )

    def test_selected_user_push_is_queued_and_sent_via_firebase_worker(self):
        response = self.post_action(
            push_title="A message from Hearteli",
            push_message="Please take a moment to check in.",
        )
        response = self.client.get(response.url)

        self.assertEqual(response.status_code, 200)
        self.assertTrue(
            EmailDelivery.objects.filter(
                recipient=self.recipient,
                kind="admin_manual",
                channel="push",
            ).exists(),
            list(response.context["messages"]),
        )
        delivery = EmailDelivery.objects.get(
            recipient=self.recipient,
            kind="admin_manual",
            channel="push",
        )
        self.assertEqual(delivery.status, "pending")
        self.assertEqual(
            Notification.objects.filter(
                recipient=self.recipient,
                verb="Please take a moment to check in.",
            ).count(),
            1,
        )

        with patch(
            "apps.users.firebase.send_push_notification",
            return_value={"sent": 1},
        ) as send_push:
            from apps.users.communications import dispatch_email_batch

            dispatch_email_batch(delivery_ids=[delivery.pk])

        send_push.assert_called_once_with(
            ["registered-test-device"],
            "A message from Hearteli",
            "Please take a moment to check in.",
            data={"kind": "admin_manual", "target_id": ""},
        )
        delivery.refresh_from_db()
        self.assertEqual(delivery.status, "sent")

    def test_missing_message_does_not_queue_any_push(self):
        response = self.post_action(
            push_title="A message from Hearteli",
            push_message="   ",
        )

        self.assertEqual(response.status_code, 302)
        self.assertFalse(
            EmailDelivery.objects.filter(
                recipient=self.recipient,
                kind="admin_manual",
                channel="push",
            ).exists()
        )

    def test_user_without_an_active_device_token_is_not_queued(self):
        DeviceToken.objects.filter(user=self.recipient).update(is_active=False)

        response = self.post_action(
            push_title="A message from Hearteli",
            push_message="Please take a moment to check in.",
        )

        self.assertEqual(response.status_code, 302)
        self.assertFalse(
            EmailDelivery.objects.filter(
                recipient=self.recipient,
                kind="admin_manual",
                channel="push",
            ).exists()
        )

from django.contrib.auth import get_user_model
from django.core import mail
from django.test import override_settings
from rest_framework import status
from rest_framework.test import APITestCase
from unittest.mock import patch

from apps.tracking.models import Mood, MoodCheckIn, Relative, Workspace, WorkspaceMembership, GratitudeEntry

User = get_user_model()


class WorkspaceAndNotificationAPITests(APITestCase):
    def setUp(self):
        self.owner = User.objects.create_user(
            name="Owner User",
            email="owner@example.com",
            password="StrongPass123",
            phone_number="+923001234567",
        )
        self.member = User.objects.create_user(
            name="Member User",
            email="member@example.com",
            password="StrongPass123",
            phone_number="+923001234568",
        )

    def test_workspace_can_be_created_by_owner(self):
        self.client.force_authenticate(user=self.owner)

        response = self.client.post(
            "/api/tracking/workspaces/",
            {"name": "Team Wellness", "description": "Office support circle"},
            format="json",
        )

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(Workspace.objects.filter(name="Team Wellness").exists())
        self.assertTrue(
            WorkspaceMembership.objects.filter(
                workspace__name="Team Wellness", user=self.owner, role=WorkspaceMembership.ROLE_OWNER
            ).exists()
        )

    def test_member_can_join_workspace_via_invite_code(self):
        self.client.force_authenticate(user=self.owner)
        workspace = Workspace.objects.create(owner=self.owner, name="Support Circle", description="Test")
        self.client.force_authenticate(user=self.member)

        response = self.client.post(
            "/api/tracking/workspaces/join/",
            {"invite_code": workspace.invite_code},
            format="json",
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(
            WorkspaceMembership.objects.filter(workspace=workspace, user=self.member).exists()
        )

    def test_gratitude_entry_can_be_created(self):
        self.client.force_authenticate(user=self.owner)

        response = self.client.post(
            "/api/tracking/gratitude-entries/",
            {
                "gratitude_1": "Family",
                "gratitude_2": "Good health",
                "gratitude_3": "A calm evening",
            },
            format="json",
        )

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(GratitudeEntry.objects.filter(user=self.owner).exists())

    def test_send_to_relatives_creates_notifications(self):
        self.client.force_authenticate(user=self.owner)
        mood = Mood.objects.create(name="Happy", img_emoji=None, score=80)
        relative = Relative.objects.create(
            user=self.owner,
            name="Partner",
            email="partner@example.com",
            phone_number="+923004445566",
            relation="partner",
            is_app_user=False,
        )
        check_in = MoodCheckIn.objects.create(user=self.owner, notes="Feeling good")
        check_in.moods.add(mood)

        response = self.client.post(
            "/api/tracking/mood-notifications/send_to_relatives/",
            {"mood_check_in_id": check_in.id},
            format="json",
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("notifications", response.data)
        self.assertGreater(len(response.data["notifications"]), 0)

    @override_settings(EMAIL_BACKEND="django.core.mail.backends.locmem.EmailBackend")
    def test_email_notification_endpoint_sends_email(self):
        self.client.force_authenticate(user=self.owner)

        response = self.client.post(
            "/api/tracking/notifications/send-email/",
            {"recipient_email": "partner@example.com", "subject": "Daily check-in", "message": "Please check in tonight."},
            format="json",
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(mail.outbox), 1)
        self.assertIn("partner@example.com", mail.outbox[0].to)

    @patch("apps.tracking.tasks.send_whatsapp_message")
    def test_whatsapp_notification_endpoint_calls_twilio(self, mock_send_whatsapp):
        self.client.force_authenticate(user=self.owner)

        response = self.client.post(
            "/api/tracking/notifications/send-whatsapp/",
            {"to_phone": "+923004445566", "message": "Your loved one needs support."},
            format="json",
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        mock_send_whatsapp.assert_called_once()

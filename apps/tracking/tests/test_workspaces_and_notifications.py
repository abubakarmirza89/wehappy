from django.contrib.auth import get_user_model
from django.core import mail
from django.test import override_settings
from django.utils import timezone
from rest_framework import status
from rest_framework.test import APITestCase
from unittest.mock import patch

from apps.tracking.models import ChatConversation, ChatMessage, Mood, MoodCheckIn, Relative, Workspace, WorkspaceMembership, GratitudeEntry

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

    def test_office_workspace_dashboard_suppresses_personal_moods(self):
        self.client.force_authenticate(user=self.owner)

        workspace = Workspace.objects.create(
            owner=self.owner,
            name="Office Wellness",
            description="Office workspace",
            workspace_type=Workspace.WORKSPACE_TYPE_OFFICE,
        )
        WorkspaceMembership.objects.create(
            workspace=workspace,
            user=self.member,
            role=WorkspaceMembership.ROLE_EMPLOYEE,
            designation="Employee",
            status=WorkspaceMembership.STATUS_APPROVED,
            joined_at=timezone.now(),
        )

        mood = Mood.objects.create(name="Exhausted", img_emoji=None, score=35)
        check_in = MoodCheckIn.objects.create(user=self.member, notes="Heavy workload")
        check_in.moods.add(mood)

        response = self.client.get(f"/api/tracking/workspaces/{workspace.id}/office_dashboard/")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["workspace_type"], Workspace.WORKSPACE_TYPE_OFFICE)
        self.assertEqual(response.data["total_members"], 2)
        self.assertFalse(response.data["aggregate_available"])
        self.assertNotIn("average_mood_score", response.data)
        self.assertNotIn("active_members_7d", response.data)
        self.assertNotIn("environment_breakdown", response.data)

    def test_bulk_invite_adds_existing_users_and_skips_missing_emails(self):
        self.client.force_authenticate(user=self.owner)

        workspace = Workspace.objects.create(
            owner=self.owner,
            name="Office Team",
            description="Bulk invite test",
            workspace_type=Workspace.WORKSPACE_TYPE_OFFICE,
        )
        second_member = User.objects.create_user(
            name="Second Member",
            email="second@example.com",
            password="StrongPass123",
            phone_number="+923001234569",
        )

        response = self.client.post(
            f"/api/tracking/workspaces/{workspace.id}/bulk_invite/",
            {"emails": [self.member.email, second_member.email, "missing@example.com"]},
            format="json",
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["invited_count"], 2)
        self.assertIn("missing@example.com", response.data["skipped_emails"])
        self.assertTrue(
            WorkspaceMembership.objects.filter(
                workspace=workspace,
                user=self.member,
                status=WorkspaceMembership.STATUS_PENDING,
            ).exists()
        )
        self.assertTrue(
            WorkspaceMembership.objects.filter(
                workspace=workspace,
                user=second_member,
                status=WorkspaceMembership.STATUS_PENDING,
            ).exists()
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

    def test_legacy_relative_broadcast_is_disabled(self):
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

        self.assertEqual(response.status_code, status.HTTP_410_GONE)
        self.assertFalse(self.owner.mood_notifications_sent.exists())

    @override_settings(EMAIL_BACKEND="django.core.mail.backends.locmem.EmailBackend")
    def test_generic_email_endpoint_is_disabled(self):
        self.client.force_authenticate(user=self.owner)

        response = self.client.post(
            "/api/tracking/notifications/send-email/",
            {"recipient_email": "partner@example.com", "subject": "Daily check-in", "message": "Please check in tonight."},
            format="json",
        )

        self.assertEqual(response.status_code, status.HTTP_410_GONE)
        self.assertEqual(len(mail.outbox), 0)

    @patch("apps.tracking.tasks.send_whatsapp_message")
    def test_generic_whatsapp_endpoint_is_disabled(self, mock_send_whatsapp):
        self.client.force_authenticate(user=self.owner)

        response = self.client.post(
            "/api/tracking/notifications/send-whatsapp/",
            {"to_phone": "+923004445566", "message": "Your loved one needs support."},
            format="json",
        )

        self.assertEqual(response.status_code, status.HTTP_410_GONE)
        mock_send_whatsapp.assert_not_called()

    def test_patient_and_therapist_can_message_in_same_conversation(self):
        therapist = User.objects.create_user(
            name='Therapist User', email='therapist@example.com', password='StrongPass123',
            phone_number='+923001234599', is_therapist=True, is_active=True,
        )
        conversation = ChatConversation.objects.create(user=self.owner, therapist=therapist)

        self.client.force_authenticate(user=self.owner)
        response = self.client.post(
            f'/api/tracking/chat-conversations/{conversation.id}/send_message/',
            {'message': 'I need support today.'}, format='json'
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(ChatMessage.objects.filter(conversation=conversation, sender='user').exists())

        self.client.force_authenticate(user=therapist)
        response = self.client.post(
            f'/api/tracking/chat-conversations/{conversation.id}/send_message/',
            {'message': 'I am here to help.'}, format='json'
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(ChatMessage.objects.filter(conversation=conversation, sender='therapist').exists())

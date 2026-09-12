from django.contrib.auth import get_user_model
from django.core.files.uploadedfile import SimpleUploadedFile
from rest_framework import status
from rest_framework.test import APITestCase

from apps.tracking.models import Mood, Relative, Suggestion, Message, MoodCheckIn

User = get_user_model()


class MoodAndRelativeAPITests(APITestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            name="Test User",
            email="user@example.com",
            password="StrongPass123",
            phone_number="+923001234567",
        )
        self.client.force_authenticate(user=self.user)

    def test_moods_list_returns_items(self):
        Mood.objects.create(
            name="Happy",
            img_emoji=SimpleUploadedFile("happy.png", b"happy", content_type="image/png"),
            score=80,
        )

        response = self.client.get("/api/tracking/moods/")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreater(len(response.data), 0)

    def test_relative_can_be_created(self):
        payload = {
            "name": "Wife",
            "email": "wife@example.com",
            "phone_number": "+923009998877",
            "relation": "wife",
            "is_app_user": False,
        }

        response = self.client.post("/api/tracking/relatives/", payload, format="json")

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(Relative.objects.filter(email="wife@example.com").exists())

    def test_today_check_in_creates_mood_entry(self):
        mood_1 = Mood.objects.create(
            name="Happy",
            img_emoji=SimpleUploadedFile("happy.png", b"happy", content_type="image/png"),
            score=80,
        )
        mood_2 = Mood.objects.create(
            name="Calm",
            img_emoji=SimpleUploadedFile("calm.png", b"calm", content_type="image/png"),
            score=70,
        )

        response = self.client.post(
            "/api/tracking/mood-check-ins/today_check_in/",
            {"mood_ids": [mood_1.id, mood_2.id], "notes": "Feeling better today"},
            format="json",
        )

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(MoodCheckIn.objects.filter(user=self.user).exists())
        self.assertEqual(response.data["notes"], "Feeling better today")

    def test_suggestion_by_mood_returns_content(self):
        mood = Mood.objects.create(
            name="Sad",
            img_emoji=SimpleUploadedFile("sad.png", b"sad", content_type="image/png"),
            score=35,
        )
        Suggestion.objects.create(mood=mood, suggestion_text="Take a short walk and rest.")
        Message.objects.create(mood=mood, message_text="We are here for you.", is_urgent=False)

        response = self.client.get("/api/tracking/suggestions/by-mood/?mood=Sad")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("suggestion_text", response.data)
        self.assertIn("Take a short walk", response.data["suggestion_text"])

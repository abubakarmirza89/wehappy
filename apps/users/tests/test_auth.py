from django.contrib.auth import get_user_model
from django.contrib.auth.tokens import default_token_generator
from django.core import mail
from django.test import override_settings
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from rest_framework import status
from rest_framework.test import APITestCase

User = get_user_model()


class AuthAPITests(APITestCase):
    def setUp(self):
        self.signup_url = "/api/signup/"
        self.login_url = "/api/login/"
        self.logout_url = "/api/logout/"
        self.user_data = {
            "name": "Ali Khan",
            "email": "ali@example.com",
            "password": "StrongPass123",
            "phone_number": "+923001234567",
            "is_therapist": False,
        }

    def test_signup_creates_user(self):
        response = self.client.post(self.signup_url, self.user_data, format="json")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(User.objects.filter(email=self.user_data["email"]).exists())
        self.assertEqual(response.data["message"], "Signup successful.")

    def test_signup_duplicate_email_is_rejected(self):
        User.objects.create_user(
            name="Existing User",
            email=self.user_data["email"],
            password=self.user_data["password"],
            phone_number=self.user_data["phone_number"],
        )

        response = self.client.post(self.signup_url, self.user_data, format="json")

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn("email", response.data)

    def test_login_with_valid_credentials_returns_token(self):
        User.objects.create_user(
            name=self.user_data["name"],
            email=self.user_data["email"],
            password=self.user_data["password"],
            phone_number=self.user_data["phone_number"],
        )

        response = self.client.post(
            self.login_url,
            {"email": self.user_data["email"], "password": self.user_data["password"]},
            format="json",
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("token", response.data)
        self.assertIn("user_id", response.data)

    def test_login_with_invalid_credentials_is_rejected(self):
        response = self.client.post(
            self.login_url,
            {"email": "notfound@example.com", "password": "wrongpass"},
            format="json",
        )

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
        self.assertIn("error", response.data)

    def test_logout_returns_success_message(self):
        user = User.objects.create_user(
            name=self.user_data["name"],
            email=self.user_data["email"],
            password=self.user_data["password"],
            phone_number=self.user_data["phone_number"],
        )
        self.client.force_authenticate(user=user)

        response = self.client.post(self.logout_url, format="json")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["message"], "Logout successful.")

    @override_settings(EMAIL_BACKEND="django.core.mail.backends.locmem.EmailBackend")
    def test_forgot_password_sends_reset_email(self):
        User.objects.create_user(
            name=self.user_data["name"],
            email=self.user_data["email"],
            password=self.user_data["password"],
            phone_number=self.user_data["phone_number"],
        )

        response = self.client.post(
            "/api/forgot-password/",
            {"email": self.user_data["email"]},
            format="json",
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(mail.outbox), 1)
        self.assertIn("reset", mail.outbox[0].subject.lower())
        self.assertIn(self.user_data["email"], mail.outbox[0].to)

    @override_settings(EMAIL_BACKEND="django.core.mail.backends.locmem.EmailBackend")
    def test_reset_password_with_valid_token_sets_new_password(self):
        user = User.objects.create_user(
            name=self.user_data["name"],
            email=self.user_data["email"],
            password=self.user_data["password"],
            phone_number=self.user_data["phone_number"],
        )
        token = default_token_generator.make_token(user)
        uid = urlsafe_base64_encode(force_bytes(user.pk))

        response = self.client.post(
            "/api/reset-password/",
            {"uid": uid, "token": token, "new_password": "NewStrongPass456"},
            format="json",
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        user.refresh_from_db()
        self.assertTrue(user.check_password("NewStrongPass456"))

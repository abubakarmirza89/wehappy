import requests
from unittest.mock import Mock, patch

from django.core.cache import cache
from django.test import TestCase, override_settings
from django.urls import reverse


@override_settings(
    EMAIL_BACKEND="apps.users.email_backend.EmailitEmailBackend",
    EMAILIT_API_KEY="test_secret",
    EMAIL_TIMEOUT=15,
    EMAIL_TEST_RECIPIENT="check@example.com",
    EMAIL_TEST_COOLDOWN_SECONDS=60,
    DEFAULT_FROM_EMAIL="Hearteli <noreply@example.com>",
)
class EmailTestPageTests(TestCase):
    def setUp(self):
        cache.clear()
        self.url = reverse("email-test")

    def test_page_is_public_and_shows_fixed_recipient_policy(self):
        response = self.client.get(self.url)

        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Visitors cannot enter another recipient address")

    @patch("apps.users.email_backend.requests.post")
    def test_send_uses_configured_recipient_and_shows_provider_acceptance(self, post):
        post.return_value = Mock()

        response = self.client.post(self.url, {"confirm": "on"})

        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Email accepted by the configured provider")
        self.assertEqual(post.call_args.kwargs["json"]["to"], ["check@example.com"])
        self.assertEqual(
            post.call_args.kwargs["json"]["subject"],
            "Hearteli email delivery test",
        )
        self.assertEqual(response.wsgi_request.path, "/test=email")

    @patch("apps.users.email_backend.requests.post")
    def test_provider_auth_error_is_clear_and_does_not_expose_secret(self, post):
        response_from_provider = Mock(status_code=401)
        post.side_effect = requests.HTTPError(response=response_from_provider)

        response = self.client.post(self.url, {"confirm": "on"})

        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Emailit returned HTTP 401")
        self.assertContains(response, "Check EMAILIT_API_KEY")
        self.assertNotContains(response, "test_secret")

    @patch("apps.users.email_backend.requests.post")
    def test_timeout_error_is_clear(self, post):
        post.side_effect = requests.Timeout()

        response = self.client.post(self.url, {"confirm": "on"})

        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "connection to Emailit timed out")

    @patch("apps.users.email_backend.requests.post")
    def test_confirmation_is_required_without_sending(self, post):
        response = self.client.post(self.url, {})

        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "This field is required")
        post.assert_not_called()

    @override_settings(EMAIL_TEST_RECIPIENT="")
    @patch("apps.users.email_backend.requests.post")
    def test_missing_fixed_recipient_is_reported_without_sending(self, post):
        response = self.client.post(self.url, {"confirm": "on"})

        self.assertContains(response, "Set EMAIL_TEST_RECIPIENT on the server")
        post.assert_not_called()

    @patch("apps.users.email_backend.requests.post")
    def test_cooldown_blocks_repeat_submission(self, post):
        post.return_value = Mock()

        first = self.client.post(self.url, {"confirm": "on"})
        second = self.client.post(self.url, {"confirm": "on"})

        self.assertContains(first, "Email accepted by the configured provider")
        self.assertContains(second, "A test email was already requested")
        self.assertEqual(post.call_count, 1)

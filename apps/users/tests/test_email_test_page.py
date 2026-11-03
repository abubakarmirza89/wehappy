import smtplib
from unittest.mock import patch

from django.core import mail
from django.core.cache import cache
from django.test import TestCase, override_settings
from django.urls import reverse


@override_settings(
    EMAIL_BACKEND="django.core.mail.backends.locmem.EmailBackend",
    EMAIL_HOST="smtp.example.com",
    EMAIL_PORT=587,
    EMAIL_USE_TLS=True,
    EMAIL_USE_SSL=False,
    EMAIL_HOST_USER="smtp-user",
    EMAIL_HOST_PASSWORD="smtp-password",
    EMAIL_TEST_RECIPIENT="check@example.com",
    EMAIL_TEST_COOLDOWN_SECONDS=60,
    DEFAULT_FROM_EMAIL="Hearteli <noreply@example.com>",
)
class EmailTestPageTests(TestCase):
    def setUp(self):
        cache.clear()
        mail.outbox.clear()
        self.url = reverse("email-test")

    def test_page_is_public_and_shows_fixed_recipient_policy(self):
        response = self.client.get(self.url)

        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Visitors cannot enter another recipient address")

    def test_both_url_forms_open_the_page(self):
        self.assertEqual(self.client.get("/test=email").status_code, 200)
        self.assertEqual(self.client.get("/test=email/").status_code, 200)

    def test_send_uses_configured_recipient_and_shows_smtp_acceptance(self):
        response = self.client.post(self.url, {"confirm": "on"})

        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "SMTP server accepted the email")
        self.assertEqual(len(mail.outbox), 1)
        self.assertEqual(mail.outbox[0].to, ["check@example.com"])
        self.assertEqual(mail.outbox[0].subject, "Hearteli email delivery test")

    @override_settings(EMAIL_BACKEND="django.core.mail.backends.smtp.EmailBackend")
    @patch(
        "django.core.mail.backends.smtp.EmailBackend.send",
        side_effect=smtplib.SMTPAuthenticationError(535, b"authentication failed"),
    )
    def test_smtp_auth_error_is_clear_and_does_not_expose_password(self, send):
        response = self.client.post(self.url, {"confirm": "on"})

        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "SMTP authentication failed")
        self.assertContains(response, "EMAIL_HOST_USER and EMAIL_HOST_PASSWORD")
        self.assertNotContains(response, "smtp-password")
        send.assert_called_once()

    @override_settings(EMAIL_BACKEND="django.core.mail.backends.smtp.EmailBackend")
    @patch(
        "django.core.mail.backends.smtp.EmailBackend.send",
        side_effect=smtplib.SMTPConnectError(421, b"connection refused"),
    )
    def test_smtp_connection_error_is_clear(self, send):
        response = self.client.post(self.url, {"confirm": "on"})

        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Could not connect to the SMTP server")
        self.assertContains(response, "EMAIL_HOST and EMAIL_PORT")

    def test_confirmation_is_required_without_sending(self):
        response = self.client.post(self.url, {})

        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "This field is required")
        self.assertEqual(mail.outbox, [])

    @override_settings(EMAIL_TEST_RECIPIENT="")
    def test_missing_fixed_recipient_is_reported_without_sending(self):
        response = self.client.post(self.url, {"confirm": "on"})

        self.assertContains(response, "Set EMAIL_TEST_RECIPIENT on the server")
        self.assertEqual(mail.outbox, [])

    def test_cooldown_blocks_repeat_submission(self):
        first = self.client.post(self.url, {"confirm": "on"})
        second = self.client.post(self.url, {"confirm": "on"})

        self.assertContains(first, "SMTP server accepted the email")
        self.assertContains(second, "A test email was already requested")
        self.assertEqual(len(mail.outbox), 1)

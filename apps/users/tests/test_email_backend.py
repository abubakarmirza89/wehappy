import base64
import hashlib
from unittest.mock import Mock, patch

from django.core.exceptions import ImproperlyConfigured
from django.core.mail import EmailMultiAlternatives
from django.test import SimpleTestCase, override_settings

from apps.users.email_backend import EmailitEmailBackend


@override_settings(
    EMAILIT_API_KEY="secret_test_key",
    EMAIL_TIMEOUT=15,
    DEFAULT_FROM_EMAIL="Hearteli <noreply@example.com>",
)
class EmailitEmailBackendTests(SimpleTestCase):
    @patch("apps.users.email_backend.requests.post")
    def test_sends_plain_html_and_attachment_through_api(self, post):
        response = Mock()
        post.return_value = response
        message = EmailMultiAlternatives(
            "Welcome",
            "Welcome to Hearteli",
            to=["member@example.com"],
            cc=["copy@example.com"],
            reply_to=["support@example.com"],
            headers={"Message-ID": "<welcome@example.com>"},
        )
        message.attach_alternative("<p>Welcome to Hearteli</p>", "text/html")
        message.attach("welcome.pdf", b"pdf contents", "application/pdf")

        self.assertEqual(EmailitEmailBackend().send_messages([message]), 1)

        post.assert_called_once()
        args, kwargs = post.call_args
        self.assertEqual(args, ("https://api.emailit.com/v2/emails",))
        self.assertEqual(kwargs["headers"]["Authorization"], "Bearer secret_test_key")
        self.assertEqual(
            kwargs["headers"]["Idempotency-Key"],
            hashlib.sha256(b"<welcome@example.com>").hexdigest(),
        )
        self.assertEqual(kwargs["timeout"], 15)
        self.assertEqual(
            kwargs["json"],
            {
                "from": "Hearteli <noreply@example.com>",
                "to": ["member@example.com"],
                "cc": ["copy@example.com"],
                "reply_to": ["support@example.com"],
                "subject": "Welcome",
                "text": "Welcome to Hearteli",
                "html": "<p>Welcome to Hearteli</p>",
                "headers": {"Message-ID": "<welcome@example.com>"},
                "attachments": [
                    {
                        "filename": "welcome.pdf",
                        "content": base64.b64encode(b"pdf contents").decode("ascii"),
                        "content_type": "application/pdf",
                    }
                ],
            },
        )
        response.raise_for_status.assert_called_once_with()

    @override_settings(EMAILIT_API_KEY="")
    def test_missing_api_key_is_reported(self):
        message = EmailMultiAlternatives("Subject", "Body", to=["member@example.com"])
        with self.assertRaisesMessage(ImproperlyConfigured, "EMAILIT_API_KEY"):
            EmailitEmailBackend().send_messages([message])

    @patch("apps.users.email_backend.requests.post")
    def test_provider_errors_are_propagated(self, post):
        import requests

        post.side_effect = requests.Timeout("Emailit timed out")
        message = EmailMultiAlternatives("Subject", "Body", to=["member@example.com"])
        with self.assertRaises(requests.Timeout):
            EmailitEmailBackend().send_messages([message])

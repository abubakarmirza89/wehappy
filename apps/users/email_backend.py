import base64
import hashlib
import logging

import requests
from django.conf import settings
from django.core.exceptions import ImproperlyConfigured
from django.core.mail.backends.base import BaseEmailBackend

logger = logging.getLogger(__name__)


class EmailitEmailBackend(BaseEmailBackend):
    """Deliver Django email messages through Emailit's transactional API."""

    api_url = "https://api.emailit.com/v2/emails"

    def send_messages(self, email_messages):
        if not email_messages:
            return 0
        if not settings.EMAILIT_API_KEY:
            raise ImproperlyConfigured("EMAILIT_API_KEY must be configured to send email.")

        sent = 0
        headers = {
            "Authorization": f"Bearer {settings.EMAILIT_API_KEY}",
            "Content-Type": "application/json",
        }
        for email_message in email_messages:
            request_headers = headers.copy()
            message_id = (email_message.extra_headers or {}).get("Message-ID")
            if message_id:
                request_headers["Idempotency-Key"] = hashlib.sha256(
                    message_id.encode("utf-8")
                ).hexdigest()
            try:
                response = requests.post(
                    self.api_url,
                    json=self._payload(email_message),
                    headers=request_headers,
                    timeout=settings.EMAIL_TIMEOUT,
                )
                response.raise_for_status()
            except requests.RequestException as exc:
                if not self.fail_silently:
                    raise
                logger.warning("Emailit email submission failed (%s).", type(exc).__name__)
            else:
                sent += 1
        return sent

    @staticmethod
    def _payload(email_message):
        payload = {
            "from": email_message.from_email,
            "to": email_message.to,
            "subject": email_message.subject,
        }

        if email_message.cc:
            payload["cc"] = email_message.cc
        if email_message.bcc:
            payload["bcc"] = email_message.bcc
        if email_message.reply_to:
            payload["reply_to"] = email_message.reply_to

        alternatives = email_message.alternatives or []
        html_body = next(
            (content for content, mimetype in alternatives if mimetype.lower() == "text/html"),
            None,
        )
        if email_message.content_subtype == "html":
            payload["html"] = email_message.body
        elif html_body is not None:
            payload["text"] = email_message.body
            payload["html"] = html_body
        else:
            payload["text"] = email_message.body

        if email_message.extra_headers:
            payload["headers"] = email_message.extra_headers

        attachments = [
            EmailitEmailBackend._attachment_payload(attachment)
            for attachment in email_message.attachments
        ]
        if attachments:
            payload["attachments"] = attachments
        return payload

    @staticmethod
    def _attachment_payload(attachment):
        if isinstance(attachment, tuple):
            filename, content, content_type = attachment
            content_type = content_type or "application/octet-stream"
            content_id = None
        else:
            filename = attachment.get_filename()
            if not filename:
                raise ValueError("Email attachments must include a filename.")
            content_type = attachment.get_content_type()
            content = attachment.get_payload(decode=True)
            if content is None:
                body = attachment.get_payload()
                if not isinstance(body, str):
                    raise ValueError(f"Unable to read email attachment {filename!r}.")
                charset = attachment.get_content_charset() or "utf-8"
                content = body.encode(charset)
            content_id = attachment.get("Content-ID")
            if content_id:
                content_id = content_id.strip("<>")

        if isinstance(content, str):
            content = content.encode("utf-8")
        elif not isinstance(content, bytes):
            content = bytes(content)

        result = {
            "filename": filename,
            "content": base64.b64encode(content).decode("ascii"),
            "content_type": content_type,
        }
        if content_id:
            result["content_id"] = content_id
        return result

import hashlib
import logging
import smtplib

from django import forms
from django.conf import settings
from django.contrib import messages
from django.core.cache import cache
from django.core.exceptions import ImproperlyConfigured
from django.core.exceptions import ValidationError as DjangoValidationError
from django.core.mail import EmailMultiAlternatives
from django.template.loader import render_to_string
from django.core.validators import validate_email
from django.shortcuts import render
from django.views.decorators.http import require_http_methods
from .communications import EMAIL_SIGNATURE, email_signature_text

logger = logging.getLogger(__name__)


class EmailTestForm(forms.Form):
    confirm = forms.BooleanField(
        required=True,
        label="I understand this sends a test email to the configured test inbox.",
    )


def _smtp_error(exc):
    if isinstance(exc, ImproperlyConfigured):
        return str(exc)
    if isinstance(exc, smtplib.SMTPAuthenticationError):
        return "SMTP authentication failed. Check EMAIL_HOST_USER and EMAIL_HOST_PASSWORD."
    if isinstance(exc, smtplib.SMTPConnectError):
        return f"Could not connect to the SMTP server (code {exc.smtp_code}). Check EMAIL_HOST and EMAIL_PORT."
    if isinstance(exc, smtplib.SMTPRecipientsRefused):
        return "The SMTP server refused the test recipient. Check the recipient and your provider's sending rules."
    if isinstance(exc, smtplib.SMTPResponseException):
        return f"The SMTP server rejected the message (code {exc.smtp_code}). Check your sender address and SMTP provider settings."
    if isinstance(exc, smtplib.SMTPException):
        return f"SMTP could not send the message ({type(exc).__name__}). Check TLS/SSL and SMTP settings."
    if isinstance(exc, OSError):
        return "Could not reach the SMTP server. Check EMAIL_HOST, EMAIL_PORT, and outbound server connectivity."
    if isinstance(exc, RuntimeError):
        return f"Email was not accepted ({type(exc).__name__}). Check the server logs and SMTP settings."
    return f"Email could not be sent ({type(exc).__name__}). Check the server logs and SMTP settings."


@require_http_methods(["GET", "POST"])
def email_test(request):
    form = EmailTestForm(request.POST if request.method == "POST" else None)
    if request.method == "POST" and form.is_valid():
        recipient = settings.EMAIL_TEST_RECIPIENT
        if not recipient:
            messages.error(
                request,
                "Test email is not configured. Set EMAIL_TEST_RECIPIENT on the server.",
            )
            return render(request, "work/email_test.html", {"form": form})
        try:
            validate_email(recipient)
        except DjangoValidationError:
            messages.error(
                request,
                "EMAIL_TEST_RECIPIENT is not a valid email address. Correct it in the server environment.",
            )
            return render(request, "work/email_test.html", {"form": form})

        client_ip = request.META.get("REMOTE_ADDR", "unknown")
        ip_digest = hashlib.sha256(client_ip.encode("utf-8")).hexdigest()
        cache_key = f"email-test-cooldown:{ip_digest}"
        cooldown = max(1, settings.EMAIL_TEST_COOLDOWN_SECONDS)
        if not cache.add(cache_key, True, timeout=cooldown):
            messages.error(
                request,
                f"A test email was already requested from this connection. Wait "
                f"{cooldown} seconds and try again.",
            )
            return render(request, "work/email_test.html", {"form": form})
        text = (
            "This is a test email from Hearteli.\n\n"
            "This message checks the configured SMTP server."
            f"\n\n{email_signature_text()}"
        )
        html = (
            "<p>This is a test email from <strong>Hearteli</strong>.</p>"
            "<p>This message checks the configured SMTP server.</p>"
            + render_to_string(
                "emails/signature.html",
                {"email_signature": EMAIL_SIGNATURE},
            )
        )
        email = EmailMultiAlternatives(
            subject="Hearteli email delivery test",
            body=text,
            from_email=settings.DEFAULT_FROM_EMAIL,
            to=[recipient],
        )
        email.attach_alternative(html, "text/html")
        try:
            sent = email.send(fail_silently=False)
            if sent != 1:
                raise RuntimeError("The email backend did not accept the message.")
        except (
            ImproperlyConfigured,
            smtplib.SMTPException,
            OSError,
            RuntimeError,
            ValueError,
        ) as exc:
            cache.delete(cache_key)
            logger.warning("Email test submission failed (%s).", type(exc).__name__)
            messages.error(request, _smtp_error(exc))
        else:
            messages.success(
                request,
                "SMTP server accepted the email. Check the configured test inbox and spam folder; "
                "acceptance does not guarantee inbox delivery.",
            )

    return render(request, "work/email_test.html", {"form": form})

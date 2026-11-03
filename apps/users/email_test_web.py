import hashlib
import logging
import smtplib

import requests
from django import forms
from django.conf import settings
from django.contrib import messages
from django.core.cache import cache
from django.core.exceptions import ImproperlyConfigured
from django.core.exceptions import ValidationError as DjangoValidationError
from django.core.mail import EmailMultiAlternatives
from django.core.validators import validate_email
from django.shortcuts import render
from django.views.decorators.http import require_http_methods

logger = logging.getLogger(__name__)


class EmailTestForm(forms.Form):
    confirm = forms.BooleanField(
        required=True,
        label="I understand this sends a test email to the configured test inbox.",
    )


def _provider_error(exc):
    if isinstance(exc, requests.HTTPError):
        response = exc.response
        status_code = response.status_code if response is not None else None
        explanations = {
            400: "Emailit rejected the request. Check the sender address and email settings.",
            401: "Emailit rejected the API key. Check EMAILIT_API_KEY.",
            402: "The Emailit workspace has insufficient credits.",
            403: "Emailit denied this send. Check the verified sender domain and production access.",
            422: "Emailit rejected the sender or message data. Check the verified sender domain.",
            429: "Emailit rate limit reached. Wait briefly, then try again.",
        }
        if status_code is not None and status_code >= 500:
            explanation = "Emailit is temporarily unavailable. Try again later."
        else:
            explanation = explanations.get(
                status_code,
                "Emailit rejected the request. Check the API response in your Emailit dashboard.",
            )
        return f"Emailit returned HTTP {status_code}. {explanation}"
    if isinstance(exc, requests.Timeout):
        return "The connection to Emailit timed out. Check server connectivity and try again."
    if isinstance(exc, requests.ConnectionError):
        return "Could not connect to Emailit. Check the server's outbound HTTPS connection."
    if isinstance(exc, ImproperlyConfigured):
        return str(exc)
    if isinstance(exc, smtplib.SMTPException):
        return f"The configured email backend reported {type(exc).__name__}. Check its settings."
    if isinstance(exc, (OSError, RuntimeError)):
        return f"Email was not accepted ({type(exc).__name__}). Check the server logs and email settings."
    return f"Email could not be submitted ({type(exc).__name__}). Check the server logs and email settings."


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
            "This message checks the configured transactional email service."
        )
        html = (
            "<p>This is a test email from <strong>Hearteli</strong>.</p>"
            "<p>This message checks the configured transactional email service.</p>"
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
            requests.RequestException,
            smtplib.SMTPException,
            OSError,
            RuntimeError,
            ValueError,
        ) as exc:
            logger.warning("Email test submission failed (%s).", type(exc).__name__)
            messages.error(request, _provider_error(exc))
        else:
            messages.success(
                request,
                "Email accepted by the configured provider. Check the configured test inbox "
                "and spam folder; acceptance does not guarantee delivery.",
            )

    return render(request, "work/email_test.html", {"form": form})

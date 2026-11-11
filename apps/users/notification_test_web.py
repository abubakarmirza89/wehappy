import logging

from django import forms
from django.conf import settings
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.core.cache import cache
from django.shortcuts import render
from django.views.decorators.http import require_http_methods

logger = logging.getLogger(__name__)

TEST_COOLDOWN_SECONDS = 60


class NotificationTestForm(forms.Form):
    confirm = forms.BooleanField(
        required=True,
        label="I understand this sends a test notification to my registered devices.",
    )


@login_required(login_url="/practice/login/")
@require_http_methods(["GET", "POST"])
def notification_test(request):
    form = NotificationTestForm(request.POST if request.method == "POST" else None)
    if request.method == "POST" and form.is_valid():
        tokens = list(
            request.user.device_tokens.filter(is_active=True)
            .values_list("token", flat=True)
        )
        if not tokens:
            messages.error(
                request,
                "No active device is registered to this account. Sign in to Hearteli "
                "on your phone and allow notifications, then try again.",
            )
        elif not settings.FIREBASE_CREDENTIALS_PATH:
            messages.error(
                request,
                "Push delivery is not configured on this server. Set "
                "FIREBASE_CREDENTIALS_PATH to the Firebase service-account file.",
            )
        else:
            cache_key = f"notification-test-cooldown:{request.user.pk}"
            if not cache.add(cache_key, True, timeout=TEST_COOLDOWN_SECONDS):
                messages.error(
                    request,
                    f"A test notification was recently sent. Wait "
                    f"{TEST_COOLDOWN_SECONDS} seconds and try again.",
                )
            else:
                try:
                    from .firebase import send_push_notification

                    result = send_push_notification(
                        tokens,
                        "Hearteli test notification",
                        "Your device is connected to Hearteli notifications.",
                    )
                except Exception as exc:
                    cache.delete(cache_key)
                    logger.exception(
                        "Push notification test failed for user %s.",
                        request.user.pk,
                    )
                    messages.error(
                        request,
                        f"Firebase could not send the test notification "
                        f"({type(exc).__name__}). Check the server logs and Firebase "
                        "service-account configuration.",
                    )
                else:
                    sent = result.get("sent", 0)
                    if sent:
                        skipped = result.get("skipped", 0)
                        messages.success(
                            request,
                            f"Firebase accepted the test notification for {sent} "
                            f"device(s). Check your phone; acceptance does not "
                            f"guarantee display. {skipped} device(s) were not accepted.",
                        )
                    else:
                        cache.delete(cache_key)
                        error_codes = result.get("error_codes", [])
                        if not result.get("configured", False):
                            detail = (
                                "The Firebase Admin SDK is unavailable on the server."
                                if "FirebaseAdminUnavailable" in error_codes
                                else "Firebase push is not configured on this server."
                            )
                        elif error_codes:
                            detail = (
                                "Firebase rejected the test for all registered "
                                f"devices ({', '.join(sorted(set(error_codes)))}). "
                                "Check the Firebase project, service-account "
                                "permissions, and device tokens."
                            )
                        else:
                            detail = (
                                "Firebase did not accept the test notification. "
                                "Check the server logs and Firebase configuration."
                            )
                        messages.error(request, detail)

    return render(request, "work/notification_test.html", {"form": form})

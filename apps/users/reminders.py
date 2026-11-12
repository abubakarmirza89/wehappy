from datetime import timedelta
from .appointment_time import appointment_start, appointment_time_text
from zoneinfo import ZoneInfo
from django.utils import timezone
from apps.tracking.models import HearteliPreferences, MoodCheckIn, EmpathyNudge, SupportOutcome
from .models import Appointment, EmailDelivery, Notification
from .communications import queue_email


DAILY_PROMPT_TITLE = 'A little moment for you'
DAILY_PROMPT_MESSAGE = 'How are you feeling today? Take a moment to check in with yourself.'


def queue_due_push_reminders(at=None):
    at = at or timezone.now()
    for pref in HearteliPreferences.objects.filter(
        reminder_enabled=True,
        user__is_active=True,
        user__device_tokens__is_active=True,
    ).select_related('user').distinct().iterator():
        user = pref.user
        local = at.astimezone(ZoneInfo(pref.timezone_name))
        if local.time().replace(second=0, microsecond=0) != pref.reminder_time:
            continue
        if MoodCheckIn.objects.filter(user=user, date=local.date()).exists():
            continue
        event_key = f'daily-prompt:{user.pk}:{local.date().isoformat()}'
        delivery, created = EmailDelivery.objects.get_or_create(
            event_key=event_key,
            defaults={
                'recipient': user,
                'kind': 'daily_prompt',
                'channel': 'push',
                'subject': DAILY_PROMPT_TITLE,
                'message': DAILY_PROMPT_MESSAGE,
                'next_attempt_at': at,
            },
        )
        if created:
            Notification.objects.create(recipient=user, verb=delivery.message)


def queue_due_reminders(at=None):
    at = at or timezone.now()
    # Existing appointment contract uses UTC; never infer a provider's timezone.
    for appointment in Appointment.objects.filter(status='BOOKED', date__range=[at.date(), (at + timedelta(days=1)).date()]).select_related('user', 'therapist'):
        start = appointment_start(appointment)
        if timedelta(0) < start - at <= timedelta(hours=24):
            for user in (appointment.user, appointment.therapist):
                queue_email(user, 'appointment_reminder', 'Your upcoming Hearteli appointment',
                    f'An appointment is scheduled for {appointment_time_text(appointment, user)}. Open Hearteli to review or contact your provider.',
                    key=f'appointment-reminder:{appointment.pk}:{user.pk}:{start.isoformat()}', path='/notifications/', target_id=appointment.pk)

    for nudge in EmpathyNudge.objects.filter(status='acknowledged', responded_at__lte=at-timedelta(hours=24)).select_related('sender'):
        if not SupportOutcome.objects.filter(nudge=nudge).exists():
            queue_email(nudge.sender, 'support_outcome', 'A quiet moment to reflect · Hearteli',
                'Did you feel supported? You can reflect privately in the app, or skip. Your answer is never a score for another person.',
                key=f'outcome-prompt:{nudge.pk}', path=f'/notifications/nudges/{nudge.pk}/', target_id=nudge.pk)

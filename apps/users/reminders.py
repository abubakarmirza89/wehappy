from datetime import datetime, timedelta
from zoneinfo import ZoneInfo
from django.utils import timezone
from apps.tracking.models import HearteliPreferences, MoodCheckIn, EmpathyNudge, SupportOutcome
from .models import Appointment
from .communications import queue_email


def queue_due_reminders(at=None):
    at = at or timezone.now()
    for pref in HearteliPreferences.objects.filter(reminder_enabled=True, user__is_active=True).select_related('user'):
        local = at.astimezone(ZoneInfo(pref.timezone_name))
        if local.time().replace(tzinfo=None) < pref.reminder_time:
            continue
        if MoodCheckIn.objects.filter(user=pref.user, date=local.date()).exists():
            continue
        queue_email(pref.user, 'reminder', 'A moment for you · Hearteli',
            'How are you feeling today? There is room for good days, tough days and everything in between.',
            key=f'reminder:{pref.user_id}:{local.date()}', path='/notifications/')
    # Existing appointment contract uses UTC; never infer a provider's timezone.
    for appointment in Appointment.objects.filter(status='BOOKED', date__range=[at.date(), (at + timedelta(days=1)).date()]).select_related('user', 'therapist'):
        start = datetime.combine(appointment.date, appointment.time, tzinfo=ZoneInfo('UTC'))
        if timedelta(0) < start - at <= timedelta(hours=24):
            for user in (appointment.user, appointment.therapist):
                queue_email(user, 'appointment_reminder', 'Your upcoming Hearteli appointment',
                    f'An appointment is scheduled for {appointment.date} at {appointment.time} UTC. Open Hearteli to review or contact your provider.',
                    key=f'appointment-reminder:{appointment.pk}:{user.pk}:{start.isoformat()}', path='/notifications/', target_id=appointment.pk)

    for nudge in EmpathyNudge.objects.filter(status='acknowledged', responded_at__lte=at-timedelta(hours=24)).select_related('sender'):
        if not SupportOutcome.objects.filter(nudge=nudge).exists():
            queue_email(nudge.sender, 'support_outcome', 'A quiet moment to reflect · Hearteli',
                'Did you feel supported? You can reflect privately in the app, or skip. Your answer is never a score for another person.',
                key=f'outcome-prompt:{nudge.pk}', path=f'/notifications/nudges/{nudge.pk}/', target_id=nudge.pk)

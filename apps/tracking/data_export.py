"""Account-scoped, versioned archive generated in memory and never retained."""
from io import BytesIO
import json
from zipfile import ZIP_DEFLATED, ZipFile

from django.core.serializers.json import DjangoJSONEncoder
from django.db import connection, transaction
from django.utils import timezone
from rest_framework.exceptions import APIException
from rest_framework.throttling import UserRateThrottle

from apps.users.models import Appointment
from .models import ConsentEvent, EmpathyNudge, HearteliPreferences, MoodCheckIn, SupportOutcome


class ExportThrottle(UserRateThrottle):
    scope = "personal_export"
    rate = "5/min"


class ExportTooLarge(APIException):
    status_code = 413
    default_detail = 'This export is too large for an in-app download. Contact Hearteli support.'


def build_export(user):
    archive = BytesIO()
    counts = {}
    encoder = DjangoJSONEncoder(ensure_ascii=False)
    remaining = 32 * 1024 * 1024
    outermost = not connection.in_atomic_block
    if outermost and connection.vendor == 'mysql':
        with connection.cursor() as cursor:
            cursor.execute('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ')
    with transaction.atomic():
        if outermost and connection.vendor == 'postgresql':
            with connection.cursor() as cursor:
                cursor.execute('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ')
        snapshot = timezone.now()
        records = {
            'account.json': user.__class__.objects.filter(pk=user.pk).values(
                'id', 'name', 'email', 'phone_number', 'date_of_birth', 'date_joined'),
            'check_ins.json': MoodCheckIn.objects.filter(user=user).values(
                'id', 'date', 'timestamp', 'feeling_category', 'notes', 'context_tags', 'support_preferences'),
            'nudges_sent.json': EmpathyNudge.objects.filter(sender=user).values(
                'id', 'recipient_id', 'message', 'support_preference', 'status', 'delivery_status', 'created_at'),
            'outcomes.json': SupportOutcome.objects.filter(member=user).values(
                'nudge_id', 'result', 'private_note', 'created_at'),
            'consent_events.json': ConsentEvent.objects.filter(actor=user).values(
                'id', 'connection_id', 'event', 'categories', 'occurred_at'),
            'preferences.json': HearteliPreferences.objects.filter(user=user).values(
                'use_contexts', 'reminder_enabled', 'nudge_notifications', 'email_notifications',
                'quiet_start', 'quiet_end', 'timezone_name', 'reminder_time', 'sponsor_opt_in', 'directory_market'),
            'appointments.json': Appointment.objects.filter(user=user).values(
                'id', 'therapist_id', 'date', 'time', 'status', 'duration_minutes', 'location', 'reason', 'fee', 'billing_currency', 'created_at'),
        }
        with ZipFile(archive, 'w', ZIP_DEFLATED) as bundle:
            for filename, rows in records.items():
                count = 0
                with bundle.open(filename, 'w') as entry:
                    entry.write(b'[')
                    for row in rows.order_by('pk').iterator(chunk_size=500):
                        data = encoder.encode(row).encode('utf-8')
                        remaining -= len(data) + 1
                        if remaining < 0:
                            raise ExportTooLarge()
                        if count:
                            entry.write(b',')
                        entry.write(data)
                        count += 1
                    entry.write(b']')
                counts[filename] = count
            bundle.writestr('README.txt',
                'Hearteli personal export, schema 1. UTF-8 JSON arrays.\n'
                'Keep this ZIP secure: it is not encrypted.\n'
                'Appointment date and time are UTC. Check-in dates are calendar dates.\n'
                'Consent event action and categories are exported as recorded; historical document version and source are not stored.\n'
                'Only currently retained records are included. Deleted records are not reconstructed.\n')
            bundle.writestr('manifest.json', json.dumps({
                'schema_version': 1, 'generated_at': snapshot.isoformat(), 'record_counts': counts,
            }))
    return archive.getvalue()

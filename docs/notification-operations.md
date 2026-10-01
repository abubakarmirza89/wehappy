# Hearteli account and notification operations

The email and push outbox is stored in `users.EmailDelivery`; each channel has its own status and idempotent event key. In-app notifications remain available when external notification channels are disabled.

## Setup

1. Apply all migrations with `python manage.py migrate`.
2. Set `HEARTELI_PUBLIC_URL` to the verified public HTTPS origin. Password reset links use this trusted setting, never the incoming Host header.
3. Configure a verified `DEFAULT_FROM_EMAIL`, SMTP host/port, username/password and TLS. Use the console or locmem backend only for development. Configure sender-domain SPF/DKIM/DMARC with the selected provider.
4. Run Celery worker plus beat: `celery -A config worker -l INFO` and `celery -A config beat -l INFO`. The beat queues opted-in reminders and processes due delivery rows every minute. As an alternative, schedule `python manage.py process_hearteli_notifications` every minute. Choose one scheduler.
5. For push, configure Firebase Admin credentials and native Flutter Firebase application configuration. Users explicitly enable device notifications in Settings; already-authorised devices re-register on app open. No permission request occurs during splash/onboarding.
6. Verify one real SMTP delivery, reset link and Android/iOS push with a test account before release. Do not send test messages to real contacts without their instruction.

## Events

| Event | Email | Push / in-app | Sensitive content |
|---|---|---|---|
| Account created | Welcome | In-app | No private check-in data |
| Forgot password | Expiring one-use reset link | Email only | Token cleared from the sent row |
| Password changed | Security notice | Email only | No password; API/device tokens revoked |
| Circle invitation | Invitation | Yes | No emotional data |
| Confirmed nudge | Generic sign-in link | Yes | Message, mood and private note excluded |
| Acknowledgement / cannot help | Bounded update | Yes | No recipient commentary |
| Support conversation message | Generic sign-in link | Yes | Chat text excluded |
| Private check-in | None | None | Never automatically broadcasts |
| Daily reminder | Opt-in, scheduled in selected timezone | Yes | No mood value |
| Support outcome prompt | Optional after 24h acknowledgement | Yes | Member-only reflection |
| Workspace membership / role | Status and privacy reminder | Yes | No personal mood or notes |
| Appointment create/update/cancel | Status update | Yes | No reason or context notes |
| Appointment reminder | Within 24h of appointment | Yes | Date/time UTC; no private reason |
| Permanent email nudge failure | Sender notice | Yes | No recipient content |

Optional email notifications respect email opt-out, nudge preferences and quiet hours, including intervals crossing midnight. Welcome/password security emails bypass quiet hours. Quiet hours use an explicit IANA timezone. Reminders use one event key per member/date and stale reminders are suppressed. Consent and relationship existence are rechecked before delivery; opening a nudge always rechecks authorisation.

## Meaning of status

`pending`/`retry` means awaiting processing; `sent` means SMTP or FCM accepted the submission. It does **not** mean inbox/device delivery or that a human saw it. A recipient opening the authenticated nudge sets `opened`. An acknowledgement remains separate from actual support outcome. Provider bounce/delivery webhooks are not integrated yet.

Failures retry up to five times with backoff. No credentials, provider error text, chat body or private journal content is logged to the outbox. A stable Message-ID helps email deduplication. SMTP cannot guarantee exactly-once delivery if a worker dies after server acceptance and before committing the local status. Run a transactional production database; SQLite does not provide the same row locking guarantees.

Inspect delivery metadata in Django admin. The admin view does not expose reset-link tokens or email bodies. Restrict admin access and adopt an operational retention policy for sent rows. Configure monitoring for failed and persistently unconfigured push rows.

## Current limits

Live SMTP and FCM delivery have not been verified: no production provider credentials or native Firebase project files were supplied. The `rich_lock_preview` preference currently remains conservative: notifications keep minimal text even if enabled. Appointment times are stored as UTC; Flutter converts newly requested local times to UTC, and appointment lists/reschedule controls label UTC explicitly. Provider-specific calendars, duration-based overlap checking and payment/refund automation remain separate integrations.

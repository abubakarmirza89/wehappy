# Hearteli account and notification operations

The email and push outbox is stored in `users.EmailDelivery`; each channel has its own status and idempotent event key. In-app notifications remain available when external notification channels are disabled.

## Setup

1. Apply all migrations with `python manage.py migrate`.
2. Set `HEARTELI_PUBLIC_URL` to the verified public HTTPS origin. Password reset links use this trusted setting, never the incoming Host header.
3. Configure `EMAILIT_API_KEY` with an Emailit API key and set `DEFAULT_FROM_EMAIL` to an address on a verified Emailit sending domain. Configure the domain's sender DNS records in Emailit. Keep the key in deployment secrets or the ignored local `.env`, never in source control. Set `DJANGO_EMAIL_BACKEND=django.core.mail.backends.console.EmailBackend` only when intentionally using the console backend for local development.
4. Run Celery worker plus beat: `celery -A config worker -l INFO` and `celery -A config beat -l INFO`. The beat queues opted-in reminders and processes due delivery rows every minute. As an alternative, schedule `python manage.py process_hearteli_notifications` every minute. Choose one scheduler.
5. For Android push, register the app in Firebase using application ID `com.hearteli.app` and keep the resulting `google-services.json` in `mobile/android/app/`. Enable Firebase Cloud Messaging HTTP v1. Put a Firebase service-account JSON on the backend host as a secret file and set `FIREBASE_CREDENTIALS_PATH` to its path; never use `google-services.json` as server credentials or commit/share a service-account key. Android requests notification permission after sign-in and registers the device token after permission is granted.
6. Verify one real Emailit delivery, reset link and Android/iOS push with a test account before release. Emailit sandbox workspaces can send only to workspace members until production access is approved. Do not send test messages to real contacts without their instruction.

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
| Daily email reminder | Opt-in, scheduled in selected timezone | Yes | No mood value |
| Daily push prompts | Three randomly scheduled pushes between 08:00 and 22:00 in the user's selected timezone, for active users with an authorised device token; slots are at least four hours apart and continue after check-in | Yes | Generic prompt only |
| Support outcome prompt | Optional after 24h acknowledgement | Yes | Member-only reflection |
| Workspace membership / role | Status and privacy reminder | Yes | No personal mood or notes |
| Appointment create/update/cancel | Status update | Yes | No reason or context notes |
| Appointment reminder | Within 24h of appointment | Yes | Date/time UTC; no private reason |
| Permanent email nudge failure | Sender notice | Yes | No recipient content |

Optional email notifications respect email opt-out, nudge preferences and quiet hours, including intervals crossing midnight. Welcome/password security emails bypass quiet hours. Quiet hours use an explicit IANA timezone. The three daily push prompts are randomized inside 08:00–22:00 in that timezone and intentionally do not follow the in-app reminder toggle or quiet hours; recipients can disable Hearteli notifications in Android system settings. Their randomized slots are idempotent per user/day/slot, stale prompts are suppressed, and dispatch also enforces a four-hour minimum gap. Consent and relationship existence are rechecked before delivery; opening a nudge always rechecks authorisation.

## Meaning of status

`pending`/`retry` means awaiting processing; `sent` means Emailit or FCM accepted the submission. It does **not** mean inbox/device delivery or that a human saw it. A recipient opening the authenticated nudge sets `opened`. An acknowledgement remains separate from actual support outcome. Provider bounce/delivery webhooks are not integrated yet.

Failures retry up to five times with backoff. No credentials, provider error text, chat body or private journal content is logged to the outbox. The Emailit backend derives its `Idempotency-Key` from the stable Message-ID so retries within Emailit's 24-hour idempotency window do not create duplicate sends. Run a transactional production database; SQLite does not provide the same row locking guarantees.

Inspect delivery metadata in Django admin. The admin view does not expose reset-link tokens or email bodies. Restrict admin access and adopt an operational retention policy for sent rows. Configure monitoring for failed and persistently unconfigured push rows.

## Current limits

Live Emailit and FCM delivery have not been verified against production credentials. Android notification delivery when the app is backgrounded or terminated requires the backend Celery worker and beat (or the management-command scheduler) to remain available; Android force-stop, revoked OS permission, network delays, and device power-management restrictions can prevent timely display. iOS also requires its Firebase plist, APNs credentials and entitlements. The `rich_lock_preview` preference currently remains conservative: notifications keep minimal text even if enabled. Appointment times are stored as UTC; Flutter converts newly requested local times to UTC, and appointment lists/reschedule controls label UTC explicitly. Provider-specific calendars, duration-based overlap checking and payment/refund automation remain separate integrations.

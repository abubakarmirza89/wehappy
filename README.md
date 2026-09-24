# Hearteli

Hearteli is a private check-in and consent based support app. This branch combines the Django API, public landing page, owner/manager workplace console, and Flutter mobile client. The visual system uses the supplied brand assets, Nunito, coral `#F2645A`, navy `#1E2233`, soft pink, and soft blue.

## Local backend

Use Python 3.11 or later and install `requirements.txt` in a virtual environment. Configure `.env` with a unique `DJANGO_SECRET_KEY`, `DJANGO_ADMIN_URL=admin/`, `DJANGO_DEBUG=True`, and `DB_ENGINE=sqlite` for local development. The existing Stripe settings also require test keys (`STRIPE_PUBLIC_KEY`, `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`). Run `python manage.py migrate` then `python manage.py runserver`. The API is at `/api/`, the workplace console at `/work/`, and API schema at `/api/docs/`.

For an existing database created before migrations were tracked, back up the database, compare the schema, and baseline only matching initial tables using Django's `migrate --fake-initial` before applying tracking 0003–0005. Do not fake the later migrations. New databases use ordinary `migrate`.

## Mobile

Install a compatible Flutter SDK, run `flutter pub get` in `mobile/`, then launch with `flutter run --dart-define=API_BASE_URL=https://your-api.example`. The default API URL points to the Android emulator's local backend and is for development. Configure Android and iOS application identifiers, Firebase projects, notification credentials, signing identities, and store metadata for the target organization before a release. The supplied brand assets and Nunito font are included in `mobile/assets/`.

## Privacy and behavior

Check-ins and notes stay private. A Circle invitation requires acceptance; the recipient can pause nudges. Each nudge requires a reviewed message, explicit recipient, a completed check-in, and a unique retry key. The recipient sees only the bounded nudge payload while consent remains active. Nudge conversations are limited to the two participants and recipient access ends when Circle permission is revoked. Therapist context is a separate selected, expiring, revocable grant. Workplace dashboards show membership and resources but do not expose personal mood information. Small cohorts do not receive aggregate mood data. The legacy relative broadcast and generic email/WhatsApp sending routes return 410.

## Verification and release gates

Run `python manage.py check` and `python manage.py test apps.tracking.tests.test_hearteli apps.tracking.tests.test_mood_and_relatives apps.tracking.tests.test_workspaces_and_notifications apps.tracking.tests.test_work_web apps.users.tests.test_auth`. The prior branch revision passed 30 backend tests. Re-run the suite and apply migration 0005 in the deployment environment; this revision could not run Django dependencies in the current workspace because the package proxy was unavailable.

Before production: run Flutter dependency resolution, analyzer, widget/device tests on iOS and Android, inspect each screen at small and large text sizes, replace development app identifiers and configure release signing, configure a production HTTPS API and deployment secrets, validate password reset email delivery, integrate workplace billing or remove the office plan entitlement, configure any push notification service, and exercise real device notification behavior. In-app nudge delivery works when the recipient loads the app; push delivery is not yet configured. Do not describe this branch as a signed, store-ready mobile release until these gates pass.

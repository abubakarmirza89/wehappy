# Hearteli v1 handoff

This branch adds the Hearteli mobile client source, official brand kit assets, and consent-based API endpoints to the existing WeHappy Django service.

## Implemented
- Branded Flutter app with sign in, Home, Circle, private Check-In, Insights, More, share preview and Empathy Nudge compose.
- Circle invitations require an existing account; only the recipient can accept and enable nudges. Either party can revoke access by deleting the connection.
- Nudges require an owned completed check-in, an accepted recipient with nudges enabled, and explicit send from the preview. Private notes are never included in the nudge response.
- Nudge recipient can acknowledge or decline. Old suggestion GET no longer queues relative messages.

## Run
Set `DJANGO_SECRET_KEY` and other settings in `.env`, install `requirements.txt`, then migrate and run Django. From `mobile/`, run `flutter pub get` and `flutter run --dart-define=HEARTELI_API_URL=https://your-domain.example`. Configure Android/iOS identifiers, signing, deployment HTTPS, and real data before release.

## Release blockers / not represented as complete
The source checkout had no `mobile/lib` at all. This is a new client implementation, not a migrated version of existing unpublished screens. The reference documents specify many additional screens and experiences (workplace admin, therapist, crisis, notification delivery, outcomes, detailed onboarding, consent audit/role-change, aggregate analytics). Those are not implemented in this branch. The API records a nudge as `sent` when saved; it does not establish push/email delivery. No automatic notifications are claimed. Signup remains available through existing `/api/signup/`, but the mobile account creation and password reset screens still need implementation. Font files are not part of the supplied brand ZIP; the app specifies Nunito and uses platform fallback until licensed font assets are added. Existing legacy endpoints and their policy need a separate complete privacy review before launch.

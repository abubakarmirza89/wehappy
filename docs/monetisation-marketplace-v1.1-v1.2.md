# Hearteli monetisation and therapist marketplace implementation

Updated 4 November 2026. Implements the supplied monetisation specification and therapist addendum together with the newer decisions in the client message. Those decisions supersede the older flat 10% commission and automated organisation billing implementation. Existing User, Therapist, Appointment, Workspace, Membership, Circle, consent, notification outbox and ledger entities are reused.

## Requirement review

| Requirement | Implementation in this branch | Launch condition / limitation |
| --- | --- | --- |
| Free individual accounts | Personal check-ins, Circles and support are independent of organisation billing. | Existing personal account/consent rules still apply. |
| Configurable consultation duration and fee | Therapist submits session options on mobile/web; admin approves each option. Booking accepts only approved active options. Duration-aware collision checks. | Existing hourly rates are not silently converted into approved offers. Admin must approve real offers. Consultation currency remains the existing USD convention; organisation invoices are AUD. See currency note below. |
| Commission | Defaults 15% platform-acquired / 5% therapist-referred. Admin policy controls rates. New bookings snapshot the rate, duration, fee and acquisition source; first booking source is retained for subsequent bookings with that therapist. Referral code on mobile/web, shareable provider link on web. | Referral code is bearer attribution, not independent proof of a prior off-platform relationship. Define referral eligibility operationally; completed/paid ledger history is preserved. |
| Reviews | One rating and optional written review per completed, paid session with a verified-at-booking snapshot. Pending moderation by default. Reporting controls on mobile/web and admin moderation. | Public display is OFF until both global and practitioner-specific professional policy approval is recorded. Existing bookings without verification provenance cannot automatically produce a new verified review. |
| Professional verification | Independent pending/verified/rejected/expired/suspended credential status, private evidence storage, admin reviewer and expiry. Badge beside name. | Credential checks are performed by authorised staff; no automated registry integration. All pending/expired/suspended providers are excluded from new-client booking/search. |
| Sponsored therapist listings | Independent approved campaign, scheduling/expiry, top sponsored block, labelled before name, identical search filters, no organic duplication. Four-state internal visual preview. | Unverified regulated practitioners are shown only in internal preview, never made bookable through payment. No sponsored results for unknown-age/minor users. |
| Sponsored Empathy Nudges | Optional first-party block below support actions. Approved creative, HTTPS destination, scheduling, caps, priority, expiry, viewport measurement, click deduplication. Mobile/web use the same API. | Default OFF. Requires approved placement policy, explicit ordinary/non-urgent context, known adult sender/recipient, recipient sponsor opt-in, opened nudge and current Circle consent. Uncertain/safety contexts remain unsponsored. No automatic clinical crisis classifier is claimed. |
| Campaign admin/analytics | Campaign CRUD, approval/pause/resume, internal protected asset preview, audit log, impressions/clicks/CTR/booking starts/paid booking attribution, CSV reports. | Destination and redirect/content suitability require human review; the server validates HTTPS and rejects literal private/localhost URLs. No remote URL-fetcher or third-party tracker. |
| Practitioner/employer pilots | Existing Workspace + one manual BusinessSubscription store legal/display identity, type, contact, organisation status, dates, seat plan, feature metadata, invoice/payment/contract details. Hashed expiring revocable invitation tokens, atomic seat checks and duplicate redemption prevention. | Individual therapists require no subscription. Feature flags are recorded entitlement metadata; the initial standard paid feature bundle is enforced as a whole, not an arbitrary per-flag product catalogue. |
| Manual subscriptions | Active/expired/suspended, start/end, renewal/extend/activate/suspend actions, configurable expiry reminder. Request-time entitlement checks; scheduler persists expiry. Expiry removes paid writes, resources and linked campaign visibility. | Admin must explicitly activate/renew the organisation status as well as dates. Historical Stripe fields remain for compatibility but cannot grant manual entitlement. Checkout/portal endpoints return 410; no B2B charge or automatic renewal. |
| Therapist activity | Last login, availability update and confirmation; default 30-day reminder, 45-day search suppression; three availability states; one-click confirmation. Sponsorship cannot bypass inactivity. | Scheduled worker/command required for email reminders. Request-time search suppression does not depend on worker uptime. Existing appointments stay accessible; admin alerted where inactive therapists have upcoming bookings. |
| Organisation reporting | Internal CSV: invitations, redemptions, joined seat usage; business console retains operational administration. | Activation, retention and emotional trends are suppressed entirely. No small-cell activity reports or arbitrary date comparisons are exposed to employers. A reviewed cohort reporting design is a later increment. |
| Advertising networks | No external ad SDK or advertiser login added. | Deferred as requested. |

## Existing functionality retained

Therapist application and admin role approval; personal/practice navigation; appointments; private appointment chat; separate consent-based context sharing; appointment payment verification; ledger and reserved withdrawal workflow; seven business console pages; welcome, password-reset and appointment communication outbox. Professional credential approval is now a separate step from therapist role approval.

## Schema and interfaces

Apply tracking migration `0008` and users migrations `0007` through `0015`, in dependency order using `python manage.py migrate`. The backfill preserves historical settled commission percentages and creates unique referral codes. No bulk professional verification or fee approval is inferred from legacy text.

New models: MarketplacePolicy, SessionOffering, CommercialAudit, OrganisationInvitation, InvitationRedemption, SponsorCampaign, SponsorEventTicket, SponsorBookingAttribution, ReviewReport. Existing models have new independent verification, activity, review, pricing snapshot and manual commercial fields.

| Surface | Path |
| --- | --- |
| Marketplace, filtered sponsor + organic results | `GET /api/users/marketplace/search/`, `/therapy/` |
| Session options and approval submission | `GET/POST /api/users/therapist/offerings/`, `/practice/profile/` |
| Confirm availability | `POST /api/users/therapist/confirm-activity/` |
| Optional nudge sponsor | `GET /api/users/nudges/<id>/sponsor/` |
| Impression/click/booking-start event | `POST /api/users/sponsor-events/` |
| Organisation invitation redemption | `POST /api/users/organisation-invitations/redeem/` |
| Review moderation report | `POST /api/users/reviews/<id>/report/` |
| Internal visual combinations | `/marketplace/preview/` (credential-view permission) |
| Internal aggregate reports | `/commercial/reports/sponsors/?from=YYYY-MM-DD&to=YYYY-MM-DD`, `/commercial/reports/organisations/` |
| Staff management | Existing Django admin: policies, offerings, therapists, manual subscriptions, invitations, campaigns, reviews, audit log |

Reports require the corresponding model view permission. Sponsor reports contain campaign IDs and aggregate counts, not client or therapist names. Date windows use UTC calendar dates, inclusive `from` and inclusive `to` in the UI, with an exclusive next-day boundary internally. Per-event-window CTR can exceed 100% if a click occurs in a different reporting window from its impression; lifetime admin CTR uses lifetime counters.

## Operations

1. Back up production DB and private uploads. Test migrations against a representative staging copy first. Run migrations and collect static assets.
2. Review credentials and set professional status/expiry. Approve real duration/fee options. Configure commission policy and referral eligibility.
3. Create organisation Workspace and manual entitlement, select plan/seat limit, dates, organisation status and invoice state. Generate invitation once; only its hash is retained. Never distribute the legacy raw organisation join code.
4. Configure real HTTPS `HEARTELI_PUBLIC_URL`, SMTP and existing push credentials. Run `python manage.py process_hearteli_notifications` every 5–15 minutes, or use the existing Celery notifications schedule. Monitor outbox failures. Reminders are deduplicated per confirmation/subscription period.
5. Store `private_credentials/` and `private_sponsor_assets/` on durable restricted storage, outside public MEDIA_ROOT and source archives. Back up with appropriate access/encryption policy. Multi-instance deployments need a shared protected storage backend.
6. Review sponsor destination/redirects and creative, then approve the campaign. Enable nudge sponsorship only after written placement policy approval. Support actions do not wait on sponsor loading or event logging.
7. Ticket impression rule: at least 50% visible for one continuous second in a foreground/current screen. Fetches are not impressions. IDs expire after at most ten minutes; ownership, campaign status, caps and eligibility are rechecked server-side. Event replay is idempotent. Viewport measurements are client assertions, not independently certified anti-fraud measurement.
8. Viewer frequency identifiers are HMAC pseudonyms used internally, never exported. They are scrubbed 30 days after campaign end; expired unshown tickets are pruned after one day. Define retention for financial records, evidence, reviews and audit logs before launch.

### Currency and legacy data

The pre-existing consultation payment/ledger implementation is USD (`HEARTELI_CURRENCY=usd`); this change does not silently convert historical money. The new manual organisation invoice records default to AUD, as specified. The therapist mock-up uses A$ illustrative pricing. **Do not relabel a funded USD ledger as AUD or change the setting on a live ledger.** If AUD consultation settlement is required for launch, perform an explicit currency-aware appointment/ledger/withdrawal migration and payment reconciliation first. That is an outstanding financial integration item, not a visual text substitution.

## Validation and remaining effort

Backend regression suite: 96 tests, including commission provenance, credential expiry, review gating, invitation caps/revocation/idempotency, paid resource expiry, consent-safe sponsor eligibility, no fetch impressions, replay deduplication, booking attribution, campaign expiry, activity reminders, report permissions and web rendering. `makemigrations --check` and Django system checks are clean. Changed Dart files pass parser/formatter checks.

Native Flutter dependency resolution/analyser/build and Android/iOS device QA have not run in this environment. The mobile visibility widget introduces `visibility_detector`; run `flutter pub get`, `flutter analyze`, native builds and accessibility/lifecycle tests before release. No real payments, payouts, production emails or live deployment were performed. SQLite regression tests do not certify PostgreSQL concurrent load; production seat/redemption/payment concurrency should be stress-tested on the production database engine. Pixel-perfect parity with every historical app screen is not certified by this backend change.

Estimated remaining engineering effort (planning ranges, excluding external approval/waiting):

| Priority | Work | Estimate |
| --- | --- | --- |
| Initial launch | Flutter dependency/native builds, mobile/browser viewport and accessibility QA, defect fixes | 2–4 developer days |
| Initial launch | Staging migrations, real SMTP/push, payment/refund/payout test-mode reconciliation, PostgreSQL concurrency and monitoring | 2–4 days |
| Initial launch if AUD consultation fees are required | Currency-aware ledger/appointment/withdrawal migration and reconciliation | 2–4 days |
| Launch configuration | Credential review, approved offers, sponsor policy/creative/destination approval, legal review for public ratings | Staff/legal work; no reliable engineering-only estimate |
| Later, after pilots | Reviewed privacy-preserving activation/retention reporting, selective feature catalogue | 3–6 days |
| Later, after revenue validation | Self-service advertiser portal, recurring B2B payments, external ad networks | Separately scoped; intentionally not built |

The efficient pilot path is manual invoice + explicit entitlement, first-party direct sponsorship, conservative review display and no emotional adoption reporting. Avoid enabling deferred billing/ad-network infrastructure before validating demand.

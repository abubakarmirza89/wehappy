# Hearteli implementation audit — 2 October 2026

Reviewed both supplied documents: **Hearteli Product UX Architecture v1.0** and **Hearteli Production Screen Specification v1.0** against the current backend, Flutter code, web templates and tracked assets on `feature/hearteli-v1`.

**Release conclusion: the complete document-defined product is not yet production-ready.** Core support-loop code exists and the backend acceptance suite passes, but a code file or screen name is not proof of a complete screen, every edge state, pixel fidelity or real provider delivery. All Flutter screens still need build/device/accessibility and screenshot comparison QA. Earlier claims of “same to same” would not be substantiated by these checks.

“Code present” means the main flow exists in the source. “Partial” lists a concrete remaining gap. Neither status means release-certified. Many inventory IDs share a screen/step/dialog, as the docs recommend reusable components rather than 43 separate pages.

## Screen-by-screen inventory

| ID | Screen | Status | Evidence / remaining work |
|---|---|---|---|
| ONB-01 | Welcome / Splash | Code present | Welcome with approved logo, Get Started, sign-in; mobile build/visual QA pending. |
| ONB-02 | How Hearteli works | Code present | Four-card explanation; contact permission not required. |
| ONB-03 | Create account / Sign in | Code present | Signup/login, strong password validation, welcome email; forgot/reset app and web flows. |
| ONB-04 | About you / use context | Partial | Use-context setup exists; interrupted setup/profile coverage needs device testing. |
| ONB-05 | Privacy promise | Code present | Private-by-default setup explanation. |
| ONB-06 | Invite first Circle person | Partial | Skippable invitation to an existing member; invitation to someone without an account is not implemented. |
| HOME-01 | Personal home | Partial | Home check-in and quick actions exist; delayed/pending-support states need broader UI coverage. |
| CHK-01 | Feeling | Code present | Five labelled mood choices; private create endpoint. |
| CHK-02 | Optional context | Code present | Optional private note/context tags; secure local draft. |
| CHK-03 | What would help | Code present | Optional support preference choices. |
| CHK-04 | Who can know | Code present | No-one/accepted-recipient selection; pending recipients excluded. |
| CHK-05 | Share preview / confirmation | Code present | Exact manual-message preview; separate private save and idempotent nudge creation. |
| CIR-01 | Circle list | Code present | Owned/incoming relationships; pending/active/paused state. |
| CIR-02 | Add / invite person | Partial | Existing-member invite works; non-member email invite and signup handoff pending. |
| CIR-03 | Relationship permissions | Partial | Support preference, recipient opt-in and ask-first pattern rule; per-relationship quiet hours and complete relationship-edit UI pending. |
| CIR-04 | Invite acceptance | Code present | Recipient accept/decline; email/in-app invitation; no history grant. |
| CIR-05 | Person detail / revoke | Code present | Person detail/removal; API access revoked immediately; UI no longer optimistically claims a failed save succeeded. |
| NUD-01 | Nudge suggestion | Code present | Opt-in two-tough-check-ins/48h ask-first suggestion; no automatic sending. |
| NUD-02 | Compose / edit nudge | Code present | Manual bounded message; private notes never appended. |
| NUD-03 | Recipient preview | Code present | Recipient and exact payload preview; retry key and pending duplicate protection. |
| NUD-04 | Recipient notification / detail | Partial | Email/push/in-app queue and authenticated detail; actual SMTP/device delivery unverified; expired signal policy/deep-link release testing pending. |
| NUD-05 | Suggested action | Partial | Three generic supportive suggestions and suggested-message copy; relationship/context-specific action tailoring and external handoff pending. |
| NUD-06 | Acknowledgement / cannot help | Partial | Acknowledge/cannot-help supported and sender notified; separate give-space intention/timeframe choices pending. |
| SUP-01 | Support conversation handoff | Code present | Authenticated two-party conversation with permission checks and generic new-message notification. |
| SUP-02 | Support outcome prompt | Code present | Private outcome choices; optional 24h acknowledged-nudge reminder; never exposed as a relationship score. |
| INS-01 | Insights overview | Code present | Week/month/year reflection, labelled distribution; no diagnostic/risk score. |
| INS-02 | Check-in history | Code present | Full private history; entry detail, note edit, historical sent-payload view and confirmed delete now added. |
| INS-03 | Support history | Code present | Support inbox/history and acknowledgement/delivery labels; no leaderboard. |
| WRK-01 | Work home / consent status | Partial | Separate labelled workplace screens/resources; full per-workspace support-consent object/UI pending. |
| WRK-02 | Work support contacts | Partial | Resources and manual Circle support available; configured workspace-scoped support-contact directory pending. |
| WRK-03 | Manager recipient view | Partial | Approved manager can read only a deliberately addressed nudge; complete workspace-scoped consent/reconfirmation model pending. |
| WRK-04 | Workspace admin overview | Code present | Business registration/login, workspace creation and owner/manager web overview; no private moods exposed. |
| WRK-05 | Members & roles | Partial | Existing-user invitation, pending approval, role changes and role audit; employee deactivation/suspension and complete support-route configuration pending. |
| WRK-06 | Aggregate insights | Partial | Sensitive aggregates always suppressed; policy-configurable cohort adoption/trends/report export not implemented. |
| THR-01 | Therapist directory | Partial | Name-search directory; full modality/location/available-slot filters and verified-provider workflow pending. |
| THR-02 | Therapist profile | Partial | Provider-supplied credentials/fee/availability displayed; bio/focus areas/verified status and cancellation terms incomplete. |
| THR-03 | Booking | Partial | Booking request, UTC conversion, future-time/conflict checks, reschedule/cancel and notifications; provider calendar/duration/terms/payment integrations pending. |
| THR-04 | Share context | Code present | Select own entries, optional notes off by default, <=30 day expiry and revoke; backend privacy tests pass. |
| SET-01 | Settings | Partial | Account/privacy/notifications/data/safety entry points; complete profile/security/help management and therapist experience require further QA. |
| SET-02 | Privacy & consent | Partial | Circle/therapist grants and revocation; complete workspace-grant/audit-summary UX pending. |
| SET-03 | Notifications & quiet hours | Partial | Email opt-out, nudge opt-in, reminder time/timezone, quiet hours and explicit device permission; richer previews remain conservatively minimal, per-contact quiet rules pending. |
| SET-04 | Data export / delete | Partial | Own-data export and password-confirmed delete; retention/pending-request policy and exhaustive data categories still need completion. |
| SAFE-01 | Immediate support / crisis resources | Partial | Immediate-support screen and offline text exist; maintained server-configurable jurisdiction resources and explicit urgent diversion flow not complete. |

## Features changed in this review

- Durable email/push outbox, stable event keys, independent channel status, five-attempt backoff and metadata-only admin inspection.
- HTML/plain-text welcome email for new consumer/business/admin-created active accounts; account creation is not blocked by SMTP downtime.
- Reset-email request with generic account-existence response, trusted configured origin, one-hour one-use token, password validation, matching-password web form and security email. API/device tokens are revoked on reset; logout deactivates registered device tokens.
- Web forgot-password link/page, branded reset page, authenticated web notification/nudge detail and bounded acknowledgement.
- Circle, nudge, support message, acknowledgement, workplace and appointment email/push events. Notification content excludes private journal and chat text.
- In-app notifications screen and recipient-scoped mark-read endpoint.
- Optional reminder schedule in a selected IANA timezone; quiet hours including midnight; optional email opt-out and nudge preferences. Private check-ins do not produce contact notifications.
- Explicit device-permission control and already-authorised device registration; push taps re-open authenticated nudge detail.
- Opt-in ask-first pattern prompt; no automatic low-mood broadcast; duplicate pending-nudge protection and malformed UUID validation.
- Appointment future/duplicate-time checks, reschedule/cancel, history preservation, UTC conversion/labels and event/reminder emails. Removed the old inconsistent automatic charge/refund path from status updates.
- Private history detail/note editing, exact historic nudge text and explicit delete consequences. Corrected Circle save feedback and invalid reset URL error handling.
- Removed scheduled legacy “brain-health score”/gratitude tasks from the Hearteli beat schedule and disabled the old unchecked relative broadcast task.

## Image and brand inventory

| Asset | Origin | Where used | Status |
|---|---|---|---|
| `together-hero.webp` (960 × 1440) | One AI-generated lifestyle photo of two adult women embracing at sunset | Landing hero and connection section; same image reused | Included and WebP optimised; not an exact reproduction of the supplied photograph |
| `logo.png` | Existing supplied Hearteli brand asset | Landing/workplace web | Included |
| Master logo, symbol, wordmark, tagline; white/ink variations | Existing supplied brand PNG/SVG files | Mobile branding | Included in `mobile/assets/brand`; not newly generated photos |
| App icons (32, 64, 128, 180, 192, 512, 1024) | Existing brand files | Mobile package assets | Included; final native store/icon installation still needs build QA |
| Cream/ink social avatar images | Existing brand files | Available in brand assets | Included |
| Nunito variable font + OFL licence | Existing font files | Web/mobile typography | Included locally |
| Circle/contact/therapist avatar portraits in the reference | No matching supplied portraits identified in tracked assets | Current screens use initials or a real uploaded profile picture | Exact reference portrait set not generated/included |
| Mobile screens / workplace graphs in the reference | UI designs, not raster app assets | Implemented as components and real data | No screenshot-as-background replacement or fabricated team mood score |

Only **one new lifestyle photo** was generated. The second placement is a reuse, not a second generated image. Missing real employee/therapist portraits should use profile uploads; any decorative portrait generation should be explicitly distinguished from real people.

## Document acceptance checks

| Test | Status | What was actually checked |
|---|---|---|
| Q01 Skippable onboarding without contacts permission | Code present / device QA pending | Skippable setup and no forced contacts import |
| Q02 Private check-in creates no recipient event | Backend pass | New communications test explicitly verifies no queued recipient notification |
| Q03 Exact bounded share | Backend pass / visual QA pending | Owned completed check-in, accepted recipient, explicit manual payload |
| Q04 Private note excluded | Backend pass | Recipient API/email/push exclude private journal text |
| Q05 Pending invite excluded | Backend pass | Recipient must accept/enable before sharing |
| Q06 Delivery failure | Backend pass / UI partial | Five failed SMTP submissions create one sender notice; alternate-person UI still needs completion |
| Q07 Cannot help | Backend pass / UI code present | Recipient response and one bounded sender notification |
| Q08 Revoke before open | Backend pass | Recipient API/web access becomes 404; queued notifications suppressed |
| Q09 Work membership gives no personal mood access | Backend pass | Workplace dashboard suppresses private mood data |
| Q10 Specific employee-to-manager share | Partial | Manual Circle nudge possible; explicit workspace-scoped consent object incomplete |
| Q11 Manager change | Partial | Role audit/resets and matching manager relationships paused; complete per-workspace reconfirmation pending |
| Q12 Small cohort suppression | Backend pass | Aggregates suppressed; larger-cohort analytics remains unbuilt |
| Q13 Selected therapist context | Backend pass | Selected own range, no notes by default, expiry and revoke |
| Q14 Urgent-safety diversion | Partial | Safety screen available; maintained jurisdiction service/explicit diversion pending |
| Q15 Offline draft | Code present / device QA pending | Secure device draft; send state awaits API success |
| Q16 Large text / accessibility | Unverified | Labels/reduced-motion code exists; actual scaling, focus, contrast and clipping audit still required |

## Remaining product work, in release order

1. Build/run Flutter on Android/iOS and web; review every reference screen at target dimensions, font scale and keyboard/screen-reader states. No pixel-perfect or all-devices claim is justified yet.
2. Complete workspace-specific `WorkspaceConsent` and support-contact/manager-change flows, deactivation, policy-configurable aggregate adoption/reporting. Never add manager access to individual mood histories.
3. Non-member Circle invitations with secure accept-after-signup handoff; recipient per-relationship quiet rules; richer permission/audit summaries.
4. Contextual nudge actions and acknowledgement intentions/timeframes; accurate provider delivery/bounce receipts, expiration/retraction and alternate-recipient UX. SMTP accepted is not inbox delivered.
5. Therapist provider calendar, verified profiles, filters, duration/availability, cancellation terms and approved payment/refund policy. No real payment automation has been verified.
6. Maintained jurisdiction-specific safety resources with offline fallback and explicit urgent-path diversion.
7. Complete privacy-safe analytics event schema, activation/support KPI calculations, exhaustive data export/retention and admin least-privilege/billing/support workflows. The legacy repo still contains score/AI-related modules outside the new Hearteli path; they require a separate removal/migration decision before release.
8. Configure verified SMTP/sender DNS, production origin, background workers and native Firebase files, then run real test-account delivery checks. Provider credentials and hosting/native configuration were not supplied. Do not paste account passwords into chat.

## Verification

**52 backend tests passed** on this revision. `makemigrations --check --dry-run` also passed with no changes detected. Backend test command covers six named modules (auth, communications, consent, workplace web, workplace/notifications, mood/relatives). Tests use an isolated SQLite test database and locmem email; push acceptance is mocked. The nine changed Dart files passed the standalone Dart formatter/parser. Flutter package analysis and a full Flutter build were not run. Production SMTP, real device push, concurrent MySQL locking, payment providers and Flutter rendering are not validated by those tests.

See `docs/notification-operations.md` for configuration, statuses, retries and operational limits.

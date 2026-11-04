# Therapist practice and business billing

Implemented on `feature/therapist-business-billing`, 4 November 2026.

## Therapist workflow

Web: `/practice/signup/` → account → `/practice/apply/` → administrator review → `/practice/` → profile/availability, appointments/chat, earnings and withdrawal requests. Approved therapists land on their practice after web sign-in. Existing members can apply without creating a duplicate identity.

Mobile: create/sign into a normal account → Settings → Apply as a therapist → submit professional details → pending/rejected/approved state. After approval, sign in again to refresh the role. Approved therapist login and restored sessions open the practice shell with Practice, Sessions, Profile and Settings. The Personal space action retains access to personal check-ins. Session lists include private appointment chat, start/complete/cancel, and client-only payment/reschedule actions.

Clients can also browse `/therapy/`, view `/therapy/<provider-id>/`, book a 60-minute UTC session, pay through hosted Stripe Checkout and use the authenticated appointment conversation. Mobile payments open the same hosted provider checkout. No card information passes through Hearteli forms. New bookings reject unavailable providers, invalid fees, past times and overlapping 60-minute appointments.

Application review never self-assigns therapist privileges. Admin approves credentials and activates a profile. Availability and hourly fee are controlled by the approved therapist. Credentials remain provider-supplied; administrators must actually verify them before approval. No automated credential verification is claimed.

## Earnings and withdrawals

The platform fee is 10%, fixed server-side. A USD 100 verified payment produces USD 10 platform commission and USD 90 therapist net credit. Booking or marking a session completed does not credit money.

A signature-verified payment webhook must match the server-created checkout/payment ID, currency and exact quoted amount. Each appointment can create only one earning ledger entry, independent of repeated webhook event IDs. Full refunds reverse the ledger credit once. Partial refunds and provider disputes still need an approved operational allocation/reconciliation policy; they do not automatically reverse the full credit.

Available balance = net earnings ledger minus pending, approved and paid withdrawal amounts. Therapist rows are locked while reserving withdrawals, preventing the same balance from being requested twice. Rejected requests release their reservation. A refund after a completed payout can make the balance negative; new withdrawals then remain blocked until reconciled. Existing historic `payment_status=paid` rows are not blindly credited: reconcile verified historical receipts before migration/import.

Withdrawals are administrator-reviewed, **not automatic Stripe Connect transfers**. Before marking paid, the administrator records the actual bank/provider payout reference and processor identity/time. Ledger entries cannot be edited/deleted through the ledger admin. No outgoing transfer is initiated by merely creating/approving a request.

## Business workflow

`/work/` selects the workspace. The console has separate Overview, Members & roles, Support resources, Insights & privacy, Workspace settings, and Plans/invoices/billing pages. Owners can invite/approve existing users, change roles, deactivate members, configure resources and edit workspace details. Managers cannot access owner billing or perform owner mutations. Emotional histories remain private.

`BillingPlan` is administrator-configured: name, real Stripe recurring monthly Price ID, amount/currency, and seat limit. Prices were not invented or enabled automatically. Checkout checks that the provider Price matches the configured displayed monthly amount/currency. Existing subscriptions are managed with the Stripe Customer Portal for payment method, invoices, upgrades and cancellation; configure the allowed prices in the Stripe portal as well.

Active/trialing provider state plus an unexpired period are required for paid access. Membership invitations/approval and resource publishing are gated on the server; client UI state cannot grant entitlements. Seat checks include pending memberships, and bulk invitations recheck capacity under a workspace lock. Cancellation, expiry and past-due subscriptions lose paid write access while owners can still review their workspace and open billing. Deactivation and removal remain available. Existing workspaces without a verified subscription now require activation for paid actions; this is an intentional behavior change.

Signed subscription/invoice webhooks retrieve current provider state before changing entitlement, so a late event cannot simply restore an older active state. Browser return URLs alone never activate access. Checkout IDs are reused while open, and provider idempotency keys protect retries.

## Deployment

1. Apply all migrations (`users` 0004–0006 and any earlier unapplied migrations).
2. Configure a verified HTTPS `HEARTELI_PUBLIC_URL`, `STRIPE_SECRET_KEY`, `STRIPE_PUBLIC_KEY`, `STRIPE_WEBHOOK_SECRET` and `HEARTELI_CURRENCY` (USD in current UI).
3. Register the signing endpoint `/api/users/webhook/stripe/`. Subscribe to payment_intent.succeeded, checkout.session.completed, charge.refunded, customer.subscription events, invoice.paid and invoice.payment_failed.
4. Create approved recurring monthly Prices in Stripe and matching active BillingPlan records. Configure the Stripe Customer Portal, invoice details and permitted prices.
5. Run existing email/push workers. Configure native Firebase and verified SMTP independently; no live notifications were sent during this change.
6. Complete a test-mode booking/payment/refund, subscription renewal/cancellation, paid-access failure and a manually reconciled payout with your account before enabling live billing.

## Verification and limits

67 backend tests passed after the overlap validation change. Desktop and 390px mobile browser checks for practice, business overview, members and billing passed without horizontal page overflow. They cover role approval, private chat, fee/ledger idempotency, withdrawal reservation, signature rejection, subscription state, seat gating, existing consent boundaries and account recovery. Dart formatter/parser checks passed for changed files. Actual Flutter dependency analysis/build, iOS/Android device runs and native notification/payment-browser return behavior are not certified by formatting.

Desktop/mobile browser checks use synthetic accounts and local pages. Live Stripe checkout, bank transfers, native app builds, tax handling and payment-provider disputes have not been exercised. No real charges or payouts were made. This branch adds the connected workflows; it does not certify every item from the earlier 43-screen product specification as complete.


## Completed-session ratings and reviews

Clients can submit a 1–5 rating and optional public review after an appointment is marked COMPLETED. The server checks appointment ownership, the matching therapist, completion, and one review per appointment under a row lock; the existing one-to-one appointment constraint also prevents duplicate storage. Mobile and web session screens expose the review form only to the client. Provider profiles show average rating, count and client review text, without publishing client names, email addresses, appointment reasons or private check-in data. Reviews are public to signed-in members and the form warns clients not to include personal health details.

Five targeted review tests passed (eligibility, duplicates, ownership, completion, rating range and public payload privacy). Dart formatting/parser checks passed; native device builds remain unverified.

## Workspace pages and settings navigation

Every sidebar section now uses a separate page template and URL: Overview, Members & roles, Support resources, Insights, Privacy & access, Plans & billing, and Workspace settings. All pages, including billing, retain the same sidebar with one active-page indicator and a section-specific title. Legacy dashboard templates delegate to Overview rather than reintroducing the long all-in-one page.

Settings validates workspace name/description and shows inline errors. Invite-code rotation requires explicit confirmation and does not remove existing memberships. Managers cannot open or submit owner settings. Member/resource mutations redirect back to their respective section; invalid resource/invitation actions show feedback instead of silently returning to Overview. Role selectors preserve the current role.

Seven pages were checked at 1440px desktop and 390px mobile width with no horizontal page overflow. Five added navigation/settings tests cover separate templates, active navigation, settings validation, invitation rotation, owner restrictions and return destinations.

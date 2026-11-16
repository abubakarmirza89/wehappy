# Hearteli QA release notes for maintainers

- Workplace invitations are issued by the workspace owner/admin via Work Settings while the organisation is entitled. The current shared token can be redeemed up to its configured seat/redemption capacity and expires at the earlier of 14 days and the subscription end. Rotation revokes previous active tokens. Users ask their workplace admin for a replacement; there is no in-app employer invite request. Joining does not share private check-ins.
- Before release, apply the migrations in order. New self-service accounts require email verification; existing accounts are not retroactively locked. Verify SMTP delivery and retry processing in staging. Circle email invitations use a seven-day signed link and require explicit acceptance with the matching account; existing legacy links retain their previous pending-connection behavior.
- Assign existing therapists to their real directory markets in admin; unassigned profiles remain visible under All markets. Verify the legacy billing currency before running the fee backfill. Keep estimates separate from settlement. Test Android permission, invitation handoff, device timezone, accessibility, and the system ZIP Save picker on a real device.
- Professional verification (#21): verification alone cannot publish new profiles. An authorised staff reviewer must separately publish an eligible, reviewed profile. Publication and credential downloads are audited; previously verified accounts retain their pre-migration directory eligibility. Credential changes clear publication. The approved jurisdiction/profession rules, evidence requirements and retention, scanned encrypted storage, versioned terms/privacy/commission text, and THR-002–005 templates are still required before enabling the requested applicant evidence and draft workflow. Do not upload new applicant evidence through an unapproved workflow.
- Android reinstall: with backup enabled, sign in on the prior build, uninstall and reinstall the updated build, then launch without clearing app data. It should reach onboarding/sign-in if the old session cannot be restored. Also verify that an ordinary in-place update preserves a readable session and its device-local drafts. The secure preferences and wrapping-key file are excluded from Android backup and device transfer; submitted account data remains on the server.


### Follow-up for UX-001 and therapist applications

- Verify workplace invitation email, nudge replies and account deletion with empty or invalid values, offline mode, and service errors. Check that input stays visible, focus returns to the field, TalkBack announces the error, and rapid taps do not submit twice. Repeat with large text, keyboard and switch access on Android.
- The legacy therapist application is now read-only. New submissions are rejected on mobile API and web, including requests from older builds. Legacy admin records cannot be approved through that queue. Existing therapist credentials, published profiles and appointments are handled separately.
- Keep the structured therapist application ticket open. The release guard does not replace the approved application, evidence, declarations, drafts, retention and notification workflows.

### Workplace web QA (#27–29, #31–35)

- Workplace support links open `/work/support/`. Set `HEARTELI_WORK_SUPPORT_EMAIL` to the approved staffed mailbox and confirm delivery before release.
- Billing checks the saved Stripe checkout when the owner opens billing. A redirect query parameter alone does not confirm payment. This check does not activate a subscription; the checkout reconciliation defect is tracked separately in #30.
- Check desktop and 320px layouts, keyboard navigation, owner and manager views, first-time and returning workplaces, and both password toggles. Test active versus inactive workplace resources with approved members in the app.

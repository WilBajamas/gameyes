# Ambiguities Report
Source: Week 1 item 7 — Auth screen; `.agents/references/onboarding-auth-design-spec.md`
Date: 2026-08-03

## CRITICAL (pipeline blocked — requires human decision before proceeding)

NONE

## RESOLVED DECISIONS

- Item 7 adds the auth route and sends every welcome-completion path to it. Item 8 retains ownership of auth-state guarding and automatic session redirects.
- Item 7 performs no success navigation. The authenticated user may remain on the auth screen until item 8 is implemented.
- While sign-in is active, disable both provider rows, preserve the tapped row's fill and label, and show an adjacent progress indicator. Clear an existing inline error on retry. Treat user cancellation silently. Show other failures inline without replacing the screen.
- Add a reusable global webview surface. Terms and Privacy each open that surface and pass `https://google.com` as the temporary URL.

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: The exact localized wording for generic non-cancellation sign-in failure is not specified. Author concise English and Chinese copy consistent with the existing localization files.

ASSUMPTION: Android touch behavior is the verification target. Hover behavior in the source design convention is descriptive reference material and is not a mobile acceptance requirement.

ASSUMPTION: Both legal links use the same temporary `https://google.com` destination until separate production URLs are supplied.

# Technical Acceptance Criteria
Source: Week 1 item 7 — Auth screen; `.agents/references/onboarding-auth-design-spec.md`; human decisions recorded 2026-08-03
Date: 2026-08-03
BA Agent version: 1.0

## Feature summary

Add the Android social sign-in screen after the two welcome screens, connect its Discord and Google actions to the existing authentication use case, provide bounded loading and inline failure states, and open temporary legal destinations in a reusable in-app webview. Register the auth destination and route all welcome-completion actions to it without implementing session guards or authenticated-success routing.

## Technical acceptance criteria

[W1-7] NAVIGATION: Register an auth destination and route every action that completes or skips the welcome flow to that destination after preserving the existing onboarding-seen behavior.
  Failure case: No welcome-completion path may enter the existing main application destination directly or leave the onboarding-seen value inconsistent.

[W1-7] NAVIGATION: Keep automatic authentication-state redirects, session guarding, and post-authentication navigation out of item 7.
  Failure case: A successful sign-in must not trigger screen-owned navigation; item 8 remains responsible for moving authenticated users into the main application.

[W1-7/AUTH-§1] UI: Render exactly two full-width social provider actions in this order: Discord, then Google. Do not render Apple, Twitch, email/password, account-creation, password-reset, questionnaire, or library-import actions.
  Failure case: No deferred or unsupported provider or authentication path may appear.

[W1-7/AUTH-§2] UI: Render the auth screen as the quiet third onboarding surface: onyx background, no hero artwork or ambient decoration, top-anchored single content column, and spacing and frame treatment consistent with the welcome flow and the dimensions in the auth specification.
  Failure case: The screen must not introduce a hero panel, raw unapproved colour treatment, or an independently styled onboarding frame.

[W1-7/AUTH-§3] UI: Render the centered 88-by-88 dashed `LOGO` placeholder using the specified radius, fill, border, typography, and ink values. Retain the placeholder through beta because no app-mark asset exists.
  Failure case: Do not invent, trace, or substitute an app logo.

[W1-7/AUTH-§4] UI: Render the localized `SIGN IN` headline and the localized one-sentence setup reassurance with the hierarchy, alignment, size, line height, and ink values defined in the specification.
  Failure case: Do not use “Welcome back” or imply that setup questions occur before entry.

[W1-7/AUTH-§5] UI: Render each provider action at full width and 52 logical pixels high with a 10-pixel gap. Apply the primary Royal Indigo treatment only to Discord and the specified raised onyx-step treatment to Google. Do not use the green CTA treatment.
  Failure case: The providers must not receive equal filled emphasis, reverse order, or fall below the specified touch-target size.

[W1-7/AUTH-§5] ASSET: Render the supplied Discord and Google SVG marks unchanged inside 20-by-20 boxes next to the localized `Continue with {Provider}` labels. Preserve each asset's proportions and colours without cropping, recolouring, tracing, or substituting a generic icon.
  Failure case: A missing or unreadable provider asset must not be replaced by an approximated trademark.

[W1-7] CONFIGURATION: Add only the explicitly authorised SVG-rendering dependency and register only `assets/icons/` under the existing Flutter asset configuration. Change no other dependency or asset path.
  Failure case: Any additional dependency or asset-directory change is outside scope.

[W1-7] AUTH: Activating Discord invokes the existing sign-in behavior once with Discord; activating Google invokes it once with Google.
  Failure case: A provider action must not invoke the wrong provider or start duplicate requests.

[W1-7/AUTH-§7] STATE: While a sign-in request is active, disable both provider actions. Keep the tapped row's fill and label visible and add an adjacent progress indicator rather than replacing the row with a spinner-only state.
  Failure case: Further provider taps must not start concurrent or duplicate sign-in requests.

[W1-7] STATE: Clear any existing inline error when a new sign-in attempt starts. Treat a user-cancelled provider flow silently and restore the idle actions without showing an error.
  Failure case: Cancellation must not appear as authentication failure, and stale error copy must not remain during a retry.

[W1-7/AUTH-§7] ERROR UI: Show non-cancellation provider failures inline below the provider actions using the specified error signal and readable error-ink conventions. Keep the rest of the auth screen visible and usable for retry.
  Failure case: Do not replace the screen with a full-page error or apply failure styling before an error occurs.

[W1-7/AUTH-§6] UI: Render the localized scope reassurance directly below the provider actions and keep the localized legal sentence at the bottom of the screen. Style Terms and Privacy as inline links using the link colour.
  Failure case: The reassurance must not be moved into the legal footer, and the legal links must remain distinguishable and operable.

[HUMAN-20260803] WEBVIEW: Provide one reusable application-wide in-app webview surface that accepts a URL. Activating either Terms or Privacy opens that surface and passes `https://google.com`.
  Failure case: Legal-link activation must not open a different destination, external browser, or provider-authentication flow.

[W1-7/AUTH-§7] INTERACTION: Apply the shared onboarding transition and press behavior while respecting reduced-motion settings and Android touch interaction.
  Failure case: Reduced-motion operation must not depend on the full onboarding entrance animation.

[W1-7] LOCALIZATION: Supply all new auth, loading-accessibility, failure, reassurance, and legal-link text through the project's English and Chinese localization system.
  Failure case: Do not hard-code user-visible copy in the widget layer or leave a supported locale without the new strings.

[W1-7] VERIFICATION: Cover routing, provider selection, loading lockout, retry clearing, silent cancellation, inline failure, legal-link URL passing, and core rendered content with permitted unit and widget tests.
  Failure case: Any behavior requiring live provider configuration or visual judgement must be recorded for manual verification rather than reported as automatically proven.

## Out of scope

- Authentication route guards, auth-state-driven redirects, expired-session handling, and successful-sign-in navigation; these belong to Week 1 item 8.
- Apple, Twitch, email/password, password reset, email verification, and account-creation UI.
- iOS behavior or platform conditionals.
- Real Terms and Privacy destinations; both use `https://google.com` temporarily.
- A real 88-pixel app mark.
- Live end-to-end OAuth verification while provider configuration remains deferred.
- Changes to the authentication domain or data contracts completed in item 5 unless a separately approved blocker is discovered.

## Assumptions

ASSUMPTION: Author concise generic failure copy in English and Chinese because exact wording is not specified.

ASSUMPTION: Android touch behavior is normative; desktop hover descriptions are not mobile acceptance requirements.

ASSUMPTION: Terms and Privacy intentionally share the same temporary URL.

## Constraints

- Target Android only.
- Use existing design tokens wherever the system defines them; retain only the auth specification's explicitly documented local additions.
- Preserve all existing onboarding/widget refactors and the onboarding-seen persistence behavior.
- Do not claim automated analyzer or test health from the indeterminate Phase 0 baselines.

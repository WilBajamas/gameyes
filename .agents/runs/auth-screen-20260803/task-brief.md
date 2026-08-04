# Task Brief
Source: `.agents/runs/auth-screen-20260803/tech-ac.md`
Date: 2026-08-03
Tech Lead Agent version: 1.0

## Context

Add the third onboarding surface for Discord/Google sign-in, connect it to the existing auth use case, and provide reusable in-app legal web content without taking over item 8's session routing.

## Testing mode

coverage
Rule applied: the feature touches authentication and adds a shared application widget.
Justification: provider selection, concurrency lockout, cancellation, retry, routing, and URL passing need focused state and widget coverage; native WebView rendering and visual fidelity remain manual.

## File allowlist

### CREATE NEW

`lib/features/auth/presentation/blocs/sign_in_state.dart` — immutable sign-in status, active-provider, and error state.

`lib/features/auth/presentation/blocs/sign_in_cubit.dart` — screen-scoped sign-in orchestration using the existing use case.

`lib/features/auth/presentation/screens/auth_screen.dart` — responsive two-provider auth screen and private UI components.

`lib/widgets/app_web_view.dart` — reusable stateful WebView route page accepting a URI, providing standard back navigation, and exposing load progress.

### MODIFY EXISTING

`pubspec.yaml` — add only `flutter_svg: ^2.3.0` and `webview_flutter: ^4.14.1`; keep the already registered `assets/icons/` path unchanged.

`pubspec.lock` — resolve the two approved direct dependencies and their transitive packages.

`lib/config/route/auto_route_config.dart` — add `/auth` and `/legal` routes.

`lib/features/onboarding/presentation/screens/onboarding_screen.dart` — replace the completed welcome flow's home navigation with auth navigation.

`lib/l10n/intl_en.arb` — add English auth, provider, error, loading-semantics, reassurance, and legal copy.

`lib/l10n/intl_zh.arb` — add matching Chinese auth, provider, error, loading-semantics, reassurance, and legal copy.

### TEST FILES

`test/cubit/auth/sign_in_cubit_test.dart` — cover provider forwarding, loading lockout, success, silent cancellation, failure, and retry clearing.

`test/widget/auth/auth_screen_test.dart` — cover core content, provider actions, loading/failed states, legal URL routing, reduced motion, and responsive overflow.

`test/widget/onboarding/welcome_screen_test.dart` — assert Skip and Get started preserve the seen flag and replace the flow with the auth destination.

## Implementation plan

Step 1: `pubspec.yaml` — add only `flutter_svg: ^2.3.0` and `webview_flutter: ^4.14.1`; run dependency resolution so `pubspec.lock` records the approved graph. Do not edit the already present `assets/icons/` entry.

Step 2: `lib/features/auth/presentation/blocs/sign_in_state.dart` — define `SignInStatus` and a sealed Freezed state with idle defaults, nullable active provider, and nullable `ErrorType`.

Step 3: `lib/features/auth/presentation/blocs/sign_in_cubit.dart` — inject `SignInUseCase`; ignore calls while loading; emit loading with cleared error; forward the selected provider; return to idle on success or `signInCancelled`; emit failed for every other `ErrorType`.

Run `dart run build_runner build --delete-conflicting-outputs` so the new Freezed state and injectable Cubit generate before UI imports them. Generated outputs are implicit and must not be hand-edited.

Step 4: `lib/widgets/app_web_view.dart` — create the global stateful `@RoutePage()` `AppWebView(Uri url)`; render a standard back app bar, initialize one `WebViewController`, enable JavaScript for normal website operation, report progress through a thin linear indicator, and load the supplied URI.

Step 5: `lib/features/auth/presentation/screens/auth_screen.dart` — create the route page, provide `SignInCubit` from DI, and implement the responsive scroll/fill layout using private stateless sub-widgets. Apply the shared 420 ms entrance curve through motion tokens so reduced-motion settings collapse it. Use existing tokens, official unchanged SVG assets, loading lockout, generic inline failure, and `https://google.com` for both `AppWebViewRoute` legal destinations. Do not listen for success navigation.

Step 6: `lib/config/route/auto_route_config.dart` — register `/auth` and `/legal` as top-level routes without guards, using `AppWebViewRoute` for `/legal`.

Step 7: `lib/features/onboarding/presentation/screens/onboarding_screen.dart` — keep `WelcomeCubit.finish()` unchanged and replace `HomeRoute` with `AuthRoute` when the welcome state becomes finished.

Run `dart run build_runner build --delete-conflicting-outputs` to generate the new AutoRoute entries and refresh DI after all annotated sources exist.

Step 8: `lib/l10n/intl_en.arb` — add the English strings defined by the code plan.

Step 9: `lib/l10n/intl_zh.arb` — add equivalent Chinese strings and the same placeholder metadata.

Manual prerequisite: regenerate Flutter Intl output from the IDE after both ARB files change. Do not run `flutter gen-l10n` and do not hand-edit `lib/generated/`. The new source cannot compile until this human regeneration completes.

Step 10: `test/cubit/auth/sign_in_cubit_test.dart` — generate a `SignInUseCase` mock and cover initial state, both providers, loading re-entry prevention, success, cancellation, ordinary failure, and clearing a previous failure when retry begins.

Step 11: `test/widget/auth/auth_screen_test.dart` — generate Cubit and router mocks; verify content/order, exact provider calls, disabled loading state with retained label/progress, inline error behavior, both legal links routing directly to `AppWebViewRoute` with `https://google.com`, reduced motion, and no overflow at 360-by-600 with 1.5 text scale.

Step 12: `test/widget/onboarding/welcome_screen_test.dart` — extend the route-aware harness and assert both completion actions write the seen flag and replace onboarding with `AuthRoute`.

Run `dart run build_runner build --delete-conflicting-outputs` after the Mockito annotations so all test mocks are regenerated.

Step 13: Format only the hand-written allowlisted Dart files with the repository's pinned formatter. Do not reformat unrelated files or generated output.

Step 14: Run the focused Cubit and widget tests for auth and onboarding. Treat native WebView platform rendering as manual rather than weakening tests around it.

Step 15: Run `flutter analyze` and `flutter test` and compare both against these untouched baselines verbatim: `Analyzer baseline: INDETERMINATE — flutter analyze timed out after 180 seconds without diagnostics at 2026-08-03T20:52:00+08:00`; `Test baseline: INDETERMINATE — flutter test timed out after 180 seconds without diagnostics at 2026-08-03T20:55:00+08:00`. Do not infer green status from silence or timeout; report every diagnostic received and any command that remains indeterminate.

## Acceptance criteria reference

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

## Constraints

- Android only. Do not add iOS-specific code or platform conditionals.
- Preserve all existing welcome widget classes, layout refactors, `WelcomeCubit`, and `first_use` behavior; change only the finished-state navigation target.
- Use Cubit + Freezed state, constructor injection, GetIt/injectable generation, AutoRoute navigation, and existing `Result`/`ErrorType` patterns.
- Use `AppTokens` for every defined visual value. `surfaceRaised`, `ink24`, error tokens, and existing radius/type tokens already cover the auth specification's formerly local additions.
- The provider rows remain private auth-screen widgets. Do not generalize `PrimaryButton` or `ButtonPressScale` and do not add Widget-returning helper functions/getters.
- Use the supplied SVG assets unchanged and include semantic labels. Do not apply an SVG colour filter.
- `assets/icons/` is already registered; do not rewrite the assets list.
- `flutter_svg ^2.3.0` and `webview_flutter ^4.14.1` are explicitly human-approved. Add no other dependency. Flutter 3.41.4's Android min SDK 24 satisfies the selected WebView release without an Android Gradle change.
- `AppWebView` is global because the human explicitly requires a reusable application-wide webview. It is itself the AutoRoute page; do not add a passthrough legal wrapper.
- Use `Uri` at the WebView boundary; both legal actions construct the temporary `https://google.com` URI.
- Only English and Chinese ARB files exist; update both. Flutter Intl IDE regeneration is manual and required before compilation.
- Unit and widget tests only. Never add golden or integration tests.
- Preserve user changes, line endings, and unrelated generated files. Do not reset, revert, or broadly reformat.
- Phase 0 analyzer and test baselines are indeterminate timeouts; never claim automated health without actual diagnostics.

## Self-correction budget

Max attempts per failure: 3
On budget exhaustion: write escalation.md, halt.
Do not modify test files to make tests pass.
Do not add packages to pubspec.yaml except the two explicitly approved dependencies.
Do not touch files outside the allowlist — escalate instead.

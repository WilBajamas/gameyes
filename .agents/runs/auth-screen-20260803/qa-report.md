# QA Report
Run: auth-screen-20260803
Commit: `b81ef40`
Overall result: PASS — pending manual checks

## Manual verification required
1. On an Android device, visually compare the auth surface with the approved design: onyx layout, 88×88 solid-border `LOGO` placeholder, PNG provider marks, typography, spacing, 52-pixel provider rows, 10-pixel gap, press feedback, and reduced-motion behavior.
2. With provider configuration available, exercise live Discord and Google OAuth, including success, cancellation, and a retryable failure.
3. On Android, open Terms and Privacy; confirm each loads `https://google.com` inside `AppWebView`, shows load progress, and supports standard back navigation.

## Static analysis
`fvm flutter analyze`: completed with the 38 approved unrelated diagnostics and no diagnostics in auth/onboarding feature files. No new attributable diagnostic.

## Test results
`fvm flutter test --coverage test/cubit/auth/sign_in_cubit_test.dart test/widget/auth/auth_screen_test.dart`: PASS, 10 tests.

`fvm flutter test test/widget/onboarding/welcome_screen_test.dart --name "writes the seen flag"`: PASS, 2 tests. The two approved unchanged welcome visual assertions were not run.

## Coverage gaps
Native WebView rendering, visual fidelity, Android touch feel, and live OAuth require the manual checks above.

## Acceptance criteria
[W1-7] NAVIGATION: PASS — `/auth` is registered at `lib/config/route/auto_route_config.dart:13`; both completion paths target `AuthRoute` in the two passing onboarding tests.

[W1-7] NAVIGATION (no item-8 redirects): PASS — `AuthScreen` owns no success listener or post-auth route.

[W1-7/AUTH-§1]: PASS — provider order and exclusivity are asserted by `renders only Discord then Google provider actions`.

[W1-7/AUTH-§2]: MANUAL — structure is implemented in `lib/features/auth/presentation/screens/auth_screen.dart`; final visual judgment remains manual.

[W1-7/AUTH-§3]: PASS — `LogoPlaceholder(width: 88, height: 88)` at `lib/features/auth/presentation/screens/auth_screen.dart:57`; solid border is approved.

[W1-7/AUTH-§4]: PASS — localized title/lead render from `S.current` in `auth_screen.dart`; exact visual hierarchy remains in manual check 1.

[W1-7/AUTH-§5] UI: PASS — provider widget layout is exercised by the auth widget tests; final visual judgment remains in manual check 1.

[W1-7/AUTH-§5] ASSET: PASS — approved PNG provider assets are used at `auth_screen.dart:68` and `auth_screen.dart:79`.

[W1-7] CONFIGURATION: PASS — dependency and asset changes match the approved implementation and deviations.

[W1-7] AUTH: PASS — exact provider forwarding is covered by `signs in once with discord` and `signs in once with google`; live OAuth is manual.

[W1-7/AUTH-§7] STATE: PASS — loading lockout and retained active label/progress pass `locks both actions and keeps the active row label visible`.

[W1-7] STATE: PASS — retry clearing and silent cancellation pass focused Cubit tests.

[W1-7/AUTH-§7] ERROR UI: PASS — inline retryable failure passes `shows provider failures inline and remains retryable`.

[W1-7/AUTH-§6]: PASS — reassurance and legal footer are rendered from localized copy in `auth_screen.dart:93-102`.

[HUMAN-20260803] WEBVIEW: PASS — both legal actions pass the temporary URL directly to `AppWebViewRoute`; route arguments pass the focused widget test. Native rendering is manual.

[W1-7/AUTH-§7] INTERACTION: MANUAL — implementation is present; Android press feel and visual reduced-motion behavior require manual check 1.

[W1-7] LOCALIZATION: PASS — matching auth keys exist in both English and Chinese ARBs at lines 21-39.

[W1-7] VERIFICATION: PASS — focused unit/widget coverage and the two changed onboarding routing tests passed.

## Architectural compliance
Cubit/Freezed state, constructor-injected `SignInUseCase`, screen-scoped provider, AutoRoute destinations, direct global `AppWebView` routing, localized copy, and the approved file separations are preserved. Test-generated coverage and macOS registration working-tree side effects were restored to the committed state after verification.

## Escalation required
Route to: NONE
No new attributable failure occurred in QA attempt 2.

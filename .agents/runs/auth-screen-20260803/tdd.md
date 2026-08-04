# Technical Design Document
Source: `.agents/runs/auth-screen-20260803/tech-ac.md`
Date: 2026-08-03
Tech Lead Agent version: 1.0

## Feature summary

Extend the existing auth feature with a screen-scoped `SignInCubit` and immutable sign-in state, add an AutoRoute auth destination after onboarding, and render the two-provider social sign-in surface with existing tokens and supplied SVG assets. Add a global stateful `AppWebView` route page backed by `webview_flutter` for temporary legal destinations. Successful OAuth launch returns the screen to idle without navigation; item 8 retains all auth-state guarding and redirects.

## Layer map

[W1-7] Navigation: UI, routing, local-storage-preserving onboarding integration

[W1-7/AUTH-§1–§7] Sign-in screen: state, UI, assets, localization

[HUMAN-20260803] Legal destinations: UI, routing, shared widget

[W1-7] Verification: Cubit tests, widget tests, manual platform-view and visual checks

## Data layer

No data-layer changes. Reuse the item-5 authentication repository and datasource unchanged.

## Domain layer

No domain-layer changes.

### Use cases

`SignInUseCase` (reuse) — `lib/features/auth/domain/use_cases/sign_in_use_case.dart`
  Input: `SignInProvider provider`
  Returns: `Future<Result<void>>`
  Calls: `AuthRepository.signIn(provider)`
  Errors: `ErrorType.signInCancelled`, provider response errors, timeouts, unknown errors

## State layer

### Notifiers / BLoC

`SignInCubit` (create) — `lib/features/auth/presentation/blocs/sign_in_cubit.dart`
  Scope: screen
  State: `SignInState`
  Calls: `SignInUseCase` when an enabled provider action is activated
  Concurrency: ignores calls while `SignInStatus.loading`
  Success: returns to idle without navigation
  Cancellation: returns to idle without error
  Failure: emits failed with the returned `ErrorType`

`SignInState` (create) — `lib/features/auth/presentation/blocs/sign_in_state.dart`
  Fields: `status: SignInStatus`, `activeProvider: SignInProvider?`, `error: ErrorType?`
  Status values: `idle`, `loading`, `failed`
  Serialisation: none; in-memory only

## UI layer

### Screens

`AuthScreen` (create) — `lib/features/auth/presentation/screens/auth_screen.dart`
  Type: stateless route page with private stateless UI composition
  Consumes: screen-scoped `SignInCubit`
  Handles: Discord/Google taps, loading lockout, generic inline error, Terms/Privacy taps
  Navigates to: `AppWebViewRoute` for legal links only; none on auth success
  Responsive behavior: fills the runtime viewport; uses a scrollable fill-remaining layout so the legal footer stays low on normal screens and all content remains reachable on short screens or with larger text. The 330-by-714 mockup is a reference, not a fixed device frame.

### Widgets

`AppWebView` (create) — `lib/widgets/app_web_view.dart`
  Type: stateful global route page
  Consumes: required `Uri url`
  Handles: standard app-bar back navigation, controller initialization, unrestricted page JavaScript, URL loading, and linear load progress

Private auth-screen widgets remain in `auth_screen.dart`: `_AuthContent`, `_LogoPlaceholder`, `_ProviderAction`, `_InlineSignInError`, and `_LegalFooter`. They are private `StatelessWidget` classes because each is pure UI with one screen caller. No Widget-returning helper functions are introduced.

## Reuse decisions

`SignInUseCase` at `lib/features/auth/domain/use_cases/sign_in_use_case.dart` — preserves the item-5 domain boundary and provider mapping.

`SignInProvider` at `lib/features/auth/domain/entities/sign_in_provider.dart` — supplies the existing Discord and Google values.

`ErrorType` and `Result` at `lib/core/data/models/` — preserve cancellation and repository failure semantics.

`ButtonPressScale` at `lib/widgets/button_press_scale.dart` — supplies the existing 0.97 press treatment, focus ring, and reduced-motion behavior. Each auth action wraps it in `IgnorePointer` while disabled so shared behavior does not need modification.

`AppTokens` through `BuildContext.tokens` — supplies canvas, raised surface, Discord indigo, link cyan, ink ramp, error ramp, radii, type, and motion without new raw colour values.

`WelcomeCubit.finish()` — retains the existing `first_use` persistence. Only the finished-state navigation target changes from home to auth.

`AutoRoute` and the existing route configuration — add normal destinations without changing the routing mechanism.

Existing `assets/icons/` registration — already covers both supplied provider marks; no asset configuration edit is needed.

## Out of scope

- Item-8 auth guards, session observation, expiry/sign-out redirects, and post-authentication navigation.
- Any authentication domain, repository, datasource, provider, or callback changes.
- Apple, Twitch, email/password, password reset, email verification, and account creation.
- iOS-specific behavior.
- Production Terms and Privacy URLs.
- A real app logo.
- Live OAuth completion while provider configuration remains deferred.
- Pixel-perfect automated verification or native WebView rendering in widget tests.

## Open questions

NONE

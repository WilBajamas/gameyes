# Technical Design Document
Source: W1-8.1 — `source-request.md` (Product Owner ticket, 2026-08-05),
follow-up to W1-8
Date: 2026-08-05

## Feature summary

A new screen-scoped `SignOutCubit` in the auth feature's presentation layer
wraps the already-shipped `SignOutUseCase` and exposes a three-state machine
(idle / loading / failed). The Settings screen gains one extra sliver holding a
`BlocProvider` for that cubit and a private section widget that renders the
control and, on failure, an inline error beside it. No repository, model,
datasource or use case is added — the data and domain layers are consumed
exactly as item 5 shipped them. The feature deliberately contains **no
navigation and no auth-status observation**: W1-8's `AuthGuard` +
`AuthStatusListener` (wired as `reevaluateListenable` in `main.dart`) remain the
only thing that decides where a signed-out user goes, and this design adds no
second path to race it.

## Layer map

[W1-8.1-AC01]: UI
[W1-8.1-AC02]: UI, state
[W1-8.1-AC03]: state
[W1-8.1-AC04]: state, UI
[W1-8.1-AC05]: UI, state (nothing added — no route action anywhere in the feature)
[W1-8.1-AC06]: state (nothing added — cubit observes no auth status)
[W1-8.1-AC07]: UI (nothing added — no listener, snackbar, dialog or banner)
[W1-8.1-AC08]: UI
[W1-8.1-AC09]: UI
[W1-8.1-AC10]: state
[W1-8.1-AC11]: state, UI
[W1-8.1-AC12]: UI, l10n
[W1-8.1-AC13]: UI

## Data layer

### API contracts

None. Sign-out goes through the existing `AuthDatasource.signOut()` →
Supabase SDK path shipped in item 5. No HTTP contract is defined or inferred by
this run.

### Models

None created or modified.

### Repositories

None created or modified. `AuthRepository.signOut()` →
`Future<Result<void>>` (`lib/features/auth/domain/repositories/auth_repository.dart`)
is consumed unchanged; `AuthRepositoryImpl.signOut` already converts
`AuthException` and every other throw into a `Failure(ErrorType)`, so no
exception can escape to the state layer.

## Domain layer

None created or modified. `SignOutUseCase`
(`lib/features/auth/domain/use_cases/sign_out_use_case.dart`) — no input,
returns `Future<Result<void>>`, calls `AuthRepository.signOut()` — is injected
into the new cubit as-is.

## State layer

SignOutState (create) — `lib/features/auth/presentation/blocs/sign_out_state.dart`
— `@freezed sealed`, fields `status` (`SignOutStatus`, default `idle`) and
`error` (`ErrorType?`). Enum `SignOutStatus { idle, loading, failed }`, mirroring
`SignInStatus` so the two auth controls read the same way.

SignOutCubit (create) — `lib/features/auth/presentation/blocs/sign_out_cubit.dart`
— scope: **screen** (provided by the Settings screen, one instance per visit;
no global registration, no app-lifetime listener). Depends on `SignOutUseCase`
only, injected by constructor, `@injectable`.

- Single public method `signOut()`. It returns immediately when
  `status == loading`, so one tap is one call [AC03].
- Emits `loading` with no error before calling the use case, which is both the
  pending state [AC04] and the point at which a previous failure clears [AC11].
- Switches exhaustively on `Result<void>`: `Success` → back to the default idle
  state; `Failure` → `failed` carrying the `ErrorType`. There is no third branch
  and no early return that leaves the control idle with nothing shown [AC10].
- Guards `isClosed` between the await and the emit. A successful sign-out makes
  `AuthStatusListener` notify, which re-evaluates `AuthGuard` and replaces the
  stack — the Settings screen and this cubit can be disposed before the use
  case's future resolves. Without the guard that ordering throws
  "cannot emit after close", which would be exactly the unhandled exception
  [AC10] forbids. The guard is the only concession made to the redirect; the
  cubit neither waits for it, suppresses it, nor knows it happened [AC05/AC06].
- No `try`/`catch`: the repository is the error boundary and is contractually
  incapable of throwing, so a second one here would be dead code.

**Placed in the auth feature, not settings.** The state it owns is auth state
and its dependency is an auth use case; it sits beside `SignInCubit` and is
tested at `test/cubit/auth/`. Settings owns the presentation of the control,
not the sign-out itself. One cubit, one operation — no `and` in its name.

## UI layer

### Screens

SettingsScreen (modify) —
`lib/features/settings/presentation/screens/settings_screen.dart` — stateful
(unchanged: it owns the `ScrollController` feeding `ScrollNotifier`). Consumes
nothing new itself. The single change is one additional sliver appended after
the existing placeholder sliver, containing a `BlocProvider` that creates
`getIt<SignOutCubit>()` around the new section widget. The app bar, scroll
physics, controller wiring and existing placeholder content are untouched
[AC13]. The screen performs no navigation as a result of this feature [AC05].

Lowest reactive-rebuild boundary: the `BlocBuilder<SignOutCubit, SignOutState>`
lives **inside** the section widget, below the `SliverToBoxAdapter`. `Scaffold`,
`SafeArea`, `CustomScrollView`, `DefaultSliverAppBar` and the existing sliver
all stay outside it, so a state change repaints the section only.

### Widgets

_SignOutSection (create) —
`lib/features/settings/presentation/widgets/sign_out_section.dart`, a `part` of
`settings_screen.dart` (same pattern as the auth screen's `part` widgets) —
stateless — consumes `SignOutState` via `BlocBuilder` — composes the control
and, when `status == failed`, the inline error directly beneath it, inside the
section's own padding [AC08]. No `BlocListener` anywhere in the feature: there
is nothing to react to imperatively, and adding one is how a stray snackbar or
route call gets introduced [AC07/AC09].

_SignOutButton (create) — same file — stateless — takes `loading` and
`onPressed` — one tap calls `context.read<SignOutCubit>().signOut()` with no
intermediate step [AC02]; rendered unconditionally, with no `kDebugMode`,
flavour or flag check anywhere in its construction [AC01]; shows a distinct
pending affordance and ignores pointers while `loading`, returning to rest on
either outcome [AC03/AC04]. Follows the existing full-width action-row anatomy
(52px row, `radius.sm`, `surfaceRaised` fill, centred label, 16px progress
indicator when pending) already used by the sign-in provider rows.

_InlineSignOutError (create) — same file — stateless — consumes nothing;
renders the error icon plus the localised failure line in `color.errorInk`,
mirroring `_InlineSignInError` on the auth screen [AC08]. It is a plain widget
in the section's column — not a snackbar, dialog, banner or full-page state
[AC09].

**Not a destructive action.** `system-foundation-specs.md §3.4` reserves the
`errorStrong` destructive fill and the error-ink outline for removal and account
deletion. Signing out destroys nothing, so the control uses the neutral raised
action-row treatment; only the failure message uses the error ramp.

## Localisation

Two new keys, added to **both** `lib/l10n/intl_en.arb` and
`lib/l10n/intl_zh.arb` [AC12]:

| Key | English | Chinese |
|---|---|---|
| `auth_sign_out` | `Sign out` | `退出登录` |
| `auth_sign_out_error` | `We couldn't sign you out. Please try again.` | `无法退出登录，请重试。` |

Both are unavoidable. Every existing key in both files was re-checked against
BA `ASSUMPTION 3`: `settings` is the screen title, `auth_sign_in_error` says the
opposite thing, `error_results` means a failed fetch, and `retry` is a button
label, not a message. Reusing any of them would ship a wrong string, which is a
worse outcome than the manual step below. No design that keeps the feature whole
avoids these two keys, and no third key is introduced — the pending state is
conveyed visually rather than by a second label.

**Consequence, stated plainly: the branch will not compile when the Dev Agent
halts.** `S.current.auth_sign_out` and `S.current.auth_sign_out_error` do not
exist until a human opens the project in the IDE and lets the Flutter Intl
plugin regenerate `lib/generated/l10n.dart` and `messages_*.dart`
(`handover.md` gotcha #1 — there is no CLI for it, and `flutter gen-l10n`
belongs to a removed system and must never be run). Until that pass happens,
`flutter analyze` will report undefined-getter errors on the settings widget
and the settings widget test, and those files' tests cannot run. This is
pre-authorised by the ticket and is expected state, not a failure to
self-correct — no self-correction attempts are to be spent on it.

## Reuse decisions

- `SignOutUseCase` — `lib/features/auth/domain/use_cases/sign_out_use_case.dart`
  — already built, injected and unit-tested in item 5. The ticket names it as
  the action; nothing new is needed in domain or data.
- `AuthGuard`, `AuthStatusListener`, `SessionNavigator`, `PendingRouteStore`
  (`lib/config/route/`) — consumed entirely unchanged and not referenced by any
  new file. They already move a signed-out user to sign-in reactively via
  `main.dart`'s `reevaluateListenable`. This run adds nothing to that path
  [AC05/AC06].
- `SignInCubit` / `SignInState` — used as the shape to copy (status enum,
  in-flight guard, error held until the next attempt), not as code to extend.
  Sign-in and sign-out are separate operations; folding both into one notifier
  would break the one-feature-boundary rule and put an unrelated failure on the
  Settings screen.
- `_InlineSignInError` (`lib/features/auth/presentation/widgets/`) — **not
  reused.** It is private to `auth_screen.dart` via `part`, and hard-codes the
  sign-in string. A settings-local twin is three lines of composition; making
  the auth one shared would mean editing a screen this ticket puts out of scope.
- `_ProviderActionButton` — **not promoted to `lib/widgets/`.** Its `assetPath`
  and provider-mark slot are required parameters that sign-out has no use for,
  so promoting it means either a speculative optional parameter or a variant —
  both banned by `flutter-arch.md` — and it would edit shipped item-7 code.
- `DefaultOutlinedButton` (`lib/widgets/`) — **not reused.** No pending state,
  no disabled state, and it renders an empty `Icon` when none is given; it
  cannot satisfy AC03/AC04 without being modified, and it is shared by other
  screens.
- `DefaultSnackbar`, `DefaultAlertDialog` — deliberately **not** used. AC07 and
  AC09 forbid both.

## Out of scope

- Any edit to `lib/config/route/**` — out of scope in `tech-ac.md` and not
  needed; the guard mechanism is consumed, not extended.
- Any second reaction to `signedOut` status, in any layer.
- Any change to existing Settings content, the app bar, scroll behaviour or the
  placeholder sliver [AC13].
- A confirmation step, account deletion, or clearing cached app data, saved
  tracker content or the onboarding-seen flag on sign-out (BA `ASSUMPTION 9`).
- Hand-writing the `S` accessor for the two new keys.
- Running W1-8's four unblocked manual checks — that is W1-8's outstanding work.

## Open questions

None.

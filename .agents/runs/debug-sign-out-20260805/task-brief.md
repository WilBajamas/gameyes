# Task Brief
Source: W1-8.1 — `source-request.md` (Product Owner ticket, 2026-08-05),
follow-up to W1-8
Date: 2026-08-05

## Context

Adds a permanent sign-out control to the Settings screen, wired to the existing
`SignOutUseCase`, so a user can leave their session from inside the app — which
also unblocks four of W1-8's manual checks. The control performs no navigation
itself; W1-8's shipped guard decides where a signed-out user goes.

## Testing mode

`coverage` — Rule applied: auth/authorisation. Justification: the feature drives
the session-ending path of the auth system, and its most important criteria
(AC05, AC06, AC07) are all things that must **not** happen, which only an
automated assertion can hold in place over time.

## File allowlist

### CREATE NEW
`lib/features/auth/presentation/blocs/sign_out_state.dart` — freezed state and
`SignOutStatus { idle, loading, failed }` enum for the sign-out control.
`lib/features/auth/presentation/blocs/sign_out_cubit.dart` — screen-scoped
cubit calling `SignOutUseCase` once per tap and holding the failure.
`lib/features/settings/presentation/widgets/sign_out_section.dart` — `part` of
the settings screen; the section, the control, and the inline error widget.

### MODIFY EXISTING
`lib/features/settings/presentation/screens/settings_screen.dart` — adds the
`part` directive, the imports it needs, and one new sliver holding a
`BlocProvider` around the section. Nothing else on the screen changes.
`lib/l10n/intl_en.arb` — adds `auth_sign_out` and `auth_sign_out_error`.
`lib/l10n/intl_zh.arb` — adds the same two keys with Chinese values.

### TEST FILES
`test/cubit/auth/sign_out_cubit_test.dart` — initial state, one call per tap,
repeat taps ignored while in flight, failure captured, error cleared on retry.
`test/widget/settings/settings_screen_test.dart` — the control renders
unconditionally, a tap runs exactly one sign-out and shows the pending state,
a failure renders inline while existing content survives, and **no router
action occurs on either outcome**.

## Implementation plan

Step 1: Add `auth_sign_out` and `auth_sign_out_error` to `lib/l10n/intl_en.arb`
(values in `tdd.md ## Localisation`). Keep the file's existing key order and
formatting; do not touch any other key.

Step 2: Add the same two keys, with the Chinese values from
`tdd.md ## Localisation`, to `lib/l10n/intl_zh.arb`, in the same relative
position.

Step 3: Create `lib/features/auth/presentation/blocs/sign_out_state.dart` — the
`SignOutStatus` enum and the `@freezed sealed` `SignOutState`.

Step 4: Create `lib/features/auth/presentation/blocs/sign_out_cubit.dart` — the
`@injectable` cubit described in `tdd.md ## State layer`. Do not import
anything from `lib/config/route/`, `auto_route`, or any auth-status stream.

CHECKPOINT: run `dart run build_runner build --delete-conflicting-outputs`
(freezed output for the new state, injectable registration for the new cubit).
Do not include unrelated regenerated files in the commit — see `handover.md`'s
build_runner over-generation gotcha and restore anything else it rewrites with
`git checkout -- <path>`.

Step 5: Create `lib/features/settings/presentation/widgets/sign_out_section.dart`
as `part of '../screens/settings_screen.dart';` holding `_SignOutSection`,
`_SignOutButton` and `_InlineSignOutError`. All colours, radii, type and motion
come from `context.tokens` — no literal colours or `Theme.of(context)`.

Step 6: Modify
`lib/features/settings/presentation/screens/settings_screen.dart` — add the
`part` directive and the needed imports, and append one `SliverToBoxAdapter`
after the existing placeholder sliver containing
`BlocProvider(create: (_) => getIt<SignOutCubit>(), child: const _SignOutSection())`.
Leave the app bar, `ScrollController` wiring, physics and existing sliver
exactly as they are.

Step 7: Create `test/cubit/auth/sign_out_cubit_test.dart`. Follow
`test/cubit/auth/sign_in_cubit_test.dart` — a local `AuthRepository` stub with
`bloc_test`, no `@GenerateMocks`, so no mocks file is generated for this one.

Step 8: Create `test/widget/settings/settings_screen_test.dart`. Follow
`test/widget/auth/auth_screen_test.dart` — `@GenerateMocks([StackRouter])`,
`S.load(const Locale('en'))` in `setUpAll`, register `ScrollNotifier` and a
`SignOutCubit` factory in `getIt`, reset GetIt in `tearDown`, pump inside
`StackRouterScope` with `buildDarkTheme()`.

CHECKPOINT: run `dart run build_runner build --delete-conflicting-outputs`
again for the widget test's `@GenerateMocks` output, before running any test.

Step 9: Run `flutter analyze` and `flutter test`, and compare against
`orchestrator-state.md`'s baselines, quoted verbatim:

- `Analyzer baseline: 0 errors, 2 warnings, 36 info (38 issues) — captured 2026-08-05`
- `Test baseline: +176 -13 (189 total) — captured 2026-08-05`
- `Pre-existing test failures: 13 failures across 6 files — test/api/games/games_test.dart, test/api/game_detail/game_detail_test.dart, test/cubit/games/games_bloc_test.dart, test/cubit/game_detail/game_detail_cubit_test.dart, test/repository/tracker/tracker_repository_test.dart, test/widget_test.dart.`

Those 13 failures are pre-existing and are never this run's regression. **On top
of that baseline, expect analyzer errors for the two new localisation keys** —
see `## Localisation — required manual step` below. Those are expected, are not
counted against the baseline, and are not to be self-corrected. Report the
delta; do not claim a green suite or a clean analyzer.

## Localisation — required manual step

This branch adds two new user-facing strings, `auth_sign_out` and
`auth_sign_out_error`, to `lib/l10n/intl_en.arb` and `lib/l10n/intl_zh.arb`.
No existing key fits either string, and no design that keeps the feature whole
avoids them (`tdd.md ## Localisation` records the check).

**The branch will not compile as delivered.** The `S` class in
`lib/generated/l10n.dart` is produced by the Flutter Intl IDE plugin, which has
no CLI in this repo, so an agent cannot generate the two accessors
(`handover.md` gotcha #1). Consequences to expect:

- `flutter analyze` reports undefined-getter errors for `S.current.auth_sign_out`
  and `S.current.auth_sign_out_error` in
  `lib/features/settings/presentation/widgets/sign_out_section.dart` and in
  `test/widget/settings/settings_screen_test.dart`.
- The settings widget test cannot run until that is fixed.
- **A human must open the project in the IDE and let the Flutter Intl plugin
  regenerate `lib/generated/l10n.dart` and `lib/generated/intl/messages_*.dart`
  before the branch builds.** This is the one required manual step.

Never hand-write the accessor, never edit `lib/generated/**`, and never run
`flutter gen-l10n`. Record the pending regeneration under
`diff-summary.md ## Deviations from implementation plan`.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: W1-8.1-AC01 – W1-8.1-AC13

## Constraints

- **No route action anywhere in this feature.** No `context.router`, no
  `Navigator`, no `AutoRouter` call, no import of `lib/config/route/**` or of
  `auto_route` navigation APIs in any new or modified file. W1-8's guard is the
  only redirect path [AC05].
- **No auth-status observation.** Do not inject or subscribe to
  `ObserveAuthStatusUseCase`, `AuthStatusListener`, `AuthRepository`, or any
  auth stream. The cubit's only dependency is `SignOutUseCase` [AC06].
- **No snackbar, dialog, banner or full-page error**, on either outcome — so no
  `DefaultSnackbar`, no `DefaultAlertDialog`, no `ScaffoldMessenger`, no
  `SliverFillRemaining` error state, and no `BlocListener` at all
  [AC07/AC08/AC09].
- **No build-mode gating.** No `kDebugMode`, flavour check, `assert`, or
  environment condition around the control's construction [AC01].
- Cubit provisioning: `BlocProvider` + `getIt` at the smallest subtree that
  needs it — the new sliver, not the screen root, not above the screen
  (`project-conventions.md`). Never call `getIt<T>()` inside the cubit.
- `BlocBuilder` goes inside the section widget; `Scaffold`, `SafeArea`,
  `CustomScrollView` and the app bar stay outside it
  (`flutter-arch.md § Reactive boundary convention`).
- State is `@freezed sealed` with a status enum and `ErrorType?` — never a bool,
  never a `String` error (`flutter-arch.md`, `dart-style.md`).
- Extracted UI is a widget class. No function or getter returning `Widget` or
  `List<Widget>` (`flutter-arch.md`).
- All colour, radius, type and motion values come from `context.tokens`. No
  literal colours, no `Theme.of(context)` (`dart-style.md`, `project-conventions.md`).
  The control follows the existing 52px full-width action-row anatomy at
  `radius.sm` on `surfaceRaised`; the failure line uses `color.errorInk`. It is
  **not** styled as a destructive action — `errorStrong` and the error-ink
  outline are reserved for removal and account deletion
  (`system-foundation-specs.md §3.4`). Minimum 44px hit target.
- Every user-facing string via `S.current.[key]`; no hard-coded literal [AC12].
  Match `settings_screen.dart`'s existing relative l10n import style.
- Lints that bite here: `prefer_single_quotes`, `require_trailing_commas`,
  `lines_longer_than_80_chars`, `no_default_cases` (switch on `Result` must
  handle `Success` and `Failure` explicitly), `avoid_redundant_argument_values`.
- Comments: plain English, explain the *why*, few of them. The `isClosed` guard
  in the cubit is the one place a short comment earns its keep.
- Tests are layer-based — `test/cubit/auth/` and `test/widget/settings/`, never
  mirrored from `lib/`. Unit and widget tests only. **Never a golden test.**
- Do not touch `lib/config/route/**`, `lib/generated/**`, the auth screen, or
  any existing Settings content [AC13].

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to
make tests pass. Do not add packages to `pubspec.yaml` or touch files outside
the allowlist — escalate instead. The two missing localisation accessors are
**not** a failure point and consume no attempts.

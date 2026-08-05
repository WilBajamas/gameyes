# Diff Summary
Source: W1-8 — `tech-ac.md` (BA Agent 1.0), as amended by `decisions.md`
DECISION-1 and DECISION-2
Date: 2026-08-05
Branch: claude/questloggd-week1-item8-sosqs6
Commit: 036015f0dd5bc980dd4e97277ea11d1d9f84a4ff

## Files created
lib/config/route/pending_route_store.dart — `@singleton` in-memory holder of the
  one pending `PageRouteInfo`; `remember`/`take`.
lib/config/route/auth_status_listener.dart — `@singleton` `ChangeNotifier`
  owning the single `ObserveAuthStatusUseCase` subscription and the
  fail-closed, notify-only-on-change `isSignedIn` flag.
lib/config/route/guards/auth_guard.dart — `@singleton` `AutoRouteGuard`:
  allow when signed in, otherwise record the pending route and
  `replaceAll` to `/auth` or `/onboarding` per the seen flag.
lib/config/route/session_navigator.dart — `@singleton` that moves a
  signed-in user off an open path to the pending route, or the tab shell.

## Files modified
lib/core/res/const.dart — added `RouteConstants.auth`, `.legal` and
  `.openPaths`.
lib/config/route/auto_route_config.dart — `AppRouter` now takes `AuthGuard`
  via constructor; guard applied to `/`, `/game-detail`, `/tracker-detail`,
  `/task-detail`, `/image-view`; `OnboardingGuard()` removed.
lib/bootstrap.dart — starts `AuthStatusListener` and `SessionNavigator`
  after `configureDependencies()`, before `runApp`.
lib/main.dart — `AppRouter.config()` now passes
  `reevaluateListenable: getIt<AuthStatusListener>()`.
lib/core/di/service_locator.config.dart — regenerated: wires the four new
  singletons and `AppRouter`'s new constructor parameter.

## Files deleted
lib/config/route/guards/onboarding_guard.dart — decision subsumed by
  `AuthGuard`; confirmed its only reference was the removed `guards:` entry.

## Test files
test/cubit/auth/pending_route_store_test.dart — empty store, remember/take,
  overwrite on second remember, clear on take.
test/cubit/auth/auth_status_listener_test.dart — fail-closed default, signed
  in/out mapping, single subscription on repeated `start()`, later emissions,
  notify-only-on-change, stream error handled as signed out, stops listening
  after `dispose()`. `@GenerateMocks([ObserveAuthStatusUseCase])`.
test/cubit/auth/auth_guard_test.dart — all four `onNavigation` branches
  (signed-in passthrough, seen→`/auth`, unseen/absent→`/onboarding`),
  pending-route recording and overwrite, and that the seen flag is never
  written. `@GenerateMocks([StackRouter])`, a real `NavigationResolver` over
  a `Completer` and a hand-built `RouteMatch`, `SharedPreferences
  .setMockInitialValues`.
test/cubit/auth/session_navigator_test.dart — pending-route resume, fallback
  to the tab shell, resume after the onboarding hop, no-op on signed-out and
  on a guarded path, no-op on a repeated signed-in status, `replaceAll`
  never `push`. Uses a hand-written `_FakeAppRouter` in place of a mock (see
  Deviations).

All twenty-eight new tests pass.

## Self-corrections
File: test/cubit/auth/session_navigator_test.dart — Error: `@GenerateMocks`
(and `@GenerateNiceMocks`) on `AppRouter` crashes `build_runner`
(`mockito:mockBuilder`, `Bad state: No element` in
`source_gen`'s `ConstantReader.revive()`), reproduced even for a bare
`RootStackRouter` subclass with no project code — an environment/toolchain
issue, not a code defect. — Fix: used a hand-written `_FakeAppRouter extends
AppRouter` overriding only `currentPath`, `replaceAll` and `push`, recording
calls for assertion instead of `verify(...)`. — Attempts: 3 (bare
`@GenerateMocks`, `@GenerateNiceMocks`, then the fake).

File: test/cubit/auth/auth_guard_test.dart — Error: two tests called
`SharedPreferences.getInstance()` via `buildGuard()` before
`setMockInitialValues` had been called in that test, throwing "Binding has
not yet been initialized". — Fix: call `SharedPreferences
.setMockInitialValues({})` in the shared `setUp`. — Attempts: 1.

## Deviations from implementation plan
`test/cubit/auth/session_navigator_test.dart` does not mock `AppRouter` via
`@GenerateMocks` as `code-plan.md` describes. Mockito's builder cannot
generate a mock for any `RootStackRouter` subclass in this project's pinned
analyzer/source_gen/mockito versions — confirmed with a minimal
reproduction outside this feature's code, and consistent with the existing
codebase, which mocks `StackRouter` (abstract) in `auth_screen_test.dart`
and `welcome_screen_test.dart` but never `AppRouter`/`RootStackRouter`. A
hand-written `_FakeAppRouter` stands in instead, recording `replaceAll`/
`push` calls for assertion. No production code, no acceptance criterion,
and no other test file's mocking approach is affected.

## Verification against baseline
`flutter analyze`: 38 issues (0 errors, 2 warnings, 36 info) — identical to
the recorded baseline (`0 errors, 2 warnings, 36 info`); none of the 38 are
in a file this run touched.

`flutter test`: 176 passed, 13 failed (189 total) — baseline was 148 passed,
13 failed (161 total). The 13 failures are the same recorded pre-existing
set (`test/api/games`, `test/api/game_detail`, `test/cubit/games`,
`test/cubit/game_detail`, `test/repository/tracker`,
`test/widget_test.dart`), unchanged in count and file. All 28 new tests
(this run's 189 − baseline's 161) pass.

## Acceptance criteria status
W1-8-AC01: satisfied
W1-8-AC02: satisfied
W1-8-AC03: satisfied
W1-8-AC04: satisfied
W1-8-AC05: satisfied
W1-8-AC06: satisfied
W1-8-AC07: satisfied
W1-8-AC08: satisfied
W1-8-AC09: satisfied
W1-8-AC10: satisfied
W1-8-AC11: satisfied
W1-8-AC12: satisfied
W1-8-AC13: satisfied
W1-8-AC14: satisfied
W1-8-AC15: satisfied
W1-8-AC16: satisfied
W1-8-AC17: satisfied
W1-8-AC18: satisfied
W1-8-AC19: satisfied — no snackbar/dialog/banner added, no `.arb` edit
W1-8-AC20: satisfied — paths, children, order and `initial: true` unchanged

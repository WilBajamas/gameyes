# Task Brief
Source: W1-8 — `tech-ac.md` (BA Agent 1.0), as amended by `decisions.md`
DECISION-1 and DECISION-2
Date: 2026-08-05

Naming updated 2026-08-05 per `code-plan.md ## Approved feedback delta`
(`AuthStatusWatcher` → `AuthStatusListener` and its file/test names). That
section is authoritative on any conflict.

## Context

Adds one auth guard to the router plus the small session plumbing it needs, so
protected routes require a signed-in status, a status change re-routes the
running app without a restart, and a deep link followed while signed out is
resumed after sign-in.

## Testing mode

`coverage` — Rule applied: first match in the Tech Lead skill's list —
"auth/authorisation". The guard is the app's only authorisation boundary and a
wrong decision either leaks a protected screen or locks a paying user out of the
app, so every branch gets a unit test.

## File allowlist

### CREATE NEW
lib/config/route/pending_route_store.dart — in-memory record of the route a
  blocked navigation was heading to.
lib/config/route/auth_status_listener.dart — app-lifetime `ChangeNotifier`
  owning the single auth-status subscription and the synchronous signed-in flag.
lib/config/route/guards/auth_guard.dart — the `AutoRouteGuard`: allow, or record
  and redirect to sign-in / welcome.
lib/config/route/session_navigator.dart — moves the user off the sign-in flow to
  the pending route (or the tab shell) when they sign in.

### MODIFY EXISTING
lib/core/res/const.dart — add `auth`, `legal` and the set of open paths to
  `RouteConstants`.
lib/config/route/auto_route_config.dart — inject `AuthGuard`, apply it to `/` and
  the four content routes, drop `OnboardingGuard`.
lib/config/route/guards/onboarding_guard.dart — **delete this file**; its
  decision is subsumed by `AuthGuard` (see `tdd.md ## Reuse decisions`).
lib/bootstrap.dart — start the auth status listener and the session navigator
  before `runApp`.
lib/main.dart — pass the auth status listener to
  `config(reevaluateListenable:)`.

### TEST FILES
test/cubit/auth/pending_route_store_test.dart — remembering, overwriting and
  taking the pending route.
test/cubit/auth/auth_status_listener_test.dart — default before any emission,
  one subscription, mapping of each emission, error handling, when it notifies.
test/cubit/auth/auth_guard_test.dart — the guard's four branches and what it
  records and replaces.
test/cubit/auth/session_navigator_test.dart — signed-in handling per current
  path, pending route resumption, fallback to the tab shell.

Test-folder note: `testing-conventions.md` names five layer folders and none of
them is "routing". These four classes are app/state-layer glue consumed by the
router, so their tests go under `test/cubit/auth/` alongside
`sign_in_cubit_test.dart`. Do not create `test/config/` or mirror `lib/`.

## Implementation plan

Step 1: Create `lib/config/route/pending_route_store.dart` — `@singleton` class
holding one nullable `PageRouteInfo`; `remember(route)` overwrites
unconditionally, `take()` returns and clears in one call. No persistence.

Step 2: Create `lib/config/route/auth_status_listener.dart` — `@singleton`
`ChangeNotifier` named `AuthStatusListener`, taking `ObserveAuthStatusUseCase`.
Field defaults to not signed in. `start()` subscribes once and returns early if
a subscription already exists. Map each emission with an exhaustive `switch` on
`AuthStatusEntity` (`AuthSignedIn` / `AuthSignedOut`); the subscription's
`onError` is handled as signed out. Notify listeners **only when the flag
changes value**. Cancel the subscription in `dispose()`.

Step 3: Create `lib/config/route/guards/auth_guard.dart` — `@singleton` class
extending `AutoRouteGuard`, constructor-injected with `AuthStatusListener`,
`SharedPreferences` and `PendingRouteStore`. Synchronous `onNavigation`: if
signed in, `resolver.next()` and return — do not touch the store and do not use
`overrideNext`. Otherwise `remember(resolver.route.toPageRouteInfo())`,
`resolver.next(false)`, then `router.replaceAll([...])` with `const AuthRoute()`
when `SharedPreferences.getBool(StorageConstants.firstUseKey)` is `true`, else
`const OnboardingRoute()`. Never write that flag. Never call `getIt` here.

Step 4: Modify `lib/core/res/const.dart` — add `auth = '/auth'`,
`legal = '/legal'` and a `static const` set of the three open paths
(`onboarding`, `auth`, `legal`) to `RouteConstants`. Leave every existing entry
alone, including the ones whose values no longer match the route table.

Step 5: Create `lib/config/route/session_navigator.dart` — `@singleton` taking
`AuthStatusListener`, `PendingRouteStore` and `AppRouter`; hold the store in a
field named `_pendingRoutesStore`. `start()` registers a listener on the auth
status listener. In the handler: return unless signed in; return unless
`AppRouter.currentPath` is in the open-paths set; otherwise
`replaceAll([store.take() ?? const HomeRoute()])`. Pass `HomeRoute` no children
so the tab shell keeps its existing default tab.

Step 6: Modify `lib/config/route/auto_route_config.dart` — give `AppRouter` a
constructor taking `AuthGuard`, put that guard in `guards:` on `/`,
`/game-detail`, `/tracker-detail`, `/task-detail` and `/image-view`, and remove
the `OnboardingGuard()` entry and its import. Change nothing else: same paths,
same five children in the same order, `initial: true` still on `/`, no guards on
`/onboarding`, `/auth`, `/legal`.

Step 7: Delete `lib/config/route/guards/onboarding_guard.dart`. Confirm first
that `auto_route_config.dart` is its only remaining reference.

Step 8: Modify `lib/bootstrap.dart` — after `configureDependencies()`, call
`start()` on `AuthStatusListener` and then on `SessionNavigator`, before
`runApp`. Neither call is awaited; do not block startup on an auth emission.

Step 9: Modify `lib/main.dart` — pass
`reevaluateListenable: getIt<AuthStatusListener>()` to
`getIt<AppRouter>().config()`. `main_prod.dart` reuses `MyApp`; leave it alone.

Generation checkpoint: run `dart run build_runner build
--delete-conflicting-outputs` — regenerates `service_locator.config.dart` for
the four new injectables and `auto_route_config.gr.dart` for the route change.
Both regenerated files are an expected part of the diff.

Step 10: Create `test/cubit/auth/pending_route_store_test.dart`.

Step 11: Create `test/cubit/auth/auth_status_listener_test.dart` — mock
`ObserveAuthStatusUseCase` via `@GenerateMocks`, drive it with a
`StreamController`.

Step 12: Create `test/cubit/auth/auth_guard_test.dart` — mock `StackRouter` via
`@GenerateMocks`; build a real `NavigationResolver` around a `Completer` and a
`RouteMatch`; use `SharedPreferences.setMockInitialValues` for the flag.

Step 13: Create `test/cubit/auth/session_navigator_test.dart` — mock `AppRouter`
via `@GenerateMocks` and stub `currentPath`.

Generation checkpoint: run `dart run build_runner build
--delete-conflicting-outputs` again for the four `*.mocks.dart` files, before
running any test.

Step 14: Run `flutter analyze` and `flutter test`. Compare against
`orchestrator-state.md`, quoted verbatim:
  - `Analyzer baseline: 0 errors, 2 warnings, 36 info (38 issues) — captured
    2026-08-05`
  - `Test baseline: +148 -13 (161 total) — captured 2026-08-05`
  - `Pre-existing test failures: 13 failures across 6 files —
    test/api/games/games_test.dart, test/api/game_detail/game_detail_test.dart,
    test/cubit/games/games_bloc_test.dart,
    test/cubit/game_detail/game_detail_cubit_test.dart,
    test/repository/tracker/tracker_repository_test.dart, test/widget_test.dart.`
  The suite is **not** green at baseline and the analyzer is **not** clean.
  Only a new failure in a file this run touched, or a new analyzer error or
  warning, is this run's regression. `test/widget_test.dart` was already failing
  and pumps `MyApp` without DI — do not "fix" it.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: W1-8-AC01 through W1-8-AC20 (all twenty).

## Constraints

- **No new package.** Everything used here — `auto_route` 11.1.0
  (`AutoRouteGuard`, `NavigationResolver`, `RouteMatch.toPageRouteInfo()`,
  `config(reevaluateListenable:)`), `injectable`, `get_it`,
  `shared_preferences`, `flutter/foundation`'s `ChangeNotifier` — is already in
  `pubspec.yaml`. If something seems to need a package, escalate.
- **Never call `getIt<T>()` inside these classes** (`flutter-arch.md`) —
  constructor injection only. `bootstrap.dart` and `main.dart` are the only
  places `getIt` appears in this diff. The deleted `OnboardingGuard` did call
  `getIt` internally; do not carry that pattern forward.
- **Never edit a generated file** — `*.gr.dart`, `*.config.dart`, `*.mocks.dart`
  are build_runner output. A wrong generated file means a wrong annotation.
  Never run `flutter gen-l10n`.
- **No new localisation key and no `.arb` edit** (W1-8-AC19). A forced return to
  sign-in is silent — no snackbar, dialog or banner.
- **Never write `StorageConstants.firstUseKey`.** This run reads it only.
- Guards go through `resolver` / `router`; never `Navigator.push`/`pop`.
- `dart-style.md`: single quotes, trailing commas on multi-line argument lists,
  80-character lines, no `dynamic`, no `var` for fields, no `late` without a
  reason, exhaustive `switch` on sealed types with no `default:`, constants only
  inside the `*Constants` classes.
- Comments per `execution.md` and `project-conventions.md`: plain English, only
  where the reason is not obvious. The two that earn their place are why
  `AuthStatusListener` notifies only on a change, and why the guard records
  before it redirects. Do not doc-comment every field.
- `execution.md`: only unit and widget tests, **never a golden test**. Do not
  weaken or delete an existing test to make the suite pass.
- Do not restructure `lib/core/`, do not change how DI, routing or theming work
  as mechanisms, and do not touch any file outside the allowlist —
  `pubspec.yaml` is read-only.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to
make tests pass. Do not add packages to `pubspec.yaml` or touch files outside
the allowlist — escalate instead.

Note for the guard and re-evaluation specifically: an annotated source that does
not analyze before build_runner has run is expected state, not a failure, and
does not count against the budget.

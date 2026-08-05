# Technical Design Document
Source: W1-8 — `tech-ac.md` (BA Agent 1.0), as amended by `decisions.md`
DECISION-1 and DECISION-2
Date: 2026-08-05

## Feature summary

The router gains one `AutoRouteGuard` (`AuthGuard`) applied to `/` and the four
root-level content routes. The guard reads a synchronously-available auth status
from an app-lifetime `ChangeNotifier` (`AuthStatusWatcher`) that owns the single
subscription to the existing `ObserveAuthStatusUseCase` stream, and reads the
existing `first_use` flag from the already-injected `SharedPreferences`. A
blocked navigation is recorded in an in-memory `PendingRouteStore` as a
`PageRouteInfo` (which carries args, path params and query params) and the stack
is replaced with `/auth` or `/onboarding`. The watcher is handed to auto_route as
`config(reevaluateListenable: ...)`, so a signed-out emission re-runs the guards
on the live stack with no restart. A `SessionNavigator` listens to the same
watcher and handles the signed-in direction: when the app is sitting on an
unguarded sign-in-flow path it replaces the stack with the pending route, or with
the tab shell when nothing is pending. No new package, no new screen, no new
localisation key.

## Layer map

Layers in play for this feature: ROUTING (route table + guard), STATE
(app-lifetime notifier + in-memory store + navigation listener), STARTUP
(bootstrap/`MaterialApp.router` wiring). No API, model, repository, use case, or
UI-widget layer work.

[W1-8-AC01]: routing (route table), routing (guard)
[W1-8-AC02]: routing (route table — assert absence of guard)
[W1-8-AC03]: routing (guard), state (watcher)
[W1-8-AC04]: routing (guard), state (watcher), storage (SharedPreferences read)
[W1-8-AC05]: routing (guard), state (watcher), storage (SharedPreferences read)
[W1-8-AC06]: routing (route table — OnboardingGuard removal), routing (guard)
[W1-8-AC07]: state (watcher default + synchronous read), routing (guard)
[W1-8-AC08]: routing (guard), state (pending route store)
[W1-8-AC09]: routing (guard), routing (route table), state (pending route store)
[W1-8-AC10]: state (session navigator), state (pending route store)
[W1-8-AC11]: state (session navigator), routing (generated `HomeRoute`)
[W1-8-AC12]: state (pending route store lifetime)
[W1-8-AC13]: state (watcher), startup (bootstrap)
[W1-8-AC14]: state (watcher), startup (`reevaluateListenable`), routing (guard)
[W1-8-AC15]: routing (guard — stack replace), state (session navigator — stack replace)
[W1-8-AC16]: routing (route table — no guards on the three open routes), state (watcher de-dupe)
[W1-8-AC17]: state (watcher de-dupe), state (session navigator path check)
[W1-8-AC18]: state (watcher — stream values and `onError` only)
[W1-8-AC19]: none — satisfied by adding nothing (no snackbar, no `.arb` change)
[W1-8-AC20]: routing (route table — paths, children, order, initial untouched)

## Data layer

### API contracts
None. No criterion maps to the API layer; nothing in this feature performs a
network call. The auth session itself is item 5's data layer and is consumed
only through its existing domain stream.

### Models
None created or modified. The pending route is held as auto_route's own
`PageRouteInfo`, not as a project model — a DTO would have to re-encode
`args`/`params`/`queryParams` that `RouteMatch.toPageRouteInfo()` already
carries losslessly, and the four content routes take object args
(`(int, String, String?)`, `TrackerSavedGameEntity`, `TrackerTaskEntity`,
`(List<String?>, int)`) that no path string can reconstruct.

### Repositories
None created or modified. `AuthRepository` /`AuthRepositoryImpl` are consumed
unchanged through the existing use case.

## Domain layer

No use case is created or modified.

Reused: `ObserveAuthStatusUseCase` (`lib/features/auth/domain/use_cases/
observe_auth_status_use_case.dart`) — input: none; returns
`Stream<AuthStatusEntity>`; calls `AuthRepository.authStatusChanges`. It is the
only permitted entry point to auth status for this feature (W1-8-AC18: no
session or token internals are read).

## State layer

All three classes below are app-lifetime `@singleton`s. Global scope is
criterion-backed: W1-8-AC13 requires a subscription that lives for the life of
the app, W1-8-AC12 requires the pending route to survive route replacement
during the onboarding hop, and W1-8-AC14 requires a redirect from whatever
screen is on top. None of them is provided into the widget tree, so the
screen-scoped `BlocProvider` convention in `project-conventions.md` is not
displaced.

AuthStatusWatcher (create) — `lib/config/route/auth_status_watcher.dart` —
scope: global (W1-8-AC13) — extends `ChangeNotifier`, annotated `@singleton`.
  Depends on: `ObserveAuthStatusUseCase` (constructor injection).
  State: one `bool` — signed in or not — defaulting to **not signed in** before
  any emission (W1-8-AC07, fail closed), exposed as a synchronous getter so a
  guard can decide without awaiting.
  `start()` subscribes exactly once and is a no-op if already subscribed
  (W1-8-AC13 second failure case: no double handling). Called from
  `bootstrap.dart` before `runApp`.
  Every emission is mapped through an exhaustive `switch` on the sealed
  `AuthStatusEntity` (`AuthSignedIn` / `AuthSignedOut`); a stream error is
  handled as signed-out (W1-8-AC18 second failure case).
  Listeners are notified **only when the value actually changes**. This is what
  makes W1-8-AC17 and W1-8-AC16 structural rather than incidental: a repeated
  signed-out emission (Supabase replays state at launch and on token refresh)
  produces no guard re-evaluation at all, so an in-progress sign-in on `/auth`
  is never interrupted and no duplicate route can be pushed. The subscription
  still receives every emission, which is what W1-8-AC13 asks for.

PendingRouteStore (create) — `lib/config/route/pending_route_store.dart` —
scope: global (W1-8-AC12) — annotated `@singleton`, plain class, no framework
base.
  Holds a single nullable `PageRouteInfo`. `remember(route)` overwrites
  unconditionally (W1-8-AC08 "replacing any previously recorded pending route").
  `take()` returns the record and clears it in one step, so a resumed route can
  never be resumed twice (W1-8-AC10 second failure case).
  In memory only, never persisted (ASSUMPTION 10).

SessionNavigator (create) — `lib/config/route/session_navigator.dart` —
scope: global (W1-8-AC10, W1-8-AC11) — annotated `@singleton`.
  Depends on: `AuthStatusWatcher`, `PendingRouteStore`, `AppRouter`.
  `start()` adds itself as a listener on the watcher; called from
  `bootstrap.dart`. This is the signed-in direction that DECISION-2 put in
  scope, and it is deliberately *not* inside the watcher: `AppRouter` already
  depends on `AuthGuard` which depends on the watcher, so a watcher that knew
  about the router would close a dependency cycle in the DI graph.
  On notification: ignores anything but signed-in; then ignores the emission
  unless `AppRouter.currentPath` is one of the three open paths
  (`/onboarding`, `/auth`, `/legal`) — that single condition is what makes a
  repeat signed-in emission a no-op for a user already inside the app
  (W1-8-AC17) while still moving a user off the sign-in screen (W1-8-AC11 first
  failure case). Then it takes the pending route and replaces the whole stack
  with it, falling back to `const HomeRoute()` when nothing is pending
  (W1-8-AC10, W1-8-AC11). Replacing rather than pushing keeps the sign-in screen
  off the back stack, consistent with W1-8-AC15.
  `HomeRoute` is pushed with no children, so `AutoTabsRouter` in `HomeScreen`
  selects its existing default tab — the initial tab is not restated here
  (W1-8-AC11, W1-8-AC20).

## Routing layer

AuthGuard (create) — `lib/config/route/guards/auth_guard.dart` — annotated
`@singleton`, extends `AutoRouteGuard`.
  Depends on: `AuthStatusWatcher`, `SharedPreferences`, `PendingRouteStore` —
  all constructor-injected. It does **not** call `getIt` internally, unlike the
  `OnboardingGuard` it replaces; `AppRouter` takes the guard through its own
  constructor instead, which is what `flutter-arch.md` requires and what makes
  the guard unit-testable.
  `onNavigation` is synchronous. Signed in → `resolver.next()` with no
  override, so arguments reach the destination untouched (W1-8-AC03). Otherwise
  → record `resolver.route.toPageRouteInfo()` in the store (W1-8-AC08),
  `resolver.next(false)` to abort, then `router.replaceAll([...])` with
  `const AuthRoute()` when the `first_use` flag is `true`, else
  `const OnboardingRoute()` (W1-8-AC04, W1-8-AC05, W1-8-AC15). The flag is only
  read, never written (out of scope, ASSUMPTION 8).
  During a guard re-evaluation auto_route walks the live stack from the root
  outwards, so for a stack like `[/, /game-detail]` the deepest blocked route is
  the last one recorded — which is the screen the user was actually on.

AppRouter (modify) — `lib/config/route/auto_route_config.dart`
  - Gains a constructor taking `AuthGuard`; injectable wires it because both are
    registered singletons. The `@singleton @AutoRouterConfig` annotations,
    `replaceInRouteName`, and every path stay exactly as they are (W1-8-AC20).
  - `guards: [authGuard]` on `/` (which covers its five children — auto_route
    evaluates the parent's guards when a child is targeted) and on
    `/game-detail`, `/tracker-detail`, `/task-detail` and `/image-view`
    (W1-8-AC01).
  - `/onboarding`, `/auth` and `/legal` keep no guards (W1-8-AC02, W1-8-AC16).
  - `OnboardingGuard()` is removed from `/`. See "Reuse decisions" below — this
    is the one design call in this plan that a reviewer should look at.

OnboardingGuard (delete) — `lib/config/route/guards/onboarding_guard.dart` —
its only reference is the `guards:` entry being replaced.

## Startup wiring

bootstrap.dart (modify) — starts `AuthStatusWatcher` then `SessionNavigator`
before `runApp`, next to the existing `SupabaseConnectionChecker` line. Starting
the subscription before the first frame gives the first emission a good chance
to land before the router resolves the initial route; W1-8-AC07's fail-closed
default is what covers the case where it does not.

main.dart (modify) — `getIt<AppRouter>().config()` gains
`reevaluateListenable: getIt<AuthStatusWatcher>()`. This is the whole of the
reactive redirect: auto_route calls `reevaluateGuards()` on every notification,
which re-runs `AuthGuard` against the live stack (W1-8-AC13, W1-8-AC14). A stack
made only of open routes has no guards to re-run, so nothing moves (W1-8-AC16).
`main_prod.dart` reuses `MyApp` and needs no change.

## UI layer

### Screens
None created or modified. `AuthScreen`, `OnboardingScreen`, `HomeScreen` and the
four detail screens are the destinations of this work, not its subject
(`tech-ac.md ## Out of scope`).

### Widgets
None. W1-8-AC19 is met by adding no snackbar, dialog or banner, and therefore no
`.arb` key and no `S` regeneration.

## Reuse decisions

- `ObserveAuthStatusUseCase` at `lib/features/auth/domain/use_cases/` — the
  sanctioned read of auth status; no new use case, and no direct repository or
  session access (W1-8-AC18).
- `SharedPreferences` + `StorageConstants.firstUseKey` at `lib/core/res/
  const.dart` — the existing onboarding-seen flag, injected per
  `flutter-arch.md`'s "no wrapper" rule. Read only.
- Generated `AuthRoute`, `OnboardingRoute`, `HomeRoute` from
  `auto_route_config.gr.dart` — no route class is hand-written.
- auto_route's `RouteMatch.toPageRouteInfo()` and
  `config(reevaluateListenable:)` — both are the package's own mechanisms for
  exactly this problem; nothing is reimplemented.
- `RouteConstants` at `lib/core/res/const.dart` gains `auth`, `legal` and the
  set of open paths rather than a new constants class, per `dart-style.md`
  ("no bare top-level constants").

**`OnboardingGuard` is replaced, not reused, and this is deliberate.** Its
current body sends *anyone* whose `first_use` flag is unset to `/onboarding`,
including a signed-in user — precisely the defect W1-8-AC06 names, and the
reason ASSUMPTION 1 was given precedence over ASSUMPTION 8 in `tech-ac.md`.
Keeping it in the chain alongside the new guard would require it to read auth
status too (two guards reading the same state, and both needing to record
pending routes), and it would have to be added to the four content routes as
well, since W1-8-AC05 applies there. Folding the single decision "where does a
signed-out visitor go" into one guard is the smaller, more testable design.
ASSUMPTION 8's substance survives: the welcome flow is still where a signed-out,
first-time user lands, and nothing in this run writes the `first_use` flag.

## Out of scope

- Any screen the guard routes to, and any change to `SignInCubit` or
  `WelcomeCubit` — they already exist and already do their jobs
  (`tech-ac.md ## Out of scope`).
- Writing the `first_use` flag; token refresh and session persistence (item 5);
  provider credentials (items 0.3/0.4/0.6).
- Persisting the pending route across a process restart (ASSUMPTION 10).
- Any user-facing string or `.arb` edit (W1-8-AC19).
- Golden tests, per `execution.md`.
- The pre-existing `RouteConstants` entries whose values do not match the real
  route paths (`gameDetail = '/game_detail'` vs. the route table's
  `/game-detail`). They are untouched; nothing in this design reads them.

## Open questions

NONE.

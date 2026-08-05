# Code Plan
Source: W1-8 — `tech-ac.md` (BA Agent 1.0), as amended by `decisions.md`
DECISION-1 and DECISION-2
Date: 2026-08-05

Skeletons only. Where `task-brief.md` and this file disagree, `task-brief.md`
wins — except for `## Approved feedback delta` at the foot of this file, which
wins over both.

## CREATE NEW

### lib/config/route/pending_route_store.dart

```dart
import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

/// The route a blocked navigation was heading to, kept until the person
/// signs in. Not saved anywhere, so closing the app forgets it.
@singleton
class PendingRouteStore {
  PageRouteInfo? _route;

  void remember(PageRouteInfo route) => _route = route;

  PageRouteInfo? take() {
    final route = _route;
    _route = null;
    return route;
  }
}
```

### lib/config/route/auth_status_listener.dart

```dart
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/auth_status_entity.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/use_cases/observe_auth_status_use_case.dart';
import 'package:injectable/injectable.dart';

@singleton
class AuthStatusListener extends ChangeNotifier {
  AuthStatusListener(this._observeAuthStatus);

  final ObserveAuthStatusUseCase _observeAuthStatus;
  StreamSubscription<AuthStatusEntity>? _subscription;

  // Until the auth service says otherwise, treat the person as signed out -
  // that way a protected screen is never shown to someone we cannot vouch for.
  bool _signedIn = false;

  bool get isSignedIn => _signedIn;

  void start() {
    if (_subscription != null) return;
    _subscription = _observeAuthStatus().listen(
      _handle,
      onError: (_) => _handle(const AuthStatusEntity.signedOut()),
    );
  }

  void _handle(AuthStatusEntity status) {
    final signedIn = switch (status) {
      AuthSignedIn() => true,
      AuthSignedOut() => false,
    };
    // Supabase repeats the current status on launch and on every token
    // refresh. Only a real change should move anyone off the screen they
    // are on, or a sign-in half-finished would be thrown away.
    if (signedIn == _signedIn) return;
    _signedIn = signedIn;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
```

### lib/config/route/guards/auth_guard.dart

```dart
import 'package:auto_route/auto_route.dart';
import 'package:gaming_library_assessment_flutter/config/route/auth_status_listener.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/config/route/pending_route_store.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class AuthGuard extends AutoRouteGuard {
  AuthGuard(this._authStatus, this._preferences, this._pendingRoutes);

  final AuthStatusListener _authStatus;
  final SharedPreferences _preferences;
  final PendingRouteStore _pendingRoutes;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_authStatus.isSignedIn) {
      resolver.next();
      return;
    }

    // Remember where they were going before sending them away, so signing in
    // can put them back on it - arguments and all.
    _pendingRoutes.remember(resolver.route.toPageRouteInfo());
    resolver.next(false);

    final seenWelcome =
        _preferences.getBool(StorageConstants.firstUseKey) ?? false;
    router.replaceAll([
      if (seenWelcome) const AuthRoute() else const OnboardingRoute(),
    ]);
  }
}
```

### lib/config/route/session_navigator.dart

```dart
import 'package:gaming_library_assessment_flutter/config/route/auth_status_listener.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/config/route/pending_route_store.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:injectable/injectable.dart';

@singleton
class SessionNavigator {
  SessionNavigator(this._authStatus, this._pendingRoutesStore, this._router);

  final AuthStatusListener _authStatus;
  final PendingRouteStore _pendingRoutesStore;
  final AppRouter _router;

  void start() => _authStatus.addListener(_onAuthStatusChanged);

  void _onAuthStatusChanged() {
    if (!_authStatus.isSignedIn) return;
    // Someone already inside the app stays where they are; only a person
    // waiting on the welcome or sign-in screens is moved along.
    if (!RouteConstants.openPaths.contains(_router.currentPath)) return;

    _router.replaceAll([_pendingRoutesStore.take() ?? const HomeRoute()]);
  }
}
```

## MODIFY EXISTING

### lib/core/res/const.dart

```dart
class RouteConstants {
  static const root = '/';
  // ... existing entries unchanged ...
  static const onboarding = '/onboarding';
  // ... existing entries unchanged ...

  static const auth = '/auth';
  static const legal = '/legal';

  /// The only paths reachable without signing in.
  static const openPaths = {onboarding, auth, legal};
}
```

### lib/config/route/auto_route_config.dart

```dart
import 'package:auto_route/auto_route.dart';
import 'package:gaming_library_assessment_flutter/config/route/guards/auth_guard.dart';
import 'package:injectable/injectable.dart';

import 'auto_route_config.gr.dart';

@singleton
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter(this._authGuard);

  final AuthGuard _authGuard;

  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '/onboarding', page: OnboardingRoute.page),
    AutoRoute(path: '/auth', page: AuthRoute.page),
    AutoRoute(path: '/legal', page: AppWebViewRoute.page),
    AutoRoute(
      path: '/',
      page: HomeRoute.page,
      initial: true,
      guards: [_authGuard],
      children: [
        // unchanged: featured, games, tracker, browse, settings
      ],
    ),
    AutoRoute(
      path: '/game-detail',
      page: GameDetailRoute.page,
      guards: [_authGuard],
    ),
    AutoRoute(
      path: '/image-view',
      page: ImageRouteView.page,
      guards: [_authGuard],
    ),
    AutoRoute(
      path: '/tracker-detail',
      page: TrackerGameDetailRoute.page,
      guards: [_authGuard],
    ),
    AutoRoute(
      path: '/task-detail',
      page: TaskDetailRoute.page,
      guards: [_authGuard],
    ),
  ];
}
```

### lib/config/route/guards/onboarding_guard.dart

Deleted. `AuthGuard` makes the same welcome-screen decision, and makes it only
for a signed-out person — which is what W1-8-AC06 requires and what this file
gets wrong today.

### lib/bootstrap.dart

```dart
  FlavorConfig.initialise(flavor);
  await configureDependencies();
  // Start listening for sign-in and sign-out before the first screen is
  // built, so the router knows where the person stands as early as it can.
  getIt<AuthStatusListener>().start();
  getIt<SessionNavigator>().start();
  unawaited(getIt<SupabaseConnectionChecker>().check());
  runApp(app);
```

### lib/main.dart

```dart
      routerConfig: getIt<AppRouter>().config(
        reevaluateListenable: getIt<AuthStatusListener>(),
      ),
```

## TEST FILES

### test/cubit/auth/pending_route_store_test.dart
- `'should return null when nothing has been remembered'` — a fresh store's
  `take()` is null. [W1-8-AC11]
- `'should return the remembered route when take is called'` — the exact
  `PageRouteInfo`, args included. [W1-8-AC08]
- `'should keep only the latest route when remember is called twice'` — the
  second overwrites the first. [W1-8-AC08]
- `'should return null on a second take when the route was already taken'` —
  `take()` clears. [W1-8-AC10]

### test/cubit/auth/auth_status_listener_test.dart
`@GenerateMocks([ObserveAuthStatusUseCase])`, driven by a `StreamController`.
- `'should report signed out when no status has been emitted yet'` — the
  fail-closed default. [W1-8-AC07]
- `'should report signed in when a signed-in status is emitted'` /
  `'...signed out when a signed-out status is emitted'`. [W1-8-AC03, AC04]
- `'should subscribe once when start is called twice'` — `verify(...).called(1)`
  on the use case. [W1-8-AC13]
- `'should react to a later emission when several arrive'` — a sign-out after a
  sign-in still flips the flag. [W1-8-AC13]
- `'should notify listeners when the status changes'` /
  `'should not notify listeners when the same status is emitted again'`.
  [W1-8-AC13, AC16, AC17]
- `'should report signed out when the stream emits an error'`. [W1-8-AC18]
- `'should stop listening when disposed'`. [W1-8-AC13]

### test/cubit/auth/auth_guard_test.dart
`@GenerateMocks([StackRouter])`, a real `NavigationResolver` over a `Completer`
and a hand-built `RouteMatch`, `SharedPreferences.setMockInitialValues` for the
flag.
- `'should resolve the navigation when the status is signed in'` — resolver
  continues, `verifyNever` on `replaceAll`. [W1-8-AC03]
- `'should not record a pending route when the navigation is allowed'` — the
  store is untouched. [W1-8-AC09]
- `'should replace the stack with the auth route when signed out and the seen
  flag is true'`. [W1-8-AC04, AC15]
- `'should replace the stack with the onboarding route when signed out and the
  seen flag is absent'` — and the same with the flag `false`. [W1-8-AC05, AC15]
- `'should record the requested route with its arguments when the navigation is
  blocked'`. [W1-8-AC08]
- `'should replace an earlier pending route when a second navigation is
  blocked'`. [W1-8-AC08]
- `'should never write the seen flag'` — the preference is unchanged after a
  blocked navigation. [W1-8-AC06 second failure case]

### test/cubit/auth/session_navigator_test.dart
`@GenerateMocks([AppRouter])`, `currentPath` stubbed, a real
`AuthStatusListener` fed by a `StreamController`.
- `'should navigate to the pending route when a signed-in status arrives on the
  auth path'` — and the record is cleared afterwards. [W1-8-AC10]
- `'should navigate to the tab shell when a signed-in status arrives with no
  pending route'`. [W1-8-AC11]
- `'should resume the pending route when the signed-in status arrives after the
  onboarding hop'` — pending recorded, path `/onboarding` then `/auth`.
  [W1-8-AC12]
- `'should do nothing when a signed-out status arrives'`. [W1-8-AC14, AC16]
- `'should do nothing when a signed-in status arrives on a guarded path'` —
  `currentPath` is `/featured`. [W1-8-AC17]
- `'should do nothing on a repeated signed-in status'` — one navigation only.
  [W1-8-AC17]
- `'should replace the stack rather than push when it navigates'` —
  `replaceAll`, never `push`. [W1-8-AC15]

## Approved feedback delta

Product Owner review, Phase 3 human design gate, 2026-08-05. Naming only — no
design, scope or acceptance-criteria change.

- Rename the class `AuthStatusWatcher` to `AuthStatusListener`, and its file
  from `lib/config/route/auth_status_watcher.dart` to
  `lib/config/route/auth_status_listener.dart`.
- Rename its test file from `test/cubit/auth/auth_status_watcher_test.dart` to
  `test/cubit/auth/auth_status_listener_test.dart`.
- Every reference follows the rename: the `AuthGuard` and `SessionNavigator`
  fields' type and imports, `bootstrap.dart`'s `getIt<AuthStatusListener>()`,
  `main.dart`'s `reevaluateListenable: getIt<AuthStatusListener>()`, and the
  prose in `tdd.md` and `task-brief.md`. The fields holding it keep the name
  `_authStatus` — it still reads correctly.
- Rename `SessionNavigator`'s field `_pendingRoutes` to `_pendingRoutesStore`
  (constructor parameter, field and its one use site).
- Not acted on, flagged for later: `AuthGuard` declares its own field named
  `_pendingRoutes`. The Product Owner asked only about `SessionNavigator`, so
  the guard's field keeps its current name; the two could be aligned in a
  follow-up if consistency is wanted.
- The rest of the design is unchanged and stays approved: guard scope,
  deep-link resume, deletion of `onboarding_guard.dart`, the fail-closed
  default and notify-only-on-change.

The renames above are also applied in place throughout this file, in
`task-brief.md`'s file allowlist and implementation plan, and in `tdd.md`, so
no stale filename reaches the Dev Agent.

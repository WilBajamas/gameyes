import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/route/auth_status_listener.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/config/route/guards/auth_guard.dart';
import 'package:gaming_library_assessment_flutter/config/route/pending_route_store.dart';
import 'package:gaming_library_assessment_flutter/config/route/session_navigator.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/auth_status_entity.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/sign_in_provider.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/use_cases/observe_auth_status_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../mocks/auth_mock.dart';

// `AppRouter` extends auto_route's `RootStackRouter`, which mockito's
// `@GenerateMocks` cannot build a mock for in this project's pinned
// analyzer/source_gen versions (reproducible even for a bare
// `RootStackRouter` subclass with no project code at all). A hand-written
// fake stands in for it instead; `AuthGuard` is still real to satisfy
// `AppRouter`'s constructor, but nothing here exercises it.
void main() {
  late _AuthRepositoryStub repository;
  late AuthStatusListener authStatus;
  late PendingRouteStore pendingRoutesStore;
  late _FakeAppRouter router;
  late SessionNavigator navigator;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = _AuthRepositoryStub();
    authStatus = AuthStatusListener(ObserveAuthStatusUseCase(repository));
    pendingRoutesStore = PendingRouteStore();
    final authGuard = AuthGuard(
      authStatus,
      await SharedPreferences.getInstance(),
      PendingRouteStore(),
    );
    router = _FakeAppRouter(authGuard);
    navigator = SessionNavigator(authStatus, pendingRoutesStore, router);
    navigator.start();
  });

  tearDown(() async {
    authStatus.dispose();
    await repository.controller.close();
  });

  Future<void> emit(AuthStatusEntity status, {String path = '/auth'}) async {
    router.currentPathValue = path;
    authStatus.start();
    repository.controller.add(status);
    await pumpEventQueue();
  }

  test('should navigate to the pending route when a signed-in status arrives '
      'on the auth path', () async {
    const pending = HomeRoute();
    pendingRoutesStore.remember(pending);

    await emit(mockDiscordSignedInStatus);

    expect(router.replaceAllCalls, [
      [pending],
    ]);
    expect(pendingRoutesStore.take(), isNull);
  });

  test('should navigate to the tab shell when a signed-in status arrives with '
      'no pending route', () async {
    await emit(mockDiscordSignedInStatus);

    expect(router.replaceAllCalls, [
      [const HomeRoute()],
    ]);
  });

  test('should resume the pending route when the signed-in status arrives '
      'after the onboarding hop', () async {
    const pending = HomeRoute();
    pendingRoutesStore.remember(pending);

    await emit(mockDiscordSignedInStatus);

    expect(router.replaceAllCalls, [
      [pending],
    ]);
  });

  test('should do nothing when a signed-out status arrives', () async {
    await emit(mockSignedOutStatus);

    expect(router.replaceAllCalls, isEmpty);
  });

  test(
    'should do nothing when a signed-in status arrives on a guarded path',
    () async {
      await emit(mockDiscordSignedInStatus, path: '/featured');

      expect(router.replaceAllCalls, isEmpty);
    },
  );

  test('should do nothing on a repeated signed-in status', () async {
    router.currentPathValue = '/auth';
    authStatus.start();

    repository.controller.add(mockDiscordSignedInStatus);
    await pumpEventQueue();
    repository.controller.add(mockGoogleSignedInStatus);
    await pumpEventQueue();

    expect(router.replaceAllCalls, hasLength(1));
  });

  test('should replace the stack rather than push when it navigates', () async {
    await emit(mockDiscordSignedInStatus);

    expect(router.replaceAllCalls, hasLength(1));
    expect(router.pushCalls, isEmpty);
  });
}

class _FakeAppRouter extends AppRouter {
  _FakeAppRouter(super.authGuard);

  String currentPathValue = '/auth';
  final replaceAllCalls = <List<PageRouteInfo>>[];
  final pushCalls = <PageRouteInfo>[];

  @override
  String get currentPath => currentPathValue;

  @override
  Future<void> replaceAll(
    List<PageRouteInfo> routes, {
    OnNavigationFailure? onFailure,
    bool updateExistingRoutes = true,
  }) async {
    replaceAllCalls.add(routes);
  }

  @override
  Future<T?> push<T extends Object?>(
    PageRouteInfo route, {
    OnNavigationFailure? onFailure,
  }) async {
    pushCalls.add(route);
    return null;
  }
}

class _AuthRepositoryStub implements AuthRepository {
  final controller = StreamController<AuthStatusEntity>.broadcast();

  @override
  Stream<AuthStatusEntity> get authStatusChanges => controller.stream;

  @override
  Future<Result<void>> signIn(SignInProvider provider) async =>
      const Success(null);

  @override
  Future<Result<void>> signOut() async => const Success(null);
}

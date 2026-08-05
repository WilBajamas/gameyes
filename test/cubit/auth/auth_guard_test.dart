import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/route/auth_status_listener.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/config/route/guards/auth_guard.dart';
import 'package:gaming_library_assessment_flutter/config/route/pending_route_store.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/auth_status_entity.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/sign_in_provider.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/use_cases/observe_auth_status_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../mocks/auth_mock.dart';
import 'auth_guard_test.mocks.dart';

@GenerateMocks([StackRouter])
void main() {
  late _AuthRepositoryStub repository;
  late AuthStatusListener authStatus;
  late PendingRouteStore pendingRoutesStore;
  late MockStackRouter router;

  RouteMatch buildMatch({
    (int, String, String?)? gameExtra = const (1, 'game-name', null),
  }) {
    final config = AutoRoute(path: '/game-detail', page: GameDetailRoute.page);
    return RouteMatch(
      config: config,
      segments: const ['game-detail'],
      stringMatch: '/game-detail',
      key: const ValueKey('game-detail'),
      args: GameDetailRouteArgs(gameExtra: gameExtra),
    );
  }

  Future<AuthGuard> buildGuard() async {
    return AuthGuard(
      authStatus,
      await SharedPreferences.getInstance(),
      pendingRoutesStore,
    );
  }

  Future<void> signIn() async {
    authStatus.start();
    repository.controller.add(mockDiscordSignedInStatus);
    await pumpEventQueue();
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = _AuthRepositoryStub();
    authStatus = AuthStatusListener(ObserveAuthStatusUseCase(repository));
    pendingRoutesStore = PendingRouteStore();
    router = MockStackRouter();
  });

  tearDown(() async {
    authStatus.dispose();
    await repository.controller.close();
  });

  test('should resolve the navigation when the status is signed in', () async {
    await signIn();
    final guard = await buildGuard();
    final match = buildMatch();
    final resolver = NavigationResolver(
      router,
      Completer<ResolverResult>(),
      match,
    );

    guard.onNavigation(resolver, router);
    final result = await resolver.future;

    expect(result.continueNavigation, isTrue);
    verifyNever(router.replaceAll(any));
  });

  test(
    'should not record a pending route when the navigation is allowed',
    () async {
      await signIn();
      final guard = await buildGuard();
      final match = buildMatch();
      final resolver = NavigationResolver(
        router,
        Completer<ResolverResult>(),
        match,
      );

      guard.onNavigation(resolver, router);
      await resolver.future;

      expect(pendingRoutesStore.take(), isNull);
    },
  );

  test('should replace the stack with the auth route when signed out and the '
      'seen flag is true', () async {
    SharedPreferences.setMockInitialValues({
      StorageConstants.firstUseKey: true,
    });
    final guard = await buildGuard();
    final match = buildMatch();
    final resolver = NavigationResolver(
      router,
      Completer<ResolverResult>(),
      match,
    );

    guard.onNavigation(resolver, router);
    await resolver.future;

    verify(router.replaceAll([const AuthRoute()])).called(1);
  });

  test('should replace the stack with the onboarding route when signed out '
      'and the seen flag is absent', () async {
    SharedPreferences.setMockInitialValues({});
    final guard = await buildGuard();
    final match = buildMatch();
    final resolver = NavigationResolver(
      router,
      Completer<ResolverResult>(),
      match,
    );

    guard.onNavigation(resolver, router);
    await resolver.future;

    verify(router.replaceAll([const OnboardingRoute()])).called(1);
  });

  test('should replace the stack with the onboarding route when signed out '
      'and the seen flag is false', () async {
    SharedPreferences.setMockInitialValues({
      StorageConstants.firstUseKey: false,
    });
    final guard = await buildGuard();
    final match = buildMatch();
    final resolver = NavigationResolver(
      router,
      Completer<ResolverResult>(),
      match,
    );

    guard.onNavigation(resolver, router);
    await resolver.future;

    verify(router.replaceAll([const OnboardingRoute()])).called(1);
  });

  test('should record the requested route with its arguments when the '
      'navigation is blocked', () async {
    SharedPreferences.setMockInitialValues({
      StorageConstants.firstUseKey: true,
    });
    final guard = await buildGuard();
    final match = buildMatch();
    final resolver = NavigationResolver(
      router,
      Completer<ResolverResult>(),
      match,
    );

    guard.onNavigation(resolver, router);
    await resolver.future;

    expect(pendingRoutesStore.take(), match.toPageRouteInfo());
  });

  test('should replace an earlier pending route when a second navigation is '
      'blocked', () async {
    SharedPreferences.setMockInitialValues({
      StorageConstants.firstUseKey: true,
    });
    final guard = await buildGuard();
    final firstMatch = buildMatch();
    final firstResolver = NavigationResolver(
      router,
      Completer<ResolverResult>(),
      firstMatch,
    );
    guard.onNavigation(firstResolver, router);
    await firstResolver.future;

    final secondMatch = buildMatch(gameExtra: (2, 'other-game', null));
    final secondResolver = NavigationResolver(
      router,
      Completer<ResolverResult>(),
      secondMatch,
    );
    guard.onNavigation(secondResolver, router);
    await secondResolver.future;

    expect(pendingRoutesStore.take(), secondMatch.toPageRouteInfo());
  });

  test('should never write the seen flag', () async {
    SharedPreferences.setMockInitialValues({
      StorageConstants.firstUseKey: true,
    });
    final preferences = await SharedPreferences.getInstance();
    final guard = AuthGuard(authStatus, preferences, pendingRoutesStore);
    final match = buildMatch();
    final resolver = NavigationResolver(
      router,
      Completer<ResolverResult>(),
      match,
    );

    guard.onNavigation(resolver, router);
    await resolver.future;

    expect(preferences.getBool(StorageConstants.firstUseKey), isTrue);
  });
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

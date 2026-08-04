import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/auth_status_entity.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/sign_in_provider.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/auth/presentation/blocs/sign_in_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/auth/presentation/screens/auth_screen.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_screen_test.mocks.dart';

@GenerateMocks([StackRouter])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  late _AuthRepositoryStub repository;
  late MockStackRouter router;

  setUpAll(() async => S.load(const Locale('en')));

  setUp(() {
    repository = _AuthRepositoryStub();
    router = MockStackRouter();
    when(router.push<dynamic>(any)).thenAnswer((_) async => null);
    getIt.registerFactory(() => SignInCubit(SignInUseCase(repository)));
  });

  tearDown(() async => GetIt.instance.reset());

  testWidgets('renders only Discord then Google provider actions', (
    tester,
  ) async {
    await _pumpAuth(tester, router);

    expect(find.text(S.current.auth_title.toUpperCase()), findsOneWidget);
    expect(find.text(S.current.continue_with_discord), findsOneWidget);
    expect(find.text(S.current.continue_with_google), findsOneWidget);
    expect(find.text('LOGO'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text(S.current.continue_with_discord)).dy,
      lessThan(tester.getTopLeft(find.text(S.current.continue_with_google)).dy),
    );
  });

  testWidgets('locks both actions and keeps the active row label visible', (
    tester,
  ) async {
    repository.result = Completer<Result<void>>().future;
    await _pumpAuth(tester, router);

    await tester.tap(find.text(S.current.continue_with_discord));
    await tester.pump();
    await tester.tap(
      find.text(S.current.continue_with_google),
      warnIfMissed: false,
    );

    expect(find.text(S.current.continue_with_discord), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(repository.providers, [SignInProvider.discord]);
  });

  testWidgets('shows provider failures inline and remains retryable', (
    tester,
  ) async {
    repository.result = Future.value(const Failure(ErrorType.unknown()));
    await _pumpAuth(tester, router);

    await tester.tap(find.text(S.current.continue_with_google));
    await tester.pumpAndSettle();

    expect(find.text(S.current.auth_sign_in_error), findsOneWidget);
    repository.result = Future.value(const Success(null));
    await tester.tap(find.text(S.current.continue_with_discord));
    await tester.pumpAndSettle();
    expect(find.text(S.current.auth_sign_in_error), findsNothing);
  });

  testWidgets('passes the temporary URL directly to the app webview route', (
    tester,
  ) async {
    await _pumpAuth(tester, router);

    await tester.tap(find.text(S.current.auth_terms));
    await tester.tap(find.text(S.current.auth_privacy));

    final routes = verify(router.push<dynamic>(captureAny)).captured;
    expect(routes, hasLength(2));
    for (final route in routes.cast<AppWebViewRoute>()) {
      expect(route.args!.url, Uri.parse('https://google.com'));
    }
  });
}

Future<void> _pumpAuth(WidgetTester tester, StackRouter router) async {
  await tester.pumpWidget(
    StackRouterScope(
      controller: router,
      stateHash: 0,
      child: MaterialApp(theme: buildDarkTheme(), home: const AuthScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

class _AuthRepositoryStub implements AuthRepository {
  Future<Result<void>> result = Future.value(const Success(null));
  final providers = <SignInProvider>[];

  @override
  Stream<AuthStatusEntity> get authStatusChanges => const Stream.empty();

  @override
  Future<Result<void>> signIn(SignInProvider provider) {
    providers.add(provider);
    return result;
  }

  @override
  Future<Result<void>> signOut() => throw UnimplementedError();
}

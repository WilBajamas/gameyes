import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/auth_status_entity.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/sign_in_provider.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/auth/presentation/blocs/sign_out_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/auth/presentation/blocs/sign_out_state.dart';
import 'package:gaming_library_assessment_flutter/features/home/presentation/notifier/scroll_notifier.dart';
import 'package:gaming_library_assessment_flutter/features/settings/presentation/screens/settings_screen.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'settings_screen_test.mocks.dart';

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
    getIt.registerSingleton<ScrollNotifier>(ScrollNotifier());
    getIt.registerFactory(() => SignOutCubit(SignOutUseCase(repository)));
  });

  tearDown(() async => GetIt.instance.reset());

  testWidgets(
    'renders the sign-out control alongside the existing settings content',
    (tester) async {
      await _pumpSettings(tester, router);

      expect(find.text(S.current.auth_sign_out), findsOneWidget);
      expect(find.text(S.current.settings), findsNWidgets(2));
    },
  );

  testWidgets('shows a pending indicator while sign-out is loading', (
    tester,
  ) async {
    getIt.unregister<SignOutCubit>();
    getIt.registerFactory<SignOutCubit>(
      () => _LoadingSignOutCubit(SignOutUseCase(repository)),
    );
    await _pumpSettings(tester, router, settle: false);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows nothing and returns to rest when sign-out succeeds', (
    tester,
  ) async {
    repository.result = Future.value(const Success(null));
    await _pumpSettings(tester, router);

    await tester.tap(find.text(S.current.auth_sign_out));
    await tester.pumpAndSettle();

    expect(find.text(S.current.auth_sign_out_error), findsNothing);
  });

  testWidgets('shows the inline error in the section when sign-out fails', (
    tester,
  ) async {
    repository.result = Future.value(const Failure(ErrorType.unknown()));
    await _pumpSettings(tester, router);

    await tester.tap(find.text(S.current.auth_sign_out));
    await tester.pumpAndSettle();

    expect(find.text(S.current.auth_sign_out_error), findsOneWidget);
    expect(find.text(S.current.settings), findsNWidgets(2));
  });

  testWidgets(
    'clears the inline error and retries when the control is tapped again',
    (tester) async {
      repository.result = Future.value(const Failure(ErrorType.unknown()));
      await _pumpSettings(tester, router);

      await tester.tap(find.text(S.current.auth_sign_out));
      await tester.pumpAndSettle();
      expect(find.text(S.current.auth_sign_out_error), findsOneWidget);

      repository.result = Future.value(const Success(null));
      await tester.tap(find.text(S.current.auth_sign_out));
      await tester.pumpAndSettle();

      expect(find.text(S.current.auth_sign_out_error), findsNothing);
      expect(repository.callCount, 2);
    },
  );

  testWidgets('never performs a route action on success or on failure', (
    tester,
  ) async {
    repository.result = Future.value(const Success(null));
    await _pumpSettings(tester, router);
    await tester.tap(find.text(S.current.auth_sign_out));
    await tester.pumpAndSettle();

    repository.result = Future.value(const Failure(ErrorType.unknown()));
    await tester.tap(find.text(S.current.auth_sign_out));
    await tester.pumpAndSettle();

    verifyNever(router.push<dynamic>(any));
    verifyNever(router.replace<dynamic>(any));
    verifyNever(router.pop<dynamic>(any));
  });
}

Future<void> _pumpSettings(
  WidgetTester tester,
  StackRouter router, {
  bool settle = true,
}) async {
  await tester.pumpWidget(
    StackRouterScope(
      controller: router,
      stateHash: 0,
      child: MaterialApp(theme: buildDarkTheme(), home: const SettingsScreen()),
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

class _LoadingSignOutCubit extends SignOutCubit {
  _LoadingSignOutCubit(super.useCase) {
    emit(const SignOutState(status: SignOutStatus.loading));
  }
}

class _AuthRepositoryStub implements AuthRepository {
  Future<Result<void>> result = Future.value(const Success(null));
  int callCount = 0;

  @override
  Stream<AuthStatusEntity> get authStatusChanges => const Stream.empty();

  @override
  Future<Result<void>> signIn(SignInProvider provider) =>
      throw UnimplementedError();

  @override
  Future<Result<void>> signOut() {
    callCount++;
    return result;
  }
}

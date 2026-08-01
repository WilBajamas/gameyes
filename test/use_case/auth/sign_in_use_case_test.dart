import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/sign_in_provider.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/error_mock.dart';
import 'sign_in_use_case_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository authRepository;
  late SignInUseCase signInUseCase;

  setUp(() {
    provideDummy<Result<void>>(const Success(null));
    authRepository = MockAuthRepository();
    GetIt.I.registerSingleton<AuthRepository>(authRepository);
    signInUseCase = SignInUseCase(authRepository);
  });

  tearDown(() async {
    await GetIt.instance.reset();
    reset(authRepository);
  });

  test('should ask the repository to sign in when Discord is chosen', () async {
    when(authRepository.signIn(SignInProvider.discord))
        .thenAnswer((_) async => const Success(null));

    final result = await signInUseCase(SignInProvider.discord);

    verify(authRepository.signIn(SignInProvider.discord));
    expect(result, isA<Success<void>>());
  });

  test('should ask the repository to sign in when Google is chosen', () async {
    when(authRepository.signIn(SignInProvider.google))
        .thenAnswer((_) async => const Success(null));

    final result = await signInUseCase(SignInProvider.google);

    verify(authRepository.signIn(SignInProvider.google));
    expect(result, isA<Success<void>>());
  });

  test('should pass the failure through when the repository fails', () async {
    when(authRepository.signIn(SignInProvider.discord))
        .thenAnswer((_) async => Failure(mockSignInCancelledError));

    final result = await signInUseCase(SignInProvider.discord);

    expect(result, isA<Failure<void>>());
    expect((result as Failure<void>).error, mockSignInCancelledError);
  });
}

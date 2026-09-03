import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/error_mock.dart';
import 'sign_out_use_case_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository authRepository;
  late SignOutUseCase signOutUseCase;

  setUp(() {
    provideDummy<Result<void>>(const Success(null));
    authRepository = MockAuthRepository();
    GetIt.I.registerSingleton<AuthRepository>(authRepository);
    signOutUseCase = SignOutUseCase(authRepository);
  });

  tearDown(() async {
    await GetIt.instance.reset();
    reset(authRepository);
  });

  test('should ask the repository to sign out when called', () async {
    when(authRepository.signOut()).thenAnswer((_) async => const Success(null));

    final result = await signOutUseCase();

    verify(authRepository.signOut());
    expect(result, isA<Success<void>>());
  });

  test('should pass the failure through when the repository fails', () async {
    when(
      authRepository.signOut(),
    ).thenAnswer((_) async => Failure(mockResponseError));

    final result = await signOutUseCase();

    expect(result, isA<Failure<void>>());
    expect((result as Failure<void>).error, mockResponseError);
  });
}

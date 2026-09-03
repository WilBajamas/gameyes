import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/auth_status_entity.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/use_cases/observe_auth_status_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/auth_mock.dart';
import 'observe_auth_status_use_case_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository authRepository;
  late ObserveAuthStatusUseCase observeAuthStatusUseCase;

  setUp(() {
    authRepository = MockAuthRepository();
    GetIt.I.registerSingleton<AuthRepository>(authRepository);
    observeAuthStatusUseCase = ObserveAuthStatusUseCase(authRepository);
  });

  tearDown(() async {
    await GetIt.instance.reset();
    reset(authRepository);
  });

  test(
    'should hand back the repository stream untouched when called',
    () async {
      final source = Stream<AuthStatusEntity>.fromIterable([
        mockSignedOutStatus,
        mockDiscordSignedInStatus,
      ]);
      when(authRepository.authStatusChanges).thenAnswer((_) => source);

      final emitted = await observeAuthStatusUseCase().toList();

      verify(authRepository.authStatusChanges);
      expect(emitted, [mockSignedOutStatus, mockDiscordSignedInStatus]);
    },
  );

  test(
    'should emit nothing extra when the repository stream is empty',
    () async {
      when(
        authRepository.authStatusChanges,
      ).thenAnswer((_) => const Stream<AuthStatusEntity>.empty());

      final emitted = await observeAuthStatusUseCase().toList();

      expect(emitted, isEmpty);
    },
  );
}

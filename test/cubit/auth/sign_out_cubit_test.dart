import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/auth_status_entity.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/sign_in_provider.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/auth/presentation/blocs/sign_out_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/auth/presentation/blocs/sign_out_state.dart';

void main() {
  late _AuthRepositoryStub repository;

  setUp(() => repository = _AuthRepositoryStub());

  test('starts idle with no error', () {
    expect(
      SignOutCubit(SignOutUseCase(repository)).state,
      const SignOutState(),
    );
  });

  blocTest<SignOutCubit, SignOutState>(
    'emits [loading, idle] when sign-out succeeds',
    build: () {
      repository.result = Future.value(const Success(null));
      return SignOutCubit(SignOutUseCase(repository));
    },
    act: (cubit) => cubit.signOut(),
    expect: () => [
      const SignOutState(status: SignOutStatus.loading),
      const SignOutState(),
    ],
    verify: (_) => expect(repository.callCount, 1),
  );

  blocTest<SignOutCubit, SignOutState>(
    'emits [loading, failed] when sign-out fails',
    build: () {
      repository.result = Future.value(const Failure(ErrorType.unknown()));
      return SignOutCubit(SignOutUseCase(repository));
    },
    act: (cubit) => cubit.signOut(),
    expect: () => [
      const SignOutState(status: SignOutStatus.loading),
      const SignOutState(
        status: SignOutStatus.failed,
        error: ErrorType.unknown(),
      ),
    ],
  );

  blocTest<SignOutCubit, SignOutState>(
    'ignores additional taps while sign-out is in flight',
    build: () {
      repository.result = Completer<Result<void>>().future;
      return SignOutCubit(SignOutUseCase(repository));
    },
    act: (cubit) async {
      unawaited(cubit.signOut());
      await Future<void>.delayed(Duration.zero);
      unawaited(cubit.signOut());
    },
    expect: () => [const SignOutState(status: SignOutStatus.loading)],
    verify: (_) => expect(repository.callCount, 1),
  );

  test('clears the previous error when a new attempt starts', () async {
    repository.result = Future.value(const Failure(ErrorType.unknown()));
    final cubit = SignOutCubit(SignOutUseCase(repository));
    addTearDown(cubit.close);

    await cubit.signOut();
    expect(
      cubit.state,
      const SignOutState(
        status: SignOutStatus.failed,
        error: ErrorType.unknown(),
      ),
    );

    final retry = Completer<Result<void>>();
    repository.result = retry.future;
    final retryCall = cubit.signOut();
    expect(cubit.state, const SignOutState(status: SignOutStatus.loading));
    retry.complete(const Success(null));
    await retryCall;
  });

  test(
    'emits nothing when the screen is gone before the result arrives',
    () async {
      final completer = Completer<Result<void>>();
      repository.result = completer.future;
      final cubit = SignOutCubit(SignOutUseCase(repository));

      final signOutCall = cubit.signOut();
      await cubit.close();
      completer.complete(const Success(null));

      await expectLater(signOutCall, completes);
    },
  );
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

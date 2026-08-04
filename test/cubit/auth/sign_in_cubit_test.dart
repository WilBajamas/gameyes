import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/sign_in_provider.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/auth_status_entity.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/auth/presentation/blocs/sign_in_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/auth/presentation/blocs/sign_in_state.dart';

void main() {
  late _AuthRepositoryStub repository;

  setUp(() => repository = _AuthRepositoryStub());

  test('starts idle without an active provider or error', () {
    expect(SignInCubit(SignInUseCase(repository)).state, const SignInState());
  });

  for (final provider in SignInProvider.values) {
    blocTest<SignInCubit, SignInState>(
      'signs in once with ${provider.name}',
      build: () {
        repository.result = Future.value(const Success(null));
        return SignInCubit(SignInUseCase(repository));
      },
      act: (cubit) => cubit.signIn(provider),
      expect: () => [
        SignInState(status: SignInStatus.loading, activeProvider: provider),
        const SignInState(),
      ],
      verify: (_) => expect(repository.providers, [provider]),
    );
  }

  blocTest<SignInCubit, SignInState>(
    'ignores additional requests while sign-in is active',
    build: () {
      repository.result = Completer<Result<void>>().future;
      return SignInCubit(SignInUseCase(repository));
    },
    act: (cubit) async {
      unawaited(cubit.signIn(SignInProvider.discord));
      await Future<void>.delayed(Duration.zero);
      unawaited(cubit.signIn(SignInProvider.google));
    },
    expect: () => [
      const SignInState(
        status: SignInStatus.loading,
        activeProvider: SignInProvider.discord,
      ),
    ],
    verify: (_) => expect(repository.providers, [SignInProvider.discord]),
  );

  blocTest<SignInCubit, SignInState>(
    'returns to idle silently when sign-in is cancelled',
    build: () {
      repository.result = Future.value(
        const Failure(ErrorType.signInCancelled()),
      );
      return SignInCubit(SignInUseCase(repository));
    },
    act: (cubit) => cubit.signIn(SignInProvider.discord),
    expect: () => [
      const SignInState(
        status: SignInStatus.loading,
        activeProvider: SignInProvider.discord,
      ),
      const SignInState(),
    ],
  );

  test('shows a failure and clears it when retry starts', () async {
    repository.result = Future.value(const Failure(ErrorType.unknown()));
    final cubit = SignInCubit(SignInUseCase(repository));
    addTearDown(cubit.close);

    await cubit.signIn(SignInProvider.google);
    expect(
      cubit.state,
      const SignInState(
        status: SignInStatus.failed,
        error: ErrorType.unknown(),
      ),
    );

    final retry = Completer<Result<void>>();
    repository.result = retry.future;
    final retryCall = cubit.signIn(SignInProvider.discord);
    expect(
      cubit.state,
      const SignInState(
        status: SignInStatus.loading,
        activeProvider: SignInProvider.discord,
      ),
    );
    retry.complete(const Success(null));
    await retryCall;
  });
}

class _AuthRepositoryStub implements AuthRepository {
  Future<Result<void>> result = Future.value(const Success(null));
  final providers = <SignInProvider>[];

  @override
  Future<Result<void>> signIn(SignInProvider provider) {
    providers.add(provider);
    return result;
  }

  @override
  Stream<AuthStatusEntity> get authStatusChanges => const Stream.empty();

  @override
  Future<Result<void>> signOut() => throw UnimplementedError();
}

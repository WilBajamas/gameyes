import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/auth/data/datasources/auth_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/auth_status_entity.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/sign_in_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../mocks/auth_mock.dart';
import 'auth_repository_test.mocks.dart';

@GenerateMocks([AuthDatasource])
void main() {
  late MockAuthDatasource authDatasource;
  late StreamController<AuthState> authStateController;
  late AuthRepositoryImpl repository;

  setUp(() {
    provideDummy<Result<void>>(const Success(null));
    authDatasource = MockAuthDatasource();
    authStateController = StreamController<AuthState>.broadcast();
    GetIt.I.registerSingleton(authDatasource);
    when(authDatasource.currentSession).thenReturn(null);
    when(
      authDatasource.authStateChanges,
    ).thenAnswer((_) => authStateController.stream);
    repository = AuthRepositoryImpl(authDatasource);
  });

  tearDown(() async {
    await authStateController.close();
    await GetIt.instance.reset();
    reset(authDatasource);
  });

  test(
    'should ask Supabase for Discord when signing in with Discord',
    () async {
      when(authDatasource.signInWithOAuth(any)).thenAnswer((_) async => true);

      final result = await repository.signIn(SignInProvider.discord);

      verify(authDatasource.signInWithOAuth(OAuthProvider.discord));
      expect(result, isA<Success<void>>());
    },
  );

  test('should ask Supabase for Google when signing in with Google', () async {
    when(authDatasource.signInWithOAuth(any)).thenAnswer((_) async => true);

    final result = await repository.signIn(SignInProvider.google);

    verify(authDatasource.signInWithOAuth(OAuthProvider.google));
    expect(result, isA<Success<void>>());
  });

  // ignore: lines_longer_than_80_chars
  test(
    'should return Failure with a typed error when sign-in throws AuthException',
    () async {
      when(authDatasource.signInWithOAuth(any)).thenThrow(mockAuthException);

      final result = await repository.signIn(SignInProvider.discord);

      expect(result, isA<Failure<void>>());
      expect(
        (result as Failure<void>).error,
        const ErrorType.responseError(
          message: 'test auth error message',
          error: 'invalid_grant',
          statusCode: 401,
        ),
      );
    },
  );

  // ignore: lines_longer_than_80_chars
  test(
    'should return Failure with a typed error when sign-out throws AuthException',
    () async {
      when(authDatasource.signOut()).thenThrow(mockAuthException);

      final result = await repository.signOut();

      expect(result, isA<Failure<void>>());
      expect(
        (result as Failure<void>).error,
        const ErrorType.responseError(
          message: 'test auth error message',
          error: 'invalid_grant',
          statusCode: 401,
        ),
      );
    },
  );

  test('should return Failure with unknown error when a plain exception is '
      'thrown', () async {
    when(
      authDatasource.signInWithOAuth(any),
    ).thenThrow(Exception('something else went wrong'));

    final result = await repository.signIn(SignInProvider.discord);

    expect(result, isA<Failure<void>>());
    expect((result as Failure<void>).error, const ErrorType.unknown());
  });

  test('should return Success when sign-out completes', () async {
    when(authDatasource.signOut()).thenAnswer((_) async {});

    final result = await repository.signOut();

    expect(result, isA<Success<void>>());
    verify(authDatasource.signOut());
  });

  test('should return Failure with signInCancelled and leave the published '
      'state untouched when sign-in is abandoned', () async {
    when(authDatasource.currentSession).thenReturn(mockDiscordSession);
    when(authDatasource.signInWithOAuth(any)).thenAnswer((_) async => false);

    final emitted = <AuthStatusEntity>[];
    final subscription = repository.authStatusChanges.listen(emitted.add);
    await _settle();

    final result = await repository.signIn(SignInProvider.discord);
    await _settle();

    expect(result, isA<Failure<void>>());
    expect((result as Failure<void>).error, const ErrorType.signInCancelled());
    expect(emitted, [mockDiscordSignedInStatus]);
    await subscription.cancel();
  });

  test('should map a signed-in event to the signed-in status when Supabase '
      'reports a sign-in', () async {
    final emitted = <AuthStatusEntity>[];
    final subscription = repository.authStatusChanges.listen(emitted.add);
    await _settle();

    authStateController.add(mockSignedInAuthState);
    await _settle();

    expect(emitted, [mockSignedOutStatus, mockDiscordSignedInStatus]);
    await subscription.cancel();
  });

  test('should map a signed-out event to the signed-out status when Supabase '
      'reports a sign-out', () async {
    when(authDatasource.currentSession).thenReturn(mockDiscordSession);

    final emitted = <AuthStatusEntity>[];
    final subscription = repository.authStatusChanges.listen(emitted.add);
    await _settle();

    authStateController.add(mockSignedOutAuthState);
    await _settle();

    expect(emitted, [mockDiscordSignedInStatus, mockSignedOutStatus]);
    await subscription.cancel();
  });

  test('should stay signed in when Supabase refreshes the token', () async {
    when(authDatasource.currentSession).thenReturn(mockDiscordSession);

    final emitted = <AuthStatusEntity>[];
    final subscription = repository.authStatusChanges.listen(emitted.add);
    await _settle();

    authStateController.add(mockTokenRefreshedAuthState);
    await _settle();

    expect(emitted, [mockDiscordSignedInStatus, mockDiscordSignedInStatus]);
    expect(emitted, isNot(contains(mockSignedOutStatus)));
    await subscription.cancel();
  });

  test('should give a late listener the current status when no further event '
      'arrives', () async {
    when(authDatasource.currentSession).thenReturn(mockGoogleSession);

    final emitted = <AuthStatusEntity>[];
    final subscription = repository.authStatusChanges.listen(emitted.add);
    await _settle();

    expect(emitted, [mockGoogleSignedInStatus]);
    await subscription.cancel();
  });

  test(
    'should give both listeners the status when two listen at once',
    () async {
      when(authDatasource.currentSession).thenReturn(mockDiscordSession);

      final first = <AuthStatusEntity>[];
      final second = <AuthStatusEntity>[];
      final firstSubscription = repository.authStatusChanges.listen(first.add);
      final secondSubscription = repository.authStatusChanges.listen(
        second.add,
      );
      await _settle();

      authStateController.add(mockSignedOutAuthState);
      await _settle();

      expect(first, [mockDiscordSignedInStatus, mockSignedOutStatus]);
      expect(second, [mockDiscordSignedInStatus, mockSignedOutStatus]);
      await firstSubscription.cancel();
      await secondSubscription.cancel();
    },
  );

  test(
    'should report signed out when restoring the saved session fails',
    () async {
      final emitted = <AuthStatusEntity>[];
      Object? streamError;
      final subscription = repository.authStatusChanges.listen(
        emitted.add,
        onError: (Object error) => streamError = error,
      );
      await _settle();

      authStateController.addError(
        const AuthException(
          'Invalid Refresh Token',
          code: 'refresh_token_not_found',
        ),
      );
      await _settle();

      expect(streamError, isNull);
      expect(emitted, [mockSignedOutStatus, mockSignedOutStatus]);
      await subscription.cancel();
    },
  );
}

// Lets every queued stream event be delivered before the test looks at what
// arrived.
Future<void> _settle() => Future<void>.delayed(Duration.zero);

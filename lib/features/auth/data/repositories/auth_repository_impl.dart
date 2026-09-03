import 'dart:async';

import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/auth/data/datasources/auth_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/auth/data/mappers/authenticated_user_mapper.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/auth_status_entity.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/sign_in_provider.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._datasource);

  final AuthDatasource _datasource;

  @override
  Future<Result<void>> signIn(SignInProvider provider) async {
    try {
      final opened = await _datasource.signInWithOAuth(_toSupabase(provider));
      if (!opened) {
        // The sign-in page never opened or was closed again, so the person
        // simply did not finish. Nothing about the session has changed.
        return Failure(const ErrorType.signInCancelled());
      }
      return Success(null);
    } on AuthException catch (e) {
      return Failure(_fromAuthException(e));
    } catch (_) {
      return Failure(const ErrorType.unknown());
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _datasource.signOut();
      return Success(null);
    } on AuthException catch (e) {
      return Failure(_fromAuthException(e));
    } catch (_) {
      return Failure(const ErrorType.unknown());
    }
  }

  @override
  Stream<AuthStatusEntity> get authStatusChanges async* {
    // Tell whoever just started listening where things stand right now, so
    // they do not have to wait for the next sign-in or sign-out to happen.
    // signIn/signOut only start the request; this stream says how it turned out.
    yield _statusFromSession(_datasource.currentSession);
    yield* _datasource.authStateChanges.transform(
      StreamTransformer<AuthState, AuthStatusEntity>.fromHandlers(
        handleData: (state, sink) => sink.add(_statusFromAuthState(state)),
        // A saved sign-in that Supabase could not restore arrives here as a
        // failure. Treat it as simply being signed out rather than letting
        // the listener deal with an error or wait forever.
        handleError: (error, stackTrace, sink) =>
            sink.add(const AuthStatusEntity.signedOut()),
      ),
    );
  }

  OAuthProvider _toSupabase(SignInProvider provider) => switch (provider) {
    SignInProvider.discord => OAuthProvider.discord,
    SignInProvider.google => OAuthProvider.google,
  };

  ErrorType _fromAuthException(AuthException e) => ErrorType.responseError(
    message: e.message,
    error: e.code,
    statusCode: int.tryParse(e.statusCode ?? ''),
  );

  AuthStatusEntity _statusFromSession(Session? session) => session == null
      ? const AuthStatusEntity.signedOut()
      : AuthStatusEntity.signedIn(session.user.toEntity());

  AuthStatusEntity _statusFromAuthState(AuthState state) =>
      switch (state.event) {
        // Only an explicit sign-out means the person is gone. Everything
        // else, a token refresh most of all, keeps whoever the session says.
        AuthChangeEvent.signedOut => const AuthStatusEntity.signedOut(),
        AuthChangeEvent.initialSession ||
        AuthChangeEvent.passwordRecovery ||
        AuthChangeEvent.signedIn ||
        AuthChangeEvent.tokenRefreshed ||
        AuthChangeEvent.userUpdated ||
        /// [AuthChangeEvent.userDeleted] is deprecated in supabase package
        // ignore: deprecated_member_use
        AuthChangeEvent.userDeleted ||
        AuthChangeEvent.mfaChallengeVerified => _statusFromSession(
          state.session,
        ),
      };
}

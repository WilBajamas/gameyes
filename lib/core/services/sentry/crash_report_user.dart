import 'dart:async';

import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/auth_status_entity.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/use_cases/observe_auth_status_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Puts the Supabase account id on crash reports while someone is signed in,
/// and takes it straight off again when they sign out.
@singleton
class CrashReportUser {
  CrashReportUser(this._observeAuthStatus);

  final ObserveAuthStatusUseCase _observeAuthStatus;
  StreamSubscription<AuthStatusEntity>? _subscription;

  void start() {
    if (_subscription != null) return;
    _subscription = _observeAuthStatus().listen(
      _apply,
      onError: (_) => _apply(const AuthStatusEntity.signedOut()),
    );
  }

  Future<void> _apply(AuthStatusEntity status) async {
    final id = switch (status) {
      AuthSignedIn(:final user) => user.id,
      AuthSignedOut() => null,
    };
    await Sentry.configureScope(
      (scope) => scope.setUser(id == null ? null : SentryUser(id: id)),
    );
  }
}

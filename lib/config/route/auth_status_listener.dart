import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/auth_status_entity.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/use_cases/observe_auth_status_use_case.dart';
import 'package:injectable/injectable.dart';

/// App-lifetime holder of the single auth-status subscription, exposed as a
/// synchronous flag so a guard can decide without awaiting.
@singleton
class AuthStatusListener extends ChangeNotifier {
  AuthStatusListener(this._observeAuthStatus);

  final ObserveAuthStatusUseCase _observeAuthStatus;
  StreamSubscription<AuthStatusEntity>? _subscription;

  // Fail closed until the first emission arrives, so a guarded screen is
  // never shown for a status we don't know yet.
  bool _signedIn = false;

  bool get isSignedIn => _signedIn;

  void start() {
    if (_subscription != null) return;
    _subscription = _observeAuthStatus().listen(
      _handle,
      onError: (_) => _handle(const AuthStatusEntity.signedOut()),
    );
  }

  void _handle(AuthStatusEntity status) {
    final signedIn = switch (status) {
      AuthSignedIn() => true,
      AuthSignedOut() => false,
    };
    // Supabase replays the current status at launch and on token refresh;
    // only a real change should move anyone off the screen they're on.
    if (signedIn == _signedIn) return;
    _signedIn = signedIn;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

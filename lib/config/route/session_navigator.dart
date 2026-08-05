import 'package:gaming_library_assessment_flutter/config/route/auth_status_listener.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/config/route/pending_route_store.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:injectable/injectable.dart';

/// Moves the user off the sign-in flow to the pending route (or the tab
/// shell) when they sign in.
@singleton
class SessionNavigator {
  SessionNavigator(this._authStatus, this._pendingRoutesStore, this._router);

  final AuthStatusListener _authStatus;
  final PendingRouteStore _pendingRoutesStore;
  final AppRouter _router;

  void start() => _authStatus.addListener(_onAuthStatusChanged);

  void _onAuthStatusChanged() {
    if (!_authStatus.isSignedIn) return;
    // Someone already inside the app stays where they are; only a person
    // waiting on the welcome or sign-in screens is moved along.
    if (!RouteConstants.openPaths.contains(_router.currentPath)) return;

    _router.replaceAll([_pendingRoutesStore.take() ?? const HomeRoute()]);
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:gaming_library_assessment_flutter/config/route/auth_status_listener.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/config/route/pending_route_store.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class AuthGuard extends AutoRouteGuard {
  AuthGuard(this._authStatus, this._preferences, this._pendingRoutesStore);

  final AuthStatusListener _authStatus;
  final SharedPreferences _preferences;
  final PendingRouteStore _pendingRoutesStore;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_authStatus.isSignedIn) {
      resolver.next();
      return;
    }

    // Record where they were headed before sending them away, so signing in
    // can put them back on it - arguments and all.
    _pendingRoutesStore.remember(resolver.route.toPageRouteInfo());
    resolver.next(false);

    final seenWelcome =
        _preferences.getBool(StorageConstants.firstUseKey) ?? false;
    router.replaceAll([
      if (seenWelcome) const AuthRoute() else const OnboardingRoute(),
    ]);
  }
}

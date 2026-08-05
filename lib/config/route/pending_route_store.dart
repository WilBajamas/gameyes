import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

/// The route a blocked navigation was heading to, kept until the person
/// signs in. Not saved anywhere, so closing the app forgets it.
@singleton
class PendingRouteStore {
  PageRouteInfo? _route;

  void remember(PageRouteInfo route) => _route = route;

  PageRouteInfo? take() {
    final route = _route;
    _route = null;
    return route;
  }
}

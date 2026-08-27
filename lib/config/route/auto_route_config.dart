import 'package:auto_route/auto_route.dart';
import 'package:gaming_library_assessment_flutter/config/route/guards/auth_guard.dart';
import 'package:injectable/injectable.dart';

import 'auto_route_config.gr.dart';

@singleton
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter(this._authGuard);

  final AuthGuard _authGuard;

  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '/onboarding', page: OnboardingRoute.page),
    AutoRoute(path: '/auth', page: AuthRoute.page),
    AutoRoute(path: '/legal', page: AppWebViewRoute.page),
    AutoRoute(
      path: '/',
      page: HomeRoute.page,
      initial: true,
      guards: [_authGuard],
      children: [
        AutoRoute(path: 'featured', page: FeaturedRoute.page),
        AutoRoute(path: 'library', page: LibraryRoute.page),
        AutoRoute(path: 'games', page: GamesRoute.page),
        AutoRoute(path: 'feed', page: FeedRoute.page),
        AutoRoute(path: 'settings', page: SettingsRoute.page),
      ],
    ),
    AutoRoute(
      path: '/game-detail',
      page: GameDetailRoute.page,
      guards: [_authGuard],
    ),
    AutoRoute(
      path: '/image-view',
      page: ImageRouteView.page,
      guards: [_authGuard],
    ),
    AutoRoute(
      path: '/tracker-detail',
      page: TrackerGameDetailRoute.page,
      guards: [_authGuard],
    ),
    AutoRoute(
      path: '/task-detail',
      page: TaskDetailRoute.page,
      guards: [_authGuard],
    ),
  ];
}

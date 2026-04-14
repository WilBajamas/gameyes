import 'package:auto_route/auto_route.dart';
import 'package:gaming_library_assessment_flutter/config/route/guards/onboarding_guard.dart';
import 'package:injectable/injectable.dart';
import 'auto_route_config.gr.dart';

@singleton
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/onboarding',
          page: OnboardingRoute.page,
        ),
        AutoRoute(
          path: '/',
          page: HomeRoute.page,
          initial: true,
          guards: [OnboardingGuard()],
          children: [
            AutoRoute(path: 'featured', page: FeaturedRouteContainer.page),
            AutoRoute(path: 'games', page: GamesRouteContainer.page),
            AutoRoute(path: 'tracker', page: TrackerRoute.page),
            AutoRoute(path: 'browse', page: BrowseRoute.page),
            AutoRoute(path: 'settings', page: SettingsRoute.page),
          ],
        ),
        AutoRoute(
          path: '/game-detail',
          page: GameDetailRoute.page,
        ),
        AutoRoute(
          path: '/image-view',
          page: ImageRouteView.page,
        ),
        AutoRoute(
          path: '/tracker-detail',
          page: TrackerGameDetailRoute.page,
        ),
      ];
}

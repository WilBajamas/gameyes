import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/storage/shared_preferences.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/screen/featured_screen.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/screens/game_detail_screen.dart';
import 'package:gaming_library_assessment_flutter/features/games/presentation/screen/games_screen.dart';
import 'package:gaming_library_assessment_flutter/features/home/presentation/screen/home_screen.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/screen/onboarding_screen.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: RouteConstants.root,
      redirect: (context, state) async {
        final SharedPreference preferences = getIt<SharedPreference>();
        final isFirstUse =
            await preferences.readValue<bool>(StorageConstants.firstUseKey);

        // Redirect based on first-time use:
        return isFirstUse == null || isFirstUse == false
            ? RouteConstants.onboarding
            : RouteConstants.featured;
      },
    ),
    GoRoute(
      path: RouteConstants.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomeScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteConstants.featured,
              builder: (context, state) => const FeaturedScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteConstants.games,
              builder: (context, state) => const GamesScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: RouteConstants.gameDetail,
      builder: (context, state) => GameDetailScreen(
        gameId: state.extra as int,
      ),
    ),
  ],
);

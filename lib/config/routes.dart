import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/screen/featured_screen.dart';
import 'package:gaming_library_assessment_flutter/features/games/presentation/screen/games_screen.dart';
import 'package:gaming_library_assessment_flutter/features/home/presentation/screen/home_screen.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  initialLocation: RouteConstants.featured,
  navigatorKey: _rootNavigatorKey,
  routes: [
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
  ],
);

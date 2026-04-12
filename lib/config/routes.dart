import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/storage/shared_preferences.dart';
import 'package:gaming_library_assessment_flutter/features/browse/presentation/screen/browse_screen.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/screen/featured_screen_wrapper.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/screens/game_detail_screen.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/screens/image_page_view.dart';
import 'package:gaming_library_assessment_flutter/features/home/presentation/screen/home_screen.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/screen/onboarding_screen.dart';
import 'package:gaming_library_assessment_flutter/features/settings/presentation/screen/settings_screen.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game_task.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/screen/task_detail_screen.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/screen/tracker_game_detail_screen.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/screen/tracker_screen.dart';
import 'package:go_router/go_router.dart';

import '../features/games/presentation/screen/games_screen_wrapper.dart';

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
        return HomeScreen();
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteConstants.featured,
              builder: (context, state) => const FeaturedScreenWrapper(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteConstants.games,
              builder: (context, state) => const GamesScreenWrapper(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteConstants.tracker,
              builder: (context, state) => const TrackerScreen(),
              routes: [
                GoRoute(
                  name: RouteConstants.trackerDetail,
                  path: 'tracker_detail',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) =>
                      TrackerGameDetailScreen(game: state.extra as SavedGame),
                  routes: [
                    GoRoute(
                      name: RouteConstants.taskDetail,
                      path: 'tracker_task',
                      builder: (context, state) {
                        final (int id, SavedGameTask task) =
                            state.extra as (int, SavedGameTask);
                        return TaskDetailScreen(
                          taskId: id,
                          task: task,
                        );
                      },
                      parentNavigatorKey: _rootNavigatorKey,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteConstants.browse,
              builder: (context, state) => const BrowseScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteConstants.settings,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: RouteConstants.gameDetail,
      builder: (context, state) {
        return GameDetailScreen(
          gameExtra: state.extra as (int, String, String?),
        );
      },
      routes: [
        GoRoute(
          name: RouteConstants.imagePageView,
          path: RouteConstants.imagePageView,
          builder: (context, state) {
            return ImagePageView(
              pageViewInfo: state.extra as (List<String?>, int),
            );
          },
        ),
      ],
    ),
  ],
);

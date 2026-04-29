// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter/material.dart' as _i13;
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_saved_game_entity.dart'
    as _i15;
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_task_entity.dart'
    as _i14;
import 'package:gaming_library_assessment_flutter/features/browse/presentation/screens/browse_screen.dart'
    as _i1;
import 'package:gaming_library_assessment_flutter/features/featured/presentation/screens/featured_screen.dart'
    as _i2;
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/screens/game_detail_screen.dart'
    as _i3;
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/screens/image_page_view.dart'
    as _i6;
import 'package:gaming_library_assessment_flutter/features/games/presentation/screens/games_screen.dart'
    as _i4;
import 'package:gaming_library_assessment_flutter/features/home/presentation/screens/home_screen.dart'
    as _i5;
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/screens/onboarding_screen.dart'
    as _i7;
import 'package:gaming_library_assessment_flutter/features/settings/presentation/screens/settings_screen.dart'
    as _i8;
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/screens/task_detail_screen.dart'
    as _i9;
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/screens/tracker_game_detail_screen.dart'
    as _i10;
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/screens/tracker_screen.dart'
    as _i11;

/// generated route for
/// [_i1.BrowseScreen]
class BrowseRoute extends _i12.PageRouteInfo<void> {
  const BrowseRoute({List<_i12.PageRouteInfo>? children})
      : super(BrowseRoute.name, initialChildren: children);

  static const String name = 'BrowseRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i1.BrowseScreen();
    },
  );
}

/// generated route for
/// [_i2.FeaturedScreenContainer]
class FeaturedRouteContainer extends _i12.PageRouteInfo<void> {
  const FeaturedRouteContainer({List<_i12.PageRouteInfo>? children})
      : super(FeaturedRouteContainer.name, initialChildren: children);

  static const String name = 'FeaturedRouteContainer';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i2.FeaturedScreenContainer();
    },
  );
}

/// generated route for
/// [_i3.GameDetailScreen]
class GameDetailRoute extends _i12.PageRouteInfo<GameDetailRouteArgs> {
  GameDetailRoute({
    _i13.Key? key,
    (int, String, String?)? gameExtra,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          GameDetailRoute.name,
          args: GameDetailRouteArgs(key: key, gameExtra: gameExtra),
          initialChildren: children,
        );

  static const String name = 'GameDetailRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GameDetailRouteArgs>(
        orElse: () => const GameDetailRouteArgs(),
      );
      return _i3.GameDetailScreen(key: args.key, gameExtra: args.gameExtra);
    },
  );
}

class GameDetailRouteArgs {
  const GameDetailRouteArgs({this.key, this.gameExtra});

  final _i13.Key? key;

  final (int, String, String?)? gameExtra;

  @override
  String toString() {
    return 'GameDetailRouteArgs{key: $key, gameExtra: $gameExtra}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GameDetailRouteArgs) return false;
    return key == other.key && gameExtra == other.gameExtra;
  }

  @override
  int get hashCode => key.hashCode ^ gameExtra.hashCode;
}

/// generated route for
/// [_i4.GamesScreenContainer]
class GamesRouteContainer extends _i12.PageRouteInfo<void> {
  const GamesRouteContainer({List<_i12.PageRouteInfo>? children})
      : super(GamesRouteContainer.name, initialChildren: children);

  static const String name = 'GamesRouteContainer';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i4.GamesScreenContainer();
    },
  );
}

/// generated route for
/// [_i5.HomeScreen]
class HomeRoute extends _i12.PageRouteInfo<void> {
  const HomeRoute({List<_i12.PageRouteInfo>? children})
      : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i5.HomeScreen();
    },
  );
}

/// generated route for
/// [_i6.ImagePageView]
class ImageRouteView extends _i12.PageRouteInfo<ImageRouteViewArgs> {
  ImageRouteView({
    _i13.Key? key,
    required (List<String?>, int) pageViewInfo,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          ImageRouteView.name,
          args: ImageRouteViewArgs(key: key, pageViewInfo: pageViewInfo),
          initialChildren: children,
        );

  static const String name = 'ImageRouteView';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ImageRouteViewArgs>();
      return _i6.ImagePageView(key: args.key, pageViewInfo: args.pageViewInfo);
    },
  );
}

class ImageRouteViewArgs {
  const ImageRouteViewArgs({this.key, required this.pageViewInfo});

  final _i13.Key? key;

  final (List<String?>, int) pageViewInfo;

  @override
  String toString() {
    return 'ImageRouteViewArgs{key: $key, pageViewInfo: $pageViewInfo}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ImageRouteViewArgs) return false;
    return key == other.key && pageViewInfo == other.pageViewInfo;
  }

  @override
  int get hashCode => key.hashCode ^ pageViewInfo.hashCode;
}

/// generated route for
/// [_i7.OnboardingScreen]
class OnboardingRoute extends _i12.PageRouteInfo<void> {
  const OnboardingRoute({List<_i12.PageRouteInfo>? children})
      : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i7.OnboardingScreen();
    },
  );
}

/// generated route for
/// [_i8.SettingsScreen]
class SettingsRoute extends _i12.PageRouteInfo<void> {
  const SettingsRoute({List<_i12.PageRouteInfo>? children})
      : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i8.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i9.TaskDetailScreen]
class TaskDetailRoute extends _i12.PageRouteInfo<TaskDetailRouteArgs> {
  TaskDetailRoute({
    int? taskId,
    _i14.TrackerTaskEntity? task,
    _i13.Key? key,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          TaskDetailRoute.name,
          args: TaskDetailRouteArgs(taskId: taskId, task: task, key: key),
          initialChildren: children,
        );

  static const String name = 'TaskDetailRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TaskDetailRouteArgs>(
        orElse: () => const TaskDetailRouteArgs(),
      );
      return _i9.TaskDetailScreen(
        taskId: args.taskId,
        task: args.task,
        key: args.key,
      );
    },
  );
}

class TaskDetailRouteArgs {
  const TaskDetailRouteArgs({this.taskId, this.task, this.key});

  final int? taskId;

  final _i14.TrackerTaskEntity? task;

  final _i13.Key? key;

  @override
  String toString() {
    return 'TaskDetailRouteArgs{taskId: $taskId, task: $task, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TaskDetailRouteArgs) return false;
    return taskId == other.taskId && task == other.task && key == other.key;
  }

  @override
  int get hashCode => taskId.hashCode ^ task.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i10.TrackerGameDetailScreen]
class TrackerGameDetailRoute
    extends _i12.PageRouteInfo<TrackerGameDetailRouteArgs> {
  TrackerGameDetailRoute({
    required _i15.TrackerSavedGameEntity game,
    _i13.Key? key,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          TrackerGameDetailRoute.name,
          args: TrackerGameDetailRouteArgs(game: game, key: key),
          initialChildren: children,
        );

  static const String name = 'TrackerGameDetailRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TrackerGameDetailRouteArgs>();
      return _i10.TrackerGameDetailScreen(game: args.game, key: args.key);
    },
  );
}

class TrackerGameDetailRouteArgs {
  const TrackerGameDetailRouteArgs({required this.game, this.key});

  final _i15.TrackerSavedGameEntity game;

  final _i13.Key? key;

  @override
  String toString() {
    return 'TrackerGameDetailRouteArgs{game: $game, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TrackerGameDetailRouteArgs) return false;
    return game == other.game && key == other.key;
  }

  @override
  int get hashCode => game.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i11.TrackerScreen]
class TrackerRoute extends _i12.PageRouteInfo<void> {
  const TrackerRoute({List<_i12.PageRouteInfo>? children})
      : super(TrackerRoute.name, initialChildren: children);

  static const String name = 'TrackerRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i11.TrackerScreen();
    },
  );
}

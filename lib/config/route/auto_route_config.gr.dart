// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i14;
import 'package:flutter/material.dart' as _i15;
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_saved_game_entity.dart'
    as _i17;
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_task_entity.dart'
    as _i16;
import 'package:gaming_library_assessment_flutter/features/auth/presentation/screens/auth_screen.dart'
    as _i2;
import 'package:gaming_library_assessment_flutter/features/browse/presentation/screens/browse_screen.dart'
    as _i3;
import 'package:gaming_library_assessment_flutter/features/featured/presentation/screens/featured_screen.dart'
    as _i4;
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/screens/game_detail_screen.dart'
    as _i5;
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/screens/image_page_view.dart'
    as _i8;
import 'package:gaming_library_assessment_flutter/features/games/presentation/screens/games_screen.dart'
    as _i6;
import 'package:gaming_library_assessment_flutter/features/home/presentation/screens/home_screen.dart'
    as _i7;
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/screens/onboarding_screen.dart'
    as _i9;
import 'package:gaming_library_assessment_flutter/features/settings/presentation/screens/settings_screen.dart'
    as _i10;
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/screens/task_detail_screen.dart'
    as _i11;
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/screens/tracker_game_detail_screen.dart'
    as _i12;
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/screens/tracker_screen.dart'
    as _i13;
import 'package:gaming_library_assessment_flutter/widgets/app_web_view.dart'
    as _i1;

/// generated route for
/// [_i1.AppWebView]
class AppWebViewRoute extends _i14.PageRouteInfo<AppWebViewRouteArgs> {
  AppWebViewRoute({
    _i15.Key? key,
    required Uri url,
    List<_i14.PageRouteInfo>? children,
  }) : super(
         AppWebViewRoute.name,
         args: AppWebViewRouteArgs(key: key, url: url),
         initialChildren: children,
       );

  static const String name = 'AppWebViewRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AppWebViewRouteArgs>();
      return _i1.AppWebView(key: args.key, url: args.url);
    },
  );
}

class AppWebViewRouteArgs {
  const AppWebViewRouteArgs({this.key, required this.url});

  final _i15.Key? key;

  final Uri url;

  @override
  String toString() {
    return 'AppWebViewRouteArgs{key: $key, url: $url}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AppWebViewRouteArgs) return false;
    return key == other.key && url == other.url;
  }

  @override
  int get hashCode => key.hashCode ^ url.hashCode;
}

/// generated route for
/// [_i2.AuthScreen]
class AuthRoute extends _i14.PageRouteInfo<void> {
  const AuthRoute({List<_i14.PageRouteInfo>? children})
    : super(AuthRoute.name, initialChildren: children);

  static const String name = 'AuthRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      return const _i2.AuthScreen();
    },
  );
}

/// generated route for
/// [_i3.BrowseScreen]
class BrowseRoute extends _i14.PageRouteInfo<void> {
  const BrowseRoute({List<_i14.PageRouteInfo>? children})
    : super(BrowseRoute.name, initialChildren: children);

  static const String name = 'BrowseRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      return const _i3.BrowseScreen();
    },
  );
}

/// generated route for
/// [_i4.FeaturedScreen]
class FeaturedRoute extends _i14.PageRouteInfo<void> {
  const FeaturedRoute({List<_i14.PageRouteInfo>? children})
    : super(FeaturedRoute.name, initialChildren: children);

  static const String name = 'FeaturedRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      return const _i4.FeaturedScreen();
    },
  );
}

/// generated route for
/// [_i5.GameDetailScreen]
class GameDetailRoute extends _i14.PageRouteInfo<GameDetailRouteArgs> {
  GameDetailRoute({
    _i15.Key? key,
    (int, String, String?)? gameExtra,
    List<_i14.PageRouteInfo>? children,
  }) : super(
         GameDetailRoute.name,
         args: GameDetailRouteArgs(key: key, gameExtra: gameExtra),
         initialChildren: children,
       );

  static const String name = 'GameDetailRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GameDetailRouteArgs>(
        orElse: () => const GameDetailRouteArgs(),
      );
      return _i5.GameDetailScreen(key: args.key, gameExtra: args.gameExtra);
    },
  );
}

class GameDetailRouteArgs {
  const GameDetailRouteArgs({this.key, this.gameExtra});

  final _i15.Key? key;

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
/// [_i6.GamesScreen]
class GamesRoute extends _i14.PageRouteInfo<void> {
  const GamesRoute({List<_i14.PageRouteInfo>? children})
    : super(GamesRoute.name, initialChildren: children);

  static const String name = 'GamesRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      return const _i6.GamesScreen();
    },
  );
}

/// generated route for
/// [_i7.HomeScreen]
class HomeRoute extends _i14.PageRouteInfo<void> {
  const HomeRoute({List<_i14.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      return const _i7.HomeScreen();
    },
  );
}

/// generated route for
/// [_i8.ImagePageView]
class ImageRouteView extends _i14.PageRouteInfo<ImageRouteViewArgs> {
  ImageRouteView({
    _i15.Key? key,
    required (List<String?>, int) pageViewInfo,
    List<_i14.PageRouteInfo>? children,
  }) : super(
         ImageRouteView.name,
         args: ImageRouteViewArgs(key: key, pageViewInfo: pageViewInfo),
         initialChildren: children,
       );

  static const String name = 'ImageRouteView';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ImageRouteViewArgs>();
      return _i8.ImagePageView(key: args.key, pageViewInfo: args.pageViewInfo);
    },
  );
}

class ImageRouteViewArgs {
  const ImageRouteViewArgs({this.key, required this.pageViewInfo});

  final _i15.Key? key;

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
/// [_i9.OnboardingScreen]
class OnboardingRoute extends _i14.PageRouteInfo<void> {
  const OnboardingRoute({List<_i14.PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      return const _i9.OnboardingScreen();
    },
  );
}

/// generated route for
/// [_i10.SettingsScreen]
class SettingsRoute extends _i14.PageRouteInfo<void> {
  const SettingsRoute({List<_i14.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      return const _i10.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i11.TaskDetailScreen]
class TaskDetailRoute extends _i14.PageRouteInfo<TaskDetailRouteArgs> {
  TaskDetailRoute({
    int? taskId,
    _i16.TrackerTaskEntity? task,
    _i15.Key? key,
    List<_i14.PageRouteInfo>? children,
  }) : super(
         TaskDetailRoute.name,
         args: TaskDetailRouteArgs(taskId: taskId, task: task, key: key),
         initialChildren: children,
       );

  static const String name = 'TaskDetailRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TaskDetailRouteArgs>(
        orElse: () => const TaskDetailRouteArgs(),
      );
      return _i11.TaskDetailScreen(
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

  final _i16.TrackerTaskEntity? task;

  final _i15.Key? key;

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
/// [_i12.TrackerGameDetailScreen]
class TrackerGameDetailRoute
    extends _i14.PageRouteInfo<TrackerGameDetailRouteArgs> {
  TrackerGameDetailRoute({
    required _i17.TrackerSavedGameEntity game,
    _i15.Key? key,
    List<_i14.PageRouteInfo>? children,
  }) : super(
         TrackerGameDetailRoute.name,
         args: TrackerGameDetailRouteArgs(game: game, key: key),
         initialChildren: children,
       );

  static const String name = 'TrackerGameDetailRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TrackerGameDetailRouteArgs>();
      return _i12.TrackerGameDetailScreen(game: args.game, key: args.key);
    },
  );
}

class TrackerGameDetailRouteArgs {
  const TrackerGameDetailRouteArgs({required this.game, this.key});

  final _i17.TrackerSavedGameEntity game;

  final _i15.Key? key;

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
/// [_i13.TrackerScreen]
class TrackerRoute extends _i14.PageRouteInfo<TrackerRouteArgs> {
  TrackerRoute({_i15.Key? key, List<_i14.PageRouteInfo>? children})
    : super(
        TrackerRoute.name,
        args: TrackerRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'TrackerRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TrackerRouteArgs>(
        orElse: () => const TrackerRouteArgs(),
      );
      return _i13.TrackerScreen(key: args.key);
    },
  );
}

class TrackerRouteArgs {
  const TrackerRouteArgs({this.key});

  final _i15.Key? key;

  @override
  String toString() {
    return 'TrackerRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TrackerRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

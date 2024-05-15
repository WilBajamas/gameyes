import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gaming_library_assessment_flutter/config/routes.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart'
    as injection;
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/bloc/featured_bloc.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/featured_filter_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/screen/featured_screen.dart';
import 'package:gaming_library_assessment_flutter/features/filter/presentation/cubit/filter_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_detail_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_screenshot_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/screens/game_detail_screen.dart';
import 'package:gaming_library_assessment_flutter/features/games/presentation/bloc/games_bloc.dart';
import 'package:gaming_library_assessment_flutter/features/games/presentation/screen/games_screen.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubit/task_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubit/tracker_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubit/tracker_detail_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/screen/task_detail_screen.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/screen/tracker_screen.dart';

void main() {
  runApp(const MyApp());
  configureDependencies();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => injection.getIt<FeaturedBloc>(),
          child: const FeaturedScreen(),
        ),
        BlocProvider(
          create: (context) => injection.getIt<FilterCubit>(),
        ),
        BlocProvider(
          create: (context) => injection.getIt<FeaturedFilterCubit>(),
        ),
        BlocProvider(
          create: (context) => injection.getIt<GamesBloc>(),
          child: const GamesScreen(),
        ),
        BlocProvider(
          create: (context) => injection.getIt<GameDetailCubit>(),
          child: const GameDetailScreen(),
        ),
        BlocProvider(
          create: (context) => injection.getIt<GameScreenshotCubit>(),
          child: const GameDetailScreen(),
        ),
        BlocProvider(
          create: (context) => injection.getIt<TrackerCubit>(),
          child: const TrackerScreen(),
        ),
        BlocProvider(
          create: (context) => injection.getIt<TrackerDetailCubit>(),
          child: const TrackerScreen(),
        ),
        BlocProvider(
          create: (context) => injection.getIt<TaskCubit>(),
          child: const TaskDetailScreen(),
        ),
      ],
      child: MaterialApp.router(
        onGenerateTitle: (context) => context.localisations.app_title,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: buildTheme(),
        darkTheme: buildDarkTheme(),
        routerConfig: goRouter,
      ),
    );
  }
}

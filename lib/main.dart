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
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/best_metacritic_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/latest_releases_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/most_anticipated_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/screen/featured_screen.dart';
import 'package:gaming_library_assessment_flutter/features/filter/presentation/cubit/filter_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/games/presentation/bloc/games_bloc.dart';
import 'package:gaming_library_assessment_flutter/features/games/presentation/screen/games_screen.dart';

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
          create: (context) => injection.getIt<MostAnticipatedCubit>(),
          child: const FeaturedScreen(),
        ),
        BlocProvider(
          create: (context) => injection.getIt<BestMetacriticCubit>(),
          child: const FeaturedScreen(),
        ),
        BlocProvider(
          create: (context) => injection.getIt<LatestReleasesCubit>(),
          child: const FeaturedScreen(),
        ),
        BlocProvider(
          create: (context) => injection.getIt<FilterCubit>(),
        ),
        BlocProvider(
          create: (context) => injection.getIt<GamesBloc>(),
          child: const GamesScreen(),
        ),
      ],
      child: MaterialApp.router(
        onGenerateTitle: (context) => context.localisations.app_title,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        themeMode: ThemeMode.system,
        theme: buildTheme(),
        darkTheme: buildDarkTheme(),
        routerConfig: goRouter,
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/presentation/mixins/stale_data_refresh_mixin.dart';
import 'package:gaming_library_assessment_flutter/features/featured_revamp/presentation/blocs/countdown_releases_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/featured_revamp/presentation/blocs/countdown_releases_state.dart';
import 'package:gaming_library_assessment_flutter/features/featured_revamp/presentation/blocs/critics_grid_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/featured_revamp/presentation/blocs/critics_grid_state.dart';
import 'package:gaming_library_assessment_flutter/features/featured_revamp/presentation/blocs/library_stats_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/featured_revamp/presentation/blocs/library_stats_state.dart';
import 'package:gaming_library_assessment_flutter/features/featured_revamp/presentation/utils/game_loading_data.dart';
import 'package:gaming_library_assessment_flutter/features/featured_revamp/presentation/widgets/countdown_releases.dart';
import 'package:gaming_library_assessment_flutter/features/featured_revamp/presentation/widgets/critics_grid.dart';
import 'package:gaming_library_assessment_flutter/features/featured_revamp/presentation/widgets/library_stats.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class FeaturedRevampScreen extends StatelessWidget {
  const FeaturedRevampScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LibraryStatsCubit>(
          create: (context) =>
              getIt<LibraryStatsCubit>()..loadLibrarySnapshot(),
        ),
        BlocProvider<CountdownReleasesCubit>(
          create: (context) =>
              getIt<CountdownReleasesCubit>()..loadCountdownAndReleases(),
        ),
        BlocProvider<CriticsGridCubit>(
          create: (context) => getIt<CriticsGridCubit>()..loadCriticsGrid(),
        ),
      ],
      child: const FeaturedRevampView(),
    );
  }
}

class FeaturedRevampView extends StatefulWidget {
  const FeaturedRevampView({super.key});

  @override
  State<FeaturedRevampView> createState() => _FeaturedRevampViewState();
}

class _FeaturedRevampViewState extends State<FeaturedRevampView>
    with StaleDataRefreshMixin {
  @override
  Duration get staleThreshold => const Duration(minutes: 15);

  @override
  void onStaleRefresh() {
    _refreshData(silent: true);
  }

  Future<void> _refreshData({required bool silent}) async {
    final libraryCubit = context.read<LibraryStatsCubit>();
    final countdownCubit = context.read<CountdownReleasesCubit>();
    final criticsCubit = context.read<CriticsGridCubit>();

    if (silent) {
      libraryCubit.loadLibrarySnapshot();
      countdownCubit.loadCountdownAndReleases();
      criticsCubit.loadCriticsGrid();
    } else {
      await Future.wait([
        libraryCubit.loadLibrarySnapshot(),
        countdownCubit.loadCountdownAndReleases(),
        criticsCubit.loadCriticsGrid(),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.featured_revamp),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(silent: false),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _YouSection(),
              const SizedBox(height: 24),
              _RightNowSection(),
              const SizedBox(height: 24),
              _DiscoverSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _YouSection extends StatelessWidget {
  const _YouSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryStatsCubit, LibraryStatsState>(
      builder: (context, state) {
        if (state.status == LibraryStatsStatus.initial ||
            (state.status == LibraryStatsStatus.loading &&
                state.snapshot == null)) {
          return const SizedBox(
            height: 150,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.status == LibraryStatsStatus.failed) {
          return Card(
            color: Colors.red.shade50,
            child: ListTile(
              leading: const Icon(Icons.error, color: Colors.red),
              title: Text(state.errorMessage ?? ''),
              trailing: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () =>
                    context.read<LibraryStatsCubit>().loadLibrarySnapshot(),
              ),
            ),
          );
        }

        return LibraryStatsWidget(
          snapshot: state.snapshot,
          isChecklistDismissed: state.isChecklistDismissed,
          step1Completed: state.step1Completed,
          step2Completed: state.step2Completed,
          step3Completed: state.step3Completed,
          checklistProgress: state.checklistProgress,
          onAddPlayedGame: () => AutoTabsRouter.of(context).setActiveIndex(1),
          onMarkNowPlaying: () => AutoTabsRouter.of(context).setActiveIndex(1),
          onWishlistUpcoming: () =>
              AutoTabsRouter.of(context).setActiveIndex(1),
        );
      },
    );
  }
}

class _RightNowSection extends StatelessWidget {
  const _RightNowSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryStatsCubit, LibraryStatsState>(
      builder: (context, libraryState) {
        final ownedIds = libraryState.snapshot?.ownedGameIds ?? <int>{};

        return BlocBuilder<CountdownReleasesCubit, CountdownReleasesState>(
          builder: (context, state) {
            final isLoading = state.status == CountdownReleasesStatus.loading &&
                state.countdownGame == null &&
                state.outThisWeekGames.isEmpty;

            if (state.status == CountdownReleasesStatus.failed) {
              return Card(
                color: Colors.red.shade50,
                child: ListTile(
                  leading: const Icon(Icons.error, color: Colors.red),
                  title: Text(state.errorMessage ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => context
                        .read<CountdownReleasesCubit>()
                        .loadCountdownAndReleases(),
                  ),
                ),
              );
            }

            if (isLoading) {
              return Skeletonizer(
                child: CountdownReleasesWidget(
                  countdownGame: GameLoadingWidgetData.countdownGame,
                  outThisWeekGames: GameLoadingWidgetData.weeklyReleases,
                  durationRemaining: GameLoadingWidgetData.countdownDuration,
                  isReleaseDay: false,
                  isComingSoonLabel: false,
                  localLibraryGameIds: ownedIds,
                  onGameClick: (_, __, ___) {},
                ),
              );
            }

            if (state.countdownGame == null && state.outThisWeekGames.isEmpty) {
              return const SizedBox.shrink();
            }

            return CountdownReleasesWidget(
              countdownGame: state.countdownGame,
              outThisWeekGames: state.outThisWeekGames,
              durationRemaining: state.durationRemaining,
              isReleaseDay: state.isReleaseDay,
              isComingSoonLabel: state.isComingSoonLabel,
              localLibraryGameIds: ownedIds,
              onGameClick: (id, name, imageUrl) {
                context.router
                    .push(GameDetailRoute(gameExtra: (id, name, imageUrl)));
              },
            );
          },
        );
      },
    );
  }
}

class _DiscoverSection extends StatelessWidget {
  const _DiscoverSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryStatsCubit, LibraryStatsState>(
      builder: (context, libraryState) {
        final ownedIds = libraryState.snapshot?.ownedGameIds ?? <int>{};

        return BlocBuilder<CriticsGridCubit, CriticsGridState>(
          builder: (context, state) {
            final isLoading = state.status == CriticsGridStatus.loading &&
                state.criticsGames.isEmpty;

            if (state.status == CriticsGridStatus.failed) {
              return Card(
                color: Colors.red.shade50,
                child: ListTile(
                  leading: const Icon(Icons.error, color: Colors.red),
                  title: Text(state.errorMessage ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () =>
                        context.read<CriticsGridCubit>().loadCriticsGrid(),
                  ),
                ),
              );
            }

            if (isLoading) {
              return Skeletonizer(
                child: CriticsGridWidget(
                  criticsGames: GameLoadingWidgetData.criticsGames,
                  genrePreferencesEntity:
                      GameLoadingWidgetData.defaultGenrePrefs,
                  localLibraryGameIds: ownedIds,
                  onGenreToggled: (_) {},
                  onSkipPressed: () {},
                  onGameClick: (_, __, ___) {},
                ),
              );
            }

            return CriticsGridWidget(
              criticsGames: state.criticsGames,
              genrePreferencesEntity: state.genrePreferencesEntity,
              localLibraryGameIds: ownedIds,
              onGenreToggled: (genreId) {
                context.read<CriticsGridCubit>().toggleGenrePreference(genreId);
              },
              onSkipPressed: () {
                context.read<CriticsGridCubit>().skipGenrePreferences();
              },
              onGameClick: (id, name, imageUrl) {
                context.router
                    .push(GameDetailRoute(gameExtra: (id, name, imageUrl)));
              },
            );
          },
        );
      },
    );
  }
}

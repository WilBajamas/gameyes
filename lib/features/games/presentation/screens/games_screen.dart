import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/filter/presentation/widgets/filter_bottom_sheet.dart';
import 'package:gaming_library_assessment_flutter/features/games/presentation/blocs/games_bloc.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_sliver_app_bar.dart';
import 'package:gaming_library_assessment_flutter/widgets/empty_state_card.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_retry_widget.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_card/game_card.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_card/enum/game_card_size.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item_grid_loading_shimmer.dart';

import '../../../../generated/l10n.dart';
import '../blocs/games_state.dart';

@RoutePage()
class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GamesBloc>(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<GamesBloc, GamesState>(
            builder: (context, state) {
              return NotificationListener<ScrollUpdateNotification>(
                onNotification: (notification) {
                  final metrics = notification.metrics;
                  final isBottom =
                      metrics.pixels >= (metrics.maxScrollExtent * 0.9);
                  if (isBottom) {
                    context.read<GamesBloc>().scrolledBottom(
                      isBottom: isBottom,
                    );
                  }
                  return false;
                },
                child: CustomScrollView(
                  slivers: [
                    const GamesAppBar(),
                    if (state.status == GamesStatus.success)
                      CupertinoSliverRefreshControl(
                        onRefresh: () async =>
                            context.read<GamesBloc>().add(const GamesFetched()),
                      ),
                    if (state.status == GamesStatus.success)
                      const GamesSliverGrid(),
                    if (state.nextPageStatus == GamesNextPageStatus.loading)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    if (state.nextPageStatus == GamesNextPageStatus.failed)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          child: ErrorRetryWidget(
                            onRetryClicked: () => context.read<GamesBloc>().add(
                              const GamesNextPage(),
                            ),
                          ),
                        ),
                      ),
                    if (state.status == GamesStatus.failed)
                      SliverFillRemaining(
                        child: Center(
                          child: ErrorRetryWidget(
                            onRetryClicked: () => context.read<GamesBloc>().add(
                              const GamesFetched(),
                            ),
                          ),
                        ),
                      ),
                    if (state.status == GamesStatus.empty)
                      SliverFillRemaining(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: EmptyStateCard(
                              glyph: Icons.search_outlined,
                              headline: S.current.nothing_matches_yet,
                              supportingLine:
                                  S.current.try_widening_your_filters,
                              actionLabel: S.current.clear_filters,
                              onActionPressed: () => context
                                  .read<GamesBloc>()
                                  .add(const GamesFiltersCleared()),
                            ),
                          ),
                        ),
                      ),
                    if (state.status == GamesStatus.loading)
                      const SliverFillRemaining(
                        child: GameItemGridLoadingShimmer(),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class GamesSliverGrid extends StatelessWidget {
  const GamesSliverGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GamesBloc>().state;

    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final columnWidth = GamesGridConstants.columnWidth(
          constraints.crossAxisExtent,
        );

        return SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: GamesGridConstants.gutter,
          ),
          sliver: SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: GamesGridConstants.columnCount,
              mainAxisSpacing: GamesGridConstants.gutter,
              crossAxisSpacing: GamesGridConstants.gutter,
              mainAxisExtent: GameCardSize.md.cellHeightFor(columnWidth),
            ),
            itemCount: state.games.length,
            itemBuilder: (context, index) => GameCard(
              size: GameCardSize.md,
              game: state.games[index],
              fromScreen: RouteConstants.games,
              criticScore: state.games[index].criticScore,
              onTap: () {
                final extra = (
                  state.games[index].id,
                  RouteConstants.games,
                  state.games[index].cover.url,
                );
                context.router.push(GameDetailRoute(gameExtra: extra));
              },
            ),
          ),
        );
      },
    );
  }
}

class GamesAppBar extends StatelessWidget {
  const GamesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultSliverAppBar(
      title: S.current.games,
      subtitle: S.current.games_screen_subtitle,
      actionOne: (
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (bottomSheetContext) => FilterBottomSheet(
                onSaveClick: (filter) => context.read<GamesBloc>().add(
                  GamesFetched(
                    searchTerm: filter.searchTerm,
                    dateFrom: filter.dateFrom,
                    dateTo: filter.dateTo,
                    platforms: filter.platforms,
                    ordering: filter.ordering,
                    genres: filter.genres,
                    ascending: filter.ascending,
                  ),
                ),
                filterState: context.read<GamesBloc>().state.filterState,
              ),
              isScrollControlled: true,
              showDragHandle: true,
            );
          },
          icon: Icon(
            Icons.filter_list,
            color: context.themeData.colorScheme.onSurface,
          ),
        ),
        null,
      ),
    );
  }
}

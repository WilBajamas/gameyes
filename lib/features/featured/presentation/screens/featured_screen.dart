import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/enums/featured_tag.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/blocs/featured_bloc.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/screens/featured_filter_bottom_sheet.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_sliver_app_bar.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_retry_widget.dart';
import 'package:gaming_library_assessment_flutter/widgets/filter_list_app_bar.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item_grid_loading_shimmer.dart';

import '../../../filter/data/models/games_platform.dart';
import '../../../../generated/l10n.dart';
import '../blocs/featured_state.dart';
import '../constants/featured_tags_constant.dart';

@RoutePage()
class FeaturedScreen extends StatelessWidget {
  const FeaturedScreen({super.key});

  void _fetchGames({
    required BuildContext context,
    FeaturedTag? tag,
    Set<GamePlatform>? platformSelected,
  }) =>
      context
          .read<FeaturedBloc>()
          .add(FeaturedFetched(tag: tag, platforms: platformSelected));

  void showBottomSheet(BuildContext context) {
    final initialPlatforms =
        context.read<FeaturedBloc>().state.platformsSelected;

    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) => FeaturedFilterBottomSheet(
        initialPlatforms: initialPlatforms,
        onSaveClick: (platforms) => _fetchGames(
          context: context,
          tag: context.read<FeaturedBloc>().state.tag,
          platformSelected: platforms,
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FeaturedBloc>(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<FeaturedBloc, FeaturedState>(
            builder: (context, state) {
              return NotificationListener<ScrollUpdateNotification>(
                onNotification: (notification) {
                  final metrics = notification.metrics;
                  final isBottom =
                      metrics.pixels >= (metrics.maxScrollExtent * 0.9);

                  if (isBottom) {
                    context.read<FeaturedBloc>().scrolledBottom(
                          isBottom: isBottom,
                        );
                  }
                  return false;
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    DefaultSliverAppBar(
                      title: S.current.featured,
                      subtitle: S.current.featured_subtitle,
                      actionOne: (
                        IconButton(
                          onPressed: () => showBottomSheet(context),
                          icon: Icon(
                            Icons.filter_list,
                            color: context.themeData.colorScheme.onSurface,
                          ),
                        ),
                        null
                      ),
                    ),
                    FilterlistAppBar<FeaturedTag>(
                      selected: (selectedTag) =>
                          _fetchGames(context: context, tag: selectedTag),
                      filterList: featuredFilters,
                    ),
                    if (state.status == FeaturedStatus.success)
                      CupertinoSliverRefreshControl(
                        onRefresh: () async =>
                            _fetchGames(context: context, tag: state.tag),
                      ),
                    if (state.status == FeaturedStatus.success)
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        sliver: SliverGrid.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.6,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                          ),
                          itemCount: state.games.length,
                          itemBuilder: (context, index) => GameItem(
                            fromScreen: RouteConstants.featured,
                            game: state.games[index],
                            onItemClick: () {
                              final extra = (
                                state.games[index].id,
                                RouteConstants.featured,
                                state.games[index].cover.url
                              );
                              context.router.push(
                                GameDetailRoute(gameExtra: extra),
                              );
                            },
                          ),
                        ),
                      ),
                    if (state.nextPageStatus == FeaturedNextPageStatus.loading)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    if (state.nextPageStatus == FeaturedNextPageStatus.failed)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          child: ErrorRetryWidget(
                            onRetryClicked: () => context
                                .read<FeaturedBloc>()
                                .add(const FeaturedNextPage()),
                          ),
                        ),
                      ),
                    if (state.status == FeaturedStatus.failed)
                      SliverFillRemaining(
                        child: Center(
                          child: ErrorRetryWidget(
                            onRetryClicked: () => _fetchGames(
                              context: context,
                            ),
                          ),
                        ),
                      ),
                    if (state.status == FeaturedStatus.empty)
                      SliverFillRemaining(
                        child: Center(
                          child: ErrorRetryWidget(
                            text: S.current.no_results_found,
                            onRetryClicked: () => _fetchGames(
                              context: context,
                            ),
                          ),
                        ),
                      ),
                    if (state.status == FeaturedStatus.loading)
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

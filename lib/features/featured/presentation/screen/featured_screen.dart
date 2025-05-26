import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/enums/featured_tag.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/bloc/featured_bloc.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/featured_filter_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/screen/featured_filter_bottom_sheet.dart';
import 'package:gaming_library_assessment_flutter/features/home/presentation/notifier/scroll_notifier.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_sliver_app_bar.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_retry_widget.dart';
import 'package:gaming_library_assessment_flutter/widgets/filter_list_app_bar.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item_grid_loading_shimmer.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/game_platform.dart';

class FeaturedScreen extends StatefulWidget {
  const FeaturedScreen({super.key});

  @override
  State<FeaturedScreen> createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen> {
  final _controller = ScrollController();
  final _scrollChangeNotifier = getIt.get<ScrollNotifier>();

  @override
  void initState() {
    _controller.addListener(_onScroll);
    _fetchGames();

    super.initState();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    _scrollChangeNotifier.isScrolled = _controller.position.userScrollDirection;

    if (_isBottom &&
        context.read<FeaturedBloc>().state.nextPageStatus !=
            FeaturedNextPageStatus.failed) {
      _fetchNextPage();
    }
  }

  void _fetchNextPage() =>
      context.read<FeaturedBloc>().add(const FeaturedNextPage());

  void _fetchGames({
    FeaturedTag tag = FeaturedTag.newAndTrending,
    Set<GamePlatform>? platformSelected,
  }) {
    final platforms = platformSelected ??
        context.read<FeaturedBloc>().state.platformsSelected;
    context
        .read<FeaturedBloc>()
        .add(FeaturedFetched(tag: tag, platforms: platforms));
  }

  bool get _isBottom {
    if (!_controller.hasClients) return false;
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  List<(FeaturedTag, String, IconData)> get featuredFilters => [
        (
          FeaturedTag.newAndTrending,
          context.localisations.new_and_trending,
          Icons.trending_up
        ),
        (
          FeaturedTag.newReleases,
          context.localisations.new_releases_30_days,
          Icons.new_releases
        ),
        (
          FeaturedTag.bestOfTheYear,
          context.localisations.best_of_the_year,
          Icons.reviews,
        ),
        (
          FeaturedTag.bestMetacritic,
          context.localisations.best_metacritic,
          Icons.fast_rewind,
        ),
        (
          FeaturedTag.allTimeTop100,
          context.localisations.all_time_top_100,
          Icons.thumb_up_sharp,
        ),
      ];

  void showBottomSheet(BuildContext context) {
    final initialPlatforms =
        context.read<FeaturedBloc>().state.platformsSelected;

    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) => FeaturedFilterBottomSheet(
        initialPlatforms: initialPlatforms,
        onSaveClick: (platforms) => _fetchGames(
          tag: context.read<FeaturedBloc>().state.tag,
          platformSelected: platforms,
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<FeaturedBloc, FeaturedState>(
          builder: (context, state) {
            return CustomScrollView(
              controller: _controller,
              physics: const BouncingScrollPhysics(),
              slivers: [
                DefaultSliverAppBar(
                  title: context.localisations.featured,
                  subtitle: context.localisations.featured_subtitle,
                  actionOne: (
                    IconButton(
                      onPressed: () => showBottomSheet(context),
                      icon: Icon(
                        Icons.filter_list,
                        color: context.themeData.colorScheme.onBackground,
                      ),
                    ),
                    null
                  ),
                ),
                FilterlistAppBar<FeaturedTag>(
                  selected: (selectedTag) => _fetchGames(tag: selectedTag),
                  filterList: featuredFilters,
                ),
                if (state.status == FeaturedStatus.success)
                  CupertinoSliverRefreshControl(
                    onRefresh: () async => _fetchGames(tag: state.tag),
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
                            state.games[index].id!,
                            RouteConstants.featured,
                            state.games[index].backgroundImage
                          );
                          context.push(
                            RouteConstants.gameDetail,
                            extra: extra,
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
                        onRetryClicked: () => _fetchNextPage(),
                      ),
                    ),
                  ),
                if (state.status == FeaturedStatus.failed)
                  SliverFillRemaining(
                    child: Center(
                      child: ErrorRetryWidget(
                        onRetryClicked: () {
                          _fetchGames();
                        },
                      ),
                    ),
                  ),
                if (state.status == FeaturedStatus.empty)
                  SliverFillRemaining(
                    child: Center(
                      child: ErrorRetryWidget(
                        text: context.localisations.no_results_found,
                        onRetryClicked: () {
                          _fetchGames();
                        },
                      ),
                    ),
                  ),
                if (state.status == FeaturedStatus.loading)
                  const SliverFillRemaining(
                    child: GameItemGridLoadingShimmer(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

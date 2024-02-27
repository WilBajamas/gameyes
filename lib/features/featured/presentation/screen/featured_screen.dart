import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/best_metacritic_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/home/presentation/notifier/scroll_notifier.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_sliver_app_bar.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_retry_widget.dart';
import 'package:gaming_library_assessment_flutter/widgets/filter_list_app_bar.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item_grid_loading_shimmer.dart';

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
    context.read<BestMetacriticCubit>().fetchBestMetacritic();

    _controller.addListener(_onScroll);

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
  }

  void _fetchGames() {
    // final filterState = context.read<FilterCubit>().state;
    // context.read<GamesBloc>().add(
    //       GamesFetched(
    //         resetPage: resetPage,
    //         searchTerm: filterState.searchTerm,
    //         dateFrom: filterState.dateFrom,
    //         dateTo: filterState.dateTo,
    //         platforms: [filterState.gamesPlatform],
    //         ordering: filterState.ordering,
    //       ),
    //     );
  }

  List<(String, String, IconData)> featuredFilters(BuildContext context) => [
        (
          TagConstants.newAndTrending,
          context.localisations.new_and_trending,
          Icons.trending_up
        ),
        (
          TagConstants.newReleases,
          context.localisations.new_releases_30_days,
          Icons.new_releases
        ),
        (
          TagConstants.bestOfTheYear,
          context.localisations.best_of_the_year,
          Icons.reviews,
        ),
        (
          TagConstants.popularLastYear,
          context.localisations.popular_last_year,
          Icons.fast_rewind,
        ),
        (
          TagConstants.allTimeTop100,
          context.localisations.all_time_top_100,
          Icons.thumb_up_sharp,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<BestMetacriticCubit, BestMetacriticState>(
          builder: (context, state) {
            return CustomScrollView(
              controller: _controller,
              physics: const BouncingScrollPhysics(),
              slivers: [
                DefaultSliverAppBar(
                  title: context.localisations.featured,
                  subtitle: context.localisations.featured_subtitle,
                ),
                FilterlistAppBar(
                  selected: (selectedTag) {},
                  filterList: featuredFilters(context),
                ),
                if (state.status == BestMetacriticStatus.success)
                  CupertinoSliverRefreshControl(
                    onRefresh: () async => _fetchGames(),
                  ),
                if (state.status == BestMetacriticStatus.success)
                  SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: state.games!.results!.length,
                    itemBuilder: (context, index) => GameItem(
                      game: state.games!.results![index],
                    ),
                  ),
                if (state.status == BestMetacriticStatus.failed)
                  SliverFillRemaining(
                    child: Center(
                      child: ErrorRetryWidget(
                        onRetryClicked: () => context
                            .read<BestMetacriticCubit>()
                            .fetchBestMetacritic(),
                      ),
                    ),
                  ),
                if (state.status == BestMetacriticStatus.empty)
                  SliverFillRemaining(
                    child: Center(
                      child: ErrorRetryWidget(
                        text: context.localisations.no_results_found,
                        onRetryClicked: () => context
                            .read<BestMetacriticCubit>()
                            .fetchBestMetacritic(),
                      ),
                    ),
                  ),
                if (state.status == BestMetacriticStatus.loading)
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

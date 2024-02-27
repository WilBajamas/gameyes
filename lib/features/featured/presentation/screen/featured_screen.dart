import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/best_metacritic_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/screen/best_metacritic_list_section.dart';
import 'package:gaming_library_assessment_flutter/features/home/presentation/notifier/scroll_notifier.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_sliver_app_bar.dart';
import 'package:gaming_library_assessment_flutter/widgets/filter_list_app_bar.dart';

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
    // context.read<MostAnticipatedCubit>().fetchMostAnticipated();
    context.read<BestMetacriticCubit>().fetchBestMetacritic();
    // context.read<LatestReleasesCubit>().fetchLatestReleases();

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

  void _fetchGames({bool resetPage = true}) {
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
            return NestedScrollView(
              headerSliverBuilder: (context, _) => [
                DefaultSliverAppBar(
                  title: context.localisations.featured,
                  subtitle: context.localisations.featured_subtitle,
                ),
                FilterlistAppBar(
                  selected: (selectedTag) {},
                  filterList: featuredFilters(context),
                ),
              ],
              body: RefreshIndicator(
                onRefresh: () async {
                  _fetchGames();
                },
                child: BestMetacriticListSection(
                  controller: _controller,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/best_metacritic_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/latest_releases_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/most_anticipated_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/screen/best_metacritic_list_section.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/screen/latest_released_list_section.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/screen/most_anticipated_list_section.dart';
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
    context.read<MostAnticipatedCubit>().fetchMostAnticipated();
    context.read<BestMetacriticCubit>().fetchBestMetacritic();
    context.read<LatestReleasesCubit>().fetchLatestReleases();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _controller,
          physics: const BouncingScrollPhysics(),
          slivers: [
            DefaultSliverAppBar(
              title: context.localisations.featured,
              subtitle: context.localisations.featured_subtitle,
            ),

            FilterlistAppBar(
              selected: (selectedTag) {},
              filterList: [
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
              ],
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            //** Most anticipated - 1 year ago to now*/
            const SliverToBoxAdapter(child: MostAnticipatedListSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            //** Best metacritics */
            const SliverToBoxAdapter(child: BestMetacriticListSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            //** Latest releases - 2 months ago to now */
            const SliverToBoxAdapter(child: LatestReleasedListSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }
}

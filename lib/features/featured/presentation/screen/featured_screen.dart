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

class FeaturedScreen extends StatefulWidget {
  const FeaturedScreen({Key? key}) : super(key: key);

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
            SliverAppBar(
              stretchTriggerOffset: 300.0,
              expandedHeight: context.screenHeight / 3,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Image.asset(
                      '${PathConstants.imagePath}featured_title_img.jpeg',
                      width: context.screenWidth,
                      height: context.screenHeight,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.7), // 70% opacity
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          context.localisations.featured_screen_title,
                          style: context.themeData.textTheme.displayLarge!
                              .merge(const TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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

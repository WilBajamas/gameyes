import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/home/presentation/notifier/scroll_notifier.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repository/tracker_repository.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubit/tracker_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/filter_list_app_bar.dart';
import 'package:gaming_library_assessment_flutter/widgets/saved_game_item.dart';
import 'package:go_router/go_router.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  final _controller = ScrollController();
  final _scrollChangeNotifier = getIt.get<ScrollNotifier>();
  final _trackerRepository = getIt<TrackerRepository>();

  @override
  void initState() {
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

  List<(SavedGameFilterTag, String, IconData?)> get trackerFilters => [
        (
          SavedGameFilterTag.recentlyChanged,
          context.localisations.recently_changed,
          null,
        ),
        (
          SavedGameFilterTag.name,
          context.localisations.name,
          null,
        ),
        (
          SavedGameFilterTag.playtime,
          context.localisations.playtime,
          null,
        ),
        (
          SavedGameFilterTag.date,
          context.localisations.date_added,
          null,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _controller,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true,
              toolbarHeight: kToolbarHeight + 10,
              backgroundColor: context.themeData.scaffoldBackgroundColor,
              surfaceTintColor: context.themeData.scaffoldBackgroundColor,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchBar(
                    hintText: context.localisations.search_saved_games,
                    padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 12),
                    ),
                    elevation: const MaterialStatePropertyAll<double>(
                      1,
                    ),
                    leading: Icon(
                      Icons.search,
                      color: context.themeData.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            FilterlistAppBar<SavedGameFilterTag>(
              selected: (selectedTag) =>
                  context.read<TrackerCubit>().setTag(selectedTag),
              filterList: trackerFilters,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              sliver: BlocBuilder<TrackerCubit, SavedGameFilterTag>(
                builder: (context, state) {
                  return StreamBuilder<List<SavedGame>>(
                    stream: _trackerRepository.savedGamesStream(state),
                    builder: (context, snapshot) {
                      final list = snapshot.data;

                      switch (list) {
                        case List<SavedGame>? list
                            when list != null && list.isNotEmpty:
                          return SliverList.builder(
                            itemCount: list.length,
                            itemBuilder: (context, index) => SavedGameItem(
                              savedGame: list[index],
                              onItemClick: (gameId, imageUrl) {
                                final extra =
                                    (gameId, RouteConstants.tracker, imageUrl);

                                context.push(
                                  RouteConstants.gameDetail,
                                  extra: extra,
                                );
                              },
                            ),
                          );

                        default:
                          // Empty or null saved games
                          return SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 40,
                                horizontal: 16,
                              ),
                              child: Center(
                                heightFactor: 1,
                                child: Text(
                                  // ignore: lines_longer_than_80_chars
                                  '${context.localisations.no_games_saved} \n${context.localisations.no_games_saved_description}',
                                  textAlign: TextAlign.center,
                                  style: context.themeData.textTheme.bodySmall,
                                ),
                              ),
                            ),
                          );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

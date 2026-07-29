import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_saved_game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubits/tracker_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubits/tracker_state.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_alert_dialog.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_filter_list_app_bar.dart';
import 'package:gaming_library_assessment_flutter/widgets/saved_game_item.dart';

import '../../../../generated/l10n.dart';

@RoutePage()
class TrackerScreen extends StatelessWidget {
  TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => getIt<TrackerCubit>(),
          child: const _TrackerView(),
        ),
      ),
    );
  }
}

class _TrackerView extends StatelessWidget {
  const _TrackerView();

  void removeSavedGame(
    BuildContext context,
    int savedGameId,
  ) {
    final cubit = context.read<TrackerCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => DefaultAlertDialog(
        title: S.current.delete_saved_game,
        description: S.current.delete_saved_game_description,
        onPositivePressed: () => cubit.removeSavedGame(savedGameId),
      ),
    );
  }

  List<(SavedGameFilterTag, String, IconData?)> get trackerFilters => [
        (
          SavedGameFilterTag.recentlyChanged,
          S.current.recently_changed,
          null,
        ),
        (
          SavedGameFilterTag.name,
          S.current.name,
          null,
        ),
        (
          SavedGameFilterTag.date,
          S.current.date_added,
          null,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
                onSubmitted: (term) =>
                    context.read<TrackerCubit>().setSearchTerm(term),
                hintText: S.current.search_saved_games,
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 12),
                ),
                elevation: const WidgetStatePropertyAll<double>(
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
        DefaultFilterListAppBar<SavedGameFilterTag>(
          filterList: trackerFilters,
          initialSelection: context.read<TrackerCubit>().state.tag,
          selected: (selectedTag) =>
              context.read<TrackerCubit>().setSortTag(selectedTag),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          sliver: BlocBuilder<TrackerCubit, TrackerState>(
            builder: (context, state) {
              return StreamBuilder<List<TrackerSavedGameEntity>>(
                stream: context.read<TrackerCubit>().savedGamesStream,
                builder: (context, snapshot) {
                  final list = snapshot.data;

                  switch (list) {
                    case List<TrackerSavedGameEntity>? list
                        when list != null && list.isNotEmpty:
                      return _TrackerList(
                        onRemoveClick: (savedGameId) =>
                            removeSavedGame(context, savedGameId),
                        onDetailClick: (gameId, imageUrl) {
                          final extra =
                              (gameId, RouteConstants.tracker, imageUrl);

                          context.router.push(
                            GameDetailRoute(gameExtra: extra),
                          );
                        },
                        list: list,
                      );

                    default:
                      // Empty or null saved games
                      return const _EmptyListDescription();
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TrackerList extends StatelessWidget {
  final Function(int) onRemoveClick;
  final Function(int, String?) onDetailClick;
  final List<TrackerSavedGameEntity> list;

  const _TrackerList({
    required this.onRemoveClick,
    required this.onDetailClick,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          context.router.push(
            TrackerGameDetailRoute(game: list[index]),
          );
        },
        child: SavedGameItem(
          savedGame: list[index],
          onRemoveClick: onRemoveClick,
          onDetailClick: onDetailClick,
        ),
      ),
    );
  }
}

class _EmptyListDescription extends StatelessWidget {
  const _EmptyListDescription();

  @override
  Widget build(BuildContext context) {
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
            '${S.current.no_games_saved} \n${S.current.no_games_saved_description}',
            textAlign: TextAlign.center,
            style: context.themeData.textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}

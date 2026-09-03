import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_saved_game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubits/tracker_detail_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubits/tracker_detail_state.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/screens/tracker_game_detail_section.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/screens/tracker_tasks_section.dart';
import 'package:gaming_library_assessment_flutter/widgets/saved_game_status_tag.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../generated/l10n.dart';

@RoutePage()
class TrackerGameDetailScreen extends StatelessWidget {
  final TrackerSavedGameEntity game;

  const TrackerGameDetailScreen({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TrackerDetailCubit>(param1: game),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, _) => [
                SliverAppBar(
                  title: Text(game.name!),
                  centerTitle: false,
                  expandedHeight: context.screenHeight * 0.3,
                  backgroundColor: Colors.blueGrey[900],
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.details_outlined),
                    ),
                  ],
                  pinned: true,
                  flexibleSpace: const FlexibleSpaceBar(
                    collapseMode: CollapseMode.none,
                    background: _HeaderBackground(),
                  ),
                  bottom: TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.white,
                    tabs: <Widget>[
                      Tab(text: S.current.details),
                      Tab(text: S.current.tasks),
                    ],
                  ),
                ),
              ],
              body: const TabBarView(
                children: [TrackerGameDetailSection(), TrackerTasksSection()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  const _HeaderBackground();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackerDetailCubit, TrackerDetailState>(
      builder: (context, state) {
        return Stack(
          children: [
            CachedNetworkImage(
              imageUrl: state.game!.imageUrl!,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(
                      Colors.black54,
                      BlendMode.darken,
                    ),
                  ),
                ),
              ),
            ),
            Container(color: Colors.black54),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${S.current.date_added}:',
                          style: context.themeData.textTheme.bodySmall!
                              .copyWith(color: Colors.white),
                        ),
                        Text(
                          state.game!.dateSaved
                              .getFormattedStringFromDateTimeSlash()!,
                          style: context.themeData.textTheme.bodyMedium!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {},
                          child: const SavedGameStatusTag(
                            status: Status.notStarted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AutoSizeText(
                          S.current.tasks_completed,
                          maxLines: 1,
                          maxFontSize: 20,
                          style: context.themeData.textTheme.displaySmall!
                              .copyWith(color: Colors.white),
                        ),
                        Text(
                          context
                              .read<TrackerDetailCubit>()
                              .getTasksCompletion(),
                          style: context.themeData.textTheme.displayLarge!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

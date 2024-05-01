import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/screen/tracker_game_detail_section.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/screen/tracker_tasks_section.dart';
import 'package:gaming_library_assessment_flutter/widgets/saved_game_status_tag.dart';

class TrackerGameDetailScreen extends StatelessWidget {
  final SavedGame game;

  const TrackerGameDetailScreen({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
                    icon: const Icon(
                      Icons.details_outlined,
                    ),
                  ),
                ],
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.none,
                  background: _HeaderBackground(
                    backgroundImage: game.imageUrl,
                    gameName: game.name,
                    dateSaved: game.dateSaved,
                  ),
                ),
                bottom: const TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.white,
                  tabs: <Widget>[
                    Tab(
                      text: 'Details',
                    ),
                    Tab(
                      text: 'Tasks',
                    ),
                  ],
                ),
              ),
            ],
            body: TabBarView(
              children: [
                TrackerGameDetailSection(game: game),
                const TrackerTasksSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  final String? backgroundImage;
  final String? gameName;
  final DateTime? dateSaved;

  const _HeaderBackground({
    required this.backgroundImage,
    required this.gameName,
    required this.dateSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: backgroundImage!,
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
                      context.localisations.date_started,
                      style: context.themeData.textTheme.bodySmall!
                          .copyWith(color: Colors.white),
                    ),
                    Text(
                      dateSaved.getFormattedStringFromDateTimeSlash()!,
                      style: context.themeData.textTheme.bodySmall!.copyWith(
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
                      context.localisations.tasks_completed,
                      maxLines: 1,
                      maxFontSize: 20,
                      style: context.themeData.textTheme.displaySmall!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '10/10',
                      style: context.themeData.textTheme.displayLarge!.copyWith(
                        color: Colors.white,
                      ),
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
  }
}

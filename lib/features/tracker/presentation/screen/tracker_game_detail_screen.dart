import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/screen/tracker_game_detail_section.dart';
import 'package:gaming_library_assessment_flutter/widgets/status_tag.dart';

class TrackerGameDetailScreen extends StatelessWidget {
  final SavedGame game;

  const TrackerGameDetailScreen({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, _) => [
              SliverAppBar(
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
                  background: _HeaderBackground(
                    backgroundImage: game.imageUrl,
                    gameName: game.name,
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
            body: const TabBarView(
              children: [
                TrackerGameDetailSection(),
                Center(
                  child: Text('Tasks'),
                ),
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

  const _HeaderBackground({
    required this.backgroundImage,
    required this.gameName,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, bottom: 20, top: 20),
                  child: AutoSizeText(
                    gameName!,
                    maxLines: 2,
                    minFontSize: 30,
                    style: context.themeData.textTheme.displayLarge!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          context.localisations.last_updated,
                          style: context.themeData.textTheme.bodySmall!
                              .copyWith(color: Colors.white),
                        ),
                        Text(
                          '01/10/1995',
                          style:
                              context.themeData.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {},
                      child: const StatusTag(
                        status: Status.inProgress,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

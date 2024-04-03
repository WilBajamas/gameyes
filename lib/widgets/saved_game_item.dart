import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_cached_network_image.dart';
import 'package:gaming_library_assessment_flutter/widgets/platform_row_list.dart';

class SavedGameItem extends StatelessWidget {
  // final SavedGame savedGame;

  const SavedGameItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: AspectRatio(
        aspectRatio: 2 / 1,
        child: _SlidableView(
          child: Row(
            children: [
              //* Image
              Expanded(
                child: _ImageView(
                  imageUrl:
                      'https://media.rawg.io/media/games/20a/20aa03a10cda45239fe22d035c0ebe64.jpg',
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //* Name & Date
                            _NameDateRow(
                              name: 'Grand Theft Auto V',
                              date: '3/4/2024',
                            ),

                            SizedBox(height: 8),

                            //* Task info
                            Expanded(
                              flex: 3,
                              child: _TaskColumn(
                                totalTasks: 10,
                                tasksCompleted: 10,
                              ),
                            ),

                            //* Platforms & Playtime
                            _PlatformPlaytimeRow(
                              playtime: '100h',
                              platforms: [GamePlatform.pc],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlidableView extends StatelessWidget {
  final Widget child;

  const _SlidableView({required this.child});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.7,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {},
            foregroundColor: context.themeData.colorScheme.primary,
            icon: Icons.delete,
            label: context.localisations.remove,
          ),
          SlidableAction(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            onPressed: (context) {},
            foregroundColor: context.themeData.colorScheme.primary,
            icon: Icons.details,
            label: context.localisations.details,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ImageView extends StatelessWidget {
  final String? imageUrl;
  const _ImageView({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
        child: DefaultCachedNetworkImage(
          imageUrl: imageUrl,
        ),
      ),
    );
  }
}

class _NameDateRow extends StatelessWidget {
  final String? name;
  final String? date;
  const _NameDateRow({required this.name, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //* Name
        Expanded(
          child: AutoSizeText(
            name ?? '-',
            maxFontSize: 20,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.themeData.textTheme.displayMedium,
          ),
        ),

        const SizedBox(width: 10),

        //* Date added
        Text(
          date ?? '-',
          style: context.themeData.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _TaskColumn extends StatelessWidget {
  final int totalTasks;
  final int tasksCompleted;

  const _TaskColumn({
    required this.totalTasks,
    required this.tasksCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //* Total task completion
        Text(
          context.localisations.tasks_completed,
          style: context.themeData.textTheme.bodySmall,
        ),
        Text(
          '$tasksCompleted/$totalTasks',
          style: context.themeData.textTheme.displayMedium,
        ),
      ],
    );
  }
}

class _PlatformPlaytimeRow extends StatelessWidget {
  final String playtime;
  final List<GamePlatform> platforms;

  const _PlatformPlaytimeRow({required this.playtime, required this.platforms});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 20,
            child: PlatformRowList(
              platforms: platforms,
            ),
          ),
        ),
        Text(
          playtime,
          style: context.themeData.textTheme.displayMedium,
        ),
      ],
    );
  }
}

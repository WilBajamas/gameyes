import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_cached_network_image.dart';
import 'package:gaming_library_assessment_flutter/widgets/platform_row_list.dart';

class SavedGameItem extends StatelessWidget {
  final SavedGame savedGame;

  const SavedGameItem({required this.savedGame, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: AspectRatio(
        aspectRatio: 2 / 1,
        child: _SlidableView(
          child: Row(
            children: [
              //* Image
              Expanded(
                child: _ImageView(
                  imageUrl: savedGame.imageUrl,
                  completed: savedGame.completed,
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //* Name & Date
                            _NameDateRow(
                              name: savedGame.name,
                              date: savedGame.dateSaved,
                            ),

                            const SizedBox(height: 8),

                            //* Task info
                            const Expanded(
                              flex: 3,
                              child: _TaskColumn(
                                totalTasks: null,
                                tasksCompleted: null,
                              ),
                            ),

                            //* Platforms & Playtime
                            const _PlatformPlaytimeRow(
                              playtime: null,
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
  final bool completed;
  const _ImageView({required this.imageUrl, required this.completed});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        bottomLeft: Radius.circular(8),
      ),
      child: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            child: DefaultCachedNetworkImage(
              imageUrl: imageUrl,
            ),
          ),
          if (completed) Container(color: Colors.black.withOpacity(0.5)),
          if (completed)
            const Center(
              child: Icon(
                Icons.check_circle_outline,
                size: 40,
                color: Colors.green,
              ),
            ),
        ],
      ),
    );
  }
}

class _NameDateRow extends StatelessWidget {
  final String? name;
  final DateTime? date;
  const _NameDateRow({required this.name, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //* Name
        AutoSizeText(
          name ?? '-',
          maxFontSize: 20,
          minFontSize: 14,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.themeData.textTheme.displayMedium,
        ),

        const SizedBox(height: 4),

        //* Date added
        Text(
          'Date added: ${date.getFormattedStringFromDateTimeSlash() ?? '-'}',
          style: context.themeData.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _TaskColumn extends StatelessWidget {
  final int? totalTasks;
  final int? tasksCompleted;

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
          '${tasksCompleted ?? '0'}/${totalTasks ?? '0'}',
          style: context.themeData.textTheme.displayMedium,
        ),
      ],
    );
  }
}

class _PlatformPlaytimeRow extends StatelessWidget {
  final String? playtime;
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
          playtime ?? '-',
          style: context.themeData.textTheme.displayMedium,
        ),
      ],
    );
  }
}

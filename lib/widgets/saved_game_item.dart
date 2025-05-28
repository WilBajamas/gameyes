import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_cached_network_image.dart';
import 'package:gaming_library_assessment_flutter/widgets/platform_row_list.dart';

import '../generated/l10n.dart';

class SavedGameItem extends StatelessWidget {
  final SavedGame savedGame;
  final Function(int gameId, String? backgroundImage) onDetailClick;
  final Function(int savedGameId) onRemoveClick;

  const SavedGameItem({
    required this.savedGame,
    required this.onDetailClick,
    required this.onRemoveClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: AspectRatio(
        aspectRatio: 2 / 1,
        child: _SlidableView(
          onRemoveClick: () => onRemoveClick(savedGame.id),
          onDetailClick: () =>
              onDetailClick(savedGame.gameId!, savedGame.imageUrl),
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
                            AutoSizeText(
                              savedGame.name ?? '-',
                              maxFontSize: 20,
                              minFontSize: 14,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.themeData.textTheme.displayMedium,
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
                            _PlatformDayAddedRow(
                              playtime: null,
                              platforms: savedGame.platforms,
                              date: savedGame.dateSaved,
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
  final VoidCallback onRemoveClick;
  final VoidCallback onDetailClick;

  const _SlidableView({
    required this.child,
    required this.onRemoveClick,
    required this.onDetailClick,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.7,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onRemoveClick(),
            foregroundColor: context.themeData.colorScheme.primary,
            icon: Icons.delete,
            label: S.current.remove,
          ),
          SlidableAction(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            onPressed: (context) => onDetailClick(),
            foregroundColor: context.themeData.colorScheme.primary,
            icon: Icons.details,
            label: S.current.details,
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
          S.current.tasks_completed,
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

class _PlatformDayAddedRow extends StatelessWidget {
  final String? playtime;
  final DateTime? date;
  final List<GamePlatform>? platforms;

  const _PlatformDayAddedRow({
    required this.playtime,
    required this.platforms,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: SizedBox(
            height: 20,
            child: platforms != null && platforms!.isNotEmpty
                ? PlatformRowList(
                    platforms: platforms!,
                    showMax: 3,
                  )
                : null,
          ),
        ),
        //* Date added
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${S.current.date_added}:',
              style: context.themeData.textTheme.bodySmall,
            ),
            Text(
              date.getFormattedStringFromDateTimeSlash() ?? '-',
              style: context.themeData.textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}

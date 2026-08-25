import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repositories/featured_repository.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_cached_network_image.dart';
import 'package:gaming_library_assessment_flutter/widgets/empty_state_card.dart';
import 'package:gaming_library_assessment_flutter/widgets/stat_pill.dart';

/// TODO: Refactor this widget - too long and many redundant things
class LibraryStatsWidget extends StatelessWidget {
  final LibrarySnapshotEntity? snapshot;
  final bool isChecklistDismissed;
  final bool step1Completed;
  final bool step2Completed;
  final bool step3Completed;
  final double checklistProgress;
  final VoidCallback onAddPlayedGame;
  final VoidCallback onMarkNowPlaying;
  final VoidCallback onWishlistUpcoming;

  const LibraryStatsWidget({
    super.key,
    required this.snapshot,
    required this.isChecklistDismissed,
    required this.step1Completed,
    required this.step2Completed,
    required this.step3Completed,
    required this.checklistProgress,
    required this.onAddPlayedGame,
    required this.onMarkNowPlaying,
    required this.onWishlistUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    final showChecklist =
        !isChecklistDismissed &&
        (snapshot == null || snapshot!.totalGamesCount == 0);

    if (showChecklist) {
      return _buildChecklistCard(context);
    } else {
      return _buildLibraryStats(context);
    }
  }

  Widget _buildChecklistCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              context.themeData.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.6,
              ),
              context.themeData.colorScheme.surface.withValues(alpha: 0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  S.current.welcome_to_gameyes,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Text(
                  '${(checklistProgress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.themeData.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              S.current.complete_onboarding_steps,
              style: TextStyle(
                fontSize: 14,
                color: context.themeData.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: checklistProgress,
                backgroundColor: context.themeData.colorScheme.surfaceContainer,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.themeData.colorScheme.primary,
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 20),
            _buildChecklistItem(
              context: context,
              title: S.current.add_game_played,
              completed: step1Completed,
              onTap: onAddPlayedGame,
              buttonText: S.current.add_button,
            ),
            const Divider(height: 24, thickness: 0.5),
            _buildChecklistItem(
              context: context,
              title: S.current.mark_playing_now,
              completed: step2Completed,
              onTap: onMarkNowPlaying,
              buttonText: S.current.mark_button,
            ),
            const Divider(height: 24, thickness: 0.5),
            _buildChecklistItem(
              context: context,
              title: S.current.wishlist_upcoming_game,
              completed: step3Completed,
              onTap: onWishlistUpcoming,
              buttonText: S.current.wishlist_button,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem({
    required BuildContext context,
    required String title,
    required bool completed,
    required VoidCallback onTap,
    required String buttonText,
  }) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: completed
                ? Colors.green.withValues(alpha: 0.2)
                : context.themeData.colorScheme.surfaceContainerHigh,
            border: Border.all(
              color: completed
                  ? Colors.green
                  : context.themeData.colorScheme.outline,
              width: 2,
            ),
          ),
          child: completed
              ? const Icon(Icons.check, size: 16, color: Colors.green)
              : null,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: completed ? FontWeight.w500 : FontWeight.normal,
              decoration: completed ? TextDecoration.lineThrough : null,
              color: completed
                  ? context.themeData.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.6,
                    )
                  : context.themeData.colorScheme.onSurface,
            ),
          ),
        ),
        if (!completed)
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              backgroundColor: context.themeData.colorScheme.primary.withValues(
                alpha: 0.1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: context.themeData.colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLibraryStats(BuildContext context) {
    final totalGames = snapshot?.totalGamesCount ?? 0;
    final wishlistCount = snapshot?.wishlistCount ?? 0;
    final weeklyHours = snapshot?.thisWeekPlayHours ?? 0.0;
    final playingGames = snapshot?.nowPlayingGames ?? [];

    final formattedHours = weeklyHours > 0.0
        ? S.current.hours_abbreviation(
            weeklyHours.toStringAsFixed(1).replaceFirst(RegExp(r'\.0$'), ''),
          )
        : S.current.hours_abbreviation('0');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: StatTile(
                figure: totalGames.toString(),
                label: S.current.total_games,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatTile(
                figure: wishlistCount.toString(),
                label: S.current.wishlist,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatTile(
                figure: formattedHours,
                label: S.current.this_week,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          S.current.now_playing,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        _buildNowPlayingCard(context, playingGames),
      ],
    );
  }

  Widget _buildNowPlayingCard(
    BuildContext context,
    List<SavedGame> playingGames,
  ) {
    if (playingGames.isEmpty) {
      return EmptyStateCard(
        glyph: Icons.play_circle_outline_rounded,
        headline: S.current.no_game_in_progress,
        supportingLine: S.current.pick_a_game_to_start_logging,
        actionLabel: S.current.mark_something_playing,
        onActionPressed: onMarkNowPlaying,
      );
    }

    final topGame = playingGames.first;
    final int extraCount = playingGames.length - 1;

    double? progressPercent;
    String? progressLabel;

    if (topGame.manualProgressPercentage != null) {
      progressPercent = topGame.manualProgressPercentage! / 100.0;
      progressLabel = S.current.completed_percentage(
        topGame.manualProgressPercentage!.toInt().toString(),
      );
    } else if (topGame.hoursLogged != null &&
        topGame.averageCompletionHours != null &&
        topGame.averageCompletionHours! > 0) {
      final calculated =
          (topGame.hoursLogged! / topGame.averageCompletionHours!) * 100;
      progressPercent = (calculated > 100 ? 100 : calculated) / 100.0;
      progressLabel = S.current.logged_hours_of(
        topGame.hoursLogged!.toStringAsFixed(1),
        topGame.averageCompletionHours!.toStringAsFixed(0),
      );
    } else if (topGame.hoursLogged != null) {
      progressLabel = S.current.played_hours(
        topGame.hoursLogged!.toStringAsFixed(1),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          if (extraCount >= 1) {
            // Route to Tracker tab [Z1-BL-04]
            AutoTabsRouter.of(context).setActiveIndex(2);
          } else {
            // Go to Tracker detail for this game
            context.router.push(
              TrackerGameDetailRoute(game: topGame.toEntity()),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 70,
                  height: 90,
                  child: topGame.imageUrl != null
                      ? DefaultCachedNetworkImage(imageUrl: topGame.imageUrl!)
                      : Container(
                          color: context.themeData.colorScheme.surfaceContainer,
                          child: const Icon(Icons.videogame_asset, size: 32),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topGame.name ?? StringConstants.emptyStringPlaceholder,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (extraCount >= 1)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color:
                              context.themeData.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          S.current.more_playing(extraCount.toString()),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: context
                                .themeData
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          S.current.active,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    if (progressLabel != null) ...[
                      Text(
                        progressLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: context.themeData.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                    if (progressPercent != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progressPercent,
                          minHeight: 6,
                          backgroundColor:
                              context.themeData.colorScheme.surfaceContainer,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green,
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

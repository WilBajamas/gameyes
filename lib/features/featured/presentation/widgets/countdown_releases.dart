import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_cached_network_image.dart';

// TODO: Refactor this
class CountdownReleasesWidget extends StatelessWidget {
  final GameEntity? countdownGame;
  final List<GameEntity> outThisWeekGames;
  final Duration? durationRemaining;
  final bool isReleaseDay;
  final bool isComingSoonLabel;
  final Set<int> localLibraryGameIds;
  final Function(int, String, String?) onGameClick;

  const CountdownReleasesWidget({
    super.key,
    required this.countdownGame,
    required this.outThisWeekGames,
    required this.durationRemaining,
    required this.isReleaseDay,
    required this.isComingSoonLabel,
    required this.localLibraryGameIds,
    required this.onGameClick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (countdownGame != null) ...[
          const Text(
            'Next Release Countdown',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          _buildCountdownCard(context),
          const SizedBox(height: 24),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isComingSoonLabel ? 'Coming Soon' : 'Out This Week',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            if (outThisWeekGames.isNotEmpty)
              Text(
                '${outThisWeekGames.length} games',
                style: TextStyle(
                  fontSize: 12,
                  color: context.themeData.colorScheme.onSurfaceVariant
                      .withValues(alpha: .6),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        _buildReleasesList(context),
      ],
    );
  }

  Widget _buildCountdownCard(BuildContext context) {
    final game = countdownGame!;
    final isFallback = !localLibraryGameIds.contains(game.id);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => onGameClick(game.id, game.name, game.cover.url),
          child: Stack(
            children: [
              // Background gradient and content
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.themeData.colorScheme.surfaceContainerHigh
                          .withValues(alpha: .85),
                      context.themeData.colorScheme.surface
                          .withValues(alpha: .95),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 80,
                        height: 110,
                        child: game.cover.url != null
                            ? DefaultCachedNetworkImage(
                                imageUrl: game.cover.url!)
                            : Container(
                                color: context
                                    .themeData.colorScheme.surfaceContainer,
                                child:
                                    const Icon(Icons.videogame_asset, size: 36),
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (isFallback)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: context
                                        .themeData.colorScheme.secondary
                                        .withValues(alpha: .12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '🔥 Global Hype',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: context
                                          .themeData.colorScheme.secondary,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withValues(alpha: .15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    '⭐ Wishlisted',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            game.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (isReleaseDay)
                            _buildCelebrationState(context)
                          else if (durationRemaining != null)
                            _buildTimerBlocks(context, durationRemaining!)
                          else
                            Text(
                              game.releaseDates?.firstOrNull?.human ??
                                  StringConstants.emptyStringPlaceholder,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: context
                                    .themeData.colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Nudge at the bottom if fallback
              if (isFallback)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: context.themeData.colorScheme.primaryContainer
                        .withValues(alpha: .3),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 12,
                          color: context.themeData.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Add upcoming games to your wishlist to countdown here!',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: context
                                  .themeData.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCelebrationState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green.withValues(alpha: .3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Out today! 🥳',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'The wait is over. Enjoy playing it now!',
            style: TextStyle(
              fontSize: 11,
              color:
                  context.themeData.colorScheme.onSurface.withValues(alpha: .8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerBlocks(BuildContext context, Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    return Row(
      children: [
        _buildTimeBox(context, days.toString().padLeft(2, '0'), 'Days'),
        const SizedBox(width: 8),
        _buildTimeBox(context, hours.toString().padLeft(2, '0'), 'Hrs'),
        const SizedBox(width: 8),
        _buildTimeBox(context, minutes.toString().padLeft(2, '0'), 'Mins'),
      ],
    );
  }

  Widget _buildTimeBox(BuildContext context, String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: context.themeData.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  context.themeData.colorScheme.outline.withValues(alpha: .1),
            ),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: context.themeData.colorScheme.onSurfaceVariant
                .withValues(alpha: .6),
          ),
        ),
      ],
    );
  }

  Widget _buildReleasesList(BuildContext context) {
    if (outThisWeekGames.isEmpty) {
      return Container(
        height: 170,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.themeData.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'No releases in this period',
            style: TextStyle(
              color: context.themeData.colorScheme.onSurfaceVariant
                  .withValues(alpha: .6),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: outThisWeekGames.length,
        itemBuilder: (context, index) {
          final game = outThisWeekGames[index];
          final isOwned = localLibraryGameIds.contains(game.id);

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () => onGameClick(game.id, game.name, game.cover.url),
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: game.cover.url != null
                                ? DefaultCachedNetworkImage(
                                    imageUrl: game.cover.url!)
                                : Container(
                                    color: context
                                        .themeData.colorScheme.surfaceContainer,
                                    child: const Icon(Icons.videogame_asset,
                                        size: 28),
                                  ),
                          ),
                        ),
                        if (isOwned)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      game.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

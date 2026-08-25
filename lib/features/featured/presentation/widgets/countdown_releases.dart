import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/countdown/countdown_card.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_cached_network_image.dart';
import 'package:gaming_library_assessment_flutter/widgets/empty_state_card.dart';
import 'package:gaming_library_assessment_flutter/widgets/library_tick.dart';

import '../../../../generated/l10n.dart';

class CountdownReleasesWidget extends StatelessWidget {
  final GameEntity? countdownGame;
  final List<GameEntity> outThisWeekGames;
  final Duration? durationRemaining;
  final bool isWishlisted;
  final bool isComingSoonLabel;
  final Set<int> localLibraryGameIds;
  final Function(int, String, String?) onGameClick;

  const CountdownReleasesWidget({
    super.key,
    required this.countdownGame,
    required this.outThisWeekGames,
    required this.durationRemaining,
    required this.isWishlisted,
    required this.isComingSoonLabel,
    required this.localLibraryGameIds,
    required this.onGameClick,
  });

  @override
  Widget build(BuildContext context) {
    final game = countdownGame;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (game != null) ...[
          const Text(
            'Next Release Countdown',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          CountdownCard(
            title: game.name,
            isWishlisted: isWishlisted,
            remaining: durationRemaining,
            releaseDateText: game.releaseDates?.firstOrNull?.human,
            onOpen: () => onGameClick(game.id, game.name, game.cover.url),
          ),
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

  Widget _buildReleasesList(BuildContext context) {
    if (outThisWeekGames.isEmpty) {
      return EmptyStateCard(
        glyph: Icons.calendar_month_outlined,
        headline: S.current.look_further_ahead,
        supportingLine: S.current.browse_for_your_next_game,
        actionLabel: S.current.browse_games,
        onActionPressed: () => AutoTabsRouter.of(context).setActiveIndex(3),
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
                                    imageUrl: game.cover.url!,
                                  )
                                : Container(
                                    color: context
                                        .themeData
                                        .colorScheme
                                        .surfaceContainer,
                                    child: const Icon(
                                      Icons.videogame_asset,
                                      size: 28,
                                    ),
                                  ),
                          ),
                        ),
                        if (isOwned)
                          const Positioned(
                            top: 6,
                            right: 6,
                            child: LibraryTick(),
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

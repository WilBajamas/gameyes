import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_genre.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repositories/featured_repository.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_cached_network_image.dart';
import 'package:gaming_library_assessment_flutter/widgets/empty_state_card.dart';

import '../../../../generated/l10n.dart';

// TODO: Refactor this
class CriticsGridWidget extends StatelessWidget {
  final List<GameEntity> criticsGames;
  final GenrePreferencesEntity? genrePreferencesEntity;
  final Set<int> localLibraryGameIds;
  final Function(int) onGenreToggled;
  final VoidCallback onSkipPressed;
  final Function(int, String, String?) onGameClick;

  const CriticsGridWidget({
    super.key,
    required this.criticsGames,
    required this.genrePreferencesEntity,
    required this.localLibraryGameIds,
    required this.onGenreToggled,
    required this.onSkipPressed,
    required this.onGameClick,
  });

  Color _getScoreColor(double score) {
    if (score >= 80) {
      return const Color(0xFF4CAF7D); // Green
    } else if (score >= 60) {
      return const Color(0xFFE6A430); // Amber
    } else {
      return const Color(0xFFE05555); // Red
    }
  }

  @override
  Widget build(BuildContext context) {
    final showGenrePicker =
        genrePreferencesEntity != null && !genrePreferencesEntity!.isSkipped;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showGenrePicker) ...[
          _buildGenrePicker(context),
          const SizedBox(height: 20),
        ],
        const Text(
          "Critics' Choice This Week",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        _buildGrid(context),
      ],
    );
  }

  Widget _buildGenrePicker(BuildContext context) {
    final selectedIds = genrePreferencesEntity?.genreIds ?? [];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.themeData.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.themeData.colorScheme.outline.withValues(alpha: .08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Personalize Your Discover Feed',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onSkipPressed,
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: context.themeData.colorScheme.onSurfaceVariant
                        .withValues(alpha: .6),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: GameGenre.values.map((genre) {
              final isSelected = selectedIds.contains(genre.id);
              return GestureDetector(
                onTap: () => onGenreToggled(genre.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.themeData.colorScheme.primary
                        : context.themeData.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? context.themeData.colorScheme.primary
                          : context.themeData.colorScheme.outline.withValues(
                              alpha: .12,
                            ),
                    ),
                  ),
                  child: Text(
                    genre.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? context.themeData.colorScheme.onPrimary
                          : context.themeData.colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    if (criticsGames.isEmpty) {
      return EmptyStateCard(
        glyph: Icons.tune_outlined,
        headline: S.current.open_up_your_genres,
        supportingLine: S.current.every_pick_without_a_genre_filter,
        actionLabel: S.current.show_every_pick,
        onActionPressed: onSkipPressed,
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: criticsGames.length,
      itemBuilder: (context, index) {
        final game = criticsGames[index];
        final isOwned = localLibraryGameIds.contains(game.id);
        final score = game.criticScore ?? 0.0;
        final scoreColor = _getScoreColor(score);

        return Card(
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () => onGameClick(game.id, game.name, game.cover.url),
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
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
                                    size: 36,
                                  ),
                                ),
                        ),
                      ),
                      if (isOwned)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              game.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (game.criticScore != null)
                            Text(
                              '${score.toInt()}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: scoreColor,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        game.releaseDates?.firstOrNull?.human ??
                            StringConstants.emptyStringPlaceholder,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: context.themeData.colorScheme.onSurfaceVariant
                              .withValues(alpha: .6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

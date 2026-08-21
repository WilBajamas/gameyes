import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_card/game_card_placeholder_bar.dart';
import 'package:gaming_library_assessment_flutter/widgets/platform_row_list.dart';

class GameCardSmallFooter extends StatelessWidget {
  const GameCardSmallFooter({super.key, this.game, this.criticScore});

  final GameEntity? game;
  final double? criticScore;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final game = this.game;
    final criticScore = this.criticScore;
    final platforms = game?.platforms;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        SizedBox(
          height: 24,
          child: game == null
              ? const GameCardPlaceholderBar(widthFactor: 1)
              : Text(
                  game.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tokens.typography.body.style.copyWith(
                    color: tokens.color.ink,
                  ),
                ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 20,
          child: game == null
              ? const GameCardPlaceholderBar(widthFactor: 0.4)
              : Row(
                  children: [
                    if (platforms != null && platforms.isNotEmpty)
                      Expanded(
                        child: SizedBox(
                          height: 16,
                          child: PlatformRowList(
                            platforms: platforms,
                            showMax: 1,
                          ),
                        ),
                      )
                    else
                      const Spacer(),
                    if (criticScore != null)
                      Text(
                        '${criticScore.round()}',
                        style: tokens.typography.meta.style,
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_card/game_card_medium_footer.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_card/game_card_size.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_card/game_card_small_footer.dart';

class GameCardFooter extends StatelessWidget {
  const GameCardFooter({
    super.key,
    required this.size,
    this.game,
    this.criticScore,
    this.onAddTap,
  });

  final GameCardSize size;
  final GameEntity? game;
  final double? criticScore;
  final VoidCallback? onAddTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.footerHeight,
      child: size == GameCardSize.sm
          ? GameCardSmallFooter(game: game, criticScore: criticScore)
          : GameCardMediumFooter(game: game, onAddTap: onAddTap),
    );
  }
}

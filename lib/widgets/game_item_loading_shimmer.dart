import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_card/game_card.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_card/enum/game_card_size.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GameItemLoadingShimmer extends StatelessWidget {
  const GameItemLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: GameCardSize.sm.cellHeightFor(GameCardSize.sm.width),
      child: Skeletonizer(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          separatorBuilder: (_, index) => const SizedBox(width: 8),
          itemBuilder: (_, index) => const GameCard(size: GameCardSize.sm),
        ),
      ),
    );
  }
}

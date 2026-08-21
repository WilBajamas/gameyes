import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_card/game_card.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_card/game_card_size.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GameItemGridLoadingShimmer extends StatelessWidget {
  const GameItemGridLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columnWidth = GamesGridConstants.columnWidth(
            constraints.maxWidth,
          );

          return GridView.builder(
            padding: const EdgeInsets.all(GamesGridConstants.gutter),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: GamesGridConstants.columnCount,
              mainAxisSpacing: GamesGridConstants.gutter,
              crossAxisSpacing: GamesGridConstants.gutter,
              mainAxisExtent: GameCardSize.md.cellHeightFor(columnWidth),
            ),
            itemCount: 4,
            itemBuilder: (_, index) => const GameCard(size: GameCardSize.md),
          );
        },
      ),
    );
  }
}

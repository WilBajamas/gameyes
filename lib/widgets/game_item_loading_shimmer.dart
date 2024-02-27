import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GameItemLoadingShimmer extends StatelessWidget {
  const GameItemLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (_, i) => const Padding(
          padding: EdgeInsets.only(left: 8),
          child: GameItem(),
        ),
      ),
    );
  }
}

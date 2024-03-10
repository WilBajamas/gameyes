import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GameItemGridLoadingShimmer extends StatelessWidget {
  const GameItemGridLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: 4,
        itemBuilder: (_, i) => const GameItem(
          fromScreen: '',
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/metacritic_indicator.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GameDetailTopContentShimmer extends StatelessWidget {
  const GameDetailTopContentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Skeletonizer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ** Name //
            Text(
              StringConstants.connectionTimeout,
              style: context.themeData.textTheme.displayMedium!,
            ),
            const SizedBox(height: 8),
            // ** Release date //
            Text(
              '${context.localisations.release_date}:',
              style: context.themeData.textTheme.titleMedium!,
            ),
            Text(
              StringConstants.connectionTimeout,
              style: context.themeData.textTheme.bodyLarge!,
            ),
            const SizedBox(height: 16),
            // ** Metacritic score //
            Row(
              children: [
                const MetacriticIndicator(
                  score: 10,
                  size: 60,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    context.localisations.metacritic_score,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

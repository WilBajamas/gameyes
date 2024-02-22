import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_detail_section_point.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GameDetailMidContentShimmer extends StatelessWidget {
  const GameDetailMidContentShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GameDetailSectionPoint(
                  title: context.localisations.genre,
                  value: StringConstants.connectionTimeout,
                ),
                const SizedBox(height: 12),
                GameDetailSectionPoint(
                  title: context.localisations.publishers,
                  value: StringConstants.connectionTimeout,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GameDetailSectionPoint(
                  title: context.localisations.developers,
                  value: StringConstants.connectionTimeout,
                ),
                const SizedBox(height: 12),
                GameDetailSectionPoint(
                  title: context.localisations.platforms,
                  value: StringConstants.connectionTimeout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

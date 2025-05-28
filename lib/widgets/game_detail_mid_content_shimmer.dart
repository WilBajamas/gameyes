import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_detail_section_point.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../generated/l10n.dart';

class GameDetailMidContentShimmer extends StatelessWidget {
  const GameDetailMidContentShimmer({super.key});

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
                  title: S.current.genre,
                  value: StringConstants.connectionTimeout,
                ),
                const SizedBox(height: 12),
                GameDetailSectionPoint(
                  title: S.current.publishers,
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
                  title: S.current.developers,
                  value: StringConstants.connectionTimeout,
                ),
                const SizedBox(height: 12),
                GameDetailSectionPoint(
                  title: S.current.platforms,
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

import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_detail_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_detail_section_point.dart';

class DetailMidSection extends StatelessWidget {
  final GameDetailState state;

  const DetailMidSection({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  value: state.response!.genreListString,
                ),
                const SizedBox(height: 12),
                GameDetailSectionPoint(
                  title: context.localisations.publishers,
                  value: state.response!.publisherListString,
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
                  value: state.response!.developerListString,
                ),
                const SizedBox(height: 12),
                GameDetailSectionPoint(
                  title: context.localisations.platforms,
                  value: state.response!.platformListString,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

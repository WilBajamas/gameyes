import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_detail_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_retry_widget.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_detail_mid_content_shimmer.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_detail_section_point.dart';
import 'package:gaming_library_assessment_flutter/widgets/horizontal_separator.dart';
import 'package:readmore/readmore.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../generated/l10n.dart';

class DetailMidSection extends StatelessWidget {
  final int? gameId;

  const DetailMidSection({super.key, required this.gameId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<GameDetailCubit, GameDetailState>(
        builder: (context, state) {
          if (state.status == GameDetailStatus.failed) {
            return Center(
              child: ErrorRetryWidget(
                onRetryClicked: () => gameId != null
                    ? context
                        .read<GameDetailCubit>()
                        .fetchGameDetail(id: gameId!)
                    : null,
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.current.about,
                style: context.themeData.textTheme.displayLarge,
              ),
              const SizedBox(height: 6),
              // ** Description //
              if (state.status == GameDetailStatus.success)
                AnimatedSize(
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 150),
                  child: Column(
                    children: [
                      ReadMoreText(
                        state.response!.description!,
                        trimLines: 7,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: S.current.read_more,
                        trimExpandedText: S.current.read_less,
                        style: context.themeData.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

              if (state.status == GameDetailStatus.loading)
                Skeletonizer(
                  child: Text(
                    StringConstants.connectionTimeout,
                    style: context.themeData.textTheme.bodySmall!,
                  ),
                ),

              const SizedBox(height: 20),

              const HorizontalSeparator(),

              const SizedBox(height: 20),

              DetailPointsSection(state: state),
            ],
          );
        },
      ),
    );
  }
}

class DetailPointsSection extends StatelessWidget {
  final GameDetailState state;
  const DetailPointsSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.status == GameDetailStatus.loading) {
      return const GameDetailMidContentShimmer();
    }

    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GameDetailSectionPoint(
                  title: S.current.genre,
                  value: state.response!.genreListString,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GameDetailSectionPoint(
                  title: S.current.publishers,
                  value: state.response!.publisherListString,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GameDetailSectionPoint(
                  title: S.current.developers,
                  value: state.response!.developerListString,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GameDetailSectionPoint(
                  title: S.current.platforms,
                  value: state.response!.platformListString,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

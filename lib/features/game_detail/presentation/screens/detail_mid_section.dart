import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_detail_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_retry_widget.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_detail_mid_content_shimmer.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_detail_section_point.dart';

class DetailMidSection extends StatelessWidget {
  final int? gameId;

  const DetailMidSection({Key? key, required this.gameId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<GameDetailCubit, GameDetailState>(
        builder: (context, state) {
          switch (state.status) {
            case GameDetailStatus.loading:
              return const GameDetailMidContentShimmer();
            case GameDetailStatus.success:
              return Row(
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
              );
            case GameDetailStatus.failed:
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
        },
      ),
    );
  }
}

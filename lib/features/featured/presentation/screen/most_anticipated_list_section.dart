import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/most_anticipated_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_retry_widget.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item_loading_shimmer.dart';

class MostAnticipatedListSection extends StatelessWidget {
  const MostAnticipatedListSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenWidth * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              context.localisations.most_anticipated,
              style: context.themeData.textTheme.displayMedium,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<MostAnticipatedCubit, MostAnticipatedState>(
              builder: (context, state) {
                final results = state.games?.results;

                switch (state.status) {
                  case MostAnticipatedStatus.success:
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: results?.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: GameItem(
                          game: results![index],
                          // imageUrl: results![index].backgroundImage,
                          // name: results[index].name,
                          // date: results[index].released,
                          // score: results[index].metacritic,
                        ),
                      ),
                    );

                  case MostAnticipatedStatus.empty:
                    return Center(
                      child: ErrorRetryWidget(
                        onRetryClicked: () => context
                            .read<MostAnticipatedCubit>()
                            .fetchMostAnticipated(),
                        text: context.localisations.no_results_found,
                      ),
                    );

                  case MostAnticipatedStatus.failed:
                    return Center(
                      child: ErrorRetryWidget(
                        onRetryClicked: () => context
                            .read<MostAnticipatedCubit>()
                            .fetchMostAnticipated(),
                      ),
                    );

                  default:
                    return const GameItemLoadingShimmer();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

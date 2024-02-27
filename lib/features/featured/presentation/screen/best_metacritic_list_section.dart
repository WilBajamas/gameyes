import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/best_metacritic_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_retry_widget.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item_loading_shimmer.dart';

class BestMetacriticListSection extends StatelessWidget {
  const BestMetacriticListSection({super.key});

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
              context.localisations.best_metacritic,
              style: context.themeData.textTheme.displayMedium,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<BestMetacriticCubit, BestMetacriticState>(
              builder: (context, state) {
                final results = state.games?.results;

                switch (state.status) {
                  case BestMetacriticStatus.success:
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: results?.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: GameItem(
                          game: results![index],
                        ),
                      ),
                    );

                  case BestMetacriticStatus.empty:
                    return Center(
                      child: ErrorRetryWidget(
                        onRetryClicked: () => context
                            .read<BestMetacriticCubit>()
                            .fetchBestMetacritic(),
                        text: context.localisations.no_results_found,
                      ),
                    );

                  case BestMetacriticStatus.failed:
                    return Center(
                      child: ErrorRetryWidget(
                        onRetryClicked: () => context
                            .read<BestMetacriticCubit>()
                            .fetchBestMetacritic(),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/best_metacritic_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_retry_widget.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item_loading_shimmer.dart';

class BestMetacriticListSection extends StatelessWidget {
  final ScrollController controller;
  const BestMetacriticListSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BestMetacriticCubit, BestMetacriticState>(
      builder: (context, state) {
        final results = state.games?.results;

        switch (state.status) {
          case BestMetacriticStatus.success:
            return GridView.builder(
              controller: controller,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
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
                onRetryClicked: () =>
                    context.read<BestMetacriticCubit>().fetchBestMetacritic(),
                text: context.localisations.no_results_found,
              ),
            );

          case BestMetacriticStatus.failed:
            return Center(
              child: ErrorRetryWidget(
                onRetryClicked: () =>
                    context.read<BestMetacriticCubit>().fetchBestMetacritic(),
              ),
            );

          default:
            return const GameItemLoadingShimmer();
        }
      },
    );
  }
}

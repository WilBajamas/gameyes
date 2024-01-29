import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/latest_releases_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_retry_widget.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item_loading_shimmer.dart';

class LatestReleasedListSection extends StatelessWidget {
  const LatestReleasedListSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              StringConstants.latestReleases,
              style: context.themeData.textTheme.displayMedium,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<LatestReleasesCubit, LatestReleasesState>(
              builder: (context, state) {
                final results = state.games?.results;

                switch (state.status) {
                  case LatestReleasesStatus.success:
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: results?.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: GameItem(
                          imageUrl: results![index].backgroundImage,
                          name: results[index].name,
                          date: results[index].released,
                          score: results[index].metacritic,
                        ),
                      ),
                    );

                  case LatestReleasesStatus.empty:
                    return Center(
                      child: ErrorRetryWidget(
                        onRetryClicked: () => context
                            .read<LatestReleasesCubit>()
                            .fetchLatestReleases(),
                        text: StringConstants.noResultsFound,
                      ),
                    );

                  case LatestReleasesStatus.failed:
                    return Center(
                      child: ErrorRetryWidget(
                        onRetryClicked: () => context
                            .read<LatestReleasesCubit>()
                            .fetchLatestReleases(),
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

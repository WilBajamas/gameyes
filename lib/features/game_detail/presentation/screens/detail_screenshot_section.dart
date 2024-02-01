import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_screenshot_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_retry_widget.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_screenshot.dart';

class DetailScreenshotsSection extends StatelessWidget {
  final String? slug;

  const DetailScreenshotsSection({Key? key, required this.slug})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight / 3,
      child: BlocBuilder<GameScreenshotCubit, GameScreenshotState>(
        builder: (context, state) {
          switch (state.status) {
            case ScreenshotsStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case ScreenshotsStatus.failure:
              return Center(
                child: ErrorRetryWidget(
                  onRetryClicked: () => context
                      .read<GameScreenshotCubit>()
                      .fetchGameScreenshots(slug: slug!),
                ),
              );
            case ScreenshotsStatus.success:
              if (state.response?.results != null &&
                  state.response!.results.isNotEmpty) {
                return ListView.builder(
                  padding: const EdgeInsets.only(left: 12),
                  itemCount: state.response!.results.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GameScreenshot(
                      imageUrl: state.response?.results[index].image,
                    ),
                  ),
                );
              } else {
                return Center(
                  child: ErrorRetryWidget(
                    text: context.localisations.no_results_found,
                    onRetryClicked: () => context
                        .read<GameScreenshotCubit>()
                        .fetchGameScreenshots(slug: slug!),
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

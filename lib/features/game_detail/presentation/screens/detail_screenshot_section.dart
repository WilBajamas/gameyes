import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_screenshot_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_retry_widget.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_screenshot.dart';
import 'package:go_router/go_router.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../../../../generated/l10n.dart';

class DetailScreenshotsSection extends StatelessWidget {
  final int id;

  const DetailScreenshotsSection({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameScreenshotCubit(id: id!),
      child: SizedBox(
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
                        .fetchGameScreenshots(id: id!),
                  ),
                );
              case ScreenshotsStatus.success:
                if (state.response?.results != null &&
                    state.response!.results.isNotEmpty) {
                  return ScrollSnapList(
                    onItemFocus: (int _) {},
                    itemSize: context.screenWidth,
                    itemBuilder: (context, index) => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GameScreenshot(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        imageUrl: state.response?.imageUrls[index],
                        onImageTap: () => context.pushNamed(
                          RouteConstants.imagePageView,
                          extra: (state.response?.imageUrls, index),
                        ),
                      ),
                    ),
                    itemCount: state.response!.results.length,
                    duration: 200,
                    scrollPhysics: const PageScrollPhysics(),
                  );
                } else {
                  return Center(
                    child: ErrorRetryWidget(
                      text: S.current.no_results_found,
                      onRetryClicked: () => context
                          .read<GameScreenshotCubit>()
                          .fetchGameScreenshots(id: id!),
                    ),
                  );
                }
            }
          },
        ),
      ),
    );
  }
}

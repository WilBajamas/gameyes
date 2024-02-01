import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_detail_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_screenshot_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/screens/detail_mid_section.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/screens/detail_screenshot_section.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/screens/detail_top_header.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_retry_widget.dart';

class GameDetailScreen extends StatefulWidget {
  final int? gameId;
  final String? slug;

  const GameDetailScreen({Key? key, this.gameId, this.slug}) : super(key: key);

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  @override
  void initState() {
    context.read<GameDetailCubit>().fetchGameDetail(id: widget.gameId!);
    context
        .read<GameScreenshotCubit>()
        .fetchGameScreenshots(slug: widget.slug!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            const SliverAppBar(),
          ],
          body: BlocBuilder<GameDetailCubit, GameDetailState>(
            builder: (context, state) {
              switch (state.status) {
                case GameDetailStatus.loading:
                  return const Center(child: CircularProgressIndicator());
                case GameDetailStatus.failed:
                  return Center(
                    child: ErrorRetryWidget(
                      onRetryClicked: () => widget.gameId != null
                          ? context
                              .read<GameDetailCubit>()
                              .fetchGameDetail(id: widget.gameId!)
                          : null,
                    ),
                  );
                case GameDetailStatus.success:
                  return ListView(
                    padding: const EdgeInsets.only(bottom: 16),
                    children: [
                      DetailTopHeader(
                        state: state,
                        id: widget.gameId,
                      ),
                      const SizedBox(height: 20),
                      DetailMidSection(state: state),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 12),
                        child: Text(
                          context.localisations.screenshots,
                          style: context.themeData.textTheme.displayLarge,
                        ),
                      ),
                      DetailScreenshotsSection(slug: widget.slug),
                    ],
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}

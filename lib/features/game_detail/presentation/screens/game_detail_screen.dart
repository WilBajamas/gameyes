import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_detail_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_screenshot_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/screens/detail_mid_section.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/screens/detail_screenshot_section.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/screens/detail_top_header.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/game.dart';

class GameDetailScreen extends StatefulWidget {
  final Game? game;

  const GameDetailScreen({super.key, this.game});

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  @override
  void initState() {
    context.read<GameDetailCubit>().resetContent;
    context.read<GameDetailCubit>().fetchGameDetail(id: widget.game!.id!);
    context
        .read<GameScreenshotCubit>()
        .fetchGameScreenshots(slug: widget.game!.slug!);
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
          body: Stack(
            children: [
              ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 16),
                children: [
                  DetailTopHeader(
                    gameId: widget.game!.id,
                    image: widget.game!.backgroundImage,
                  ),
                  DetailMidSection(gameId: widget.game!.id),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 12),
                    child: Text(
                      context.localisations.screenshots,
                      style: context.themeData.textTheme.displayLarge,
                    ),
                  ),
                  DetailScreenshotsSection(slug: widget.game!.slug),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

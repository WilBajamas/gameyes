import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubits/game_detail_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubits/game_detail_state.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/screens/detail_mid_section.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/screens/detail_top_header.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';

import '../../../../generated/l10n.dart';

@RoutePage()
class GameDetailScreen extends StatelessWidget {
  final (int, String, String?)? gameExtra;

  const GameDetailScreen({super.key, this.gameExtra});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GameDetailCubit>(param1: gameExtra!.$1),
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, _) => [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight:
                    (context.screenHeight * 0.35) + kToolbarHeight * 2,
                actions: [
                  BlocSelector<GameDetailCubit, GameDetailState, SavedGame?>(
                    selector: (state) => state.savedGame,
                    builder: (context, state) {
                      return IconButton(
                        onPressed: () =>
                            context.read<GameDetailCubit>().saveButtonClicked(),
                        icon: state == null
                            ? const Icon(Icons.star_border)
                            : const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: DetailTopHeader(
                    gameId: gameExtra!.$1,
                    image: gameExtra!.$3,
                    fromScreen: gameExtra!.$2,
                  ),
                ),
              ),
            ],
            body: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 16),
              children: [
                DetailMidSection(gameId: gameExtra!.$1),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 12),
                  child: Text(
                    S.current.screenshots,
                    style: context.themeData.textTheme.displayLarge,
                  ),
                ),

                /// TODO: fetch screenshots - from game detail
                // DetailScreenshotsSection(id: gameExtra!.$1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

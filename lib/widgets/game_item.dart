import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_cached_network_image.dart';
import 'package:gaming_library_assessment_flutter/widgets/metacritic_indicator.dart';
import 'package:gaming_library_assessment_flutter/widgets/platform_row_list.dart';

class GameItem extends StatelessWidget {
  final GameEntity? game;
  final bool showReleaseDate;
  final VoidCallback? onItemClick;
  final String fromScreen;

  const GameItem({
    super.key,
    this.game,
    this.showReleaseDate = false,
    this.onItemClick,
    required this.fromScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onItemClick,
        child: SizedBox(
          width: context.screenWidth / 2.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TopStack(
                game: game,
                fromScreen: fromScreen,
              ),

              const SizedBox(height: 4),

              //** Platforms */
              if (!showReleaseDate &&
                  game?.platforms != null &&
                  game!.platforms!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    height: 16,
                    child: PlatformRowList(
                      platforms: game!.platforms!,
                    ),
                  ),
                ),

              const SizedBox(height: 4),

              //** Date */
              if (showReleaseDate)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: AutoSizeText(
                    game?.releaseDate?.stringToDateString() ??
                        StringConstants.emptyStringPlaceholder,
                    maxLines: 1,
                    maxFontSize: 14,
                    style: context.themeData.textTheme.bodyLarge,
                  ),
                ),

              const SizedBox(height: 4),

              //** Name */
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: AutoSizeText(
                    game?.name ?? StringConstants.emptyStringPlaceholder,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: context.themeData.textTheme.displaySmall,
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopStack extends StatelessWidget {
  final GameEntity? game;
  final String fromScreen;

  const _TopStack({
    this.game,
    required this.fromScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 4 / 4.8,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: game?.imageUrl != null

                //** Image */
                ? Hero(
                    tag: '${ConfigConstants.heroTag}/${game?.id}/$fromScreen',
                    child: DefaultCachedNetworkImage(
                      imageUrl: game!.imageUrl!,
                    ),
                  )
                : Center(
                    child: Image.asset(
                      'assets/images/${AssetConstants.error404}',
                      height: 40,
                    ),
                  ),
          ),
        ),

        //** Score */
        if (game?.metacritic != null)
          Positioned(
            bottom: 8,
            right: 8,
            child: MetacriticIndicator(
              score: game?.metacritic,
            ),
          ),
      ],
    );
  }
}

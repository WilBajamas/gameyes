import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/widgets/metacritic_indicator.dart';
import 'package:gaming_library_assessment_flutter/widgets/platform_row_list.dart';
import 'package:go_router/go_router.dart';

class GameItem extends StatelessWidget {
  final Game? game;
  final bool showReleaseDate;

  const GameItem({
    super.key,
    this.game,
    this.showReleaseDate = false,
  });

  void onClickGameItem(
    BuildContext context,
  ) {
    if (game case final game?) {
      context.push(
        RouteConstants.gameDetail,
        extra: game,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => onClickGameItem(
          context,
        ),
        child: SizedBox(
          width: context.screenWidth / 2.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TopStack(
                game: game,
              ),

              const SizedBox(height: 4),

              //** Platforms */
              if (!showReleaseDate &&
                  game?.platformValues != null &&
                  game!.platformValues!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    height: 16,
                    child: PlatformRowList(
                      platforms: game!.platformValues!,
                    ),
                  ),
                ),

              const SizedBox(height: 4),

              //** Date */
              if (showReleaseDate)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: AutoSizeText(
                    game?.released.stringToDateString() ??
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
  final Game? game;

  const _TopStack({this.game});

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
            child: game?.backgroundImage != null

                //** Image */
                ? Hero(
                    tag: '${ConfigConstants.heroTag}/${game?.id}',
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: game!.backgroundImage!,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Center(child: Icon(Icons.error)),
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

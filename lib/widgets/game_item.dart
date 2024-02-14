import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/data/models/game_detail_route_param.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/widgets/metacritic_indicator.dart';
import 'package:go_router/go_router.dart';

class GameItem extends StatelessWidget {
  final Game? game;

  const GameItem({
    Key? key,
    this.game,
  }) : super(key: key);

  void onClickGameItem(
    BuildContext context,
  ) {
    if (game?.id != null && game?.slug != null) {
      context.push(
        RouteConstants.gameDetail,
        extra: GameDetailRouteParam(game?.id, game?.slug),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemWidth = context.screenWidth / 2.2;

    return Card(
      child: InkWell(
        onTap: () => onClickGameItem(
          context,
        ),
        child: SizedBox(
          width: itemWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: '${ConfigConstants.heroTag}/${game?.id}',
                child: Stack(
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
                            ? CachedNetworkImage(
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
                              )
                            : Center(
                                child: Icon(
                                  Icons.error,
                                  color: context.themeData.colorScheme.primary,
                                  size: 40,
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

              //** Date */
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: AutoSizeText(
                  game?.released.stringToDateString() ??
                      StringConstants.emptyStringPlaceholder,
                  maxLines: 1,
                  style: context.themeData.textTheme.bodyLarge,
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

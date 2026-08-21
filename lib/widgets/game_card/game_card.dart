import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/critic_badge.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_cached_network_image.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_card/game_card_footer.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_card/enum/game_card_size.dart';
import 'package:gaming_library_assessment_flutter/widgets/library_tick.dart';
import 'package:gaming_library_assessment_flutter/widgets/status_chip.dart';

class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.size,
    this.game,
    this.fromScreen,
    this.criticScore,
    this.status,
    this.inLibrary = false,
    this.onTap,
    this.onAddTap,
  });

  final GameCardSize size;
  final GameEntity? game;
  final String? fromScreen;
  final double? criticScore;
  final LibraryStatus? status;
  final bool inLibrary;
  final VoidCallback? onTap;
  final VoidCallback? onAddTap;

  @override
  Widget build(BuildContext context) {
    final card = InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _CardCover(
            game: game,
            fromScreen: fromScreen,
            criticScore: criticScore,
            status: status,
            inLibrary: inLibrary,
          ),
          if (size.hasFooter)
            GameCardFooter(
              size: size,
              game: game,
              criticScore: criticScore,
              onAddTap: onAddTap,
            ),
        ],
      ),
    );

    return size.fillsParent ? card : SizedBox(width: size.width, child: card);
  }
}

class _CardCover extends StatelessWidget {
  const _CardCover({
    this.game,
    this.fromScreen,
    this.criticScore,
    this.status,
    required this.inLibrary,
  });

  final GameEntity? game;
  final String? fromScreen;
  final double? criticScore;
  final LibraryStatus? status;
  final bool inLibrary;

  @override
  Widget build(BuildContext context) {
    final game = this.game;
    final fromScreen = this.fromScreen;
    final criticScore = this.criticScore;
    final status = this.status;
    final borderRadius = BorderRadius.circular(context.tokens.radius.lg);

    final cover = ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _CoverArt(url: game?.cover.url, borderRadius: borderRadius),
          if (criticScore != null)
            Positioned(top: 8, left: 8, child: CriticBadge(score: criticScore)),
          if (inLibrary)
            const Positioned(top: 8, right: 8, child: LibraryTick()),
          if (status != null)
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Align(
                alignment: Alignment.centerLeft,
                child: StatusChip(
                  status: status,
                  variant: StatusChipVariant.onMedia,
                ),
              ),
            ),
        ],
      ),
    );

    return AspectRatio(
      aspectRatio: coverAspectRatio,
      child: game != null && fromScreen != null
          ? Hero(
              tag: '${ConfigConstants.heroTag}/${game.id}/$fromScreen',
              child: cover,
            )
          : cover,
    );
  }
}

class _CoverArt extends StatelessWidget {
  const _CoverArt({this.url, required this.borderRadius});

  final String? url;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final url = this.url;

    if (url == null || url.isEmpty) {
      return _MissingArt(borderRadius: borderRadius);
    }

    return DefaultCachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, image) => Stack(
        fit: StackFit.expand,
        children: [
          Image(image: image, fit: BoxFit.cover),
          ColoredBox(color: context.tokens.color.coverWash),
        ],
      ),
      placeholder: (context, url) =>
          ColoredBox(color: context.tokens.color.surfaceRaised),
      errorWidget: (context, url, error) =>
          _MissingArt(borderRadius: borderRadius),
    );
  }
}

class _MissingArt extends StatelessWidget {
  const _MissingArt({required this.borderRadius});

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.tokens.color;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.canvas,
        border: Border.all(color: colors.hairline),
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Icon(Icons.videogame_asset_outlined, color: colors.ink24),
      ),
    );
  }
}

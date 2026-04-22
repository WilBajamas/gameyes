import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubits/game_detail_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_retry_widget.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_detail_top_content_shimmer.dart';
import 'package:gaming_library_assessment_flutter/widgets/metacritic_indicator.dart';

import '../../../../generated/l10n.dart';
import '../cubits/game_detail_state.dart';

class DetailTopHeader extends StatelessWidget {
  final int? gameId;
  final String fromScreen;
  final String? image;

  const DetailTopHeader({
    super.key,
    required this.gameId,
    required this.fromScreen,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BlocBuilder<GameDetailCubit, GameDetailState>(
        builder: (context, state) {
          if (state.status == GameDetailStatus.failed) {
            return Center(
              child: ErrorRetryWidget(
                onRetryClicked: () => gameId != null
                    ? context
                        .read<GameDetailCubit>()
                        .fetchGameDetail(id: gameId!)
                    : null,
              ),
            );
          }

          return Stack(
            children: [
              DetailBackground(
                backgroundImage: state.game?.additionalImageUrl,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, kToolbarHeight, 16, 16),
                width: context.screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: context.screenWidth,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ** Image //
                          DetailImage(
                            gameId: gameId,
                            image: image,
                            fromScreen: fromScreen,
                          ),
                          const SizedBox(width: 16),

                          // ** Details //
                          if (state.status == GameDetailStatus.success)
                            DetailContent(
                              state: state,
                            ),

                          if (state.status == GameDetailStatus.loading)
                            const GameDetailTopContentShimmer(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final GameDetailState state;

  const DetailContent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ** Name //
          AutoSizeText(
            state.game?.name ?? '-',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: context.themeData.textTheme.displayMedium!.merge(
              const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // ** Release date //
          AutoSizeText(
            '${S.current.release_date}:',
            maxLines: 1,
            style: context.themeData.textTheme.titleMedium!
                .copyWith(color: Colors.white),
          ),
          AutoSizeText(
            state.game?.releaseDate?.stringToDateString() ?? '-',
            maxLines: 2,
            style: context.themeData.textTheme.bodyLarge!
                .copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16),
          // ** Metacritic score //
          Row(
            children: [
              MetacriticIndicator(
                score: state.game?.metacritic,
                size: 60,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: AutoSizeText(
                  S.current.metacritic_score,
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DetailImage extends StatelessWidget {
  const DetailImage({
    super.key,
    required this.gameId,
    required this.image,
    required this.fromScreen,
  });

  final int? gameId;
  final String? image;
  final String fromScreen;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Hero(
        tag: '${ConfigConstants.heroTag}/$gameId/$fromScreen',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AspectRatio(
            aspectRatio: 2 / 3,
            child: CachedNetworkImage(
              imageUrl: image ?? '-',
              errorWidget: (context, _, __) => Container(
                color: Colors.white,
                child: Center(
                  child: Icon(
                    Icons.error,
                    size: 40,
                    color: context.themeData.colorScheme.primary,
                  ),
                ),
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class DetailBackground extends StatelessWidget {
  final String? backgroundImage;

  const DetailBackground({
    super.key,
    this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: (context.screenHeight * 0.35) + kToolbarHeight * 2,
          width: context.screenWidth,
          child: backgroundImage != null
              ? CachedNetworkImage(
                  imageUrl: backgroundImage!,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                          Colors.black54,
                          BlendMode.darken,
                        ),
                      ),
                    ),
                  ),
                )
              : null,
        ),
        Container(
          height: (context.screenHeight * 0.35) + kToolbarHeight * 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                context.themeData.scaffoldBackgroundColor,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

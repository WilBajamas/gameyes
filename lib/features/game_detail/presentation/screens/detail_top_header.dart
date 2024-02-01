import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_detail_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/metacritic_indicator.dart';

class DetailTopHeader extends StatelessWidget {
  final GameDetailState state;
  final int? id;

  // ignore: lines_longer_than_80_chars
  const DetailTopHeader({Key? key, required this.state, this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.6,
      child: Stack(
        children: [
          // ** Background image //
          SizedBox(
            height: context.screenHeight,
            child: state.response?.backgroundImageAdditional != null
                ? Image.network(
                    state.response!.backgroundImageAdditional!,
                    fit: BoxFit.cover,
                  )
                : null,
          ),

          Container(
            color: Colors.black.withOpacity(0.7), // 70% opacity
          ),

          // ** Content //
          Container(
            padding: const EdgeInsets.all(16),
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
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AspectRatio(
                            aspectRatio: 2 / 3,
                            child: CachedNetworkImage(
                              imageUrl: state.response?.backgroundImage ?? '-',
                              errorWidget: (context, _, __) => Container(
                                color: Colors.white,
                                child: Center(
                                  child: Icon(
                                    Icons.error,
                                    size: 40,
                                    color:
                                        context.themeData.colorScheme.primary,
                                  ),
                                ),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ** Name //
                            Text(
                              state.response!.name!,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: context.themeData.textTheme.displayMedium!
                                  .merge(const TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(height: 8),
                            // ** Release date //
                            Text(
                              '${context.localisations.release_date}:',
                              style: context.themeData.textTheme.titleMedium!
                                  .copyWith(color: Colors.white),
                            ),
                            Text(
                              state.response!.released.stringToDateString(),
                              style: context.themeData.textTheme.bodyLarge!
                                  .copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            // ** Metacritic score //
                            Row(
                              children: [
                                MetacriticIndicator(
                                  score: state.response?.metacritic,
                                  size: 60,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    context.localisations.metacritic_score,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // ** Description //
                Expanded(
                  child: Text(
                    state.response!.description!,
                    overflow: TextOverflow.fade,
                    softWrap: true,
                    style: context.themeData.textTheme.bodySmall!
                        .merge(const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

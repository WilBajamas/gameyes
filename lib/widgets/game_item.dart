import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/metacritic_indicator.dart';

class GameItem extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final String? date;
  final int? score;

  const GameItem({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.date,
    this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemWidth = context.screenWidth / 2.2;

    return Card(
      child: SizedBox(
        width: itemWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 4 / 4.8,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: imageUrl != null

                        //** Image */
                        ? CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: imageUrl!,
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
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: MetacriticIndicator(
                    score: score,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            //** Name */
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                name ?? StringConstants.emptyStringPlaceholder,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.themeData.textTheme.displaySmall,
              ),
            ),
            const SizedBox(height: 4),

            //** Date */
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                date.formatDate(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

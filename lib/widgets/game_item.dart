import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class GameItem extends StatelessWidget {
  final String imageUrl;
  final String? name;
  final String? date;
  final String score;

  const GameItem({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.date,
    this.score = StringConstants.na,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemWidth = context.screenWidth / 2.2;
    final itemHeight = itemWidth * 1.9;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Card(
        child: SizedBox(
          width: itemWidth,
          height: itemHeight,
          child: Stack(
            children: [
              //** Score */

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //** Image */
                  AspectRatio(
                    aspectRatio: 4 / 5,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: imageUrl,
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  //** Name */
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      name ?? StringConstants.emptyStringPlaceholder,
                      style: context.themeData().textTheme.displaySmall,
                    ),
                  ),
                  const SizedBox(height: 4),

                  //** Date */
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      date ?? StringConstants.emptyStringPlaceholder,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

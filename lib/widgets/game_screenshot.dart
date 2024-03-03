import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class GameScreenshot extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback? onImageTap;
  final EdgeInsets padding;
  final double borderRadius;

  const GameScreenshot({
    super.key,
    required this.imageUrl,
    this.onImageTap,
    this.padding = EdgeInsets.zero,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth,
      child: Padding(
        padding: padding,
        child: imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: imageUrl != null
                    ? InkWell(
                        onTap: onImageTap,
                        child: CachedNetworkImage(
                          imageUrl: imageUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Center(child: Icon(Icons.error)),
              )
            : const Center(child: Icon(Icons.error)),
      ),
    );
  }
}

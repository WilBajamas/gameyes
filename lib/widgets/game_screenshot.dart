import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class GameScreenshot extends StatelessWidget {
  final String imageUrl;

  const GameScreenshot({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenWidth / 3,
      child: AspectRatio(
        aspectRatio: 3 / 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

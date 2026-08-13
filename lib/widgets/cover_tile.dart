import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_cached_network_image.dart';
import 'package:gaming_library_assessment_flutter/widgets/status_chip.dart';
import 'package:skeletonizer/skeletonizer.dart';

enum CoverTileSize {
  mini(width: 26, height: 34),
  row(width: 112, height: 150),
  fan(width: 100, height: 134),
  focal(width: 124, height: 166);

  const CoverTileSize({required this.width, required this.height});

  final double width;
  final double height;

  bool get isMini => this == CoverTileSize.mini;
}

class CoverTile extends StatelessWidget {
  const CoverTile({super.key, required this.size, this.imageUrl, this.status});

  final CoverTileSize size;
  final String? imageUrl;
  final LibraryStatus? status;

  @override
  Widget build(BuildContext context) {
    final radius = context.tokens.radius;
    final borderRadius = BorderRadius.circular(
      size.isMini ? radius.mini : radius.lg,
    );
    final imageUrl = this.imageUrl;
    final status = this.status;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl == null || imageUrl.isEmpty)
              _CoverFallback(size: size, borderRadius: borderRadius)
            else
              DefaultCachedNetworkImage(
                imageUrl: imageUrl,
                imageBuilder: (context, image) => _CoverArtwork(image: image),
                placeholder: (context, url) =>
                    _CoverLoading(borderRadius: borderRadius),
                errorWidget: (context, url, error) =>
                    _CoverFallback(size: size, borderRadius: borderRadius),
              ),
            if (status != null && !size.isMini)
              Positioned(
                left: 8,
                bottom: 8,
                child: StatusChip(
                  status: status,
                  variant: StatusChipVariant.onMedia,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CoverArtwork extends StatelessWidget {
  const _CoverArtwork({required this.image});

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image(image: image, fit: BoxFit.cover),
        ColoredBox(color: context.tokens.color.coverWash),
      ],
    );
  }
}

class _CoverFallback extends StatelessWidget {
  const _CoverFallback({required this.size, required this.borderRadius});

  final CoverTileSize size;
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
      child: size.isMini
          ? null
          : Center(
              child: Icon(Icons.videogame_asset_outlined, color: colors.ink24),
            ),
    );
  }
}

class _CoverLoading extends StatelessWidget {
  const _CoverLoading({required this.borderRadius});

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.tokens.color.surfaceRaised,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

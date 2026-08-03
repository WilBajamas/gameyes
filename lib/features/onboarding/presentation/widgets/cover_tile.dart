import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/glass_surface_widget.dart';

class CoverTile extends StatelessWidget {
  const CoverTile({
    super.key,
    required this.width,
    required this.height,
    this.showsPlaying = false,
    this.hasFloatShadow = false,
    this.mini = false,
  });

  final double width;
  final double height;
  final bool showsPlaying;
  final bool hasFloatShadow;
  final bool mini;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: tokens.color.coverWash,
        borderRadius: BorderRadius.circular(
          mini ? tokens.radius.mini : tokens.radius.lg,
        ),
        border: mini
            ? Border.all(color: tokens.color.canvas, width: 1.5)
            : null,
        boxShadow: hasFloatShadow ? [tokens.effect.float] : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          mini ? tokens.radius.mini : tokens.radius.lg,
        ),
        child: Stack(
          children: [
            Positioned(
              left: 8,
              right: 8,
              top: 12,
              bottom: 12,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(tokens.radius.xs),
                  color: tokens.color.surfaceIndigoPanel,
                ),
              ),
            ),
            if (showsPlaying)
              Positioned(
                left: 8,
                bottom: 8,
                child: GlassSurface(
                  fill: tokens.color.glass34,
                  borderRadius: BorderRadius.circular(tokens.radius.pill),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: tokens.color.ink,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tokens.typography.pill.format(S.current.playing),
                          style: tokens.typography.pill.style.copyWith(
                            color: tokens.color.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

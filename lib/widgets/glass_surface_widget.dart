import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.fill,
    required this.borderRadius,
    required this.child,
  });

  final Color fill;
  final BorderRadius borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final blur = context.tokens.effect.glassBlur;
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: ColoredBox(color: fill, child: child),
      ),
    );
  }
}

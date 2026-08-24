import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class ErrorDot extends StatelessWidget {
  const ErrorDot({super.key, required this.size, this.glyph});

  final double size;
  final IconData? glyph;

  @override
  Widget build(BuildContext context) {
    final colors = context.tokens.color;
    final glyph = this.glyph;

    return SizedBox.square(
      dimension: size,
      child: ClipOval(
        child: ColoredBox(
          color: colors.error,
          child: glyph == null
              ? null
              : Center(child: Icon(glyph, size: 12, color: colors.ink)),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class LibraryTick extends StatelessWidget {
  const LibraryTick({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.tokens.color;

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: colors.accentIndigo,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.check, size: 12, color: colors.ink),
    );
  }
}

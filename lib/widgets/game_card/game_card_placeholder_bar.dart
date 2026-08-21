import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class GameCardPlaceholderBar extends StatelessWidget {
  const GameCardPlaceholderBar({super.key, required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: SizedBox(
          height: 12,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: tokens.color.ink12,
              borderRadius: BorderRadius.circular(tokens.radius.xs),
            ),
          ),
        ),
      ),
    );
  }
}

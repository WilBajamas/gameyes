import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class CriticBadge extends StatelessWidget {
  const CriticBadge({super.key, required this.score});

  final double score;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.color.green,
        borderRadius: BorderRadius.circular(tokens.radius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Text(
          '${score.round()}',
          style: tokens.typography.pill.style.copyWith(
            color: tokens.color.inkDark,
          ),
        ),
      ),
    );
  }
}

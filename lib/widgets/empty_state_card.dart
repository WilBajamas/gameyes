import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/primary_button.dart';

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    required this.headline,
    required this.supportingLine,
    required this.actionLabel,
    required this.onActionPressed,
    this.glyph,
  });

  final String headline;
  final String supportingLine;
  final String actionLabel;
  final VoidCallback onActionPressed;
  final IconData? glyph;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.color;
    final glyph = this.glyph;

    return ClipRRect(
      borderRadius: BorderRadius.circular(tokens.radius.lg),
      child: ColoredBox(
        color: colors.surfaceRaised,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              if (glyph != null) Icon(glyph, size: 44, color: colors.ink55),
              Text(
                headline.toUpperCase(),
                textAlign: TextAlign.center,
                style: tokens.typography.cardHeading.style.copyWith(
                  color: colors.ink,
                ),
              ),
              Text(
                supportingLine,
                textAlign: TextAlign.center,
                style: tokens.typography.body.style.copyWith(
                  color: colors.ink70,
                ),
              ),
              PrimaryButton(label: actionLabel, onPressed: onActionPressed),
            ],
          ),
        ),
      ),
    );
  }
}

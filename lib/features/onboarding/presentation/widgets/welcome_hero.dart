import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/const.dart';

/// Rounded panel at the top of a welcome screen
class WelcomeHero extends StatelessWidget {
  const WelcomeHero({
    super.key,
    required this.contentAsset,
    this.backgroundColor,
    this.backgroundAsset,
  });

  final String contentAsset;
  final Color? backgroundColor;
  final String? backgroundAsset;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: context.tokens.radius.heroShape,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (backgroundColor != null) ColoredBox(color: backgroundColor!),
          if (backgroundAsset != null)
            Image.asset(
              backgroundAsset!,
              fit: BoxFit.cover,
              excludeFromSemantics: true,
            ),
          // Only the content art is inset; the fill and background still
          // reach the panel's edges.
          Padding(
            padding: const EdgeInsets.all(
              WelcomeLayoutConstants.heroContentPadding,
            ),
            child: Image.asset(
              contentAsset,
              fit: BoxFit.contain,
              excludeFromSemantics: true,
            ),
          ),
        ],
      ),
    );
  }
}

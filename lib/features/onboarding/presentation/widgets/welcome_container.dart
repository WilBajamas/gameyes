import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/blocs/welcome_state.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/glass_surface_widget.dart';

class WelcomeContainer extends StatelessWidget {
  const WelcomeContainer({
    super.key,
    required this.step,
    required this.heroContent,
    required this.actions,
    this.socialProof,
  });

  final WelcomeStep step;
  final Widget heroContent;
  final Widget actions;
  final Widget? socialProof;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.color;
    final isFirstStep = step == WelcomeStep.one;
    final heroHeight = isFirstStep ? 400.0 : 356.0;
    final headline = isFirstStep
        ? S.current.welcome_headline_one
        : S.current.welcome_headline_two;
    final body = isFirstStep
        ? S.current.welcome_body_one
        : S.current.welcome_body_two;
    final chip = isFirstStep
        ? S.current.welcome_chip_one
        : S.current.welcome_chip_two;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Short screens give space back from the hero so the bottom copy stays
        // usable.
        final shortfall = (714 - constraints.maxHeight).clamp(0.0, heroHeight);
        final resolvedHeroHeight = heroHeight - shortfall;
        return Column(
          children: [
            SizedBox(
              height: resolvedHeroHeight,
              child: ClipRRect(
                borderRadius: tokens.radius.heroShape,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ColoredBox(
                      color: isFirstStep
                          ? colors.surfaceIndigoPanel
                          : colors.surfaceMagentaPanel,
                    ),
                    Positioned(
                      left: -42,
                      top: 114,
                      child: Container(
                        width: 156,
                        height: 156,
                        decoration: BoxDecoration(
                          color: colors.ambientNeutral,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -58,
                      top: 12,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: colors.ambientAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 24,
                      top: 54,
                      child: GlassSurface(
                        fill: colors.glass34,
                        borderRadius: BorderRadius.circular(tokens.radius.pill),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isFirstStep
                                    ? Icons.library_books_outlined
                                    : Icons.favorite_border,
                                size: 13,
                                color: colors.ink,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                tokens.typography.pill.format(chip),
                                style: tokens.typography.pill.style.copyWith(
                                  color: colors.ink,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(child: heroContent),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                padding: EdgeInsets.fromLTRB(
                  24,
                  isFirstStep ? 28 : 24,
                  24,
                  24 + context.bottomPadding,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (socialProof != null) ...[
                        socialProof!,
                        const SizedBox(height: 18),
                      ],
                      Row(
                        children: [
                          Container(
                            width: isFirstStep ? 22 : 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: isFirstStep ? colors.ink : colors.ink12,
                              borderRadius: BorderRadius.circular(
                                tokens.radius.pill,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: isFirstStep ? 5 : 22,
                            height: 5,
                            decoration: BoxDecoration(
                              color: isFirstStep ? colors.ink12 : colors.ink,
                              borderRadius: BorderRadius.circular(
                                tokens.radius.pill,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isFirstStep ? 22 : 18),
                      Text(
                        tokens.typography.welcomeHeadline.format(headline),
                        style: tokens.typography.welcomeHeadline.style,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        body,
                        style: tokens.typography.body.style.copyWith(
                          color: colors.ink70,
                        ),
                      ),
                      SizedBox(height: isFirstStep ? 28 : 24),
                      actions,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

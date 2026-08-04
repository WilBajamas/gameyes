import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/blocs/welcome_state.dart';

class WelcomeContainer extends StatelessWidget {
  const WelcomeContainer({
    super.key,
    required this.step,
    required this.heroHeight,
    required this.hero,
    required this.headline,
    required this.body,
    required this.actions,
  });

  /// Which progress dot reads as active.
  final WelcomeStep step;
  final double heroHeight;
  final Widget hero;
  final String headline;
  final String body;
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.color;
    // Only the first screen differs in rhythm; every later screen shares the
    // second screen's spacing.
    final isFirstStep = step == WelcomeStep.one;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Short screens give space back from the hero so the bottom copy stays
        // usable.
        final shortfall = (714 - constraints.maxHeight).clamp(0.0, heroHeight);
        final resolvedHeroHeight = heroHeight - shortfall;
        return Column(
          children: [
            SizedBox(height: resolvedHeroHeight, child: hero),
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                padding: EdgeInsets.fromLTRB(
                  24,
                  isFirstStep ? 28 : 24,
                  24,
                  // SafeArea now owns the bottom system inset, so adding it
                  // here again would double-count it.
                  24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

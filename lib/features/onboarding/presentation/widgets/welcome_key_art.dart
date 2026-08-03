import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/glass_surface_widget.dart';

class WelcomeKeyArt extends StatelessWidget {
  const WelcomeKeyArt({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          left: 48,
          right: 48,
          top: 128,
          bottom: 50,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(tokens.radius.lg),
              color: tokens.color.coverWash,
            ),
          ),
        ),
        Positioned.fill(child: ColoredBox(color: tokens.color.keyArtWash)),
        Positioned(
          left: 24,
          right: 24,
          bottom: 34,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tokens.typography.panelTitle.format(
                  S.current.welcome_countdown_title,
                ),
                style: tokens.typography.panelTitle.style,
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _WelcomeCountdownTile(
                    value: '12',
                    label: _CountdownLabel.days,
                  ),
                  _WelcomeCountdownColon(),
                  _WelcomeCountdownTile(
                    value: '06',
                    label: _CountdownLabel.hours,
                  ),
                  _WelcomeCountdownColon(),
                  _WelcomeCountdownTile(
                    value: '41',
                    label: _CountdownLabel.minutes,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum _CountdownLabel { days, hours, minutes }

class _WelcomeCountdownTile extends StatelessWidget {
  const _WelcomeCountdownTile({required this.value, required this.label});

  final String value;
  final _CountdownLabel label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final text = switch (label) {
      _CountdownLabel.days => S.current.welcome_countdown_days,
      _CountdownLabel.hours => S.current.welcome_countdown_hours,
      _CountdownLabel.minutes => S.current.welcome_countdown_minutes,
    };
    return GlassSurface(
      fill: tokens.color.glass32,
      borderRadius: BorderRadius.circular(tokens.radius.xs),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 52),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: tokens.typography.countdownFigure.style),
              Text(
                tokens.typography.microLabel.format(text),
                style: tokens.typography.microLabel.style,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeCountdownColon extends StatelessWidget {
  const _WelcomeCountdownColon();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 26),
      child: Text(':', style: tokens.typography.countdownColon.style),
    );
  }
}

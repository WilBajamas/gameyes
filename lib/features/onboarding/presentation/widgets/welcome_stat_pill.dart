import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/glass_surface_widget.dart';

class WelcomeStatPill extends StatelessWidget {
  const WelcomeStatPill({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return GlassSurface(
      fill: tokens.color.glass30,
      borderRadius: BorderRadius.circular(tokens.radius.pill),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _WelcomeStatPair(value: '312', labelKey: _WelcomeLabel.tracked),
            _WelcomeStatPair(value: '1,204', labelKey: _WelcomeLabel.hours),
            _WelcomeStatPair(value: '7', labelKey: _WelcomeLabel.playing),
          ],
        ),
      ),
    );
  }
}

enum _WelcomeLabel { tracked, hours, playing }

class _WelcomeStatPair extends StatelessWidget {
  const _WelcomeStatPair({required this.value, required this.labelKey});

  final String value;
  final _WelcomeLabel labelKey;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final label = switch (labelKey) {
      _WelcomeLabel.tracked => S.current.welcome_stat_tracked,
      _WelcomeLabel.hours => S.current.welcome_stat_hours,
      _WelcomeLabel.playing => S.current.welcome_stat_playing,
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: tokens.typography.statFigure.style),
        const SizedBox(height: 3),
        Text(
          tokens.typography.microLabel.format(label),
          style: tokens.typography.microLabel.style,
        ),
      ],
    );
  }
}

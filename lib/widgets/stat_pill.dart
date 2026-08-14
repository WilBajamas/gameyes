import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/glass_surface_widget.dart';

@immutable
class StatEntry {
  const StatEntry({required this.figure, required this.label});

  final String figure;
  final String label;
}

class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.figure, required this.label});

  final String figure;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.color.ink08,
        borderRadius: BorderRadius.circular(tokens.radius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: _StatPair(
          figure: figure,
          label: label,
          labelStyle: tokens.typography.pill.style.copyWith(
            color: tokens.color.ink55,
          ),
        ),
      ),
    );
  }
}

class StatPill extends StatelessWidget {
  const StatPill({super.key, required this.stats})
    : assert(
        stats.length == 2 || stats.length == 3,
        'The glass stat pill holds two or three pairs.',
      );

  final List<StatEntry> stats;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final labelStyle = tokens.typography.microLabel.style;

    return GlassSurface(
      fill: tokens.color.glass30,
      borderRadius: BorderRadius.circular(tokens.radius.pill),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            ...stats.map(
              (stat) => Expanded(
                child: _StatPair(
                  figure: stat.figure,
                  label: stat.label,
                  labelStyle: labelStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatPair extends StatelessWidget {
  const _StatPair({
    required this.figure,
    required this.label,
    required this.labelStyle,
  });

  final String figure;
  final String label;
  final TextStyle labelStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          figure,
          style: context.tokens.typography.statFigure.style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: labelStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

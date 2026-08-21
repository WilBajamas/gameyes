import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/completion_ring/completion_ring_painter.dart';
import 'package:gaming_library_assessment_flutter/widgets/completion_ring/enum/completion_ring_size.dart';

class CompletionRing extends StatelessWidget {
  const CompletionRing({
    super.key,
    required this.value,
    required this.size,
    this.caption,
  });

  final double value;
  final CompletionRingSize size;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final clamped = value.clamp(0, 100).toDouble();
    final percentage = clamped.truncate();
    final complete = clamped == 100;
    final captionLine = size.showsCaption ? caption : null;

    return Semantics(
      container: true,
      excludeSemantics: true,
      label: S.current.completed_percentage('$percentage'),
      child: SizedBox.square(
        dimension: size.box,
        child: CustomPaint(
          painter: CompletionRingPainter(
            progress: clamped / 100,
            radius: size.radius,
            stroke: size.stroke,
            trackColor: tokens.color.ink12,
            progressColor: complete
                ? tokens.color.accentMagenta
                : tokens.color.accentIndigo,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$percentage%',
                  style: tokens.typography.statFigure.style.copyWith(
                    fontSize: size.figureSize,
                  ),
                  maxLines: 1,
                ),
                if (captionLine != null)
                  Text(
                    captionLine,
                    style: tokens.typography.microLabel.style.copyWith(
                      color: tokens.color.ink55,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

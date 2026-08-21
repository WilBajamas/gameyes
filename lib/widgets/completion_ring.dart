import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';

const double _ringInset = 2;

enum CompletionRingSize {
  inline(box: 60, stroke: 6, figureSize: 14, showsCaption: false),
  specimen(box: 80, stroke: 8, figureSize: 18, showsCaption: true),
  detail(box: 88, stroke: 8, figureSize: 22, showsCaption: true);

  const CompletionRingSize({
    required this.box,
    required this.stroke,
    required this.figureSize,
    required this.showsCaption,
  });

  final double box;
  final double stroke;
  final double figureSize;
  final bool showsCaption;

  double get radius => (box - _ringInset * 2 - stroke) / 2;
}

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

class CompletionRingPainter extends CustomPainter {
  CompletionRingPainter({
    required this.progress,
    required this.radius,
    required this.stroke,
    required this.trackColor,
    required this.progressColor,
  });

  final double progress;
  final double radius;
  final double stroke;
  final Color trackColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final centre = size.center(Offset.zero);

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = trackColor;

    canvas.drawCircle(centre, radius, track);

    if (progress <= 0) return;

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = progressColor;

    canvas.drawArc(
      Rect.fromCircle(center: centre, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant CompletionRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.radius != radius ||
      oldDelegate.stroke != stroke ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.progressColor != progressColor;
}

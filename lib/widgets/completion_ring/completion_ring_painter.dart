import 'dart:math';

import 'package:flutter/material.dart';

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

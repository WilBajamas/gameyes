import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

// The six rounded-corner sizes used across the app.
@immutable
class AppRadiusTokens {
  const AppRadiusTokens({
    required this.xs,
    required this.mini,
    required this.sm,
    required this.lg,
    required this.xl,
    required this.pill,
    required this.full,
    required this.heroShape,
  });

  // ** Scale
  final double xs;
  final double mini;
  final double sm;
  final double lg;
  final double xl;
  final double pill;

  /// The fully-circular step.
  final double full;

  // ** Shape
  final BorderRadius heroShape;

  static const AppRadiusTokens dark = AppRadiusTokens(
    xs: 6,
    mini: 5,
    sm: 12,
    lg: 16,
    xl: 40,
    pill: 50,
    full: 9999,
    heroShape: BorderRadius.only(
      bottomLeft: Radius.circular(88),
      bottomRight: Radius.circular(88),
    ),
  );

  AppRadiusTokens copyWith({
    double? xs,
    double? mini,
    double? sm,
    double? lg,
    double? xl,
    double? pill,
    double? full,
    BorderRadius? heroShape,
  }) {
    return AppRadiusTokens(
      xs: xs ?? this.xs,
      mini: mini ?? this.mini,
      sm: sm ?? this.sm,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      pill: pill ?? this.pill,
      full: full ?? this.full,
      heroShape: heroShape ?? this.heroShape,
    );
  }

  static AppRadiusTokens lerp(AppRadiusTokens a, AppRadiusTokens b, double t) {
    return AppRadiusTokens(
      xs: lerpDouble(a.xs, b.xs, t)!,
      mini: lerpDouble(a.mini, b.mini, t)!,
      sm: lerpDouble(a.sm, b.sm, t)!,
      lg: lerpDouble(a.lg, b.lg, t)!,
      xl: lerpDouble(a.xl, b.xl, t)!,
      pill: lerpDouble(a.pill, b.pill, t)!,
      full: lerpDouble(a.full, b.full, t)!,
      heroShape: BorderRadius.lerp(a.heroShape, b.heroShape, t)!,
    );
  }
}

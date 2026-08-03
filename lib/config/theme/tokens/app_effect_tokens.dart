import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

@immutable
class AppEffectTokens {
  const AppEffectTokens({required this.float, required this.glassBlur});

  final BoxShadow float;
  final double glassBlur;

  static const AppEffectTokens dark = AppEffectTokens(
    float: BoxShadow(
      color: Color.fromRGBO(69, 42, 124, 0.1),
      offset: Offset(0, 3),
      blurRadius: 68,
    ),
    glassBlur: 9,
  );

  AppEffectTokens copyWith({BoxShadow? float, double? glassBlur}) {
    return AppEffectTokens(
      float: float ?? this.float,
      glassBlur: glassBlur ?? this.glassBlur,
    );
  }

  static AppEffectTokens lerp(AppEffectTokens a, AppEffectTokens b, double t) {
    return AppEffectTokens(
      float: BoxShadow.lerp(a.float, b.float, t)!,
      glassBlur: lerpDouble(a.glassBlur, b.glassBlur, t)!,
    );
  }
}

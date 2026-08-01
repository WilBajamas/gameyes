import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_color_tokens.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_motion_tokens.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_radius_tokens.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_type_tokens.dart';

// One place for the whole app to read its colors, fonts, spacing and
// animation timing. Read it with `context.tokens`.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.color,
    required this.typography,
    required this.radius,
    required this.motion,
  });

  final AppColorTokens color;

  // Called "typography" instead of "type" because Flutter's theme system
  // already uses the word "type" internally - naming it that would have
  // broken the lookup silently.
  final AppTypeTokens typography;

  final AppRadiusTokens radius;
  final AppMotionTokens motion;

  // Not "const" because building the fonts below calls a function, not just
  // plain values.
  static final AppTokens dark = AppTokens(
    color: AppColorTokens.dark,
    typography: AppTypeTokens.dark,
    radius: AppRadiusTokens.dark,
    motion: AppMotionTokens.dark,
  );

  @override
  AppTokens copyWith({
    AppColorTokens? color,
    AppTypeTokens? typography,
    AppRadiusTokens? radius,
    AppMotionTokens? motion,
  }) {
    return AppTokens(
      color: color ?? this.color,
      typography: typography ?? this.typography,
      radius: radius ?? this.radius,
      motion: motion ?? this.motion,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;

    return AppTokens(
      color: AppColorTokens.lerp(color, other.color, t),
      typography: AppTypeTokens.lerp(typography, other.typography, t),
      radius: AppRadiusTokens.lerp(radius, other.radius, t),
      motion: AppMotionTokens.lerp(motion, other.motion, t),
    );
  }
}

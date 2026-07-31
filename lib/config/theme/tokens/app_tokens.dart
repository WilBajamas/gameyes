import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_color_tokens.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_motion_tokens.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_radius_tokens.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_type_tokens.dart';

/// The single theme extension carrying every design token.
///
/// Resolved with `context.tokens`. Adding light mode later is one more
/// static instance plus a `themeMode` change — no new type, no change to the
/// lookup call shape, no change to any consumer.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.color,
    required this.typography,
    required this.radius,
    required this.motion,
  });

  final AppColorTokens color;

  /// The type scale.
  ///
  /// Named `typography` rather than `type` because [ThemeExtension] already
  /// declares `Object get type`, which [ThemeData] uses as this extension's
  /// key in its extensions map. A field named `type` would override it and
  /// make `Theme.of(context).extension<AppTokens>()` resolve to null.
  final AppTypeTokens typography;

  final AppRadiusTokens radius;
  final AppMotionTokens motion;

  /// The only named instance authored in this run.
  ///
  /// `final`, not `const`, because [AppTypeTokens.dark] is built from
  /// `GoogleFonts.*` function calls.
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

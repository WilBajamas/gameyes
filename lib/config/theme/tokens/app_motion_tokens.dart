import 'package:flutter/foundation.dart' show lerpDuration;
import 'package:flutter/material.dart';

/// The four durations and three curves the app animates with.
///
/// No spinner, bounce or parallax duration is tokenised, and the welcome
/// spec's 18s ambient breathe is deliberately absent.
@immutable
class AppMotionTokens {
  const AppMotionTokens({
    required this.stateChange,
    required this.expandCollapse,
    required this.shimmer,
    required this.screenTransition,
    required this.standard,
    required this.shimmerCurve,
    required this.screenTransitionCurve,
  });

  // ** Durations
  /// Pairs with [standard].
  final Duration stateChange;

  /// Pairs with [standard].
  final Duration expandCollapse;

  /// Pairs with [shimmerCurve].
  final Duration shimmer;

  /// Pairs with [screenTransitionCurve].
  final Duration screenTransition;

  // ** Curves
  /// The standard easing, used with [stateChange] and [expandCollapse].
  final Curve standard;

  /// Used with [shimmer]. Linear, so the sweep reads at a constant rate.
  final Curve shimmerCurve;

  /// Used with [screenTransition].
  final Curve screenTransitionCurve;

  static const AppMotionTokens dark = AppMotionTokens(
    stateChange: Duration(milliseconds: 140),
    expandCollapse: Duration(milliseconds: 220),
    shimmer: Duration(milliseconds: 1400),
    screenTransition: Duration(milliseconds: 420),
    standard: Cubic(0.2, 0.7, 0.2, 1),
    shimmerCurve: Curves.linear,
    screenTransitionCurve: Cubic(0.16, 1, 0.3, 1),
  );

  /// Whether the platform has asked for animation to be collapsed.
  bool isReduced(BuildContext context) =>
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  /// [duration], or [Duration.zero] when reduced motion is requested.
  ///
  /// Every consumer resolves through this rather than querying platform
  /// accessibility settings itself.
  Duration resolve(BuildContext context, Duration duration) =>
      isReduced(context) ? Duration.zero : duration;

  AppMotionTokens copyWith({
    Duration? stateChange,
    Duration? expandCollapse,
    Duration? shimmer,
    Duration? screenTransition,
    Curve? standard,
    Curve? shimmerCurve,
    Curve? screenTransitionCurve,
  }) {
    return AppMotionTokens(
      stateChange: stateChange ?? this.stateChange,
      expandCollapse: expandCollapse ?? this.expandCollapse,
      shimmer: shimmer ?? this.shimmer,
      screenTransition: screenTransition ?? this.screenTransition,
      standard: standard ?? this.standard,
      shimmerCurve: shimmerCurve ?? this.shimmerCurve,
      screenTransitionCurve:
          screenTransitionCurve ?? this.screenTransitionCurve,
    );
  }

  static AppMotionTokens lerp(AppMotionTokens a, AppMotionTokens b, double t) {
    return AppMotionTokens(
      stateChange: lerpDuration(a.stateChange, b.stateChange, t),
      expandCollapse: lerpDuration(a.expandCollapse, b.expandCollapse, t),
      shimmer: lerpDuration(a.shimmer, b.shimmer, t),
      screenTransition: lerpDuration(
        a.screenTransition,
        b.screenTransition,
        t,
      ),
      standard: t < 0.5 ? a.standard : b.standard,
      shimmerCurve: t < 0.5 ? a.shimmerCurve : b.shimmerCurve,
      screenTransitionCurve:
          t < 0.5 ? a.screenTransitionCurve : b.screenTransitionCurve,
    );
  }
}

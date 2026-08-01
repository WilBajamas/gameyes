import 'package:flutter/material.dart';

enum StatusTreatment { filled, tinted }

// One status's look: its color, the background it sits on, and whether
// it's filled or tinted.
@immutable
class AppStatusToken {
  const AppStatusToken({
    required this.color,
    required this.fill,
    required this.treatment,
  });

  final Color color;
  final Color fill;
  final StatusTreatment treatment;

  AppStatusToken copyWith({
    Color? color,
    Color? fill,
    StatusTreatment? treatment,
  }) {
    return AppStatusToken(
      color: color ?? this.color,
      fill: fill ?? this.fill,
      treatment: treatment ?? this.treatment,
    );
  }

  static AppStatusToken lerp(AppStatusToken a, AppStatusToken b, double t) {
    return AppStatusToken(
      color: Color.lerp(a.color, b.color, t)!,
      fill: Color.lerp(a.fill, b.fill, t)!,
      treatment: t < 0.5 ? a.treatment : b.treatment,
    );
  }
}

/// The six statuses fixed by the tracker schema.
@immutable
class AppStatusTokens {
  const AppStatusTokens({
    required this.playing,
    required this.backlog,
    required this.completed,
    required this.onHold,
    required this.wishlist,
    required this.dropped,
  });

  final AppStatusToken playing;
  final AppStatusToken backlog;
  final AppStatusToken completed;
  final AppStatusToken onHold;
  final AppStatusToken wishlist;
  final AppStatusToken dropped;

  AppStatusTokens copyWith({
    AppStatusToken? playing,
    AppStatusToken? backlog,
    AppStatusToken? completed,
    AppStatusToken? onHold,
    AppStatusToken? wishlist,
    AppStatusToken? dropped,
  }) {
    return AppStatusTokens(
      playing: playing ?? this.playing,
      backlog: backlog ?? this.backlog,
      completed: completed ?? this.completed,
      onHold: onHold ?? this.onHold,
      wishlist: wishlist ?? this.wishlist,
      dropped: dropped ?? this.dropped,
    );
  }

  static AppStatusTokens lerp(AppStatusTokens a, AppStatusTokens b, double t) {
    return AppStatusTokens(
      playing: AppStatusToken.lerp(a.playing, b.playing, t),
      backlog: AppStatusToken.lerp(a.backlog, b.backlog, t),
      completed: AppStatusToken.lerp(a.completed, b.completed, t),
      onHold: AppStatusToken.lerp(a.onHold, b.onHold, t),
      wishlist: AppStatusToken.lerp(a.wishlist, b.wishlist, t),
      dropped: AppStatusToken.lerp(a.dropped, b.dropped, t),
    );
  }
}

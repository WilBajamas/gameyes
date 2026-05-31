import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Mixin for StatefulWidgets that need to refresh data when the app
/// resumes after being in the background for a configurable duration.
///
/// Usage:
/// ```dart
/// class _MyScreenState extends State<MyScreen>
///     with StaleDataRefreshMixin {
///
///   @override
///   Duration get staleThreshold => const Duration(minutes: 15);
///
///   @override
///   void onStaleRefresh() {
///     context.read<MyCubit>().reload();
///   }
/// }
/// ```
mixin StaleDataRefreshMixin<T extends StatefulWidget> on State<T>
    implements WidgetsBindingObserver {
  DateTime? _lastPausedTime;

  /// How long the app must be paused before data is considered stale.
  Duration get staleThreshold;

  /// Called when the app resumes and data is stale.
  /// Implement this to trigger your refresh logic.
  void onStaleRefresh();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _lastPausedTime = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      if (_lastPausedTime != null) {
        final elapsed = DateTime.now().difference(_lastPausedTime!);
        if (elapsed >= staleThreshold) {
          onStaleRefresh();
        }
      }
      _lastPausedTime = null;
    }
  }

  /* These overridden methods are required because it avoids forcing
   the user to implement every method from WidgetsBindingObserver in the
   widgets that uses this mixin. */
  @override
  void didChangeAccessibilityFeatures() {}
  @override
  void didChangeLocales(List<Locale>? locales) {}
  @override
  void didChangeMetrics() {}
  @override
  void didChangePlatformBrightness() {}
  @override
  void didChangeTextScaleFactor() {}
  @override
  void didHaveMemoryPressure() {}
  @override
  void didChangeViewFocus(ViewFocusEvent event) {}
  @override
  void handleCancelBackGesture() {}
  @override
  void handleCommitBackGesture() {}
  @override
  bool handleStartBackGesture(PredictiveBackEvent backEvent) {
    return false;
  }

  @override
  void handleStatusBarTap() {}
  @override
  void handleUpdateBackGestureProgress(PredictiveBackEvent backEvent) {}
  @override
  Future<bool> didPopRoute() => Future.value(false);
  @override
  Future<bool> didPushRoute(String route) => Future.value(false);
  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) =>
      Future.value(false);
  @override
  Future<AppExitResponse> didRequestAppExit() =>
      Future.value(AppExitResponse.exit);
}

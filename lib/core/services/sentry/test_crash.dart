import 'package:gaming_library_assessment_flutter/config/flavor/flavor.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';

/// Throws on purpose so we can check that reports really arrive. Two separate
/// switches have to be on, so a released build can never reach it.
abstract final class TestCrash {
  static const _requested = bool.fromEnvironment(SentryConstants.testCrashFlag);

  static void scheduleIfRequested(Flavor flavor) {
    if (!_requested || flavor != Flavor.dev) return;
    Future<void>.delayed(SentryConstants.testCrashDelay, () {
      throw StateError(SentryConstants.testCrashMessage);
    });
  }
}

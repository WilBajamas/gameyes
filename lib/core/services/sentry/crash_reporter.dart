import 'package:flutter/foundation.dart';
import 'package:gaming_library_assessment_flutter/config/config_envied.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/sentry/app_version.dart';
import 'package:gaming_library_assessment_flutter/core/services/sentry/crash_reporting_settings.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract final class CrashReporter {
  /// Starts crash reporting when this build has a real key, then starts the
  /// app. The app always starts, whatever happens here.
  static Future<void> start({
    required Flavor? flavor,
    required VoidCallback startApp,
  }) async {
    var appStarted = false;
    void startAppOnce() {
      if (appStarted) return;
      appStarted = true;
      startApp();
    }

    final settings = CrashReportingSettings.resolve(
      flavor: flavor,
      dsn: Env.sentryDsn,
    );
    if (settings == null) {
      debugPrint('Crash reporting is off for this build.');
      startAppOnce();
      return;
    }

    final tags = <String, String>{
      SentryConstants.flavorTag: settings.environment,
    };
    final appVersion = await AppVersion.read();
    if (appVersion != null) {
      tags[SentryConstants.appVersionTag] = appVersion;
    }

    try {
      await SentryFlutter.init(
        (options) => _configure(options, settings, tags),
        appRunner: startAppOnce,
      );
    } catch (error) {
      debugPrint('Crash reporting could not start (${error.runtimeType}).');
    }
    startAppOnce();
  }

  static void _configure(
    SentryFlutterOptions options,
    CrashReportingSettings settings,
    Map<String, String> tags,
  ) {
    options
      ..dsn = settings.dsn
      ..environment = settings.environment
      // Keep the SDK's own guesses about who is using the app out of reports:
      // no IP address, no device name, no account name from the machine.
      ..sendDefaultPii = false
      ..beforeSend = (event, hint) => _prepare(event, tags);
  }

  /// Last stop before a report leaves the phone: stamp the two tags on it, and
  /// strip everything about the person except the Supabase id.
  static SentryEvent _prepare(SentryEvent event, Map<String, String> tags) {
    event.tags = {...?event.tags, ...tags};
    final user = event.user;
    if (user != null) event.user = SentryUser(id: user.id);
    return event;
  }
}

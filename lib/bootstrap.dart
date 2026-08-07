import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor_config.dart';
import 'package:gaming_library_assessment_flutter/config/route/auth_status_listener.dart';
import 'package:gaming_library_assessment_flutter/config/route/session_navigator.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_color_tokens.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/services/sentry/crash_report_user.dart';
import 'package:gaming_library_assessment_flutter/core/services/sentry/crash_reporter.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_connection_checker.dart';

Future<void> bootstrap({required Flavor flavor, required Widget app}) async {
  WidgetsFlutterBinding.ensureInitialized();
  // The status bar shows whatever the screen paints behind it, and the
  // system navigation bar reads as the app's own background.
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColorTokens.dark.canvas,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  FlavorConfig.initialise(flavor);
  await configureDependencies();
  // Start listening for sign-in and sign-out before the first screen is
  // built.
  getIt<AuthStatusListener>().start();
  getIt<SessionNavigator>().start();
  // Ask Supabase if it's reachable, but don't wait for the answer - the app
  // should open right away either way.
  unawaited(getIt<SupabaseConnectionChecker>().check());

  await CrashReporter.start(
    flavor: flavor,
    startApp: () {
      // Started here, not earlier, so the first sign-in status lands after
      // crash reporting is actually listening.
      getIt<CrashReportUser>().start();
      runApp(app);
    },
  );
}

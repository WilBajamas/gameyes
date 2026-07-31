import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor_config.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_connection_checker.dart';

/// Shared startup sequence for every flavour entrypoint.
Future<void> bootstrap({required Flavor flavor, required Widget app}) async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig.initialise(flavor);
  await configureDependencies();
  // Ask Supabase if it's reachable, but don't wait for the answer - the app
  // should open right away either way.
  unawaited(getIt<SupabaseConnectionChecker>().check());
  runApp(app);
}

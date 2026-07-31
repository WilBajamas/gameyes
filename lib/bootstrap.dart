import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor_config.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_connectivity_checker.dart';

/// Shared startup sequence for every flavour entrypoint.
Future<void> bootstrap({required Flavor flavor, required Widget app}) async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig.initialise(flavor);
  await configureDependencies();
  unawaited(getIt<SupabaseConnectivityChecker>().check());
  runApp(app);
}

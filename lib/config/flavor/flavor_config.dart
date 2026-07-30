import 'package:gaming_library_assessment_flutter/config/config_envied.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor.dart';

/// Process-wide, immutable configuration for the running flavour.
///
/// Call [initialise] once during startup, before anything reads [instance].
final class FlavorConfig {
  const FlavorConfig._({
    required this.flavor,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
  });

  final Flavor flavor;
  final String supabaseUrl;
  final String supabaseAnonKey;

  static FlavorConfig? _instance;

  static void initialise(Flavor flavor) {
    _instance = switch (flavor) {
      Flavor.dev => FlavorConfig._(
          flavor: flavor,
          supabaseUrl: EnvDev.supabaseUrl,
          supabaseAnonKey: EnvDev.supabaseAnonKey,
        ),
      Flavor.prod => FlavorConfig._(
          flavor: flavor,
          supabaseUrl: EnvProd.supabaseUrl,
          supabaseAnonKey: EnvProd.supabaseAnonKey,
        ),
    };
  }

  static FlavorConfig get instance {
    final config = _instance;
    if (config == null) {
      throw StateError(
        'FlavorConfig read before initialise(). Call '
        'FlavorConfig.initialise(flavor) during bootstrap.',
      );
    }
    return config;
  }
}

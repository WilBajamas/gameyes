import 'package:gaming_library_assessment_flutter/config/config_envied.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';

/// Unable to use `injectable` and `getit` to retrieve environment variables during runtime.
final class FlavorConfig {
  const FlavorConfig._({
    required this.flavor,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.authRedirectUrl,
  });

  final Flavor flavor;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String authRedirectUrl;

  static FlavorConfig? _instance;

  static void initialise(Flavor flavor) {
    _instance = switch (flavor) {
      Flavor.dev => FlavorConfig._(
          flavor: flavor,
          supabaseUrl: EnvDev.supabaseUrl,
          supabaseAnonKey: EnvDev.supabaseAnonKey,
          authRedirectUrl: SupabaseConstants.devAuthRedirectUrl,
        ),
      Flavor.prod => FlavorConfig._(
          flavor: flavor,
          supabaseUrl: EnvProd.supabaseUrl,
          supabaseAnonKey: EnvProd.supabaseAnonKey,
          authRedirectUrl: SupabaseConstants.prodAuthRedirectUrl,
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

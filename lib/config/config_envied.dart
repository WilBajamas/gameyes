import 'package:envied/envied.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';

part 'config_envied.g.dart';

@Envied(path: ConfigConstants.enviedFilePath)
abstract class Env {
  @EnviedField(
    varName: ConfigConstants.apiKey,
    obfuscate: true,
    defaultValue: 'PLACEHOLDER_API_KEY',
  )
  static String apiKey = _Env.apiKey;

  // One key for both builds - dev and prod are told apart by Sentry's
  // environment, not by a second key.
  @EnviedField(
    varName: ConfigConstants.sentryDsn,
    obfuscate: true,
    defaultValue: SentryConstants.placeholderDsn,
  )
  static String sentryDsn = _Env.sentryDsn;
}

@Envied(path: ConfigConstants.enviedDevFilePath, name: 'EnvDev')
abstract class EnvDev {
  @EnviedField(
    varName: ConfigConstants.supabaseUrl,
    obfuscate: true,
    defaultValue: 'https://placeholder-dev.supabase.co',
  )
  static String supabaseUrl = _EnvDev.supabaseUrl;

  @EnviedField(
    varName: ConfigConstants.supabaseAnonKey,
    obfuscate: true,
    defaultValue: 'PLACEHOLDER_DEV_SUPABASE_ANON_KEY',
  )
  static String supabaseAnonKey = _EnvDev.supabaseAnonKey;
}

@Envied(path: ConfigConstants.enviedProdFilePath, name: 'EnvProd')
abstract class EnvProd {
  @EnviedField(
    varName: ConfigConstants.supabaseUrl,
    obfuscate: true,
    defaultValue: 'https://placeholder-prod.supabase.co',
  )
  static String supabaseUrl = _EnvProd.supabaseUrl;

  @EnviedField(
    varName: ConfigConstants.supabaseAnonKey,
    obfuscate: true,
    defaultValue: 'PLACEHOLDER_PROD_SUPABASE_ANON_KEY',
  )
  static String supabaseAnonKey = _EnvProd.supabaseAnonKey;
}

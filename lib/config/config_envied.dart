import 'package:envied/envied.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';

part 'config_envied.g.dart';

@Envied(path: ConfigConstants.enviedFilePath)
abstract class Env {
  @EnviedField(varName: ConfigConstants.apiKey, obfuscate: true)
  static String apiKey = _Env.apiKey;

  @EnviedField(varName: ConfigConstants.twitchClientId, obfuscate: true)
  static String twitchClientId = _Env.twitchClientId;

  @EnviedField(varName: ConfigConstants.twitchClientSecret, obfuscate: true)
  static String twitchClientSecret = _Env.twitchClientSecret;
}

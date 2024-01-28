import 'package:envied/envied.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';

part 'config_envied.g.dart';

@Envied(path: ConfigConstants.enviedFilePath)
abstract class Env {
  @EnviedField(varName: ConfigConstants.apiKey, obfuscate: true)
  static String apiKey = _Env.apiKey;
}

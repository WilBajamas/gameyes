import 'package:package_info_plus/package_info_plus.dart';

/// `1.0.0+1` style. Null when the platform cannot say
Future<String?> readAppVersion() async {
  try {
    final info = await PackageInfo.fromPlatform();
    if (info.version.isEmpty) return null;
    if (info.buildNumber.isEmpty) return info.version;
    return '${info.version}+${info.buildNumber}';
  } catch (_) {
    return null;
  }
}

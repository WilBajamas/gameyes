import 'package:package_info_plus/package_info_plus.dart';

abstract final class AppVersion {
  /// `1.0.0+1` style. Null when the platform cannot say - a report with no
  /// version still beats no report.
  static Future<String?> read() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (info.version.isEmpty) return null;
      if (info.buildNumber.isEmpty) return info.version;
      return '${info.version}+${info.buildNumber}';
    } catch (_) {
      return null;
    }
  }
}

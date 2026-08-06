import 'package:gaming_library_assessment_flutter/config/flavor/flavor.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';

class CrashReportingSettings {
  const CrashReportingSettings({required this.dsn, required this.environment});

  final String dsn;
  final String environment;

  /// Null means crash reporting stays off: either this build has no real key
  /// yet, or we do not know which build this is and would guess wrong.
  static CrashReportingSettings? resolve({
    required Flavor? flavor,
    required String dsn,
  }) {
    if (flavor == null) return null;
    if (dsn.isEmpty || dsn == SentryConstants.placeholderDsn) return null;
    return CrashReportingSettings(dsn: dsn, environment: flavor.name);
  }
}

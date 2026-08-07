import 'package:gaming_library_assessment_flutter/config/flavor/flavor.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';

/// Null means crash reporting stays off: either this build has no real key
/// yet, or we do not know which build this is
({String dsn, String environment})? resolveCrashReportingSettings({
  required Flavor? flavor,
  required String dsn,
}) {
  if (flavor == null) return null;
  if (dsn.isEmpty || dsn == SentryConstants.placeholderDsn) return null;
  return (dsn: dsn, environment: flavor.name);
}

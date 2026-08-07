import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/sentry/crash_reporting_settings.dart';

void main() {
  const dsn = 'https://key@o1.ingest.sentry.io/1';

  test('should return null when the flavour is unknown', () {
    final settings = resolveCrashReportingSettings(flavor: null, dsn: dsn);

    expect(settings, isNull);
  });

  test('should return null when the key is the placeholder', () {
    final devSettings = resolveCrashReportingSettings(
      flavor: Flavor.dev,
      dsn: SentryConstants.placeholderDsn,
    );
    final prodSettings = resolveCrashReportingSettings(
      flavor: Flavor.prod,
      dsn: SentryConstants.placeholderDsn,
    );

    expect(devSettings, isNull);
    expect(prodSettings, isNull);
  });

  test('should return null when the key is empty', () {
    final settings = resolveCrashReportingSettings(flavor: Flavor.dev, dsn: '');

    expect(settings, isNull);
  });

  test('should keep the same key for both flavours', () {
    final devSettings = resolveCrashReportingSettings(
      flavor: Flavor.dev,
      dsn: dsn,
    );
    final prodSettings = resolveCrashReportingSettings(
      flavor: Flavor.prod,
      dsn: dsn,
    );

    expect(devSettings!.dsn, dsn);
    expect(prodSettings!.dsn, dsn);
  });

  test('should name the environment after the flavour', () {
    final devSettings = resolveCrashReportingSettings(
      flavor: Flavor.dev,
      dsn: dsn,
    );
    final prodSettings = resolveCrashReportingSettings(
      flavor: Flavor.prod,
      dsn: dsn,
    );

    expect(devSettings!.environment, 'dev');
    expect(prodSettings!.environment, 'prod');
  });
}

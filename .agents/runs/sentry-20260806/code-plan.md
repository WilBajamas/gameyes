# Code Plan
Source: `.agents/week-1-task-briefs.md` §"10 — Sentry [PIPELINE]", plus the IGDB
`talker` logging and `PrettyDioLogger` removal added to the same run on
2026-08-06 (both via `tech-ac.md`)
Date: 2026-08-06

> **Two new packages.** `sentry_flutter` (the feature itself) and
> `package_info_plus` (app-version tag, already transitive via `sentry_flutter`).
> Approving this plan approves both. See `task-brief.md ## New dependencies`, and
> `tdd.md ## Alternative considered` for the zero-direct-dependency swap if you
> would rather drop `package_info_plus`.
>
> Three points worth your eye specifically:
> 1. `bootstrap.dart`'s `runApp(app)` moves inside a callback. Everything else in
>    `bootstrap` keeps its exact position and order.
> 2. `CrashReportingSettings.resolve` takes a nullable `Flavor` purely to satisfy
>    [10.5]'s "skip rather than default" failure case. Today's one call site
>    always passes a real flavour, so that branch is a guard, not a live path.
> 3. `CrashReportUser` takes a *second* subscription to the auth stream rather
>    than extending item 8's `AuthStatusListener`.
>
> **Added scope [10.15]-[10.26] starts at "Added scope" below.** It needs no new
> package and removes `pretty_dio_logger`. Two points worth your eye there:
> 1. `FlavorConfig` gains one `instanceOrNull` getter. Without it, `invoke` would
>    throw in every unit test, since `instance` throws before bootstrap has run.
> 2. `.agents/references/flutter-arch.md` line 169's stale path is corrected in
>    the same edit as [10.25], which you approved separately — it is not one of
>    `tech-ac.md`'s criteria.

## CREATE NEW

### lib/core/services/sentry/crash_reporting_settings.dart

```dart
import 'package:gaming_library_assessment_flutter/config/flavor/flavor.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';

class CrashReportingSettings {
  const CrashReportingSettings({
    required this.dsn,
    required this.environment,
  });

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
```

### lib/core/services/sentry/app_version.dart

```dart
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
```

### lib/core/services/sentry/crash_reporter.dart

```dart
import 'package:flutter/foundation.dart';
import 'package:gaming_library_assessment_flutter/config/config_envied.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/sentry/app_version.dart';
import 'package:gaming_library_assessment_flutter/core/services/sentry/crash_reporting_settings.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract final class CrashReporter {
  /// Starts crash reporting when this build has a real key, then starts the
  /// app. The app always starts, whatever happens here.
  static Future<void> start({
    required Flavor? flavor,
    required VoidCallback startApp,
  }) async {
    var appStarted = false;
    void startAppOnce() {
      if (appStarted) return;
      appStarted = true;
      startApp();
    }

    final settings = CrashReportingSettings.resolve(
      flavor: flavor,
      dsn: Env.sentryDsn,
    );
    if (settings == null) {
      debugPrint('Crash reporting is off for this build.');
      startAppOnce();
      return;
    }

    final tags = <String, String>{
      SentryConstants.flavorTag: settings.environment,
    };
    final appVersion = await AppVersion.read();
    if (appVersion != null) {
      tags[SentryConstants.appVersionTag] = appVersion;
    }

    try {
      await SentryFlutter.init(
        (options) => _configure(options, settings, tags),
        appRunner: startAppOnce,
      );
    } catch (error) {
      debugPrint('Crash reporting could not start (${error.runtimeType}).');
    }
    startAppOnce();
  }

  static void _configure(
    SentryFlutterOptions options,
    CrashReportingSettings settings,
    Map<String, String> tags,
  ) {
    options
      ..dsn = settings.dsn
      ..environment = settings.environment
      // Keep the SDK's own guesses about who is using the app out of reports:
      // no IP address, no device name, no account name from the machine.
      ..sendDefaultPii = false
      ..beforeSend = (event, hint) => _prepare(event, tags);
  }

  /// Last stop before a report leaves the phone: stamp the two tags on it, and
  /// strip everything about the person except the Supabase id.
  static SentryEvent _prepare(SentryEvent event, Map<String, String> tags) {
    final user = event.user;
    return event.copyWith(
      tags: {...?event.tags, ...tags},
      user: user == null ? null : SentryUser(id: user.id),
    );
  }
}
```

Reviewer notes:
- `startAppOnce` is called both as `appRunner` and again after the `try`/`catch`.
  The `bool` makes the second call a no-op when the SDK already ran it, so
  [10.1]'s "init throws, `runApp` still executes" holds with no double start.
- `beforeSend`'s parameters are left to inference so the plan does not pin the
  SDK's `Hint` type name across major versions.
- `copyWith(user: null)` leaves the field unchanged in `sentry_flutter`, so the
  `null` branch is a deliberate no-op, not an attempt to clear the user.

### lib/core/services/sentry/crash_report_user.dart

```dart
import 'dart:async';

import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/auth_status_entity.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/use_cases/observe_auth_status_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Puts the Supabase account id on crash reports while someone is signed in,
/// and takes it straight off again when they sign out.
@singleton
class CrashReportUser {
  CrashReportUser(this._observeAuthStatus);

  final ObserveAuthStatusUseCase _observeAuthStatus;
  StreamSubscription<AuthStatusEntity>? _subscription;

  void start() {
    if (_subscription != null) return;
    _subscription = _observeAuthStatus().listen(
      _apply,
      onError: (_) => _apply(const AuthStatusEntity.signedOut()),
    );
  }

  Future<void> _apply(AuthStatusEntity status) async {
    final id = switch (status) {
      AuthSignedIn(:final user) => user.id,
      AuthSignedOut() => null,
    };
    await Sentry.configureScope(
      (scope) => scope.setUser(id == null ? null : SentryUser(id: id)),
    );
  }
}
```

### lib/core/services/sentry/test_crash.dart

```dart
import 'package:gaming_library_assessment_flutter/config/flavor/flavor.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';

/// Throws on purpose so we can check that reports really arrive. Two separate
/// switches have to be on, so a released build can never reach it.
abstract final class TestCrash {
  static const _requested = bool.fromEnvironment(
    SentryConstants.testCrashFlag,
  );

  static void scheduleIfRequested(Flavor flavor) {
    if (!_requested || flavor != Flavor.dev) return;
    Future<void>.delayed(SentryConstants.testCrashDelay, () {
      throw StateError(SentryConstants.testCrashMessage);
    });
  }
}
```

## MODIFY EXISTING

### pubspec.yaml

```yaml
  # Supabase
  supabase_flutter: ^2.16.0

  # Crash reporting
  sentry_flutter: ^<resolved by flutter pub add>

  # App version, for the crash report tag
  package_info_plus: ^<resolved by flutter pub add>
```

### lib/core/res/const.dart

```dart
class ConfigConstants {
  // ... unchanged ...
  static const supabaseUrl = 'SUPABASE_URL';
  static const supabaseAnonKey = 'SUPABASE_ANON_KEY';
  static const sentryDsn = 'SENTRY_DSN';
  // ... unchanged ...
}

// ... SupabaseConstants unchanged, new class directly after it ...

class SentryConstants {
  // What a checkout with no secret.env resolves to. Seeing this means crash
  // reporting stays off, which is the intended behaviour, not a fault.
  static const placeholderDsn = 'PLACEHOLDER_SENTRY_DSN';

  static const flavorTag = 'flavor';
  static const appVersionTag = 'app_version';

  static const testCrashFlag = 'SENTRY_TEST_CRASH';
  static const testCrashMessage = 'Deliberate test crash - Sentry check.';
  static const Duration testCrashDelay = Duration(seconds: 3);
}
```

### lib/config/config_envied.dart

```dart
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

// EnvDev and EnvProd unchanged - no Sentry field goes in either.
```

### lib/bootstrap.dart

```dart
// added imports:
//   core/services/sentry/crash_report_user.dart
//   core/services/sentry/crash_reporter.dart
//   core/services/sentry/test_crash.dart

Future<void> bootstrap({required Flavor flavor, required Widget app}) async {
  // ... ensureInitialized, SystemChrome, FlavorConfig.initialise,
  //     configureDependencies, AuthStatusListener, SessionNavigator,
  //     SupabaseConnectionChecker - all unchanged, same order ...
  unawaited(getIt<SupabaseConnectionChecker>().check());

  await CrashReporter.start(
    flavor: flavor,
    startApp: () {
      // Started here, not earlier, so the first sign-in status lands after
      // crash reporting is actually listening.
      getIt<CrashReportUser>().start();
      runApp(app);
      TestCrash.scheduleIfRequested(flavor);
    },
  );
}
```

The removed line is the old trailing `runApp(app);`. Nothing above it moves.

## TEST FILES

### test/repository/sentry/crash_reporting_settings_test.dart

No mocks, no `GetIt`, no `provideDummy` — the subject is pure.

- `'should return null when the flavour is unknown'` — `resolve(flavor: null,
  dsn: 'https://key@o1.ingest.sentry.io/1')` is null, so an unresolved flavour
  skips rather than guessing an environment. [10.5]
- `'should return null when the key is the placeholder'` — `resolve` with
  `SentryConstants.placeholderDsn` is null on both flavours. [10.3] [10.4]
- `'should return null when the key is empty'` — `resolve` with `''` is null.
  [10.4]
- `'should keep the same key for both flavours'` — dev and prod resolve to
  settings carrying the identical `dsn`. [10.2]
- `'should name the environment after the flavour'` — dev gives
  `environment == 'dev'`, prod gives `environment == 'prod'`. [10.5]

---

# Added scope — [10.15]-[10.26]

Everything above is the Sentry half and is unchanged. Everything below was added
to this run on 2026-08-06.

## CREATE NEW (added scope)

### lib/core/services/supabase/igdb_call_log.dart

```dart
import 'package:flutter/foundation.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor_config.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Console notes about live IGDB calls, for a developer running the dev build.
/// Silent everywhere else, and nothing here ever leaves the device.
abstract final class IgdbCallLog {
  // History is off because nothing can ever show it - the console is the only
  // reader.
  static final Talker _talker = Talker(
    settings: TalkerSettings(useHistory: false),
  );

  // Checked on every call, not once at startup. kDebugMode comes first so a
  // release build drops the rest of this file entirely.
  static bool get _isOn =>
      kDebugMode && FlavorConfig.instanceOrNull?.flavor == Flavor.dev;

  static void request({required String endpoint, required String query}) {
    _write(() => _talker.info('IGDB request -> $endpoint | $query'));
  }

  static void response(Object? body) {
    _write(() => _talker.info('IGDB response <-\n${trimToLineCap(body)}'));
  }

  static void failure(Object error, StackTrace stackTrace) {
    _write(() => _talker.error('IGDB call failed', error, stackTrace));
  }

  /// At most 50 lines of body, and a plain note when there was more, so a short
  /// log is never mistaken for a cut-off one.
  @visibleForTesting
  static String trimToLineCap(Object? body) {
    final text = '$body';
    final lines = text.split('\n');
    final cap = SupabaseIgdbProxyConstants.maxLogBodyLines;
    if (lines.length <= cap) return text;
    final kept = lines.take(cap).join('\n');
    return '$kept\n[cut short: showing $cap of ${lines.length} lines]';
  }

  static void _write(void Function() entry) {
    if (!_isOn) return;
    try {
      entry();
    } catch (_) {
      // A missing log line is always better than a failed IGDB call.
    }
  }
}
```

Reviewer notes:
- `_talker` is a lazy `static final`, so a build where `_isOn` is never true
  never constructs it.
- `trimToLineCap` is public only for its test; nothing else calls it.
- The `catch (_)` is deliberately empty apart from the comment. That comment is
  also what keeps `empty_catches` quiet; if the analyzer still flags it, an
  `// ignore: empty_catches` on the line is pre-approved.
- `package:talker_flutter/...` is the import, not `package:talker/...` —
  `talker_flutter` re-exports the whole of `talker` and is the direct dependency.

## MODIFY EXISTING (added scope)

### lib/config/flavor/flavor_config.dart

```dart
  static FlavorConfig? _instance;

  // ... initialise unchanged ...

  /// Null until bootstrap has run. For callers that can carry on without
  /// knowing which build this is; everything else uses [instance].
  static FlavorConfig? get instanceOrNull => _instance;

  static FlavorConfig get instance {
    // ... unchanged, still throws ...
  }
```

### lib/core/res/const.dart

```dart
class SupabaseIgdbProxyConstants {
  // ... functionName, gamesEndpoint, releaseDatesEndpoint, requestTimeout
  //     all unchanged ...

  // How much of a response body is worth reading in the console.
  static const maxLogBodyLines = 50;
}
```

### lib/core/services/supabase/supabase_igdb_client.dart

```dart
// added import: core/services/supabase/igdb_call_log.dart

  Future<Object?> invoke({
    required String endpoint,
    required String query,
  }) async {
    IgdbCallLog.request(endpoint: endpoint, query: query);
    try {
      final response = await _client.functions
          .invoke(
            SupabaseIgdbProxyConstants.functionName,
            body: {'endpoint': endpoint, 'query': query},
          )
          .timeout(SupabaseIgdbProxyConstants.requestTimeout);

      IgdbCallLog.response(response.data);
      return response.data;
    } catch (error, stackTrace) {
      IgdbCallLog.failure(error, stackTrace);
      rethrow;
    }
  }
```

The `@injectable` annotation, the `const` constructor, the `_client` field, the
method signature and the `.timeout(...)` are all unchanged. `rethrow` is what
keeps the error's type, message and original stack trace intact for the caller.

### lib/core/di/network_module.dart

```dart
import 'package:dio/dio.dart';
// deleted: import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../res/const.dart';
import '../services/api/twitch_auth_interceptor.dart';

// ... comments and @Deprecated unchanged ...
    dio.interceptors.add(interceptor);
    // deleted: dio.interceptors.add(PrettyDioLogger(requestHeader: true,
    //                                               requestBody: true));
    return dio;
```

### lib/core/services/api/twitch_auth_interceptor.dart

```dart
import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
// deleted: import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// ... comments, @Deprecated, class header, both constants unchanged ...

  TwitchAuthInterceptor()
      : _tokenDio = Dio(
          BaseOptions(
            baseUrl: 'https://id.twitch.tv/oauth2/',
            connectTimeout: ConfigConstants.connectTimeout,
            receiveTimeout: ConfigConstants.receiveTimeout,
            sendTimeout: ConfigConstants.sendTimeout,
          ),
        );

// ... _fetchToken, onRequest, onError unchanged ...
```

The constructor body was only ever the logger registration, so it goes away and
the initialiser list now ends the constructor.

### pubspec.yaml

```yaml
  # Logging
  logger: ^2.7.0
  talker_flutter: ^5.1.16
  # deleted: pretty_dio_logger: ^1.4.0
```

Then `flutter pub get`, and check `pretty_dio_logger` is gone from
`pubspec.lock`. It is `direct main` there today with nothing else depending on
it, so it should disappear rather than turn transitive. [10.24]

### .agents/references/flutter-arch.md

```markdown
line 169  **NetworkModule** (`@module` in `lib/core/di/network_module.dart`):
line 170  - Provides the singleton `Dio` instance with `TwitchAuthInterceptor`
line 181  <deleted: Logging: `PrettyDioLogger` (request header + body).>
```

- 169 is the path correction the human approved on top of `tech-ac.md`; the
  `@module` wording on the same line is left as it is.
- 170 loses ` + PrettyDioLogger` and nothing else.
- 181 is deleted rather than reworded — after this run the Dio path has no
  logging, and describing logging that does not exist is exactly what [10.25]
  fails on. `IgdbCallLog` is not mentioned in its place: it logs the Supabase
  edge-function path, not the Dio path.

## TEST FILES (added scope)

### test/api/supabase/igdb_call_log_test.dart

No mocks, no `FlavorConfig`, no client — `trimToLineCap` is pure.

- `'should return the body unchanged when it is shorter than the cap'` — a
  three-line body comes back identical, with no marker. [10.16]
- `'should return the body unchanged when it is exactly at the cap'` — a
  50-line body comes back identical, with no marker; the boundary is inclusive.
  [10.16]
- `'should keep only the first 50 lines when the body is longer than the cap'` —
  a 60-line body yields 50 original lines plus one added line. [10.16]
- `'should say the output was cut short when the body is longer than the cap'` —
  the last line names both the cap and the real line count. [10.16]

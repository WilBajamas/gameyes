# QA Report
Source: `.agents/week-1-task-briefs.md` §"10 — Sentry [PIPELINE]", plus the IGDB
`talker` logging and `PrettyDioLogger` removal delta ([10.15]-[10.26])
Date: 2026-08-07

Overall result: PASS — pending manual checks

Verified against `git diff 3eec7031a8691c8bad4e383fd83548f56f1a4a11..HEAD`
(HEAD = `a6685d4`, human comment-trim on top of `e652d1f` on top of `a963c5f`).

## Manual verification required
[10.12] — Run the dev flavour on a device with a real `SENTRY_DSN` in `secret.env`
and `--dart-define=SENTRY_TEST_CRASH=true` — expect an event in the Sentry project
within a minute, `environment = dev`, tags `flavor = dev` and `app_version = 1.0.0+1`,
a readable Dart stack trace for `StateError('Deliberate test crash - Sentry check.')`,
and no email / display name / avatar URL / access token anywhere on the event
(user context should show a Supabase id or nothing at all).

[10.18] — Run the dev flavour as a debug build, open a screen that hits IGDB
(games list or game detail) — expect console `IGDB request ->` / `IGDB response <-`
lines. Then run the prod flavour in debug, and the dev flavour in release/profile —
expect no such lines in either. (`kDebugMode` is always true under `flutter test`,
so the gate cannot be exercised by the automated suite.)

## Static analysis
Status: PASS
Errors: NONE

`dart run build_runner build --delete-conflicting-outputs` — exit 0, 33 outputs
written, `git status` clean afterwards, so committed generated code is current.

`flutter analyze` — 34 issues: 0 errors, 2 warnings, 32 info. Exactly matches the
recorded Analyzer baseline (0/2/32). Both warnings are in
`lib/features/tracker/presentation/screens/task_detail_screen.dart`, outside the
allowlist and pre-existing. No issue of any severity is attributed to an
allowlisted new or modified file — `lib/config/flavor/flavor_config.dart:5:81`
(long doc line) sits on line 5, above the only added member (`instanceOrNull`,
line 38), and predates this change.

## Test results
Status: PASS
Tests run: 269 (started, incl. group-level) — reporter totals: 209 passed, 11 failed
Allowlisted test files: 9/9 passed
Failing tests: all 11 are the recorded pre-existing baseline failures, unchanged in
count and location —
- `test/repository/tracker/tracker_repository_test.dart` — 4
- `test/cubit/game_detail/game_detail_cubit_test.dart` — 3
- `test/cubit/games/games_bloc_test.dart` — 3
- `test/widget_test.dart` — 1 (`Counter increments smoke test`)

No new failure. `test/api/supabase/supabase_igdb_client_test.dart`'s 3 existing
tests still pass ([10.21]).

Testing mode `smoke`, per `task-brief.md ## Testing mode`. The full suite was run
in addition to the allowlisted files, to evidence the [10.14]/[10.21]/[10.26]
regression criteria.

## Coverage gaps (coverage mode only)
N/A — testing mode is `smoke`.

## Acceptance criteria
[10.1]: PASS — `lib/bootstrap.dart:39-48`; `runApp(app)` runs inside
`CrashReporter.start`'s `startApp` callback, after `FlavorConfig.initialise(flavor)`
(line 29) and shared by both entrypoints. The `flavor` argument is the resolved one.
[10.2]: PASS — one `Env.sentryDsn` (`lib/config/config_envied.dart:15-21`), read once
at `crash_reporter.dart:25`; no per-flavour DSN and no `switch (flavor)` over DSNs.
Test `should keep the same key for both flavours`.
[10.3]: PASS — `@EnviedField(obfuscate: true, defaultValue: SentryConstants.placeholderDsn)`;
no `.env` file exists in this checkout (`ls *.env` → none) and `build_runner`
still generated `lib/config/config_envied.g.dart` (`sentryDsn` at line 115) and
`flutter analyze` is clean, so a fresh checkout builds. No plaintext DSN in the repo.
[10.4]: PASS — `crash_reporting_settings.dart:11` returns null on empty/placeholder;
`crash_reporter.dart:27-31` then emits exactly one `debugPrint` and starts the app,
with no retry and no rethrow. Tests `should return null when the key is the placeholder`
and `should return null when the key is empty`.
[10.5]: PASS — `crash_reporting_settings.dart:12` derives `environment: flavor.name`
at runtime; `crash_reporter.dart:59` assigns it. Failure case at line 10: `flavor == null`
returns null, so init is skipped rather than defaulted. Tests
`should name the environment after the flavour` and `should return null when the flavour is unknown`.
[10.6]: PASS — `crash_reporter.dart:42-45` calls `SentryFlutter.init` with
`appRunner: startAppOnce`, so `runApp` executes inside the SDK's guarded zone and
the SDK's root Dart/async error handler is installed by default; no code here
overrides `PlatformDispatcher.onError` or installs a competing `runZonedGuarded`
(grep: no `runZonedGuarded` anywhere in `lib/`). The `try`/`catch` at 41-48 plus the
unconditional `startAppOnce()` at 49 contain any init failure.
[10.7]: PASS — same `SentryFlutter.init` call; `FlutterError.onError` chaining to
the previous handler is SDK default behaviour and nothing in the diff assigns
`FlutterError.onError` or `ErrorWidget.builder`.
[10.8]: PASS — `crash_reporter.dart:33-39` builds the tag map (`flavor` =
`settings.environment` = flavour name, `app_version` = `readAppVersion()`), applied
in `beforeSend` at line 69 so both error sources get them. Failure case:
`version_utils.dart:10-12` returns null on any platform error and line 37 simply
omits the tag — the event is still sent.
[10.9]: PASS — `crash_reporter.dart:68-73` `_prepare` replaces `event.user` with an
id-only `SentryUser`, so email/name/avatar cannot survive `beforeSend`;
`crash_report_user.dart:31` only ever sets `SentryUser(id: id)`. No code attaches
an email, display name, avatar URL or token — grep for `Breadcrumb`/`addBreadcrumb`
in `lib/` returns nothing, so no breadcrumb path exists either.
[10.10]: PASS — `crash_reporter.dart:62` `sendDefaultPii = false`, set explicitly;
nothing re-enables it.
[10.11]: PASS — `crash_report_user.dart:19-33`; `_apply` maps `AuthSignedIn` to the
Supabase `user.id` and `AuthSignedOut` (and stream error) to `null`, calling
`scope.setUser(null)`, so no stale id survives sign-out. Wired as `@singleton`
(`service_locator.config.dart:250`) and started at `bootstrap.dart:44` before
`runApp`.
[10.12]: MANUAL — see the checklist above. Cannot be automated: no real DSN in this
checkout.
[10.13]: PASS — `test_crash.dart:7,10`; double gate of
`bool.fromEnvironment('SENTRY_TEST_CRASH')` (compile-time const, so it folds away
without the define) AND `flavor != Flavor.dev`. No widget, route or gesture triggers
it — its only call site is `bootstrap.dart:46`.
[10.14]: PASS — `git diff` of `lib/bootstrap.dart` moves only the `runApp(app)` call
site; lines 17-37 (binding, system chrome, `FlavorConfig.initialise`,
`configureDependencies`, the two listeners, the unawaited connectivity check) are
byte-identical and in the same order. Analyzer and test results match baseline
exactly (see above).
[10.15]: PASS — `supabase_igdb_client.dart:18` calls
`IgdbCallLog.request(endpoint:, query:)` before `invoke` is dispatched;
`igdb_call_log.dart:22` logs both values. Failure case: `_write`
(`igdb_call_log.dart:45-52`) swallows any error from the log entry, and the request
call sits outside the try that wraps the dispatch, so a log failure cannot alter the
call or reach the caller.
[10.16]: PASS — `supabase_igdb_client.dart:27` logs one response entry;
`igdb_call_log.dart:36-43` caps at `SupabaseIgdbProxyConstants.maxLogBodyLines` (50)
and appends `[cut short: showing 50 of N lines]` only when over. Failure case covered
by tests `should return the body unchanged when it is shorter than the cap` and
`...exactly at the cap` (no marker), vs `should say the output was cut short...`.
[10.17]: PASS — `supabase_igdb_client.dart:30-32`: `catch (error, stackTrace)` →
`IgdbCallLog.failure(error, stackTrace)` → `rethrow`, so type, message and stack are
unchanged for the caller. `igdb_call_log.dart:30` passes the stack trace straight to
`_talker.error` with no trimming; `trimToLineCap` is only reached from `response`.
The catch is broad enough to cover timeout, transport failure and an edge-function
error alike. Existing test `should fail rather than hang when the function does not
answer within 30 seconds` still passes.
[10.18]: MANUAL — see the checklist above. Code reads correctly:
`igdb_call_log.dart:18-19` `kDebugMode && FlavorConfig.instanceOrNull?.flavor == Flavor.dev`,
a getter so it is re-evaluated on every call, and `instanceOrNull` yields null (→ no
logging, call proceeds) when the flavour is unresolved.
[10.19]: PASS — `git diff --name-only` shows no file under any `presentation/`,
`screens/`, `widgets/` or route folder; grep for `TalkerScreen`, `TalkerWrapper`,
`TalkerRouteObserver` in `lib/` returns nothing. Output goes only to `_talker`
(`igdb_call_log.dart:12`), which is created with `useHistory: false`.
[10.20]: PASS — no import crosses the two paths: `lib/core/services/sentry/` contains
no `talker` reference and `lib/core/services/supabase/` contains no `sentry`
reference (grep, both empty). No `TalkerObserver`, no `SentryNavigatorObserver`, no
breadcrumb bridging. Either mechanism disabled leaves the other untouched — the
logging gate reads only `kDebugMode`/`FlavorConfig`, and `CrashReporter` never reads
`IgdbCallLog`.
[10.21]: PASS — `invoke`'s signature, `@injectable`, `const` constructor,
`functionName`, body map, `.timeout(...)` and `return response.data` are unchanged in
the diff; only logging and a rethrowing try/catch were added. The games, game detail
and featured services are absent from `git diff --name-only`. The 3 existing
`supabase_igdb_client_test.dart` tests pass.
[10.22]: PASS — `network_module.dart` has no `pretty_dio_logger` import and no second
`interceptors.add`; the diff removes exactly those two lines. `Dio` instance, all
four base options, the `TwitchAuthInterceptor` registration, the `@Deprecated`
annotation and the comments are unchanged.
[10.23]: PASS — `twitch_auth_interceptor.dart` has no `pretty_dio_logger` import and
an empty constructor body (lines 17-25); the token `Dio` keeps
`https://id.twitch.tv/oauth2/` and all three timeouts. `_fetchToken`, `onRequest`,
`onError` and the `@Deprecated` class annotation are untouched; the file stays in the
tree and stays unregistered in DI.
[10.24]: PASS — `grep -rn pretty_dio_logger pubspec.yaml pubspec.lock lib/ test/`
returns nothing; it appears in the lock neither as direct nor transitive. Analyzer
clean, so no orphaned import.
[10.25]: PASS — `.agents/references/flutter-arch.md` diff: line 170 now reads
"Provides the singleton `Dio` instance with `TwitchAuthInterceptor`" (no
`+ PrettyDioLogger`) and the `Logging: PrettyDioLogger (request header + body).`
line is deleted. What remains describes only `Dio` + `TwitchAuthInterceptor`, both of
which still exist. The line-169 path correction
(`lib/core/services/api/network_module.dart` → `lib/core/di/network_module.dart`) is
present and is the human-approved, criterion-free allowlist line recorded in
`task-brief.md`; the stale `@module` wording was correctly left alone.
[10.26]: PASS — see Static analysis and Test results: 0 new analyzer issues, 0 new
test failures. The only runtime-reachable change outside `bootstrap.dart` is inside
`SupabaseIgdbClient.invoke`; `NetworkModule` and `TwitchAuthInterceptor` remain
unregistered in `service_locator.config.dart` and unreachable from the app.

## Architectural compliance
Status: PASS
FAILs: NONE
WARNINGs:
- `tdd.md` §Models/§Services specifies a `CrashReportingSettings` class with a static
  `resolve`, and an `AppVersion` class at `lib/core/services/sentry/app_version.dart`.
  The code instead has a top-level `resolveCrashReportingSettings` returning a
  `({String dsn, String environment})?` record, and a top-level `readAppVersion()` at
  `lib/core/utils/version_utils.dart`. Logic, call sites and criteria coverage are
  identical. This is the human's own Phase 4B review instruction, recorded in
  `orchestrator-state.md ## Code review outcomes` (2026-08-06) and delivered as
  `e652d1f`, so it is a directed deviation, not drift — but it is recorded under
  "Code review outcomes" rather than "## Deviation approvals", and `tdd.md` was never
  amended to match. Flagging so the design doc and the code do not silently diverge.
- `lib/core/utils/version_utils.dart` is not named in the `task-brief.md` allowlist;
  it is the direct replacement for the allowlisted
  `lib/core/services/sentry/app_version.dart` (deleted in the same commit) under the
  same approved review instruction. Additive and harmless.
- Everything else matches `tdd.md`: `CrashReporter`, `CrashReportUser`, `TestCrash`,
  `IgdbCallLog` keep their specified names, paths and members;
  `FlavorConfig.instanceOrNull` is the single added accessor; `SentryConstants` and
  `SupabaseIgdbProxyConstants.maxLogBodyLines` sit in the shared
  `lib/core/res/const.dart` as designed; no package outside the two approved ones
  (`sentry_flutter`, `package_info_plus`) was added.

## Scope check
Working tree clean (`git status --short` empty), before and after `build_runner`.

`git diff --name-only 3eec703..HEAD` lists 37 files. In-allowlist or covered:
all 10 MODIFY EXISTING entries, 5 of the 6 CREATE NEW entries (`app_version.dart`
deleted, `version_utils.dart` substituted — see above), both TEST FILES, the implicit
generated `lib/core/di/service_locator.config.dart`, and the 5 desktop plugin
registrant files under `linux/`, `macos/`, `windows/` — the last are `flutter pub get`
output for the two new packages, declared in `diff-summary.md`, and this project
targets Android only.

Nine files in the diff are outside this run's allowlist and are **not** this run's
doing — `git log` attributes each to a commit predating or unrelated to the three Dev
commits (`a963c5f`, `e652d1f`, `a6685d4`), which touch only `lib/`, `test/`,
`pubspec.*` and the desktop registrants:
- `.agents/runs/cleanup-20260806/` (5 files) — the concurrent item-11 run, commits
  `a3c5d3a`, `f3371e5`, `1bf3d60`, `2f29f36`.
- `.agents/week-1-task-briefs.md` — commits `86366cf`, `06a861e`.
- `.agents/runs/sentry-20260806/` (this run's own artifacts) — expected.
No scope violation. `diff-summary.md` did not mention these, correctly so.

`TestCrash` (`test_crash.dart`, its `bootstrap.dart:46` call site, and the three
`SentryConstants.testCrash*` constants) is still present and wired into startup by
design — `orchestrator-state.md ## Follow-up actions` schedules its removal for a
separate commit after this QA pass and the human's [10.12] check. Not flagged.

## Escalation required
NONE

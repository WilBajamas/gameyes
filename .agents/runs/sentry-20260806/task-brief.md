# Task Brief
Source: `.agents/week-1-task-briefs.md` §"10 — Sentry [PIPELINE]", plus the IGDB
`talker` logging and `PrettyDioLogger` removal added to the same run on
2026-08-06 (both via `tech-ac.md`)
Date: 2026-08-06

## Context

Wire Sentry into the shared `bootstrap()` startup path so unhandled Dart and
Flutter framework errors from both flavours report into one project, tagged and
free of personal data, without a real DSN being required to build or run.

Added to the same run: log every IGDB edge-function call to the console with
`talker` in dev debug builds only, and delete the dead `PrettyDioLogger`
interceptor, its package and its documentation.

## New dependencies — READ THIS AT THE GATE

This task adds two packages. Adding a package is normally an escalation under
`.claude/pipeline/rules/escalation.md`; it is surfaced here instead because the
feature is *defined* as adding a crash-reporting SDK, and the orchestrator
directed that new dependencies be made visible at the Phase 3 human gate rather
than halt the run. Approving `code-plan.md` approves these two lines.

| Package | Why | Notes |
|---|---|---|
| `sentry_flutter` | The feature. Nothing in the tree reports crashes today. | Latest stable; resolve with `flutter pub add`, do not hand-pick a version. |
| `package_info_plus` | App version + build number for the [10.8] tag. | Already arrives **transitively** with `sentry_flutter` (it powers the SDK's own release detection), so this makes an existing import legal rather than pulling in new code. Confirm this in `pubspec.lock` after `pub get`; if it turns out not to be transitive, say so in `diff-summary.md`. |

`tdd.md ## Alternative considered` records a zero-direct-dependency way to get the
version tag (parse `SentryEvent.release`) if the human prefers to drop
`package_info_plus`. That swap is a `code-plan.md ## Approved feedback delta`
item, not something to decide during implementation.

The added logging scope adds **no** package: `talker_flutter` is already
`direct main` and re-exports all of `package:talker/talker.dart`. Import
`package:talker_flutter/talker_flutter.dart`, never `package:talker/talker.dart`
— the latter is transitive and trips `depend_on_referenced_packages`. [10.24]
**removes** `pretty_dio_logger`, so the net change to `pubspec.yaml` is +2 / -1.

Item 11's "add no dependency" instruction belongs to the concurrent
`cleanup-20260806` run only and does not constrain this one.

## Testing mode

`smoke` — Rule applied: *isolated with no shared dependencies*.

Justification: the new code is a self-contained startup service. It adds no
repository, use case, cubit or widget, and its only touch on shared code is
replacing one `runApp(app)` call in `bootstrap.dart`. It is not `coverage` work —
it is neither auth/authorisation (it *observes* auth status, it does not decide
anything), nor payments, nor persistence, nor a utility three features call. It is
not `none` either, because `CrashReportingSettings.resolve` carries real
criterion-backed branching ([10.2] [10.4] [10.5]) that is pure and cheap to test.

One unit test file covers that branching. `CrashReporter`, `CrashReportUser`,
`AppVersion` and `TestCrash` all bind to `Sentry`/`PackageInfo` statics or platform
channels and are not unit-testable without wrapper indirection this design
deliberately does not add; they are covered by the [10.12] manual verification.

The added scope stays `smoke` for the same reason. Its one piece of branching is
`IgdbCallLog.trimToLineCap` ([10.16]), which is pure and gets a second unit test
file. The [10.18] gate cannot be unit tested — `kDebugMode` is always true under
`flutter test` and `FlavorConfig` has no reset — so it is QA's manual dev-run
check. The `PrettyDioLogger` removal is behaviour-free in unreachable code and
gets no test; [10.24] and [10.26] are verified by the analyzer and the lock file.

## File allowlist

### CREATE NEW
- `lib/core/services/sentry/crash_reporting_settings.dart` — decides whether crash reporting starts, and with which environment name.
- `lib/core/services/sentry/crash_reporter.dart` — initialises the SDK, sets options and tags, scrubs events, and starts the app exactly once.
- `lib/core/services/sentry/app_version.dart` — reads `version+buildNumber` from the platform, or nothing.
- `lib/core/services/sentry/crash_report_user.dart` — keeps the Supabase user id on reports while signed in and clears it on sign-out.
- `lib/core/services/sentry/test_crash.dart` — double-gated dev-only deliberate crash for delivery verification.
- `lib/core/services/supabase/igdb_call_log.dart` — console log lines for IGDB calls in dev debug builds, and the 50-line body trim.

### MODIFY EXISTING
- `pubspec.yaml` — add `sentry_flutter` and `package_info_plus`, remove `pretty_dio_logger` (see above; this is the one task where `pubspec.yaml` is writable, not read-only).
- `pubspec.lock` — changes as a result of `flutter pub get`; commit it, do not hand-edit.
- `lib/core/res/const.dart` — add `ConfigConstants.sentryDsn`, add a `SentryConstants` class, add `SupabaseIgdbProxyConstants.maxLogBodyLines`.
- `lib/config/config_envied.dart` — add one obfuscated `sentryDsn` field to the shared `Env` class only.
- `lib/bootstrap.dart` — start crash reporting around the existing `runApp` call; start the user-context singleton and the dev crash trigger alongside it.
- `lib/config/flavor/flavor_config.dart` — add one `instanceOrNull` getter; change nothing else.
- `lib/core/services/supabase/supabase_igdb_client.dart` — log the call, the trimmed response and any failure around the existing `invoke` body; signature unchanged.
- `lib/core/di/network_module.dart` — delete the `PrettyDioLogger` import and its `interceptors.add` call. Nothing else.
- `lib/core/services/api/twitch_auth_interceptor.dart` — delete the `PrettyDioLogger` import and the constructor body that registered it. Nothing else.
- `.agents/references/flutter-arch.md` — drop `PrettyDioLogger` from lines 170 and 181, and correct the `NetworkModule` path on line 169.

### TEST FILES
- `test/repository/sentry/crash_reporting_settings_test.dart` — every branch of `CrashReportingSettings.resolve`: unknown flavour, empty DSN, placeholder DSN, and that both flavours produce the same DSN with different environment names.
- `test/api/supabase/igdb_call_log_test.dart` — the 50-line body cap: under, exactly at, and over the cap, and that only the over case carries the cut-short marker.

Path follows the existing precedent for a core service test,
`test/repository/supabase/supabase_connection_checker_test.dart`. No mocks are
needed — the subject is pure. The second test file sits beside the existing
`test/api/supabase/supabase_igdb_client_test.dart`, matching the layer of the code
it covers; it needs no mocks either.

**One line in the allowlist is not backed by a criterion.** The `flutter-arch.md`
line 169 path fix (`lib/core/services/api/network_module.dart` →
`lib/core/di/network_module.dart`) is *not* in `tech-ac.md` — the BA explicitly
placed it out of scope as unrelated to the logger removal. The human approved
adding it on 2026-08-06 because it sits in the same line block as [10.25]'s two
edits. It is recorded here so QA does not read it as scope invented during
design. Nothing else on or around that line changes — in particular the equally
stale `@module` wording stays.

Generated outputs (`config_envied.g.dart`, `service_locator.config.dart`) are
implicit for the allowlisted annotated sources and are not listed.

## Implementation plan

Step 1: `pubspec.yaml` — add `sentry_flutter` and `package_info_plus` under
`dependencies`, each with a short comment matching the file's existing grouped
style. Prefer `flutter pub add sentry_flutter package_info_plus` so pub picks
constraints compatible with Dart 3.10 / Flutter 3.38.1, then tidy the placement
and comments by hand. Record the resolved versions for `diff-summary.md`.

Step 2: `lib/core/res/const.dart` — add `static const sentryDsn = 'SENTRY_DSN';`
to `ConfigConstants` next to `supabaseAnonKey`, and add a new `SentryConstants`
class after `SupabaseConstants` holding the placeholder DSN, the flavour and
app-version tag keys, the dart-define flag name, and the test-crash delay and
message. **Added scope, same edit:** add `static const maxLogBodyLines = 50;` to
the existing `SupabaseIgdbProxyConstants` class at the bottom of the file.

Step 3: `lib/config/config_envied.dart` — add one `@EnviedField` to the **shared
`Env` class only**: `varName: ConfigConstants.sentryDsn`, `obfuscate: true`,
`defaultValue: SentryConstants.placeholderDsn`. Do not touch `EnvDev` or
`EnvProd`. If the `envied` generator rejects the `static const` reference as a
`defaultValue` (existing fields use string literals), fall back to the literal
`'PLACEHOLDER_SENTRY_DSN'` in the annotation while keeping
`SentryConstants.placeholderDsn` as the single comparison point in code — that
fallback is pre-approved; note it in `diff-summary.md` rather than escalating.

Step GEN-A: `dart run build_runner build --delete-conflicting-outputs` —
regenerates `config_envied.g.dart`. Expect the placeholder to be produced, since
`secret.env` does not exist in this checkout; that is [10.3] working, not a
failure.

Step 4: create `lib/core/services/sentry/crash_reporting_settings.dart`.

Step 5: create `lib/core/services/sentry/app_version.dart`.

Step 6: create `lib/core/services/sentry/crash_reporter.dart`.

Step 7: create `lib/core/services/sentry/crash_report_user.dart` — annotate
`@singleton`.

Step 8: create `lib/core/services/sentry/test_crash.dart`.

Step GEN-B: `dart run build_runner build --delete-conflicting-outputs` — wires
`CrashReportUser` into `service_locator.config.dart`.

Step 9: `lib/bootstrap.dart` — replace the trailing `runApp(app);` with the
`CrashReporter.start(...)` call whose `startApp` callback starts
`getIt<CrashReportUser>()`, calls `runApp(app)`, then calls
`TestCrash.scheduleIfRequested(flavor)`. Leave every preceding statement, and
their order, exactly as they are.

Step 10: create `test/repository/sentry/crash_reporting_settings_test.dart`.

Step 11: `lib/config/flavor/flavor_config.dart` — add
`static FlavorConfig? get instanceOrNull => _instance;` directly above the
existing `instance` getter, with one comment saying it is null until bootstrap
has run. Do not change `instance`, `initialise`, the fields or the constructor.

Step 12: create `lib/core/services/supabase/igdb_call_log.dart` — static-only,
three log entry points, the `@visibleForTesting` trim, one private `_write`
guard, and the private `Talker` with `useHistory: false`. Import
`package:talker_flutter/talker_flutter.dart`.

Step 13: `lib/core/services/supabase/supabase_igdb_client.dart` — call
`IgdbCallLog.request` before dispatch, wrap the existing body in
`try`/`catch (error, stackTrace)`, call `IgdbCallLog.response(response.data)`
before returning, call `IgdbCallLog.failure(error, stackTrace)` then `rethrow`.
Leave the signature, the `@injectable` annotation, the `const` constructor and
the `.timeout(...)` exactly as they are.

Step 14: `lib/core/di/network_module.dart` — delete the
`package:pretty_dio_logger/pretty_dio_logger.dart` import and the
`dio.interceptors.add(PrettyDioLogger(...))` statement. Keep the
`dio.interceptors.add(interceptor);` line above it and everything else
untouched.

Step 15: `lib/core/services/api/twitch_auth_interceptor.dart` — delete the
`pretty_dio_logger` import and the whole constructor body block that registered
the logger on `_tokenDio`, so the constructor ends at the initialiser list's `;`.
Change no other member.

Step 16: `pubspec.yaml` — delete the `pretty_dio_logger: ^1.4.0` line under
`# Logging`, keeping `logger` and `talker_flutter`. Run `flutter pub get` and
confirm `pretty_dio_logger` no longer appears anywhere in `pubspec.lock`. If it
reappears as `transitive`, stop and report it in `diff-summary.md` — something
else depends on it and that is a finding, not something to patch around. [10.24]

Step 17: `.agents/references/flutter-arch.md` — on line 169 correct the path to
`lib/core/di/network_module.dart` (leave `@module` alone); on line 170 drop
`+ PrettyDioLogger`; delete the `Logging: PrettyDioLogger (request header +
body).` line at 181 outright rather than rewriting it. Add no sentence about
`IgdbCallLog` — it is not part of the Dio setup that section describes.

Step 18: create `test/api/supabase/igdb_call_log_test.dart`.

Step 19: run `flutter analyze` and `flutter test`, and compare against
`orchestrator-state.md`, quoted verbatim:
- `Analyzer baseline: 0 errors, 2 warnings, 32 info — captured 2026-08-06T00:00:00Z`
- `Test baseline: +11 -11 counted as failures (199 passing, 11 failing out of 210) — captured 2026-08-06T00:00:00Z`
- `Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart (4), test/cubit/game_detail/game_detail_cubit_test.dart (3), test/cubit/games/games_bloc_test.dart (3), test/widget_test.dart (1).`

Only a new, in-scope error or failure is yours. Do not attempt to fix the eleven
pre-existing failures. Watch specifically for the three existing tests in
`test/api/supabase/supabase_igdb_client_test.dart` — they must still pass, which
is [10.21].

19 non-generation steps; the 20-step ceiling is not exceeded. (This step list
replaces the earlier 11-step version: steps 1–10 are unchanged apart from the
added clause in Step 2, the old Step 11 verification is now Step 19, and steps
11–18 are the added scope.)

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: 10.1, 10.2, 10.3, 10.4, 10.5, 10.6, 10.7, 10.8, 10.9, 10.10, 10.11,
10.12, 10.13, 10.14, 10.15, 10.16, 10.17, 10.18, 10.19, 10.20, 10.21, 10.22,
10.23, 10.24, 10.25, 10.26

10.12 and 10.13 are manual/QA verification. 10.12 cannot be run in this checkout —
it needs the human's real DSN in a local `secret.env`. Implement for it, do not
claim it. 10.18 and 10.19 are likewise manual: they need a `flutter run --flavor
dev` in debug to observe, and the same build in release to observe silence.

## Constraints

From `flutter-arch.md`:
- `lib/core/services/[area]/` is the home for a cross-cutting service; `sentry/`
  sits beside the existing `supabase/` and `storage/` folders, and the IGDB log
  helper sits inside `supabase/` beside the client it serves.
- New `@injectable`/`@singleton` classes are wired only by build_runner; never
  hand-edit `service_locator.config.dart`. `IgdbCallLog` is static and gets no
  annotation, so it needs no generation step.
- Never read `secret.env` directly — go through the `envied` `Env` class.
- Never edit `*.g.dart` or `*.config.dart` by hand.

From `project-conventions.md` and `.claude/pipeline/rules/execution.md`:
- Comments are plain English explaining *why*, and few. No `///` line per field
  that restates the field name. No framework or pattern jargon.
- Names are plain English words — no invented compounds, no placeholder-looking
  identifiers.
- Constants belong in the right `*Constants` class in `lib/core/res/const.dart`,
  never inline and never bare top-level. `SupabaseConstants` is the precedent for
  a core service owning a class there. The 50-line cap goes on the existing
  `SupabaseIgdbProxyConstants`, not into a new class and not inline.
- Prefer a concrete class over a single-implementation interface. No `abstract
  interface class` anywhere in this task.

From `dart-style.md`:
- `prefer_single_quotes`, `require_trailing_commas`, `lines_longer_than_80_chars`
  (hard limit — the `debugPrint` strings and long class names will need care),
  `no_default_cases` (the `switch` on `AuthStatusEntity` handles both variants
  explicitly), `avoid_redundant_argument_values`.
- Package imports, not relative, except `part`/`part of` and `generated/l10n.dart`
  (neither applies here). `network_module.dart` currently uses relative imports;
  leave the remaining ones as they are — [10.22] wants only the logger line gone.
- No `dynamic`, no `var` for class fields, no `late`, no `print`. `debugPrint` is
  fine and matches `SupabaseConnectionChecker`.
- The empty `catch` in `IgdbCallLog._write` must carry a comment saying why it
  swallows, both because `empty_catches` needs it and because a silent catch with
  no explanation is the thing reviewers rightly stop on.

From `testing-conventions.md`:
- Test name format `'should [expected behaviour] when [condition]'`.
- Never a golden test.

Criterion-specific hard rules:
- Exactly one DSN field, in the shared `Env` class. No `switch (flavor)` near the
  DSN, no per-flavour DSN key, no DSN on `FlavorConfig`. [10.2]
- Never commit a real DSN, and never commit a `secret.env`. [10.3]
- At most one diagnostic log line for a disabled or failed start, and none per
  captured error. No retry loop. [10.4]
- Do not add `sentry_dio` or any Dio interceptor integration — it is the one thing
  that could put a Supabase or Twitch token into a breadcrumb. [10.9]
- Do not enable tracing, profiling, session replay, release-health sessions,
  screenshot or view-hierarchy attachment. Out of scope, and several of them
  attach PII.
- The test crash must be gated twice: `--dart-define=SENTRY_TEST_CRASH=true`
  **and** `Flavor.dev`. No user-reachable trigger, no UI affordance. [10.13]
- Do not change any statement or ordering in `bootstrap.dart` other than the
  `runApp` call site. [10.14]
- Evaluate the log gate inside each entry point, never once at startup, and put
  `kDebugMode` first so a release build tree-shakes the rest. [10.18]
- Never import `TalkerScreen`, `TalkerWrapper`, `TalkerRouteObserver` or any other
  viewer type, and add no route, button, overlay or widget. [10.19]
- Install no `TalkerObserver`, and never call anything from `sentry_flutter`
  inside `IgdbCallLog` or anything from `talker_flutter` inside the Sentry
  service. [10.20]
- `rethrow` the original error — never `throw error`, never wrap it, and never
  apply the line cap to an error or a stack trace. [10.17] [10.21]
- The trim marker appears only when the body was actually cut. A body at or under
  50 lines is emitted verbatim. [10.16]
- The two `PrettyDioLogger` edits are subtractive only. No reordering, no
  reformatting, no import tidying, no touching `@Deprecated` or the comments.
  [10.22] [10.23]
- `flutter-arch.md` gets exactly three line edits and nothing else. [10.25]

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make
tests pass. Do not touch files outside the allowlist — escalate instead.
`pubspec.yaml` and `pubspec.lock` are writable in this task **only** for the two
dependencies added and the one removed above; any further package change is an
escalation.

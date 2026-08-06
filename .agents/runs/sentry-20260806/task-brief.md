# Task Brief
Source: `.agents/week-1-task-briefs.md` §"10 — Sentry [PIPELINE]" (via `tech-ac.md`)
Date: 2026-08-06

## Context

Wire Sentry into the shared `bootstrap()` startup path so unhandled Dart and
Flutter framework errors from both flavours report into one project, tagged and
free of personal data, without a real DSN being required to build or run.

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

## File allowlist

### CREATE NEW
- `lib/core/services/sentry/crash_reporting_settings.dart` — decides whether crash reporting starts, and with which environment name.
- `lib/core/services/sentry/crash_reporter.dart` — initialises the SDK, sets options and tags, scrubs events, and starts the app exactly once.
- `lib/core/services/sentry/app_version.dart` — reads `version+buildNumber` from the platform, or nothing.
- `lib/core/services/sentry/crash_report_user.dart` — keeps the Supabase user id on reports while signed in and clears it on sign-out.
- `lib/core/services/sentry/test_crash.dart` — double-gated dev-only deliberate crash for delivery verification.

### MODIFY EXISTING
- `pubspec.yaml` — add `sentry_flutter` and `package_info_plus` (see above; this is the one task where `pubspec.yaml` is writable, not read-only).
- `pubspec.lock` — changes as a result of `flutter pub get`; commit it, do not hand-edit.
- `lib/core/res/const.dart` — add `ConfigConstants.sentryDsn`, add a `SentryConstants` class.
- `lib/config/config_envied.dart` — add one obfuscated `sentryDsn` field to the shared `Env` class only.
- `lib/bootstrap.dart` — start crash reporting around the existing `runApp` call; start the user-context singleton and the dev crash trigger alongside it.

### TEST FILES
- `test/repository/sentry/crash_reporting_settings_test.dart` — every branch of `CrashReportingSettings.resolve`: unknown flavour, empty DSN, placeholder DSN, and that both flavours produce the same DSN with different environment names.

Path follows the existing precedent for a core service test,
`test/repository/supabase/supabase_connection_checker_test.dart`. No mocks are
needed — the subject is pure.

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
message.

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

Step 11: run `flutter analyze` and `flutter test`, and compare against
`orchestrator-state.md`, quoted verbatim:
- `Analyzer baseline: 0 errors, 2 warnings, 32 info — captured 2026-08-06T00:00:00Z`
- `Test baseline: +11 -11 counted as failures (199 passing, 11 failing out of 210) — captured 2026-08-06T00:00:00Z`
- `Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart (4), test/cubit/game_detail/game_detail_cubit_test.dart (3), test/cubit/games/games_bloc_test.dart (3), test/widget_test.dart (1).`

Only a new, in-scope error or failure is yours. Do not attempt to fix the eleven
pre-existing failures.

11 non-generation steps; the 20-step ceiling is not approached.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: 10.1, 10.2, 10.3, 10.4, 10.5, 10.6, 10.7, 10.8, 10.9, 10.10, 10.11,
10.12, 10.13, 10.14

10.12 and 10.13 are manual/QA verification. 10.12 cannot be run in this checkout —
it needs the human's real DSN in a local `secret.env`. Implement for it, do not
claim it.

## Constraints

From `flutter-arch.md`:
- `lib/core/services/[area]/` is the home for a cross-cutting service; `sentry/`
  sits beside the existing `supabase/` and `storage/` folders.
- New `@injectable`/`@singleton` classes are wired only by build_runner; never
  hand-edit `service_locator.config.dart`.
- Never read `secret.env` directly — go through the `envied` `Env` class.
- Never edit `*.g.dart` or `*.config.dart` by hand.

From `project-conventions.md` and `.claude/pipeline/rules/execution.md`:
- Comments are plain English explaining *why*, and few. No `///` line per field
  that restates the field name. No framework or pattern jargon.
- Names are plain English words — no invented compounds, no placeholder-looking
  identifiers.
- Constants belong in the right `*Constants` class in `lib/core/res/const.dart`,
  never inline and never bare top-level. `SupabaseConstants` is the precedent for
  a core service owning a class there.
- Prefer a concrete class over a single-implementation interface. No `abstract
  interface class` anywhere in this task.

From `dart-style.md`:
- `prefer_single_quotes`, `require_trailing_commas`, `lines_longer_than_80_chars`
  (hard limit — the `debugPrint` strings and long class names will need care),
  `no_default_cases` (the `switch` on `AuthStatusEntity` handles both variants
  explicitly), `avoid_redundant_argument_values`.
- Package imports, not relative, except `part`/`part of` and `generated/l10n.dart`
  (neither applies here).
- No `dynamic`, no `var` for class fields, no `late`, no `print`. `debugPrint` is
  fine and matches `SupabaseConnectionChecker`.

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

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make
tests pass. Do not touch files outside the allowlist — escalate instead.
`pubspec.yaml` and `pubspec.lock` are writable in this task **only** for the two
dependencies named above; any further package is an escalation.

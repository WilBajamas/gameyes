# Technical Design Document
Source: `.agents/week-1-task-briefs.md` §"10 — Sentry [PIPELINE]" (via `tech-ac.md`)
Date: 2026-08-06

## Feature summary

A new self-contained startup service under `lib/core/services/sentry/` initialises
the Sentry Flutter SDK from inside the existing `bootstrap()` sequence, after the
flavour is resolved and as the wrapper around the single `runApp` call. A pure
value class decides whether reporting starts at all, from one shared obfuscated
`envied` field plus the active flavour; when it returns nothing, `bootstrap`
starts the app exactly as it does today. Flavour and app-version tags plus PII
scrubbing are applied in a single `beforeSend` hook so both error sources are
covered by one code path. A separate `@singleton`, started alongside the existing
`AuthStatusListener`, mirrors the Supabase user id onto the Sentry scope and
clears it on sign-out. No repository, use case, cubit, screen or route is added.

## Layer map

- [10.1] startup (`bootstrap.dart`), service
- [10.2] config (`config_envied.dart`, `const.dart`), service
- [10.3] config (`config_envied.dart`, `const.dart`)
- [10.4] service, startup
- [10.5] config (`flavor.dart` — read only), service
- [10.6] service (SDK integration), startup
- [10.7] service (SDK integration)
- [10.8] service (SDK options + platform read via `package_info_plus`)
- [10.9] service (`beforeSend`)
- [10.10] service (SDK options)
- [10.11] service (new `@singleton`), domain (existing `ObserveAuthStatusUseCase`, read only)
- [10.12] verification only — no code
- [10.13] service (dev-only trigger), startup
- [10.14] startup (regression surface: `bootstrap.dart` only)

## Data layer

### API contracts
None. No criterion maps to the API layer; Sentry event transport is entirely
inside the SDK.

### Models

`CrashReportingSettings` (create) — `lib/core/services/sentry/crash_reporting_settings.dart`
— fields `dsn` (`String`, non-null), `environment` (`String`, non-null) — no
serialisation, not an API DTO — source: derived at runtime from `Env.sentryDsn`
and `Flavor.name`.

It is a plain immutable class, not `@freezed`: it never needs `copyWith`, JSON, or
equality beyond what the one unit test asserts field-by-field, and `dart-style.md`
explicitly allows plain-Dart entities where freezed buys nothing.

Its only behaviour is the static factory `resolve({required Flavor? flavor,
required String dsn})`, returning `CrashReportingSettings?`:

- `flavor == null` → `null` — [10.5] failure case: skip rather than default to a
  wrong environment.
- `dsn.isEmpty || dsn == SentryConstants.placeholderDsn` → `null` — [10.4].
- otherwise → settings with `environment: flavor.name` — [10.5]; the DSN is
  passed in, never selected per flavour — [10.2].

The DSN is a parameter rather than a direct `Env.sentryDsn` read so all four
branches are unit-testable; the single production call site in `CrashReporter`
supplies `Env.sentryDsn`.

`flavor` is nullable because [10.5]'s failure case demands a skip path. Today's
one call site (`bootstrap`) always holds a resolved `Flavor`, so this is a guard,
not a live path — noted here so a reviewer reads it as deliberate.

### Repositories
None. Crash reporting has no data source, no `Result<T>` surface and no caller
that could consume one.

## Domain layer

No new use case. [10.11] reuses the existing `ObserveAuthStatusUseCase`
(`lib/features/auth/domain/use_cases/observe_auth_status_use_case.dart`)
unchanged — it already emits `AuthStatusEntity` on subscribe and on every
subsequent change, which is exactly the signal the user context needs.

## State layer

No Bloc or Cubit. Nothing here renders.

`CrashReportUser` (create) — `lib/core/services/sentry/crash_report_user.dart` —
`@singleton`, app-lifetime scope. Global scope is criterion-backed: [10.11]
requires the user id to be correct for events raised anywhere in the app,
including before any screen exists, so a screen-scoped holder cannot satisfy it.
It follows the existing precedent of `AuthStatusListener` and `SessionNavigator`
exactly: constructor-injected use case, a `start()` called once from `bootstrap`,
one long-lived `StreamSubscription`.

It maps `AuthSignedIn(:final user)` → `SentryUser(id: user.id)` and
`AuthSignedOut()` → `null`, then hands the result to `Sentry.configureScope`.
Passing `null` to `Scope.setUser` clears it, which is what [10.11]'s failure case
(no stale id after sign-out) requires. A stream error is treated as signed out,
matching `AuthStatusListener`'s existing `onError` behaviour.

A second subscription to the same stream is taken deliberately rather than
extending `AuthStatusListener` to expose the id: `AuthStatusListener` is item 8's
shipped auth-routing mechanism and [10.14] forbids regressing startup behaviour.
Adding a field and a notification path to it would put crash reporting inside the
routing hot path for no gain.

## UI layer

### Screens
None created or modified.

### Widgets
None created or modified. Explicitly no crash dialog, no "report a problem"
affordance and no Settings row — `tech-ac.md ## Out of scope` rules all three out,
and the [10.12] verification trigger is a `--dart-define` flag, not UI, so no new
`.arb` string and no IDE l10n regeneration is needed anywhere in this task.

## Services (the substance of this design)

### `CrashReporter` — `lib/core/services/sentry/crash_reporter.dart` (create)

Static-only holder. One entry point:

`start({required Flavor? flavor, required VoidCallback startApp})`

1. `CrashReportingSettings.resolve(flavor: flavor, dsn: Env.sentryDsn)`.
2. `null` → one `debugPrint`, call `startApp()`, return. [10.4] — no exception, no
   retry, exactly one diagnostic line for the whole run, none per error.
3. Build the tag map: flavour tag always; app-version tag only when
   `AppVersion.read()` returned non-null. [10.8] and its failure case.
4. `SentryFlutter.init(configure, appRunner: runOnce)` inside `try`/`catch`.
5. `runOnce()` again after the `try`/`catch`. It is idempotent behind a local
   `bool`, so the app starts exactly once whether init succeeded, threw, or was
   skipped. This is how [10.1]'s failure case is met without any risk of a double
   `runApp`.

`appRunner` is used rather than calling `runApp` before/after init because it is
the SDK's documented integration point and keeps the app inside whatever zone the
SDK installs, so [10.6]'s asynchronous root-handler path needs no assumption about
SDK internals on our side.

Options set in `configure` — deliberately short, because everything else stays at
its default per `tech-ac.md ## Out of scope`:

- `dsn` — from settings. [10.2] [10.3]
- `environment` — `flavor.name`, i.e. `dev` or `prod`. [10.5]
- `sendDefaultPii = false` — set explicitly even though it is the SDK default, so
  [10.10] is visible in the diff rather than inherited silently.
- `beforeSend` — a closure over the tag map (below).

Not set, and not to be set: tracing/profiling/replay sample rates, release-health
session tracking, screenshot/view-hierarchy attachment, and any `sentry_dio`
interceptor. The Dio one matters for [10.9]: without it, no request URL, header or
body — and therefore no Supabase access token and no Twitch bearer token — can
ever become a breadcrumb.

`beforeSend` does both tagging and scrubbing in one place so [10.8] and [10.9]
hold identically for framework errors [10.7] and async errors [10.6]:

- merges the flavour and app-version tags over `event.tags`
- replaces `event.user` with an id-only `SentryUser` when a user is present

The user rebuild is the "scrubbed before send, not merely relied upon to be empty"
that [10.9]'s failure case asks for. Note `SentryEvent.copyWith` treats a `null`
argument as "leave unchanged", so the code passes a replacement only when
`event.user != null` — passing `null` in the absent case is a no-op either way and
is written that way on purpose.

### `AppVersion` — `lib/core/services/sentry/app_version.dart` (create)

Static-only. `Future<String?> read()` returns `'<version>+<buildNumber>'` from
`PackageInfo.fromPlatform()`, or `null` on an empty version or any thrown error.
`null` means the tag is omitted and the event still sends — [10.8] failure case.

### `TestCrash` — `lib/core/services/sentry/test_crash.dart` (create)

Static-only. `scheduleIfRequested(Flavor flavor)` returns immediately unless
**both** gates pass: the compile-time `bool.fromEnvironment('SENTRY_TEST_CRASH')`
is true **and** `flavor == Flavor.dev`. When both pass it schedules a
`Future.delayed` that throws a `StateError`.

Two gates, either sufficient, is what satisfies [10.13]: a prod build never passes
the flavour gate, and no build passes the environment gate unless someone typed
`--dart-define=SENTRY_TEST_CRASH=true` on the command line. There is no
user-reachable trigger at all.

The throw is deliberately asynchronous and outside the widget tree so it exercises
[10.6]'s exact path — an uncaught async error reaching the root error handler —
rather than the framework hook, and produces the readable Dart stack trace
[10.12] checks for.

### Startup wiring — `lib/bootstrap.dart` (modify)

Every existing statement keeps its current position and order, which is what
[10.14] protects. The only change is that the final `runApp(app)` becomes the body
of a callback handed to `CrashReporter.start`:

```
ensureInitialized → overlay style → FlavorConfig.initialise → configureDependencies
→ AuthStatusListener.start → SessionNavigator.start → SupabaseConnectionChecker.check
→ CrashReporter.start(flavor, startApp: { CrashReportUser.start; runApp(app);
                                          TestCrash.scheduleIfRequested(flavor) })
```

`CrashReportUser.start()` sits inside `startApp` on purpose: it runs after
`SentryFlutter.init` has replaced the no-op hub, so the first auth status the
stream replays actually lands on a live scope. Started earlier it would be
silently dropped and [10.11] would fail for the launch session.

Accepted cost, stated plainly: when a real DSN is present, `SentryFlutter.init`
and one `PackageInfo` platform call sit between the connectivity check and the
first frame. [10.1] mandates initialisation before `runApp`, so this is
unavoidable, not a design choice. On this checkout (placeholder DSN) the added
work is one string comparison and one `debugPrint`, so [10.14]'s
time-to-first-frame clause is unaffected on the only path QA can measure.

## Configuration

`ConfigConstants.sentryDsn = 'SENTRY_DSN'` — the env var name, sitting next to the
existing `apiKey`, `supabaseUrl` and `supabaseAnonKey` entries.

New `SentryConstants` class in `lib/core/res/const.dart`, alongside the existing
`SupabaseConstants` — same precedent: a core service's constants live there, not
in a feature `const.dart`, because `lib/core/services/sentry/` is not a feature.
Holds the placeholder DSN, the two tag keys, the dart-define flag name, and the
test-crash delay and message.

`Env.sentryDsn` is added to the **shared** `Env` class (source `secret.env`), not
to `EnvDev`/`EnvProd`, and `FlavorConfig` gains no Sentry field. That is the
direct expression of [10.2]: there is one field, one env key, one placeholder, and
no `switch (flavor)` anywhere near the DSN. `obfuscate: true` plus a placeholder
default matches every existing field, so a checkout with no `secret.env` still
builds — [10.3].

## Reuse decisions

- `bootstrap()` at `lib/bootstrap.dart` — the single shared startup path both
  entrypoints already call. [10.1] is satisfied by extending it; no entrypoint
  file is touched, so nothing can drift between `main.dart` and `main_prod.dart`.
- `Flavor` / `FlavorConfig` at `lib/config/flavor/` — flavour is already resolved
  and passed into `bootstrap` as a parameter. `Flavor.name` is reused verbatim as
  the Sentry environment, so `dev`/`prod` cannot disagree with the rest of the app.
- `Env` + `envied` at `lib/config/config_envied.dart` — the project's established
  obfuscated-secret mechanism, already proven to build with no env file present.
- `ObserveAuthStatusUseCase` — reused unchanged for [10.11].
- `AuthStatusListener` / `SessionNavigator` — reused as the *pattern* for
  `CrashReportUser` (`@singleton`, injected use case, `start()` from bootstrap),
  and deliberately left unmodified.
- `debugPrint` — matches `SupabaseConnectionChecker`'s existing startup
  diagnostics; no new logging dependency, and `dart-style.md`'s `print` ban is
  about `print`, not `debugPrint`.
- **No existing global error handling to reuse or fight.** `runZonedGuarded`,
  `FlutterError.onError` and `PlatformDispatcher.instance.onError` appear nowhere
  in `lib/` — the only two `runZonedGuarded` hits in the repo are inside
  `test/widget/theme/*_test.dart`. The Sentry SDK therefore installs the first and
  only handlers, and its `FlutterErrorIntegration` chains to Flutter's own default
  `presentError`, which is what preserves debug console output and the existing
  error widget for [10.7].

### Alternative considered and rejected for the app-version tag

`sentry_flutter` already populates `SentryEvent.release` as `package@version+build`
from its own package-info integration, so the version tag could be parsed out of
`event.release` inside `beforeSend` with **no direct dependency at all**. Rejected:
it couples the tag to an undocumented-in-our-code string format, is invisible to a
reader of the tag code, and silently degrades to a missing tag if the SDK changes
the format. Reading `PackageInfo.fromPlatform()` directly is three lines, obvious,
and independently testable. This is a cheap swap if the human prefers it at the
gate — see `code-plan.md`.

## Out of scope

- Everything listed in `tech-ac.md ## Out of scope` — tracing, profiling, replay,
  release-health sessions, handled-exception capture, breadcrumb routing of the
  app's logging, native symbol/mapping upload, Sentry dashboard configuration,
  prod verification, iOS.
- `sentry_dio` / any Dio interceptor integration — actively excluded, see above.
- Any change to `AuthStatusListener`, `SessionNavigator`, `AuthRepositoryImpl`, the
  auth entities, routing, DI module files, or either `main` entrypoint.
- Any user-facing string, `.arb` edit or `lib/generated/l10n.dart` regeneration.
- Supplying the real DSN. This checkout resolves the placeholder and exercises
  [10.4]; the human pastes the real value into `secret.env` locally for [10.12].

## Open questions

NONE.

## New dependencies — flagged for the Phase 3 human gate

This design adds two packages to `pubspec.yaml`. Rationale is in
`task-brief.md ## New dependencies`; it is repeated at the top of `code-plan.md`
so it cannot be missed at the gate.

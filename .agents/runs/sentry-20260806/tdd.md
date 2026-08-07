# Technical Design Document
Source: `.agents/week-1-task-briefs.md` §"10 — Sentry [PIPELINE]", plus the IGDB
`talker` logging and `PrettyDioLogger` removal added to the same run on
2026-08-06 (both via `tech-ac.md`)
Date: 2026-08-06

## Amendment — Phase 4B revision (2026-08-07)

Per the human's Phase 4B review (recorded in `orchestrator-state.md ## Code
review outcomes`, shipped as commit `e652d1f`), two pieces described below no
longer match the code, on purpose:

- **`CrashReportingSettings`** (§Models, below) — the class and its static
  `resolve` factory were replaced by a top-level function,
  `resolveCrashReportingSettings`, returning a nullable Dart 3 record
  (`({String dsn, String environment})?`) instead of a class instance. Same
  four branches, same failure cases, same criteria coverage — only the shape
  changed, class → function, instance fields → record fields.
- **`AppVersion`** (§Services, below) — the class was deleted. Its logic moved
  to a top-level function, `readAppVersion()`, at
  `lib/core/utils/version_utils.dart` (not `lib/core/services/sentry/` as
  described below).

Everything else in this document — `CrashReporter`, `CrashReportUser`,
`TestCrash`, `IgdbCallLog`, the constants, and every criterion mapping — matches
the shipped code as originally designed.

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

Added on 2026-08-06 to the same run, and entirely separate from the above: a
static console-logging helper beside the IGDB client logs each `invoke` call, its
response body trimmed to 50 lines, and any failure with a full stack trace, using
the `Talker` already available through the existing `talker_flutter` dependency.
It is gated per call on debug build AND dev flavour, reads the flavour through a
new non-throwing accessor on `FlavorConfig`, and is wired nowhere — no DI entry,
no widget, no route. Alongside it the `PrettyDioLogger` interceptor is deleted
from the two deprecated Dio files that still register it, the `pretty_dio_logger`
package is dropped from `pubspec.yaml`, and `flutter-arch.md` stops documenting
it.

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
- [10.15] service (new `IgdbCallLog`), API client (`supabase_igdb_client.dart`)
- [10.16] service (`IgdbCallLog.trimToLineCap`), config (`const.dart`)
- [10.17] service, API client
- [10.18] service, config (`flavor_config.dart` — one added accessor)
- [10.19] service (no UI layer touched at all)
- [10.20] service (independence of the two services above)
- [10.21] API client (regression surface: `invoke` signature only)
- [10.22] DI module (`network_module.dart`, deprecated, unreachable)
- [10.23] service (`twitch_auth_interceptor.dart`, deprecated, unreachable)
- [10.24] dependencies (`pubspec.yaml`, `pubspec.lock`)
- [10.25] documentation (`.agents/references/flutter-arch.md`)
- [10.26] regression surface for [10.15]-[10.25]

## Data layer

### API contracts
None. No criterion maps to the API layer; Sentry event transport is entirely
inside the SDK, and the added logging observes an existing call rather than
defining a new one.

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

No model is added for [10.15]-[10.26]. The log entries are strings built at the
call site; nothing about them is stored, parsed or passed on.

### Repositories
None. Crash reporting has no data source, no `Result<T>` surface and no caller
that could consume one. The logging scope adds no repository either — it sits
inside the existing `SupabaseIgdbClient`, below every repository.

## Domain layer

No new use case. [10.11] reuses the existing `ObserveAuthStatusUseCase`
(`lib/features/auth/domain/use_cases/observe_auth_status_use_case.dart`)
unchanged — it already emits `AuthStatusEntity` on subscribe and on every
subsequent change, which is exactly the signal the user context needs.

Nothing in [10.15]-[10.26] reaches the domain layer.

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

No state class is added for [10.15]-[10.26].

## UI layer

### Screens
None created or modified.

### Widgets
None created or modified. Explicitly no crash dialog, no "report a problem"
affordance and no Settings row — `tech-ac.md ## Out of scope` rules all three out,
and the [10.12] verification trigger is a `--dart-define` flag, not UI, so no new
`.arb` string and no IDE l10n regeneration is needed anywhere in this task.

[10.19] is satisfied structurally rather than by a check: the added scope creates
and modifies no file under any `presentation/` folder, imports nothing from
`talker_flutter`'s viewer half (`TalkerScreen`, `TalkerWrapper`,
`TalkerRouteObserver`), and adds no route to `app_router.dart`.

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

The added scope puts its one constant, the 50-line cap, on the existing
`SupabaseIgdbProxyConstants` in the same file — it belongs to the IGDB proxy call
path that class already describes, so no third class is introduced.

---

# Added scope — IGDB call logging and `PrettyDioLogger` removal

Everything below covers [10.15]-[10.26]. It shares no code, no configuration and
no failure mode with the Sentry half above; that separation is [10.20] and is
the reason it is written as its own section rather than folded into the services
above.

## Where the logging lives

### `IgdbCallLog` — `lib/core/services/supabase/igdb_call_log.dart` (create)

A static-only helper file beside `supabase_igdb_client.dart`, not inline code in
the client and not a new injected collaborator. Three reasons:

1. **[10.21] forbids touching the callers**, and the client's constructor is
   `const SupabaseIgdbClient(this._client)` with a single DI-provided
   `SupabaseClient`. A new constructor parameter would mean a new DI registration
   for a `Talker`, and a `Talker` in the graph is one import away from someone
   registering the viewer UI that [10.19] forbids. A static helper adds nothing
   to the graph.
2. `SupabaseIgdbClient` dispatches calls; deciding whether to log, building the
   entry, and trimming the body are a different job. Keeping them apart is the
   difference between a nine-line `invoke` and a thirty-line one.
3. The one piece of real logic — the 50-line trim — becomes directly unit
   testable without instantiating the client or mocking Supabase.

Public surface, all static, all returning `void`:

- `request({required String endpoint, required String query})` — one info entry
  carrying both values, called before dispatch. [10.15]
- `response(Object? body)` — one info entry carrying `trimToLineCap(body)`.
  [10.16]
- `failure(Object error, StackTrace stackTrace)` — one error entry carrying the
  error and the untrimmed stack trace, via `Talker.error(msg, error, stack)`.
  [10.17]
- `trimToLineCap(Object? body)` → `String`, marked `@visibleForTesting` — public
  only so the cap can be tested; nothing outside the file and its test calls it.

Levels follow `tech-ac.md ## Assumptions`: request and successful response at
info, failure at error, so failures stay filterable in console output.

### How the gate reads the flavour and the build mode

`static bool get _isOn => kDebugMode && FlavorConfig.instanceOrNull?.flavor ==
Flavor.dev;`, evaluated inside every entry point, so it is per call as [10.18]
requires rather than cached at startup.

`kDebugMode` is a compile-time constant, so in a release build the whole branch —
and with it every `Talker` reference — is dropped by the tree shaker. That is why
the gate is written debug-first.

Reading the flavour statically rather than injecting it follows an existing
precedent in this exact folder: `SupabaseConnectionChecker` already does
`FlavorConfig.instance.flavor` with no constructor dependency. The Sentry half's
route (`bootstrap` passes its `Flavor` parameter down) is not available here,
because the client is built by DI and called long after startup.

### `FlavorConfig.instanceOrNull` — `lib/config/flavor/flavor_config.dart` (modify)

One added getter: `static FlavorConfig? get instanceOrNull => _instance;`.
`instance` and its `StateError` are untouched, and no existing caller changes.

It is needed because `FlavorConfig.instance` throws when startup has not run —
which is exactly the state of every unit test, including the existing
`test/api/supabase/supabase_igdb_client_test.dart`. Calling `instance` from
`invoke` would turn three passing tests into three errors and fail [10.21]
outright. The nullable accessor makes "the flavour cannot be resolved, so log
nothing and carry on" a plain `null` check, which is [10.18]'s failure case
stated in code.

Alternative considered and rejected: wrapping `FlavorConfig.instance` in a
`try`/`catch` inside `IgdbCallLog`. It needs no shared-file edit, but it makes a
normal condition (not started yet) look like an error, and it hides a real
`StateError` from a genuinely broken startup behind the same catch. One added
getter is smaller and honest.

### Keeping logging out of the caller's way

Every entry point routes through one private `_write(void Function() entry)` that
returns early when the gate is off and otherwise runs the closure inside a
`try`/`catch` that swallows. That is [10.15]'s failure case for all three entries
at once: a log that throws never reaches the caller and never stops the call.

The `Talker` instance is a private `static final` in the same file, created with
`TalkerSettings(useHistory: false)`. Lazy static initialisation means it is never
constructed in a build where the gate never opens. History is off because the
only consumer is the console — nothing should hold response bodies in memory when
no screen can ever display them, which is [10.19] enforced at the source rather
than by omission.

`talker_flutter` is imported, not `talker`. `talker_flutter` re-exports the whole
of `package:talker/talker.dart`, and it is the `direct main` dependency —
importing `package:talker/talker.dart` directly would be a transitive import and
a new `depend_on_referenced_packages` diagnostic against the [10.26] baseline. No
package is added.

### The 50-line trim

`trimToLineCap` renders the body with `'$body'`, splits on `\n`, and:

- `lines.length <= cap` → returns the text unchanged, with no marker. [10.16]'s
  failure case is explicit that a complete log must never look truncated, so the
  marker is attached only on the cut path.
- otherwise → first `cap` lines joined, then one final line naming both numbers,
  e.g. `[cut short: showing 50 of 812 lines]`.

The cap lives in `SupabaseIgdbProxyConstants.maxLogBodyLines`. No formatter or
JSON-pretty-printing package is involved; a body is whatever `toString` gives,
which is what `tech-ac.md`'s "a newline-separated line of the rendered response
body" assumption describes.

Trimming is applied in `response` only. `failure` passes the error and stack
straight through — [10.17] fails if the cap touches either.

### `SupabaseIgdbClient.invoke` — `lib/core/services/supabase/supabase_igdb_client.dart` (modify)

The method keeps its name, its two named required parameters, its
`Future<Object?>` return and its `@injectable` `const` constructor. The body gains
exactly three things: a `request` call before dispatch, a `response` call on the
returned data, and a `try`/`catch (error, stackTrace)` that calls `failure` and
then `rethrow`s.

`rethrow` rather than `throw error` is what keeps [10.17]'s "unchanged in type and
message" true, and it preserves the original stack trace for the caller as well as
for the log. The existing `.timeout(...)` stays where it is, inside the `try`, so
a `TimeoutException` is logged by the same path as a transport failure or an edge
function error — the three cases [10.17] names.

No caller changes. The games, game detail and featured API services keep calling
the same method and gain no logging of their own. [10.21]

### Independence from crash reporting — [10.20]

Stated as a design constraint so a reviewer can check it in one place: no
`TalkerObserver` is installed, so no entry can become a Sentry breadcrumb; the
log helper imports nothing from `sentry_flutter`; `CrashReporter` imports nothing
from `talker_flutter`; and neither one's gate reads the other's state. A build
with a placeholder DSN still logs, and a prod release build still reports crashes
while logging nothing.

## `PrettyDioLogger` removal

Three code edits, each purely subtractive, plus one doc edit.

- `lib/core/di/network_module.dart` [10.22] — delete the
  `package:pretty_dio_logger/...` import and the six-line
  `dio.interceptors.add(PrettyDioLogger(...))` statement. The `Dio`, its
  `BaseOptions`, the `TwitchAuthInterceptor` registration, the `return dio`, the
  `@Deprecated` annotation and both comments stay exactly as they are.
- `lib/core/services/api/twitch_auth_interceptor.dart` [10.23] — delete the
  import and the constructor body that registered the logger on `_tokenDio`. The
  initialiser list keeps the same base URL and the same three timeouts; the body
  becomes empty, which is the whole of the change. `_fetchToken`, `onRequest`,
  `onError`, both fake constants, the `@Deprecated` annotation and the comments
  are untouched, and the file stays in the tree and out of DI.
- `pubspec.yaml` [10.24] — delete the single `pretty_dio_logger: ^1.4.0` line
  under `# Logging`. `logger` and `talker_flutter` stay. `pubspec.lock` currently
  records it as `direct main`, so `flutter pub get` should remove the entry
  outright. If it comes back as `transitive`, something else pulls it in: report
  that, do not work around it.

Both code files are `@Deprecated`, registered nowhere and imported by nothing that
runs, which is why [10.26] can claim no observable runtime change from these two
edits. Deleting the files themselves belongs to item 11.

### `.agents/references/flutter-arch.md` [10.25]

Two mentions, and one extra line the human approved separately:

- line 169 — the module's path reads `lib/core/services/api/network_module.dart`;
  the file is at `lib/core/di/network_module.dart`. **This correction is not one
  of `tech-ac.md`'s criteria** — the BA marked it out of scope as unrelated, and
  the human approved fixing it here because it is the same line block as the two
  below. The `@module` wording on the same line is left alone; it is stale too,
  but nobody approved changing it.
- line 170 — drop `+ PrettyDioLogger` from the sentence about what the singleton
  `Dio` is provided with.
- line 181 — delete the whole `Logging: PrettyDioLogger (request header + body).`
  line. Rewriting it is not an option: after this run the Dio path has no logging
  at all, and [10.25] fails a line describing logging the code does not have. The
  new `IgdbCallLog` is deliberately not documented in its place — it logs the
  Supabase edge-function path, not the Dio path, and documenting it there would
  reintroduce exactly the mismatch this criterion is fixing.

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
- `talker_flutter` at `pubspec.yaml` — already a `direct main` dependency and
  already the logger `dart-style.md` names. It re-exports `Talker`, so the added
  scope needs no package. [10.24] removes one and adds none.
- `SupabaseConnectionChecker`'s static `FlavorConfig.instance.flavor` read — the
  precedent for a core service knowing the flavour without a constructor
  dependency, which is what [10.18]'s gate needs.
- `SupabaseIgdbClient.invoke` — reused as the single choke point for [10.15]-
  [10.17]; instrumenting it is what lets [10.21] leave all three caller services
  untouched.

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
- `talker_flutter`'s viewer half — `TalkerScreen`, `TalkerWrapper`,
  `TalkerRouteObserver`, `TalkerListener` and any route to them. Not imported
  anywhere.
- Logging on any other path — Supabase auth, storage, the tracker repository and
  direct `SupabaseClient` calls. Only `SupabaseIgdbClient.invoke` is instrumented.
- Log persistence, file/remote export, configurable log levels, and scrubbing of
  log content. Console only, dev only, debug only.
- Migrating existing `debugPrint`/`logger` calls to `talker`, and any change to
  the `logger` or `talker_flutter` dependency entries.
- Deleting `NetworkModule` or `TwitchAuthInterceptor`, and touching `dio`,
  `retrofit` or any other Dio wiring beyond the one interceptor removal. That is
  item 11.
- Any other edit to `flutter-arch.md` beyond the two `PrettyDioLogger` mentions
  and the one human-approved path correction named above — including the stale
  `@module` wording on the same line.

## Open questions

NONE.

## New dependencies — flagged for the Phase 3 human gate

This design adds two packages to `pubspec.yaml` and removes one. Rationale is in
`task-brief.md ## New dependencies`; it is repeated at the top of `code-plan.md`
so it cannot be missed at the gate. The added logging scope needs no package —
`talker_flutter` is already a direct dependency — and [10.24] deletes
`pretty_dio_logger`, so the net change is +2 / -1.

# Ambiguities Report
Source: `.agents/week-1-task-briefs.md` §10.1 — IGDB client transport: Dio + Retrofit
Date: 2026-08-07

## CRITICAL (pipeline blocked — requires human decision before proceeding)
NONE

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: "Public signature stays unchanged" is read as the `invoke({required
String endpoint, required String query}) -> Future<Object?>` method only. The
constructor's injected dependency may change (it must, since the transport
changes). Justified because the three callers depend on `invoke` and their tests
mock `SupabaseIgdbClient` itself, so a constructor change reaches only DI
registration and the client's own test file.

ASSUMPTION: When there is no Supabase session, the interceptor sends the anon key
as the bearer token rather than omitting the header or failing locally. This
preserves today's behaviour exactly — `functions.invoke` already falls back to
`auth.currentSession?.accessToken ?? <anon key>` (`supabase-2.14.0`
`supabase_client.dart:373`), and the anon key is itself a valid JWT, so
`verify_jwt` accepts it. Omitting the header would be a regression, not a
no-change swap. Note this is a rare path anyway: every screen that can trigger an
IGDB call sits behind `AuthGuard`.

ASSUMPTION: The exact `ErrorType` variant produced by a timeout is allowed to
change. Today the client wraps the call in `.timeout(30s)`, which throws
`TimeoutException` and lands in `BaseRepositoryMixin`'s bare `catch (_)` as
`ErrorType.unknown()`. Under Dio the same condition arrives as a `DioException`
of type `connectionTimeout`/`receiveTimeout` and maps to
`ErrorType.connectionTimeout()`/`receiveTimeout()`. Accepted as an improvement,
not a regression: no widget or bloc branches on which variant it is. What must
not change is that the call fails within the timeout instead of hanging and
surfaces as a `Failure`.

ASSUMPTION: For a non-2xx response, the proxy's `{"error": "..."}` body will land
in `ResponseError.error` instead of `ResponseError.message`, because
`ErrorType.dioError` reads `data['error']` into `error` while
`ErrorType.supabaseIgdbError` read it into `message`. The HTTP status code is
preserved on both paths. Accepted because nothing in the UI reads either field —
error states render generic copy. `ErrorType` and `BaseRepositoryMixin` are not
to be edited to "fix" this.

ASSUMPTION: `IgdbCallLog` is kept, and its behaviour (not its implementation) is
what the criteria pin. `TalkerDioLogger` is not adopted in this run. Findings
behind this, for the Tech Lead to confirm or overturn:
  - `talker_dio_logger` is **not a dependency** — it is absent from both
    `pubspec.yaml` and `pubspec.lock`. Only `talker_flutter` (direct) and
    `talker`/`talker_logger` (transitive) are present. Adopting it means adding a
    package, and `.claude/pipeline/rules/execution.md` makes `pubspec.yaml`
    read-only for the pipeline. That alone needs a deviation approval.
  - Feature gap 1: `TalkerDioLoggerSettings` offers whole-response filtering
    (`responseFilter`) and on/off toggles for body/headers, but no line-count
    truncation. The 50-line cap plus the explicit `[cut short: showing 50 of N
    lines]` note is not available out of the box.
  - Feature gap 2: `IgdbCallLog.failure` logs the caller's own `StackTrace`.
    A Dio interceptor only ever sees the `DioException`'s stack trace, which
    starts inside Dio, not at the call site.
  - Feature gap 3: `IgdbCallLog` self-gates on `kDebugMode && flavour == dev` on
    every call and swallows its own failures so a broken log can never fail an
    IGDB request. Both would have to be rebuilt around the interceptor.
  So it is not a 1:1 drop-in. Criterion 10.1-AC-16 states the logging behaviour
  in implementation-neutral terms — if the Tech Lead does secure approval for the
  package, that criterion is still the bar it must clear.

ASSUMPTION: The `SupabaseIgdbClient` unit test
(`test/api/supabase/supabase_igdb_client_test.dart`) is expected to be rewritten
— it mocks `FunctionsClient` directly and cannot survive a transport change. The
brief's "existing tests keep passing" is read as applying to the *callers'* tests
(`games_test.dart`, `game_detail_test.dart`, featured repository tests), which
mock `SupabaseIgdbClient` and are transport-agnostic.

ASSUMPTION: One Retrofit interface covering the single POST to `igdb-proxy` is
what "a Retrofit interface for the one endpoint it calls" means — `endpoint` and
`query` stay fields of the JSON body, not path or query parameters, because the
Edge Function reads them from the body.

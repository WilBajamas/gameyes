# Diff Summary
Source: `.agents/week-1-task-briefs.md` §10.1 — IGDB client transport: Dio + Retrofit
Date: 2026-08-07
Branch: claude/questloggd-item-10-1-igdb-ogvf5r
Commit: 5385338

## Files created
lib/core/services/supabase/supabase_igdb_proxy_service.dart — Retrofit interface `SupabaseIgdbProxyService`, one `@POST` to `SupabaseIgdbProxyConstants.functionPath`
lib/core/services/supabase/supabase_igdb_proxy_service.g.dart — generated Retrofit implementation
lib/core/services/supabase/igdb_proxy_auth_interceptor.dart — `IgdbProxyAuthInterceptor`: sets `Authorization`/`apikey` per request, refreshes and replays once on 401
lib/core/di/igdb_proxy_module.dart — `@module` building the igdb-proxy Dio (flavour baseUrl, shared timeouts, auth interceptor, `TalkerDioLogger` gated to debug+dev) and providing `SupabaseIgdbProxyService`

## Files modified
pubspec.yaml — added `talker_dio_logger: ^5.1.16` under `# Logging` (approved deviation)
pubspec.lock — updated by `flutter pub get`, adds `talker_dio_logger 5.1.20` only
lib/core/res/const.dart — `SupabaseIgdbProxyConstants`: `functionName` → `functionPath` (`'/igdb-proxy'`), added `functionsBasePath`, removed `requestTimeout` and `maxLogBodyLines`
lib/features/games/services/games_api_service.dart — `SupabaseIgdbClient _client` → `SupabaseIgdbProxyService _proxy`, one call site updated
lib/features/game_detail/services/game_detail_api_service.dart — same shape change, one call site
lib/features/featured/services/featured_api_service.dart — same shape change, one call site
lib/core/di/service_locator.config.dart — regenerated: `SupabaseIgdbClient` entry gone, three services now take `SupabaseIgdbProxyService`
test/mocks/auth_mock.dart — added `mockRefreshedDiscordSession` getter
test/mocks/error_mock.dart — added `mockDioException` getter (502 bad response, same error body as `mockFunctionException`) and `dio` import; `mockFunctionException` untouched
test/api/games/games_test.dart — mocks `SupabaseIgdbProxyService` instead of `SupabaseIgdbClient`; map-form `invoke` calls; error-propagation test renamed and now throws/asserts `DioException`
test/api/games/games_test.mocks.dart — regenerated
test/api/game_detail/game_detail_test.dart — same set of changes as games_test.dart
test/api/game_detail/game_detail_test.mocks.dart — regenerated

## Files deleted
lib/core/services/supabase/supabase_igdb_client.dart — one-line passthrough, callers now depend on `SupabaseIgdbProxyService` directly
lib/core/services/supabase/igdb_call_log.dart — replaced by `TalkerDioLogger`
test/api/supabase/supabase_igdb_client_test.dart — coverage moved to `test/api/supabase/supabase_igdb_proxy_service_test.dart`
test/api/supabase/supabase_igdb_client_test.mocks.dart — orphaned generated output
test/api/supabase/igdb_call_log_test.dart — tested a deleted class, not ported

## Test files
test/api/supabase/supabase_igdb_proxy_service_test.dart — request target/body/content-type, no-IGDB-host, decoded 200 body, 400 and 502 propagation (7 tests)
test/api/supabase/igdb_proxy_auth_interceptor_test.dart — both headers, token freshness, anon-key fallback, 401 refresh+replay, exactly-two-requests on repeat 401, refresh throws/no-session, no retry on 502 or connection error (9 tests)
test/api/games/games_test.dart — updated in place (see Files modified)
test/api/game_detail/game_detail_test.dart — updated in place (see Files modified)
(No test added for `FeaturedApiService` or for the logger, per task-brief.)

## Self-corrections
File: test/api/supabase/igdb_proxy_auth_interceptor_test.dart — Error: `ambiguous_import` on `Headers` (dio vs. supabase_flutter/postgrest) surfaced by `flutter analyze` on both this file and `lib/core/di/igdb_proxy_module.dart` — Fix: added `hide Headers` to the `supabase_flutter` import in both files — Attempts: 1
File: test/api/supabase/igdb_proxy_auth_interceptor_test.dart — Error: "should refresh and try again once when the proxy answers 401" asserted the replayed request's Authorization header but the mocked `auth.currentSession` never changed after `refreshSession()`, so the interceptor correctly kept sending the old token — Fix: rewrote the stub so `currentSession` reads a mutable variable that `refreshSession()` updates, matching a real session refresh — Attempts: 1

## Deviations from implementation plan
NONE — plan followed exactly, including all four `code-plan.md` approved feedback deltas.

## Verification against baseline
`flutter pub get` — resolved cleanly, only `talker_dio_logger 5.1.20` added, no other dependency changed.
`dart run build_runner build --delete-conflicting-outputs` — ran twice (after annotated sources, then after test files), no unresolved errors.
`flutter analyze` — 0 errors, 2 warnings, 32 info. Matches baseline exactly.
`flutter test` — 218 passed, 11 failed. All 11 failures are the pre-existing ones named in `orchestrator-state.md` (tracker_repository_test.dart ×4, game_detail_cubit_test.dart ×3, games_bloc_test.dart ×3, widget_test.dart ×1). Total test count (229) reconciles with baseline: 220 baseline − 7 removed with the two deleted test files (igdb_call_log_test.dart 4, supabase_igdb_client_test.dart 3) + 16 new (7 in supabase_igdb_proxy_service_test.dart, 9 in igdb_proxy_auth_interceptor_test.dart) = 229.

## Acceptance criteria status
10.1-AC-1: satisfied
10.1-AC-2: satisfied
10.1-AC-3: satisfied
10.1-AC-4: satisfied
10.1-AC-5: satisfied
10.1-AC-6: satisfied
10.1-AC-7: satisfied
10.1-AC-8: satisfied
10.1-AC-9: satisfied
10.1-AC-10: satisfied
10.1-AC-11: satisfied
10.1-AC-12: satisfied
10.1-AC-13: satisfied
10.1-AC-14: satisfied — read per Phase 3 delta, one layer up from the deleted class (see task-brief.md)
10.1-AC-15: satisfied — "no edits" clause void per Phase 3 delta; behaviour unchanged
10.1-AC-16: satisfied to the extent `TalkerDioLogger`'s defaults allow — accepted loss of the 50-line trim and caller stack trace, per approved deviation
10.1-AC-17: satisfied — logger registration gated to `kDebugMode && Flavor.dev`
10.1-AC-18: satisfied where the gate is closed; rests on `TalkerDioLogger` itself where it's open, per approved deviation
10.1-AC-19: satisfied — `NetworkModule`/`TwitchAuthInterceptor` untouched
10.1-AC-20: satisfied — nothing under `supabase/` touched
10.1-AC-21: satisfied
10.1-AC-22: not applicable — superseded, trim no longer exists (human-approved)
10.1-AC-23: not met — overturned, human-approved; `games_test.dart`/`game_detail_test.dart` edited as directed
10.1-AC-24: satisfied — analyzer and test baselines held, only the expected 7-test drop from deletions plus 16 new tests

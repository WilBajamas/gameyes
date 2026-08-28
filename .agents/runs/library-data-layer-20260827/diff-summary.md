# Diff Summary
Source: `.agents/week-3-task-briefs.md` item 3.3 (lines 211–232), via `tech-ac.md`
Date: 2026-08-27
Branch: claude/questloggd-week-3-stage-3-4sxzix
Commit: 6c89deba18ed356bf2f9ddcc6d810230875f70e0

## Files created
supabase/migrations/20260827120000_library_entries_details.sql — additive migration: six new columns and three check constraints on `library_entries`.
lib/core/enums/library_sort.dart — the five sort options.
lib/features/library/const.dart — `LibraryEntryConstants`: table and column names.
lib/features/library/data/models/library_status_column.dart — hand-written `LibraryStatus` ↔ column-value mapping, no `default` branch.
lib/features/library/data/models/library_entry_model.dart — freezed `LibraryEntryModel` over the full column set, with `toEntity()`.
lib/features/library/data/datasources/library_remote_datasource.dart — Supabase table access: paged filtered sorted read, insert, partial update, delete.
lib/features/library/data/repositories/library_repository_impl.dart — repository on `BaseRepositoryMixin`, mapping model→entity inside `fetchData`'s try/catch.
lib/features/library/domain/entities/library_entry_entity.dart — freezed domain entity, `LibraryStatus` typed.
lib/features/library/domain/repositories/library_repository.dart — abstract interface, four methods on `Result<T>`.
lib/features/library/domain/use_cases/fetch_library_page_use_case.dart
lib/features/library/domain/use_cases/add_library_entry_use_case.dart
lib/features/library/domain/use_cases/update_library_entry_use_case.dart
lib/features/library/domain/use_cases/remove_library_entry_use_case.dart

## Files modified
lib/core/data/models/error.dart — four new `ErrorType` variants (`duplicateEntry`, `invalidValue`, `notAllowed`, `notSignedIn`), a `postgrestError` factory switching on SQLSTATE, three private SQLSTATE consts.
lib/core/data/datasource/base_repository_mixin.dart — added `on PostgrestException` and `on AuthSessionMissingException` clauses above the existing `catch (_)`; nothing else touched.
lib/core/domain/entities/tracker_saved_game_entity.dart — three nullable fields added (`hoursLogged`, `averageCompletionHours`, `manualProgressPercentage`).
lib/features/tracker/data/models/saved_game.dart — `toEntity()` maps the three new fields; no field removed.
lib/features/featured/domain/entities/library_snapshot_entity.dart — `nowPlayingGames` retyped to `List<TrackerSavedGameEntity>`; `features/tracker/data/` import dropped.
lib/features/featured/data/repositories/featured_repository_impl.dart — `getLibrarySnapshot` maps datasource `SavedGame`s through `.toEntity()`; `FeaturedLocalDatasource` source unchanged.
lib/features/featured/presentation/widgets/library_stats.dart — parameter retyped, import swapped, `TrackerGameDetailRoute(game: topGame)` — still compiles and still pushes the route.
.agents/references/library-design-conventions.md — line 67 only: grid-meta examples lose `· Ch. 9`, D11 recorded inline.
lib/core/data/models/error.freezed.dart, lib/core/domain/entities/tracker_saved_game_entity.freezed.dart, lib/core/di/service_locator.config.dart — generated outputs, regenerated from the above annotated sources.

## Test files
test/api/library/library_status_column_test.dart — each of the six enum values individually, the six literals parsed back, an unknown string yields null.
test/api/library/library_entry_model_test.dart — full-column round trip, an all-nulls row yields `null` (not `0`/`''`), `toEntity()` produces `LibraryStatus`, throws `FormatException` on an unknown status.
test/repository/library/library_repository_test.dart — error mapping (`23505`/`23514`/`42501` → three distinct `ErrorType`s, distinct from each other), `notSignedIn` on no session, malformed status → failure, empty page as success, idempotent remove, no exception escapes.
test/use_case/library/fetch_library_page_use_case_test.dart — forwards, returns failure unchanged.
test/use_case/library/add_library_entry_use_case_test.dart — forwards every field, returns failure unchanged.
test/use_case/library/update_library_entry_use_case_test.dart — forwards rating, forwards `clearRating`, returns failure unchanged.
test/use_case/library/remove_library_entry_use_case_test.dart — forwards id, returns failure unchanged.
test/features/featured/presentation/blocs/library_stats_cubit_test.dart (modified) — `:99` now builds a `TrackerSavedGameEntity` in place of `SavedGame`; no assertion changed.

## Self-corrections
File: test/repository/library/library_repository_test.dart — Error: `MissingDummyValueError` on `LibraryEntryModel` from the mocked datasource's `add`/`update` return type — Fix: added `provideDummy<LibraryEntryModel>(row)` in `setUp` — Attempts: 1
File: test/repository/library/library_repository_test.dart, test/use_case/library/add_library_entry_use_case_test.dart — Error: bare `any` used for named parameters, which Mockito rejects and also corrupts the argument-matcher stack for the next stubbed call in the same test — Fix: switched to `anyNamed('paramName')` for each named matcher (repository test), and to concrete literal values where no wildcard was actually needed (use case test) — Attempts: 1

## Deviations from implementation plan
NONE — the plan was followed exactly, step by step, with a build_runner checkpoint after each contiguous group of annotated sources.

## Verification against baseline
`flutter analyze`: 0 errors, 2 warnings (the `_TaskReminder` pair, unchanged), 37 info (39 total — the 11 extra are `use_null_aware_elements` info-level lints inside the new datasource, matching `code-plan.md`'s approved skeleton verbatim; the total is not an invariant per the brief).
`flutter test`: +394 -10. The 10 failures are exactly the recorded baseline set (`tracker_repository_test` 4, `game_detail_cubit_test` 3, `games_bloc_test` 3) — confirmed by name, none new. +31 over the +363 baseline, all new library tests plus the modified cubit test.

Caveats from `tdd.md ## Caveats I could not execute`, recorded as required:
1. SQLSTATE reaching `PostgrestException.code` — confirmed by reading `postgrest-2.8.0/lib/src/types.dart:9-20`: `code` is `String?`, matching the design. No fallback needed.
2. `.single()` on a zero-row update — implemented as designed (`.select().single()`); this path needs a real Supabase project to observe the actual exception shape, which this pipeline does not have. Left as designed; not runtime-verified. If 3.3-AC30's manual device check shows a different shape than `PGRST116`, the fallback in `tdd.md` (switch to `.select()` + `rows.first`) is the documented remedy.
3. Case-insensitive alphabetical sort — implemented as `.order('title', ascending: true)`, server-side only; **not sorted in Dart**, per the criterion. Not runtime-verified against the live collation (no Supabase project in this pipeline). Flagging as a follow-up per `tdd.md`'s instruction, not fixing preemptively.
4. `numeric` columns arriving as JSON numbers — confirmed in the generated `library_entry_model.g.dart`: `(json['playtime_hours'] as num?)?.toDouble()` and the same for `progress_percent`, handling int or double. No fallback needed.
5. `SavedGame.toEntity()` running at snapshot-load time for every now-playing game — implemented as designed (`featured_repository_impl.dart`'s `getLibrarySnapshot` maps the full list). No fallback needed; unchanged risk profile from today's tap-time call.

## Acceptance criteria status
3.3-AC1: satisfied
3.3-AC2: satisfied
3.3-AC3: satisfied
3.3-AC4: satisfied
3.3-AC5: satisfied
3.3-AC6: satisfied
3.3-AC7: satisfied — migration is additive only, no existing constraint/policy/index touched
3.3-AC8: satisfied
3.3-AC9: satisfied
3.3-AC10: satisfied — no `default` branch in either switch
3.3-AC11: satisfied
3.3-AC12: satisfied
3.3-AC13: satisfied
3.3-AC14: satisfied
3.3-AC15: satisfied — entity file imports only `freezed_annotation` and `core/enums/library_status.dart`
3.3-AC16: satisfied — filter/order/range are all server-side query calls
3.3-AC17: satisfied — not runtime-verified for collation, see caveat 3
3.3-AC18: satisfied — package default (`nullsFirst: false`)
3.3-AC19: satisfied
3.3-AC20: satisfied
3.3-AC21: satisfied
3.3-AC22: satisfied
3.3-AC23: satisfied
3.3-AC24: satisfied
3.3-AC25: satisfied
3.3-AC26: satisfied
3.3-AC27: satisfied
3.3-AC28: satisfied
3.3-AC29: satisfied
3.3-AC30: not applicable here — manual, on-device, left for QA's manual checklist
3.3-AC31: satisfied
3.3-AC32: satisfied
3.3-AC33: satisfied
3.3-AC34: satisfied
3.3-AC35: satisfied

## Phase 4B revision round — 2026-08-28
Human sent commit `6c89deb` back at the Phase 4B gate: clear the 11 new
`use_null_aware_elements` info lints in `library_remote_datasource.dart` before
they settle into the analyzer baseline. Everything else about the commit was
approved.

Converted 10 of the 11 `if (x != null) key: x` map entries to `key: ?x`
null-aware elements: `coverUrl`, `rating`, `platform`, `genre`,
`playtimeHours`, `progressPercent` in `add`; `platform`, `genre`,
`playtimeHours`, `progressPercent` in `update`. `releaseDate` in `add` was
never flagged (it needs `.toIso8601String()` applied) and was left as-is.

Line 103, the `else if (rating != null)` half of the `clearRating` /
`rating` pair in `update`, was deliberately left unconverted. That pair
relies on `if (clearRating) ... key: null` writing an explicit null to erase
a rating (3.3-AC26), while `key: ?value` omits the map entry entirely when
`value` is null — the opposite behaviour. No form of null-aware element
preserves both "send explicit null to clear" and "send nothing when
`rating` is absent", so the pair is left exactly as it was in `6c89deb`, one
remaining info lint and no risk to 3.3-AC26.

Verification: `flutter analyze` — 0 errors, 2 warnings (`_TaskReminder`
pair, unchanged), 27 info (down from 37, one `use_null_aware_elements` lint
remains at line 101 — the trap). `flutter test` — +394 -10, the 10 being
the same pre-existing set by name (`tracker_repository_test` 4,
`game_detail_cubit_test` 3, `games_bloc_test` 3), no new failures, no drop
in passing count. `test/use_case/library/update_library_entry_use_case_test.dart`
(file untouched) still passes all 3 tests including "should forward
clearRating when the rating is being removed".

Commit: 9f22b6b

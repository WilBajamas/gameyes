# Orchestrator State
Feature: Item 3.4a — `LibraryBloc`, preferences, counts and search (split from 3.4 by D16; the Featured repair is 3.4b)
Run ID: library-bloc-preferences-20260827
Run folder: .agents/runs/library-bloc-preferences-20260827/
Started: 2026-08-27
Current phase: QA
QA cycles used: 0
Analyzer baseline: 0 errors, 2 warnings, 27 info (29 total) — captured 2026-08-27T18:45:00Z
Test baseline: +394 -10 — captured 2026-08-27T18:47:00Z
Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart (4), test/cubit/game_detail/game_detail_cubit_test.dart (3), test/cubit/games/games_bloc_test.dart (3)
Branch: feature/library-bloc-preferences
Base branch: develop
Base SHA: 618bed1
Dev commit: 7d87dcc
Last updated: 2026-08-27T18:50:00Z

## Phase 0 notes

Branch cut fresh from `develop` at the human's instruction, rather than continuing
on the harness session branch. Item 3.3 was merged to `develop` at `618bed1` (a
`--no-ff` merge, so the item has a real marker in history rather than vanishing
into a fast-forward as items 3.1 and 3.2 did).

**Baselines verified on the untouched tree, not inherited.** They moved with 3.3
and both numbers are new:
- Analyzer **29 issues — 0 errors, 2 warnings, 27 info** (was 28 before 3.3).
- Suite **+394 -10** (was +363 -10). Same ten pre-existing failures by name.

**The 2 warnings are the invariant.** The deliberate `_TaskReminder` pair at
`task_detail_screen.dart:201` and `:204`. The *total* is not an invariant and has
now moved three times this week — 30 → 28 → 29. A run that reports a different
total has probably just added or deleted files; check the warnings, then find out
why, rather than assuming either breakage or safety.

**One info lint is a deliberate, human-approved survivor**:
`use_null_aware_elements` at `library_remote_datasource.dart:101`. It is the
`else if (rating != null)` half of the `clearRating` pair, and converting it to
`key: ?value` would break 3.3-AC26 — `clearRating` must write an *explicit* null,
while the null-aware form omits the entry. **Do not "fix" it.**

## What item 3.3 handed over

- `LibraryRepository` with four use cases (fetch page, add, update, remove) on
  `Result<T>`, `LibraryEntryEntity`, `LibraryEntryModel`, `LibraryStatus` ↔ column
  mapping, and `LibrarySort` (five options).
- `library_entries` now carries `platform`, `rating`, `playtime_hours`,
  `progress_percent`, `genre` and `updated_at`.
- `ErrorType` gained `duplicateEntry`, `invalidValue`, `notAllowed` and
  `notSignedIn`, mapped off SQLSTATE `23505`/`23514`/`42501` in
  `BaseRepositoryMixin`. Callers can now tell an RLS denial from a constraint
  violation from a unique conflict.
- `LibrarySnapshotEntity` no longer holds an Isar `SavedGame`; it holds
  `TrackerSavedGameEntity`. ~~`library_stats.dart:317` still pushes
  `TrackerGameDetailRoute`, which is the sole surviving entry point into the
  dormant tracker tree and must keep working.~~ **Struck by D14 below — that push
  is removed in this item and the route keeps no caller.** The `TrackerSavedGameEntity`
  retype itself still stands.

## Two things 3.3 deliberately did not do — this item must claim them

1. **Counts.** Nothing anywhere provides a count capability. §3's status chip
   counts and §8's `Showing 12 out of 312` cannot be served by any of 3.3's four
   use cases, and the Tech Lead declined to smuggle in a fifth. This item's BA
   will hit a spec line it cannot satisfy unless the brief claims it.
2. **A datasource test.** No test constructs a real `LibraryRemoteDatasource` —
   the repository test mocks it and the use case tests mock the repository above
   it. Eight of 3.3's criteria (AC16–AC25) rest on code inspection alone, and the
   `clearRating` behaviour has no automated guard at all. QA recommended a
   datasource test against a fake `SupabaseClient`; worth folding in here.

## Carried decisions that still bind

- **D9** — one status vocabulary, no wishlist boolean. This item's Featured repair
  must therefore repoint `getWishlistedGames()` at `status = 'wishlist'`; there is
  no successor to `isWishlisted`.
- **D10** — `rating` is the user's own nullable 1–10 integer. The input control is
  item 4.6's, not this one's.
- **D12** — Supabase is the source of truth. The Isar read cache, the IGDB refresh
  system and task-tree backup are **later items**, not this one. Do not pull them in.
- The tracker task tree is dormant by human decision and must not be cleaned up.

## Human decisions

**D14 — every now-playing tap goes to the Library tab. Resolves CRITICAL-1, option B.**
The single-game branch stops pushing `TrackerGameDetailRoute`; both branches now
call `setActiveIndex(1)`, so the destination no longer depends on how many games
are playing. The whole playing slice renders on the card, so the reported bug is
**fully** fixed rather than half fixed.
The reason the obvious fix was unavailable: that screen looks its game up by **Isar
row id**, which a Supabase library entry cannot supply. A placeholder id crashes on
`tracker_game_detail_section.dart:27`'s unguarded `state.game!`; a colliding
autoincrement id would send `TrackerDetailCubit.setPlatform` into a **different
game's row**. Neither is acceptable, and the real fix — re-keying the tracker tree
onto `igdb_id` — is reserved for a design convention that has not landed.
**What this costs, stated plainly:** the tracker task tree becomes **fully
unreachable**. It was previously reachable from exactly one place, and this removes
it. Two standing rules said it must keep that entry point; the human overrode them
deliberately and authorised the doc amendments, which are done:
- `handover.md` — the "Known non-blocking gaps" reminder, with the superseded
  sentence **struck rather than deleted**, per the week's own lesson that a
  reversed ruling read as live guidance for most of a day.
- `week-3-task-briefs.md` — the "What week 3 does NOT touch" section, same treatment.
**The rule that did NOT change: do not delete the tracker tree.**
`tracker_game_detail_screen.dart`, `task_detail_screen.dart`, `TaskCubit`,
`GroupTask`, `SavedGameTask` and `TaskStep` all stay, compiling and passing their
tests, until the convention lands. Unreachable is not the same as unwanted.
Also retires **3.3-AC32**, which pinned `library_stats.dart` still pushing that
route. That criterion belongs to a run already merged and closed, so nothing
re-gates on it — but a later reader comparing the two items would otherwise see a
contradiction.
Watch for at Dev: removing the last push may orphan the route registration and
produce new info-level lints. That is expected, not breakage. The **2-warning**
invariant is unaffected — `_TaskReminder` lives in `task_detail_screen.dart`, which
survives.

**D16 — item 3.4 is split in two, at the Featured seam. This run is 3.4a.**
Resolves the Tech Lead's step-ceiling escalation, option A. The plan needed 26
non-generation steps against a ceiling of 20, across 26 source and 10 test files.
- **3.4a (this run)** — `LibraryBloc`, preferences, counts, search, datasource test.
  ~19 steps. Criteria 3.4-AC1–AC25 and AC37–AC41.
- **3.4b (a later run)** — the Featured repair. ~9 steps. Criteria 3.4-AC26–AC36.
The dependency runs **one way only**: 3.4b needs 3.4a's `fetchCounts` and
`fetchAllEntries`, so 3.4a lands first. `tdd.md` and `code-plan.md` already cover
both halves and are reused unchanged — only `task-brief.md`'s plan re-cuts, so the
split costs almost nothing.
Why this over a deviation approval: **the two halves fail differently.** 3.4b's
whole value is one observable outcome — a shelf that has never once rendered with
data finally rendering — plus an on-device check, and burying that behind nineteen
steps of substrate is how it ends up verified by inspection rather than by looking.
3.4a's risk is concentrated somewhere else entirely: renaming a live
`SharedPreferences` key. One Dev pass carrying a 3-attempt self-correction budget
across PostgREST query building, a preferences key rename **and** a Supabase-for-Isar
swap in Featured is the shape long passes historically fail in.
`tech-ac.md` is **not** re-cut — it stays whole at 41 criteria, and each half's QA
scopes to its own range. D14's guardrail (3.4-AC32, the six tracker artefacts still
present and compiling) belongs to 3.4b.

**D15 — `countSavedGames()` and `getOwnedGameIds()` repoint at `library_entries`.**
Resolves CRITICAL-2. Without this, one row of stat tiles reads two different stores
and a user who added games only through the Library sees `Total Games 0` beside
`Wishlist 3`, with no owned marks on Featured. The count capability this item must
build already serves the first of the two directly.

**D17 — seven Phase 3 revisions from the human's code-plan review.**
The gate found four real defects, three of which would have shipped. Four of the
seven move or reverse a criterion, so this routes **BA → Tech Lead**, not Tech Lead
alone — the standing lesson is that a criterion left standing with no matching change
is an automatic QA FAIL and a burned cycle.

1. **Separate `LibraryPreferencesDatasource`; `TrackerPreferencesDatasource` is not
   renamed and not touched.** Reverses the shared-`AppPreferencesDatasource` design.
   **Changes 3.4-AC22**, whose whole premise is "the renamed preferences datasource".
   The new shape is strictly safer: an untouched class cannot disturb the live
   `tracker_sort_tag` key, which was AC22's stated failure case.
2. **`_buildNowPlayingCard` becomes a `StatelessWidget`, not a helper method returning
   a Widget.** A method cannot be `const` and rebuilds with its parent. **This is
   3.4b's file** (`library_stats.dart`) — recorded here as binding on that run, not
   pulled into 3.4a.
3. **Comment the parallel-call idiom.** `final pageCall = ...` before `await` starts
   both requests concurrently; awaiting each directly would serialise them. Correct as
   written, but nothing says so. Plain English, no jargon.
4. **`_pattern` moves out of the datasource** to `lib/core/utils/postgrest_utils.dart`
   as a public `postgrestLikePattern(String term)`, beside `igdb_query_builder.dart`.
   It encodes PostgREST `ilike` escaping, which is query-syntax knowledge rather than
   Library knowledge, and other features will need it.
5. **The search debounce must not clear the list or flash a loader.** Real defect: the
   plan emits `loading` with `entries: []` **before** awaiting the debounce, so every
   keystroke strobes the screen and the debounce saves network calls without saving the
   UI. Wait first, then emit; and keep the previous results visible while a search is
   in flight. **Adds a requirement** — 3.4-AC9 protects entries only during a
   *next-page* append, never during a search.
6. **Declare `stream_transform` and use a named `debounce()` event transformer**,
   replacing the hand-rolled `Future.delayed`. `restartable()` takes no duration, so the
   delay was riding implicitly on its cancellation — it works, but a later edit breaks
   debouncing with no failing test. `stream_transform` is already in the lock file as a
   transitive dependency of `bloc_concurrency`. **`bloc_concurrency` stays** — it
   provides `restartable()`/`droppable()`, which `stream_transform` does not.
7. **A stale next-page response must never append after the query changed.** Real
   defect: the two handlers have separate transformers and cannot see each other, so
   scrolling and then tapping a different status chip appends the *old* status's page 2
   onto the *new* status's list. Visibly wrong games. The entry guard runs before the
   await and cannot catch it.
   Human's rule: a query change cancels the in-flight next-page. **Honest constraint:**
   the Supabase client exposes no request cancellation, so "cancel" means *discard the
   response*. Same visible behaviour. Mechanism: a private `int _queryGeneration` on the
   bloc (not in `LibraryState`, so equality is unaffected), bumped by the query handler,
   captured by the next-page handler before its await and re-checked after. Also fixes
   out-of-order page responses, and is testable in a way that can actually fail.
   **Adds a requirement** — 3.4-AC6 covers only duplicate appends from two next-page
   requests.
8. **`hasReachedEnd` comes from `matchedCount`, not from a short page.** The 40-item
   case costs a wasted third request under the current rule. **Reverses 3.4-AC7**, whose
   mechanism is literally "a page shorter than the requested limit". No new endpoint and
   no extra call is needed: the paged query already returns `page.matchedCount`, because
   PostgREST's count respects filters and ignores range — the same figure §8's
   `Showing 12 out of 312` line needs.

## Escalation history
2026-08-28T10:40:00Z Phase 2 — Tech Lead Agent — the plan needs 26 non-generation
steps against the 20-step ceiling — Resolved: human took option A, the split at the
Featured seam, recorded as D16. This run continues as 3.4a; 3.4b opens its own run
afterwards. Tech Lead re-spawned to re-cut `task-brief.md`.
2026-08-27T19:05:00Z Phase 1 — BA Agent — 2 CRITICAL ambiguities (the now-playing
tap's destination; the split-store stat row) — Resolved: human decisions D14 and
D15 recorded above, 2026-08-27T19:30:00Z. Docs amended. BA re-spawned.

## Deviation approvals
NONE

## Code review outcomes
2026-08-28 Phase 3 gate — approved after one revision round. The human's review of
`code-plan.md` found four real defects, three of which would have shipped; all seven
resulting revisions are recorded as D17 and were routed BA → Tech Lead → Dev, because
four of them moved or reversed a criterion.
2026-08-28 Phase 4B — `7d87dcc` — Reviewed and approved by human. Verified
independently rather than from `diff-summary.md`: no tracker file touched in either
commit (the whole basis of D17.1), `pubspec.lock` exactly the predicted
`transitive` → `direct main` one-liner, `_queryGeneration` present and used at
`:61/:67/:166/:181`, `hasReachedEnd` deriving from `matchedCount` in both handlers.
Analyzer 29 total / 0 errors / 2 warnings / 27 info — **identical to baseline despite
41 files added**. Suite +435 -10, same ten pre-existing failures, +41 new tests.
Both risky caveats resolved with no fallback: the broadcast double-subscribe works,
and the loopback `HttpServer` harness gave the datasource real coverage first
attempt — closing the inspection-only gap QA found in 3.3.

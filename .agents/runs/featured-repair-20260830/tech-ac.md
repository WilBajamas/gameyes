# Technical Acceptance Criteria
Source: `.agents/week-3-task-briefs.md` item 3.4b (lines 261–272). Criteria 3.4-AC26
through 3.4-AC36 are **reused verbatim** from
`.agents/runs/library-bloc-preferences-20260827/tech-ac.md` (the item-3.4 criteria set,
whole at 43 criteria, not re-cut — D16). 3.4-AC44 is new to this run.
Human decisions D14, D15, D16 and the `StatelessWidget` instruction
(`orchestrator-state.md ## Closed decisions`).
Date: 2026-08-30
BA Agent version: 1.0

## How to read this file

This is the single gating document for run `featured-repair-20260830`. It contains:

- **3.4-AC26 – 3.4-AC36** — carried across unchanged, text and failure cases intact, from
  `.agents/runs/library-bloc-preferences-20260827/tech-ac.md` lines 235–319. That file
  stays the canonical 43-criterion source and is **not** renumbered, re-cut or re-derived
  by this run. If the two ever disagree, the source file wins and this copy is the bug.
- **3.4-AC44** — the one genuinely new criterion, closing a gap QA found in 3.4a and did
  not fail the run for. Numbered 44 because the source file already runs to 3.4-AC43.

Nothing else in the source file is in scope here. 3.4-AC1–3.4-AC25 and
3.4-AC37–3.4-AC40 were satisfied and gated by the 3.4a run.

## Feature summary

Featured's now-playing shelf and its wishlist, total-games and owned-id figures are
repaired against `library_entries`. All four read Isar fields nothing has ever written —
`statusEqualTo('Playing')` and `isWishlistedEqualTo(true)` — so the shelf and the
progress branch behind it have never once rendered with data. This is a defect fix, not
a refactor. The repaired source is the unpaged read and the count capability 3.4a landed;
the seam that carries a playing row to the card is retyped so no Isar key is derived from
a `library_entries` row. Every now-playing tap goes to the Library tab (D14), which makes
the tracker task tree unreachable — intended, and guarded so nothing deletes it. A failed
or signed-out library read degrades to empty/zero inside a still-successful Featured
snapshot. One test proves the non-empty state the repair exists to produce actually
occurs, and one closes the append-side hole in the 3.4a end-of-results guard.

## Technical acceptance criteria

### Featured repair — carried verbatim from the 3.4 criteria set

3.4-AC26 DATA: Featured's now-playing list is sourced from `library_entries` rows with
status `playing` for the signed-in user, ordered by `updated_at` descending. The Isar
`statusEqualTo('Playing')` filter is no longer consulted for it.
  Failure case: the filter matches a value nothing has ever written
  (`featured_local_datasource.dart:46`), which is why the shelf has never once rendered
  with data — the defect this item exists to fix.

3.4-AC27 DATA: The wishlist source is repointed at `library_entries` rows with status
`wishlist`, and **all three** of its callers are served by the repointed source: the
wishlist stat tile (`featured_repository_impl.dart:39`), `getCountdownGame`'s wishlist
ids (`:63`), and `getOutThisWeekGames`'s wishlist-first ordering (`:131`). The ids the
latter two key on are IGDB ids and continue to match `GameEntity.id`.
  Failure case: the item text names only the stat, so a criterion set written from it
  leaves the countdown card's "on your wishlist" line and the out-this-week ordering on
  `isWishlistedEqualTo(true)` — a filter with no writer — and both stay silently wrong
  after the visible bug looks fixed.

3.4-AC28 DATA: Total games and the owned-game ids are also sourced from
`library_entries` for the signed-in user (D15) — the total from the count capability of
3.4-AC13, the owned ids as the entries' IGDB ids across every status. Featured's owned
marks (`featured_screen.dart:161,238`) and the three checklist steps
(`library_stats_cubit.dart:40-42`) are computed from library data only, with no Isar
fallback.
  Failure case: a user who added games only through the Library sees `Total Games 0`
  beside `Wishlist 3`, and their games carry no owned mark anywhere on Featured.

3.4-AC29 PRESENTATION: Both branches of the now-playing card's tap call
`setActiveIndex(1)`, so the destination is the Library tab regardless of how many games
are playing, and no `TrackerGameDetailRoute` push remains in `library_stats.dart` (D14).
  Failure case: the surviving push needs an Isar row id a library entry cannot supply; a
  placeholder id makes the stream emit null and `tracker_game_detail_section.dart:27`'s
  unguarded `state.game!` throws, while a colliding autoincrement id sends
  `TrackerDetailCubit.setPlatform` into a different game's row.

3.4-AC30 PRESENTATION: The whole playing slice is passed to the card, not a subset
filtered by whether a matching local `SavedGame` exists.
  Failure case: filtering to games saved through Game Detail leaves the shelf empty for
  exactly the users this repair is for, fixing the bug by half (D14 rejected this).

3.4-AC31 DOMAIN/DATA: No value produced for the now-playing seam is used as an Isar key.
No Isar lookup, watch or write anywhere in the Featured path is keyed on an identifier
derived from a `library_entries` row.
  Failure case: a synthesised row id that collides with a real one reads or writes
  another game's record — the failure mode D14 was decided to avoid, reintroduced by a
  seam that merely satisfies the type.

3.4-AC32 PRESENTATION: `tracker_game_detail_screen.dart`, `task_detail_screen.dart`,
`TaskCubit`, `GroupTask`, `SavedGameTask` and `TaskStep` are all still present, still
compile, and their existing tests still pass. Nothing in this item deletes, empties or
"tidies" any of them, and no Isar `SavedGame` field is removed.
  Failure case: D14 makes the tracker tree fully unreachable and that is intended, but
  the human's ruling is explicit that unreachable is not unwanted — the tree stays until
  the design convention lands. Deleting it here is an unauthorised scope change dressed
  as a cleanup.

3.4-AC33 DATA: A failed or signed-out library read leaves the Featured snapshot a
success, with an empty now-playing list, zero wishlist count, zero total and an empty
owned-id set. `getThisWeekPlayHours()` is unaffected and still reads Isar
`playSessionLogs`.
  Failure case: the whole Featured screen fails on a signed-out session, replacing five
  working sections with an error — a regression from the zeroes those tiles have shown
  since day one.

3.4-AC34 DATA: The now-playing seam carries every field `library_stats.dart` renders —
the title, the cover image, and the progress inputs at `:287-305` — with
`progress_percent` supplying the manual-progress branch and `playtime_hours` supplying
the hours branch.
  Failure case: the shelf renders with a blank title or no progress line, so the repair
  ships visibly incomplete.

3.4-AC35 TEST: A test proves the state the repair exists to produce actually occurs —
given `library_entries` rows with status `playing`, the snapshot's now-playing list is
non-empty and the card renders game data rather than `EmptyStateCard`.
  Failure case: the item's own lesson from `GamesStatus.empty` — when a criterion says
  "renders X in state Y", something must actually produce state Y. A test that only
  asserts the empty branch passes against a filter that matches zero rows, which is how
  this bug survived from the beginning.

3.4-AC36 MANUAL: On device, tapping the now-playing card opens the **Library** tab, with
one playing game and with several. Closes `3.2-MC-6`
(`manual-check-backlog.md:548-553`) — index 1 has never executed in either branch.
  Failure case: index 1 means Browse, and the card sends every user to the wrong tab
  with no compiler help, which is the trap the navigation blocker warned about.

### Added scope — new to this run

3.4-AC44 TEST: The end-of-results flag is guarded by test on the **append** path, not
only on the first-page path. A next-page test seeds a case the two candidate rules
disagree on — a full page appended onto an already-loaded page while the matched count
says the list has ended, e.g. one page loaded, a next page returned at exactly the
requested page size, and a matched count equal to their sum — and asserts the flag is
set. Reverting only the next-page handler's flag derivation to the withdrawn
short-page rule must make this test fail.
  Failure case: the append half of 3.4-AC7 is unfalsifiable today. The existing next-page
  test seeds a case where the matched-count rule and the withdrawn short-page rule agree,
  so reverting *only* the next-page handler leaves the whole bloc suite green (3.4a QA,
  surviving mutation 1). The first-page half has two tests; the half that runs on every
  scroll has none, and D17.8's decision can be undone by accident with no signal.

## Also binding on this run, not re-cut here

3.4-AC41 (analyzer: 0 errors and the 2-warning `_TaskReminder` invariant; the ten
pre-existing failures unchanged in name and count; no new failure outside them) is a
constraint on both halves of item 3.4 and is checked here against this run's diff and
this run's Phase 0 baseline (`orchestrator-state.md`: 0 errors, 2 warnings, 27 info;
`+435 -10`). It is not restated as a criterion because it is not this run's to re-derive
— read it from the source file at line 354. New info-level lints from the orphaned
tracker route registration are expected and are not breakage; the analyzer *total* is not
an invariant.

## Known gaps carried forward

- **`library_stats.dart:292-301` stays permanently unreachable** even after the shelf
  renders. That branch needs `averageCompletionHours` and `library_entries` has no
  average-completion column, so branches 1 and 3 fire and branch 2 never does. 3.4-AC34
  is met by the two reachable branches. Not a criterion, because no criterion written
  against it could pass.
- **The tracker task tree is reachable from nowhere** after 3.4-AC29 (D14). Deliberate,
  authorised, and constrained by 3.4-AC32 — it stays in the repo, compiling and tested.

## Out of scope

- **Everything 3.4a already shipped and was gated on** — the bloc, library preferences,
  the count capability, the search predicate, the datasource test. 3.4-AC1–3.4-AC25 and
  3.4-AC37–3.4-AC40 are closed and are not re-checked here. This run depends on 3.4a's
  `fetchCounts()`, `fetchAllEntries()`, `LibraryCountsEntity`, the `notSignedIn` mapping
  and the `LibraryRepository` domain interface, all of which already exist.
- **Re-deriving, rewriting or renumbering 3.4-AC26–3.4-AC36** (D16). The copies above are
  the source file's text; the source file is canonical.
- **The Isar read cache, the IGDB refresh system and task-tree backup** — later items
  with no run yet (D12).
- **The Library screen and its widgets** — Stage 4, items 4.1–4.6.
- **`getThisWeekPlayHours()` and `getSavedGames()`'s genre derivation.** Both stay on
  Isar; D15 names two methods and no Supabase table backs either of these.
- **Any Isar → Supabase data migration.** Neither legacy filter has ever matched a row,
  so there is nothing to migrate.
- **`GamesBloc`'s three pre-existing test failures**, and the deliberate
  `use_null_aware_elements` info lint in `library_remote_datasource.dart` — a
  human-approved survivor, because `clearRating` must write an explicit null (3.3-AC26).
  Do not fix it.

## Assumptions

The fifteen assumptions behind the source file carry into 3.4-AC26–3.4-AC36 unchanged;
the one that binds this range is that Featured's now-playing order is `updated_at`
descending (3.4-AC26).

ASSUMPTION (3.4-AC44): "the requested page size" means the library feature's existing
page-size constant, not a new value. The criterion constrains the test's seeded data, not
the page size itself.

ASSUMPTION (3.4-AC44): the case is expressed as a bloc-level test alongside the existing
next-page tests, since that is the layer the surviving mutation lives at.

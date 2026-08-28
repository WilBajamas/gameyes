# Technical Acceptance Criteria
Source: `.agents/week-3-task-briefs.md` item 3.4 (lines 240–264), with
`.agents/references/library-design-conventions.md` §2, §3, §8, §9, §10 as the consuming
spec. Human decisions D9, D10, D12, D14, D15
(`orchestrator-state.md ## Human decisions`).
Date: 2026-08-28
BA Agent version: 1.0

## Feature summary

The Library gains its state layer and the two data capabilities Stage 4 cannot be built
without. A bloc owns status filter, sort, view mode, search term and pagination, with
search composing with the active status rather than replacing it (§9:113) — a state-shape
decision, which is why it lands here and not on the screen. The data layer gains a
search predicate on the paged query and a server-side count capability (per-status counts
plus the library total), neither of which item 3.3 provided; without them §3's chip
counts and §8's `Showing 12 out of 312` have no source. View mode and sort persist
device-side through the existing tracker preferences datasource, renamed and extended
rather than duplicated. Featured's never-rendering now-playing shelf and wishlist stat
are repaired against `library_entries`, together with the total-games and owned-ids
figures per D15, and every now-playing tap goes to the Library tab per D14. A datasource
test against a fake `SupabaseClient` retires the inspection-only status of eight of
3.3's criteria. No Library screen and no widget: Stage 4 composes this.

## Technical acceptance criteria

### Library state shape

3.4-AC1 PRESENTATION: Library state carries, as independently readable fields: the
active status (a nullable `LibraryStatus`, where absent means `All`), the sort option,
the view mode, the search term, the loaded entries, a load status, an end-of-results
flag, the per-status counts, and the library total.
  Failure case: filter and sort held in widget state means the toggle rebuild loses
  them, which §9:109 forbids twice over.

3.4-AC2 PRESENTATION/DATA: Search composes with the active status (§9:113). With a
status active and a search term entered, the issued query carries **both** predicates
and the results are the intersection. Setting a search term does not clear the status;
changing the status does not clear the search term.
  Failure case: typing silently widens the shelf to the whole library, so the user reads
  the result as "my filter broke" and the chip still claims to be active.

3.4-AC3 PRESENTATION: Changing the status resets pagination to the first page and
refetches, preserving sort, view mode and search term.
  Failure case: page 4's offset applied to a different slice returns an empty page and
  the chip presents as a dead end.

3.4-AC4 PRESENTATION: Changing the sort resets pagination to the first page and
refetches, preserving status, view mode and search term (§9:111).
  Failure case: appending a differently-ordered page onto an existing list interleaves
  two orders and the shelf is in neither.

3.4-AC5 PRESENTATION: Changing the view mode emits new state **without** issuing any
fetch and without discarding the loaded entries, the active status, the sort or the
search term (§9:109).
  Failure case: a grid⇄list tap costs a round trip and re-anchors a 300-game list at the
  top, which is exactly what §9 says must not happen.

3.4-AC6 PRESENTATION: Requesting the next page appends to the loaded entries rather than
replacing them, and carries the offset of the already-loaded count. A next-page request
made while one is in flight does not produce a duplicated or doubled append.
  Failure case: a fast scroll fires twice and the same twelve games appear twice.

3.4-AC7 PRESENTATION: A page shorter than the requested limit sets the end-of-results
flag, and further next-page requests while it is set issue no query. Resetting the
status, sort or search clears the flag.
  Failure case: the end of a 312-game list issues a query per scroll event forever.

3.4-AC8 PRESENTATION: Search input is debounced 300ms — three keystrokes inside the
window issue one query, not three — and a whitespace-only term is treated as no search.
Clearing the term restores the unsearched slice for the active status.
  Failure case: a query per keystroke on a 312-row table; or `"   "` matched literally,
  returning nothing and reading as an empty library.

3.4-AC9 PRESENTATION: First-page loading and next-page appending are distinguishable in
state. An append in flight leaves the already-loaded entries readable.
  Failure case: the shelf blanks to skeletons on every page fetch, so scrolling flashes
  the whole screen (§9:123 puts skeletons in the shape of what they replace, on load).

3.4-AC10 PRESENTATION: A failed first-page fetch emits a failure state with an error the
UI can render, and a retry re-issues the same query. A failed **append** emits failure
without discarding the already-loaded entries.
  Failure case: one flaky page-4 request empties a shelf the user was reading.

3.4-AC11 PRESENTATION: A signed-out library read is distinguishable in state from a
successful empty library.
  Failure case: a logged-out user gets §11's recruiting empty state, which asks them to
  add a first game they already have.

3.4-AC12 PRESENTATION/TEST: The bloc does **not** dispatch any fetch from its own
constructor; the initial load is an event its caller adds. Constructing the bloc with
mocked collaborators performs zero use-case calls and leaves the state at its declared
initial value, and the first externally-added event is handled rather than dropped.
  Failure case: `GamesBloc`'s shape — a constructor `add()` plus `droppable()` handlers —
  makes the bloc untestable in the house `blocTest` style, because the constructor's own
  fetch is always in flight first, `droppable()` silently discards the event `act` adds,
  and the stub written for the test's arguments never matches
  (`testing-conventions.md:231-245`). That is the cause of three of the suite's ten
  standing failures, and repeating it ships this bloc untestable from day one.

### Counts

3.4-AC13 DATA: A count capability exists, reaching the caller as a `Result` on the same
shape as 3.3's four use cases, returning a count for each of the six `LibraryStatus`
values and the unfiltered library total for the signed-in user.
  Failure case: nothing after 3.3 provides counts, so §3:42's chip counts and §8:101's
  second figure have no source at all and Stage 4 invents one from the loaded page.

3.4-AC14 DATA: The counts are computed by the database, not by counting loaded rows or
by fetching rows to measure them.
  Failure case: a 312-game library reports `Showing 12 out of 12`, which is the one
  thing §8 says the line exists to disprove.

3.4-AC15 DATA: A status with no rows is returned as `0`, as a success — not omitted and
not an error. The library total for a user with no entries is `0`.
  Failure case: §10:131 requires `Wishlist 0` to stay visible as the route out of the
  library you own into the one you want; a missing key renders it as a blank chip.

3.4-AC16 DATA: The status counts ignore the search term and report whole-status figures.
The count-line figure is a separate value that honours **both** the active status and
the search term, against a library total that honours neither.
  Failure case: chip counts that shrink while typing stop answering the question they
  exist for — whether a slice you have not tapped has anything in it.

3.4-AC17 DATA: The count query filters by the signed-in user, and a signed-out call
returns a failure rather than a zero count.
  Failure case: a logged-out user is told they own zero games.

### Search in the data layer

3.4-AC18 DATA: The paged library query accepts an optional search term and applies it in
the query as a case-insensitive substring match on the entry title, combined with the
status predicate by AND. Existing call sites that supply no term issue a query
byte-identical to today's.
  Failure case: client-side filtering over loaded rows returns matches only from the
  pages already fetched, so a game on page 5 is unfindable by name.

3.4-AC19 DATA: A search term containing `%`, `_`, `\` or a comma matches those
characters literally and does not alter the query's structure or widen the match.
  Failure case: typing `%` matches the entire library; a comma splits the predicate and
  the query means something the user did not ask for.

3.4-AC20 DATA: Limit and offset apply to the filtered result set, so paging a search
result walks the matches, not the unfiltered table.
  Failure case: page 2 of a 3-match search returns rows that do not match.

3.4-AC21 DATA: Sort ordering is applied identically with and without a search term, and
the null-last rule from 3.3-AC18 still holds.
  Failure case: searching silently reverts the shelf to insertion order while the sort
  pill claims otherwise.

### Preferences

3.4-AC22 DATA: The renamed preferences datasource keeps reading and writing the existing
`tracker_sort_tag` key with unchanged semantics, and `TrackerCubit` still resolves from
DI and still round-trips its sort tag. The existing tracker preference and sort-repository
tests pass against the renamed types.
  Failure case: a rename that changes the key silently discards every existing user's
  stored tracker sort.

3.4-AC23 DATA: View mode and library sort persist under their own new keys, separate
from `tracker_sort_tag`, and survive an app restart. Persistence is device-scoped.
  Failure case: §9:109 — a 300-game user who picks list is handed the grid again.

3.4-AC24 DATA: Preference writes are best-effort: a write that throws is swallowed and
surfaces no error to the caller. A missing or unparseable stored value reads back as the
default (grid, recently added) rather than throwing.
  Failure case: one corrupt preference string crashes the Library tab on open, with no
  way for the user to clear it.

3.4-AC25 PRESENTATION: The persisted view mode and sort are applied before the first
page is fetched, so the first render is in the stored view and the stored order with no
visible switch. The status chip and the search term are **not** persisted and start at
`All` and empty on every visit.
  Failure case: the shelf paints as a grid then jumps to list; or a status filter set
  three days ago silently hides most of the library on open, with the user reading it as
  data loss.

### Featured repair

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

### Tests

3.4-AC37 TEST: A test constructs a real `LibraryRemoteDatasource` against a fake
`SupabaseClient` and asserts the request it builds for: a paged fetch with and without a
status, with and without a search term, for each sort option, and with a non-zero
offset; an add payload; and a partial update that omits unsupplied fields.
  Failure case: 3.3-AC16 through 3.3-AC25 rest on code inspection alone — no test
  constructs this class — so a wrong column name, a dropped predicate or a swapped sort
  direction ships green.

3.4-AC38 TEST: A test asserts `clearRating` sends an explicit `null` for the rating
column, and that an update with neither a rating nor `clearRating` omits the rating key
entirely.
  Failure case: `clearRating` has no automated guard at all today, and the
  `use_null_aware_elements` lint at `library_remote_datasource.dart:101` is a standing
  invitation to rewrite it into the `key: ?value` form, which omits the entry instead of
  writing null — a rating the user cleared silently comes back.

3.4-AC39 TEST: The bloc's tests cover, at minimum: initial state, first-page load
success and failure, status change resetting pagination, sort change resetting
pagination, view-mode change issuing no fetch, search composing with the active status,
debounce collapsing rapid input, append-on-next-page, and the end-of-results flag. They
are written in the house `blocTest` style and pass.
  Failure case: a bloc whose only proof is a passing analyzer, handed to Stage 4 as the
  substrate for six items.

3.4-AC40 TEST: Count and search behaviour are covered at the use-case and repository
level with mocked collaborators, including the zero-count and signed-out paths.
  Failure case: the two capabilities this item exists to add are the two with no
  regression guard.

3.4-AC41 CONSTRAINT: `flutter analyze` reports 0 errors and the 2-warning invariant (the
`_TaskReminder` pair in `task_detail_screen.dart`). New info-level lints arising from the
orphaned tracker route registration are expected and are not breakage. The ten
pre-existing test failures are unchanged in name and count, and no new failure appears
outside them.
  Failure case: the analyzer total has moved three times this week (30 → 28 → 29), so a
  changed total on its own proves nothing — the warnings are the invariant, and a run
  that reports a different total has probably added or deleted files.

## Known gaps

- **`library_stats.dart:292-301` stays permanently unreachable** even after the shelf
  renders. That branch needs `averageCompletionHours`, and `library_entries` has no
  average-completion column, so branch 1 (`:287-291`) and branch 3 (`:302-305`) fire and
  branch 2 never does. Recorded here rather than as a criterion, because no criterion
  written against it could pass. Adding an average-completion source is not this item;
  deleting the branch is the task-tree convention's call.
- **The tracker task tree is now reachable from nowhere** (D14). Deliberate, authorised,
  and constrained by 3.4-AC32 — it stays in the repo, compiling and tested.

## Out of scope

- **The Library screen and every one of its widgets** — chips, sort pill, view toggle,
  search field, grid, list, count line, Log-a-game cell, skeletons, empty states. Stage 4
  (items 4.1–4.6). This item ships the state and the data those widgets read.
- **The filter sheet** (platform, genre, year, score — §9:115) and its badge. Only the
  status axis is claimed here.
- **The rating input control** — item 4.6 (D10).
- **The Isar read cache, the IGDB refresh system and task-tree backup** — later items
  per D12. Supabase is the source of truth for this item.
- **`GamesBloc`'s three pre-existing test failures.** Fixing them needs restructuring;
  moving the baseline mid-week helps nobody. Their *cause* is in scope only as the
  constraint in 3.4-AC12.
- **Any Isar → Supabase data migration.** Neither legacy filter has ever matched a row,
  so there is nothing to migrate.
- **`getThisWeekPlayHours()` and `getSavedGames()`'s genre derivation.** Both stay on
  Isar; D15 names two methods and no Supabase table backs either of these.
- **Recent searches over the shelf** (§9:113's focus behaviour) and the scroll-position
  restore on clear. Both are screen concerns, and neither is independently testable at
  this layer.
- **Correcting the brief's stale 30-issue analyzer preamble** (lines 82–84). Real, but a
  doc edit outside this item's allowlist decision — flagged in `ambiguities.md`
  OBSERVATION-8 for the Tech Lead to place.

## Assumptions

See `ambiguities.md ## ASSUMPTIONS` — all fifteen carry into these criteria unchanged.
The load-bearing ones: counts are server-side and status counts ignore search
(3.4-AC14, 3.4-AC16); search is a server-side predicate on title, case-insensitive
substring (3.4-AC18); the debounce is 300ms (3.4-AC8); only view mode and sort persist
(3.4-AC25); page size is one constant in the library feature's own `const.dart`; and
Featured's now-playing order is `updated_at` descending (3.4-AC26).

# Technical Design Document
Source: `.agents/runs/library-bloc-preferences-20260827/tech-ac.md` (item 3.4 —
`LibraryBloc`, preferences, and the Featured repair)
Date: 2026-08-28 (revised 2026-08-30 for D17)

> **D17 revision note.** The human's Phase 3 review of `code-plan.md` found four real
> defects and settled seven revisions (`orchestrator-state.md ## Human decisions`, D17).
> Four of them moved criteria, which the BA has already applied to `tech-ac.md` — see its
> `## Changelog`. This document is corrected **in place** rather than by delta, because
> three of the seven falsify whole sections of it (D-C's preferences design, D-D's
> debounce, D-F's file placement) and because `task-brief.md`'s allowlist changes.
> The corrections are summarised in `code-plan.md ## Approved feedback delta`.

> **Split note (D16).** Item 3.4 is split at the Featured seam and this document
> deliberately still covers **both halves** — 3.4b's task brief is cut from it and from
> `code-plan.md` without re-deriving anything.
> **3.4a** (this run — criteria AC1–AC25, AC37–AC43): D-B, D-C, D-D, D-E, D-F; the
> `LibraryRemoteDatasource`, `LibraryPreferencesDatasource`, `postgrestLikePattern`,
> `LibraryRepository` and `LibraryPreferencesRepository` entries; the Library half of
> `## Domain layer`; all of `## State layer`; caveats 1–3.
> **3.4b** (a later run — criteria AC26–AC36): D-A; the `FeaturedRepositoryImpl` and
> `FeaturedLocalDatasource` entries; `NowPlayingGameEntity` and the
> `LibrarySnapshotEntity` modify; all of `## UI layer`, including the widget-test scoping
> decision. D17.2 (`_buildNowPlayingCard` becomes a `StatelessWidget`) also binds 3.4b.
> Where a brief and this document disagree, `task-brief.md` wins. The step-ceiling gate
> item recorded under `## Open questions` is what D16 resolved; it is no longer open.

## Feature summary

The Library gains a screen-scoped `LibraryBloc` that owns status filter, sort, view
mode, search term, pagination and counts, over a data layer extended in three ways: a
search predicate on the paged query, a database-computed count capability, and an
unpaged status read that Featured consumes. Library view mode and sort persist through a
**new, library-owned** `SharedPreferences` datasource added beside the tracker's, which
is left entirely untouched (D17). Featured's now-playing shelf, wishlist stat, total and
owned ids are repointed off the never-matching Isar filters onto `library_entries`
through the `LibraryRepository` interface, and the now-playing seam is **retyped** so no
Isar-shaped identifier exists on it at all. No screen and no new widget: Stage 4 composes
this.

## Layer map

| Criterion | Layers |
|---|---|
| 3.4-AC1, AC3–AC5, AC9–AC12, AC25 | state |
| 3.4-AC2, AC6–AC8 | state, domain, data |
| 3.4-AC13–AC17 | domain, data (Supabase) |
| 3.4-AC18–AC21 | data (Supabase), core utility |
| 3.4-AC22–AC24 | data (SharedPreferences), domain |
| 3.4-AC26–AC28, AC30, AC33, AC34 | data, domain |
| 3.4-AC29 | UI |
| 3.4-AC31 | domain (entity retype) |
| 3.4-AC32 | none — invariant to protect |
| 3.4-AC35, AC37–AC40 | test |
| 3.4-AC36 | manual |
| 3.4-AC41 | constraint |
| 3.4-AC42, AC43 | state |

---

## Design decisions settled here

These are the calls the orchestrator asked to be closed in this file rather than left
to Dev or QA.

### D-A. 3.4-AC31 — the now-playing seam is retyped, not populated with a safe value

`LibrarySnapshotEntity.nowPlayingGames` stops being `List<TrackerSavedGameEntity>` and
becomes `List<NowPlayingGameEntity>` — a new Featured-owned entity that carries exactly
what the card renders and **has no int identifier of any kind**.

Rejected alternative: keep `TrackerSavedGameEntity` and put a provably-unused value in
its required `id`. That satisfies the type and relies on a convention ("nobody keys on
it") that no compiler enforces, which is the failure mode 3.4-AC31 names verbatim.
Removing the field makes the failure impossible to write rather than merely absent
today — a later item that adds an Isar lookup to the Featured path cannot reach for an
id that does not exist.

`TrackerSavedGameEntity` itself is **untouched** and keeps every current consumer
(`TrackerCubit`, `TrackerRepositoryImpl`, the tracker detail tree) — 3.4-AC32 holds.

`NowPlayingGameEntity` carries `averageCompletionHours` even though `library_entries`
has no column for it. This is deliberate: dropping the field would force branch 2 of
`library_stats.dart:292-301` to be deleted to keep compiling, and `tech-ac.md ## Known
gaps` explicitly rules that deletion out of this item. The field therefore reads as
always-null and the branch stays permanently unreachable exactly as recorded.

### D-B. How counts are served — six concurrent database counts, once per visit

`LibraryRepository.fetchCounts()` issues **six** PostgREST head-count requests, one per
`LibraryStatus`, concurrently, and returns `LibraryCountsEntity(byStatus, total)` where
`total` is the sum of the six. `postgrest`'s `from(table).count(CountOption.exact)`
(`postgrest_query_builder.dart:257`) sends a `HEAD` request and returns an `int` — no
rows cross the wire and the database computes the number, satisfying 3.4-AC14. Deriving
`total` from the sum is exact, not approximate: `library_entries.status` is
`not null` with a six-value check constraint
(`supabase/migrations/20260805200002_library_entries.sql:14-16`), so every row is in
exactly one bucket. A seventh unfiltered count would be redundant.

**Why not one grouped query.** PostgREST's `select('status, count()')` aggregate form
would be one request instead of six, but aggregate functions are a server-side
PostgREST toggle this pipeline cannot inspect, and — this is the deciding point — a
fake-client test proves nothing either way, because the request is well-formed whether
or not the server accepts it. The failure would land only on a real device, as blank
chip counts for every user. Six requests are the choice that is correct without a
configuration assumption. Recorded as the future optimisation, not taken here.

**Why six requests is cheap in practice.** Counts are whole-status figures that ignore
the active status and the search term (3.4-AC16), so they do not change when a chip,
sort or search changes. They are fetched **once per visit** — by the first query event
that finds `state.counts == null` — and never on a status change, a sort change, a
keystroke or a page append. One burst of six concurrent `HEAD` requests per Library
open, and zero thereafter.

**The count line's own figure is free, and it is also what ends pagination.**
`.select().count(CountOption.exact)` "respects any filters but ignores modifiers"
(`postgrest_transform_builder.dart:202-206`), so the paged query already knows how many
rows matched status **and** search, ignoring limit/offset. `fetchPage` therefore returns
`LibraryPageEntity(entries, matchedCount)`. That one figure serves two criteria at once:
3.4-AC16's "separate value" costs no extra round trip and can never be torn against the
page it describes, and 3.4-AC7's end-of-results flag is derived from it rather than from
a short page (D17.8) — see D-G.

On 3.4-AC18's "byte-identical" clause: adding the count modifier changes a request
*header* (`Prefer: count=exact`), not the path, the predicates, the ordering or the
range. The criterion's failure case is about predicates and client-side filtering, and
no predicate changes for a no-search call. Flagged here so QA reads it as considered
rather than missed.

### D-C. Preferences — a separate library datasource; the tracker's is not touched

**Revised by D17.1. The previous design — rename `TrackerPreferencesDatasource` to a
shared `AppPreferencesDatasource` in `core/` and extend it — is withdrawn in full.**

- **`TrackerPreferencesDatasource` is not renamed, not moved, not extended and not
  edited.** Its file, its class name, its two methods, the `tracker_sort_tag` key, its
  default and its swallow-on-failure semantics all stay exactly as they are.
  `TrackerSortRepositoryImpl`, `TrackerSortRepository`, `TrackerCubit`,
  `GetTrackerSortUseCase`, `SaveTrackerSortUseCase` and
  `test/repository/tracker/tracker_sort_repository_test.dart` are likewise untouched —
  none of them appears in this item's allowlist at all (3.4-AC22).
- **`LibraryPreferencesDatasource` is created beside it**, at
  `lib/features/library/data/datasources/library_preferences_datasource.dart`,
  `@injectable`, holding `SharedPreferences`, with two read/write pairs for the two new
  library keys. Flat in `data/datasources/`, matching `library_remote_datasource.dart`;
  the tracker's `local/` nesting is a known deviation the `flutter-datasource` skill says
  not to copy without reason.
- `LibraryPreferencesRepository` / `LibraryPreferencesRepositoryImpl` sit above it, as
  before.

**Why this is safer than the rename it replaces.** 3.4-AC22's own stated failure case was
a changed key silently discarding every existing user's stored tracker sort. A class
nobody edits cannot reach that failure at all. The rename's blast radius — one impl, one
test file and the generated DI config — was small but non-zero; this is zero.

**The cost, stated plainly so QA does not read it as an oversight.** The two classes now
each carry the same six-line `try`/`catch` around `getString`/`setString`. That
duplication is deliberate and human-approved: the item text asked for "rename and extend
rather than writing a second one", and D17 overrules it. Do not "tidy" the two back
together.

**Why the repository is not merged either.** Merging would make one interface import
`SavedGameFilterTag` (tracker) and `LibraryViewMode` + `LibrarySort` (library), and
would hand `TrackerCubit` a contract with three members it never calls — an
interface-segregation break across two feature domains. With the datasources now separate
as well, both layers are split on the same seam, which is the simpler story.

Both preference repositories keep the tracker's **synchronous, non-`Result`,
contractually non-throwing** shape (`tracker_sort_repository.dart:3-8`) rather than the
project's `Future<Result<T>>` default. That deviation already exists, is documented on
the existing interface, and is what makes 3.4-AC24 ("a write that throws is swallowed
and surfaces no error to the caller") expressible at all. Matching it is the consistent
choice; introducing `Result` here would force the bloc to handle a failure the criteria
forbid it from surfacing.

### D-D. 3.4-AC12 — the bloc cannot repeat `GamesBloc`'s shape

Three structural rules, chosen so the trap is unrepeatable rather than merely avoided:

1. **The constructor registers handlers and nothing else.** No `add()`, no use-case
   call, no preference read. `super(const LibraryState())` — the declared initial value
   is a `const` freezed default, so "constructing with mocked collaborators performs
   zero use-case calls and leaves the state at its declared initial value" is checkable
   with a plain `test()`, not a `blocTest`.
2. **No `droppable()` on the events a caller adds first.** The query family uses
   `restartable()`; `droppable()` appears only on `LibraryNextPageRequested`, which is
   never the first event and where dropping is the required behaviour (3.4-AC6).
   `restartable()` cannot silently discard the first event — there is nothing in flight
   to lose to.
3. **One handler for the whole reset-and-refetch family.** `LibraryStarted`,
   `LibraryStatusSelected`, `LibrarySortSelected`, `LibrarySearchTermChanged` and
   `LibraryRetried` all extend a sealed `LibraryQueryChanged` and are registered as a
   single `on<LibraryQueryChanged>(..., transformer: ...)`. This is not cleverness for
   its own sake: with one `on<>` per event type, a chip tap during an in-flight search
   fetch runs on a *different* stream, the two requests race, and the loser can emit last
   with stale rows. One handler and one transformer make the latest query authoritative
   by construction, which is what 3.4-AC2's "the results are the intersection" needs to
   be true under real timing.

**How 3.4-AC25 is still met with an empty constructor.** The stored view mode and sort
are read (synchronously — `SharedPreferences.getString` is synchronous on an already
resolved instance) inside the `LibraryStarted` branch of the handler and folded into the
**same** emit that sets `loading`. There is no emit in the default view mode carrying
content, so there is no visible switch. The one frame before the handler runs is at
`LibraryLoadStatus.initial`, which is why `initial` and `loading` are separate enum
values: Stage 4 renders nothing at `initial` and skeletons at `loading`.

**The 300 ms debounce is a named event transformer, not a delay inside the handler**
(3.4-AC8, and revised by D17.5/D17.6). `stream_transform` is declared as a direct
dependency — see D-H — and the query family is registered with a small named transformer
that splits the incoming event stream in two:

- search events are put through `debounce(LibraryConstants.searchDebounce)` (the
  package's defaults, `leading: false, trailing: true`, are exactly "emit the last event
  once typing stops");
- every other query event passes through with no delay, because a chip or sort tap is a
  deliberate action and must not feel laggy;
- the two are merged and handed to `restartable()`, so the single-handler property of
  rule 3 above survives intact.

The previous design — `restartable()` plus a hand-rolled `await Future.delayed(...)` at
the top of the handler — is withdrawn. It worked only because `restartable()`'s
cancellation happened to sit underneath the delay, so a later edit could have removed
debouncing with no test failing (D17.6). It also forced the loading emit to happen
*before* the delay, which is the defect 3.4-AC42 now names.

**What moving the delay out of the handler changes, and why 3.4-AC42 needs it.** With
the debounce in the transformer, a keystroke inside the window reaches the handler not at
all, so nothing is emitted for it — which is 3.4-AC42's "a keystroke inside the window
emits nothing at all", literally rather than approximately. Only the keystroke that
survives the debounce runs the handler and emits `loading`.

**Consequence, recorded so QA reads it as considered.** Because a pending keystroke never
reaches the handler, `state.searchTerm` is deliberately stale for up to 300 ms. A chip tap
during that window therefore issues one query carrying the *previous* term; 300 ms later
the debounced search event supersedes it through `restartable()` and the correct
intersection is fetched. The final state is the intersection 3.4-AC2 requires, and the
intermediate render is one term behind — which is what a debounce means. Keeping the term
in state ahead of time is not available: it would be an emit inside the debounce window,
which 3.4-AC42 forbids.

### D-E. The stale analyzer preamble at `week-3-task-briefs.md:82-84` **is** corrected here

Decided: correct it, in this run, scoped to those three lines only.

It is not general doc maintenance. Lines 77–80 immediately above are the D14 amendment
this run's human decision produced, and line 82 opens "**Consequence:**" — the stale
`30 issues` number is inside the paragraph D14 rewrote, so fixing it finishes an
amendment this run already owns. It also directly contradicts this run's own recorded
baseline (`orchestrator-state.md:8`, 29 issues) and instructs a reader that "a run that
reports 28 has broken something", which is now false in both directions. Item 3.1 set
the precedent for correcting a doc in the run that invalidates it, and the week has
already lost time to a superseded line read as live guidance.

The correction replaces the fixed total with the mechanism — the 2 `_TaskReminder`
warnings are the invariant, the total is not and has moved three times, verify at Phase
0. No other edit to that file; the allowlist entry names the line range.

### D-F. File placement — no new module folder, and two files land outside the feature

Every new Library file has an unambiguous home in a layer folder the feature already has
from 3.3 (`domain/entities`, `domain/use_cases`, `domain/repositories`,
`data/datasources`, `data/repositories`, `presentation/blocs`). Grouping the preferences
work into its own module folder would put a repository interface outside
`domain/repositories`, which is where every reader and every other feature looks for one.
The bloc, its `part` event file and its state file sit flat in `presentation/blocs/`
exactly as `games_bloc.dart` does.

Two files sit outside `features/library/` on purpose:

- `lib/core/enums/library_view_mode.dart`, beside the existing `library_status.dart` and
  `library_sort.dart`.
- `lib/core/utils/postgrest_utils.dart`, beside `igdb_query_builder.dart` (D17.4) — see
  D-I.

Nothing lands in `lib/core/data/datasource/` any more; the pre-D17 plan put the shared
preferences datasource there, and D17.1 withdrew it. That folder keeps the contents
`flutter-arch.md:35` already describes.

### D-G. 3.4-AC7 — end of results comes from the matched count (D17.8)

The flag is `loaded >= page.matchedCount`, where `loaded` is the entry count the emit is
about to publish:

- first page — `page.entries.length >= page.matchedCount`;
- next page — `(state.entries.length + page.entries.length) >= page.matchedCount`.

Both figures come from the **same** response, so the comparison can never be torn against
a count fetched at another moment. `matchedCount` respects the status and search
predicates and ignores limit/offset (D-B), which is exactly the total the flag needs. An
empty library gives `0 >= 0` and the flag is set immediately, which is correct: there is
no next page to ask for.

The withdrawn rule — `entries.length < pageSize` — is gone from both handlers. It cost a
wasted request on every exact multiple of the page size (40 rows at a page size of 20
cannot be known to have ended until an empty third page comes back), and briefly showed a
"loading more" state with nothing to add.

No new query, no new endpoint: the count modifier is already on the paged request for
3.4-AC16's sake.

### D-H. `stream_transform` is declared — the one authorised `pubspec.yaml` edit (D17.6)

`execution.md` makes `pubspec.yaml` read-only, "to check package availability", and
`task-brief.md` normally forbids adding a package outright. **D17.6 is an explicit human
authorisation to edit it, and only for this one line.** It is in the allowlist for that
reason, and for no other.

- Add `stream_transform: ^2.1.1` under `dependencies`, beside `bloc_concurrency`.
- The package is **already resolved**: `pubspec.lock:1301-1308` has it at 2.1.1 as a
  transitive dependency of `bloc_concurrency`. Declaring it changes that entry's
  `dependency:` field from `transitive` to `direct main` and nothing else — no version
  moves. `flutter pub get` must be run after the edit; that one-line `pubspec.lock`
  change is an expected part of the diff, not an out-of-allowlist edit.
- **`bloc_concurrency` stays.** It provides `restartable()` and `droppable()`, which
  `stream_transform` does not. This is an addition, not a swap.
- Nothing else goes into `pubspec.yaml`. `http` and `rxdart` remain off-limits and the
  design needs neither.

### D-I. `postgrestLikePattern` lives in `core/utils`, not in the datasource (D17.4)

The `ilike` pattern builder is created as a public top-level function
`String postgrestLikePattern(String term)` in `lib/core/utils/postgrest_utils.dart`,
beside `igdb_query_builder.dart`. It never exists as a private `_pattern` on
`LibraryRemoteDatasource`.

The reason is what the knowledge is *about*: doubling a backslash and escaping `%` and
`_` is PostgREST/`LIKE` query syntax, not anything about a library entry. The Library
datasource is simply its first caller, and search boxes over other Supabase tables are
already foreseeable. `igdb_query_builder.dart` is the existing precedent for
query-syntax knowledge living in `core/utils/`.

A top-level function rather than a class: there is no state and no builder chain to hold,
and a one-method class would exist only to be instantiated.

**No dedicated test file, deliberately.** The escaping is asserted where it is observable
— `test/repository/library/library_remote_datasource_test.dart` reads the built request
URL, which covers both the escaping and the percent-encoding a pure unit test cannot see
(3.4-AC19, and caveat 2 below). `testing-conventions.md`'s layer table has no utility
layer, so a `test/utils/` file would introduce a folder convention this item did not set
out to change. If the human wants one anyway it is a one-step addition; say so and it
goes in.

---

## Data layer

### Supabase (PostgREST) requests

Table `library_entries`, all filtered by `user_id` from
`SupabaseClient.auth.currentSession` (absent session throws
`AuthSessionMissingException`, which `BaseRepositoryMixin` already maps to
`ErrorType.notSignedIn` — `base_repository_mixin.dart:20-21`). That mapping is what
serves 3.4-AC11 and 3.4-AC17 without new error plumbing.

| Request | Shape |
|---|---|
| paged fetch | `select().count(exact).eq(user_id).eq(status)?.ilike(title, pattern)?.order(col, asc:, nullsLast).range(offset, offset+limit-1)` → rows + `matchedCount` |
| status count ×6 | `count(exact).eq(user_id).eq(status)` (`HEAD`) → `int` |
| unpaged status read | `select().eq(user_id).eq(status)?.order(updated_at, desc)` → rows |

Search pattern (3.4-AC18–AC21): the datasource calls
`postgrestLikePattern(searchTerm)` (D-I), which returns `'%${escaped}%'` where `escaped`
replaces `\`→`\\`, then `%`→`\%`, then `_`→`\_`, in that order. Postgres `ILIKE` uses
backslash as its default escape character, so the escaped pattern matches those
characters literally and cannot widen the match. `ilike` is appended as an ordinary
filter alongside the status `eq`, so the predicates combine by AND, the limit/offset
apply to the filtered set, and `order` is unchanged with or without a term — 3.4-AC20 and
3.4-AC21 fall out of using one query rather than two paths.

**Caveat (not executable here).** Two things about the built request cannot be settled
without running code: whether a comma in the term survives as a literal, and the exact
percent-encoding of the pattern. Reasoning: `postgrest_builder.dart:395-400` builds the
filter through `Uri.replace(queryParameters:)`, and Dart percent-encodes query values,
so a comma should arrive as `%2C` and cannot split the predicate. **Fallback if the
datasource test shows a raw comma in the built URL:** wrap the pattern in PostgREST
double quotes rather than removing the character — inside `postgrestLikePattern`, which
is now the one place that decides this. Dev records the actual encoded form as a
self-correction note either way.

### Models

No new or changed DTOs. `LibraryEntryModel` is unchanged — search and counts add no
columns.

### Repositories

**`LibraryRepository` (modify)** — `lib/features/library/domain/repositories/library_repository.dart`
- `fetchPage({LibraryStatus? status, required LibrarySort sort, required int limit,
  required int offset, String? searchTerm})` → `Future<Result<LibraryPageEntity>>`
  *(return type changes from `List<LibraryEntryEntity>`; `searchTerm` is new)*
- `fetchCounts()` → `Future<Result<LibraryCountsEntity>>` *(new)*
- `fetchAllEntries({LibraryStatus? status})` → `Future<Result<List<LibraryEntryEntity>>>`
  *(new; unpaged, ordered `updated_at` descending)*
- `add`, `update`, `remove` unchanged.

`fetchAllEntries` exists for Featured, not for the Library screen. It stays on this
interface rather than becoming a second one because every member is a read or write of
the same table in the same feature's domain — unlike D-C, where a merge would have
crossed two feature vocabularies. One method serves all three Featured needs: playing
rows, wishlist ids, and every owned id.

**`LibraryRepositoryImpl` (modify)** — mirrors the interface; keeps `BaseRepositoryMixin`
and the existing "map rows to entities inside the awaited future" pattern so a bad
status row fails as a `Failure` rather than throwing at the caller.

**`LibraryPreferencesRepository` (create)** —
`lib/features/library/domain/repositories/library_preferences_repository.dart`
- `LibraryViewMode getViewMode()` — defaults to `grid`
- `Future<void> saveViewMode(LibraryViewMode mode)`
- `LibrarySort getSort()` — defaults to `recentlyAdded`
- `Future<void> saveSort(LibrarySort sort)`

Contractually non-throwing on both sides; an absent or unparseable stored value reads
back as the default (3.4-AC24). Doc comment mirrors `TrackerSortRepository`'s.

**`LibraryPreferencesRepositoryImpl` (create)** — `@Injectable(as: ...)`, holds
`LibraryPreferencesDatasource`, matches enum names to stored strings by `.name` with a
default fallback, the same shape `TrackerSortRepositoryImpl.getSortTag()` uses today.

**`FeaturedRepositoryImpl` (modify)** — gains `LibraryRepository` as a third
constructor dependency (the domain interface, not the impl).
- `getLibrarySnapshot()` — starts `fetchAllEntries()` and `fetchCounts()` concurrently,
  keeps `getThisWeekPlayHours()` on Isar. `totalGamesCount` ← `counts.total`;
  `wishlistCount` ← `counts.byStatus[wishlist]`; `nowPlayingGames` ← entries filtered to
  `playing` (order preserved from the query) mapped to `NowPlayingGameEntity`;
  `ownedGameIds` ← every entry's `igdbId`. A `Failure` on either read degrades to an
  empty list / null counts and the snapshot **still returns `Success`** (3.4-AC33).
  The two calls are assigned before either is awaited; that idiom carries the plain
  comment D17.3 asks for, same wording as the bloc's.
- `getCountdownGame()` and `getOutThisWeekGames()` — wishlist ids come from
  `fetchAllEntries(status: wishlist)` mapped to `igdbId`; a `Failure` degrades to an
  empty set. These are 3.4-AC27's two unnamed callers and they are fixed in the same
  pass as the visible stat.

### Datasources

**`LibraryRemoteDatasource` (modify)** — `fetchPage` gains `String? searchTerm` and
returns `(List<LibraryEntryModel> rows, int matchedCount)`; new `fetchCounts()` →
`Map<LibraryStatus, int>` (six concurrent head counts via `Future.wait`) and
`fetchAllEntries({LibraryStatus? status})` → `List<LibraryEntryModel>`. The `ilike`
pattern comes from `postgrestLikePattern` in `core/utils` (D-I); this class holds no
private pattern helper. `_currentUserId`, `_sortColumn` and the `clearRating` pair are
untouched — in particular the human-approved `use_null_aware_elements` lint at `:101`
stays exactly as it is.

**`LibraryPreferencesDatasource` (create)** —
`lib/features/library/data/datasources/library_preferences_datasource.dart`,
`@injectable`, holds `SharedPreferences`. Two read/write pairs, each wrapped in the same
swallow-on-failure try/catch `TrackerPreferencesDatasource` uses: `readViewModeName` /
`writeViewModeName`, `readSortName` / `writeSortName`. Named methods per preference
rather than a generic `readString(key)` — `flutter-datasource` forbids wrapping
`SharedPreferences` in pass-throughs, and named methods keep the keys off the call sites.
Keys live in `StorageConstants` (`lib/core/res/const.dart`) beside `trackerSortTagKey`,
which is itself not touched.

**`TrackerPreferencesDatasource` — not modified, not moved, not deleted** (3.4-AC22,
D-C). It is not in the allowlist.

**`FeaturedLocalDatasource` (modify)** — `countSavedGames`, `getOwnedGameIds`,
`getWishlistedGames` and `getNowPlayingGames` are removed; they are the four dead Isar
reads this item exists to retire and nothing else calls them. `getThisWeekPlayHours`,
`getSavedGames` and the genre-preference pair stay untouched, so the This Week tile and
the genre derivation are unaffected. No `SavedGame` field is removed and
`SavedGame.toEntity()` keeps its caller in `TrackerRepositoryImpl` — 3.4-AC32 holds.

### Core utility

**`postgrestLikePattern` (create)** — `lib/core/utils/postgrest_utils.dart`, a public
top-level `String postgrestLikePattern(String term)`. See D-I for placement and for the
no-test decision.

---

## Domain layer

**Entities (create)**

- `LibraryCountsEntity` — `lib/features/library/domain/entities/library_counts_entity.dart`
  — freezed — `Map<LibraryStatus, int> byStatus` (all six keys always present, zeros
  included per 3.4-AC15), `int total`.
- `LibraryPageEntity` — `lib/features/library/domain/entities/library_page_entity.dart`
  — freezed — `List<LibraryEntryEntity> entries`, `int matchedCount`.
- `NowPlayingGameEntity` — `lib/features/featured/domain/entities/now_playing_game_entity.dart`
  — freezed — `String title`, `String? coverUrl`, `double? progressPercent`,
  `double? playtimeHours`, `double? averageCompletionHours` (no source; see D-A).

**Enum (create)** — `LibraryViewMode { grid, list }` in `lib/core/enums/library_view_mode.dart`,
beside `library_status.dart` and `library_sort.dart`.

**Entity (modify)** — `LibrarySnapshotEntity.nowPlayingGames` becomes
`List<NowPlayingGameEntity>`. Stays a plain class; nothing else about it changes.

**Use cases**

| Use case | Path | Input | Returns | Repo call |
|---|---|---|---|---|
| `FetchLibraryPageUseCase` (modify) | `library/domain/use_cases/` | status?, sort, limit, offset, searchTerm? | `Future<Result<LibraryPageEntity>>` | `fetchPage` |
| `FetchLibraryCountsUseCase` (create) | `library/domain/use_cases/` | none | `Future<Result<LibraryCountsEntity>>` | `fetchCounts` |
| `GetLibraryPreferencesUseCase` (create) | `library/domain/use_cases/` | none | `({LibraryViewMode viewMode, LibrarySort sort})` | `getViewMode`, `getSort` |
| `SaveLibraryViewModeUseCase` (create) | `library/domain/use_cases/` | `LibraryViewMode` | `Future<void>` | `saveViewMode` |
| `SaveLibrarySortUseCase` (create) | `library/domain/use_cases/` | `LibrarySort` | `Future<void>` | `saveSort` |

Errors handled: none in the domain layer — every fetch use case forwards the
repository's `Result` unchanged, and the preference use cases sit on a non-throwing
contract.

`GetLibraryPreferencesUseCase` returns a record rather than an entity: it is one
operation ("what did they choose"), the two values are always read together, and a
two-field entity file would exist only to be destructured immediately. It returns
synchronously and outside `Result` for the reason given in D-C; it is the same
deviation `GetTrackerSortUseCase` already ships.

Featured's repository depends on `LibraryRepository` **directly**, not through a use
case — a repository calling a use case would invert the layering.

---

## State layer

**`LibraryBloc`** (create) — `lib/features/library/presentation/blocs/library_bloc.dart`,
`@injectable`, **screen scope** (provided by Stage 4's `LibraryScreen` via
`BlocProvider` + `getIt`; nothing in this item provides it).

Dependencies: `FetchLibraryPageUseCase`, `FetchLibraryCountsUseCase`,
`GetLibraryPreferencesUseCase`, `SaveLibraryViewModeUseCase`, `SaveLibrarySortUseCase`.

**`LibraryState`** (create) — `library_state.dart`, freezed, single `const factory`:

| Field | Type | Default | Criterion |
|---|---|---|---|
| `activeStatus` | `LibraryStatus?` | none (null = All) | AC1 |
| `sort` | `LibrarySort` | `recentlyAdded` | AC1, AC25 |
| `viewMode` | `LibraryViewMode` | `grid` | AC1, AC25 |
| `searchTerm` | `String` | `''` | AC1, AC2 |
| `entries` | `List<LibraryEntryEntity>` | `[]` | AC1, AC42 |
| `status` | `LibraryLoadStatus` | `initial` | AC1, AC9, AC11 |
| `nextPageStatus` | `LibraryNextPageStatus` | `initial` | AC9 |
| `hasReachedEnd` | `bool` | `false` | AC7 |
| `counts` | `LibraryCountsEntity?` | none | AC13, AC15, AC17 |
| `matchedCount` | `int` | `0` | AC7, AC16 |
| `error` | `ErrorType?` | none | AC10, AC11 |
| `nextPageError` | `ErrorType?` | none | AC10 |

`enum LibraryLoadStatus { initial, loading, success, failed, empty }` and
`enum LibraryNextPageStatus { initial, loading, failed }` — two enums, never collapsed
(`flutter-state`), which is what makes 3.4-AC9 expressible.

`counts` is **nullable with no default** on purpose: 3.4-AC15 requires a real `0` to be
a success and 3.4-AC17 requires a signed-out call to be a failure, so "not loaded"
cannot be represented by zeros. `null` means unknown, a non-null entity means every
figure in it is authoritative.

`activeStatus` is set back to null by an ordinary `copyWith(activeStatus: null)` —
freezed's generated `copyWith` uses a `freezed` sentinel, not `null`, for its "unchanged"
marker (confirmed at `games_state.freezed.dart:65-77`), so selecting `All` needs no
special handling.

**The generation counter is not in the state.** `LibraryBloc` carries a private
`int _queryGeneration`, deliberately kept off `LibraryState` (D17.7). It is bookkeeping,
not something the UI reads, and putting it in the state would break equality for every
consumer — two otherwise identical states would compare unequal and rebuild. See the
next-page handler below.

**Events** — `library_event.dart`, `part of 'library_bloc.dart'`:

```
LibraryEvent (sealed, Equatable)
├── LibraryQueryChanged (sealed) ......... resets pagination, refetches page 1
│   ├── LibraryStarted ................... caller's initial load; also reads preferences
│   ├── LibraryStatusSelected(status?)
│   ├── LibrarySortSelected(sort)
│   ├── LibrarySearchTermChanged(term) ... debounced by the transformer
│   └── LibraryRetried
├── LibraryViewModeSelected(viewMode) .... no fetch
└── LibraryNextPageRequested ............. appends
```

**Handlers**

| Registration | Transformer | Behaviour |
|---|---|---|
| `on<LibraryQueryChanged>` | named `_latestQuery()` — search events debounced, everything else immediate, merged, then `restartable()` (D-D) | see below |
| `on<LibraryViewModeSelected>` | none (synchronous) | emits `viewMode` only; persists fire-and-forget; entries, status, sort and term untouched (AC5, AC23) |
| `on<LibraryNextPageRequested>` | `droppable()` | see below |

`_onQueryChanged`, in order:

1. Bump `_queryGeneration`. This happens **before anything else**, so any next-page
   request already in flight is invalidated the moment the query changes (AC43).
2. Resolve the new query from `state` plus the event's own field — `LibraryStarted`
   reads `sort` and `viewMode` from `GetLibraryPreferencesUseCase`, every other event
   inherits them from state. The search term is trimmed here.
3. Emit once: the new field, the resolved preferences, `status: loading`,
   `hasReachedEnd: false`, `nextPageStatus: initial`, `error: null`,
   `nextPageError: null`. **`entries` is not cleared** (AC42) — see below. This single
   emit is what makes 3.4-AC3, AC4, AC7 and AC25 hold together, and because the debounce
   now lives in the transformer, it is reached only by a query that actually issues
   (AC42).
4. If the event is `LibrarySortSelected`, persist the sort, fire-and-forget (AC23).
5. Start `FetchLibraryPageUseCase(status: activeStatus, sort:, limit: pageSize,
   offset: 0, searchTerm: term.isEmpty ? null : term)` and, **only when
   `state.counts == null`**, `FetchLibraryCountsUseCase()` — concurrently, by assigning
   both futures before awaiting either. Await both.
6. Emit once, from an exhaustive `switch` over each `Result`:
   `Success` → `status: entries.isEmpty ? empty : success`, `entries`,
   `matchedCount`, `hasReachedEnd: page.entries.length >= page.matchedCount` (D-G), and
   `counts` when the counts call succeeded; a counts `Failure` leaves `counts` null and
   does **not** fail the page. `Failure` on the page → `status: failed, error:`
   (AC10, AC11).

**Why the loading emit no longer clears `entries`** (D17.5, 3.4-AC42). One rule for every
query change, not a branch on event type: the previously loaded entries stay in state
until the replacement arrives. For a search this is what AC42 requires. For a chip or
sort tap it is harmless — `status == loading` is what Stage 4 renders skeletons from
(§9:123), so what the shelf shows is a rendering decision the screen owns, and the state
layer's job is only to keep the rows readable. Nothing depends on `entries` being empty
while a first page loads: `hasReachedEnd` is reset in the same emit, and the success
branch replaces the list wholesale.

The search term is trimmed on entry, so a whitespace-only term is stored as `''` and
sent as `null` — no `ilike` filter is appended at all, which is what "treated as no
search" means at the wire level (AC8).

Every emit is built from `state.copyWith(...)` read at emit time, never from a snapshot
captured before the await, so a view-mode change during an in-flight fetch survives the
fetch's own emit.

`_onNextPageRequested`, in order:

1. Return immediately when `hasReachedEnd` or `status != success` (AC6, AC7).
2. Capture `_queryGeneration` into a local, **before** the await.
3. Emit `nextPageStatus: loading` (AC9 — `entries` untouched).
4. Fetch at `offset: state.entries.length`, with the state's own status, sort and term.
5. **Re-check the captured generation against `_queryGeneration`. If they differ, return
   without emitting** (AC43). The query moved on while this request was out, so its rows
   belong to a slice the user is no longer looking at. No state repair is needed on this
   path: `_onQueryChanged`'s own emit already set `nextPageStatus: initial`, so nothing
   is left stuck in a loading state.
6. Otherwise emit: append with `List.of(state.entries)..addAll(page.entries)`, carry
   `matchedCount`, and set `hasReachedEnd` from the appended length against
   `page.matchedCount` (D-G). A `Failure` sets `nextPageStatus: failed` and
   `nextPageError` without discarding the loaded entries (AC10).

"Cancel" means discarding the response, not aborting the request: the Supabase client
exposes no request cancellation. The observable behaviour is identical, and the counter
also settles two page responses that arrive out of order — whichever belongs to an
older generation is dropped.

---

## UI layer

### Screens
None created or modified. `library_screen.dart` stays the Stage 3 shell.

### Widgets

**`LibraryStatsWidget` (modify)** — `lib/features/featured/presentation/widgets/library_stats.dart`
— stateless — consumes `LibrarySnapshotEntity?` (now with `List<NowPlayingGameEntity>`).
Three changes and nothing else:
1. The now-playing card's `onTap` becomes a single
   `AutoTabsRouter.of(context).setActiveIndex(1)` — both branches collapse because both
   destinations are now the same (3.4-AC29, D14). The `TrackerGameDetailRoute` push and
   the `auto_route_config.gr.dart` import go with it; leaving the import behind would be
   a new lint.
2. The card reads `title`, `coverUrl`, `progressPercent`, `playtimeHours` and
   `averageCompletionHours` off the new entity. All three progress branches stay
   structurally intact (3.4-AC34, and `## Known gaps`).
3. No comments are added — widget files carry none.

Per D17.2 the card becomes its own `StatelessWidget` rather than a
`_buildNowPlayingCard` helper method, so it can be `const` and does not rebuild with its
parent. **That is 3.4b's file and 3.4b's change**; it is recorded here because this
section is 3.4b's to cut from, and it is not in 3.4a's allowlist.

The `extraCount >= 1` badge and the `Active` pill are unchanged; the tap no longer
depends on them.

**Widget test scoping** (per `flutter-widget-test`): `LibraryStatsWidget` **gets a
dedicated test file**. It owns a genuine conditional the repair exists to flip — an
empty playing list renders `EmptyStateCard`, a non-empty one renders the game — which is
3.4-AC35's second half and the exact `GamesStatus.empty` lesson the item cites. The tap
destination is **not** widget-tested: exercising `AutoTabsRouter` needs a tab-router
harness disproportionate to one `setActiveIndex` call, and 3.4-AC36 already books it as
an on-device manual check. No other widget in scope gets or needs a file —
`library_screen.dart` is untouched, and nothing else in the diff renders.

---

## Reuse decisions

- `BaseRepositoryMixin` (`core/data/datasource/base_repository_mixin.dart`) — every new
  repository method goes through `fetchData`; its existing
  `AuthSessionMissingException → ErrorType.notSignedIn` mapping serves 3.4-AC11 and
  3.4-AC17 with no new error code.
- `TrackerPreferencesDatasource` — **read for its shape, not reused as a type** (D-C,
  D17.1). Its swallow-on-failure try/catch is what 3.4-AC24 asks for and is written the
  same way in the new `LibraryPreferencesDatasource`; the class itself is not renamed,
  extended or edited.
- `TrackerSortRepositoryImpl.getSortTag()`'s "match `.name`, fall back to the default"
  loop — same shape used for both library preference reads. That file is not modified.
- `postgrest`'s `count(CountOption.exact)` — the count capability is the package's own
  head-count request, not a hand-rolled aggregate, and the paged query's own count is
  what 3.4-AC7 and 3.4-AC16 both read.
- `LibraryEntryModel` / `LibraryStatusColumn` — unchanged; counts and search reuse the
  existing column mapping.
- `lib/core/utils/igdb_query_builder.dart` — the precedent for query-syntax knowledge
  living in `core/utils/`; `postgrest_utils.dart` sits beside it (D-I).
- `restartable()` / `droppable()` from `bloc_concurrency` — already a dependency, and it
  **stays**: `stream_transform` has no equivalent (D-H).
- `stream_transform`'s `debounce()` and `merge()` — already resolved at 2.1.1 in the lock
  file; declaring it replaces a hand-rolled `Future.delayed` (D-H, D-D).
- `LibraryStatsCubit`, `featured_screen.dart` — **not modified.** Both already read
  `snapshot.totalGamesCount`, `snapshot.ownedGameIds` and `snapshot.nowPlayingGames`, so
  repointing the snapshot's source satisfies 3.4-AC28 without touching either file.

---

## Caveats that need execution to settle

Per the Tech Lead skill's no-shell rule, each states how it was reasoned and what Dev
should do if it does not hold. Dev records the outcome as a self-correction note either
way.

1. **The composed query transformer subscribes to the event stream twice** — once for
   the `LibrarySearchTermChanged` branch it debounces, once for everything else.
   Reasoned from source, not executed: `bloc-9.0.0/lib/src/bloc.dart:67` creates
   `_eventController` as a **broadcast** controller, and `:196` hands the transformer
   `_eventController.stream.where(...).cast<E>()`, which stays broadcast — so two
   listeners are legal and neither steals events from the other. `stream_transform`'s
   `debounce` and `merge` both preserve broadcast-ness
   (`rate_limit.dart:31`, `merge.dart:50-53`).
   *Fallback if a second-listener error appears at runtime:* take
   `events.asBroadcastStream()` once at the top of the transformer and branch off that.
   *Fallback if that also fails:* debounce the whole `LibraryQueryChanged` stream with a
   single `events.debounce(...)` before `restartable()`. That still satisfies 3.4-AC8 and
   3.4-AC42; it costs a 300 ms delay on chip and sort taps and on the initial load, which
   is worse but correct. **Do not go back to `await Future.delayed` inside the handler**
   — that is the shape D17.6 removed.
2. **Search-term encoding.** See the Data layer caveat above — comma handling and
   percent-encoding. *Fallback:* PostgREST double-quote the pattern, inside
   `postgrestLikePattern`.
3. **The datasource test harness (3.4-AC37/AC38).** A real `SupabaseClient` cannot read a
   session without one being installed, and `package:http` is not a declared dependency,
   so `MockClient` would add an info lint. The path that needs neither: bind a
   `dart:io` `HttpServer` on the loopback interface, point a real `SupabaseClient` at it,
   install a session with `client.auth.setInitialSession(jsonEncode(...))` — which
   assigns `_currentSession` with no network (`gotrue-2.26.0/lib/src/gotrue_client.dart:1138-1156`)
   — and assert on the recorded request URI and body. Close the server and call
   `client.dispose()` in `tearDown`, or the isolate the client spawns can hang the run.
   *Fallback:* if this cannot be made to work inside the self-correction budget,
   **escalate** — do not add `http` to `pubspec.yaml` (the `stream_transform` line of
   D-H is the only authorised edit to that file) and do not downgrade the test to
   asserting nothing.

---

## Out of scope

- The Library screen and all its widgets, the filter sheet, the rating input, recent
  searches, scroll restore — Stage 4 / item 4.6, per `tech-ac.md ## Out of scope`.
- `GamesBloc`'s three failures — its shape is a constraint here, not a target.
- The Isar read cache, IGDB refresh, task-tree backup (D12); any Isar → Supabase
  migration.
- `getThisWeekPlayHours()` and the genre derivation — both stay on Isar.
- Deleting `library_stats.dart`'s unreachable branch 2 — see D-A and `## Known gaps`.
- **`TrackerPreferencesDatasource`, `TrackerSortRepository(Impl)`, `TrackerCubit`, the
  two tracker sort use cases and `tracker_sort_repository_test.dart`** — none is renamed,
  moved, extended or edited, and `tracker_sort_tag` keeps its name and semantics
  (3.4-AC22, D17.1). Not in the allowlist.
- Anything else in the tracker tree: `tracker_game_detail_screen.dart`,
  `task_detail_screen.dart`, `TaskCubit`, `GroupTask`, `SavedGameTask`, `TaskStep` and
  every `SavedGame` field stay exactly as they are (3.4-AC32).
- Any `pubspec.yaml` edit beyond the single `stream_transform` line (D-H).

## Open questions

None. Every ambiguity the BA left open is settled in `## Design decisions settled here`,
and D17 closed the four the Phase 3 gate raised.

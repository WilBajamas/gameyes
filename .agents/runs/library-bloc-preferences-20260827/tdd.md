# Technical Design Document
Source: `.agents/runs/library-bloc-preferences-20260827/tech-ac.md` (item 3.4 —
`LibraryBloc`, preferences, and the Featured repair)
Date: 2026-08-28

## Feature summary

The Library gains a screen-scoped `LibraryBloc` that owns status filter, sort, view
mode, search term, pagination and counts, over a data layer extended in three ways: a
search predicate on the paged query, a database-computed count capability, and an
unpaged status read that Featured consumes. Preferences move to one shared
`SharedPreferences` datasource in `core/`, keeping the tracker's key and semantics
untouched while adding two new library keys behind a second, library-owned repository.
Featured's now-playing shelf, wishlist stat, total and owned ids are repointed off the
never-matching Isar filters onto `library_entries` through the `LibraryRepository`
interface, and the now-playing seam is **retyped** so no Isar-shaped identifier exists
on it at all. No screen and no new widget: Stage 4 composes this.

## Layer map

| Criterion | Layers |
|---|---|
| 3.4-AC1, AC3–AC5, AC9–AC12, AC25 | state |
| 3.4-AC2, AC6–AC8 | state, domain, data |
| 3.4-AC13–AC17 | domain, data (Supabase) |
| 3.4-AC18–AC21 | data (Supabase) |
| 3.4-AC22–AC24 | data (SharedPreferences), domain |
| 3.4-AC26–AC28, AC30, AC33, AC34 | data, domain |
| 3.4-AC29 | UI |
| 3.4-AC31 | domain (entity retype) |
| 3.4-AC32 | none — invariant to protect |
| 3.4-AC35, AC37–AC40 | test |
| 3.4-AC36 | manual |
| 3.4-AC41 | constraint |

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

**The count line's own figure is free.** `.select().count(CountOption.exact)` "respects
any filters but ignores modifiers" (`postgrest_transform_builder.dart:202-206`), so the
paged query already knows how many rows matched status **and** search, ignoring
limit/offset. `fetchPage` therefore returns `LibraryPageEntity(entries, matchedCount)`
and 3.4-AC16's "separate value" costs no extra round trip and can never be torn against
the page it describes.

On 3.4-AC18's "byte-identical" clause: adding the count modifier changes a request
*header* (`Prefer: count=exact`), not the path, the predicates, the ordering or the
range. The criterion's failure case is about predicates and client-side filtering, and
no predicate changes for a no-search call. Flagged here so QA reads it as considered
rather than missed.

### D-C. Preferences — one shared datasource, two repositories

The item says "rename and extend rather than writing a second one". That is honoured at
the **datasource** layer and deliberately not at the repository layer:

- `TrackerPreferencesDatasource` moves and is renamed to `AppPreferencesDatasource`
  (`lib/core/data/datasource/app_preferences_datasource.dart`), gaining two read/write
  pairs for the library keys. The `tracker_sort_tag` key, its default and its
  swallow-on-failure semantics are unchanged (3.4-AC22). Verified against source: this
  class has exactly one consumer, `TrackerSortRepositoryImpl`, and one test that mocks
  it (`test/repository/tracker/tracker_sort_repository_test.dart:12`).
- `TrackerSortRepository` / `TrackerSortRepositoryImpl` **keep their names and their
  interface** and change only the datasource type they hold. A second, library-owned
  `LibraryPreferencesRepository` is added.

**Why the repository is not merged.** Merging would make one interface import
`SavedGameFilterTag` (tracker) and `LibraryViewMode` + `LibrarySort` (library), and
would hand `TrackerCubit` a contract with three members it never calls. That is an
interface-segregation break across two feature domains for no saving — the duplication
the item warns about is the `SharedPreferences` plumbing, and that is now in exactly one
place. Stated plainly because it reads against the brief's literal wording; overrule at
the Phase 3 gate if the merged shape is wanted.

`TrackerCubit`'s widget-less status was confirmed against source, matching
OBSERVATION-4: it is DI-registered (`service_locator.config.dart:369`) with no widget
caller anywhere in `lib/`, so the rename's blast radius is one impl, one test file and
the generated DI config.

Both preference repositories keep the tracker's **synchronous, non-`Result`,
contractually non-throwing** shape (`tracker_sort_repository.dart:3-8`) rather than the
project's `Future<Result<T>>` default. That deviation already exists, is documented on
the existing interface, and is what makes 3.4-AC24 ("a write that throws is swallowed
and surfaces no error to the caller") expressible at all. Extending it is the
consistent choice; introducing `Result` here would force the bloc to handle a failure
the criteria forbid it from surfacing.

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
   single `on<LibraryQueryChanged>(..., transformer: restartable())`. This is not
   cleverness for its own sake: with one `on<>` per event type, a chip tap during an
   in-flight search fetch runs on a *different* stream, the two requests race, and the
   loser can emit last with stale rows. One handler and one transformer make the latest
   query authoritative by construction, which is what 3.4-AC2's "the results are the
   intersection" needs to be true under real timing.

**How 3.4-AC25 is still met with an empty constructor.** The stored view mode and sort
are read (synchronously — `SharedPreferences.getString` is synchronous on an already
resolved instance) inside the `LibraryStarted` branch of the handler and folded into the
**same** emit that sets `loading`. There is no emit in the default view mode carrying
content, so there is no visible switch. The one frame before the handler runs is at
`LibraryLoadStatus.initial`, which is why `initial` and `loading` are separate enum
values: Stage 4 renders nothing at `initial` and skeletons at `loading`.

**How the 300 ms debounce is done without a new package** (3.4-AC8). `rxdart` and
`stream_transform` are not direct dependencies and adding one is an escalation, so the
debounce is `restartable()` plus an `await Future<void>.delayed(...)` at the top of the
handler, taken only when the event is a `LibrarySearchTermChanged`, followed by an
`if (emit.isDone) return;` guard. Verified against
`bloc-9.0.0/lib/src/emitter.dart:135,139-145`: `restartable()` is `switchMap`
(`bloc_concurrency-0.3.0/lib/src/restartable.dart:13`), a superseded handler's emitter
is cancelled, `isDone` becomes true and `call()` is already a no-op — the guard exists
to skip the use-case call, not to avoid a throw. Three keystrokes inside the window
therefore produce one query, which is exactly 3.4-AC8.
The search term is written into state **before** the delay, so a chip tap that
supersedes a pending search still composes with the term the person typed (3.4-AC2's
"setting a search term does not clear the status; changing the status does not clear the
search term"). Emitting per keystroke is not a query per keystroke.

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

### D-F. Module folder vs flat file — no new module folder

Every new file has an unambiguous home in a layer folder the feature already has from
3.3 (`domain/entities`, `domain/use_cases`, `domain/repositories`, `data/repositories`,
`presentation/blocs`). Grouping the preferences work into its own module folder would
put a repository interface outside `domain/repositories`, which is where every reader
and every other feature looks for one. The bloc, its `part` event file and its state
file sit flat in `presentation/blocs/` exactly as `games_bloc.dart` does. One placement
does move: the shared preferences datasource goes to `lib/core/data/datasource/`, which
`flutter-arch.md:35` currently describes as "BaseRepositoryMixin only" — a widening of
that folder's contents, deliberate and noted, not a new mechanism.

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

Search pattern (3.4-AC18–AC21): `'%${escaped}%'` where `escaped` replaces `\`→`\\`,
then `%`→`\%`, then `_`→`\_`, in that order. Postgres `ILIKE` uses backslash as its
default escape character, so the escaped pattern matches those characters literally and
cannot widen the match. `ilike` is appended as an ordinary filter alongside the status
`eq`, so the predicates combine by AND, the limit/offset apply to the filtered set, and
`order` is unchanged with or without a term — 3.4-AC20 and 3.4-AC21 fall out of using
one query rather than two paths.

**Caveat (not executable here).** Two things about the built request cannot be settled
without running code: whether a comma in the term survives as a literal, and the exact
percent-encoding of the pattern. Reasoning: `postgrest_builder.dart:395-400` builds the
filter through `Uri.replace(queryParameters:)`, and Dart percent-encodes query values,
so a comma should arrive as `%2C` and cannot split the predicate. **Fallback if the
datasource test shows a raw comma in the built URL:** wrap the pattern in PostgREST
double quotes rather than removing the character. Dev records the actual encoded form as
a self-correction note either way.

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
`AppPreferencesDatasource`, matches enum names to stored strings by `.name` with a
default fallback, exactly as `TrackerSortRepositoryImpl.getSortTag()` does today.

**`FeaturedRepositoryImpl` (modify)** — gains `LibraryRepository` as a third
constructor dependency (the domain interface, not the impl).
- `getLibrarySnapshot()` — starts `fetchAllEntries()` and `fetchCounts()` concurrently,
  keeps `getThisWeekPlayHours()` on Isar. `totalGamesCount` ← `counts.total`;
  `wishlistCount` ← `counts.byStatus[wishlist]`; `nowPlayingGames` ← entries filtered to
  `playing` (order preserved from the query) mapped to `NowPlayingGameEntity`;
  `ownedGameIds` ← every entry's `igdbId`. A `Failure` on either read degrades to an
  empty list / null counts and the snapshot **still returns `Success`** (3.4-AC33).
- `getCountdownGame()` and `getOutThisWeekGames()` — wishlist ids come from
  `fetchAllEntries(status: wishlist)` mapped to `igdbId`; a `Failure` degrades to an
  empty set. These are 3.4-AC27's two unnamed callers and they are fixed in the same
  pass as the visible stat.

### Datasources

**`LibraryRemoteDatasource` (modify)** — `fetchPage` gains `String? searchTerm` and
returns `(List<LibraryEntryModel> rows, int matchedCount)`; new `fetchCounts()` →
`Map<LibraryStatus, int>` (six concurrent head counts via `Future.wait`) and
`fetchAllEntries({LibraryStatus? status})` → `List<LibraryEntryModel>`. `_currentUserId`,
`_sortColumn` and the `clearRating` pair are untouched — in particular the
human-approved `use_null_aware_elements` lint at `:101` stays exactly as it is.

**`AppPreferencesDatasource` (create; replaces `TrackerPreferencesDatasource`)** —
`lib/core/data/datasource/app_preferences_datasource.dart`, `@injectable`, holds
`SharedPreferences`. Three read/write pairs, each wrapped in the existing swallow-on-
failure try/catch: `readTrackerSortTagName`/`writeTrackerSortTagName` (unchanged key and
semantics), `readLibraryViewModeName`/`writeLibraryViewModeName`,
`readLibrarySortName`/`writeLibrarySortName`. Named methods per preference rather than a
generic `readString(key)` — `flutter-datasource` forbids wrapping `SharedPreferences` in
pass-throughs, and named methods keep the keys off the call sites. Keys live in
`StorageConstants` (`lib/core/res/const.dart`) beside `trackerSortTagKey`.
`lib/features/tracker/data/datasources/local/tracker_preferences_datasource.dart` is
deleted in the same step.

**`FeaturedLocalDatasource` (modify)** — `countSavedGames`, `getOwnedGameIds`,
`getWishlistedGames` and `getNowPlayingGames` are removed; they are the four dead Isar
reads this item exists to retire and nothing else calls them. `getThisWeekPlayHours`,
`getSavedGames` and the genre-preference pair stay untouched, so the This Week tile and
the genre derivation are unaffected. No `SavedGame` field is removed and
`SavedGame.toEntity()` keeps its caller in `TrackerRepositoryImpl` — 3.4-AC32 holds.

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
| `entries` | `List<LibraryEntryEntity>` | `[]` | AC1 |
| `status` | `LibraryLoadStatus` | `initial` | AC1, AC9, AC11 |
| `nextPageStatus` | `LibraryNextPageStatus` | `initial` | AC9 |
| `hasReachedEnd` | `bool` | `false` | AC7 |
| `counts` | `LibraryCountsEntity?` | none | AC13, AC15, AC17 |
| `matchedCount` | `int` | `0` | AC16 |
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

**Events** — `library_event.dart`, `part of 'library_bloc.dart'`:

```
LibraryEvent (sealed, Equatable)
├── LibraryQueryChanged (sealed) ......... resets pagination, refetches page 1
│   ├── LibraryStarted ................... caller's initial load; also reads preferences
│   ├── LibraryStatusSelected(status?)
│   ├── LibrarySortSelected(sort)
│   ├── LibrarySearchTermChanged(term) ... debounced
│   └── LibraryRetried
├── LibraryViewModeSelected(viewMode) .... no fetch
└── LibraryNextPageRequested ............. appends
```

**Handlers**

| Registration | Transformer | Behaviour |
|---|---|---|
| `on<LibraryQueryChanged>` | `restartable()` | see below |
| `on<LibraryViewModeSelected>` | none (synchronous) | emits `viewMode` only; persists fire-and-forget; entries, status, sort and term untouched (AC5, AC23) |
| `on<LibraryNextPageRequested>` | `droppable()` | returns immediately when `hasReachedEnd` or `status != success`; otherwise emits `nextPageStatus: loading`, fetches at `offset: state.entries.length`, appends (AC6, AC7, AC9, AC10) |

`_onQueryChanged`, in order:

1. Resolve the new query from `state` plus the event's own field — `LibraryStarted`
   reads `sort` and `viewMode` from `GetLibraryPreferencesUseCase`, every other event
   inherits them from state.
2. Emit once: the new field, the resolved preferences, `status: loading`,
   `entries: []`, `hasReachedEnd: false`, `nextPageStatus: initial`, `error: null`.
   This single emit is what makes 3.4-AC3, AC4, AC7 and AC25 hold together.
3. If the event is `LibrarySearchTermChanged`: `await Future.delayed(searchDebounce)`,
   then `if (emit.isDone) return;`. The term is already in state from step 2, so a
   superseding event composes with it (AC2, AC8).
4. If the event is `LibrarySortSelected`, persist the sort, fire-and-forget (AC23).
5. Start `FetchLibraryPageUseCase(status: activeStatus, sort:, limit: pageSize,
   offset: 0, searchTerm: term.isEmpty ? null : term)` and, **only when
   `state.counts == null`**, `FetchLibraryCountsUseCase()` — concurrently. Await both.
6. Emit once, from an exhaustive `switch` over each `Result`:
   `Success` → `status: entries.isEmpty ? empty : success`, `entries`,
   `matchedCount`, `hasReachedEnd: entries.length < pageSize`, and `counts` when the
   counts call succeeded; a counts `Failure` leaves `counts` null and does **not** fail
   the page. `Failure` on the page → `status: failed, error:` (AC10, AC11).

The search term is trimmed on entry, so a whitespace-only term is stored as `''` and
sent as `null` — no `ilike` filter is appended at all, which is what "treated as no
search" means at the wire level (AC8).

Every emit is built from `state.copyWith(...)` read at emit time, never from a snapshot
captured before the await, so a view-mode change during an in-flight fetch survives the
fetch's own emit.

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
- `TrackerPreferencesDatasource` — renamed and extended rather than duplicated, per the
  item. Its swallow-on-failure try/catch is the shape 3.4-AC24 asks for and is reused
  verbatim for the new keys.
- `TrackerSortRepositoryImpl.getSortTag()`'s "match `.name`, fall back to the default"
  loop — reused shape for both library preference reads.
- `postgrest`'s `count(CountOption.exact)` — the count capability is the package's own
  head-count request, not a hand-rolled aggregate.
- `LibraryEntryModel` / `LibraryStatusColumn` — unchanged; counts and search reuse the
  existing column mapping.
- `restartable()` / `droppable()` from `bloc_concurrency` — already a dependency; no new
  package for the debounce (see D-D).
- `LibraryStatsCubit`, `featured_screen.dart` — **not modified.** Both already read
  `snapshot.totalGamesCount`, `snapshot.ownedGameIds` and `snapshot.nowPlayingGames`, so
  repointing the snapshot's source satisfies 3.4-AC28 without touching either file.

---

## Caveats that need execution to settle

Per the Tech Lead skill's no-shell rule, each states how it was reasoned and what Dev
should do if it does not hold. Dev records the outcome as a self-correction note either
way.

1. **The `restartable()` + delay debounce.** Reasoned from `bloc-9.0.0`'s emitter source
   and `bloc_concurrency`'s `switchMap`; not executed. *Fallback:* if a superseded
   handler throws rather than no-ops, move the guard to `if (emit.isDone) return;`
   immediately before **every** emit in the handler. Do not add a package.
2. **Search-term encoding.** See the Data layer caveat above — comma handling and
   percent-encoding. *Fallback:* PostgREST double-quote the pattern.
3. **The datasource test harness (3.4-AC37/AC38).** A real `SupabaseClient` cannot read a
   session without one being installed, and `package:http` is not a declared dependency,
   so `MockClient` would add an info lint. The path that needs neither: bind a
   `dart:io` `HttpServer` on the loopback interface, point a real `SupabaseClient` at it,
   install a session with `client.auth.setInitialSession(jsonEncode(...))` — which
   assigns `_currentSession` with no network (`gotrue-2.26.0/lib/src/gotrue_client.dart:1138-1156`)
   — and assert on the recorded request URI and body. Close the server and call
   `client.dispose()` in `tearDown`, or the isolate the client spawns can hang the run.
   *Fallback:* if this cannot be made to work inside the self-correction budget,
   **escalate** — do not add `http` to `pubspec.yaml` and do not downgrade the test to
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
- Anything in the tracker tree beyond the datasource move: `tracker_game_detail_screen.dart`,
  `task_detail_screen.dart`, `TaskCubit`, `GroupTask`, `SavedGameTask`, `TaskStep` and
  every `SavedGame` field stay exactly as they are (3.4-AC32).

## Open questions

None. Every ambiguity the BA left open is settled in `## Design decisions settled here`.

**Not an open question, but a gate item:** the implementation plan needs 26 non-generation
steps against the pipeline's 20-step ceiling, so `escalation.md` is open with a
recommended split at the Featured seam. The design above is complete either way — a
split changes which steps run in which pass, not what gets built.

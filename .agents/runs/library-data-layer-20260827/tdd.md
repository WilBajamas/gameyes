# Technical Design Document
Source: `.agents/week-3-task-briefs.md` item 3.3 (lines 211–232), via `tech-ac.md`
Date: 2026-08-27

## Feature summary

One additive SQL migration widens `public.library_entries` with six columns and
three check constraints, touching nothing that already exists on the table. On the
app side a new `library` data layer lands: a freezed `LibraryEntryModel` on the
column names, a hand-written `LibraryStatus` ↔ column-value mapping, a
`LibraryRemoteDatasource` that builds every filter/order/range server-side against
the injected `SupabaseClient`, a `LibraryRepository` + impl on `Result<T>`, and
four use cases. `BaseRepositoryMixin` gains two catch clauses and `ErrorType` four
variants so a unique conflict, a check violation and an RLS denial stop collapsing
into `ErrorType.unknown()`. Separately, `LibrarySnapshotEntity.nowPlayingGames` is
retyped from the Isar `SavedGame` to the existing domain
`TrackerSavedGameEntity`, which gains the three progress fields Featured reads, so
the sole surviving push into the dormant tracker tree keeps working. Scope stops at
the use cases.

## Layer map

- 3.3-AC1 … 3.3-AC7: storage (SQL migration)
- 3.3-AC8, 3.3-AC10: data (status ↔ column mapping)
- 3.3-AC9: test
- 3.3-AC11: data (model → entity), repository
- 3.3-AC12, 3.3-AC13: data (model)
- 3.3-AC14, 3.3-AC15: domain (entity)
- 3.3-AC16 … 3.3-AC20: data (datasource query), domain (use case input)
- 3.3-AC21 … 3.3-AC25: data (datasource), repository
- 3.3-AC26: domain (use case) → repository → data → storage
- 3.3-AC27, 3.3-AC28, 3.3-AC29: core data (mixin + `ErrorType`), repository
- 3.3-AC30: storage (manual, on device)
- 3.3-AC31: domain (`LibrarySnapshotEntity`), core domain (`TrackerSavedGameEntity`)
- 3.3-AC32, 3.3-AC33: UI (`library_stats.dart`)
- 3.3-AC34: data (`FeaturedRepositoryImpl` keeps its `FeaturedLocalDatasource` source)
- 3.3-AC35: data (Isar `SavedGame` — additive mapping only, no field removed)

Note on wording: `tech-ac.md` says "DTO" as a generic term for the data-layer
model. The concrete type this design creates is `LibraryEntryModel` — see D-G.

---

## Design decisions this item was asked to settle

### D-A — `PostgrestException` is mapped by widening `BaseRepositoryMixin` (3.3-AC27)

**Decision: widen the mixin, and add four `ErrorType` variants.** Not mapped at the
datasource.

Why not the datasource: `fetchData<T>()` swallows anything that is not a
`DioException` or a `FunctionException` into `ErrorType.unknown()` at
`base_repository_mixin.dart:17-19`. A datasource that classifies the error still has
to hand its result to the repository, and the only way the repository can keep that
classification is to stop calling `fetchData` and hand-roll try/catch — which the
`flutter-repository` skill lists under "what NOT to do". So "map at the datasource"
really means "skip the mixin", and it buys a second error convention in the app.

Cost of widening, weighed rather than waved through: the mixin has three users —
`GamesRepositoryImpl`, `GameDetailRepositoryImpl`, `FeaturedRepositoryImpl`. The
change is **additive and inert for all three**: a new `on PostgrestException` clause
above the existing `catch (_)`. None of the three can raise one — they reach
Supabase only through `functions.invoke`, which raises `FunctionException`, already
handled. `SupabasePing` is the only current `.from()` caller and is not a repository.
No behaviour changes for any existing caller; any code path that reaches the new
clause today would have returned `ErrorType.unknown()` instead.

This is a shared-file change. It is **not escalated** because the orchestrator's task
prompt delegates this exact call to the Tech Lead, and `tech-ac.md` 3.3-AC27 states
the same. Flagged here so the Phase 3 human sees it as a shared-code touch rather
than discovering it in the diff.

Mapping, on `PostgrestException.code` (a `String?`,
`postgrest-2.8.0/lib/src/types.dart:9-13`), which carries the Postgres SQLSTATE:

| Code | Meaning | `ErrorType` |
|---|---|---|
| `23505` | unique violation on `library_entries_user_igdb_unique` | `duplicateEntry()` |
| `23514` | check violation (`rating`, `progress_percent`, `playtime_hours`, `status`) | `invalidValue()` |
| `42501` | insufficient privilege — RLS with-check denial | `notAllowed()` |
| anything else | — | `responseError(message:, error: code, statusCode:)` |

The fall-through keeps a `PGRST*` error (e.g. `PGRST116`, "no row returned") out of
`unknown()` too, so nothing that reaches this clause is opaque.

Second new clause: `on AuthSessionMissingException` → `ErrorType.notSignedIn()`
(3.3-AC29). `AuthSessionMissingException` is Supabase's own type
(`gotrue-2.26.0/lib/src/types/auth_exception.dart:44`) meaning exactly this, so the
datasource throws the real thing rather than a project-invented exception.

New `ErrorType` variants: `duplicateEntry`, `invalidValue`, `notAllowed`,
`notSignedIn`. Precedent: `ErrorType.signInCancelled()` was added the same way for
the same reason. Nothing in `lib/` switches exhaustively over `ErrorType` — the only
pattern match is `sign_in_cubit.dart:25` — so adding variants breaks no caller.

**Deliberately not added:** a variant for the malformed-status row (3.3-AC11). That
criterion asks only that the read *fails* rather than defaulting a status; the
`FormatException` thrown by `toEntity()` lands on `catch (_)` → `unknown()`, which
satisfies it. If item 3.4 wants to say "this row is broken" in words, it adds the
variant then. Four new variants is already the ceiling of what the criteria buy.

### D-B — the `LibrarySnapshotEntity` seam breaks onto `TrackerSavedGameEntity`

**Decision: reuse the existing domain entity, extended by three nullable fields; do
not invent a new seam type.**

`TrackerSavedGameEntity` (`lib/core/domain/entities/tracker_saved_game_entity.dart`)
is already a freezed domain entity, already carries `name`, `imageUrl` and
everything else `library_stats.dart` reads, and is **already the argument type
`TrackerGameDetailRoute` takes** (`tracker_game_detail_screen.dart:19`). It is
missing exactly three fields: `hoursLogged`, `averageCompletionHours`,
`manualProgressPercentage`. Add them as nullable optional fields and map them in
`SavedGame.toEntity()`.

Consequences, each pinned to a criterion:
- 3.3-AC31 — `LibrarySnapshotEntity.nowPlayingGames` becomes
  `List<TrackerSavedGameEntity>` and the file's only import becomes
  `core/domain/entities/tracker_saved_game_entity.dart`. Nothing from
  `features/tracker/data/`.
- 3.3-AC32 — `library_stats.dart:317-319` gets **simpler**, not deleted:
  `TrackerGameDetailRoute(game: topGame)` instead of
  `TrackerGameDetailRoute(game: topGame.toEntity())`. The `.toEntity()` call moves
  up into `FeaturedRepositoryImpl.getLibrarySnapshot`, which is where a data model
  should have become a domain entity all along. The push, the route and the whole
  dormant tracker tree behind it stay reachable.
- 3.3-AC33 — every field the widget reads is present, with the same values from the
  same rows, so the rendered output is unchanged. The `manualProgressPercentage` /
  `hoursLogged` / `averageCompletionHours` branch at `:287-305` is **retyped, not
  deleted**; whether it ever fires is item 3.4's Featured repair.
- 3.3-AC34 — `getLibrarySnapshot` still calls `FeaturedLocalDatasource`. Only the
  type crossing the repository boundary changes.
- 3.3-AC35 — `SavedGame` loses nothing; `toEntity()` gains three lines.

Rejected alternative: a new `NowPlayingGameEntity` wrapping the tracker entity plus
the three fields. It would force `library_stats.dart` to reach through a wrapper
(`topGame.game.name`) and would add a type whose only job is to hold three fields
that belong on the entity anyway.

### D-C — the §5 grid-meta example correction lands in this run

**Decision: yes, correct `library-design-conventions.md` in this run.** D11 left the
scoping to me.

For: item 3.1 set the precedent (correct the design doc in the run that invalidates
it), the run already writes a non-Dart file (the migration), the edit is one line,
and the failure mode of deferring is concrete — the next BA reads `PS5 · 24h · Ch. 9`
and re-derives a chapter column, which is the exact class of defect this item exists
to clear. Against: a data-layer run widening its allowlist by a doc. The one-line
edit wins.

**Note for the record:** the example is at **line 67, which is inside §5 (Grid
view)**, not §6 (List view). D11 and `ambiguities.md` both call it "§6". §6 contains
no chapter example. The correction target is line 67.

Edit: the three examples become `PS5 · 24h`, `NSW · Added 3d ago`,
`PS5 · Out 14 Aug`, with a short parenthetical recording D11 — matching how §11
already records the flat-fill decision inline. The *rule* text
(`platform · contextual number`) is already correct and is not touched.

### D-D — the status serialiser is hand-written, not annotated

**Decision: a hand-written extension on `LibraryStatus`, in the data layer.** Not
`@JsonValue` annotations on the enum, and not `@JsonKey(unknownEnumValue:)`.

The deciding criterion is 3.3-AC10: adding a seventh status must be a **compile-time
break**. A `switch` expression over the enum with no `default` gives exactly that —
Dart's exhaustiveness check plus this project's `no_default_cases` lint
(`dart-style.md`). `@JsonValue` gives the opposite: a seventh value with no
annotation silently serialises to its `.name`, which is how `onHold` → `'onHold'`
gets into the app in the first place (3.3-AC8).

Supporting reasons: 3.3-AC9 wants each of the six values asserted individually, and
a plain function is directly callable without constructing a model; and it keeps
`json_annotation` out of `lib/core/enums/library_status.dart`, which global widgets
(`status_chip.dart`, `cover_tile.dart`, `game_card.dart`) import.

Shape: `extension LibraryStatusColumn on LibraryStatus` with `String get
columnValue` and `static LibraryStatus? fromColumnValue(String value)`, in
`lib/features/library/data/models/library_status_column.dart`. Named for what it is
— the value stored in the `status` column. `fromColumnValue` returns `null` for an
unrecognised string; the model turns that null into a `FormatException` so the read
fails (3.3-AC11) instead of defaulting.

The **sort** mapping (3.3-AC17) gets the same no-`default` switch treatment but
stays a private method inside the datasource: it is used in exactly one place — the
query — has no second caller and no test of its own, and a separate file would be a
one-use indirection.

### D-E — flat files, no module folder

**Decision: flat files, one type per file, under the standard
`data/` / `domain/` layer folders. No `library_entry/` module folder.**

The module-folder rule is a **widget** rule and — since its 2026-08-25 correction —
is explicitly per-component, not absolute: it earns its place for "a variant enum, a
`CustomPainter`, or several sub-widgets", and the skill lists five folders and four
deliberate flat files as both being correct. None of that reaches the data layer,
where `flutter-arch.md`'s three-layer folder structure and `dart-style.md`'s
one-file-per-type naming table already answer the question, and where every existing
model, datasource, repository and use case in the tree is a flat file. Nothing here
has a variant enum or internal sub-parts to hide.

The one folder that is new is `lib/features/library/{data,domain}/` itself, plus
`lib/features/library/const.dart` at the feature root for the table and column
names — `flutter-arch.md` sanctions a feature-level `const.dart` and this feature
now has more than one or two of them.

### D-F — counts, and whether item 3.4 is buildable without them

`tech-ac.md ## Out of scope` flags that nothing provides a count after this item.
**My read: 3.4 is buildable, and no fifth use case is added here.** The count line
(§8) and the per-chip counts (§3) need a filtered count and a library total; both
are one extra method on this same datasource using PostgREST's count option, plus
one use case, and both belong with the state that renders them. Adding them here
would ship two use cases with no caller for a week — the same "no writer / no
reader" defect D11 railed against. **Item 3.4's brief must name the count capability
as its own work**; if it does not, its BA will find a spec line it cannot serve.
Flagged, not invented.

### D-G — the data model is `LibraryEntryModel`, never `LibraryEntryDto`

**Decision (D13, Phase 3 gate): the class is `LibraryEntryModel` and the file is
`lib/features/library/data/models/library_entry_model.dart`.** The earlier draft of
this design called it `LibraryEntryDto`; that name is withdrawn.

Reasons, recorded so this is not re-argued:
- The tree contains **zero** `*_dto.dart` files. Every existing data model is either
  a bare noun (`game.dart`, `saved_game.dart`) or `*_model.dart`
  (`games_model.dart`, `game_detail_model.dart`).
- The `flutter-dto` skill's own naming rule is `File: [entity_name].dart`. The skill
  is only *named* "dto"; it never prescribes the suffix, so following the skill and
  dropping `Dto` are the same act.
- `LibraryEntryModel` reads correctly opposite `LibraryEntryEntity`, which is the
  pairing every consumer of this layer will see.

`tech-ac.md` is unaffected: it uses "DTO" only as a generic term for the data-layer
model and contains no occurrence of the concrete class or file name, so no criterion
moved. The rest of this document uses "model" for the same generic sense.

---

## Data layer

### Storage — migration

`supabase/migrations/20260827120000_library_entries_details.sql` (create).

- `alter table public.library_entries add column …` for the six columns:
  `platform text`, `rating int`, `playtime_hours numeric`,
  `progress_percent numeric`, `genre text`,
  `updated_at timestamptz not null default now()` (3.3-AC1).
- All five new nullable columns carry no default. `updated_at` is `not null` **with**
  a default, which is what lets it apply to a table that already holds rows;
  Postgres backfills existing rows with `now()` (3.3-AC2).
- Three named check constraints added in the same file (3.3-AC3, 3.3-AC4, 3.3-AC5):
  `rating` in 1–10, `progress_percent` in 0–100, `playtime_hours >= 0`. Each written
  as `x is null or …` — a bare `check` already passes on `null`, but spelling it out
  is what the reader needs to see, given 3.3-AC3 exists precisely because `0` must
  not mean "unrated".
- **No** `alter … drop constraint` on `status`, no wishlist boolean, no chapter
  column, no table drop/recreate, no policy or index statement (3.3-AC6, 3.3-AC7).
- The three existing migrations are not opened (3.3-AC1). Nothing in this pipeline
  applies the file to the remote project.
- **No `updated_at` trigger.** Inserts get the column default (server clock);
  updates send the value explicitly (3.3-AC24). A trigger would be more robust but
  is not in the six columns 3.3-AC1 names, and nothing sorts on the column. Recorded
  as the follow-up if the audit value ever becomes load-bearing.

### Models

`LibraryEntryModel` (create) —
`lib/features/library/data/models/library_entry_model.dart`
— `@freezed sealed class` + `const LibraryEntryModel._();` + `fromJson`.
Fields, all `@JsonKey(name: …)` against `LibraryEntryConstants` so the model and the
datasource share one source of truth for column names (3.3-AC12):

| Dart | Type | JSON key | Nullable |
|---|---|---|---|
| `id` | `String` | `id` | no |
| `userId` | `String` | `user_id` | no |
| `igdbId` | `int` | `igdb_id` | no |
| `title` | `String` | `title` | no |
| `coverUrl` | `String?` | `cover_url` | yes |
| `releaseDate` | `DateTime?` | `release_date` | yes |
| `status` | `String` | `status` | no |
| `createdAt` | `DateTime` | `created_at` | no |
| `platform` | `String?` | `platform` | yes |
| `rating` | `int?` | `rating` | yes |
| `playtimeHours` | `double?` | `playtime_hours` | yes |
| `progressPercent` | `double?` | `progress_percent` | yes |
| `genre` | `String?` | `genre` | yes |
| `updatedAt` | `DateTime` | `updated_at` | no |

Every nullable field is declared `T?` with no `@Default`, so a null column
deserialises to `null` and never to `0`, `0.0` or `''` (3.3-AC13).

`status` is held as the **raw column string**, not as `LibraryStatus`, so that
parsing happens in `toEntity()` where it can fail loudly:
`toEntity()` calls `LibraryStatusColumn.fromColumnValue(status)` and throws
`FormatException` when it returns null (3.3-AC11). The model is read-only in practice
— write payloads are built as maps in the datasource (see 3.3-AC23) — but `toJson`
exists and is exercised by the test.

Naming follows D-G / D13: `LibraryEntryModel` in `library_entry_model.dart`, matching
`games_model.dart` and `game_detail_model.dart` already in the tree, and matching
`dart-style.md`'s rule that the file is the class in snake_case. The item brief's
word "DTO" is generic, not a class name.

`LibraryStatusColumn` (create) — `lib/features/library/data/models/library_status_column.dart`
— extension on `LibraryStatus`. `String get columnValue` is a no-`default` switch
producing the six literals `playing`, `backlog`, `completed`, `on_hold`, `wishlist`,
`dropped`; `static LibraryStatus? fromColumnValue(String)` is its inverse, returning
null for anything else (3.3-AC8, 3.3-AC10, 3.3-AC11).

`LibraryEntryConstants` (create) — `lib/features/library/const.dart` — `static const`
table name and column names. Used by the model's `@JsonKey`s and by every `eq`,
`order` and payload key in the datasource.

`LibrarySort` (create) — `lib/core/enums/library_sort.dart` — `recentlyAdded`,
`alphabetical`, `releaseDate`, `rating`, `playtime`
(`library-design-conventions.md:54`). Placed beside `library_status.dart` and
`saved_game_filter_tag.dart`, the direct precedent for a sort enum; item 3.4's sort
pill will read it from the presentation layer.

`ErrorType` (modify) — `lib/core/data/models/error.dart` — four new variants and a
`ErrorType.postgrestError({required PostgrestException exception})` factory, built
the same way as the existing `dioError` and `supabaseIgdbError` factories. The three
SQLSTATE literals are private `static const` members on `ErrorType` — used nowhere
else, so they do not belong in `core/res/const.dart`.

### Datasource

`LibraryRemoteDatasource` (create) — `lib/features/library/data/datasources/library_remote_datasource.dart`
— `@injectable`, constructor-injected `SupabaseClient` exactly as `AuthDatasource`
takes it (`service_locator.config.dart:213` shows the async singleton resolving
fine). Named `…Datasource`, matching five of the six datasources in the tree and
`GameDetailRemoteDatasource` exactly; `GamesDataSource` is the lone `DataSource`
spelling, so `ambiguities.md`'s "which no existing datasource follows" is slightly
overstated — the majority and the `Remote` precedent both point the same way anyway.

Every method is `async` and starts by reading the session user id through one
private helper that throws `AuthSessionMissingException()` when there is no session
(3.3-AC29). Because the methods are `async`, that throw is captured in the returned
future and reaches the mixin.

- `fetchPage({LibraryStatus? status, required LibrarySort sort, required int limit, required int offset})`
  → `Future<List<LibraryEntryModel>>`.
  `.from(table).select().eq('user_id', userId)`, then `.eq('status', status.columnValue)`
  **only when a status is supplied** (3.3-AC19), then `.order(column, ascending:, nullsFirst: false)`
  from the private sort switch (3.3-AC17, and `nullsFirst: false` is the package
  default, giving 3.3-AC18), then `.range(offset, offset + limit - 1)`.
  Filter, order and range are all query parameters — nothing is filtered or sorted in
  Dart (3.3-AC16). An offset past the end returns `[]`, and a short page is returned
  as-is (3.3-AC20). No default or capped page size (page size is item 3.4's).
- `add({required int igdbId, required String title, String? coverUrl, DateTime? releaseDate, required LibraryStatus status, int? rating, String? platform, String? genre, double? playtimeHours, double? progressPercent})`
  → `Future<LibraryEntryModel>`. `.insert(payload).select().single()`. `user_id` comes
  from the session and is never a parameter (3.3-AC21). A plain insert, not an
  upsert: the unique conflict raises `23505`, which surfaces as
  `ErrorType.duplicateEntry()` and leaves the stored row untouched (3.3-AC22).
  `updated_at` is left to the column default (3.3-AC24).
- `update({required int igdbId, LibraryStatus? status, int? rating, bool clearRating = false, String? platform, String? genre, double? playtimeHours, double? progressPercent})`
  → `Future<LibraryEntryModel>`. Builds the payload from **only the arguments that were
  supplied**, plus `updated_at` (3.3-AC23, 3.3-AC24), then
  `.update(payload).eq('user_id', userId).eq('igdb_id', igdbId).select().single()`.
  `clearRating: true` writes `rating: null` and wins over any `rating` value —
  `rating` is the one column the user can un-set (D10, 3.3-AC26), and a nullable
  parameter alone cannot say "clear this" apart from "leave it alone". Rejected
  alternatives: a one-use generic `Edit<T>` wrapper (project-conventions bans generic
  wrappers added without a current requirement) and a sentinel number (bans
  placeholder-looking values).
- `remove({required int igdbId})` → `Future<void>`.
  `.delete().eq('user_id', userId).eq('igdb_id', igdbId)`. A delete matching zero
  rows is not an error, so remove is idempotent for free (3.3-AC25).

### Repositories

Interface `LibraryRepository` (create) —
`lib/features/library/domain/repositories/library_repository.dart`:
- `Future<Result<List<LibraryEntryEntity>>> fetchPage({LibraryStatus? status, required LibrarySort sort, required int limit, required int offset})`
- `Future<Result<LibraryEntryEntity>> add({…the datasource's add parameters…})`
- `Future<Result<LibraryEntryEntity>> update({…the datasource's update parameters…})`
- `Future<Result<void>> remove({required int igdbId})`

One interface, not four. Interface segregation is about callers needing only one
side; here the one caller that matters (item 3.4's `LibraryBloc`) needs all four,
and the project's shape is one repository per feature.

Implementation `LibraryRepositoryImpl` (create) —
`lib/features/library/data/repositories/library_repository_impl.dart` —
`@Injectable(as: LibraryRepository)`, `with BaseRepositoryMixin`.

**Every path goes through `fetchData`, and the model → entity conversion happens
inside the future that `fetchData` awaits.** This is the one subtle correctness
point in the file: `GamesRepositoryImpl` and `GameDetailRepositoryImpl` both call
`result.map((m) => m.toEntity())` *after* `fetchData` returns, which is outside the
try/catch. Here `toEntity()` can throw (3.3-AC11), so doing it that way would let an
exception cross into item 3.4's BLoC and break 3.3-AC28. Instead each method passes
a private `async` helper's future — `fetchData(apiCall: _pageOf(…))` — so the
datasource call *and* the mapping are both inside the mixin's try. `Result.map` is
still fine for a conversion that cannot throw; none here qualify.

## Domain layer

`LibraryEntryEntity` (create) —
`lib/features/library/domain/entities/library_entry_entity.dart` — `@freezed sealed
class`. Fields: `id` (`String`), `igdbId` (`int`), `title` (`String`), `coverUrl`
(`String?`), `releaseDate` (`DateTime?`), `status` (`LibraryStatus`, not a string),
`createdAt` (`DateTime`), `platform` (`String?`), `rating` (`int?`), `playtimeHours`
(`double?`), `progressPercent` (`double?`), `genre` (`String?`), `updatedAt`
(`DateTime`) (3.3-AC14).

Exactly one rating field, no `score` (D10, 3.3-AC14). `userId` is deliberately
**not** on the entity — it is an RLS mechanic, the row is always the signed-in
user's, and no consumer needs it. It stays on `LibraryEntryModel` because 3.3-AC12
names it. The file imports `freezed_annotation` and `core/enums/library_status.dart`
only — nothing from a data or persistence package (3.3-AC15).

Use cases, all `@injectable`, all a single `call()` returning `Future<Result<T>>`,
all depending on the interface (`lib/features/library/domain/use_cases/`):

| Use case | File | Input | Returns | Repo call |
|---|---|---|---|---|
| `FetchLibraryPageUseCase` | `fetch_library_page_use_case.dart` | status?, sort, limit, offset | `Result<List<LibraryEntryEntity>>` | `fetchPage` |
| `AddLibraryEntryUseCase` | `add_library_entry_use_case.dart` | game snapshot + status + optional fields | `Result<LibraryEntryEntity>` | `add` |
| `UpdateLibraryEntryUseCase` | `update_library_entry_use_case.dart` | igdbId + supplied fields (+ `clearRating`) | `Result<LibraryEntryEntity>` | `update` |
| `RemoveLibraryEntryUseCase` | `remove_library_entry_use_case.dart` | igdbId | `Result<void>` | `remove` |

Errors handled: none. Each forwards; the repository has already converted every
failure into a `Result` (3.3-AC28). `UpdateLibraryEntryUseCase` is the end of the
rating write path 3.3-AC26 requires — it accepts `rating: 1..10` and
`clearRating: true`, and item 4.6 builds the control that calls it.

`LibrarySnapshotEntity` (modify) —
`lib/features/featured/domain/entities/library_snapshot_entity.dart` —
`nowPlayingGames` becomes `List<TrackerSavedGameEntity>`; the
`features/tracker/data/models/saved_game.dart` import is replaced by
`core/domain/entities/tracker_saved_game_entity.dart` (3.3-AC31). Stays a plain
`final`-field class — the `flutter-usecase` skill says an existing plain entity that
never needs `copyWith` is not worth converting.

`TrackerSavedGameEntity` (modify) — `lib/core/domain/entities/tracker_saved_game_entity.dart`
— three nullable fields added: `hoursLogged`, `averageCompletionHours`,
`manualProgressPercentage` (3.3-AC33). Additive and named, so no existing
constructor call or `copyWith` breaks.

## State layer

None. Item 3.4 owns `LibraryBloc`, preferences and pagination state.

## UI layer

### Screens
None.

### Widgets
`LibraryStatsWidget` (modify) — `lib/features/featured/presentation/widgets/library_stats.dart`
— stateless, unchanged. Three edits only: `_buildNowPlayingCard`'s parameter becomes
`List<TrackerSavedGameEntity>`, the `saved_game.dart` import is dropped, and
`TrackerGameDetailRoute(game: topGame.toEntity())` becomes
`TrackerGameDetailRoute(game: topGame)` (3.3-AC32). Every field read at `:287-305`
and `:333-347` is present on the new type with the same value, so the rendered
output does not change (3.3-AC33). No comment is added — widget files carry none.

Per `flutter-widget-test`: **no new widget test file, and no test added for
`LibraryStatsWidget`.** It owns no new behaviour here — this is a parameter type
change with byte-identical output, and the widget has no test file today. Adding one
now would be writing coverage for an unrelated legacy widget inside a data-layer
run. No other widget is created or modified.

## Reuse decisions

- `BaseRepositoryMixin` at `lib/core/data/datasource/base_repository_mixin.dart` —
  extended rather than bypassed; see D-A.
- `ErrorType` / `Result` at `lib/core/data/models/` — the project's one error and
  result contract; four variants added, no parallel type introduced.
- `TrackerSavedGameEntity` at `lib/core/domain/entities/` — reused as the seam type
  and as the route argument; see D-B.
- `LibraryStatus` at `lib/core/enums/library_status.dart` — unchanged. The six
  values already match the check constraint as a *set*; only the wire spelling of
  `onHold` needed solving, and that is the mapping's job, not the enum's.
- `SupabaseClient` via `SupabaseModule` — injected exactly as `AuthDatasource` does.
  No new module, no second client.
- `SavedGame.toEntity()` at `lib/features/tracker/data/models/saved_game.dart` — the
  existing data→domain conversion, extended by three fields rather than duplicated.
- `FeaturedLocalDatasource` — untouched; Featured keeps its Isar source (3.3-AC34).

## Caveats I could not execute

No shell. Each of these is reasoned from package source or documented Postgres
behaviour, not verified by running anything. Dev records the outcome of each as a
self-correction either way.

1. **SQLSTATE values reaching `PostgrestException.code`.** `code` is a `String?`
   (`postgrest-2.8.0/lib/src/types.dart:9-13`) and PostgREST passes the Postgres
   SQLSTATE through, so `23505` / `23514` / `42501` is the expected shape.
   *Fallback:* if the manual 3.3-AC30 device check shows a different code (an HTTP
   status string, or `PGRST301`), add the observed code to the same branch — a
   one-line change to the private constants in `error.dart`. The fall-through branch
   means an unmapped code is still a `responseError`, never `unknown()`, so nothing
   collapses while this is open.
2. **`.single()` on a zero-row update.** Expected to raise `PostgrestException`
   with `PGRST116` (the `Accept: application/vnd.pgrst.object+json` header at
   `postgrest_transform_builder.dart:152-161` is what triggers it), which the
   fall-through maps to `responseError`. *Fallback:* use `.select()` and take
   `rows.first`; the resulting `StateError` is caught by the mixin as `unknown()` —
   a failure, not a crash, so 3.3-AC28 holds either way.
3. **Case-insensitive alphabetical sort (3.3-AC17).** `.order('title', ascending: true)`
   relies on the database collation; Supabase's default `en_US.UTF-8` orders
   case-insensitively in practice, a `C` collation would not. *Fallback: none in this
   item.* If the manual check shows `Zelda` before `animal crossing`, raise it as a
   follow-up migration adding a `lower(title)` expression index — **do not** sort in
   Dart, which 3.3-AC16 forbids.
4. **`numeric` columns arriving as JSON numbers.** json_serializable generates
   `(json['playtime_hours'] as num?)?.toDouble()`, which handles int or double.
   *Fallback:* if PostgREST returns them quoted, add a `@JsonKey(fromJson:)` on the
   two numeric fields.
5. **`SavedGame.toEntity()` now runs at snapshot-load time for every now-playing
   game rather than at tap time for one.** Same objects, same unloaded `IsarLinks`,
   so `groupTasks` resolves the same way it does today; if it could throw, the
   current code would already throw at tap. *Fallback: none needed.*

## Out of scope

- `LibraryBloc`, preferences, pagination state, search-within-status, the Featured
  repair — item 3.4.
- The rating **input** control — item 4.6. This item ships the column, the
  constraint and the write path (3.3-AC26).
- Any Library screen, widget or state — Stage 4.
- **Counts** — see D-F. Deliberately not a fifth use case here; item 3.4's brief must
  claim it.
- Isar → Supabase data migration, and any legacy `Status` → `LibraryStatus` mapping
  code — ruled out at `handover.md:475-477`; there are no rows to map.
- Filter axes beyond status.
- Applying the migration to the remote project — this pipeline plans the file only.
- The **Isar read cache**, the **IGDB refresh/sync system** and **remote task-tree
  backup**. All three are decided and real (D12), and all three are separate items
  after 3.4. Nothing in this item anticipates them.

## Open questions

NONE.

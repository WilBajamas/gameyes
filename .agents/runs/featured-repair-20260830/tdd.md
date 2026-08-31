# Technical Design Document
Source: `.agents/runs/featured-repair-20260830/tech-ac.md` (item 3.4b — the Featured repair)
Date: 2026-08-30

> **This design is reused, not re-derived.** Item 3.4's design was settled in
> `.agents/runs/library-bloc-preferences-20260827/tdd.md` and `code-plan.md`, which
> deliberately cover **both halves** of 3.4. 3.4a landed on 2026-08-30 and is merged. This
> document carries across the 3.4b-relevant sections of that design, scoped to this run's
> criterion range (3.4-AC26–3.4-AC36 plus the new 3.4-AC44), and extends it only where
> 3.4b needs something the source did not settle. Every extension is marked **NEW**.
> Where the source document and this one disagree, this one is scoped to 3.4b and wins for
> this run; `task-brief.md` wins over both.

## What is carried and what is new

**Carried unchanged** from `library-bloc-preferences-20260827/tdd.md`, per that run's
`task-brief.md ## What 3.4b inherits` (line 253):

- **D-A** — the now-playing seam is retyped, not populated with a safe value (below as
  D-A, verbatim in substance).
- The **`FeaturedRepositoryImpl`** and **`FeaturedLocalDatasource`** entries under
  `## Data layer`.
- **`NowPlayingGameEntity`** (create) and the **`LibrarySnapshotEntity`** modify under
  `## Domain layer`.
- The whole **`## UI layer`** section, including the widget-test scoping decision and
  D17.2's `StatelessWidget` change.
- **D17.3**'s parallel-call comment, which applies again to `FeaturedRepositoryImpl`'s
  `entriesCall`/`countsCall`.

**New in this run** (the source design did not settle these):

- **D-J** — 3.4-AC44's append-side end-of-results test, and why the seeded numbers make
  the mutation fail. Added scope, agreed at Phase 0.
- **D-K** — `_NowPlayingCard` needs the parent's `onMarkNowPlaying` callback. The source
  skeleton showed the widget holding only `playingGames`, which does not compile against
  the `EmptyStateCard` branch it inherits.
- **D-L** — the widget test's harness gate: `LibraryStatsWidget` renders the checklist
  card, not the stats, unless the snapshot's `totalGamesCount` is at least 1.
- Caveats 1–4 below, all specific to this half.
- `test/cubit/library/library_bloc_test.dart` joins the allowlist as a MODIFY (3.4-AC44).
  It was 3.4a's file and is otherwise finished.

**Deliberately not carried** — everything scoped to 3.4a: D-B through D-I, the
`LibraryRemoteDatasource` / `LibraryPreferencesDatasource` / `postgrestLikePattern`
entries, the Library half of `## Domain layer`, and all of `## State layer`. Those
shipped. Nothing in this run re-opens them.

## Feature summary

Featured's now-playing shelf, wishlist stat, total-games figure and owned-game ids are
repointed off four Isar filters nothing has ever written and onto `library_entries`,
through the `LibraryRepository` domain interface 3.4a landed. `FeaturedRepositoryImpl`
takes that interface as a third constructor dependency and serves the snapshot from
`fetchAllEntries()` and `fetchCounts()`, run side by side, degrading a failed or
signed-out read to empty/zero inside a still-successful snapshot. The seam that carries a
playing row to the card is **retyped** to a new Featured-owned `NowPlayingGameEntity` that
has no int identifier at all, so no Isar key can be derived from a `library_entries` row.
The four dead Isar reads are retired from `FeaturedLocalDatasource`; `getThisWeekPlayHours`
and the genre derivation stay on Isar untouched. On the card, both tap branches collapse to
`setActiveIndex(1)` and the card becomes its own `StatelessWidget`. No screen, no new
route, no state class changes.

## Layer map

| Criterion | Layers |
|---|---|
| 3.4-AC26, AC27, AC28, AC30, AC33, AC34 | data, domain |
| 3.4-AC29 | UI |
| 3.4-AC31 | domain (entity retype) |
| 3.4-AC32 | none — invariant to protect, allowlist exclusion |
| 3.4-AC35 | test (repository + widget) |
| 3.4-AC36 | manual (on device) |
| 3.4-AC44 | test (state layer, `LibraryBloc`) |
| 3.4-AC41 | constraint (not re-cut here — read from the source file at line 354) |

---

## Design decisions settled here

### D-A. 3.4-AC31 — the now-playing seam is retyped, not populated with a safe value

**Carried from the source `tdd.md` D-A.**

`LibrarySnapshotEntity.nowPlayingGames` stops being `List<TrackerSavedGameEntity>` and
becomes `List<NowPlayingGameEntity>` — a new Featured-owned entity that carries exactly
what the card renders and **has no int identifier of any kind**.

Rejected alternative: keep `TrackerSavedGameEntity` and put a provably-unused value in its
required `id`. That satisfies the type and relies on a convention ("nobody keys on it")
that no compiler enforces, which is the failure mode 3.4-AC31 names verbatim. Removing the
field makes the failure impossible to write rather than merely absent today — a later item
that adds an Isar lookup to the Featured path cannot reach for an id that does not exist.

`TrackerSavedGameEntity` itself is **untouched** and keeps every current consumer
(`TrackerCubit`, `TrackerRepositoryImpl`, the tracker detail tree) — 3.4-AC32 holds.

`NowPlayingGameEntity` carries `averageCompletionHours` even though `library_entries` has
no column for it. This is deliberate: dropping the field would force branch 2 of
`library_stats.dart:292-301` to be deleted to keep compiling, and `tech-ac.md ## Known
gaps` explicitly rules that deletion out. The field therefore reads as always-null and the
branch stays permanently unreachable exactly as recorded.

### D-J. 3.4-AC44 — the append-side guard, and the numbers that make the mutation fail (**NEW**)

The surviving mutation is real and reproducible by reading the code. `library_bloc.dart`
derives the flag in two places:

- first page, `:135` — `page.entries.length >= page.matchedCount`
- next page, `:188-189` — `state.entries.length + page.entries.length >= page.matchedCount`

Both existing end-of-results tests (`library_bloc_test.dart:468` and `:491`) dispatch
`LibraryStarted`, so they exercise only the **first-page** line. The one next-page test
(`:420`-ish, "appends the next page rather than replacing the loaded entries") seeds 20
loaded, appends 20, `matchedCount: 100` — the correct rule gives `40 >= 100` → false, and
the withdrawn short-page rule gives `20 < 20` → false. They **agree**, which is exactly why
reverting only the next-page line leaves the suite green.

The seeded case that separates them, and what 3.4-AC44 describes:

| | value |
|---|---|
| seeded `entries` | one full page, `LibraryConstants.pageSize` (20) rows |
| seeded `matchedCount` | 40 (their sum), `status: success`, `hasReachedEnd: false` |
| next page returned at `offset: 20` | 20 rows, `matchedCount: 40` |
| matched-count rule | `20 + 20 >= 40` → **true** |
| withdrawn short-page rule | `20 < 20` → **false** |

The test asserts `hasReachedEnd` is `true` after the append. Under the mutation it is
`false` and the test fails — which is the criterion's own falsifiability requirement.

The page size is `LibraryConstants.pageSize`, not a literal invented for the test
(`tech-ac.md ## Assumptions`), and the test sits in
`test/cubit/library/library_bloc_test.dart` beside the existing next-page tests, which is
the layer the mutation lives at. It is one added `blocTest`; nothing existing in that file
is rewritten. See caveat 3.

### D-K. `_NowPlayingCard` takes the parent's `onMarkNowPlaying` callback (**NEW**)

The source `code-plan.md` sketched `_NowPlayingCard` holding only `playingGames`. That does
not compile: the empty branch it inherits builds an `EmptyStateCard` whose
`onActionPressed` is `LibraryStatsWidget.onMarkNowPlaying`, a field of the **parent**, and
`EmptyStateCard` has no actionless variant (`flutter-widgets`). The extracted widget
therefore takes both values as required named parameters.

This does not weaken D17.2. The human instruction is that the card is a `StatelessWidget`
rather than a `Widget`-returning helper method — that stands, and `flutter-widgets`
independently forbids the helper-method shape. That the call site cannot be `const`
(`playingGames` comes from a runtime snapshot) is a property of the data, not of the
refactor.

### D-L. The widget test must clear the checklist gate (**NEW**)

`LibraryStatsWidget.build` (`library_stats.dart:40-48`) renders the **checklist card**, not
the stats, when `!isChecklistDismissed && (snapshot == null || snapshot!.totalGamesCount == 0)`.
A widget test that supplies a snapshot with a playing game but `totalGamesCount: 0` and
`isChecklistDismissed: false` renders neither the now-playing card nor `EmptyStateCard`, and
whatever it asserts will be misleading.

So both tests in `test/widget/featured/library_stats_test.dart` supply a snapshot with
`totalGamesCount` of at least 1. This is a harness fact, not a test design: which
assertions each test makes is Dev's, guided by `flutter-widget-test`.

---

## Data layer

### API contracts

None. No new or changed request is issued by this half — every Supabase request it uses
(`fetchAllEntries`, `fetchCounts`) shipped with 3.4a and is unchanged.

### Models

No new or changed DTOs.

### Repositories

**`FeaturedRepositoryImpl` (modify)** —
`lib/features/featured/data/repositories/featured_repository_impl.dart`. **Carried.**

Gains `LibraryRepository` as a **third constructor dependency** — the domain interface, not
the impl, and never a use case. A repository calling a use case would invert the layering.
Injectable resolves it from `LibraryRepositoryImpl`'s existing
`@Injectable(as: LibraryRepository)` (`library_repository_impl.dart:12`).

- `getLibrarySnapshot()` — starts `fetchAllEntries()` and `fetchCounts()` concurrently and
  keeps `getThisWeekPlayHours()` on Isar. `totalGamesCount` ← `counts.total`;
  `wishlistCount` ← `counts.byStatus[wishlist]`; `nowPlayingGames` ← entries filtered to
  `LibraryStatus.playing` (order preserved from the query, which is `updated_at`
  descending — 3.4-AC26) mapped to `NowPlayingGameEntity`; `ownedGameIds` ← every entry's
  `igdbId` across every status (3.4-AC28, D15). A `Failure` on either read degrades to an
  empty list / null counts and the snapshot **still returns `Success`** (3.4-AC33). The two
  calls are assigned before either is awaited; that idiom carries the plain-English comment
  D17.3 asks for, same wording as the bloc's.
- `getCountdownGame()` (`:63`) and `getOutThisWeekGames()` (`:131`) — wishlist ids come
  from `fetchAllEntries(status: wishlist)` mapped to `igdbId`; a `Failure` degrades to an
  empty set. These are two of 3.4-AC27's three callers and they are fixed in the same pass
  as the visible stat. The ids are IGDB ids and continue to match `GameEntity.id`, so
  `_countdownFrom` and the out-this-week ordering are unchanged.
- `getCriticsChoiceGames`, `saveGenrePreferences` and `getGenrePreferences` are
  **unchanged**, including the Isar-backed genre derivation.

**`FeaturedRepository`** (the domain interface) is **not** modified — no signature changes.

### Datasources

**`FeaturedLocalDatasource` (modify)** —
`lib/features/featured/data/datasources/featured_local_datasource.dart`. **Carried.**

`countSavedGames`, `getOwnedGameIds`, `getWishlistedGames` and `getNowPlayingGames` are
**removed**. They are the four dead Isar reads this item exists to retire — `:39` filters
`isWishlistedEqualTo(true)` and `:46` filters `statusEqualTo('Playing')`, neither of which
anything has ever written — and after this half nothing else calls them (Phase 0 caller
grep: `featured_repository_impl.dart:36, :37, :39, :40, :63, :131` and nothing outside it).

`getThisWeekPlayHours`, `getSavedGames`, `saveGenrePreferences`, `getSavedGenrePreferences`
and `_getDb` stay **untouched**, so the This Week tile and the genre derivation are
unaffected (3.4-AC33, and `tech-ac.md ## Out of scope`).

**NEW, so Dev does not strip them:** every import in that file survives the removal.
`isar_community` is still used by `_getDb`'s return type and `getThisWeekPlayHours`;
`saved_game.dart` is still used by `getSavedGames()`'s `List<SavedGame?>` return type;
`play_session_log.dart` and `shared_preferences` are untouched. Removing an import here
would be a new error, not a tidy-up.

No `SavedGame` field is removed and `SavedGame.toEntity()` keeps its caller in
`TrackerRepositoryImpl` — 3.4-AC32 holds.

---

## Domain layer

**Entity (create)** — `NowPlayingGameEntity` —
`lib/features/featured/domain/entities/now_playing_game_entity.dart` — freezed —
`String title`, `String? coverUrl`, `double? progressPercent`, `double? playtimeHours`,
`double? averageCompletionHours` (no source; see D-A). **Carried.**

Every field the card renders is present and every one has a source on
`LibraryEntryEntity` except the last: `title` ← `title`, `coverUrl` ← `coverUrl`,
`progressPercent` ← `progressPercent` (the `progress_percent` column, 3.4-AC34's
manual-progress branch), `playtimeHours` ← `playtimeHours` (the `playtime_hours` column,
the hours branch). Types line up exactly — all four are `double?`/`String?` on both sides.

**Entity (modify)** — `LibrarySnapshotEntity.nowPlayingGames` becomes
`List<NowPlayingGameEntity>`. Stays a plain class; nothing else about it changes, and the
`tracker_saved_game_entity.dart` import is replaced by the new entity's. **Carried.**

**Use cases** — none created or modified. `GetLibrarySnapshotUseCase` forwards the
repository's `Result` unchanged and its signature does not move.

---

## State layer

Nothing created or modified. `LibraryStatsCubit` is **not** touched: it already reads
`snapshot.totalGamesCount`, `snapshot.nowPlayingGames.isNotEmpty` and
`snapshot.wishlistCount` (`library_stats_cubit.dart:35, :40-42`), so repointing the
snapshot's source satisfies 3.4-AC28's three checklist steps without editing the file.
`LibraryBloc` is unchanged as production code — 3.4-AC44 adds a test against it, not a
behaviour change (D-J).

---

## UI layer

### Screens

None created or modified. `featured_screen.dart` is **not** touched: `:161` and `:238`
already read `libraryState.snapshot?.ownedGameIds`, so the owned marks are repaired by the
repointed snapshot alone (3.4-AC28).

### Widgets

**`LibraryStatsWidget` (modify)** —
`lib/features/featured/presentation/widgets/library_stats.dart` — stateless — consumes
`LibrarySnapshotEntity?` (now with `List<NowPlayingGameEntity>`) — interactions: one tap
target on the now-playing card. **Carried, with D-K.**

Four changes and nothing else:

1. `_buildNowPlayingCard` becomes a private `_NowPlayingCard extends StatelessWidget` in
   the same file (D17.2, and `flutter-widgets`' "never split composition into a function
   returning `Widget`"). It takes `playingGames` and `onMarkNowPlaying` as required named
   parameters (D-K). `_buildLibraryStats` places it in the same position at `:262`.
2. The card's `onTap` becomes a single `AutoTabsRouter.of(context).setActiveIndex(1)` —
   both branches collapse because both destinations are now the same (3.4-AC29, D14). The
   `TrackerGameDetailRoute` push goes, and with it the
   `config/route/auto_route_config.gr.dart` import; leaving that import behind would be a
   new lint. The route's own registration in `auto_route_config.dart:44` is **not** touched
   — the tracker tree stays reachable by the router and compiling (3.4-AC32).
3. The card reads `title`, `coverUrl`, `progressPercent`, `playtimeHours` and
   `averageCompletionHours` off the new entity, replacing `name`, `imageUrl`,
   `manualProgressPercentage`, `hoursLogged`. The
   `name ?? StringConstants.emptyStringPlaceholder` fallback at `:345` goes, because `title`
   is non-nullable. All three progress branches stay structurally intact (3.4-AC34, and
   `tech-ac.md ## Known gaps` — branch 2 stays permanently unreachable and is **not**
   deleted). The `core/domain/entities/tracker_saved_game_entity.dart` import goes.
4. No comments are added — widget files carry none. The pre-existing
   `/// TODO: Refactor this widget` at `:13` is left exactly as it is; it predates this run
   and removing it is not this run's change.

The `extraCount >= 1` badge and the `Active` pill are unchanged; the tap no longer depends
on them. Nothing about layout, colour, spacing or dimensions moves.

**Widget test scoping** (per `flutter-widget-test`). **Carried, and re-confirmed against
the skill this run.**

- **`LibraryStatsWidget` gets a dedicated test file**, `test/widget/featured/library_stats_test.dart`.
  It owns a genuine conditional the repair exists to flip — an empty playing list renders
  `EmptyStateCard`, a non-empty one renders the game — which is 3.4-AC35's second half and
  the exact `GamesStatus.empty` lesson the item cites. That is "content that changes with
  an input", the skill's first listed reason to create a file.
- **The tap destination is not widget-tested.** Exercising `AutoTabsRouter.of(context)`
  needs a tab-router harness disproportionate to one `setActiveIndex` call, and 3.4-AC36
  already books it as an on-device manual check closing `3.2-MC-6`.
- **`_NowPlayingCard` gets no file of its own.** It is private and has no surface a caller
  can reach; its two branches are the same two the parent's file covers.
- **No other widget in scope gets or needs a file.** `featured_screen.dart` and
  `library_stats_cubit.dart` are untouched, and nothing else in the diff renders.
- Two tests, no dimension, colour or spacing assertions, no tap test. Both supply a
  snapshot with `totalGamesCount >= 1` (D-L). See caveats 1 and 2.

---

## Reuse decisions

- **`LibraryRepository`** (`lib/features/library/domain/repositories/library_repository.dart`)
  — the domain interface 3.4a landed, injected into `FeaturedRepositoryImpl`. Its
  `fetchAllEntries({LibraryStatus? status})` serves all three Featured needs from one
  method: playing rows, wishlist ids, every owned id. `fetchCounts()` serves the total and
  the wishlist figure. Nothing new is added to the interface.
- **`BaseRepositoryMixin`'s `AuthSessionMissingException → ErrorType.notSignedIn` mapping**
  — already on both new methods from 3.4a. It is what lets a signed-out library read arrive
  as a `Failure` this half can degrade to zeroes while still returning `Success`
  (3.4-AC33), with no new error plumbing.
- **`LibraryStatsCubit`, `featured_screen.dart`, `GetLibrarySnapshotUseCase`,
  `FeaturedRepository`** — **not modified.** All already read the snapshot's fields, so
  repointing its source satisfies 3.4-AC28 without touching any of them.
- **`EmptyStateCard`** (`lib/widgets/empty_state_card.dart`) — the existing empty branch is
  kept exactly as it is, moved into `_NowPlayingCard` unchanged.
- **`DefaultCachedNetworkImage`** — the cover branch is unchanged; only the field feeding
  it is renamed `imageUrl` → `coverUrl`.
- **`test/cubit/library/library_bloc_test.dart`'s existing helpers** — `_entry`, `_pageOf`,
  `_counts` and the mock set are reused by 3.4-AC44's added test; no new fixture is
  introduced and no existing test is edited.

---

## Caveats that need execution to settle

Per the Tech Lead skill's no-shell rule, each states how it was reasoned and what Dev should
do if it does not hold. **Dev records the outcome as a self-correction note either way.**

1. **The widget test's localisation harness.** `LibraryStatsWidget` renders through
   `S.current` throughout, so the test needs `await S.load(const Locale('en'))` before
   pumping and a `MaterialApp` around the subject. Reasoned from
   `test/features/featured/presentation/blocs/library_stats_cubit_test.dart:34, :40`, which
   already does exactly this for the same strings — not executed here.
   *Fallback if strings come back null or the pump throws:* copy the `setUp` from that file
   verbatim, including `TestWidgetsFlutterBinding.ensureInitialized()`.
2. **What the non-empty test can assert on.** The intended assertion is the playing game's
   title, which `_NowPlayingCard` renders through a plain `Text` — safe for `find.text`.
   The empty branch's headline goes through `EmptyStateCard`, which the catalogue documents
   as rendering "a caps headline **from a normal-case string**", so `find.text` against the
   `.arb` value may not match the rendered caps. Reasoned from
   `flutter-widgets`' catalogue entry, not from running the widget.
   *Fallback:* assert `find.byType(EmptyStateCard)` for the empty branch — a composed
   public component, which the skill sanctions. **Do not** assert a hand-uppercased string.
   Also pass `coverUrl: null` in both tests so the fallback icon renders and no network
   image is manufactured (`flutter-widget-test`, "Do not manufacture image states").
3. **That 3.4-AC44's test actually fails under the mutation.** D-J's table is a hand
   evaluation of both rules against the seeded numbers, read off `library_bloc.dart:135`
   and `:188-189`. It was not run, and the mutation was not applied.
   *Fallback if the new test passes with the next-page line reverted to
   `page.entries.length < LibraryConstants.pageSize`:* the seeded numbers have drifted into
   a case the two rules agree on — restore the three constraints that make them disagree
   (appended page length exactly `LibraryConstants.pageSize`, seeded `entries` exactly one
   full page, `matchedCount` exactly their sum) rather than changing the assertion.
   **Do not** modify the production handler to make a test pass.
4. **DI resolution of the third dependency.** `FeaturedRepositoryImpl`'s new
   `LibraryRepository` parameter resolves because `LibraryRepositoryImpl` carries
   `@Injectable(as: LibraryRepository)` (`library_repository_impl.dart:12`) — read, not
   generated here.
   *Fallback if the generated `.config.dart` fails to resolve it:* escalate. Never
   hand-edit a generated file (`generation.md`).

---

## Out of scope

- **Everything 3.4a shipped** — the bloc's behaviour, library preferences, the count
  capability, the search predicate, the datasource test. 3.4-AC1–AC25 and AC37–AC40 are
  closed and are not re-checked. `library_bloc.dart` itself is **not** modified; 3.4-AC44
  adds a test only.
- **Re-deriving, rewriting or renumbering 3.4-AC26–3.4-AC36** (D16).
- **The tracker tree** — `tracker_game_detail_screen.dart`, `task_detail_screen.dart`,
  `TaskCubit`, `GroupTask`, `SavedGameTask`, `TaskStep`, every `SavedGame` field, and the
  `TrackerGameDetailRoute` registration at `auto_route_config.dart:44`. All stay,
  compiling and passing their tests. D14 makes the tree unreachable and that is intended;
  3.4-AC32 is what keeps it in the repo.
- **Deleting `library_stats.dart`'s unreachable branch 2** (`:292-301`) — see D-A and
  `tech-ac.md ## Known gaps`.
- **`getThisWeekPlayHours()` and `getSavedGames()`'s genre derivation** — both stay on Isar.
- **Any Isar → Supabase migration.** Neither legacy filter has ever matched a row, so
  there is nothing to migrate.
- **The Isar read cache, the IGDB refresh system, task-tree backup** (D12) — later items
  with no run yet.
- **The Library screen and its widgets** — Stage 4, items 4.1–4.6.
- **`GamesBloc`'s three pre-existing failures**, and the `use_null_aware_elements` info
  lint at `library_remote_datasource.dart` — human-approved, `clearRating` must write an
  explicit null (3.3-AC26). **Do not fix it.**
- **Any `pubspec.yaml` edit.** This half needs no package. `execution.md`'s read-only rule
  applies with no exception; 3.4a's `stream_transform` authorisation was spent.

## Open questions

None.

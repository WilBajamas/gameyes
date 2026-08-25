# Technical Design Document
Source: `tech-ac.md` (run `async-empty-state-20260824`), AC-01–AC-28
Date: 2026-08-24

## Feature summary

One new stateless widget in `lib/widgets/` draws the empty-state card — raised
surface, `lg` radius, optional glyph, caps headline, one supporting line, one
required action built from the shipped `PrimaryButton`. Five existing empty
branches stop improvising and render it instead. No domain, data or state layer
changes: every site keeps the callback or cubit method it already owns, so this
is a presentation-layer swap plus eleven new `.arb` keys and one edited value.
The `flutter-widgets` skill's empty-state note and catalogue are updated to name
the component.

## Layer map

| Criteria | Layers touched |
|---|---|
| AC-01–AC-10, AC-26 | UI (new shared widget) + test |
| AC-11, AC-12 | UI (screen) — existing `GamesBloc` event, no state change |
| AC-13 | UI (feature widget) — existing `onMarkNowPlaying` callback |
| AC-14 | UI (feature widget) — existing `onSkipPressed` callback → existing `CriticsGridCubit.skipGenrePreferences()` |
| AC-15, AC-16, AC-17, AC-18 | UI (feature widget + screen) — tab router, no navigation stack |
| AC-19, AC-22, AC-23, AC-24 | Localisation (`.arb` + regenerated `S`) |
| AC-20, AC-21 | Scope boundaries — nothing to build, enforced by the allowlist |
| AC-25 | Documentation (`flutter-widgets` skill) |
| AC-27, AC-28 | Verification against the recorded baselines |

## Data layer

None. No API, model, DTO, repository or storage change.

## Domain layer

None. No new or modified use case.

## State layer

None. Deliberate, and it is the load-bearing constraint on this design — see
"Why no new callback parameter" below.

## UI layer

### Widgets

**`EmptyStateCard` (create) — `lib/widgets/empty_state_card.dart` — stateless.**

- Consumes: `headline` (String, required), `supportingLine` (String, required),
  `actionLabel` (String, required), `onActionPressed` (VoidCallback, required),
  `glyph` (IconData?, optional, defaults to none).
- Interactions: the single action control invokes `onActionPressed`.
- Structure: `ClipRRect` (radius `tokens.radius.lg`) → `ColoredBox`
  (`tokens.color.surfaceRaised`) → `Padding` (the card's own interior) →
  `Column` (`mainAxisSize: MainAxisSize.min`) of: optional `Icon`, headline
  `Text`, supporting `Text`, `PrimaryButton`.
- Tokens, all criterion-driven: fill `surfaceRaised` (AC-02), radius `lg`
  (AC-03), headline `typography.cardHeading` in `color.ink` (AC-04), supporting
  line `typography.body` in `color.ink70` (AC-05), glyph at 44 in `color.ink55`
  (ASSUMPTION-15).
- Outermost widget is the `ClipRRect`. No `Padding`, `SizedBox`, `Center` or
  `Align` wraps it, and there is no padding/margin/gap constructor parameter
  (AC-07). No `height:` anywhere in the file (AC-09). No `Border`, no
  `CustomPainter` (AC-08). No comments (AC-10).

**Caps are applied at the component, not by the type token.**
`AppTextToken.format()` is the shipped caps mechanism (`context_chip.dart:29`,
`zone_label.dart:29`), but it is a **no-op for this role**: `cardHeading` is
declared `uppercase: false` (`app_type_tokens.dart:75-81`). Flipping that flag
is not available — `cardHeading` is also `countdown_card.dart:48`'s game title,
which must stay in its authored case. So the component calls
`headline.toUpperCase()` on a normal-case `.arb` value (AC-04), which is a no-op
for the Chinese locale as ASSUMPTION-6 requires. Whether `cardHeading` deserves
a caps sibling token is a foundations question, not this run's.

**Placement: a flat file, not a module folder.** One public class, no variant
enum, no private sub-widget — every child is either a Flutter primitive or an
already-shared widget (`PrimaryButton`). That is `hairline_group.dart`'s and
`label_value_row.dart`'s shape (item 2.6), not `error_states/`'s (item 2.7,
which earned its folder with four classes plus an enum). The `flutter-widgets`
skill states a flat "one file per widget family" rule as absolute, which matches
neither 2.7 nor `game_card/` nor `bottom_tab_bar/`; that contradiction is a known
live follow-up. This item lands flat on its own merits, not because the skill
says so.

### Screens and feature widgets (all modify)

| Site | File | Change |
|---|---|---|
| 1 | `lib/features/games/presentation/screens/games_screen.dart` | `GamesStatus.empty` branch renders `EmptyStateCard` inside the existing `SliverFillRemaining`+`Center`, with the caller supplying horizontal padding. Action re-dispatches `const GamesFetched()` on the existing bloc — the same event and the same instance as today (AC-11). `ErrorRetryWidget` keeps its two failed-branch constructions untouched (AC-12). |
| 2 | `.../featured/presentation/widgets/library_stats.dart` | `_buildNowPlayingCard`'s empty branch returns `EmptyStateCard` with `Icons.play_circle_outline_rounded` and `onMarkNowPlaying`. The `Container`+`CustomPaint`+`BorderStyle.none` recipe and the whole `_DashedBorderPainter` class are deleted (AC-13). |
| 3 | `.../featured/presentation/widgets/critics_grid.dart` | `_buildGrid`'s empty branch returns `EmptyStateCard` with `Icons.tune_outlined`, action `onSkipPressed` (AC-14 — see below). The 160px `Container` and the hardcoded English go. |
| 4 | `.../featured/presentation/widgets/countdown_releases.dart` | `_buildReleasesList`'s empty branch returns `EmptyStateCard` with `Icons.calendar_month_outlined`; the action calls `AutoTabsRouter.of(context).setActiveIndex(3)` using the `BuildContext` the method already receives. The 170px `Container` and the hardcoded English go. |
| 5 | `.../featured/presentation/screens/featured_screen.dart` | `_RightNowSection`'s `state.countdownGame == null && state.outThisWeekGames.isEmpty` branch returns `EmptyStateCard` with `Icons.timer_outlined` in the exact slot `const SizedBox.shrink()` occupies today — same `if`, same early `return`, no heading added (AC-16). Action `AutoTabsRouter.of(context).setActiveIndex(3)`. |

Reactive boundary is unchanged at every site: each empty branch already sits
inside the `BlocBuilder` that owns it.

### Why no new callback parameter anywhere (the AC-20 constraint)

`CriticsGridWidget`, `CountdownReleasesWidget` and `LibraryStatsWidget` each have
exactly one production caller — `featured_screen.dart` — and each is constructed
**twice** there: once for real, once inside the `Skeletonizer` loading branch.
Adding a required constructor parameter to any of them therefore forces a diff
hunk inside a loading branch, which AC-20 fails outright ("any diff hunk inside a
loading or failed branch fails, even if it only reformats"). Making it optional
would let `EmptyStateCard`'s required action be fed a null, which AC-06 forbids.

So sites 3, 4 and 5 are wired without touching any constructor signature:

- **Site 4 and 5 act on their own `BuildContext`.** `AutoTabsRouter.of(context)
  .setActiveIndex(3)` is the shipped pattern in these exact files
  (`featured_screen.dart:143-146`, `library_stats.dart:375`) and Browse is child
  index 3 of the home tabs router (`auto_route_config.dart:28`). `.of(context)`
  is evaluated inside the tap callback, never at build time, so the loading
  skeleton — which has no live tab router in a test harness — is unaffected. No
  `router.push`, no `BrowseRoute` (AC-17).
- **Site 3 reuses the existing `onSkipPressed` callback.** See the reuse
  decision below.

### AC-18 — sites 4 and 5 are genuinely mutually exclusive, verified on disk

`ambiguities.md` ASSUMPTION-8 asserts this; it holds against the real tree, and
the guarantee is structural rather than incidental:

- `featured_screen.dart` `_RightNowSection` evaluates, in order and each with an
  early `return`: `failed` → `isLoading` → `countdownGame == null &&
  outThisWeekGames.isEmpty` (site 5) → `CountdownReleasesWidget` (site 4's host).
- Site 4's branch, `countdown_releases.dart:83`, needs `outThisWeekGames.isEmpty`
  — but it is only ever reached on the fall-through path, where site 5's
  condition was false, so `countdownGame != null` there. Exactly AC-18's wording.
- `CountdownReleasesWidget` has no other production caller (grepped:
  `featured_screen.dart:187` and `:203` only), so no other path can render site 4
  with both lists empty.
- The `Skeletonizer` construction at `:187` passes
  `GameLoadingWidgetData.weeklyReleases`, which is `List.generate(5, …)` —
  never empty, so the loading skeleton cannot reach site 4's branch and AC-20
  stays intact by construction.

Checkable form for QA, per the "position criteria usually have a checkable form"
rule: after the change `EmptyStateCard(` appears exactly once in
`countdown_releases.dart` and exactly once in `featured_screen.dart`, and site
5's branch is still an early `return` placed above the `CountdownReleasesWidget`
construction. Both are greps. A widget test is *not* the right instrument here —
constructing `CountdownReleasesWidget` with both lists empty would assert a state
the app cannot reach.

## Reuse decisions

- **`PrimaryButton` (`lib/widgets/primary_button.dart`)** — the component's
  action control (AC-06). It is the current-generation token-driven button
  (`green` fill, `radius.sm`, `typography.meta`, `ButtonPressScale` press and
  focus behaviour), its API is exactly `label` + `onPressed`, and it adds no
  spacing of its own. `EmptyStateCard` defines no button styling. Not
  `DefaultOutlinedButton` / `DefaultFilledButtonFullWidth`: both are legacy
  Material-theme buttons that read no app tokens. Not `ActionRow`: it requires a
  leading mark.
- **`ClipRRect` + `ColoredBox` for the card**, copying `HairlineGroup` — the
  shipped `surfaceRaised` + `radius.lg` card. See the finder note under Testing.
- **`CriticsGridCubit.skipGenrePreferences()` via the existing `onSkipPressed`
  callback** for site 3's action. It saves `genreIds: []` **once** and calls
  `loadCriticsGrid()` **once**, whatever was selected, and works when nothing is
  selected — exactly AC-14, including both its failure cases. The alternative,
  looping `onGenreToggled` over the selection, fires one save-and-reload *per
  genre* and fails AC-14 outright (ASSUMPTION-12 flagged this). A new
  `clearGenrePreferences()` cubit method would need a new required widget
  parameter, which AC-20 forbids. **Trade-off, recorded deliberately:**
  `skipGenrePreferences()` also sets `isSkipped: true`, so the genre picker above
  the grid hides after the tap. That reads as coherent — the user just asked to
  see every pick regardless of genre — but it is a visible side effect beyond
  AC-14's literal words and the human should confirm it at the Phase 3 gate.
- **`no_results_found`, `no_game_in_progress`, `mark_something_playing`** reused
  as site 1's headline, site 2's headline and site 2's action label (AC-24);
  wording untouched apart from dropping the trailing `→` from
  `mark_something_playing` in both locales.
- **One shared `browse_games` action key for sites 4 and 5.** Both actions mean
  the same thing and go to the same place; two keys would be the near-duplicate
  AC-24 forbids. The existing `browse` key is the *tab destination's* name, not a
  call to action, so it is not reused here.
- **`ErrorRetryWidget`, `GamesBloc`, `GamesFetched`, `LibraryStatsWidget`'s
  `onMarkNowPlaying`** — all untouched.

### New localisation keys

Eleven new keys in both `intl_en.arb` and `intl_zh.arb`, plus one edited value.
All authored in normal case (AC-04), none containing an apology, a "sorry", a
"not found"/"nothing here" framing, an exclamation mark, an emoji or a dingbat
(AC-23). `S.current.retry` is deliberately not reused at site 1 (ASSUMPTION-11).

| Key | Used by | EN |
|---|---|---|
| `try_widening_your_filters` | site 1 line | Widen your filters and more of the catalogue comes into view. |
| `search_again` | site 1 action | Search again |
| `pick_a_game_to_start_logging` | site 2 line | Pick a game from your library and start logging hours. |
| `open_up_your_genres` | site 3 headline | Open up your genres |
| `every_pick_without_a_genre_filter` | site 3 line | Clear the genre filter to see every pick critics made this week. |
| `show_every_pick` | site 3 action | Show every pick |
| `look_further_ahead` | site 4 headline | Look further ahead |
| `browse_for_your_next_game` | site 4 line | Browse the catalogue and line up what you play next. |
| `browse_games` | sites 4 + 5 action | Browse games |
| `start_a_countdown` | site 5 headline | Start a countdown |
| `wishlist_a_game_to_track_release` | site 5 line | Wishlist an upcoming game and its release lands here. |

`mark_something_playing` edited in both locales: `"Mark something as playing →"`
→ `"Mark something as playing"`, `"标记一些游戏为正在玩 →"` → `"标记一些游戏为正在玩"`.

Site 1's action label is `Search again`, not `Show all games`: `const
GamesFetched()` carries all-null arguments, and `games_bloc.dart:40-47` falls
back to `state.filterState` for each one, so the dispatch **re-runs the current
filtered search** rather than clearing filters. The label has to be honest about
that; the supporting line is what points the user at the filter sheet.

## Testing

**Mode: `smoke`.** Rule applied: "UI-only with no new logic". Not `coverage` —
nothing here touches auth, payments, persistence or an offline queue, and the
component serves two features (games, featured), not the three-plus that rule
names. Unit and widget tests only; never a golden.

**Which widgets get a dedicated test file** (per `flutter-widget-test`'s "Decide
whether to create a test file"):

- **`EmptyStateCard` — yes.** `test/widget/components/empty_state_card_test.dart`.
  It owns a real public contract: content that changes with its inputs, a
  render-time caps treatment, a conditional glyph, and an interaction with an
  observable result. AC-26 requires it.
- **`GamesScreen` — no.** The rewiring swaps which widget an already-existing
  branch renders; the behaviour worth protecting (what the empty state says and
  what its action does) lives in `EmptyStateCard`, and the bloc dispatch is
  already the one `games_bloc_test.dart` covers.
- **`LibraryStatsWidget`, `CriticsGridWidget`, `CountdownReleasesWidget` — no.**
  None has a test today; each would need a fresh cubit-and-tab-router harness
  built for a pre-existing untested widget, which is out of proportion to a
  smoke-mode swap of one branch's child.
- **`FeaturedScreen` — no.** Same reason, and AC-18's guarantee is a structural
  grep (above), not something a widget test can express without asserting an
  unreachable state.

**Existing tests: none need updating.** Grepped — no test file references
`ErrorRetryWidget`, `LibraryStatsWidget`, `CriticsGridWidget`,
`CountdownReleasesWidget`, `no_results_found` or `GamesStatus.empty`.
`games_screen_test.dart` exercises `GamesSliverGrid` only. AC-27 therefore
reduces to "the suite is no worse than the recorded baseline".

**Finder note — this is the trap item 2.7 hit, so it is settled here, not left
to Dev.** The card's fill must be findable single-match from outside.

- `find.byType(DecoratedBox)` scoped to the component is **not** single-match:
  `PrimaryButton` wraps its label in `Container(decoration: BoxDecoration(…))`,
  and `Container.build` emits a `DecoratedBox` whenever `decoration != null`
  (`/opt/flutter/packages/flutter/lib/src/widgets/container.dart:421-423`) — and
  `ButtonPressScale` adds a *second* one while focused (`button_press_scale.dart:37-43`).
  So the card must not be a `DecoratedBox`.
- `find.byType(ColoredBox)` scoped to the component **is** single-match with the
  `ClipRRect`+`ColoredBox` shape: `Container` emits a `ColoredBox` only when its
  `color` argument is non-null (same file, `:405-407`), and neither Container in
  the `PrimaryButton` chain passes `color`. `Icon` and `Text` emit none —
  `ColoredBox` appears in only six files under
  `/opt/flutter/packages/flutter/lib/src/widgets/`, none of them `icon.dart`,
  `text.dart`, `transitions.dart` or `actions.dart`. This is what `ErrorNotice`
  got wrong: its `_ErrorToast` fill *and* its `ErrorDot` child both draw a
  `ColoredBox` (`error_dot.dart:18`), so its test had to fall back to a colour
  predicate. `EmptyStateCard` has no such child.
- **Caveat, stated plainly:** this phase had no shell available, so the claim is
  verified against the Flutter SDK source on disk rather than by pumping the
  tree. Dev must confirm the assertion resolves when the test is written; if it
  does not, switch to `error_notice_test.dart:65-72`'s `byWidgetPredicate` form
  (`ColoredBox` whose `color` is `surfaceRaised`) rather than deepening the
  finder.

**What the test must not do:** no dimension, gap, radius or position assertion;
no `matchesGoldenFile`; colour assertions name the token, never a hex (AC-26).
AC-05's "no `maxLines`, no ellipsis" and AC-07/AC-09/AC-10 are code-inspection
criteria, not assertions — pinning `maxLines == null` would copy the
implementation into a second file. Keep the file at or under
`hairline_group_test.dart`'s length; import only
`package:…/widgets/empty_state_card.dart` plus the token file.

## Out of scope

- Any foundations edit: no new colour token, no `cardHeading` caps flag change,
  no `app_*_tokens.dart` file touched. `system-foundation-specs.md` §2.2's
  "art-deep is the empty-state card fill" stays an unimplemented foundations gap
  to record, per gate CRITICAL-1.
- Loading/shimmer and error branches at all five sites (AC-20).
- `tracker_tasks_section.dart`, `tracker_game_detail_section.dart` (AC-21).
- `ErrorRetryWidget`'s implementation and its four genuine error call sites
  (`games_screen.dart` ×2, `detail_mid_section.dart`, `detail_top_header.dart`).
- `project-conventions.md` — FR-2.8.5 puts the note in the skill; line 11 there
  only points at it.
- Wording of the three reused keys beyond dropping the arrow.

## Open questions

None.

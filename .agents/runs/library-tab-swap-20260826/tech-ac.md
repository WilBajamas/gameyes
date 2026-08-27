# Technical Acceptance Criteria
Source: `.agents/week-3-task-briefs.md` — Stage 3, item 3.2 (as corrected 2026-08-26), with the preamble "What week 3 does NOT touch" and "Baselines"; `.agents/handover.md` "Stage 3 brief" rulings 1 and 6 and the six-row `setActiveIndex` table; `orchestrator-state.md` "## Orchestrator decision — 2026-08-26, Phase 1" and "## Corrections to the checklist's inherited claims"
Date: 2026-08-26
BA Agent version: 1.0

## Feature summary

Change the app's bottom tab set from five tabs
(`Featured · Games · Tracker · Browse · Settings`) to four
(`Featured(0) · Library(1) · Games(2) · Settings(3)`). Library is a new tab
occupying index 1; Tracker and Browse are removed as tabs; Games moves 1 → 2 and
Settings 4 → 3. Because index is derived from declaration order in three parallel
lists (the destination enum, the `AutoTabsRouter` routes list, the router
children), all three must be reordered together and the generated router
regenerated. Every one of the six hard-coded `setActiveIndex` literals in the app
changes value, and the new Library screen adds a seventh. The Library tab is
backed by a deliberately throwaway shell — a title and an unconditional empty
state, no bloc, no repository, no datasource — whose only purpose is to freeze
the final indices before Stage 4 builds on them. Three source files retire
(`tracker_screen.dart`, `saved_game_item.dart`, all of `lib/features/browse/`)
and three l10n key edits follow. This item ships no data, no persistence and no
Library feature behaviour.

## Technical acceptance criteria

### Tab destination enum

[3.2-AC1] PRESENTATION (`lib/widgets/bottom_tab_bar/enum/bottom_tab_bar_destination.dart`):
`BottomTabBarDestination` declares exactly four values in this order —
`featured`, `library`, `games`, `settings`. The `tracker` and `browse` values are
removed. `library`'s label resolves through the new `library` l10n key; `featured`,
`games` and `settings` keep their existing icons and label keys unchanged.
  Failure case: any fifth value, or `library` declared anywhere but second, makes
  `BottomTabBarDestination.library.index != 1` and silently mis-routes every
  index-based call site. Verified by an enum-order assertion, not by reading.

[3.2-AC2] PRESENTATION: `bottom_tab_bar.dart`, `bottom_tab_bar_cell.dart`,
`bottom_tab_bar_cell_content.dart`, `bottom_tab_bar_focus_ring.dart` and
`bottom_tab_bar_cap.dart` are modified by **no** line of this item. The bar
iterates `BottomTabBarDestination.values` and reads `destination.index` for both
the selected comparison and the reported index; nothing in the widget tree names
a tab count or a slot number.
  Failure case: a diff touching any of these five files means a count or index was
  hard-coded where the enum already supplies it — reject the change.

### Route registration and ordering

[3.2-AC3] NAVIGATION (`home_screen.dart:16-22`): the `AutoTabsRouter` `routes:`
list reads `FeaturedRoute(), LibraryRoute(), GamesRoute(), SettingsRoute()` — four
entries, in that order. `TrackerRoute()` and `BrowseRoute()` are removed.
  Failure case: this list's order *is* the active index. Any mismatch with
  [3.2-AC1]'s enum order means the tab bar highlights one tab while the body shows
  another, with no compile error.

[3.2-AC4] NAVIGATION (`auto_route_config.dart:24-30`): the `HomeRoute` `children:`
list declares four child routes in the same order — paths `featured`, `library`,
`games`, `settings`. The `tracker` and `browse` child routes are deleted. The
top-level `/tracker-detail` (`TrackerGameDetailRoute`) and `/task-detail`
(`TaskDetailRoute`) routes are **not** touched.
  Failure case: deleting `/tracker-detail` breaks `library_stats.dart:319`'s
  surviving push and edits the protected task tree. Leaving the `browse`/`tracker`
  children in place leaves the generated router referencing deleted screen classes
  and fails compilation.

[3.2-AC5] GENERATED: `auto_route_config.gr.dart` is regenerated after
[3.2-AC3]/[3.2-AC4] and afterwards declares `LibraryRoute` and contains no
`BrowseRoute`, no `BrowseScreen` reference, no `TrackerRoute`, no `TrackerRouteArgs`
and no `TrackerScreen` reference. `TrackerGameDetailRoute` still exists.
  Failure case: a hand-edited `.gr.dart`, or a stale one, compiles today and is
  overwritten by the next unrelated regeneration.

### Tab index literals

[3.2-AC6] PRESENTATION: all six existing `setActiveIndex` literals are rewritten,
and none keeps its old value:

| Site | Was | Becomes | Destination |
|---|---|---|---|
| `featured_screen.dart:144` | 1 | 2 | Games |
| `featured_screen.dart:145` | 1 | 2 | Games |
| `featured_screen.dart:147` | 1 | 2 | Games |
| `featured_screen.dart:207` | 3 | 2 | Games (was Browse) |
| `countdown_releases.dart:93` | 3 | 2 | Games (was Browse) |
| `library_stats.dart:315` | 2 | 1 | Library (was Tracker) |

  Failure case: `library_stats.dart:315` is the one with no compiler help — left
  at `2` it silently opens Games instead of Library. It sits inside the
  `playingGames.isNotEmpty` branch, which has never rendered (Featured's
  `statusEqualTo('Playing')` filter has no writers) and therefore cannot be caught
  by running the app; it starts firing when item 3.4 repairs that filter. It must
  change in this item regardless of being unreachable today.

[3.2-AC7] PRESENTATION (`home_screen.dart:27`): the
`onDestinationSelected: context.tabsRouter.setActiveIndex` tear-off is unchanged.
It carries no literal.
  Failure case: rewriting it to a lambda with an index adds a seventh index
  dependency where none existed.

[3.2-AC8] PRESENTATION: after this item a repo-wide grep of `setActiveIndex` in
`lib/` returns **eight** occurrences — the six of [3.2-AC6], the tear-off of
[3.2-AC7], and one new literal in the Library shell ([3.2-AC11]). Seven of the
eight carry a literal.
  Failure case: any check phrased as "the count is six" fails a correct build.
  "Six" is a statement about the pre-change tree only.

[3.2-AC9] PRESENTATION: no other tab-index literal exists. `activeIndex`,
`tabsRouter` and `AutoTabsRouter` were grepped repo-wide at Phase 0 and the only
other `activeIndex` hits are `ProgressDots`' onboarding dots, which are unrelated
to tabs and must not be touched.
  Failure case: an index literal outside the eight sites survives the swap and
  routes to the wrong tab.

[3.2-AC10] PRESENTATION (`library_stats.dart:314`): the comment
`// Route to Tracker tab [Z1-BL-04]` does not survive describing the destination as
Tracker. Per the project's widget rule, a widget file carries no comments — remove
it rather than rewording it.
  Failure case: the codebase's next reader inherits a comment that names a tab that
  no longer exists — the exact stale-instruction failure item 3.1 exists to close.

### The Library shell

[3.2-AC11] PRESENTATION: a new Library screen renders, in the Library tab, a title
reading the localized `library` string and — unconditionally, with no loading,
error or populated branch — one `EmptyStateCard` whose headline is
`no_games_saved`, supporting line is `no_games_saved_description`, action label is
`browse_games`, and whose action calls `setActiveIndex(2)` (Games).
  Failure case: the shell ships with no state to branch on because this item ships
  no data source; a loading spinner or an error state here is fabricated behaviour.
  `EmptyStateCard` requires both `actionLabel` and `onActionPressed`, so an
  action-less variant is not available and a dead button is not acceptable.

[3.2-AC12] PRESENTATION: the Library screen registers no `ScrollController`
listener and performs no write to `ScrollNotifier`. Deleting `browse_screen.dart`
takes `ScrollNotifier`'s writer count from three to two (`settings_screen`,
`home_screen`); this item leaves it at two.
  Failure case: a third writer reopens item 2.4's closed follow-up, which the item
  text explicitly forbids. `home_screen.dart`'s `NotificationListener` already
  covers the tab body.

[3.2-AC13] ARCHITECTURE: the Library shell introduces no bloc, cubit, repository,
use case, datasource, DTO, entity or DI registration. Nothing under
`lib/features/library/` exists beyond the screen and whatever the route generator
produces.
  Failure case: a speculative `LibraryCubit` here pre-empts item 3.4's state-shape
  decisions (search composing with the active chip, view-mode persistence) and item
  3.3's schema decisions, and will be rewritten rather than extended.

[3.2-AC14] PRESENTATION: the Library shell renders none of §11's empty-state
design — no recruit card, no `surfaceArtDeep`, no green CTA, no
`Showing 0 games out of 0` line, no status chips, no search field, no view toggle.
  Failure case: building §11 here duplicates work item 4.5 owns and does it before
  the data layer exists to feed the count line.

### Retirements

[3.2-AC15] SOURCE: these are deleted in full —
`lib/features/tracker/presentation/screens/tracker_screen.dart`,
`lib/widgets/saved_game_item.dart`, and the whole of `lib/features/browse/`
(which contains exactly one file, `presentation/screens/browse_screen.dart`).
  Failure case: `browse_screen.dart` is 59 lines — a `StatefulWidget` with its own
  `ScrollController`, an `initState`/`dispose` pair, a `ScrollNotifier` write and a
  `DefaultSliverAppBar` — not the bare `Center(child: Text('Browse'))` the brief
  describes. Deleting it is still free (no bloc, no datasource, no other file in
  the folder), but a run expecting a one-liner should not stop short.

[3.2-AC16] SOURCE: `lib/widgets/saved_game_status_tag.dart` and its `Status` enum
are **not** deleted, and `tracker_game_detail_screen.dart` is not modified by a
single line. The retirement is deferred by orchestrator decision (see
`orchestrator-state.md`, "## Orchestrator decision — 2026-08-26, Phase 1") because
the widget's only caller, `tracker_game_detail_screen.dart:131-133`, is inside the
task tree the human's standing decision protects.
  Failure case: deleting the widget forces an edit inside a dormant, design-pending
  screen ahead of the convention meant to govern it. Substituting `StatusChip`
  there is worse — it invents a status mapping for a screen this item does not
  design.

[3.2-AC17] SOURCE: deleting `tracker_screen.dart` drops `TrackerCubit` and
`lib/widgets/default_filter_list_app_bar.dart` to zero `lib/` callers. Both are
**flagged, not deleted**: `TrackerCubit` stays DI-registered, both keep their
existing passing tests, and item 3.4 renames and extends the tracker preferences
plumbing. `lib/widgets/default_alert_dialog.dart` is **not** orphaned —
`task_detail_screen.dart:319` still uses it and that file survives.
  Failure case: sweeping `default_alert_dialog.dart` breaks the surviving task
  detail screen at compile time. Sweeping `TrackerCubit` deletes work item 3.4
  reuses and removes passing tests from the baseline. Neither orphan produces an
  analyzer issue, so neither can be justified as a cleanup.

[3.2-AC18] SOURCE: the tracker task tree is untouched —
`tracker_game_detail_screen.dart`, `task_detail_screen.dart`, `TaskCubit`,
`GroupTask`, `SavedGameTask`, `TaskStep`, the Isar `SavedGame` store and
`horizontal_separator.dart` all survive unmodified. `TrackerRepository` and
`TrackerCubit` and their tests survive.
  Failure case: the analyzer baseline of **2 warnings** depends on the deliberate
  `_TaskReminder` pair in `task_detail_screen.dart`. A post-change analyzer
  reporting 28 issues rather than 30 means part of the tree was deleted.

### Localization

[3.2-AC19] L10N: exactly three key edits are made, applied identically to
`lib/l10n/intl_en.arb` and `lib/l10n/intl_zh.arb` — add `library`, delete `browse`,
delete `tracker`. English `library` is `Library`; Chinese `library` is `游戏库`.
  Failure case: `tracker` becomes unreferenced by the same edit that frees
  `browse`, though the item text names only `browse` — its only uses are the enum
  label switch and the tab-bar test fixture, both rewritten here. A key present in
  one `.arb` and absent from the other produces a locale-dependent missing string.

[3.2-AC20] L10N: `browse_games` and `browse_for_your_next_game` still exist in both
`.arb` files and still have generated getters after regeneration. Both are live on
Featured — `featured_screen.dart:205` and `countdown_releases.dart:91-92` — and
`browse_games` gains a third caller from [3.2-AC11].
  Failure case: `intl_utils` regenerates strictly from the `.arb` files, so a key
  deleted by a text-search sweep for "browse" silently takes its getter with it and
  breaks Featured's two empty states.

[3.2-AC21] L10N: every other key whose last caller disappears with
`tracker_screen.dart` — `delete_saved_game`, `recently_changed` and the rest of
that screen's strings — is **left in place**.
  Failure case: an unreferenced key costs an unused getter and nothing else, while
  deleting one is irreversible-by-accident and item 3.4 may want them back.

[3.2-AC22] GENERATED: `dart pub global run intl_utils:generate` is run after the
`.arb` edits, and `S.current.library` compiles. `library` is a Dart *built-in
identifier*, not a reserved word, so `String get library` is a legal member name.
  Failure case: if generation or analysis rejects the identifier, rename the key to
  `library_tab` in both `.arb` files and at its call sites — the fallback, not the
  default. Confirm by running the generator, not by reasoning about it.

[3.2-AC23] L10N: the untranslated-key count does not fall by the amount the diff
suggests. `浏览` (browse) and `追踪` (tracker) were two of the very few real Chinese
translations and both are deleted here; `游戏库` and the two reused `no_games_saved`
keys (which hold English values in `intl_zh.arb`) are the offsetting additions.
  Failure case: a check asserting "untranslated keys decreased by N" fails a correct
  build. Derive the number by diffing the two files' *values*, never by counting
  keys or quoting the standing figure of 63.

### Tests

[3.2-AC24] TEST (`test/widget/components/bottom_tab_bar_test.dart:9-23`): both
fixture lists drop from five entries to four and read
`featured, library, games, settings` in that order, with `library`'s glyph matching
the enum.
  Failure case: a fixture still naming `S.current.tracker` or `S.current.browse`
  fails to compile once [3.2-AC19] removes those getters.

[3.2-AC25] TEST (`:80`): the second `pumpWidget` in "shows every destination label
and glyph whichever destination is selected" pumps `selectedIndex: 3`, not `4`.
  Failure case: index 4 no longer exists; the test's purpose is to exercise the
  last destination as selected, which is now Settings at 3.

[3.2-AC26] TEST (`:157-177`): the "announces the destination name once with its
localized tab position" test is retargeted from `S.current.tracker` to
`S.current.library`, and its `tabLabel` assertion becomes
`tabIndex: 1, tabCount: 4` (Library is enum index 1, i.e. tab 2 of 4).
  Failure case: leaving `tabIndex: 3, tabCount: 5` asserts a screen-reader
  announcement the widget no longer produces, and the retargeting is invisible to
  the compiler once the string changes.

[3.2-AC27] TEST (`:199`): the test named "keeps all five destinations while the
body scrolls with no scroll state" is renamed to say four.
  Failure case: a passing test whose name states a wrong fact is the same
  stale-instruction failure as [3.2-AC10].

[3.2-AC28] TEST (`test/widget/components/default_sliver_app_bar_test.dart:20,82`):
the literal string `'Browse'` appears twice as an app-bar title fixture and is
**not** touched. It has no relationship to `BrowseScreen` or the `browse` l10n key.
  Failure case: a grep-driven sweep for "Browse" breaks a passing, unrelated test.

[3.2-AC29] TEST: the Library shell gets a widget test covering [3.2-AC11] — the
title renders, the empty state renders, and tapping the action reports index 2. No
`matchesGoldenFile`, in this or any test.
  Failure case: the shell is throwaway but the index it hands to Games is not — that
  literal is exactly the class of value [3.2-AC6] shows survives by looking correct.

[3.2-AC30] TEST: no test in the repository pumps `HomeScreen` or asserts the tab
route list. The four test files importing `auto_route_config`
(`session_navigator_test`, `auth_guard_test`, `games_screen_test`,
`welcome_screen_test`) use unrelated routes and need no edit.
  Failure case: assuming a route-list test exists and "fixing" it edits a test that
  was never about tabs.

[3.2-AC31] BASELINE: after the change, `flutter analyze` reports **30 issues / 0
errors / 2 warnings / 28 info**, and `flutter test` reports the same ten
pre-existing failures and no new ones — `tracker_repository_test` (4),
`game_detail_cubit_test` (3), `games_bloc_test` (3). Passing count is at least 361
(it rises by [3.2-AC29]'s new test).
  Failure case: 28 analyzer issues means part of the protected task tree was
  deleted ([3.2-AC18]). A new failure in `tracker_cubit_test` means `TrackerCubit`
  was swept ([3.2-AC17]). The three `games_bloc_test` failures are explicitly out of
  scope and must not be "fixed" here.

## Out of scope

- Retiring `saved_game_status_tag.dart` and its `Status` enum, and any edit to
  `tracker_game_detail_screen.dart` — deferred by orchestrator decision to whichever
  item adopts the incoming task-tree design convention.
- Deleting `TrackerCubit`, `TrackerRepository`, `default_filter_list_app_bar.dart`,
  the Isar `SavedGame` store, or any part of the task tree.
- §11's full empty state — recruit card, `surfaceArtDeep`, the green CTA, the
  `Showing 0 games out of 0` line. Item 4.5.
- The Library data layer, schema migration and status mapping. Item 3.3.
- `LibraryBloc`, filtering, sorting, view mode, persistence, pagination, and the
  Featured `statusEqualTo('Playing')` repair. Item 3.4.
- The `games_bloc_test` failures (restructuring; would move the baseline mid-week).
- Renaming Games to Browse or giving it `Icons.search_outlined` — the human's stated
  eventual intent, explicitly a later week's work.
- Reopening item 2.4's `ScrollNotifier` follow-up.
- Correcting `home-screen-design-conventions.md:113`'s superseded five-tab IA
  (`Home · Library · Search · Feed · Profile`). Ruling 1 governs; the stale doc is a
  handover note, not this item's work.

## Assumptions

ASSUMPTION: The Library tab's glyph is unspecified in every design document and is
assumed to be `Icons.collections_bookmark_outlined`.
`library-design-conventions.md:168` says only "Tab bar. Unchanged from Home.
Library active: indigo glyph and label"; `home-screen-design-conventions.md:108-115`
gives sizes but no icon names for a five-tab IA that ruling 1 supersedes. The
assumed glyph matches the existing set's `_outlined` convention and reads as a saved
collection rather than as books or video. One enum line — cheap for the human to
overrule at the Phase 3 gate.

ASSUMPTION: The new screen is `lib/features/library/presentation/screens/library_screen.dart`
carrying `@RoutePage()` so `LibraryRoute` generates; no `lib/features/library/` tree
exists today. Route path `library`.

ASSUMPTION: The shell's empty state reuses `no_games_saved`,
`no_games_saved_description` and `browse_games` rather than minting copy. All three
already exist in both `.arb` files; the first two are freed by `tracker_screen.dart`'s
deletion (its improvised bare-`Text` empty state at `:179-202` is their only current
use) and both still hold English values in `intl_zh.arb`, so reuse also folds two
untranslated keys into this run's zh work.

ASSUMPTION: The zh value for `library` is `游戏库`. If it overflows the tab cell in
`bottom_tab_bar_test.dart`'s "renders every destination without overflow in zh at a
raised text scale" case, the fallback is the two-character `收藏` rather than widening
the cell — the tab bar's geometry is not this item's to change.

ASSUMPTION: `library` generates and compiles as an `S` member ([3.2-AC22]). It is a
Dart built-in identifier, not a reserved word, so this is expected to work; it has
not been compiled here because BA has no shell. `library_tab` is the fallback only if
the generator or analyzer actually rejects it.

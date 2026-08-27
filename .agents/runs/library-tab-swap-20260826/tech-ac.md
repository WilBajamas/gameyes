# Technical Acceptance Criteria
Source: `.agents/week-3-task-briefs.md` — Stage 3, item 3.2 (as corrected 2026-08-26 at the Phase 3 gate), with the preamble "What week 3 does NOT touch" and "Baselines"; `.agents/handover.md` "Stage 3 brief" rulings 1 and 6 and the six-row `setActiveIndex` table; `orchestrator-state.md` "## Human decisions — 2026-08-26, Phase 3 design gate" (D6, D7), "## Orchestrator decision — 2026-08-26, Phase 1" and "## Corrections to the checklist's inherited claims"
Date: 2026-08-27 (revision 2 — retargeted from the superseded four-tab shape to D6's five)
BA Agent version: 1.0

## Feature summary

Change the app's bottom tab set from `Featured · Games · Tracker · Browse ·
Settings` to `Featured(0) · Library(1) · Browse(2) · Feed(3) · Settings(4)`. The
count stays at five. Library and Feed are new; Tracker loses its tab; the old
`browse_screen.dart` stub is deleted and its *name* passes to the existing Games
screen, which moves 1 → 2 and is relabelled user-visibly only — the feature
folder, bloc, repository, datasource and `GamesScreen` class name are all
unchanged. Settings does not move. Because index is derived from declaration
order in three parallel lists (the destination enum, the `AutoTabsRouter` routes
list, the router children), all three are reordered together and the generated
router regenerated. All six hard-coded `setActiveIndex` literals change value and
the Library shell adds a seventh. Library ships a deliberately throwaway shell —
title plus an unconditional empty state; Feed ships a deliberately barer one —
title plus a centred line of text, no card. Neither has a bloc, repository or
datasource. Three source files retire (`tracker_screen.dart`,
`saved_game_item.dart`, all of `lib/features/browse/`) and four l10n key edits
follow. This item ships no data, no persistence and no Library or Feed behaviour.

**Revision note.** IDs are stable across this revision — a criterion that still
holds keeps its number. New criteria are numbered from 32 up and sit in their
logical section, so the list is not ID-ordered end to end.

## Technical acceptance criteria

### Tab destination enum

[3.2-AC1] PRESENTATION (`lib/widgets/bottom_tab_bar/enum/bottom_tab_bar_destination.dart`):
`BottomTabBarDestination` declares exactly five values in this order —
`featured`, `library`, `browse`, `feed`, `settings`. The `games` and `tracker`
values are removed; `browse` **survives and is reused** as slot 2's identity for
the Games screen. `library` and `feed` resolve their labels through the new
`library` and `feed` l10n keys; `browse` keeps `S.current.browse`; `featured` and
`settings` keep their existing icons and label keys unchanged.
  Failure case: the count is unchanged at five, so an off-by-one here produces no
  size mismatch anywhere and fails silently — `library` declared anywhere but
  second, or `browse` anywhere but third, mis-routes every index-based call site
  while the bar still looks right. Verified by an enum-order assertion, not by
  reading. Slot 2's glyph is an open one-line question — see the assumptions.

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
list reads `FeaturedRoute(), LibraryRoute(), GamesRoute(), FeedRoute(),
SettingsRoute()` — five entries, in that order. `TrackerRoute()` and
`BrowseRoute()` are removed. `GamesRoute` keeps its generated name because
`GamesScreen` keeps its class name ([3.2-AC36]); it is slot 2 despite being named
`GamesRoute`.
  Failure case: this list's order *is* the active index. Any mismatch with
  [3.2-AC1]'s enum order means the tab bar highlights one tab while the body shows
  another, with no compile error — and with the count unchanged at five there is
  no length check to catch it either.

[3.2-AC4] NAVIGATION (`auto_route_config.dart:24-30`, actual path
`lib/config/route/auto_route_config.dart`): the `HomeRoute` `children:` list
declares five child routes in the same order — `FeaturedRoute`, `LibraryRoute`,
`GamesRoute`, `FeedRoute`, `SettingsRoute`. The `tracker` and `browse` child
routes are deleted. Whether slot 2's **path** stays `games` or becomes `browse` is
the Tech Lead's call and is not fixed here; either satisfies this criterion. The
top-level `/tracker-detail` (`TrackerGameDetailRoute`) and `/task-detail`
(`TaskDetailRoute`) routes are **not** touched.
  Failure case: deleting `/tracker-detail` breaks `library_stats.dart:319`'s
  surviving push and edits the protected task tree. Leaving the `browse`/`tracker`
  children in place leaves the generated router referencing deleted screen classes
  and fails compilation. Nothing user-visible turns on the path choice — Android
  declares no `VIEW` intent filter, so URL deep links cannot be delivered at all.

[3.2-AC5] GENERATED: `auto_route_config.gr.dart` is regenerated after
[3.2-AC3]/[3.2-AC4] and afterwards declares `LibraryRoute` and `FeedRoute`, still
declares `GamesRoute` and `TrackerGameDetailRoute`, and contains no `BrowseRoute`,
no `BrowseScreen` reference, no `TrackerRoute`, no `TrackerRouteArgs` and no
`TrackerScreen` reference.
  Failure case: a hand-edited `.gr.dart`, or a stale one, compiles today and is
  overwritten by the next unrelated regeneration.

### Tab index literals

[3.2-AC6] PRESENTATION: all six existing `setActiveIndex` literals are rewritten,
and none keeps its old value:

| Site | Was | Becomes | Destination |
|---|---|---|---|
| `featured_screen.dart:144` | 1 | 2 | Browse (the Games screen) |
| `featured_screen.dart:145` | 1 | 2 | Browse (the Games screen) |
| `featured_screen.dart:147` | 1 | 2 | Browse (the Games screen) |
| `featured_screen.dart:207` | 3 | 2 | Browse (was the deleted stub) |
| `countdown_releases.dart:93` | 3 | 2 | Browse (was the deleted stub) |
| `library_stats.dart:315` | 2 | 1 | Library (was Tracker) |

  D6 did not move a single row of this table: every "go find a game" site still
  lands on 2, and `library_stats.dart:315` still moves to 1.
  Failure case: `library_stats.dart:315` is the one with no compiler help — left
  at `2` it silently opens Browse instead of Library. It sits inside the
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
eight carry a literal. The Feed shell adds none ([3.2-AC32]).
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
  Note `:317`'s `// Go to Tracker detail for this game` describes
  `TrackerGameDetailRoute`, which survives; it is not stale and not this item's to
  sweep.

### The Library shell

[3.2-AC11] PRESENTATION: a new Library screen renders, in the Library tab, a title
reading the localized `library` string and — unconditionally, with no loading,
error or populated branch — one `EmptyStateCard` whose headline is
`no_games_saved`, supporting line is `no_games_saved_description`, action label is
`browse_games`, and whose action calls `setActiveIndex(2)` (Browse).
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

### The Feed shell

[3.2-AC32] PRESENTATION: a new Feed screen renders, in the Feed tab, a title
reading the localized `feed` string and a single centred `Text` — nothing else. It
renders **no** `EmptyStateCard`, no glyph, no action and no button, and it calls
`setActiveIndex` nowhere.
  Failure case: giving Feed the Library shell's `EmptyStateCard` treatment
  contradicts an explicit human decision at the Phase 3 gate — the asymmetry is
  deliberate, because Feed is replaced wholesale when it is designed while
  Library's empty state is the one item 4.5 evolves. An `EmptyStateCard` here also
  demands an action destination that does not exist.

[3.2-AC33] ARCHITECTURE: the Feed shell introduces no bloc, cubit, repository, use
case, datasource, DTO, entity or DI registration, registers no `ScrollController`
listener, and performs no write to `ScrollNotifier`.
  Failure case: `ScrollNotifier`'s writer count must land at two ([3.2-AC12]).
  Feed is the second new screen in this item and the second chance to reopen item
  2.4's closed follow-up.

### The relabelled Browse tab (the Games screen)

[3.2-AC35] PRESENTATION (`games_screen.dart:171`): the app-bar title changes from
`S.current.games` to `S.current.browse`, so the screen's own heading matches its
tab label. `S.current.games_screen_subtitle` at `:172` is a separate key and is
**not** changed by this item.
  Failure case: `games` is deleted as a key by [3.2-AC19], so leaving `:171` alone
  is a compile error rather than a silent mismatch — but "fix" it by reinstating
  the `games` key and the tab and the screen it opens disagree on their own name.

[3.2-AC36] ARCHITECTURE: the relabel is user-visible only. `lib/features/games/`
keeps its folder name; `GamesScreen`, `GamesBloc`, `GamesRepository`, the games
datasource, `GamesRoute` and every games test file keep their existing names. No
file under `lib/features/games/` is renamed or moved by this item.
  Failure case: renaming the feature is a large diff across code already slated for
  wholesale redesign, and it would collide with that redesign's own diff. The
  human's stated end state is that the screen becomes Browse in name too — under
  new conventions, in a later week, not here.

### Retirements

[3.2-AC15] SOURCE: these are deleted in full —
`lib/features/tracker/presentation/screens/tracker_screen.dart`,
`lib/widgets/saved_game_item.dart`, and the whole of `lib/features/browse/`
(which contains exactly one file, `presentation/screens/browse_screen.dart`).
  Failure case: `browse_screen.dart` is 59 lines — a `StatefulWidget` with its own
  `ScrollController`, an `initState`/`dispose` pair, a `ScrollNotifier` write and a
  `DefaultSliverAppBar` — not the bare `Center(child: Text('Browse'))` the brief
  describes. Deleting it is still free (no bloc, no datasource, no other file in
  the folder), but a run expecting a one-liner should not stop short. Its *name*
  passes to the Games screen ([3.2-AC35]); its *code* does not survive in any form.

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

[3.2-AC19] L10N: exactly four key edits are made, applied identically to
`lib/l10n/intl_en.arb` and `lib/l10n/intl_zh.arb` — add `library`, add `feed`,
delete `games`, delete `tracker`. **`browse` is kept**: it is slot 2's label and
`games_screen.dart:171`'s title. English values are `Library` and `Feed`; Chinese
values are `游戏库` and `动态` — real translations, not English placeholders, per
the translate-as-you-touch rule.
  Failure case: D6 inverted this from the four-tab shape, where `browse` was the
  key being deleted. Deleting `browse` now removes the surviving tab's own label.
  `games` is the key that goes: after [3.2-AC1] and [3.2-AC35] its last two callers
  are gone. `tracker` goes with the enum value and the test fixture. A key present
  in one `.arb` and absent from the other produces a locale-dependent missing
  string.

[3.2-AC20] L10N: `browse_games` and `browse_for_your_next_game` still exist in both
`.arb` files and still have generated getters after regeneration. Both are live on
Featured — `featured_screen.dart:205` and `countdown_releases.dart:91-92` — and
`browse_games` gains a third caller from [3.2-AC11].
  Failure case: `intl_utils` regenerates strictly from the `.arb` files, so a key
  deleted by a text-search sweep for "browse" or for "games" silently takes its
  getter with it and breaks Featured's two empty states.

[3.2-AC21] L10N: every other key whose last caller disappears with
`tracker_screen.dart` — `delete_saved_game`, `recently_changed` and the rest of
that screen's strings — is **left in place**. So is `games_screen_subtitle`, whose
caller survives.
  Failure case: an unreferenced key costs an unused getter and nothing else, while
  deleting one is irreversible-by-accident and item 3.4 may want them back.

[3.2-AC22] GENERATED: `dart pub global run intl_utils:generate` is run after the
`.arb` edits, and `S.current.library` and `S.current.feed` both compile. `library`
is a Dart *built-in identifier*, not a reserved word, so `String get library` is a
legal member name; `feed` is an ordinary identifier.
  Failure case: if generation or analysis rejects `library`, rename that key to
  `library_tab` in both `.arb` files and at its call sites — the fallback, not the
  default. Confirm by running the generator, not by reasoning about it.

[3.2-AC23] L10N: the untranslated-key count does not move the way the diff
suggests. `追踪` (tracker) is a real Chinese value being deleted; `浏览` (browse)
now **survives**; `游戏` (games) is a real value being deleted with its key; `游戏库`
and `动态` are real values being added, and the two reused `no_games_saved` keys
hold English values in `intl_zh.arb` today.
  Failure case: a check asserting "untranslated keys decreased by N" fails a correct
  build. Derive the number by diffing the two files' *values*, never by counting
  keys or quoting the standing figure of 63.

### Tests

[3.2-AC24] TEST (`test/widget/components/bottom_tab_bar_test.dart:9-23`): both
fixture lists stay at **five** entries and read `featured, library, browse, feed,
settings` in that order, with `library`'s and `feed`'s glyphs matching the enum and
`browse`'s glyph matching whatever [3.2-AC1] gives slot 2.
  Failure case: the list length does not change, so a fixture reordered wrongly
  still passes the label-presence tests and only fails the index-dependent ones. A
  fixture still naming `S.current.tracker` or `S.current.games` fails to compile
  once [3.2-AC19] removes those getters — that compile error is the only free
  catch in this file, and it does not extend to any of the numbers.

[3.2-AC25] TEST (`:80`): the second `pumpWidget` in "shows every destination label
and glyph whichever destination is selected" still pumps `selectedIndex: 4` and is
**unchanged**. The test's purpose is to exercise the last destination as selected;
that is still Settings, still at 4.
  Failure case: changing it to 3 by analogy with the superseded four-tab shape
  pumps Feed and silently stops covering the case the test exists for.

[3.2-AC26] TEST (`:157-177`): the "announces the destination name once with its
localized tab position" test is retargeted from `S.current.tracker` to
`S.current.browse` at `:166`, `:167` and `:172`. The assertion
`tabLabel(tabIndex: 3, tabCount: 5)` at `:168-170` is **unchanged**.
  Failure case: `tabLabel`'s `tabIndex` is 1-based, so `tabIndex: 3` names enum
  index 2 — which was Tracker and is now Browse, the same slot. The numbers are
  correct precisely because the tab count did not change; "correcting" them to
  match a 0-based reading, or retargeting to Library without moving `tabIndex` to
  2, asserts an announcement the widget does not produce.

[3.2-AC27] TEST (`:199`): the test named "keeps all five destinations while the
body scrolls with no scroll state" keeps that name — five is still correct.
  Failure case: renaming it to four carries the superseded shape into a test name,
  which is the same stale-instruction failure as [3.2-AC10] in the other direction.

[3.2-AC37] TEST (`:90-108`, "reports the tapped destination index once per tap"):
the finder is retargeted from `S.current.games` to `S.current.browse` at `:98` and
`:102`, `:99`'s `find.byIcon` is retargeted to slot 2's glyph per [3.2-AC1], and
the assertion at `:107` becomes `expect(reported, [2, 2, 2])`.
  Failure case: this is Tech Lead finding TL-1 and it fails at **run time, not
  compile time**. The compiler forces the string edit (the `games` getter is gone)
  but says nothing about the number, so a mechanical `games` → `browse` sweep
  leaves `[1, 1, 1]` asserting that tapping the third cell reports the second
  index. The same sweep silently retargets the icon finder to a glyph that may now
  sit in a different cell.

[3.2-AC38] TEST (`:110-155`, "moves the selected state to the destination the
caller supplies"): every `S.current.games` at `:124`, `:128`, `:136` and `:149` is
retargeted to `S.current.browse`, and the `pumpWidget` at `:141` pumps
`selectedIndex: 2`, not `1`, so the index pumped is the enum index of the
destination the assertions name. The `:119-138` half, which asserts that tapping a
cell does **not** move the selection, keeps its existing expectations.
  Failure case: the second half of TL-1, also run-time-only. Left at
  `selectedIndex: 1` the test pumps Library and then asserts Browse is selected and
  Featured is not — it fails, and the obvious "fix" of flipping the expectations
  would assert the opposite of the widget's contract. Retargeting to Library
  instead of Browse is equally acceptable only if the finder and the pumped index
  are changed together.

[3.2-AC28] TEST (`test/widget/components/default_sliver_app_bar_test.dart:20,82`):
the literal string `'Browse'` appears twice as an app-bar title fixture and is
**not** touched. It has no relationship to the `browse` l10n key, the deleted
`BrowseScreen`, or the relabelled Games screen.
  Failure case: a grep-driven sweep for "Browse" breaks a passing, unrelated test —
  and D6 makes this likelier, not less likely, because "Browse" is now a live
  label that a run has reason to be editing.

[3.2-AC29] TEST: the Library shell gets a widget test covering [3.2-AC11] — the
title renders, the empty state renders, and tapping the action reports index 2. No
`matchesGoldenFile`, in this or any test.
  Failure case: the shell is throwaway but the index it hands to Browse is not —
  that literal is exactly the class of value [3.2-AC6] shows survives by looking
  correct.

[3.2-AC34] TEST: the Feed shell gets a widget test covering [3.2-AC32] — the title
renders, the centred text renders, and `EmptyStateCard` is asserted **absent**
(`findsNothing`).
  Failure case: without the absence assertion, the one thing the human explicitly
  decided about this screen is the one thing no test protects, and the next run to
  touch Feed "improves" it into the Library shell's shape.

[3.2-AC30] TEST: no test in the repository pumps `HomeScreen` or asserts the tab
route list. The four test files importing `auto_route_config`
(`session_navigator_test`, `auth_guard_test`, `games_screen_test`,
`welcome_screen_test`) use unrelated routes and need no edit. `games_screen_test`
asserts no app-bar title string, so [3.2-AC35] does not reach it.
  Failure case: assuming a route-list test exists and "fixing" it edits a test that
  was never about tabs.

[3.2-AC31] BASELINE: after the change, `flutter analyze` reports **30 issues / 0
errors / 2 warnings / 28 info**, and `flutter test` reports the same ten
pre-existing failures and no new ones — `tracker_repository_test` (4),
`game_detail_cubit_test` (3), `games_bloc_test` (3). Passing count is at least 361
(it rises by [3.2-AC29]'s and [3.2-AC34]'s new tests).
  Failure case: 28 analyzer issues means part of the protected task tree was
  deleted ([3.2-AC18]). A new failure in `tracker_cubit_test` means `TrackerCubit`
  was swept ([3.2-AC17]). The three `games_bloc_test` failures are explicitly out of
  scope and must not be "fixed" here.

### Documentation

[3.2-AC39] DOCS (`.claude/skills/flutter-widgets/SKILL.md`): `SavedGameItem` is
removed from the legacy-widget list at `:160` and its table row at `:202` is
deleted, matching [3.2-AC15]. `:220`'s `BottomTabBar` entry — "five fixed
destinations … the other four" — is **not** edited: it is correct at five tabs.
`:203`'s `SavedGameStatusTag` row stays, per [3.2-AC16].
  Failure case: a skill file is the *enforcing* copy agents are told to obey, so a
  row naming a deleted widget is a live instruction to use it. Conversely, editing
  `:220` to say four carries the superseded shape into the file that most
  aggressively propagates it.

## Out of scope

- Renaming `lib/features/games/`, `GamesScreen`, `GamesBloc`, the games repository
  or datasource, and the Games screen's own redesign. The relabel here is the tab
  label and the app-bar title only ([3.2-AC35], [3.2-AC36]).
- The route path decision for slot 2 (`games` vs `browse`) — Tech Lead's call
  ([3.2-AC4]).
- Any Feed behaviour: content, data, social graph, notifications. The placeholder
  is replaced wholesale when Feed is designed.
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
- Reopening item 2.4's `ScrollNotifier` follow-up.
- Correcting `home-screen-design-conventions.md:113`'s superseded IA
  (`Home · Library · Search · Feed · Profile`). Ruling 1 governs. Note it is now
  *more* confusable, not less: it is also five tabs and also has a Feed, so only
  three of the five names differ.

## Assumptions

ASSUMPTION: **Slot 2's glyph is `Icons.search_outlined`** — the surviving `browse`
enum value keeps the icon it already carries. Two source sentences pull opposite
ways and the human should settle it in one line at the gate. Item 3.2's own text
says "the `browse` value **survives and is reused**", which reads as the value
surviving intact, icon included; ruling 1 says "for now Games keeps its name and
`Icons.gamepad_outlined`. Do not pre-emptively rename it or hand it
`Icons.search_outlined`" — but that sentence's premise ("keeps its name") is
exactly what D6 reverses. A search glyph also matches the human's stated end state
for this tab. This is one enum line plus one line of test fixture ([3.2-AC24]) and
one icon finder ([3.2-AC37]); nothing is blocked either way.

ASSUMPTION: The Library tab's glyph is unspecified in every design document and is
assumed to be `Icons.collections_bookmark_outlined`.
`library-design-conventions.md:168` says only "Tab bar. Unchanged from Home.
Library active: indigo glyph and label"; `home-screen-design-conventions.md:108-115`
gives sizes but no icon names. The assumed glyph matches the existing set's
`_outlined` convention and reads as a saved collection rather than as books or
video. One enum line — cheap for the human to overrule.

ASSUMPTION: The Feed tab's glyph is likewise unspecified and is assumed to be
`Icons.dynamic_feed_outlined` — same shape as the Library assumption, same
`_outlined` convention, one enum line. `home-screen-design-conventions.md:117`
mentions Feed only to say it keeps its tab.

ASSUMPTION: The new screens are
`lib/features/library/presentation/screens/library_screen.dart` and
`lib/features/feed/presentation/screens/feed_screen.dart`, each carrying
`@RoutePage()` so `LibraryRoute` and `FeedRoute` generate; neither
`lib/features/library/` nor `lib/features/feed/` exists today. Route paths
`library` and `feed`.

ASSUMPTION: The Library shell's empty state reuses `no_games_saved`,
`no_games_saved_description` and `browse_games` rather than minting copy. All three
already exist in both `.arb` files; the first two are freed by `tracker_screen.dart`'s
deletion (its improvised bare-`Text` empty state at `:179-202` is their only current
use) and both still hold English values in `intl_zh.arb`, so reuse also folds two
untranslated keys into this run's zh work.

ASSUMPTION: **Feed's centred line reuses the existing `coming_soon` key** ("Coming
Soon" / "即将推出") rather than minting throwaway copy. It already exists in both
files with a real Chinese value; its only other caller is
`game_loading_data.dart:18`, where it stands in for an unknown release date, so the
words fit but the context differs. If the human wants Feed-specific copy, mint
`feed_coming_soon` in both files with a real zh value — that is the fallback, not
the default.

ASSUMPTION: The zh values for the two new keys are `游戏库` (library) and `动态`
(feed). If either overflows the tab cell in `bottom_tab_bar_test.dart`'s "renders
every destination without overflow in zh at a raised text scale" case, the fallback
is a shorter word (`收藏` for library) rather than widening the cell — the tab bar's
geometry is not this item's to change.

ASSUMPTION: `library` generates and compiles as an `S` member ([3.2-AC22]). It is a
Dart built-in identifier, not a reserved word, so this is expected to work; it has
not been compiled here because BA has no shell. `library_tab` is the fallback only if
the generator or analyzer actually rejects it.

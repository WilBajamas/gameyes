# Task Brief
Source: `.agents/runs/library-tab-swap-20260826/tech-ac.md` (Week 3 item 3.2 — Tab swap, Library and Feed shells, Tracker tab retirement, Browse relabel)
Date: 2026-08-27 (revision 2 — retargeted from the superseded four-tab shape to D6's five)
Revised: 2026-08-27 (revision 3) — D8 removes `test/widget/feed/feed_screen_test.dart`
from this item's scope entirely. The testing-mode justification, the file allowlist,
plan step 17 and step 19's expected suite movement are corrected in place. Nothing
else changes: the five-tab shape, the ordering design, the three retirements, the
l10n inversion, the slot-2 route path and the three glyphs all stand.

## Context

Reorder the bottom tab set to `Featured(0) · Library(1) · Browse(2) · Feed(3) ·
Settings(4)` — still five tabs — so Stage 3 and Stage 4 build on final tab indices
instead of moving ones, ship throwaway Library and Feed shells so neither new tab is
dead on arrival, and relabel the existing Games screen as Browse without renaming
anything in code.

**This brief was rewritten at revision 2, not amended.** The four-tab target of
revision 1 is dead (`orchestrator-state.md` D6). The allowlist below is the one the
Dev Agent checks literally, and it has changed twice: revision 2 added two files to
MODIFY EXISTING and one to TEST FILES, and **revision 3 removes
`test/widget/feed/feed_screen_test.dart` from TEST FILES again (D8)**. Only one test
file is created by this item.

## Testing mode

**smoke** — Rule applied: *UI-only with no new logic, isolated with no shared
dependencies.* Justification: two new screens with no bloc, no repository and no
datasource, plus index, label and localisation edits to existing UI. **One** new test
file (`library_screen_test.dart` per [3.2-AC29]) and one existing test file edited.

The mode is set by what the change touches, not by how many test files it produces,
so D8 does not move it. What D8 changes is the count: `feed_screen_test.dart` is not
written, no test in the repository touches `feed_screen.dart`, and the Feed shell
ships with zero coverage by decision. [3.2-AC32] and [3.2-AC33] are carried by step
17's source read instead. Never a golden test.

## File allowlist

### CREATE NEW
- `lib/features/library/presentation/screens/library_screen.dart` — the Library tab's throwaway shell: title plus one unconditional empty state.
- `lib/features/feed/presentation/screens/feed_screen.dart` — the Feed tab's deliberately barer shell: title plus one centred line of text, no card.

### MODIFY EXISTING
- `lib/l10n/intl_en.arb` — add `library` and `feed`; delete `games` and `tracker`. **`browse` is KEPT.**
- `lib/l10n/intl_zh.arb` — the same four edits, identically placed, with real Chinese values.
- `lib/widgets/bottom_tab_bar/enum/bottom_tab_bar_destination.dart` — still five values, reordered; `games` and `tracker` removed, `library` and `feed` added, `browse` reused for slot 2.
- `lib/config/route/auto_route_config.dart` — `HomeRoute` children become `featured`, `library`, `games`, `feed`, `settings`. **The slot-2 path stays `games`** — see `tdd.md` "Routing".
- `lib/features/home/presentation/screens/home_screen.dart` — the `AutoTabsRouter` `routes:` list, in the same order.
- `lib/features/games/presentation/screens/games_screen.dart` — **one string**: `:171`'s app-bar title `S.current.games` → `S.current.browse`. Nothing else in this file or anywhere under `lib/features/games/`.
- `lib/features/featured/presentation/screens/featured_screen.dart` — four `setActiveIndex` literals.
- `lib/features/featured/presentation/widgets/countdown_releases.dart` — one `setActiveIndex` literal.
- `lib/features/featured/presentation/widgets/library_stats.dart` — one `setActiveIndex` literal, and delete the stale comment above it.
- `.claude/skills/flutter-widgets/SKILL.md` — **two lines only**: remove `SavedGameItem` from `:160`'s legacy list and delete its table row at `:202` ([3.2-AC39]). **Do not touch `:220` or `:203`.**

### DELETE
- `lib/features/tracker/presentation/screens/tracker_screen.dart`
- `lib/features/browse/presentation/screens/browse_screen.dart` — and the now-empty `lib/features/browse/` tree with it.
- `lib/widgets/saved_game_item.dart`

### TEST FILES
- `test/widget/components/bottom_tab_bar_test.dart` (modify) — retarget the five-destination fixtures and every index and label the swap moves. **Two of its numbers are already correct and must not be edited** — see step 15.
- `test/widget/library/library_screen_test.dart` (create) — the shell renders its title and empty state, and its action reports index 2 ([3.2-AC29], unaffected by D8).

**`test/widget/feed/feed_screen_test.dart` is OUT OF SCOPE (D8) and is NOT created.**
Do not create that file, do not create `test/widget/feed/`, and do not add a Feed
assertion to any other test file. **No test in the repository may touch
`feed_screen.dart`.** The Feed shell ships untested by human decision (`tech-ac.md
## Retired criteria`); [3.2-AC32] and [3.2-AC33] are verified by step 17's source
read instead. **Exactly two test files appear in the diff — one modified, one
created.** If something looks like it needs a Feed test, escalate; do not write one.

Generated outputs are implicit for the allowlisted annotated sources and are not
listed: `lib/config/route/auto_route_config.gr.dart` and `lib/generated/`
(`l10n.dart`, `intl/messages_*.dart`). **Never hand-edit either.**

## Implementation plan

**Steps 9–14 are one uninterrupted block.** Do not run `flutter analyze`, do not run
`flutter test` and do not commit between them — they are the three parallel
declaration orders plus the literals derived from them, and any check taken partway
through reads a tree whose indices disagree. **The tab count does not change, so
there is no length mismatch anywhere to catch a half-applied reorder**: a partial
state looks consistent and is not. The tree does not analyze clean between step 1
and GEN-2; per `generation.md` that is expected state and must not consume a
self-correction attempt.

Step 1: `lib/l10n/intl_en.arb` — add `"library": "Library"` and `"feed": "Feed"`
immediately after `"featured"` (line 33) so the tab labels stay in tab order, and
delete `"games"` (line 34) and `"tracker"` (line 73). **Leave `"browse"` (line 66)
alone** — it is slot 2's label now. Change nothing else: `browse_games`,
`browse_for_your_next_game`, `no_games_saved`, `no_games_saved_description`,
`coming_soon`, `games_screen_subtitle`, `delete_saved_game`, `recently_changed` and
every other key stay.

Step 2: `lib/l10n/intl_zh.arb` — the same four edits at the same positions.
`"library": "游戏库"`, `"feed": "动态"` — real translations, not English placeholders.
The deleted values are `游戏` and `追踪`; `浏览` stays.

GEN-1: `dart pub global activate intl_utils` then
`dart pub global run intl_utils:generate`. Never `flutter gen-l10n`. Confirm
`S.current.library` and `S.current.feed` exist, and that `browse`, `browse_games`,
`browse_for_your_next_game` and `coming_soon` all kept their getters. If the
generator rejects `library`, apply the [3.2-AC22] fallback (`library_tab` in both
files and at both call sites) and record it as a deviation — do not touch `feed`.

Step 3: Create `lib/features/library/presentation/screens/library_screen.dart` per
`code-plan.md`. `const` constructor — this is load-bearing, see `tdd.md` "UI layer".
No comments anywhere in the file.

Step 4: Create `lib/features/feed/presentation/screens/feed_screen.dart` per
`code-plan.md`. `const` constructor. **No `EmptyStateCard`, no glyph, no button, no
`setActiveIndex`, no `ScrollController`, no `ScrollNotifier` write** ([3.2-AC32],
[3.2-AC33]). The asymmetry with step 3 is a human decision, not an oversight — do
not make the two screens match. No comments anywhere in the file. **Nothing
automated will ever check this file** (D8) — step 17 is what checks it.

Step 5: Delete `lib/features/browse/presentation/screens/browse_screen.dart` and the
now-empty `lib/features/browse/` directory tree. It is 59 lines with its own
`ScrollController` and a `ScrollNotifier` write, not the bare
`Center(child: Text('Browse'))` older notes describe — delete all of it. Its *name*
passes to the Games screen; its *code* does not survive in any form.

Step 6: Delete `lib/features/tracker/presentation/screens/tracker_screen.dart`.
Nothing else under `lib/features/tracker/` is touched.

Step 7: Delete `lib/widgets/saved_game_item.dart`.

Step 8: `lib/features/games/presentation/screens/games_screen.dart:171` — the
`DefaultSliverAppBar`'s `title:` becomes `S.current.browse`. **Leave `:172`'s
`subtitle: S.current.games_screen_subtitle` exactly as it is.** This is the only
line of the games feature this item touches: no file under `lib/features/games/` is
renamed or moved, and `GamesScreen`, `GamesBloc`, `GamesRepository`, the games
datasource and `GamesRoute` all keep their names ([3.2-AC36]).

Step 9: `bottom_tab_bar_destination.dart` — **five** values, in this order:
`featured`, `library`, `browse`, `feed`, `settings`. `library` takes
`Icons.collections_bookmark_outlined` and `S.current.library`; `feed` takes
`Icons.dynamic_feed_outlined` and `S.current.feed`; **`browse` keeps
`Icons.search_outlined` and `S.current.browse`** — it is reused, not re-created.
Remove the `games` and `tracker` values and their `label` switch arms; leave
`featured`'s and `settings`' arms exactly as they are. The switch arms must be
reordered to match, or the file will not read as the canonical order the next two
steps are checked against.

Step 10: `auto_route_config.dart:24-30` — the `HomeRoute` `children:` list becomes,
in this order: `AutoRoute(path: 'featured', page: FeaturedRoute.page)`,
`AutoRoute(path: 'library', page: LibraryRoute.page)`,
`AutoRoute(path: 'games', page: GamesRoute.page)`,
`AutoRoute(path: 'feed', page: FeedRoute.page)`,
`AutoRoute(path: 'settings', page: SettingsRoute.page)`. Delete the `tracker` and
`browse` children. **Slot 2's path stays `games`** — a Tech Lead decision with its
reasons in `tdd.md` "Routing"; do not change it to `browse`. **Do not touch** the
top-level `/tracker-detail` or `/task-detail` routes.

Step 11: `home_screen.dart:16-22` — the `routes:` list becomes `FeaturedRoute(),
LibraryRoute(), GamesRoute(), FeedRoute(), SettingsRoute()`. `GamesRoute` in slot 2
is correct and is not a mistake. Leave `:27`'s
`onDestinationSelected: context.tabsRouter.setActiveIndex` tear-off untouched.

Step 12: `featured_screen.dart` — `:144`, `:145`, `:147` (currently `1`) and `:207`
(currently `3`) all become `setActiveIndex(2)`.

Step 13: `countdown_releases.dart:93` — `setActiveIndex(3)` becomes
`setActiveIndex(2)`.

Step 14: `library_stats.dart` — delete the comment line
`// Route to Tracker tab [Z1-BL-04]` (`:314`) outright, and change `:315`'s
`setActiveIndex(2)` to `setActiveIndex(1)`. **Leave `:317`'s
`// Go to Tracker detail for this game` in place** — it describes the surviving
`TrackerGameDetailRoute` push and is a follow-up, not this item's edit. `:315` is
the one literal with no compiler help and it sits in a branch that has never
rendered, so nothing but care catches it.

GEN-2: `dart run build_runner build --delete-conflicting-outputs`. This regenerates
`auto_route_config.gr.dart`. Afterwards it must declare `LibraryRoute` and
`FeedRoute`, still declare `GamesRoute` and `TrackerGameDetailRoute`, and contain no
`BrowseRoute`, no `BrowseScreen`, no `TrackerRoute`, no `TrackerRouteArgs` and no
`TrackerScreen`. If the command errors instead of regenerating, delete
`lib/config/route/auto_route_config.gr.dart` and re-run it once — see `tdd.md`
caveat C-2. Do not hand-edit or hand-restore it.

Step 15: `test/widget/components/bottom_tab_bar_test.dart` — six edits, and **two
deliberate non-edits**. Read the whole file before starting; a mechanical
find-and-replace on `games`, `tracker` or `browse` gets this wrong.
  a. `:9-15` and `:17-23` — both fixture lists stay at **five** entries and become
     `featured, library, browse, feed, settings`, with `library`'s glyph
     (`Icons.collections_bookmark_outlined`), `browse`'s (`Icons.search_outlined`,
     unchanged from its current tuple) and `feed`'s
     (`Icons.dynamic_feed_outlined`) matching step 9's enum.
  b. `:98`, `:102` — `S.current.games` → `S.current.browse`; `:99`'s
     `find.byIcon(Icons.gamepad_outlined)` → `find.byIcon(Icons.search_outlined)`;
     `:107`'s `expect(reported, [1, 1, 1])` → `[2, 2, 2]` ([3.2-AC37]). **The
     compiler forces the string but says nothing about the number** — this fails at
     run time, not compile time.
  c. `:124`, `:128`, `:136`, `:149` — `S.current.games` → `S.current.browse`, and
     `:141`'s `pumpWidget(... selectedIndex: 1 ...)` → `selectedIndex: 2`
     ([3.2-AC38]). Also run-time-only. The `:119-138` half, which asserts that
     tapping a cell does *not* move the selection, keeps its existing expectations.
  d. `:166`, `:167`, `:172` — `S.current.tracker` → `S.current.browse`. **`:168-170`'s
     `tabLabel(tabIndex: 3, tabCount: 5)` is UNCHANGED — do not "correct" either
     number** ([3.2-AC26]). `MaterialLocalizations.tabLabel` is 1-based
     (`assert(tabIndex >= 1)` in the Flutter source), so `tabIndex: 3` names enum
     index 2 — which was Tracker and is now Browse, the same slot. See `tdd.md`
     caveat C-5.
  e. `:190`, `:193` — `S.current.games` → `S.current.browse` in the long-press
     tooltip test. **This is not in `tech-ac.md`; see `tdd.md` TL-5.** It is
     compiler-forced (the `games` getter is gone) and carries no index, so it is a
     safe string retarget. Do not change `expect(reportedCount, 0)`.
  f. **`:80`'s `selectedIndex: 4` is UNCHANGED** ([3.2-AC25]) and **`:199`'s test
     name "keeps all five destinations…" is UNCHANGED** ([3.2-AC27]). Both are
     correct at five tabs. Changing either to a four-tab reading silently stops the
     test covering what it exists for.
  Do not add an import of `bottom_tab_bar_destination.dart` — the module's only
  public surface is `BottomTabBar`, tests included.

Step 16: Create `test/widget/library/library_screen_test.dart` per `code-plan.md` —
two tests. **This is the only test file this item creates.** Read
`test/widget/components/context_chip_test.dart` first for shape and
`test/widget/components/empty_state_card_test.dart` for the harness. If the
`Fake`-based `TabsRouter` double will not compile, apply `tdd.md` caveat C-1's
fallback (Mockito `@GenerateNiceMocks`, plus one extra `build_runner` run before
`flutter test`) and record it as a self-correction.

Step 17: **Feed verification by source read — a real step, not a formality, and not
a test file.** [3.2-AC34] was retired by D8, so **nothing automated guards the Feed
shell**: no test in the repository touches `feed_screen.dart`, and step 19's green
suite is evidence of nothing about it. Perform all three checks below and **record
the outcome of each, verbatim, in `diff-summary.md`** — QA reads that record, it does
not infer it.
  a. Read `lib/features/feed/presentation/screens/feed_screen.dart` in full — it is a
     few dozen lines — and confirm each fact individually: the title reads
     `S.current.feed`; exactly one `Text` sits inside a `Center`; and the strings
     `EmptyStateCard`, `Icons.`, `ElevatedButton`, `TextButton`, `InkWell`,
     `GestureDetector`, `onPressed`, `onTap` and `setActiveIndex` appear nowhere in
     the file ([3.2-AC32]).
  b. List `lib/features/feed/` recursively — it holds the one screen file and nothing
     else. No `bloc/`, `cubit/`, `data/`, `domain/` or `di/` directory, no DTO,
     entity, repository, use case or datasource, none of them declared inline in the
     screen, and no Feed type registered in the DI container ([3.2-AC33]).
  c. **The `ScrollNotifier` check — the one with no backstop of any kind.** Grep
     `lib/features/feed/` for `ScrollNotifier`, `ScrollController` and `addListener`:
     all three must return nothing. Then grep `lib/` repo-wide and confirm
     `ScrollNotifier` still has exactly **two** writers, `settings_screen` and
     `home_screen` ([3.2-AC12], [3.2-AC33]). Feed is the second new screen in this
     item and the second of exactly two chances to reopen item 2.4's closed
     follow-up, which this item forbids. **A third writer compiles, runs and passes
     the entire suite** — this grep is the only thing that goes red.
  Do not satisfy any of these checks by writing a test: that is precisely the file
  D8 removed from scope. If a check fails, fix `feed_screen.dart` and repeat the whole
  step; if the repo-wide writer count is not two for a reason outside the allowlist,
  escalate rather than edit.

Step 18: `.claude/skills/flutter-widgets/SKILL.md` — two lines. Remove
`` `SavedGameItem`, `` from the legacy-but-live list at `:160`, and delete the whole
table row `| `SavedGameItem` | `saved_game_item.dart` | Saved game list row with
swipe actions |` at `:202` ([3.2-AC39]). **Do not edit `:220`** — its "five fixed
destinations … the other four" is correct again at five tabs. **Do not edit
`:203`'s `SavedGameStatusTag` row** — that widget is not retired ([3.2-AC16]). No
other line of this file changes.

Step 19: Run `flutter analyze` and `flutter test`. Compare against
`orchestrator-state.md` verbatim: `Analyzer baseline: 0 errors, 2 warnings, 28 info
(30 issues total)` and `Test baseline: +361 -10`, with the ten pre-existing failures
being `test/repository/tracker/tracker_repository_test.dart` (4),
`test/cubit/game_detail/game_detail_cubit_test.dart` (3),
`test/cubit/games/games_bloc_test.dart` (3). The analyzer must still report **30
issues, 2 warnings** — **28 issues means something in the protected task tree was
deleted**, which is a failure, not a cleanup. **Passing count rises by step 16's two
Library tests and by nothing else**, and **exactly one new test file appears in the
diff** ([3.2-AC31], D8). A rise sized for two new test files, or any file under
`test/widget/feed/`, means a Feed test was written after all — that contradicts D8;
report it, do not keep it. Do not "fix" the three `games_bloc_test` failures.

19 non-generation steps, 2 generation checkpoints.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: `3.2-AC1` – `3.2-AC33` and `3.2-AC35` – `3.2-AC39` — 38 of 39. Note the
file is not ID-ordered end to end — AC32–AC39 sit in their logical sections, not at
the end.

**`3.2-AC34` is retired by D8** and lives in `tech-ac.md ## Retired criteria` — do
not implement it. `3.2-AC32` and `3.2-AC33` are **not** retired: they stand in full
and are verified by step 17's source read rather than by the suite. `3.2-AC29`, the
Library shell's test, is unaffected.

One required edit falls under [3.2-AC31] rather than having its own ID — step 15e,
the long-press tooltip test. See `tdd.md` "Findings — TL-5".

## Constraints

- **No test file for the Feed shell, anywhere (D8).** `test/widget/feed/` is not
  created and no test in the repository may reference `FeedScreen` or
  `feed_screen.dart`. The bareness of that screen is protected by step 17's source
  read, by `tech-ac.md` prose, and by nothing else — that trade-off was stated and
  accepted at the gate. Do not "restore" the coverage.
- **Widget files carry no comments at all** — not a header, not a `///`, not a note.
  This is stricter than the project-wide comment rule and it governs
  `library_screen.dart`, `feed_screen.dart` and the `library_stats.dart` edit
  (`flutter-widgets` skill; [3.2-AC10]).
- **`bottom_tab_bar/` has exactly one public surface, `BottomTabBar`.** The cell,
  cap, focus ring, content and the destination enum are internal and are not
  imported from outside the folder, **tests included**. `library_screen.dart` uses
  the literal `2`, not `BottomTabBarDestination.browse.index`.
- **The five other files in `bottom_tab_bar/` are modified by no line of this item**
  ([3.2-AC2]). A diff touching one means an index or a count was hard-coded where the
  enum already supplies it.
- **The tab count stays at five.** Anything that reads as "the bar went from five to
  four" is inherited from the superseded plan and is wrong.
- **The Browse relabel is user-visible only** ([3.2-AC36]): the tab label and
  `games_screen.dart:171`'s title. No rename of the folder, the class, the bloc, the
  repository, the datasource, `GamesRoute` or any games test file. The slot-2 route
  path stays `games`.
- Every screen is `Scaffold(body: SafeArea(child: …))`; use `context.themeData`, not
  `Theme.of(context)`; all user-facing strings through `S.current.[key]`; no
  Widget-returning function or getter; `const` wherever the linter allows; no
  odd-numbered dimensions (`flutter-widgets`).
- Screens are `StatelessWidget` by default and annotated `@RoutePage()`; feature
  screens live at `lib/features/[feature]/presentation/screens/` (`flutter-arch.md`).
- Import order: Dart SDK, then package (flutter → third-party → project), then
  relative (only for `part` and `generated/l10n.dart`), each group alphabetised.
- Generated files are never hand-written: fix the source and regenerate. If a
  generated file you cannot regenerate gets touched, `git checkout -- <path>`
  (`generation.md`).
- `intl_utils` regenerates strictly from the `.arb` files, so a deleted key silently
  takes its getter with it. Only `games` and `tracker` are deleted ([3.2-AC19]) —
  **`browse` is kept**, and a sweep for "browse" or for "games" that removes
  `browse`, `browse_games`, `browse_for_your_next_game`, `coming_soon` or
  `games_screen_subtitle` breaks live callers.
- The tracker task tree is untouched: `tracker_game_detail_screen.dart`,
  `task_detail_screen.dart`, `TaskCubit`, `GroupTask`, `SavedGameTask`, `TaskStep`,
  the Isar `SavedGame` store and `horizontal_separator.dart` all survive unmodified
  ([3.2-AC18]).
- `saved_game_status_tag.dart` and its `Status` enum are **not** deleted
  ([3.2-AC16]). `TrackerCubit`, `default_filter_list_app_bar.dart` and
  `RouteConstants.tracker` are orphaned by this item and are **flagged, not swept**
  ([3.2-AC17], `tdd.md` TL-3). `default_alert_dialog.dart` is not orphaned at all —
  `task_detail_screen.dart:319` still uses it.
- `RouteConstants.games` (`lib/core/res/const.dart:61`) is a hero-tag discriminator,
  not a route path. It keeps its caller and is not touched by the relabel.
- `test/widget/components/default_sliver_app_bar_test.dart:20,82` uses the literal
  string `'Browse'` as an unrelated title fixture — do not touch it ([3.2-AC28]).
  D6 makes this more dangerous, not less: "Browse" is now a live label.
- Preserve unrelated pre-existing changes; never revert something you did not cause.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make
tests pass, and do not add a test file that is not in the allowlist — creating
`test/widget/feed/feed_screen_test.dart` is a scope breach, not a fix. Do not add
packages to `pubspec.yaml` or touch files outside the allowlist — escalate instead.
Three named fallbacks in `tdd.md` are pre-approved and do not count as deviations
needing escalation — C-1's Mockito route, C-2's delete-and-regenerate, and C-4's
`收藏` if the zh Library label overflows the tab cell at a raised text scale — but
record which path was taken in `diff-summary.md`.

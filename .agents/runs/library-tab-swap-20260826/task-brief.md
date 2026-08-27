# Task Brief
Source: `.agents/runs/library-tab-swap-20260826/tech-ac.md` (Week 3 item 3.2 — Tab swap, Library shell, Tracker and Browse tab retirement)
Date: 2026-08-26

## Context

Cut the bottom tab set from five tabs to four — `Featured(0) · Library(1) ·
Games(2) · Settings(3)` — so that Stage 3 and Stage 4 build on final tab indices
instead of moving ones, and ship a deliberately throwaway Library shell so the new
tab is not dead on arrival.

## Testing mode

**smoke** — Rule applied: *UI-only with no new logic, isolated with no shared
dependencies.* Justification: one new screen with no bloc, no repository and no
datasource, plus index and localisation edits to existing UI. One new test file
(`library_screen_test.dart`, required by [3.2-AC29]) and one existing test file
edited. Never a golden test.

## File allowlist

### CREATE NEW
- `lib/features/library/presentation/screens/library_screen.dart` — the Library tab's throwaway shell: title plus one unconditional empty state.

### MODIFY EXISTING
- `lib/l10n/intl_en.arb` — add `library`; delete `browse` and `tracker`.
- `lib/l10n/intl_zh.arb` — the same three edits, identically placed.
- `lib/widgets/bottom_tab_bar/enum/bottom_tab_bar_destination.dart` — four values in the new order; `tracker` and `browse` removed.
- `lib/config/route/auto_route_config.dart` — `HomeRoute` children become `featured`, `library`, `games`, `settings`.
- `lib/features/home/presentation/screens/home_screen.dart` — the `AutoTabsRouter` `routes:` list, in the same order.
- `lib/features/featured/presentation/screens/featured_screen.dart` — four `setActiveIndex` literals.
- `lib/features/featured/presentation/widgets/countdown_releases.dart` — one `setActiveIndex` literal.
- `lib/features/featured/presentation/widgets/library_stats.dart` — one `setActiveIndex` literal, and delete the stale comment above it.

### DELETE
- `lib/features/tracker/presentation/screens/tracker_screen.dart`
- `lib/features/browse/presentation/screens/browse_screen.dart` — and the now-empty `lib/features/browse/` tree with it.
- `lib/widgets/saved_game_item.dart`

### TEST FILES
- `test/widget/components/bottom_tab_bar_test.dart` — retarget the five-destination fixtures and every index the swap moves.
- `test/widget/library/library_screen_test.dart` — the shell renders its title and empty state, and its action reports index 2.

Generated outputs are implicit for the allowlisted annotated sources and are not
listed: `lib/config/route/auto_route_config.gr.dart` and `lib/generated/`
(`l10n.dart`, `intl/messages_*.dart`). **Never hand-edit either.**

## Implementation plan

**Steps 7–12 are one uninterrupted block.** Do not run `flutter analyze`, do not run
`flutter test` and do not commit between them — they are the three parallel
declaration orders plus the literals derived from them, and any check taken partway
through reads a tree whose indices disagree. The tree does not analyze clean between
step 1 and GEN-2; per `generation.md` that is expected state and must not consume a
self-correction attempt.

Step 1: `lib/l10n/intl_en.arb` — add `"library": "Library"` immediately after
`"featured"` (line 33) so the tab labels stay in tab order, and delete the `"browse"`
(line 66) and `"tracker"` (line 73) entries. Change nothing else — `browse_games`,
`browse_for_your_next_game`, `no_games_saved`, `no_games_saved_description`,
`delete_saved_game`, `recently_changed` and every other key stay.

Step 2: `lib/l10n/intl_zh.arb` — the same three edits at the same positions.
`"library": "游戏库"`.

GEN-1: `dart pub global activate intl_utils` then
`dart pub global run intl_utils:generate`. Never `flutter gen-l10n`. Confirm
`S.current.library` exists and that `browse_games` / `browse_for_your_next_game` kept
their getters. If the generator rejects `library`, apply the [3.2-AC22] fallback
(`library_tab` in both files and at both call sites) and record it as a deviation.

Step 3: Create `lib/features/library/presentation/screens/library_screen.dart` per
`code-plan.md`. `const` constructor — this is load-bearing, see `tdd.md` "UI layer".
No comments anywhere in the file.

Step 4: Delete `lib/features/browse/presentation/screens/browse_screen.dart` and the
now-empty `lib/features/browse/` directory tree. It is 59 lines with its own
`ScrollController` and a `ScrollNotifier` write, not the bare `Center(child: Text('Browse'))`
older notes describe — delete all of it.

Step 5: Delete `lib/features/tracker/presentation/screens/tracker_screen.dart`.
Nothing else under `lib/features/tracker/` is touched.

Step 6: Delete `lib/widgets/saved_game_item.dart`.

Step 7: `bottom_tab_bar_destination.dart` — four values, in this order:
`featured`, `library`, `games`, `settings`. `library` takes
`Icons.collections_bookmark_outlined` and `S.current.library`. Remove the `tracker`
and `browse` values and their `label` switch arms; leave the other three arms exactly
as they are.

Step 8: `auto_route_config.dart:24-30` — the `HomeRoute` `children:` list becomes
paths `featured`, `library`, `games`, `settings` in that order. Delete the `tracker`
and `browse` children. **Do not touch** the top-level `/tracker-detail` or
`/task-detail` routes.

Step 9: `home_screen.dart:16-22` — the `routes:` list becomes `FeaturedRoute(),
LibraryRoute(), GamesRoute(), SettingsRoute()`. Leave `:27`'s
`onDestinationSelected: context.tabsRouter.setActiveIndex` tear-off untouched.

Step 10: `featured_screen.dart` — `:144`, `:145`, `:147` and `:207` all become
`setActiveIndex(2)`.

Step 11: `countdown_releases.dart:93` — becomes `setActiveIndex(2)`.

Step 12: `library_stats.dart` — delete the comment line
`// Route to Tracker tab [Z1-BL-04]` (`:314`) outright, and change `:315`'s
`setActiveIndex(2)` to `setActiveIndex(1)`. **Leave `:317`'s
`// Go to Tracker detail for this game` in place** — it describes the surviving
`TrackerGameDetailRoute` push and is a follow-up, not this item's edit.

GEN-2: `dart run build_runner build --delete-conflicting-outputs`. This regenerates
`auto_route_config.gr.dart`. Afterwards it must declare `LibraryRoute` and contain no
`BrowseRoute`, no `BrowseScreen`, no `TrackerRoute`, no `TrackerRouteArgs` and no
`TrackerScreen`, while `TrackerGameDetailRoute` still exists. If the command errors
instead of regenerating, delete `lib/config/route/auto_route_config.gr.dart` and
re-run it once — see `tdd.md` caveat C-2. Do not hand-edit or hand-restore it.

Step 13: `test/widget/components/bottom_tab_bar_test.dart` — six edits:
  a. `:9-15` and `:17-23` — both fixture lists drop to four entries reading
     `featured, library, games, settings`, with `library`'s glyph matching the enum.
  b. `:80` — `selectedIndex: 4` becomes `selectedIndex: 3`.
  c. `:107` — `expect(reported, [1, 1, 1])` becomes `[2, 2, 2]`. Games moved 1 → 2.
     **Not in `tech-ac.md`; see `tdd.md` TL-1.** It fails at run time, not compile
     time.
  d. `:140-151` — the third `pumpWidget` in *"moves the selected state…"* pumps
     `selectedIndex: 1`, which is now Library; it becomes `selectedIndex: 2` so the
     test still asserts what it was written to assert. **Also TL-1.**
  e. `:157-177` — retarget from `S.current.tracker` to `S.current.library` at all
     three uses, and the assertion becomes `tabLabel(tabIndex: 1, tabCount: 4)`.
  f. `:199` — the test name "keeps all five destinations…" says four.
  Do not add an import of `bottom_tab_bar_destination.dart` — the module's only
  public surface is `BottomTabBar`, tests included.

Step 14: Create `test/widget/library/library_screen_test.dart` per `code-plan.md` —
two tests. Read `test/widget/components/context_chip_test.dart` first for shape and
`test/widget/components/empty_state_card_test.dart` for the harness. If the
`Fake`-based `TabsRouter` double will not compile, apply `tdd.md` caveat C-1's
fallback (Mockito `@GenerateNiceMocks`, plus one extra `build_runner` run before
`flutter test`) and record it as a self-correction.

Step 15: Run `flutter analyze` and `flutter test`. Compare against
`orchestrator-state.md` verbatim: `Analyzer baseline: 0 errors, 2 warnings, 28 info
(30 issues total)` and `Test baseline: +361 -10`, with the ten pre-existing failures
being `test/repository/tracker/tracker_repository_test.dart` (4),
`test/cubit/game_detail/game_detail_cubit_test.dart` (3),
`test/cubit/games/games_bloc_test.dart` (3). The analyzer must still report **30
issues, 2 warnings** — **28 issues means something in the protected task tree was
deleted**, which is a failure, not a cleanup. Passing count should rise by step 14's
new tests. Do not "fix" the three `games_bloc_test` failures.

15 non-generation steps, 2 generation checkpoints.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: 3.2-AC1 through 3.2-AC31 (all).

Two required edits fall under [3.2-AC31] rather than having their own ID — steps 13c
and 13d. See `tdd.md` "Findings — TL-1".

## Constraints

- **Widget files carry no comments at all** — not a header, not a `///`, not a note.
  This is stricter than the project-wide comment rule and it governs
  `library_screen.dart` and the `library_stats.dart` edit (`flutter-widgets` skill;
  [3.2-AC10]).
- **`bottom_tab_bar/` has exactly one public surface, `BottomTabBar`.** The cell,
  cap, focus ring, content and the destination enum are internal and are not
  imported from outside the folder, **tests included**. `library_screen.dart` uses
  the literal `2`, not `BottomTabBarDestination.games.index`.
- **The five other files in `bottom_tab_bar/` are modified by no line of this item**
  ([3.2-AC2]). A diff touching one means an index or a count was hard-coded where the
  enum already supplies it.
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
  takes its getter with it. Only `browse` and `tracker` are deleted ([3.2-AC19]).
- The tracker task tree is untouched: `tracker_game_detail_screen.dart`,
  `task_detail_screen.dart`, `TaskCubit`, `GroupTask`, `SavedGameTask`, `TaskStep`,
  the Isar `SavedGame` store and `horizontal_separator.dart` all survive unmodified
  ([3.2-AC18]).
- `saved_game_status_tag.dart` and its `Status` enum are **not** deleted
  ([3.2-AC16]). `TrackerCubit`, `default_filter_list_app_bar.dart` and
  `RouteConstants.tracker` are orphaned by this item and are **flagged, not swept**
  ([3.2-AC17], `tdd.md` TL-3). `default_alert_dialog.dart` is not orphaned at all.
- `test/widget/components/default_sliver_app_bar_test.dart:20,82` uses the literal
  string `'Browse'` as an unrelated title fixture — do not touch it ([3.2-AC28]).
- Preserve unrelated pre-existing changes; never revert something you did not cause.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make
tests pass. Do not add packages to `pubspec.yaml` or touch files outside the
allowlist — escalate instead. The two named fallbacks in `tdd.md` (C-1's Mockito
route, C-2's delete-and-regenerate) are pre-approved and do not count as deviations
needing escalation, but record which path was taken in `diff-summary.md`.

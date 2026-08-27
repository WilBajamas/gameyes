# QA Report
Source: `.agents/runs/library-tab-swap-20260826/tech-ac.md` (Week 3 item 3.2 — Tab swap, Library and Feed shells, Tracker tab retirement, Browse relabel)
Date: 2026-08-27

Overall result: PASS — pending manual checks

Verified at `e7dcee40ac820649a8af333874a63da9dab6449f` (`3ff133d` on top is the SHA
backfill into `diff-summary.md` and carries no source or test change). Scope compared
against git over `14da82c..HEAD`, not against `diff-summary.md`'s self-report.

## Manual verification required

[3.2-AC1] — Open the app, any tab — expect five tabs left to right: Featured
(`featured_play_list_outlined`), Library (`collections_bookmark_outlined`), Browse
(`search_outlined`), Feed (`dynamic_feed_outlined`), Settings (`settings_outlined`),
with the selected one indigo (glyph, label and cap) and the other four ink-55.

[3.2-AC1]/[3.2-AC19] — Switch the device locale to Chinese and open any tab — expect
精选 · 游戏库 · 浏览 · 动态 · 设置, and expect 游戏库 (three characters, the first
three-character label this bar has carried) not to clip or wrap in its cell. The
`textScaleFactor: 2` overflow case passes in the suite, so this is a visual-fit check
at normal scale, not a correctness one.

[3.2-AC11]/[3.2-AC14] — Open the Library tab — expect the title "Library" and one
`EmptyStateCard` (NO GAMES SAVED, its supporting line, a "Browse games" button), with
no spinner, no error state, no recruit card, no status chips, no search field, no view
toggle, and no `Showing 0 games out of 0` line. Tapping the button must land on Browse
(the games grid), which is the third tab.

[3.2-AC32] — Open the Feed tab — expect the title "Feed" and a single vertically
centred "Coming Soon", nothing else: no card, no glyph, no button. This screen has
zero test coverage by decision (D8), so this is the only run-time look it gets.

[3.2-AC35] — Open the Browse tab — expect the app-bar title to read "Browse" with the
existing subtitle "Search for your favourite games here" unchanged beneath it.

[3.2-AC6] — `library_stats.dart:314` cannot be reached today (the
`playingGames.isNotEmpty` branch has never rendered because Featured's
`statusEqualTo('Playing')` filter has no writers). Nothing manual can confirm it now;
whoever lands item 3.4 must confirm the card opens Library, not Browse.

## Static analysis

Status: PASS
Errors: NONE

Generated code confirmed current first: `dart run build_runner build
--delete-conflicting-outputs` wrote **0 outputs** and left the tree clean, so the
analysis below ran against up-to-date generated files.

`flutter analyze`: **28 issues — 0 errors, 2 warnings, 26 info.**

The 2 warnings are both in `lib/features/tracker/presentation/screens/task_detail_screen.dart`
(`:201:7 unused_element _TaskReminder`, `:204:29 unused_element_parameter task`) —
verified independently, this is the check that proves the protected task tree survived.

**28, not 30, is correct here and is not drift.** `orchestrator-state.md`'s header line
still reads 30 because it was captured at Phase 0 before the three deletions; the
`## Code review outcomes` section is the accurate record and says 28. The 2-issue drop
is info-level lints that lived only in the deleted files. Not failed for.

No new issue in any allowlisted file. The only issues inside files this item touched
are pre-existing: `featured_screen.dart:195,270` (`unnecessary_underscores`, unrelated
`_` patterns) and `bottom_tab_bar.dart:22` (`avoid_redundant_argument_values`, the
`elevation: 0` item 2.4 knowingly kept). Neither new screen, neither test file and none
of the other edited files contributes an issue.

## Test results

Status: PASS
Tests run: 373  |  Passed: 363  |  Failed: 10

Testing mode: **smoke**. Both allowlisted test files run green:
`test/widget/library/library_screen_test.dart` (2 passed) and
`test/widget/components/bottom_tab_bar_test.dart` (all passed, including the zh
raised-text-scale overflow case).

Failing tests — all 10 are the recorded pre-existing set, none new, all outside the
allowlist and none blocking:

- `test/repository/tracker/tracker_repository_test.dart` — 4
- `test/cubit/game_detail/game_detail_cubit_test.dart` — 3
- `test/cubit/games/games_bloc_test.dart` — 3

Baseline movement is exactly as predicted: **+361 -10 → +363 -10**. The rise of 2 is
[3.2-AC29]'s two Library tests and nothing else, and git confirms exactly two test files
in the diff — one modified, one created.

## Acceptance criteria

`3.2-AC34` is **retired by D8** (`tech-ac.md ## Retired criteria`) and was not checked.
Its absence is the decided outcome, not a gap. No file under `test/widget/feed/` exists
and no test in the repository references `FeedScreen` or `feed_screen.dart` — confirmed
by `ls` and by `grep -rn "FeedScreen\|feed_screen" test/`, both empty.

3.2-AC1: PASS — `bottom_tab_bar_destination.dart:5-9` declares exactly five values in
order `featured, library, browse, feed, settings`; `library` carries
`Icons.collections_bookmark_outlined`, `browse` keeps `Icons.search_outlined`, `feed`
carries `Icons.dynamic_feed_outlined`; the `:15-21` label switch is reordered to match
and resolves `S.current.library` / `S.current.browse` / `S.current.feed`. Order is
asserted at run time by `bottom_tab_bar_test.dart:9-23`'s index-dependent cases.
Appearance is MANUAL above.

3.2-AC2: PASS — `git diff --name-only 14da82c..HEAD -- lib/widgets/bottom_tab_bar/`
returns only `enum/bottom_tab_bar_destination.dart`. `bottom_tab_bar.dart`,
`bottom_tab_bar_cell.dart`, `bottom_tab_bar_cell_content.dart`,
`bottom_tab_bar_focus_ring.dart` and `bottom_tab_bar_cap.dart` are untouched.

3.2-AC3: PASS — `home_screen.dart:16-22` reads `FeaturedRoute(), LibraryRoute(),
GamesRoute(), FeedRoute(), SettingsRoute()`. No `TrackerRoute()` or `BrowseRoute()`.

3.2-AC4: PASS — `auto_route_config.dart:25-29` declares the five children in the same
order; slot 2's path stays `games` per `tdd.md` "Routing". `/tracker-detail` (`:42-46`)
and `/task-detail` (`:47-51`) are intact.

3.2-AC5: PASS — read `auto_route_config.gr.dart` directly after regenerating:
`LibraryRoute` and `FeedRoute` present, `GamesRoute` and `TrackerGameDetailRoute` still
present, and zero occurrences of `BrowseRoute`, `BrowseScreen`, `TrackerRoute`,
`TrackerRouteArgs` and `TrackerScreen`.

3.2-AC6: PASS — all six literals rewritten, none keeping its old value:
`featured_screen.dart:144,145,147` → 2, `:207` → 2 (was 3),
`countdown_releases.dart:93` → 2 (was 3), `library_stats.dart:314` → 1 (was `:315`'s 2;
the line moved up one because [3.2-AC10]'s comment was deleted).

3.2-AC7: PASS — `home_screen.dart:27` is still the bare tear-off
`onDestinationSelected: context.tabsRouter.setActiveIndex`.

3.2-AC8: PASS — `grep -rn setActiveIndex lib/` returns exactly **8**: the six of AC6,
the `home_screen.dart:27` tear-off, and `library_screen.dart:28`'s new
`setActiveIndex(2)`. Seven carry a literal; Feed contributes none.

3.2-AC9: PASS — no other tab-index literal. The only other `activeIndex` hits are
`home_screen.dart:26`'s read and `ProgressDots` (`progress_dots.dart:8,11,16,25`,
`welcome_container.dart:58`), which are onboarding dots and are untouched.

3.2-AC10: PASS — `// Route to Tracker tab [Z1-BL-04]` deleted outright (diff shows the
line removed, not reworded). `:316`'s `// Go to Tracker detail for this game` correctly
left in place per TL-2 — it still describes the surviving `TrackerGameDetailRoute` push.

3.2-AC11: PASS — `library_screen.dart:19-31`: title `S.current.library`, one
unconditional `EmptyStateCard` with `no_games_saved` / `no_games_saved_description` /
`browse_games` and `onActionPressed` calling `setActiveIndex(2)`. No loading, error or
populated branch exists in the file. Covered by both tests in
`library_screen_test.dart`.

3.2-AC12: PASS — `library_screen.dart` contains no `ScrollController` and no
`ScrollNotifier` reference; repo-wide writer count is two (see AC33).

3.2-AC13: PASS — `lib/features/library/` holds only
`presentation/screens/library_screen.dart`; nothing declared inline in it beyond the
screen class, and no Library type in `service_locator.config.dart`.

3.2-AC14: PASS on source (no recruit card, no `surfaceArtDeep`, no green CTA, no count
line, no chips, no search field, no view toggle appear in the file) — visual
confirmation is MANUAL above.

3.2-AC15: PASS — `lib/features/tracker/presentation/screens/tracker_screen.dart`,
`lib/widgets/saved_game_item.dart` and the whole `lib/features/browse/` tree are gone
(git records all three as `D`; `ls` confirms none exists, and `lib/features/browse` is
absent as a directory).

3.2-AC16: PASS — `lib/widgets/saved_game_status_tag.dart` exists and appears in no
diff; `tracker_game_detail_screen.dart` exists and appears in no diff.

3.2-AC17: PASS — `TrackerCubit` survives (`presentation/cubits/tracker_cubit.dart`) and
is still DI-registered (`service_locator.config.dart:337`);
`lib/widgets/default_filter_list_app_bar.dart` survives; `default_alert_dialog.dart`
survives with its live caller at `task_detail_screen.dart:319`. Both orphans flagged,
neither swept — correct, and not defects.

3.2-AC18: PASS — `tracker_game_detail_screen.dart`, `task_detail_screen.dart`,
`TaskCubit`, `GroupTask`, `SavedGameTask`, `TaskStep`, the Isar `SavedGame` store and
`horizontal_separator.dart` all present and absent from the diff. The 2 analyzer
warnings are still the `_TaskReminder` pair.

3.2-AC19: PASS — exactly four key edits in each `.arb`, identically placed: `library` /
`feed` added after `featured`, `games` and `tracker` deleted, `browse` kept. English
`Library` / `Feed`; Chinese `游戏库` / `动态`; `browse` still `浏览`.

3.2-AC20: PASS — `browse_games` and `browse_for_your_next_game` present in both `.arb`
files and both still have generated getters; `library_screen.dart:26` is
`browse_games`' third caller.

3.2-AC21: PASS — `delete_saved_game`, `recently_changed` and `games_screen_subtitle`
all still present in both `.arb` files.

3.2-AC22: PASS — `S.current.library` and `S.current.feed` both compile; `l10n.dart:249`
`String get library`, `:254` `String get feed`. The `library_tab` fallback was not
needed and was not used.

3.2-AC23: PASS — verified by diffing values, not counting keys, and no key-count
assertion exists anywhere in the change: `追踪` and `游戏` are real values deleted,
`浏览` survives, `游戏库` and `动态` are real values added, and the two reused
`no_games_saved` keys still hold English values in `intl_zh.arb`.

3.2-AC24: PASS — `bottom_tab_bar_test.dart:9-15` and `:17-23` both hold five entries
reading `featured, library, browse, feed, settings`, glyphs matching the enum exactly.

3.2-AC25: PASS — `:80` still pumps `selectedIndex: 4`, unchanged (absent from the
diff). Correct at five tabs.

3.2-AC26: PASS — `:166,167,172` retargeted to `S.current.browse`; `:168-170`'s
`tabLabel(tabIndex: 3, tabCount: 5)` unchanged. Correct — `tabLabel` is 1-based
(`assert(tabIndex >= 1)`), so `tabIndex: 3` names enum index 2, Tracker's old slot and
Browse's new one. Test passes.

3.2-AC27: PASS — `:199` still reads "keeps all five destinations while the body scrolls
with no scroll state", unchanged.

3.2-AC28: PASS — `default_sliver_app_bar_test.dart` is absent from the diff entirely;
its `'Browse'` fixture is still at `:20` and `:82`.

3.2-AC29: PASS — `test/widget/library/library_screen_test.dart`, two tests, both
passing: "shows the library title and the saved-games empty state" and "reports the
browse tab index when the empty state action is tapped" (asserts
`tabsRouter.selectedIndexes == [2]`). No `matchesGoldenFile` anywhere.

3.2-AC30: PASS — no test pumps `HomeScreen` or asserts the tab route list. The only
`HomeRoute` hits in `test/` are `session_navigator_test.dart:62,78,84`, using it as a
pending-route value; that file is untouched and passing.

3.2-AC31: PASS with the corrected reading — 0 errors, 2 warnings, 28 issues (see Static
analysis for why 28 is correct on this branch, not the 30 the criterion text quotes);
the same ten pre-existing failures, no new ones; passing count 361 → 363, the rise
being the two Library tests only; exactly one new test file in the diff.

3.2-AC32: PASS by source read — read `feed_screen.dart` in full (29 lines) myself:
`:18` title is `S.current.feed`; `:21` is exactly one `Text` inside a `Center` inside
`SliverFillRemaining(hasScrollBody: false)`; and a grep of `lib/features/feed/` for
`EmptyStateCard`, `Icons.`, `ElevatedButton`, `TextButton`, `InkWell`,
`GestureDetector`, `onPressed`, `onTap` and `setActiveIndex` returns **nothing**. The
green suite was not treated as evidence for any part of this.

3.2-AC33: PASS by source read. **Both named checks performed independently, not taken
from `diff-summary.md`:**
  1. Recursive listing of `lib/features/feed/` returns exactly
     `presentation/screens/feed_screen.dart` and its two parent directories — no
     `bloc/`, `cubit/`, `data/`, `domain/` or `di/`, no DTO, entity, repository, use
     case or datasource, none declared inline in the screen, and no Feed type in
     `service_locator.config.dart`.
  2. Grep of `lib/features/feed/` for `ScrollNotifier`, `ScrollController` and
     `addListener` returns nothing. Repo-wide `grep -rn ScrollNotifier lib/` returns
     four hits and **exactly two writers** — `settings_screen.dart:26` and
     `home_screen.dart:31` — the other two being the class declaration
     (`scroll_notifier.dart:6`) and its DI registration
     (`service_locator.config.dart:172`). Count is two, as required. The third writer
     that lived in `browse_screen.dart` went with the deletion.

3.2-AC35: PASS — `games_screen.dart:171` is `title: S.current.browse`; `:172`'s
`subtitle: S.current.games_screen_subtitle` is unchanged. The diff on this file is that
one line and nothing else.

3.2-AC36: PASS — `git diff --name-only 14da82c..HEAD -- lib/features/games/` returns
only `presentation/screens/games_screen.dart`. No rename, no move; `GamesScreen`,
`GamesBloc`, `GamesRepository`, the datasource and `GamesRoute` all keep their names,
and slot 2's route path stays `games`.

3.2-AC37: PASS — `:98,102` retargeted to `S.current.browse`, `:99` to
`find.byIcon(Icons.search_outlined)`, and `:107` asserts `[2, 2, 2]`. Test passes.

3.2-AC38: PASS — `:124,128,136,149` retargeted to `S.current.browse` and `:141` pumps
`selectedIndex: 2`. The `:119-138` non-selection half keeps its original expectations.
Test passes.

3.2-AC39: PASS — exactly two lines changed in `.claude/skills/flutter-widgets/SKILL.md`:
`SavedGameItem` removed from the legacy list at `:160` and its catalogue row deleted.
`:220`'s `BottomTabBar` entry still reads "five fixed destinations … the other four" and
was not edited; the `SavedGameStatusTag` row survives.

## Architectural compliance

Status: PASS

Checked against `tdd.md` and, via the Skill tool, `flutter-widgets` and
`flutter-widget-test` (the allowlist touches the UI layer and one widget test file; no
data, domain or state layer is touched, so `flutter-state`, `flutter-repository`,
`flutter-usecase`, `flutter-datasource` and `flutter-dto` do not apply — correctly, per
`tdd.md`'s empty data/domain/state sections).

FAILs: NONE

- `tdd.md` conformance: both screens are `StatelessWidget` + `@RoutePage()` + `const`
  constructor at the specified paths; `LibraryScreen` is
  `Scaffold > SafeArea > CustomScrollView` with `DefaultSliverAppBar` + a padded
  `SliverToBoxAdapter` holding one `EmptyStateCard`; `FeedScreen` is the same shell with
  `SliverFillRemaining(hasScrollBody: false)` holding `Center(child: Text(...))`, which
  is the one structural call `tdd.md` names. No package added to `pubspec.yaml` (absent
  from the diff). No new global scope.
- `flutter-widgets`: correct placement and naming; **no comments in either new widget
  file**; `SafeArea` wrapping; every string through `S.current`; no `Theme.of(context)`;
  no Widget-returning function or getter; `const` throughout; the only dimension either
  file writes is `EdgeInsets.all(16)`, even; `EmptyStateCard` and `DefaultSliverAppBar`
  reused rather than rebuilt; import order correct (package flutter → third-party →
  project, then the `generated/l10n.dart` relative exception).
- Module boundary: `library_screen.dart:28` uses the bare literal `2` and does not
  import `BottomTabBarDestination`; `bottom_tab_bar_test.dart:6` imports only
  `bottom_tab_bar.dart`. `bottom_tab_bar/`'s single public surface is respected.
- `flutter-widget-test` on both test files: names state condition and outcome; no
  comments; setup is proportional (the `TabsRouterScope` wrapper is required —
  `AutoTabsRouter.of` asserts a non-null scope); assertions are on visible text and a
  recorded callback index, never on structure, dimensions, colours or private state; no
  completers, fake image bytes, arbitrary delays, zones or swallowed errors; no manual
  invocation of internal builders; 67 lines, in line with the reference files. Both
  would fail if the behaviour regressed and survive an implementation-only refactor.
  The hand-written `_RecordingTabsRouter extends Fake implements TabsRouter` is the
  sanctioned departure from `testing-conventions.md` recorded as `tdd.md` caveat C-1 —
  it is a third-party routing controller, not a project dependency, and C-1's Mockito
  fallback was not needed.

WARNINGs:

- `library_stats.dart:316`'s surviving `// Go to Tracker detail for this game` breaks
  `flutter-widgets`' no-comments-in-widget-files rule. **This is pre-existing and its
  retention is correct** — `tdd.md` TL-2 and `task-brief.md` step 14 both explicitly
  require leaving it, because removing it is an out-of-criteria edit on the same lines
  the protected task tree is reached through. Recorded as the standing follow-up TL-2
  already raised, not as a defect of this item.
- Three orphans are flagged and not swept, as designed: `TrackerCubit`,
  `default_filter_list_app_bar.dart` and `RouteConstants.tracker` (TL-3). None produces
  an analyzer issue. Not defects; carried forward to item 3.4.
- The Feed shell ships with **zero test coverage** by human decision D8. Accepted at the
  gate with the trade-off stated; carried here only so it stays visible that the next
  run to touch `feed_screen.dart` has nothing that goes red.

## Scope check (git, not `diff-summary.md`)

`git diff --name-only 14da82c..HEAD` matches the allowlist. Every source and test path
in the diff is allowlisted; the four generated files
(`auto_route_config.gr.dart`, `generated/l10n.dart`, `generated/intl/messages_en.dart`,
`generated/intl/messages_zh.dart`) are the implicit outputs of allowlisted annotated
sources. No file appears in git that `diff-summary.md` failed to declare. No scope
violation.

Two observations, neither a violation:

- **One uncommitted change:** `.agents/runs/library-tab-swap-20260826/orchestrator-state.md`
  is modified in the working tree — the orchestrator's own bookkeeping (phase DEV → QA,
  the Dev SHA, and the Phase 4B code-review outcome). No source or test file is dirty.
  `git stash list` is empty, confirming nothing was stranded by the `git stash` Dev
  self-reported at the review gate.
- The Dev commit `e7dcee4` also carries the revision-3 (D8) rewrites of `tech-ac.md`,
  `tdd.md`, `task-brief.md` and `code-plan.md` in the same commit as the implementation.
  Those are run-folder artifacts, not source, and the D8 authority for every one of
  those edits is recorded in `orchestrator-state.md`; the criteria were not bent to fit
  the code. Worth noting only because bundling the plan revision with the work it
  governs makes the two harder to tell apart at review.

## Escalation required

NONE

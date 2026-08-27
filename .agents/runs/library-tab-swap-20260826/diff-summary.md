# Diff Summary
Source: `.agents/runs/library-tab-swap-20260826/tech-ac.md` (Week 3 item 3.2 — Tab swap, Library and Feed shells, Tracker tab retirement, Browse relabel)
Date: 2026-08-27
Branch: feature/library-tab-swap
Commit: PENDING — recorded after commit

## Files created
lib/features/library/presentation/screens/library_screen.dart — Library tab shell: title plus one unconditional `EmptyStateCard` whose action calls `setActiveIndex(2)` (Browse).
lib/features/feed/presentation/screens/feed_screen.dart — Feed tab shell: title plus one centred `Text`, no card, no action, no `setActiveIndex`, no `ScrollController`.

## Files modified
lib/l10n/intl_en.arb — added `library`/`feed`, deleted `games`/`tracker`; `browse` kept.
lib/l10n/intl_zh.arb — same four edits; `library`: `游戏库`, `feed`: `动态`.
lib/widgets/bottom_tab_bar/enum/bottom_tab_bar_destination.dart — five values reordered to `featured, library, browse, feed, settings`; `browse` reused (kept `Icons.search_outlined`); `library`/`feed` added with new glyphs and l10n keys.
lib/config/route/auto_route_config.dart — `HomeRoute` children reordered to `featured, library, games, feed, settings`; slot 2's path stays `games` per `tdd.md` "Routing".
lib/features/home/presentation/screens/home_screen.dart — `AutoTabsRouter` `routes:` list reordered to `FeaturedRoute(), LibraryRoute(), GamesRoute(), FeedRoute(), SettingsRoute()`.
lib/features/games/presentation/screens/games_screen.dart — `GamesAppBar` title `S.current.games` → `S.current.browse`; nothing else touched.
lib/features/featured/presentation/screens/featured_screen.dart — `:144,145,147` (was `1`) and `:207` (was `3`) all became `setActiveIndex(2)`.
lib/features/featured/presentation/widgets/countdown_releases.dart — `:93` `setActiveIndex(3)` → `setActiveIndex(2)`.
lib/features/featured/presentation/widgets/library_stats.dart — deleted stale `// Route to Tracker tab [Z1-BL-04]` comment; `:315` `setActiveIndex(2)` → `setActiveIndex(1)`; the surviving `// Go to Tracker detail for this game` comment left in place.
.claude/skills/flutter-widgets/SKILL.md — removed `SavedGameItem` from the legacy-widget list and deleted its catalogue row; `:220` and `:203` left untouched.

## Files deleted
lib/features/tracker/presentation/screens/tracker_screen.dart
lib/features/browse/presentation/screens/browse_screen.dart (and the now-empty `lib/features/browse/` tree)
lib/widgets/saved_game_item.dart

## Generated outputs (regenerated, not hand-edited)
lib/generated/l10n.dart, lib/generated/intl/messages_en.dart, lib/generated/intl/messages_zh.dart — via `dart pub global run intl_utils:generate` (GEN-1).
lib/config/route/auto_route_config.gr.dart — via `dart run build_runner build --delete-conflicting-outputs` (GEN-2). Confirmed afterwards: declares `LibraryRoute` and `FeedRoute`, still declares `GamesRoute` and `TrackerGameDetailRoute`, contains no `BrowseRoute`, `BrowseScreen`, `TrackerRoute`, `TrackerRouteArgs` or `TrackerScreen`.

## Test files
test/widget/components/bottom_tab_bar_test.dart (modified) — retargeted both fixture lists to `featured, library, browse, feed, settings`; retargeted the run-time-only tap/selection/tooltip assertions to `browse`/`2`; left `:80`'s `selectedIndex: 4`, `:170`'s `tabLabel(tabIndex: 3, tabCount: 5)`, and `:199`'s "all five destinations" name unchanged, all deliberately per step 15.
test/widget/library/library_screen_test.dart (created) — two tests: title + empty-state copy render; tapping the empty-state action reports `[2]` via a `Fake implements TabsRouter` recorder ([3.2-AC29]).

No test file was created for `feed_screen.dart` and none references it (D8). `test/widget/feed/` does not exist.

## Self-corrections
NONE.

## Deviations from implementation plan
NONE. `library` and `feed` compiled as `S` members on the first generator run (C-3's fallback, `library_tab`, was not needed). The zh `游戏库` label did not overflow the tab cell at `textScaleFactor: 2` (C-4's fallback, `收藏`, was not needed — verified by `bottom_tab_bar_test.dart`'s "renders every destination without overflow in zh at a raised text scale" passing). The `Fake implements TabsRouter` double in `library_screen_test.dart` compiled and ran on the first attempt (C-1's Mockito fallback was not needed).

## Step 17 — Feed shell source-read verification (D8, no test exists for this file)

a. Read `lib/features/feed/presentation/screens/feed_screen.dart` in full (29 lines).
   Confirmed individually: title reads `S.current.feed`; exactly one `Text` sits
   inside a `Center`, itself inside a `SliverFillRemaining(hasScrollBody: false)`;
   none of `EmptyStateCard`, `Icons.`, `ElevatedButton`, `TextButton`, `InkWell`,
   `GestureDetector`, `onPressed`, `onTap` or `setActiveIndex` appears anywhere in
   the file ([3.2-AC32] satisfied).
b. Recursive listing of `lib/features/feed/`: contains exactly
   `presentation/screens/feed_screen.dart` — no `bloc/`, `cubit/`, `data/`,
   `domain/` or `di/` directory, no DTO, entity, repository, use case or
   datasource declared inline or elsewhere ([3.2-AC33] satisfied).
c. `grep -rn "ScrollNotifier\|ScrollController\|addListener" lib/features/feed/`
   returned nothing. Repo-wide `grep -rn "ScrollNotifier" lib/` returned exactly
   two writers: `lib/features/settings/presentation/screens/settings_screen.dart:44`
   and `lib/features/home/presentation/screens/home_screen.dart:31-37` (plus the
   class declaration and its DI registration, neither a writer) — count stays at
   two ([3.2-AC12], [3.2-AC33] satisfied).

## Verification against baseline
`flutter analyze`: 28 issues (26 info, 2 warnings, 0 errors) — down from the recorded
baseline of 30 issues (28 info, 2 warnings). Investigated the 2-issue drop before
treating it as acceptable: temporarily restored the three deleted files
(`browse_screen.dart`, `tracker_screen.dart`, `saved_game_item.dart`) from `HEAD` and
ran `flutter analyze` scoped to them — they carried exactly 2 pre-existing info
issues of their own (`prefer_const_constructors_in_immutables` in
`tracker_screen.dart:20`, `deprecated_member_use` (`withOpacity`) in
`saved_game_item.dart:156`), then removed the three files again. The drop is fully
accounted for by deleting files that carried their own lint issues; the 2-warning
count (`task_detail_screen.dart`'s `_TaskReminder` pair) is unchanged, confirming the
protected task tree is intact.

`flutter test`: +363 -10. The 10 failures are exactly the recorded pre-existing set —
`tracker_repository_test.dart` (4), `game_detail_cubit_test.dart` (3),
`games_bloc_test.dart` (3) — no new failures. Passing count rose from 361 to 363,
exactly [3.2-AC29]'s two Library tests, matching the corrected D8 expectation. Only
one new test file appears in the diff.

## Acceptance criteria status
3.2-AC1: satisfied
3.2-AC2: satisfied — no line of `bottom_tab_bar.dart`, `bottom_tab_bar_cell.dart`, `bottom_tab_bar_cell_content.dart`, `bottom_tab_bar_focus_ring.dart` or `bottom_tab_bar_cap.dart` touched
3.2-AC3: satisfied
3.2-AC4: satisfied — slot-2 path stays `games`
3.2-AC5: satisfied — verified `.gr.dart` contents directly
3.2-AC6: satisfied
3.2-AC7: satisfied — tear-off unchanged
3.2-AC8: satisfied
3.2-AC9: satisfied
3.2-AC10: satisfied
3.2-AC11: satisfied
3.2-AC12: satisfied
3.2-AC13: satisfied
3.2-AC14: satisfied
3.2-AC15: satisfied
3.2-AC16: satisfied — `saved_game_status_tag.dart` and `tracker_game_detail_screen.dart` untouched
3.2-AC17: satisfied — `TrackerCubit`, `default_filter_list_app_bar.dart` flagged not swept; `default_alert_dialog.dart` untouched
3.2-AC18: satisfied — task tree intact, 2 warnings preserved
3.2-AC19: satisfied
3.2-AC20: satisfied
3.2-AC21: satisfied
3.2-AC22: satisfied — `library`/`feed` compiled without the `library_tab` fallback
3.2-AC23: not separately measured — no key-count assertion made
3.2-AC24: satisfied
3.2-AC25: satisfied — `:80` unchanged
3.2-AC26: satisfied — `tabLabel(tabIndex: 3, tabCount: 5)` unchanged
3.2-AC27: satisfied — test name unchanged
3.2-AC28: satisfied — `default_sliver_app_bar_test.dart`'s `'Browse'` fixture untouched
3.2-AC29: satisfied
3.2-AC30: satisfied — no file in the allowlist added a route-list or `HomeScreen` test
3.2-AC31: satisfied — see "Verification against baseline"
3.2-AC32: satisfied — verified by step 17's source read
3.2-AC33: satisfied — verified by step 17's source read, repo-wide writer count is two
3.2-AC35: satisfied
3.2-AC36: satisfied — no file under `lib/features/games/` renamed or moved
3.2-AC37: satisfied
3.2-AC38: satisfied
3.2-AC39: satisfied — `:220` and `:203` left untouched

3.2-AC34: retired by D8 — not implemented, not checked.

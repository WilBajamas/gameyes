# Code Plan
Source: `.agents/runs/library-tab-swap-20260826/tech-ac.md` (Week 3 item 3.2 — Tab swap, Library and Feed shells, Tracker tab retirement, Browse relabel)
Date: 2026-08-27 (revision 2 — retargeted from the superseded four-tab shape to D6's five)

## CREATE NEW

### lib/features/library/presentation/screens/library_screen.dart

```dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_sliver_app_bar.dart';
import 'package:gaming_library_assessment_flutter/widgets/empty_state_card.dart';

import '../../../../generated/l10n.dart';

@RoutePage()
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            DefaultSliverAppBar(title: S.current.library),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: EmptyStateCard(
                  headline: S.current.no_games_saved,
                  supportingLine: S.current.no_games_saved_description,
                  actionLabel: S.current.browse_games,
                  onActionPressed: () =>
                      AutoTabsRouter.of(context).setActiveIndex(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

No comments, no `glyph`, no `ScrollController`, no `ScrollNotifier` write, no bloc.
`const` constructor so auto_route emits `LibraryRoute` as `PageRouteInfo<void>` with
no args class. The `2` is a literal on purpose — importing `BottomTabBarDestination`
to derive it would cross the `bottom_tab_bar/` module boundary. `2` is Browse, i.e.
the Games screen.

### lib/features/feed/presentation/screens/feed_screen.dart

```dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_sliver_app_bar.dart';

import '../../../../generated/l10n.dart';

@RoutePage()
class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            DefaultSliverAppBar(title: S.current.feed),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text(S.current.coming_soon)),
            ),
          ],
        ),
      ),
    );
  }
}
```

**This is the whole screen.** No `EmptyStateCard`, no glyph, no action, no button,
no `setActiveIndex`, no `ScrollController`, no `ScrollNotifier` write, no bloc
([3.2-AC32], [3.2-AC33]). The asymmetry with `LibraryScreen` above is the human's
explicit decision at the Phase 3 gate — Library's empty state is what item 4.5
evolves, Feed's placeholder is replaced wholesale. Do not make them match.

`SliverFillRemaining(hasScrollBody: false)` rather than `SliverToBoxAdapter`, so the
`Center` actually centres — the deleted `browse_screen.dart:51-53` used the latter
and centred nothing. `coming_soon` is an existing key with a real Chinese value
(`即将推出`) in both `.arb` files.

## MODIFY EXISTING

### lib/l10n/intl_en.arb

```jsonc
  "featured": "Featured",
  "library": "Library",          // added
  "feed": "Feed",                // added
  // "games": "Games",           ← deleted (line 34)
  "settings": "Settings",
  ...
  "all_time_top_100": "All time top 100",
  "browse": "Browse",            // KEPT — slot 2's label and the Games app-bar title
  "news": "News",
  ...
  "tasks_completed": "Tasks Completed",
  // "tracker": "Tracker",       ← deleted (line 73)
  "recently_changed": "Recently changed",
```

`browse_games`, `browse_for_your_next_game`, `no_games_saved`,
`no_games_saved_description`, `coming_soon` and `games_screen_subtitle` are all
untouched and all still have live callers.

### lib/l10n/intl_zh.arb

Identical four edits at the same positions; `"library": "游戏库"` and
`"feed": "动态"`. `游戏` and `追踪` are deleted with their keys; `浏览` stays. The
untranslated-key count will not move the way the diff suggests ([3.2-AC23]) — derive
it by diffing values, never by counting keys.

### lib/widgets/bottom_tab_bar/enum/bottom_tab_bar_destination.dart

```dart
enum BottomTabBarDestination {
  featured(Icons.featured_play_list_outlined),
  library(Icons.collections_bookmark_outlined),
  browse(Icons.search_outlined),
  feed(Icons.dynamic_feed_outlined),
  settings(Icons.settings_outlined);

  const BottomTabBarDestination(this.icon);

  final IconData icon;

  String get label => switch (this) {
    BottomTabBarDestination.featured => S.current.featured,
    BottomTabBarDestination.library => S.current.library,
    BottomTabBarDestination.browse => S.current.browse,
    BottomTabBarDestination.feed => S.current.feed,
    BottomTabBarDestination.settings => S.current.settings,
  };
}
```

Still five values. `browse` is **reused**, not re-created — it keeps the
`Icons.search_outlined` it already carries and the `S.current.browse` it already
resolves; only its position moves, 3 → 2. `games` and `tracker` go.

### lib/config/route/auto_route_config.dart

```dart
      children: [
        AutoRoute(path: 'featured', page: FeaturedRoute.page),
        AutoRoute(path: 'library', page: LibraryRoute.page),
        AutoRoute(path: 'games', page: GamesRoute.page),
        AutoRoute(path: 'feed', page: FeedRoute.page),
        AutoRoute(path: 'settings', page: SettingsRoute.page),
      ],
    ),
    // unchanged below: /game-detail, /image-view, /tracker-detail, /task-detail
```

Slot 2 keeps the path `games` — decided in `tdd.md` "Routing", because the path is
code-facing (no Android `VIEW` intent filter, so deep links are undeliverable) and
every other code-facing name stays `Games`.

### lib/features/home/presentation/screens/home_screen.dart

```dart
    return AutoTabsRouter(
      routes: [
        FeaturedRoute(),
        LibraryRoute(),
        GamesRoute(),
        FeedRoute(),
        SettingsRoute(),
      ],
      builder: (context, child) {
        return Scaffold(
          bottomNavigationBar: BottomTabBar(
            selectedIndex: context.tabsRouter.activeIndex,
            onDestinationSelected: context.tabsRouter.setActiveIndex, // unchanged
          ),
```

`GamesRoute` in slot 2 is correct: it is the Browse tab, under its unchanged
generated name.

### lib/features/games/presentation/screens/games_screen.dart

```dart
class GamesAppBar extends StatelessWidget {
  const GamesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultSliverAppBar(
      title: S.current.browse,                    // was S.current.games
      subtitle: S.current.games_screen_subtitle,  // unchanged
```

One line. The class, the file, the folder, `GamesBloc`, `GamesRepository`, the
datasource and `GamesRoute` all keep their names ([3.2-AC36]).

### lib/features/featured/presentation/screens/featured_screen.dart

```dart
          onAddPlayedGame: () => AutoTabsRouter.of(context).setActiveIndex(2),
          onMarkNowPlaying: () => AutoTabsRouter.of(context).setActiveIndex(2),
          onWishlistUpcoming: () =>
              AutoTabsRouter.of(context).setActiveIndex(2),
```

```dart
              return EmptyStateCard(
                glyph: Icons.timer_outlined,
                headline: S.current.start_a_countdown,
                supportingLine: S.current.wishlist_a_game_to_track_release,
                actionLabel: S.current.browse_games,
                onActionPressed: () =>
                    AutoTabsRouter.of(context).setActiveIndex(2),
              );
```

### lib/features/featured/presentation/widgets/countdown_releases.dart

```dart
        actionLabel: S.current.browse_games,
        onActionPressed: () => AutoTabsRouter.of(context).setActiveIndex(2),
```

### lib/features/featured/presentation/widgets/library_stats.dart

```dart
        onTap: () {
          if (extraCount >= 1) {
            AutoTabsRouter.of(context).setActiveIndex(1);
          } else {
            // Go to Tracker detail for this game
            context.router.push(
              TrackerGameDetailRoute(game: topGame.toEntity()),
            );
          }
        },
```

`// Route to Tracker tab [Z1-BL-04]` is gone and the literal is `1`. The second
comment stays — see `tdd.md` TL-2.

### .claude/skills/flutter-widgets/SKILL.md

Two lines, nothing else in the file.

```diff
- but its main caller is a Game Detail screen), `SavedGameItem`, `TaskItem`,
+ but its main caller is a Game Detail screen), `TaskItem`,
```

```diff
- | `SavedGameItem` | `saved_game_item.dart` | Saved game list row with swipe actions |
```

**`:220`'s `BottomTabBar` entry is NOT edited** — "five fixed destinations at equal
width … a transparent cap on the other four" is correct again at five tabs (D7).
**`:203`'s `SavedGameStatusTag` row is NOT edited** — that widget is not retired
([3.2-AC16]).

## DELETE

- `lib/features/tracker/presentation/screens/tracker_screen.dart`
- `lib/features/browse/` (its only file, `presentation/screens/browse_screen.dart`)
- `lib/widgets/saved_game_item.dart`

## TEST FILES

### test/widget/components/bottom_tab_bar_test.dart (modify)

```dart
List<String> _destinationLabels() => [
  S.current.featured,
  S.current.library,
  S.current.browse,
  S.current.feed,
  S.current.settings,
];

List<(String label, IconData icon)> _destinationLabelsAndIcons() => [
  (S.current.featured, Icons.featured_play_list_outlined),
  (S.current.library, Icons.collections_bookmark_outlined),
  (S.current.browse, Icons.search_outlined),
  (S.current.feed, Icons.dynamic_feed_outlined),
  (S.current.settings, Icons.settings_outlined),
];
```

- `'shows every destination label and glyph whichever destination is selected'` —
  **unchanged.** `:80`'s `selectedIndex: 4` is still the last destination, still
  Settings ([3.2-AC25]).
- `'reports the tapped destination index once per tap'` — finder becomes
  `S.current.browse` (`:98`, `:102`), icon finder becomes `Icons.search_outlined`
  (`:99`), and `expect(reported, [2, 2, 2])` (`:107`). Run-time-only ([3.2-AC37]).
- `'moves the selected state to the destination the caller supplies'` — all four
  `S.current.games` become `S.current.browse`; the final pump becomes
  `selectedIndex: 2`. Run-time-only ([3.2-AC38]).
- `'announces the destination name once with its localized tab position'` —
  `S.current.tracker` → `S.current.browse` at all three uses. **`tabLabel(tabIndex: 3,
  tabCount: 5)` is UNCHANGED**: `tabLabel` is 1-based, so `tabIndex: 3` is enum
  index 2 — the same slot Tracker held ([3.2-AC26], `tdd.md` C-5).
- `'shows the destination label as a tooltip on long press without selecting'` —
  `S.current.games` → `S.current.browse` at `:190` and `:193`. Compiler-forced,
  index-free. **Not in `tech-ac.md`** — `tdd.md` TL-5.
- `'keeps all five destinations while the body scrolls with no scroll state'` —
  **name unchanged**, five is still correct ([3.2-AC27]).
- The remaining two tests are untouched.

### test/widget/library/library_screen_test.dart (create)

```dart
class _RecordingTabsRouter extends Fake implements TabsRouter {
  final selectedIndexes = <int>[];

  @override
  void setActiveIndex(int index, {bool notify = true}) =>
      selectedIndexes.add(index);
}

Widget buildSubject(TabsRouter tabsRouter) => MaterialApp(
  theme: buildDarkTheme(),
  localizationsDelegates: const [S.delegate, /* the three Global* delegates */],
  supportedLocales: S.delegate.supportedLocales,
  home: TabsRouterScope(
    controller: tabsRouter,
    stateHash: 0,
    child: const LibraryScreen(),
  ),
);
```

- `'shows the library title and the saved-games empty state'` — asserts
  `S.current.library`, the uppercased `S.current.no_games_saved`,
  `S.current.no_games_saved_description` and `S.current.browse_games` are all on
  screen. (`EmptyStateCard` renders its headline in caps.)
- `'reports the browse tab index when the empty state action is tapped'` — taps
  `S.current.browse_games` and expects `selectedIndexes` to be `[2]`.

Harness notes: `TestWidgetsFlutterBinding.ensureInitialized()`,
`GoogleFonts.config.allowRuntimeFetching = false`, and
`setUpAll(() => S.load(const Locale('en')))` because the assertions read
`S.current`. Copy the surrounding shape from
`test/widget/components/empty_state_card_test.dart`. No golden test, no dimension
assertion, no third test. If `Fake implements TabsRouter` will not compile, switch to
`@GenerateNiceMocks([MockSpec<TabsRouter>()])` per `tdd.md` caveat C-1.

### test/widget/feed/feed_screen_test.dart (create)

```dart
Widget buildSubject() => MaterialApp(
  theme: buildDarkTheme(),
  localizationsDelegates: const [S.delegate, /* the three Global* delegates */],
  supportedLocales: S.delegate.supportedLocales,
  home: const FeedScreen(),
);
```

- `'shows the feed title and a coming-soon line with no empty-state card'` —
  asserts `find.text(S.current.feed)`, `find.text(S.current.coming_soon)` and
  `expect(find.byType(EmptyStateCard), findsNothing)` ([3.2-AC34]).

**One test, not two.** The absence assertion is the whole reason this file exists —
it is the only thing protecting the human's explicit decision that Feed stays bare.
**No `TabsRouterScope` and no `TabsRouter` double**: Feed calls `setActiveIndex`
nowhere, so a routing harness here would be a sign behaviour had crept in. Same
`ensureInitialized` / `allowRuntimeFetching` / `S.load` preamble as the Library test.

## Approved feedback delta

Applied after the human's D6 and D7 decisions at the Phase 3 design gate
(`orchestrator-state.md`, "## Human decisions — 2026-08-26"). This was a
**substantial** revision, so `tdd.md` and `task-brief.md` were corrected in place as
well — the allowlist in particular, which the Dev Agent checks literally. Change
list, one line each:

- **Tab set is five, not four:** `Featured(0) · Library(1) · Browse(2) · Feed(3) ·
  Settings(4)`. Every "went from five to four" statement in revision 1 is dead.
- **Slot 2 is the existing Games screen relabelled**, not the deleted stub — one tab
  label plus `games_screen.dart:171`'s app-bar title; no code rename anywhere.
- **`games_screen.dart` added to the allowlist** (MODIFY EXISTING, one line).
- **Feed added:** new `feed_screen.dart` (CREATE NEW), new
  `test/widget/feed/feed_screen_test.dart` (TEST FILES), `FeedRoute` in both route
  lists, `feed` enum value, `feed` l10n key. Deliberately bare — no
  `EmptyStateCard`, no `setActiveIndex`, no `ScrollNotifier` write.
- **`.claude/skills/flutter-widgets/SKILL.md` added to the allowlist** for
  [3.2-AC39]'s two-line `SavedGameItem` removal (D7). `:220` is now correct and is
  explicitly excluded.
- **l10n inverted:** `browse` is now KEPT (slot 2's label); `games` and `tracker` are
  deleted; `library` and `feed` added. Revision 1 deleted `browse` — that is now the
  exact wrong move.
- **Settings stays at index 4.** Revision 1 moved it to 3.
- **`bottom_tab_bar_test.dart:80` (`selectedIndex: 4`) and `:199` ("all five
  destinations") are now UNCHANGED**, inverting revision 1's steps 13b and 13f.
- **`tabLabel(tabIndex: 3, tabCount: 5)` at `:168-170` is UNCHANGED** — `tabLabel` is
  1-based, so it already names the slot that was Tracker and is now Browse. Revision
  1 changed it to `tabIndex: 1, tabCount: 4`.
- **New edit, no criterion of its own:** `bottom_tab_bar_test.dart:190,193`'s
  long-press tooltip test names `S.current.games` and must retarget to
  `S.current.browse`. Created by D6 (the `games` key now dies); compiler-forced,
  index-free. `tdd.md` TL-5.
- **Route path for slot 2 stays `games`** — Tech Lead call under [3.2-AC4], reasoned
  in `tdd.md` "Routing".
- **Slot 2's glyph is `Icons.search_outlined`, and this one is a genuine document
  conflict** — the surviving `browse` enum value already carries it, while
  `handover.md` ruling 1 `:893-894` still says keep `Icons.gamepad_outlined`. That
  sentence's premise ("Games keeps its name") is what D6 reverses, so I read it as
  obsolete — but it has not been struck from the file. **One line to overrule.**
- **Library's glyph `Icons.collections_bookmark_outlined` and Feed's
  `Icons.dynamic_feed_outlined`** — pure gaps, no document names either. One line
  each.
- **C-4 upgraded from low to real risk:** revision 1 argued `游戏库` was safe because
  the cell got wider at four tabs. The cell is *not* wider now, and `游戏库` is the
  only three-character label in the bar. `收藏` is the pre-approved fallback.
- **Unchanged and still governing:** the six-row `setActiveIndex` table, [3.2-AC10]'s
  comment deletion, the three retirements, `saved_game_status_tag.dart`'s deliberate
  non-retirement, the `TrackerCubit` / `default_filter_list_app_bar.dart` /
  `RouteConstants.tracker` orphan flags, `default_alert_dialog.dart` not being
  orphaned, `default_sliver_app_bar_test.dart`'s `'Browse'` fixture staying
  untouched, and the ordering design (`.arb` → `intl_utils` → new screens →
  deletions → one uninterrupted block → single `build_runner` → tests).

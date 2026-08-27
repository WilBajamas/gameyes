# Code Plan
Source: `.agents/runs/library-tab-swap-20260826/tech-ac.md` (Week 3 item 3.2 — Tab swap, Library shell, Tracker and Browse tab retirement)
Date: 2026-08-26

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
to derive it would cross the `bottom_tab_bar/` module boundary.

## MODIFY EXISTING

### lib/l10n/intl_en.arb

```jsonc
  "featured": "Featured",
  "library": "Library",          // added
  "games": "Games",
  "settings": "Settings",
  ...
  "all_time_top_100": "All time top 100",
  // "browse": "Browse",         ← deleted (line 66)
  "news": "News",
  ...
  "tasks_completed": "Tasks Completed",
  // "tracker": "Tracker",       ← deleted (line 73)
  "recently_changed": "Recently changed",
```

### lib/l10n/intl_zh.arb

Identical three edits at the same positions; `"library": "游戏库"`. `浏览` and `追踪`
are deleted with their keys — expected, and the untranslated-key count will not fall
the way the diff suggests ([3.2-AC23]).

### lib/widgets/bottom_tab_bar/enum/bottom_tab_bar_destination.dart

```dart
enum BottomTabBarDestination {
  featured(Icons.featured_play_list_outlined),
  library(Icons.collections_bookmark_outlined),
  games(Icons.gamepad_outlined),
  settings(Icons.settings_outlined);

  const BottomTabBarDestination(this.icon);

  final IconData icon;

  String get label => switch (this) {
    BottomTabBarDestination.featured => S.current.featured,
    BottomTabBarDestination.library => S.current.library,
    BottomTabBarDestination.games => S.current.games,
    BottomTabBarDestination.settings => S.current.settings,
  };
}
```

### lib/config/route/auto_route_config.dart

```dart
      children: [
        AutoRoute(path: 'featured', page: FeaturedRoute.page),
        AutoRoute(path: 'library', page: LibraryRoute.page),
        AutoRoute(path: 'games', page: GamesRoute.page),
        AutoRoute(path: 'settings', page: SettingsRoute.page),
      ],
    ),
    // unchanged below: /game-detail, /image-view, /tracker-detail, /task-detail
```

### lib/features/home/presentation/screens/home_screen.dart

```dart
    return AutoTabsRouter(
      routes: [
        FeaturedRoute(),
        LibraryRoute(),
        GamesRoute(),
        SettingsRoute(),
      ],
      builder: (context, child) {
        return Scaffold(
          bottomNavigationBar: BottomTabBar(
            selectedIndex: context.tabsRouter.activeIndex,
            onDestinationSelected: context.tabsRouter.setActiveIndex, // unchanged
          ),
```

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
  S.current.games,
  S.current.settings,
];

List<(String label, IconData icon)> _destinationLabelsAndIcons() => [
  (S.current.featured, Icons.featured_play_list_outlined),
  (S.current.library, Icons.collections_bookmark_outlined),
  (S.current.games, Icons.gamepad_outlined),
  (S.current.settings, Icons.settings_outlined),
];
```

- `'shows every destination label and glyph whichever destination is selected'` —
  second pump becomes `selectedIndex: 3`.
- `'reports the tapped destination index once per tap'` — `expect(reported, [2, 2, 2])`.
  Games moved 1 → 2.
- `'moves the selected state to the destination the caller supplies'` — the final
  pump becomes `selectedIndex: 2`; the Featured/Games assertions around it are
  unchanged.
- `'announces the destination name once with its localized tab position'` —
  `S.current.tracker` → `S.current.library` at all three uses;
  `tabLabel(tabIndex: 1, tabCount: 4)`.
- `'keeps all four destinations while the body scrolls with no scroll state'` —
  renamed from "five".
- The remaining three tests are untouched.

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
- `'reports the games tab index when the empty state action is tapped'` — taps
  `S.current.browse_games` and expects `selectedIndexes` to be `[2]`.

Harness notes: `TestWidgetsFlutterBinding.ensureInitialized()`,
`GoogleFonts.config.allowRuntimeFetching = false`, and
`setUpAll(() => S.load(const Locale('en')))` because the assertions read
`S.current`. Copy the surrounding shape from
`test/widget/components/empty_state_card_test.dart`. No golden test, no dimension
assertion, no third test. If `Fake implements TabsRouter` will not compile, switch to
`@GenerateNiceMocks([MockSpec<TabsRouter>()])` per `tdd.md` caveat C-1.

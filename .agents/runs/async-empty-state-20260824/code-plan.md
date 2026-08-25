# Code Plan
Source: `tech-ac.md` (run `async-empty-state-20260824`), AC-01–AC-28
Date: 2026-08-24

## CREATE NEW

### lib/widgets/empty_state_card.dart

```dart
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/primary_button.dart';

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    required this.headline,
    required this.supportingLine,
    required this.actionLabel,
    required this.onActionPressed,
    this.glyph,
  });

  final String headline;
  final String supportingLine;
  final String actionLabel;
  final VoidCallback onActionPressed;
  final IconData? glyph;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.color;
    final glyph = this.glyph;

    return ClipRRect(
      borderRadius: BorderRadius.circular(tokens.radius.lg),
      child: ColoredBox(
        color: colors.surfaceRaised,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              if (glyph != null) Icon(glyph, size: 44, color: colors.ink55),
              Text(
                headline.toUpperCase(),
                textAlign: TextAlign.center,
                style: tokens.typography.cardHeading.style.copyWith(
                  color: colors.ink,
                ),
              ),
              Text(
                supportingLine,
                textAlign: TextAlign.center,
                style: tokens.typography.body.style.copyWith(
                  color: colors.ink70,
                ),
              ),
              PrimaryButton(label: actionLabel, onPressed: onActionPressed),
            ],
          ),
        ),
      ),
    );
  }
}
```

No comments in the shipped file — the notes below are for the reviewer only.
`headline.toUpperCase()` rather than `cardHeading.format(headline)` because that
token is `uppercase: false` and shares the role with `countdown_card.dart`'s game
title. `ClipRRect` + `ColoredBox` rather than `DecoratedBox` so the card's fill
stays a single-match finder — see `tdd.md ## Testing`. The `ClipRRect` is the
outermost widget: nothing wraps it (AC-07), and there is no `height:` (AC-09).

## MODIFY EXISTING

### lib/l10n/intl_en.arb

```json
  "no_game_in_progress": "No game in progress",
  "mark_something_playing": "Mark something as playing",

  "try_widening_your_filters": "Widen your filters and more of the catalogue comes into view.",
  "search_again": "Search again",
  "pick_a_game_to_start_logging": "Pick a game from your library and start logging hours.",
  "open_up_your_genres": "Open up your genres",
  "every_pick_without_a_genre_filter": "Clear the genre filter to see every pick critics made this week.",
  "show_every_pick": "Show every pick",
  "look_further_ahead": "Look further ahead",
  "browse_for_your_next_game": "Browse the catalogue and line up what you play next.",
  "browse_games": "Browse games",
  "start_a_countdown": "Start a countdown",
  "wishlist_a_game_to_track_release": "Wishlist an upcoming game and its release lands here.",
```

### lib/l10n/intl_zh.arb

```json
  "no_game_in_progress": "目前没有正在进行的游戏",
  "mark_something_playing": "标记一些游戏为正在玩",

  "try_widening_your_filters": "放宽筛选条件，就能看到更多游戏。",
  "search_again": "重新搜索",
  "pick_a_game_to_start_logging": "从你的游戏库中选一款，开始记录时长。",
  "open_up_your_genres": "放开你的类型偏好",
  "every_pick_without_a_genre_filter": "清除类型筛选，就能看到本周媒体的全部推荐。",
  "show_every_pick": "显示全部推荐",
  "look_further_ahead": "看看更远的未来",
  "browse_for_your_next_game": "浏览游戏库，安排你接下来要玩的游戏。",
  "browse_games": "浏览游戏",
  "start_a_countdown": "开启一个倒计时",
  "wishlist_a_game_to_track_release": "将即将推出的游戏加入心愿单，它的发售就会出现在这里。",
```

### lib/features/games/presentation/screens/games_screen.dart

```dart
                    if (state.status == GamesStatus.failed)
                      SliverFillRemaining(
                        child: Center(
                          child: ErrorRetryWidget(
                            onRetryClicked: () => context.read<GamesBloc>().add(
                              const GamesFetched(),
                            ),
                          ),
                        ),
                      ),
                    if (state.status == GamesStatus.empty)
                      SliverFillRemaining(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: EmptyStateCard(
                              glyph: Icons.search_outlined,
                              headline: S.current.no_results_found,
                              supportingLine:
                                  S.current.try_widening_your_filters,
                              actionLabel: S.current.search_again,
                              onActionPressed: () =>
                                  context.read<GamesBloc>().add(
                                    const GamesFetched(),
                                  ),
                            ),
                          ),
                        ),
                      ),
```

Import added: `package:…/widgets/empty_state_card.dart`. The
`error_retry_widget.dart` import stays — two failed-branch callers remain.

### lib/features/featured/presentation/widgets/library_stats.dart

```dart
  Widget _buildNowPlayingCard(
    BuildContext context,
    List<SavedGame> playingGames,
  ) {
    if (playingGames.isEmpty) {
      return EmptyStateCard(
        glyph: Icons.play_circle_outline_rounded,
        headline: S.current.no_game_in_progress,
        supportingLine: S.current.pick_a_game_to_start_logging,
        actionLabel: S.current.mark_something_playing,
        onActionPressed: onMarkNowPlaying,
      );
    }

    final topGame = playingGames.first;
```

The whole `class _DashedBorderPainter extends CustomPainter { … }` at the end of
the file is deleted.

### lib/features/featured/presentation/widgets/critics_grid.dart

```dart
  Widget _buildGrid(BuildContext context) {
    if (criticsGames.isEmpty) {
      return EmptyStateCard(
        glyph: Icons.tune_outlined,
        headline: S.current.open_up_your_genres,
        supportingLine: S.current.every_pick_without_a_genre_filter,
        actionLabel: S.current.show_every_pick,
        onActionPressed: onSkipPressed,
      );
    }

    return GridView.builder(
```

Imports added: `…/generated/l10n.dart`, `…/widgets/empty_state_card.dart`.
`onSkipPressed` already reaches `CriticsGridCubit.skipGenrePreferences()`, which
saves once and reloads once — the constructor is not changed.

### lib/features/featured/presentation/widgets/countdown_releases.dart

```dart
  Widget _buildReleasesList(BuildContext context) {
    if (outThisWeekGames.isEmpty) {
      return EmptyStateCard(
        glyph: Icons.calendar_month_outlined,
        headline: S.current.look_further_ahead,
        supportingLine: S.current.browse_for_your_next_game,
        actionLabel: S.current.browse_games,
        onActionPressed: () => AutoTabsRouter.of(context).setActiveIndex(3),
      );
    }

    return SizedBox(
```

Imports added: `package:auto_route/auto_route.dart`, `…/generated/l10n.dart`,
`…/widgets/empty_state_card.dart`. The constructor is not changed.

### lib/features/featured/presentation/screens/featured_screen.dart

```dart
            if (state.countdownGame == null && state.outThisWeekGames.isEmpty) {
              return EmptyStateCard(
                glyph: Icons.timer_outlined,
                headline: S.current.start_a_countdown,
                supportingLine: S.current.wishlist_a_game_to_track_release,
                actionLabel: S.current.browse_games,
                onActionPressed: () =>
                    AutoTabsRouter.of(context).setActiveIndex(3),
              );
            }

            return CountdownReleasesWidget(
```

Import added: `…/widgets/empty_state_card.dart`. Same `if`, same early `return`,
same slot — no heading, no wrapper.

### .claude/skills/flutter-widgets/SKILL.md

Replace lines 218-220 with:

```markdown
**Empty state** — use `EmptyStateCard` (`lib/widgets/empty_state_card.dart`) for
every empty branch. Its anatomy is fixed: a raised-surface card at r-lg carrying
an optional glyph, a headline the component renders in caps from a normal-case
`.arb` value, exactly one supporting line, and exactly one action. All four text
and callback slots are required — there is no actionless variant, and the card
adds no spacing of its own, so the caller owns the surrounding layout.
```

Add a catalogue row beside `HairlineGroup`:

```markdown
| `EmptyStateCard` | `empty_state_card.dart` | Empty-state card on `surfaceRaised` at r16: optional 44px glyph, a caps headline rendered from a normal-case string, one supporting line at `ink70` that wraps rather than truncating, and one required action built from `PrimaryButton`. No border, no fixed height, no actionless variant; adds no spacing of its own |
```

Also drop `text: S.current.no_results_found` from the "Error + retry" sample at
lines 180-187 — it is the same empty-state-through-an-error-widget workaround and
AC-25 requires it gone from the whole skill.

## TEST FILES

### test/widget/components/empty_state_card_test.dart

Subject builder mirrors `hairline_group_test.dart`: `MaterialApp` with
`buildDarkTheme()`, the four localisation delegates, `Scaffold(body:
EmptyStateCard(...))`, `GoogleFonts.config.allowRuntimeFetching = false`.
Imports only `widgets/empty_state_card.dart` and
`config/theme/tokens/app_color_tokens.dart` from the app.

- `'shows the headline in capitals, the supporting line and the action label'` —
  built with `headline: 'headline copy'`; asserts `find.text('HEADLINE COPY')`,
  the supporting line and the action label each find one widget. Covers AC-04's
  render-time caps and AC-26's content assertions.
- `'calls the action callback once when the action is tapped'` — taps the action
  label, asserts an external counter equals 1. The counter lives in the test, so
  it cannot pass by construction.
- `'hides the glyph when none is supplied'` — built with no `glyph`; asserts no
  `Icon` descends from `EmptyStateCard`. Covers AC-01's optional glyph.
- `'fills the card with the surfaceRaised token'` — reads the single `ColoredBox`
  descending from `EmptyStateCard` and asserts its `color` is
  `AppColorTokens.dark.surfaceRaised`. Covers AC-26's token-named colour.

No dimension, gap, radius or position assertion. No `matchesGoldenFile`. No
`maxLines`/`overflow` assertion — AC-05 is enforced by inspecting the file, not
by copying its implementation into the test.

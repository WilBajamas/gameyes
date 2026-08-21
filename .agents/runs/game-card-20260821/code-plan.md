# Code Plan
Source: `.agents/runs/game-card-20260821/tech-ac.md` — week 2 Stage 2 item 2.1, Game card
Date: 2026-08-21

Skeleton only. `task-brief.md` wins on any conflict. Widget files below carry no
comments, deliberately — that is the convention, not an omission in the sketch.

## CREATE NEW

### lib/widgets/game_card.dart

```dart
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_cached_network_image.dart';
import 'package:gaming_library_assessment_flutter/widgets/platform_row_list.dart';
import 'package:gaming_library_assessment_flutter/widgets/status_chip.dart';

import '../generated/l10n.dart';

const double _coverAspectRatio = 3 / 4;

enum GameCardSize {
  xs(width: 64, footerHeight: 0),
  sm(width: 132, footerHeight: 56),
  md(width: 220, footerHeight: 126);

  const GameCardSize({required this.width, required this.footerHeight});

  final double width;
  final double footerHeight;

  bool get fillsParent => this == GameCardSize.md;

  bool get hasFooter => this != GameCardSize.xs;

  double cellHeightFor(double cardWidth) =>
      cardWidth / _coverAspectRatio + footerHeight;
}

class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.size,
    this.game,
    this.fromScreen,
    this.criticScore,
    this.status,
    this.inLibrary = false,
    this.onTap,
    this.onAddTap,
  });

  final GameCardSize size;
  final GameEntity? game;
  final String? fromScreen;
  final double? criticScore;
  final LibraryStatus? status;
  final bool inLibrary;
  final VoidCallback? onTap;
  final VoidCallback? onAddTap;

  @override
  Widget build(BuildContext context) {
    final card = InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _CardCover(
            game: game,
            fromScreen: fromScreen,
            criticScore: criticScore,
            status: status,
            inLibrary: inLibrary,
          ),
          if (size.hasFooter)
            _CardFooter(
              size: size,
              game: game,
              criticScore: criticScore,
              onAddTap: onAddTap,
            ),
        ],
      ),
    );

    return size.fillsParent ? card : SizedBox(width: size.width, child: card);
  }
}

class _CardCover extends StatelessWidget {
  const _CardCover({
    this.game,
    this.fromScreen,
    this.criticScore,
    this.status,
    required this.inLibrary,
  });

  final GameEntity? game;
  final String? fromScreen;
  final double? criticScore;
  final LibraryStatus? status;
  final bool inLibrary;

  @override
  Widget build(BuildContext context) {
    final game = this.game;
    final fromScreen = this.fromScreen;
    final criticScore = this.criticScore;
    final status = this.status;
    final borderRadius = BorderRadius.circular(context.tokens.radius.lg);

    final cover = ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _CoverArt(url: game?.cover.url, borderRadius: borderRadius),
          if (criticScore != null)
            Positioned(
              top: 8,
              left: 8,
              child: _CriticBadge(score: criticScore),
            ),
          if (inLibrary)
            const Positioned(top: 8, right: 8, child: _LibraryTick()),
          if (status != null)
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Align(
                alignment: Alignment.centerLeft,
                child: StatusChip(
                  status: status,
                  variant: StatusChipVariant.onMedia,
                ),
              ),
            ),
        ],
      ),
    );

    return AspectRatio(
      aspectRatio: _coverAspectRatio,
      child: game != null && fromScreen != null
          ? Hero(
              tag: '${ConfigConstants.heroTag}/${game.id}/$fromScreen',
              child: cover,
            )
          : cover,
    );
  }
}

class _CoverArt extends StatelessWidget {
  const _CoverArt({this.url, required this.borderRadius});

  final String? url;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final url = this.url;

    if (url == null || url.isEmpty) {
      return _MissingArt(borderRadius: borderRadius);
    }

    return DefaultCachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, image) => Stack(
        fit: StackFit.expand,
        children: [
          Image(image: image, fit: BoxFit.cover),
          ColoredBox(color: context.tokens.color.coverWash),
        ],
      ),
      placeholder: (context, url) =>
          ColoredBox(color: context.tokens.color.surfaceRaised),
      errorWidget: (context, url, error) =>
          _MissingArt(borderRadius: borderRadius),
    );
  }
}

class _MissingArt extends StatelessWidget {
  const _MissingArt({required this.borderRadius});

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.tokens.color;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.canvas,
        border: Border.all(color: colors.hairline),
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Icon(Icons.videogame_asset_outlined, color: colors.ink24),
      ),
    );
  }
}

class _CriticBadge extends StatelessWidget {
  const _CriticBadge({required this.score});

  final double score;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.color.green,
        borderRadius: BorderRadius.circular(tokens.radius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Text(
          '${score.round()}',
          style: tokens.typography.pill.style.copyWith(
            color: tokens.color.inkDark,
          ),
        ),
      ),
    );
  }
}

class _LibraryTick extends StatelessWidget {
  const _LibraryTick();

  @override
  Widget build(BuildContext context) {
    final colors = context.tokens.color;

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: colors.accentIndigo,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.check, size: 12, color: colors.ink),
    );
  }
}

class _CardFooter extends StatelessWidget {
  const _CardFooter({
    required this.size,
    this.game,
    this.criticScore,
    this.onAddTap,
  });

  final GameCardSize size;
  final GameEntity? game;
  final double? criticScore;
  final VoidCallback? onAddTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.footerHeight,
      child: size == GameCardSize.sm
          ? _SmallFooter(game: game, criticScore: criticScore)
          : _MediumFooter(game: game, onAddTap: onAddTap),
    );
  }
}

class _SmallFooter extends StatelessWidget {
  const _SmallFooter({this.game, this.criticScore});

  final GameEntity? game;
  final double? criticScore;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final game = this.game;
    final criticScore = this.criticScore;
    final platforms = game?.platforms;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        SizedBox(
          height: 24,
          child: game == null
              ? const _PlaceholderBar(widthFactor: 1)
              : Text(
                  game.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tokens.typography.body.style.copyWith(
                    color: tokens.color.ink,
                  ),
                ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 20,
          child: game == null
              ? const _PlaceholderBar(widthFactor: 0.4)
              : Row(
                  children: [
                    if (platforms != null && platforms.isNotEmpty)
                      Expanded(
                        child: SizedBox(
                          height: 16,
                          child: PlatformRowList(
                            platforms: platforms,
                            showMax: 1,
                          ),
                        ),
                      )
                    else
                      const Spacer(),
                    if (criticScore != null)
                      Text(
                        '${criticScore.round()}',
                        style: tokens.typography.meta.style,
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _MediumFooter extends StatelessWidget {
  const _MediumFooter({this.game, this.onAddTap});

  final GameEntity? game;
  final VoidCallback? onAddTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final game = this.game;
    final onAddTap = this.onAddTap;
    final platforms = game?.platforms;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: game == null
              ? const _PlaceholderBar(widthFactor: 0.8)
              : Text(
                  game.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: tokens.typography.body.style.copyWith(
                    color: tokens.color.ink,
                  ),
                ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 18,
          child: game == null
              ? const _PlaceholderBar(widthFactor: 0.5)
              : Text(
                  game.releaseDates?.firstOrNull?.human ??
                      StringConstants.emptyStringPlaceholder,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tokens.typography.meta.style,
                ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 44,
          child: Row(
            children: [
              if (platforms != null && platforms.isNotEmpty)
                Expanded(
                  child: SizedBox(
                    height: 16,
                    child: PlatformRowList(platforms: platforms),
                  ),
                )
              else
                const Spacer(),
              if (onAddTap != null)
                IconButton(
                  onPressed: onAddTap,
                  tooltip: S.current.add_to_library,
                  icon: const Icon(Icons.add),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlaceholderBar extends StatelessWidget {
  const _PlaceholderBar({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: SizedBox(
          height: 12,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: tokens.color.ink12,
              borderRadius: BorderRadius.circular(tokens.radius.xs),
            ),
          ),
        ),
      ),
    );
  }
}
```

## MODIFY EXISTING

### lib/core/res/const.dart

```dart
class GamesGridConstants {
  static const double gutter = 8;
  static const int columnCount = 2;

  static double columnWidth(double crossAxisExtent) =>
      (crossAxisExtent - gutter * (columnCount + 1)) / columnCount;
}
```

### lib/features/games/presentation/screens/games_screen.dart

```dart
class GamesSliverGrid extends StatelessWidget {
  const GamesSliverGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GamesBloc>().state;

    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final columnWidth = GamesGridConstants.columnWidth(
          constraints.crossAxisExtent,
        );

        return SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: GamesGridConstants.gutter,
          ),
          sliver: SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: GamesGridConstants.columnCount,
              mainAxisSpacing: GamesGridConstants.gutter,
              crossAxisSpacing: GamesGridConstants.gutter,
              mainAxisExtent: GameCardSize.md.cellHeightFor(columnWidth),
            ),
            itemCount: state.games.length,
            itemBuilder: (context, index) => GameCard(
              size: GameCardSize.md,
              game: state.games[index],
              fromScreen: RouteConstants.games,
              criticScore: state.games[index].criticScore,
              onTap: () {
                final extra = (
                  state.games[index].id,
                  RouteConstants.games,
                  state.games[index].cover.url
                );
                context.router.push(
                  GameDetailRoute(gameExtra: extra),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
```

### lib/widgets/game_item_grid_loading_shimmer.dart

```dart
class GameItemGridLoadingShimmer extends StatelessWidget {
  const GameItemGridLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columnWidth = GamesGridConstants.columnWidth(
            constraints.maxWidth,
          );

          return GridView.builder(
            padding: const EdgeInsets.all(GamesGridConstants.gutter),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: GamesGridConstants.columnCount,
              mainAxisSpacing: GamesGridConstants.gutter,
              crossAxisSpacing: GamesGridConstants.gutter,
              mainAxisExtent: GameCardSize.md.cellHeightFor(columnWidth),
            ),
            itemCount: 4,
            itemBuilder: (_, index) => const GameCard(size: GameCardSize.md),
          );
        },
      ),
    );
  }
}
```

### lib/widgets/game_item_loading_shimmer.dart

```dart
class GameItemLoadingShimmer extends StatelessWidget {
  const GameItemLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: GameCardSize.sm.cellHeightFor(GameCardSize.sm.width),
      child: Skeletonizer(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          separatorBuilder: (_, index) => const SizedBox(width: 8),
          itemBuilder: (_, index) => const GameCard(size: GameCardSize.sm),
        ),
      ),
    );
  }
}
```

### lib/widgets/game_item.dart

```dart
@Deprecated('Use GameCard in lib/widgets/game_card.dart')
class GameItem extends StatelessWidget {
```

### lib/l10n/intl_en.arb and lib/l10n/intl_zh.arb

```
"add_to_library": "Add to library"
```
Chinese value in `intl_zh.arb`, same key. Regenerate with
`dart pub global run intl_utils:generate`.

### .claude/skills/flutter-widgets/SKILL.md

Catalogue table rows only — no rule text:

```
| `GameCard` | `game_card.dart` | Game card in three sizes (`xs` 64 no footer, `sm` 132, `md` fills its parent): 3:4 cover at r16 with an indigo wash and an onyx missing-art fallback, optional library tick / status chip / green critic badge overlays, optional shared-element hero, constructible with no data for shimmers; adds no spacing of its own |
| `GameItem` | `game_item.dart` | **Deprecated** — replaced by `GameCard`. Kept as reference only, no callers |
| `GameItemLoadingShimmer` | `game_item_loading_shimmer.dart` | Horizontal shimmer of dataless `GameCard`s at `sm` |
| `GameItemGridLoadingShimmer` | `game_item_grid_loading_shimmer.dart` | Grid shimmer of dataless `GameCard`s at `md`, matching the games grid's cell geometry |
```

## TEST FILES

### test/mocks/game_mock.dart
- add `GameEntity get mockGameEntity` (real id, `'test_name'`, a cover url, one or two
  platforms, one release date) beside the existing `Game` DTO getters; tests vary it
  with `copyWith`.

### test/widget/components/game_card_test.dart
- `'shows the missing-art glyph when the cover url is null or empty'` — C3; also asserts
  no asset image is rendered.
- `'shows the library tick when the caller says the game is in the library'` — C4.
- `'hides the library tick when the caller does not'` — C4.
- `'shows the supplied status using the on-media variant'` — C5, via the `StatusChip`'s
  public `status`/`variant`.
- `'hides the status chip when no status is supplied'` — C5.
- `'shows the critic score rounded to a whole number'` — C6, for a fractional score; the
  run's one permitted colour assertion, naming the green token, belongs here.
- `'hides the critic badge when no score is supplied'` — C6.
- `'hides the title at xs'` — C7.
- `'shows the title, the capped platform row and the critic number at sm'` — C8;
  asserts the row's `showMax`, never a loaded logo.
- `'hides the critic number at sm when no score is supplied'` — C8.
- `'shows the release date, the platform row and the add action at md'` — C9.
- `'hides the add action at md when no callback is supplied'` — C9.
- `'calls the add action without calling the card tap when the add is tapped'` — C10.
- `'hides the platform row when platforms are null or empty'` — C11, both cases, card
  still builds.
- `'renders a long title and an over-cap platform list without overflowing'` — C12, at
  `sm` and `md`.
- `'calls the tap action once when the card is tapped'` — C13.
- `'does nothing when tapped with no tap action supplied'` — C13.
- `'uses the shared hero tag built from the game id and fromScreen'` — C14, asserting
  the exact string.
- `'registers no hero when several dataless cards render together'` — C15.

### test/widget/games/games_screen_test.dart
- `'shows a card for each game with no status chip and no library tick'` — R1.
- `'renders the grid without overflow at a narrow and a wide surface'` — R2, title still
  found; no dimension or ratio assertion.
- `'pushes the game detail route with the unchanged payload when a card is tapped'` — R3,
  via a mocked `StackRouter` in a `StackRouterScope`.

### test/widget/components/game_card_shimmers_test.dart
- `'renders the grid shimmer cells without throwing'` — R5.
- `'renders the horizontal shimmer cells without throwing'` — R6.

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

---

## Approved feedback delta

Phase 3 gate, 2026-08-21. Authoritative wherever it conflicts with anything above.
`tdd.md` and `task-brief.md` were also corrected in place for D1–D4, because the file
allowlist would otherwise be stale and the Dev Agent checks it literally. Every other
section of both files stands as written.

### D1 — the card becomes a multi-file module at `lib/widgets/game_card/`

- `_CardFooter`, `_SmallFooter` and `_MediumFooter` each get their own file, together in
  one folder. `_PlaceholderBar` moves with them — both footers use it, so it cannot stay
  private in the card's file once they leave it. A forced consequence of the split, not
  extra scope.
- **The card moves into the folder too.** `lib/widgets/game_card.dart` becomes
  `lib/widgets/game_card/game_card.dart`. The folder *is* the module, so its public entry
  point belongs at the module root; a `game_card.dart` file sitting beside a `game_card/`
  folder reads as two separate things. `GameCardSize` also moves to its own file — the
  footers need it and the card imports the footers, so leaving the enum in `game_card.dart`
  would make the module import itself in a circle.
- **Shape and naming — stated plainly, because the skill does not document this.**
  `flutter-widgets` documents **no** multi-file module shape under `lib/widgets/`, and
  `flutter-arch.md` shows `widgets/` as a flat folder of single files; the skill's live
  rule is the opposite one ("one file per widget family — a small helper widget only its
  parent uses lives as a private class in the same file"). There is no existing shape to
  copy, so the folder is built from the two conventions the repo does demonstrate
  everywhere rather than from a new invention:
  - a folder named for the thing it owns, with the entry point named after the folder —
    as `lib/features/[feature]/` and `lib/core/data/models/` already do;
  - **one file per class, file name the snake_case of the class name** —
    `status_chip.dart` / `StatusChip`, `saved_game_status_tag.dart` / `SavedGameStatusTag`,
    `game_detail_section_point.dart` / `GameDetailSectionPoint`. The folder prefix
    therefore repeats in the file names. That repetition is the price of keeping the one
    naming rule this repo is actually consistent about, instead of inventing a
    folder-relative one that exists nowhere else.
  - No barrel file and no `export` — the project has none anywhere. A caller needing both
    the card and the enum writes two imports.
  - `part` / `part of` was considered and rejected: it is the project's other multi-file
    mechanism (`settings_screen.dart` parts in `../widgets/sign_out_section.dart`), but it
    would keep the three footers `_`-prefixed and library-private, and the feedback is
    explicit that they stop being file-private.
- **Visibility.** The four extracted classes are public and named for the module they
  belong to: `GameCardFooter`, `GameCardSmallFooter`, `GameCardMediumFooter`,
  `GameCardPlaceholderBar`. Public because they are no longer in one file; prefixed with
  `GameCard` because they are module-internal rather than app-wide. They are **not**
  catalogued in the `flutter-widgets` table, get **no** dedicated test file, and nothing
  outside `lib/widgets/game_card/` may import them. Only `GameCard` and `GameCardSize` are
  the module's public surface.
- `_CardCover`, `_CoverArt` and `_MissingArt` stay file-private inside `game_card.dart`.
  Only their parent uses them and the feedback did not name them.

Final module layout:

```
lib/widgets/game_card/
  game_card.dart                    GameCard + private _CardCover, _CoverArt, _MissingArt
  game_card_size.dart               GameCardSize + coverAspectRatio
  game_card_footer.dart             GameCardFooter          (per-size switch)
  game_card_small_footer.dart       GameCardSmallFooter
  game_card_medium_footer.dart      GameCardMediumFooter
  game_card_placeholder_bar.dart    GameCardPlaceholderBar  (used by both footers)
```

Bodies are unchanged from the skeletons above apart from the renames, the constructors
losing their private-class form, and the imports. The two that change materially:

```dart
// lib/widgets/game_card/game_card_size.dart
const double coverAspectRatio = 3 / 4;

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
      cardWidth / coverAspectRatio + footerHeight;
}
```

```dart
// lib/widgets/game_card/game_card_footer.dart
class GameCardFooter extends StatelessWidget {
  const GameCardFooter({
    super.key,
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
          ? GameCardSmallFooter(game: game, criticScore: criticScore)
          : GameCardMediumFooter(game: game, onAddTap: onAddTap),
    );
  }
}
```

`_coverAspectRatio` loses its underscore and lives in `game_card_size.dart` beside the
enum that consumes it; `game_card.dart` imports it for the cover's `AspectRatio`.

### D2 — `LibraryTick` and `CriticBadge` become app-wide widgets

Both leave the card and become flat files in `lib/widgets/`, on the same footing as the
Stage 1 primitives. `_CardCover` composes them by their public names; nothing else about
the cover changes.

```dart
// lib/widgets/library_tick.dart
class LibraryTick extends StatelessWidget {
  const LibraryTick({super.key});

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
```

```dart
// lib/widgets/critic_badge.dart
class CriticBadge extends StatelessWidget {
  const CriticBadge({super.key, required this.score});

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
```

**How the green is protected.** §2 rule 1 rations green to one CTA per screen and names
exactly two non-action exceptions: the focus ring and this badge, "because that one is
data, not an affordance". The API itself is the guard — `score` is the only parameter, so
there is no colour, fill, variant, threshold or size knob a caller could turn, and no way
to reuse the widget as a generic green pill without calling the thing a critic score.
Three supporting measures:

- the class name is domain-bound, so a misuse is visible at the call site;
- the catalogue row (D4) states the exception and that green must not spread out of it;
- step 13's repo search is extended: after implementation, `color.green` in `lib/`
  resolves only to the theme's focus ring and `critic_badge.dart`. A third hit is a green
  leak and is a defect, not a style choice.

**Dedicated test files, decided per widget against `flutter-widget-test` — deliberately
not the same answer for both:**

- `CriticBadge` — **yes**, `test/widget/components/critic_badge_test.dart`, 2 tests. It
  owns a real transformation the user sees (a fractional score rendered as a whole number)
  and one documented contract that warrants a colour assertion (the sanctioned green,
  named by token, protecting C6's "the badge is one colour" against a re-invented score
  ramp). The run's single permitted colour assertion **moves** here from the card's file —
  it does not multiply, it relocates to the widget that owns the colour.
- `LibraryTick` — **no**. Zero parameters, no conditional content, no interaction, no
  input that can regress; it is a fixed glyph. Per the skill, a passive widget does not
  earn a file, and its only meaningful behaviour — appearing when and only when the caller
  says the game is in the library — is the *card's* behaviour and is asserted there.

```
test/widget/components/critic_badge_test.dart
- 'shows the score rounded to a whole number'
- 'uses the sanctioned green token for the badge fill'
```

The card's own assertion narrows accordingly: it checks that a `CriticBadge` is present
and received the supplied score, not what the badge renders. Rounding is the badge's
contract now, per the skill's ownership rule.

### D3 — the card's test file drops from 19 tests to 10

`flutter-widget-test` re-read in full. The 19-test file was one test per `Verify:` line,
which is not what the skill asks for — it asks for the smallest set that fails when the
behaviour regresses and keeps passing through an implementation-only refactor. Ten tests,
against `context_chip_test.dart`'s 1, `stat_pill_test.dart`'s 2 and `status_chip_test.dart`'s
10 as the repo's current ceiling. The card sits **at** that ceiling, not above it, because
it genuinely owns three sizes, three overlays and two interactions.

`test/widget/components/game_card_test.dart` — final list, replacing the 19 above:

1. `'shows the missing-art glyph when no cover url is supplied'` — C3.
2. `'shows the library tick, the status chip and the critic badge when the caller supplies them'` —
   C4, C5, C6. One pump, three presence assertions, plus the chip's `status`/`variant` and
   the badge's `score` read as public properties.
3. `'hides the overlays, the platform row and the add action when the caller supplies none of them'` —
   C4, C5, C6, C9, C11. One pump of a card holding a platform-less game and no optional
   input; five absence assertions.
4. `'hides the title at xs'` — C7.
5. `'shows the title and the platform row capped at one at sm'` — C8, C11.
6. `'shows the release date, the platform row and the add action at md'` — C9, C11.
7. `'calls the add action without calling the card tap when the add is tapped'` — C10.
8. `'calls the tap action once when the card is tapped'` — C13.
9. `'uses the shared hero tag built from the game id and fromScreen'` — C14. **Kept
   verbatim, asserting the exact string. One of the two reasons this file exists.**
10. `'registers no hero when several dataless cards render together'` — C15. **Kept
    verbatim. The other silent-failure path.**

Cut, with reasons:

- **Nine presence/absence tests collapsed into three** (2, 3, and the size pair 5/6). Each
  old test was a single pump asserting one widget's presence or absence; the conditions
  are independent, so one card with everything supplied and one with nothing supplied fail
  on exactly the same regressions with a fifth of the setup.
- **`'hides the critic number at sm when no score is supplied'`** (C8) — folded into 3.
- **`'hides the add action at md when no callback is supplied'`** (C9) — folded into 3.
- **`'hides the platform row when platforms are null or empty'`** (C11) — folded into 3.
- **`'does nothing when tapped with no tap action supplied'`** (C13, second half) — cut. A
  null `onTap` producing no callback is `InkWell`'s own behaviour, and the skill forbids
  testing Flutter itself. C13's "no ripple" half was already a manual check.
- **`'renders a long title and an over-cap platform list without overflowing'`** (C12) —
  cut from the test file and **added to the manual-check list**. What C12 protects is that
  no overflow stripe appears, which is a pixel-appearance outcome a device check sees
  directly. The `md` case is already exercised in real cell geometry by the grid test's
  narrow and wide surfaces (R2), and `sm` only ever renders dataless today. QA verifies a
  long title and an over-cap platform list on device at each size that has a footer.
- **The green colour assertion** — moved to `critic_badge_test.dart` (D2), not deleted.

Unchanged: `games_screen_test.dart` (3 tests) and `game_card_shimmers_test.dart` (2).
**Run total: 17 widget tests across 4 files**, down from 24 across 3.

### D4 — consequences for the allowlist, the catalogue and the plan

- `.claude/skills/flutter-widgets/SKILL.md` catalogue grows from 4 edited rows to 6:
  `GameCard`'s row takes the new path, and `LibraryTick` and `CriticBadge` get rows of
  their own beside it. Rule text still untouched. These rows replace the four above:

```
| `GameCard` | `game_card/game_card.dart` | Game card in three sizes (`xs` 64 no footer, `sm` 132, `md` fills its parent): 3:4 cover at r16 with an indigo wash and an onyx missing-art fallback, optional library tick / status chip / critic badge overlays, optional shared-element hero, constructible with no data for shimmers. Multi-file module — only `GameCard` and `GameCardSize` are public surface; the footer classes beside them are internal and are not imported from outside the folder. Adds no spacing of its own |
| `LibraryTick` | `library_tick.dart` | 20px indigo circle with a check, marking a cover as already in the library; no parameters, display-only; adds no spacing of its own |
| `CriticBadge` | `critic_badge.dart` | Green pill showing a critic score rounded to a whole number. `score` is the only parameter — no colour, threshold, variant or score ramp. Its green is one of §2 rule 1's two sanctioned exceptions (with the focus ring) because it is data, not an affordance: do not copy the green out of this widget and do not reuse it for a badge that is not a critic score |
| `GameItem` | `game_item.dart` | **Deprecated** — replaced by `GameCard`. Kept as reference only, no callers |
| `GameItemLoadingShimmer` | `game_item_loading_shimmer.dart` | Horizontal shimmer of dataless `GameCard`s at `sm` |
| `GameItemGridLoadingShimmer` | `game_item_grid_loading_shimmer.dart` | Grid shimmer of dataless `GameCard`s at `md`, matching the games grid's cell geometry |
```

- The `@Deprecated` line now points at the new path:
  `@Deprecated('Use GameCard in lib/widgets/game_card/game_card.dart')`.
- Callers import `package:.../widgets/game_card/game_card.dart` **and**
  `package:.../widgets/game_card/game_card_size.dart` (no barrel). This affects
  `games_screen.dart` and both shimmers; nothing else in those three files changes.
- **Implementation plan: 14 steps → 19.** Still under the 20 ceiling, so no escalation.
  One deliberate deviation from the one-file-per-step rule: the four files of the footer
  module land in a single step. They are one extraction, and splitting them would leave
  the tree non-compiling between steps for no reviewable gain. Every other new file is its
  own step.
- Step 13's repo search now covers `color.green` as well as `GameItem` (see D2).
- Nothing else moves. The Option B scope, the C2 wash-only design, OQ-1, the hero-tag
  string, the grid geometry derivation, `GamesGridConstants`, the `PlatformRowList`
  composition and the `GameItem` deprecation all stand exactly as written above.

# Code Plan
Source: Week 2 task brief item 1.3 · `system-foundation-specs.md` §3.3 "Cover tile"
Date: 2026-08-12

## CREATE NEW

### lib/widgets/cover_tile.dart

```dart
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_cached_network_image.dart';
import 'package:gaming_library_assessment_flutter/widgets/status_chip.dart';
import 'package:skeletonizer/skeletonizer.dart';

enum CoverTileSize {
  mini(width: 26, height: 34),
  row(width: 112, height: 150),
  fan(width: 100, height: 134),
  focal(width: 124, height: 166);

  const CoverTileSize({required this.width, required this.height});

  final double width;
  final double height;

  bool get isMini => this == CoverTileSize.mini;
}

class CoverTile extends StatelessWidget {
  const CoverTile({
    super.key,
    required this.size,
    this.imageUrl,
    this.status,
  });

  // saturate(.5) then contrast(1.05), per the spec. No effect token covers it.
  static const ColorFilter artworkFilter = ColorFilter.matrix(<double>[
    0.6368, 0.3754, 0.0378, 0, -6.375,
    0.1118, 0.9004, 0.0378, 0, -6.375,
    0.1118, 0.3754, 0.5628, 0, -6.375,
    0, 0, 0, 1, 0,
  ]);

  final CoverTileSize size;
  final String? imageUrl;
  final LibraryStatus? status;

  @override
  Widget build(BuildContext context) {
    final radius = context.tokens.radius;
    final borderRadius = BorderRadius.circular(
      size.isMini ? radius.mini : radius.lg,
    );
    final imageUrl = this.imageUrl;
    final status = this.status;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl == null || imageUrl.isEmpty)
              _CoverFallback(size: size, borderRadius: borderRadius)
            else
              DefaultCachedNetworkImage(
                imageUrl: imageUrl,
                imageBuilder: (context, image) => _CoverArtwork(image: image),
                placeholder: (context, url) =>
                    _CoverLoading(borderRadius: borderRadius),
                errorWidget: (context, url, error) =>
                    _CoverFallback(size: size, borderRadius: borderRadius),
              ),
            if (status != null && !size.isMini)
              Positioned(
                left: 8,
                bottom: 8,
                child: StatusChip(
                  status: status,
                  variant: StatusChipVariant.onMedia,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// The filter and the wash sit here, not around the whole tile, so the
// fallback and the loading block keep their own colours.
class _CoverArtwork extends StatelessWidget {
  const _CoverArtwork({required this.image});

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColorFiltered(
          colorFilter: CoverTile.artworkFilter,
          child: Image(image: image, fit: BoxFit.cover),
        ),
        ColoredBox(color: context.tokens.color.coverWash),
      ],
    );
  }
}

class _CoverFallback extends StatelessWidget {
  const _CoverFallback({required this.size, required this.borderRadius});

  final CoverTileSize size;
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
      child: size.isMini
          ? null
          : Center(
              child: Icon(
                Icons.videogame_asset_outlined,
                color: colors.ink24,
              ),
            ),
    );
  }
}

class _CoverLoading extends StatelessWidget {
  const _CoverLoading({required this.borderRadius});

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.tokens.color.surfaceRaised,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
```

## MODIFY EXISTING

### lib/widgets/default_cached_network_image.dart

```dart
class DefaultCachedNetworkImage extends StatelessWidget {
  final String? imageUrl;

  // Optional overrides for callers that draw their own states; unset
  // leaves the rendering every existing caller already gets.
  final ImageWidgetBuilder? imageBuilder;
  final PlaceholderWidgetBuilder? placeholder;
  final LoadingErrorWidgetBuilder? errorWidget;

  const DefaultCachedNetworkImage({
    required this.imageUrl,
    this.imageBuilder,
    this.placeholder,
    this.errorWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: imageUrl ?? '',
      imageBuilder: imageBuilder,
      placeholder:
          placeholder ??
          (context, url) => const Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            ),
          ),
      errorWidget:
          errorWidget ??
          (context, url, error) => const Center(child: Icon(Icons.error)),
    );
  }
}
```

### .claude/skills/flutter-widgets/SKILL.md

```markdown
| `DefaultCachedNetworkImage` | `default_cached_network_image.dart` | Remote image with cache, loader, error fallback; optional builders override the loaded/loading/error rendering |
...
| `CoverTile` | `cover_tile.dart` | Game cover at one of four fixed sizes: cropped art, saturate/contrast filter, indigo wash, optional bottom-left status chip, onyx+glyph fallback; adds no spacing of its own |
```

## TEST FILES

### test/widget/components/cover_tile_test.dart
- `'should render its stated dimensions when each of the four sizes renders'` — `getSize` on `CoverTile` equals 26×34 / 112×150 / 100×134 / 124×166.
- `'should clip to the mini radius at mini and the lg radius at the other three sizes'` — the tile's `ClipRRect.borderRadius` equals `AppTokens.dark.radius.mini` / `.lg`.
- `'should render the wash at coverWash above the artwork when art loads'` — build the pumped `DefaultCachedNetworkImage`'s `imageBuilder`, assert a `ColoredBox` at `colors.coverWash` sits after the filtered `Image` in the stack.
- `'should filter the artwork when art loads'` — the same builder output wraps the `Image` in a `ColorFiltered` whose filter is `CoverTile.artworkFilter`.
- `'should render no filter and no wash over the fallback when no url is supplied'` — no `ColorFiltered`, no `coverWash` `ColoredBox`.
- `'should render the status chip bottom-left in the on-media variant when a status is supplied'` — one `StatusChip` with `variant: onMedia`, 8px from the tile's left and bottom edges.
- `'should render nothing in the chip slot when no status is supplied'` — no `StatusChip`, and the tile's size is unchanged from the chipped case.
- `'should render no chip at the mini size even when a status is supplied'` — no `StatusChip`.
- `'should render the onyx fallback with a hairline and a gamepad glyph when the url is null or empty'` — `canvas` fill, `hairline` border, `Icons.videogame_asset_outlined`, and no `Image.asset`/`error_404.png`, no `Icons.error`, no `Text`.
- `'should render the same fallback when the image fails to load'` — invoke the pumped widget's `errorWidget` builder and pump it; same fill, border and glyph.
- `'should omit the glyph from the fallback at the mini size'` — fill and hairline only, no `Icon`.
- `'should render no CircularProgressIndicator while the image loads'` — pump the `placeholder` builder output; a `Skeletonizer` renders and `find.byType(CircularProgressIndicator)` is empty. Use `pump()`, never `pumpAndSettle()`.
- `'should add no spacing of its own when rendering'` — no `Padding` ancestor between `CoverTile` and its `SizedBox`, and the rendered box equals the size's dimensions exactly.

### test/widget/components/default_cached_network_image_test.dart
- `'should render the spinner placeholder when no placeholder is supplied'` — guards [1.3-AC15]: the `CachedNetworkImage`'s `placeholder` output still renders a `CircularProgressIndicator`.
- `'should render the error icon when no errorWidget is supplied'` — the `errorWidget` output still renders `Icons.error`.
- `'should pass no imageBuilder when none is supplied'` — the underlying `CachedNetworkImage.imageBuilder` is null, i.e. the default image rendering is untouched.

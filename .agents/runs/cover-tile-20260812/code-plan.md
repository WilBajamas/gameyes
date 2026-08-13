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

class _CoverArtwork extends StatelessWidget {
  const _CoverArtwork({required this.image});

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image(image: image, fit: BoxFit.cover),
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
| `CoverTile` | `cover_tile.dart` | Game cover at one of four fixed sizes: cropped art in its original colours, indigo wash, optional bottom-left status chip, onyx+glyph fallback; adds no spacing of its own |
```

## TEST FILES

### test/widget/components/cover_tile_test.dart
- `'should render its stated dimensions when each of the four sizes renders'` — `getSize` on `CoverTile` equals 26×34 / 112×150 / 100×134 / 124×166.
- `'should clip to the mini radius at mini and the lg radius at the other three sizes'` — the tile's `ClipRRect.borderRadius` equals `AppTokens.dark.radius.mini` / `.lg`.
- `'should render the wash at coverWash above the artwork when art loads'` — build the pumped `DefaultCachedNetworkImage`'s `imageBuilder`, assert a `ColoredBox` at `colors.coverWash` sits after the `Image` in the stack.
- `'should render the artwork with no colour filter when art loads'` — the same builder output, at every one of the four sizes: no `ColorFiltered` anywhere in it, and the `Image` has no `color`/`colorBlendMode` and no `Opacity` ancestor inside the tile ([1.3-AC7]).
- `'should render no wash over the fallback when no url is supplied'` — no `coverWash` `ColoredBox`.
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

## Approved feedback delta

- 2026-08-12, Phase 3 human override, [1.3-AC7] reversed: loaded artwork renders in its original colours. `CoverTile.artworkFilter` (`static const ColorFilter`) is deleted and the `ColorFiltered` wrapper around the artwork `Image` is removed — the `Image` renders directly, with `ColoredBox(color: coverWash)` stacked above it exactly as before.
- Same revision: the cover-tile test that asserted `CoverTile.artworkFilter` is replaced by one asserting no colour filter wraps the artwork at any size; the fallback test now asserts the wash's absence only.
- Same revision: the `flutter-widgets` catalogue row drops "saturate/contrast filter" and says the art keeps its original colours.
- `tdd.md` and `task-brief.md` were corrected in place for this revision (handover's in-place rule for substantial Phase 3 changes), so they do not conflict with the above.
- 2026-08-13, Phase 3 human style request: the two explanatory comments are dropped — the block comment above `_CoverArtwork` in `cover_tile.dart` and the comment above the three optional builder fields in `DefaultCachedNetworkImage`. Neither is load-bearing and both restate what the code shows; write both files with no comments. Behaviour is unchanged.

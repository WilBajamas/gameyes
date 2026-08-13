# Code Plan
Source: Week 2 task briefs items 1.5, 1.6, 1.7 (combined run) · `tech-ac.md` 2026-08-13
Date: 2026-08-13

## CREATE NEW

### lib/widgets/filter_count_chip.dart

```dart
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class FilterCountChip extends StatelessWidget {
  const FilterCountChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.count,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.color;
    // Inter 14/500 already; only the colour changes per state.
    final labelStyle = tokens.typography.meta.style;
    final count = this.count;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onSelected,
      // Height only - the 44px floor is the tap area, not the capsule, and
      // widthFactor keeps the chip at its content width inside a Wrap.
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Center(
          widthFactor: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isSelected ? colors.accentIndigo : colors.ink08,
              borderRadius: BorderRadius.circular(tokens.radius.pill),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      style: labelStyle.copyWith(color: colors.ink),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (count != null)
                    Text(
                      '$count',
                      style: labelStyle.copyWith(
                        color: isSelected ? colors.ink : colors.ink55,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

### lib/widgets/context_chip.dart

```dart
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/glass_surface_widget.dart';

class ContextChip extends StatelessWidget {
  const ContextChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.color;
    final pill = tokens.typography.pill;

    return GlassSurface(
      fill: colors.glass32,
      borderRadius: BorderRadius.circular(tokens.radius.pill),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            Icon(icon, size: 13, color: colors.ink),
            Flexible(
              child: Text(
                pill.format(label),
                style: pill.style.copyWith(color: colors.ink),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### lib/widgets/stat_pill.dart

```dart
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/glass_surface_widget.dart';

@immutable
class StatEntry {
  const StatEntry({required this.figure, required this.label});

  final String figure;
  final String label;
}

// The tile form: one pair on 8% ink, laid out in threes by its caller.
class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.figure, required this.label});

  final String figure;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.color.ink08,
        borderRadius: BorderRadius.circular(tokens.radius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: _StatPair(
          figure: figure,
          label: label,
          // The pill token's size, weight and tracking; the stat label is not
          // a caps role, so its uppercase flag is not applied.
          labelStyle: tokens.typography.pill.style.copyWith(
            color: tokens.color.ink55,
          ),
        ),
      ),
    );
  }
}

// The glass hero form: 2-3 pairs in one capsule.
class StatPill extends StatelessWidget {
  const StatPill({super.key, required this.stats})
    : assert(
        stats.length == 2 || stats.length == 3,
        'The glass stat pill holds two or three pairs.',
      );

  final List<StatEntry> stats;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final labelStyle = tokens.typography.microLabel.style;

    return GlassSurface(
      fill: tokens.color.glass30,
      borderRadius: BorderRadius.circular(tokens.radius.pill),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Loose flex so a long pair truncates instead of overflowing,
            // while the leftover space still falls between the pairs.
            for (final stat in stats)
              Flexible(
                child: _StatPair(
                  figure: stat.figure,
                  label: stat.label,
                  labelStyle: labelStyle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatPair extends StatelessWidget {
  const _StatPair({
    required this.figure,
    required this.label,
    required this.labelStyle,
  });

  final String figure;
  final String label;
  final TextStyle labelStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          figure,
          style: context.tokens.typography.statFigure.style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: labelStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
```

## MODIFY EXISTING

### lib/widgets/default_choice_chip.dart

Deleted. `FilterCountChip` replaces it and both callers migrate in this run, so no
`@Deprecated` alias is kept.

### lib/widgets/type_values_selection.dart

```dart
import 'package:gaming_library_assessment_flutter/widgets/filter_count_chip.dart';

        // ... unchanged title Text and SizedBox(height: 2) above ...
        Wrap(
          spacing: 5,
          children: typeList.map(
            (type) {
              return FilterCountChip(
                label: getTypeNames(type),
                isSelected: typeSelection == type,
                onSelected: () => onTypeSelected(type),
              );
            },
          ).toList(),
        ),
```

### lib/widgets/multi_type_values_selection.dart

```dart
import 'package:gaming_library_assessment_flutter/widgets/filter_count_chip.dart';

        Wrap(
          spacing: 4,
          children: selections.map(
            (type) {
              return FilterCountChip(
                label: type.valueName,
                isSelected: selectedItems.contains(type),
                onSelected: () => onSelect(type),
              );
            },
          ).toList(),
        ),
```

### lib/features/featured/presentation/widgets/library_stats.dart

```dart
import 'package:gaming_library_assessment_flutter/widgets/stat_pill.dart';

  Widget _buildLibraryStats(BuildContext context) {
    // ... totalGames / wishlistCount / weeklyHours / playingGames and
    // formattedHours all unchanged ...

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: StatTile(
                figure: totalGames.toString(),
                label: S.current.total_games,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatTile(
                figure: wishlistCount.toString(),
                label: S.current.wishlist,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatTile(
                figure: formattedHours,
                label: S.current.this_week,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // ... now-playing heading and card unchanged ...
      ],
    );
  }

  // _buildStatTile is deleted entirely, with its IconData and Color
  // parameters and the blueAccent / orangeAccent / green call sites.
  // _buildNowPlayingCard and _DashedBorderPainter are NOT touched.
```

### .claude/skills/flutter-widgets/SKILL.md

```markdown
| `FilterCountChip` | `filter_count_chip.dart` | Filter chip: pill capsule, indigo fill + white label when active, 8% ink + full-ink label when inactive, optional count after the label; adds no spacing of its own |
| `ContextChip` | `context_chip.dart` | Glass pill naming where the user is inside a hero: required 13px leading icon + 11px caps label, display-only; adds no spacing of its own |
| `StatTile` / `StatPill` | `stat_pill.dart` | Stat pill in two forms sharing one figure-over-label pair: `StatTile` on 8% ink at r16 (laid out in threes by its caller), `StatPill` as a glass capsule of 2-3 pairs; adds no spacing of its own |
```

The `DefaultChoiceChip` row is removed, not left beside these.

## TEST FILES

### test/widget/components/filter_count_chip_test.dart

- `'should fill the capsule with indigo and render a white label when selected'` — capsule
  `BoxDecoration.color` is `accentIndigo`, label `Text.style.color` is `ink`.
- `'should fill the capsule with ink08 and render a full ink label when not selected'` —
  capsule colour is `ink08`, label colour is `ink`.
- `'should round the capsule to the pill radius in both states'` — `borderRadius` equals
  `BorderRadius.circular(radius.pill)` selected and unselected.
- `'should render the label at 14px weight 500 in the body face'` — size, weight and font
  family match `typography.meta.style`.
- `'should render the count after the label when a count is supplied'` — `find.text('7')`
  is one widget and sits inside the capsule.
- `'should render no count widget when no count is supplied'` — exactly one `Text`
  descendant.
- `'should render the count when the count is zero'` — `find.text('0')` is one widget.
- `'should render the count in ink55 when not selected and in ink when selected'` — count
  `Text.style.color` per state.
- `'should truncate the label with an ellipsis when the parent is too narrow'` — a
  `SizedBox(width: 60)` parent leaves the label `maxLines: 1` /
  `TextOverflow.ellipsis`, the count still findable, and `tester.takeException()` null.
- `'should size itself to its content when the parent is wide'` — chip width is far
  below a 400px parent's width.
- `'should fire its callback once per tap in each state'` — a counter increments by
  exactly one per `tester.tap`, selected and unselected.
- `'should give the chip a hit target of at least 44 logical pixels'` —
  `tester.getSize(find.byType(FilterCountChip)).height >= 44`, with the capsule's own
  `DecoratedBox` shorter than that.
- `'should render no checkmark, icon or border when selected'` — no `Icon`, no
  `CustomPaint`, `BoxDecoration.border` is null, `boxShadow` is null.
- `'should add no spacing of its own'` — no `Padding` ancestor around the widget.

### test/widget/components/context_chip_test.dart

- `'should fill the capsule with the glass32 token behind a blur'` — `GlassSurface.fill`
  is `glass32` and one `BackdropFilter` is present.
- `'should clip the blur to the capsule'` — a `ClipRRect` ancestor of the `BackdropFilter`
  carries the pill radius.
- `'should round the capsule to the pill radius'` — `GlassSurface.borderRadius` equals
  `BorderRadius.circular(radius.pill)`.
- `'should render the label uppercase at 11px weight 500 in full ink'` — rendered text is
  the uppercased input; size, weight, letter spacing match `typography.pill.style`;
  colour is `ink`.
- `'should render a 13px leading icon in the label colour before the label'` — `Icon.size`
  is 13, `Icon.color` is `ink`, and the icon precedes the text in the row.
- `'should truncate the label with an ellipsis in a narrow parent'` — `maxLines: 1`,
  ellipsis, no exception.
- `'should expose no tap handler'` — no `GestureDetector`, `InkWell` or `InkResponse`
  descendant.
- `'should apply no position of its own'` — no `Positioned`, `Align`, `Transform` or
  `Padding` ancestor/descendant applying an offset.

### test/widget/components/stat_pill_test.dart

- `'should fill the tile with ink08 at the lg radius'` — tile `BoxDecoration.color` is
  `ink08`, `borderRadius` is `BorderRadius.circular(radius.lg)`, `border` is null.
- `'should render the figure above the label in the tile form'` — the figure's global `dy`
  is less than the label's, and both are horizontally centred in the tile.
- `'should render the tile figure in the stat figure token and its label at 11px ink55'` —
  figure style matches `typography.statFigure.style`; label size 11, weight 500, colour
  `ink55`.
- `'should adopt the parent width in the tile form'` — inside a 300px `SizedBox` the tile
  measures 300 wide; inside a three-`Expanded` row the three tiles measure equal.
- `'should fill the glass form with glass30 behind a clipped blur at the pill radius'` —
  `GlassSurface.fill`, one `BackdropFilter`, `borderRadius` equals the pill radius.
- `'should render the glass form label at 10px in ink70'` — matches
  `typography.microLabel.style`.
- `'should distribute the glass form pairs with space between them'` — the `Row`'s
  `mainAxisAlignment` is `spaceBetween` and no `SizedBox`/spacer sits between pairs.
- `'should accept two and three pairs in the glass form'` — both build with no exception
  and render the expected figures and labels.
- `'should reject one pair and four pairs in the glass form'` — constructing `StatPill`
  with 1 and with 4 entries throws an `AssertionError`.
- `'should render figures and labels verbatim in both forms'` — `'1,204'` and `'3.5h'`
  appear exactly as supplied, with no `S.current` lookup or reformatting.
- `'should truncate a long figure or label with an ellipsis'` — `maxLines: 1` and
  ellipsis in a narrow parent, `tester.takeException()` null in both forms.
- `'should add no spacing of its own in either form'` — no `Padding` ancestor around
  either widget.

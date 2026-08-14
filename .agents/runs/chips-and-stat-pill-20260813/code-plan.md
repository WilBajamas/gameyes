# Code Plan
Source: Week 2 task briefs items 1.5, 1.6, 1.7 (combined run) · `tech-ac.md` 2026-08-13
Date: 2026-08-13
Revised: 2026-08-14 (Phase 3, human override — `## TEST FILES` deferred; see the delta at
the end)

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

**Deferred to the human — Dev writes none this run.** [ALL-AC7] as revised 2026-08-14
moves test authorship for `FilterCountChip`, `ContextChip` and `StatTile`/`StatPill` to
the human, who supplies `test/widget/components/filter_count_chip_test.dart`,
`context_chip_test.dart` and `stat_pill_test.dart` afterwards for separate review. The
Dev-ready test outlines that stood here are removed so nothing reads as a work item.

What those files should cover is `tech-ac.md`'s **[ALL-AC7] state matrix** — the per-
component list under 1.5, 1.6 and 1.7 there is canonical and is the checklist the
human-supplied tests are reviewed against. Do not re-derive it from this file.

Two rules bind the human's files as much as Dev's: **no golden test and no
`matchesGoldenFile`**, whatever the criteria say about appearance; and the established
shape in `test/widget/components/` applies — `GoogleFonts.config.allowRuntimeFetching =
false`, the `setUpAll` font warm-up, a `MaterialApp(theme: buildDarkTheme())` wrapper with
the `S` delegates, and `'should [expected behaviour] when [condition]'` test names.

Dev's own obligation is unchanged and is not a test file: run the full existing suite and
confirm the two call-site migrations and the deleted `default_choice_chip.dart` cause no
regression against `orchestrator-state.md`'s recorded baseline (`task-brief.md` Step 9).

## Approved feedback delta

- 2026-08-14 — [ALL-AC7] revised by the BA at the human's direction: **Dev writes no
  widget test file for the three components.** Authorship moves to the human, for review
  in a later pass. Deferred, not waived.
- The three test files are removed from `task-brief.md`'s allowlist and its plan steps 9,
  10 and 11 are gone; the verification step is now Step 9. Creating any file under `test/`
  in this run is an allowlist breach.
- `## TEST FILES` above no longer carries test outlines — `tech-ac.md`'s [ALL-AC7] matrix
  is the checklist for the human's files.
- `tdd.md` and `task-brief.md` were corrected in place rather than by delta alone, per the
  substantial-revision rule in `.agents/handover.md`; both carry a dated revision note.
- Unchanged by this revision: the 8 source files, both call-site migrations, the catalogue
  update, every design and reuse decision, and Dev's full-suite regression check.

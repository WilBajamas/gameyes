# Code Plan
Source: Week 2 task briefs items 1.5, 1.6, 1.7 (combined run) · `tech-ac.md` 2026-08-13
Date: 2026-08-13
Revised: 2026-08-14 (Phase 3, human override — `## TEST FILES` deferred; then a second
Phase 3 pass for even dimensions, `Expanded`, and the spread operator; then a third for
comment removal; see the delta at the end)

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
    final labelStyle = tokens.typography.meta.style;
    final count = this.count;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onSelected,
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
            Icon(icon, size: 12, color: colors.ink),
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
        padding: const EdgeInsets.all(14),
        child: _StatPair(
          figure: figure,
          label: label,
          labelStyle: tokens.typography.pill.style.copyWith(
            color: tokens.color.ink55,
          ),
        ),
      ),
    );
  }
}

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
          children: [
            ...stats.map(
              (stat) => Expanded(
                child: _StatPair(
                  figure: stat.figure,
                  label: stat.label,
                  labelStyle: labelStyle,
                ),
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
| `ContextChip` | `context_chip.dart` | Glass pill naming where the user is inside a hero: required 12px leading icon + 11px caps label, display-only; adds no spacing of its own |
| `StatTile` / `StatPill` | `stat_pill.dart` | Stat pill in two forms sharing one figure-over-label pair: `StatTile` on 8% ink at r16 (laid out in threes by its caller), `StatPill` as a glass capsule of 2-3 pairs; adds no spacing of its own |
```

The `DefaultChoiceChip` row is removed, not left beside these.

Only the catalogue table is Dev's to edit. The two new standing-convention bullets
("Dimensions are even numbers", "Prefer `Expanded` over `Flexible`, unless the widget
hugs its content") were added to the same file by the Tech Lead on 2026-08-14 and are
already in place — Dev leaves that section alone.

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

### 2026-08-14 (second pass) — even dimensions, `Expanded`, spread operator

Implementation style only. No criterion, allowlist entry, plan step or test-scope changed,
so `tdd.md` and `task-brief.md` are **not** rewritten — where they still show `13`,
`Flexible` in `StatPill`, or the `for` loop, this delta wins.

**1. No odd-numbered dimensions.** Two odd values existed in this run's own new code and
both change:

- `context_chip.dart` — `Icon(icon, size: 13)` → **`size: 12`**. Rounded down: the label
  beside it is 11px caps, and 14 would make the icon visibly out-weigh its own label,
  while 12 sits just above the cap height and reads balanced. 12 is also already this
  widget's horizontal padding, so the chip uses one value twice instead of a third
  number.
- `stat_pill.dart` — `StatTile`'s `padding: EdgeInsets.all(13)` → **`EdgeInsets.all(14)`**.
  Rounded up: the caller separates the three tiles by 12 (`SizedBox(width: 12)` in
  `library_stats.dart`), and interior padding equal to the gap between tiles reads
  under-padded on an r16 surface — the content wants a little more inset than the gutter
  so it clears the rounded corner. 14 also matches `StatPill`'s own horizontal 14, so both
  forms of the family share one inset.

  These two override the literal `13` written into [1.6-AC5] and [1.7-AC2]. Nothing else
  in either criterion moves — icon still required, still label-coloured, still 6px from
  the label; tile still `ink08` at `lg` radius, padding still equal on all four sides. QA
  measures 12 and 14 against this delta, not the `13` in `tech-ac.md`.

- **Not touched, and not this run's to touch:** `type_values_selection.dart`'s
  `Wrap(spacing: 5)` and `multi_type_values_selection.dart`'s `Wrap(spacing: 4)` are
  **pre-existing shipped code**, verified in both files on disk. This run only swaps
  `DefaultChoiceChip` for `FilterCountChip` inside them — `task-brief.md` steps 4 and 5
  already say to leave the `Wrap` untouched, and [ALL-AC1] keeps that spacing with the
  caller by design. Same treatment as `_DashedBorderPainter`: leave exactly as is, raise
  as a follow-up. Other pre-existing odd values the new convention will surface later, all
  out of scope here: the 11px pill/caps type token, `StatusChip`'s `list` variant 7px dot,
  and the 5/4 `Wrap` spacings above.

**2. `Expanded` instead of `Flexible` — applied to one of the three, flagged on two.**

- `stat_pill.dart` — **applied.** `StatPill`'s `Row` has no `mainAxisSize: min`; it fills
  the capsule already, so `Expanded` is the right flex and gives each pair an equal share.
  One visual consequence to expect: `mainAxisAlignment: spaceBetween` is now dead (three
  `Expanded` children leave no free space to distribute) and is removed, so the outer
  pairs no longer touch the capsule's inner edges — each pair centres inside its own equal
  slot. Reads as evenly distributed, which is [1.7-AC5]'s intent, but it is equal *slots*
  rather than equal *gaps*. Flagging the difference, not blocking on it.
- `filter_count_chip.dart` — **held at `Flexible`, needs the human's call.** Same
  hug-content pattern as `status_chip.dart`: `Row(mainAxisSize: MainAxisSize.min)` inside
  `Center(widthFactor: 1)`. `Expanded` in a `min` row makes the row claim the full width
  it was offered, so inside `TypeValuesSelection`'s `Wrap` every chip would become
  full-width and the chip group would collapse into one chip per line. That is a shape
  change, not a refactor.
- `context_chip.dart` — **held at `Flexible`, needs the human's call.** Same pattern:
  `Row(mainAxisSize: MainAxisSize.min)` inside `GlassSurface`, which passes its
  constraints straight through. `Expanded` would turn the capsule into a full-width glass
  bar wherever the hero places it, and [1.6-AC6] requires the chip to size itself to its
  content.

  Both are the exact exception `status_chip.dart` is being held for. If the human wants
  `Expanded` in them anyway, the fix is to bound the width at the parent, not to swap the
  flex — worth a separate decision alongside the `status_chip.dart` one. Until then Dev
  writes `Flexible` in these two; the reasoning lives here in the delta, not in the file.

**3. Spread operator in `StatPill`.** `for (final stat in stats) Flexible(...)` becomes
`...stats.map((stat) => Expanded(child: _StatPair(...)))`, combined with change 2 in the
same edit. No behaviour change beyond the `Expanded` swap already described.

  **Not codified as a standing convention** — judgment call, flagging it as such. A
  `for`-in element in a collection literal is idiomatic Dart, and it is the better form
  the moment an `if` or a second element joins it (the widget catalogue uses it that way
  in several places). `...map()` is only clearly nicer for a plain 1:1 wrap like this one.
  A blanket rule would force the worse form half the time, so it stays a per-site
  preference. Say the word and it goes in the skill.

**4. Standing conventions added to `.claude/skills/flutter-widgets/SKILL.md`** by the Tech
Lead, in the "Building a new reusable widget" list beside "No spacing of its own" and
"Outlines are always solid":

- *Dimensions are even numbers* — every dimension a widget writes itself, with the
  explicit note that odd values in already-shipped widgets and in the theme tokens are a
  follow-up to raise, not something to rewrite inside an unrelated run.
- *Prefer `Expanded` over `Flexible`, unless the widget hugs its content* — worded as a
  default plus a real exception, not an absolute: a chip/pill/badge using
  `mainAxisSize: MainAxisSize.min` to stay at its content width is the legitimate case,
  and there the instruction is to flag the trade-off, not to swap it blind.
  `StatusChip` is named as the live example.

  A matching "Do not introduce an odd-numbered dimension" line was added to that skill's
  *What NOT to do* list. Dev's own SKILL.md edit is still the catalogue table only.

### 2026-08-14 (third pass) — no shipped comments

- Style only, same as the comment removals already applied to items 1.3 and 1.4: every
  comment that would land in a shipped file is deleted from the skeletons above —
  `filter_count_chip.dart` (the `labelStyle`, `ConstrainedBox` and `Flexible` comments),
  `context_chip.dart` (the `Flexible` comment), `stat_pill.dart` (the `StatTile`,
  `labelStyle`, `StatPill` and `Row` comments), and the trailing "pre-existing, untouched"
  notes on the `Wrap` spacing lines in `type_values_selection.dart` and
  `multi_type_values_selection.dart` (code unchanged, `spacing: 5` and `spacing: 4` stay).
  Dev writes these files with no comments in them. The `// ...` elision markers and the
  `_buildStatTile is deleted` note are this plan's own annotations, not file content, and
  stay. The second pass's "with the one-line comment shown in the skeletons" instruction
  for `Flexible` is withdrawn — the reasoning stays in this delta only. No criterion,
  allowlist entry, plan step or test-scope changed, so `tdd.md` and `task-brief.md` are
  not rewritten.

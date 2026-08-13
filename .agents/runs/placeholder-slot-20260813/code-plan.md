# Code Plan
Source: Week 2 task brief item 1.4 · `system-foundation-specs.md` §3.3 · `onboarding-auth-design-spec.md` §3, §9, §10 · `flutter-widgets` skill
Date: 2026-08-13

## CREATE NEW

### lib/widgets/placeholder_slot.dart

```dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

enum PlaceholderSlotSize {
  appMark(dimension: 88),
  providerMark(dimension: 20);

  const PlaceholderSlotSize({required this.dimension});

  final double dimension;

  bool get isAppMark => this == PlaceholderSlotSize.appMark;
}

class PlaceholderSlot extends StatelessWidget {
  const PlaceholderSlot({super.key, required this.size});

  final PlaceholderSlotSize size;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final borderRadius = BorderRadius.circular(switch (size) {
      // 20 is not in the radius scale; it is a local addition per §6.
      PlaceholderSlotSize.appMark => 20,
      PlaceholderSlotSize.providerMark => tokens.radius.xs,
    });
    final marker = tokens.typography.zoneLabel;

    return SizedBox.square(
      dimension: size.dimension,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.color.ink12,
          borderRadius: borderRadius,
        ),
        child: CustomPaint(
          painter: _DashedOutline(
            color: tokens.color.ink24,
            borderRadius: borderRadius,
          ),
          child: size.isAppMark
              ? Center(
                  child: Text(
                    'LOGO',
                    // 14 x 0.16em
                    style: marker.style.copyWith(
                      fontSize: 14,
                      letterSpacing: 2.24,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class _DashedOutline extends CustomPainter {
  const _DashedOutline({required this.color, required this.borderRadius});

  static const double _strokeWidth = 1;
  static const double _dashLength = 2;
  static const double _gapLength = 2;

  final Color color;
  final BorderRadius borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    // Half the stroke keeps the whole dash inside the box, and one
    // continuous path carries the dashes through the corners.
    final outline = Path()
      ..addRRect(
        borderRadius.toRRect(Offset.zero & size).deflate(_strokeWidth / 2),
      );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;

    for (final metric in outline.computeMetrics()) {
      var start = 0.0;
      while (start < metric.length) {
        final end = math.min(start + _dashLength, metric.length);
        canvas.drawPath(metric.extractPath(start, end), paint);
        start = end + _gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedOutline oldDelegate) =>
      oldDelegate.color != color || oldDelegate.borderRadius != borderRadius;
}
```

## MODIFY EXISTING

### lib/widgets/logo_placeholder.dart

Removed by the rename in step 1. Nothing remains at this path — no class, no
`@Deprecated` alias, no re-export.

### lib/features/auth/presentation/screens/auth_screen.dart

```dart
import 'package:gaming_library_assessment_flutter/widgets/button_press_scale.dart';
import 'package:gaming_library_assessment_flutter/widgets/placeholder_slot.dart';

// ...

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: PlaceholderSlot(size: PlaceholderSlotSize.appMark),
              ),
              const SizedBox(height: 32),
```

### .agents/references/onboarding-auth-design-spec.md

§9, replacement checklist — first bullet:

```markdown
- [ ] `88px` app mark — use the global `PlaceholderSlot` at its app-mark preset
      (dashed outline) until the final app mark is supplied.
```

§10, Flutter composition — the `LogoPlaceholder` bullet:

```markdown
- `PlaceholderSlot` is a global reusable widget under `lib/widgets/`. It takes
  one of two presets — app mark (`88`, radius 20) and provider mark (`20`,
  `--radius-xs`) — and draws a `--color-ink-12` fill with a 1px dashed
  `rgba(255,255,255,.24)` outline. It has no width/height input and adds no
  spacing of its own.
```

### .claude/skills/flutter-widgets/SKILL.md

New catalogue row, directly after the `StatusChip` row:

```markdown
| `PlaceholderSlot` | `placeholder_slot.dart` | Reserved empty box signalling art is still owed: ink-12 fill, 1px dashed ink-24 outline, two presets (app mark 88 r20 with a `LOGO` marker, provider mark 20 r-xs, no label); adds no spacing of its own |
```

## TEST FILES

### test/widget/components/placeholder_slot_test.dart

- `'should render an 88 box at the app mark preset and a 20 box at the provider mark preset'` — `tester.getSize(find.byType(PlaceholderSlot))` equals `Size(88, 88)` then `Size(20, 20)`.
- `'should round the app mark to 20 and the provider mark to the xs radius'` — the `BoxDecoration.borderRadius` on the slot's `DecoratedBox` equals `BorderRadius.circular(20)`, then `BorderRadius.circular(radius.xs)`.
- `'should fill both presets with ink12'` — `BoxDecoration.color` equals `colors.ink12` at each preset.
- `'should draw a dashed 1px ink24 outline and no solid border at both presets'` — the `CustomPaint` painter is a `CustomPainter` whose paint uses `colors.ink24` at stroke width 1 (asserted through the `paints` matcher: `paints..path(color: colors.ink24, strokeWidth: 1, style: PaintingStyle.stroke)`), and `BoxDecoration.border` is `null` at both presets.
- `'should paint several dashes per side at the provider mark preset'` — build a `PaintPattern` in a loop of 16 `path()` entries and match the provider preset's render object against it, proving the outline is many short segments (~4 per side), not one stroked path.
- `'should render the LOGO marker in the display face at 700 only at the app mark preset'` — at `appMark`, `find.text('LOGO')` finds one widget whose style has `fontWeight` `w700`, `fontSize` 14, `letterSpacing` 2.24, `color` `colors.ink55`, and the same `fontFamily` as `typography.zoneLabel.style`; at `providerMark`, `find.byType(Text)` finds nothing.
- `'should hold its box inside a fixed-size parent and inside an unbounded parent'` — the app mark preset measures `Size(88, 88)` both inside a 200×200 `SizedBox` with a `Center` and inside a horizontally unbounded parent, with no overflow exception recorded.
- `'should add no spacing of its own'` — no `Padding` ancestor between the slot and its parent, and the measured size equals the preset dimension exactly at both presets.

No `matchesGoldenFile` and no golden files anywhere in this file.

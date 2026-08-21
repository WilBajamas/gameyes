# Code Plan
Source: `.agents/runs/completion-ring-20260821/tech-ac.md` — week 2 Stage 2 item 2.2, Completion ring
Date: 2026-08-21

## CREATE NEW

### lib/widgets/completion_ring.dart

No comments in this file — the block below is the file as it should read.

```dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';

const double _ringInset = 2;

enum CompletionRingSize {
  inline(box: 60, stroke: 6, figureSize: 14, showsCaption: false),
  specimen(box: 80, stroke: 8, figureSize: 18, showsCaption: true),
  detail(box: 88, stroke: 8, figureSize: 22, showsCaption: true);

  const CompletionRingSize({
    required this.box,
    required this.stroke,
    required this.figureSize,
    required this.showsCaption,
  });

  final double box;
  final double stroke;
  final double figureSize;
  final bool showsCaption;

  double get radius => (box - _ringInset * 2 - stroke) / 2;
}

class CompletionRing extends StatelessWidget {
  const CompletionRing({
    super.key,
    required this.value,
    required this.size,
    this.caption,
  });

  final double value;
  final CompletionRingSize size;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final clamped = value.clamp(0, 100).toDouble();
    final percentage = clamped.truncate();
    final complete = clamped == 100;
    final captionLine = size.showsCaption ? caption : null;

    return Semantics(
      container: true,
      excludeSemantics: true,
      label: S.current.completed_percentage('$percentage'),
      child: SizedBox.square(
        dimension: size.box,
        child: CustomPaint(
          painter: CompletionRingPainter(
            progress: clamped / 100,
            radius: size.radius,
            stroke: size.stroke,
            trackColor: tokens.color.ink12,
            progressColor: complete
                ? tokens.color.accentMagenta
                : tokens.color.accentIndigo,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$percentage%',
                  style: tokens.typography.statFigure.style.copyWith(
                    fontSize: size.figureSize,
                  ),
                  maxLines: 1,
                ),
                if (captionLine != null)
                  Text(
                    captionLine,
                    style: tokens.typography.microLabel.style.copyWith(
                      color: tokens.color.ink55,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CompletionRingPainter extends CustomPainter {
  CompletionRingPainter({
    required this.progress,
    required this.radius,
    required this.stroke,
    required this.trackColor,
    required this.progressColor,
  });

  final double progress;
  final double radius;
  final double stroke;
  final Color trackColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final centre = size.center(Offset.zero);

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = trackColor;

    canvas.drawCircle(centre, radius, track);

    if (progress <= 0) return;

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = progressColor;

    canvas.drawArc(
      Rect.fromCircle(center: centre, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant CompletionRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.radius != radius ||
      oldDelegate.stroke != stroke ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.progressColor != progressColor;
}
```

Points a reviewer should look at rather than skim:

- `clamped` and `percentage` are the only clamp and the only truncation in the component. The
  arc fraction, the visible label, the semantics label and the colour all read from them.
- `complete` is `== 100` after clamping, so `100%`, magenta, and a closed ring are the same
  event. `99.6` gives `99%` on an indigo, nearly-closed arc.
- `if (progress <= 0) return;` is what makes 0% an untouched track — with `StrokeCap.round` a
  zero-length arc would otherwise paint a dot (C4's named failure).
- `shouldRepaint` compares every painted field. `_DashedBorderPainter`'s `=> false` would
  freeze the arc at its first value.
- The track is drawn with the default butt cap because it is a closed circle; only the arc
  needs `StrokeCap.round` (both documented sizes specify `stroke-linecap: round`).
- `radius` is derived from `box`, `stroke` and a shared inset of 2: 60 → 25 and 88 → 38,
  matching the two documented sizes, and 80 → 34 under ASSUMPTION-2.

## MODIFY EXISTING

### .claude/skills/flutter-widgets/SKILL.md

Catalogue table only — one row appended in the same style as its neighbours. No rule text
changes.

```markdown
| `CompletionRing` | `completion_ring.dart` | Circular completion ring at three fixed sizes (60 inline, 80 specimen, 88 detail): ink-12 track with a proportional arc over it and the truncated percentage centred inside, plus an optional caption at the two larger sizes. Indigo below 100, a closed magenta ring at exactly 100; value clamps to 0–100 and never throws. Display-only, unanimated, not a hit target; adds no spacing of its own |
```

## TEST FILES

### test/widget/components/completion_ring_test.dart

Harness: copy `context_chip_test.dart` — `buildSubject` returning `MaterialApp` with
`buildDarkTheme()`, the four localisation delegates, and a `Scaffold` body. No `setUpAll`, no
token pre-resolution, no zones. Colour expectations reference `AppColorTokens.dark` directly
(it is a plain const and needs no font warm-up). One local helper reads the painter:

```dart
CompletionRingPainter painterOf(WidgetTester tester) =>
    (tester
                .widget<CustomPaint>(
                  find.byWidgetPredicate(
                    (widget) =>
                        widget is CustomPaint &&
                        widget.painter is CompletionRingPainter,
                  ),
                )
                .painter!
            as CompletionRingPainter);
```

- `'shows the truncated percentage when the value carries a fraction'` — `99.6` renders
  `99%` and `0.4` renders `0%`; truncation toward zero, never rounding (C6, C11).
- `'shows a clamped percentage when the value falls outside 0 to 100'` — `-5` renders `0%`
  and `140` renders `100%`, with no thrown exception (C5, C7).
- `'switches the arc to accentMagenta only at 100 and leaves the ink12 track unchanged'` —
  at `99` the painter's `progressColor` is `AppColorTokens.dark.accentIndigo`; at `100` and
  at `140` it is `AppColorTokens.dark.accentMagenta`; `trackColor` is
  `AppColorTokens.dark.ink12` at every one of them (C8, C9's colour, C10).
- `'shows the percentage at every size and drops the caption at the inline size'` — the three
  sizes pumped side by side in an unbounded `Row` with the same `caption: 'done'`; `50%` is
  found three times and `done` twice, and the unbounded parent throws nothing (C1's three
  members, C2, C3, C11, C13).
- `'states the clamped percentage in the semantics label'` — with `tester.ensureSemantics()`,
  `37` announces `37% completed`, `-5` announces `0% completed` and `140` announces
  `100% completed` (C14). `140` is the clamped-out-of-range case and the exactly-100
  rendering in one pump, so no fourth value is needed.

Five tests, five pumped states each doing one thing. Nothing in this file asserts a box size,
a stroke, a radius, an offset or a font size, and there is no golden test.

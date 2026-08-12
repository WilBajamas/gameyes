# Code Plan
Source: Week 2 task brief item 1.1 · `system-foundation-specs.md` §3.2 "Zone label"
Date: 2026-08-09 · revised 2026-08-12 (Phase 3 revision round 1)

## CREATE NEW

### lib/widgets/zone_label.dart

```dart
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class ZoneLabel extends StatelessWidget {
  const ZoneLabel({
    super.key,
    required this.label,
    this.linkLabel,
    this.onLinkPressed,
  });

  final String label;
  final String? linkLabel;
  final VoidCallback? onLinkPressed;

  @override
  Widget build(BuildContext context) {
    final zoneLabel = context.tokens.typography.zoneLabel;
    // Locals so the two link fields promote to non-null inside the if below.
    final linkLabel = this.linkLabel;
    final onLinkPressed = this.onLinkPressed;

    // No padding or margin here on purpose: the gap between zones is the
    // caller's to apply, so this sits flush in whatever bounds it is given.
    return Row(
      children: [
        Expanded(
          child: Text(
            zoneLabel.format(label),
            style: zoneLabel.style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (linkLabel != null && onLinkPressed != null)
          _ZoneLink(label: linkLabel, onPressed: onLinkPressed),
      ],
    );
  }
}

class _ZoneLink extends StatelessWidget {
  const _ZoneLink({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      // Height only - the link keeps its 13px text and its own width.
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Center(
          child: Text(
            label,
            style: context.tokens.typography.zoneLink.style,
          ),
        ),
      ),
    );
  }
}
```

## MODIFY EXISTING

### .claude/skills/flutter-widgets/SKILL.md

Two edits, nothing else in the file.

**Edit 1 — new bullet in "Building a new reusable widget".** Insert between the
"Configurable, not hardcoded." bullet and the "Reuse before rebuilding." bullet
(currently line 77):

```markdown
- **No spacing of its own.** A reusable widget renders flush inside the bounds
  its parent gives it — no outer padding, margin, or spacer around its content,
  and no `EdgeInsets`/`padding`/gap constructor parameter reintroducing the same
  concern through its API. Separation between components belongs to the layout
  that places them: a `Column`'s spacing, a gap widget, the screen's own
  gutters — per §1.3's "stacks use flex `gap`, never margins between siblings".
  Padding *inside* a surface the widget itself draws (a card, chip or button's
  interior) is that widget's own anatomy and is fine; the rule is about space
  *around* the widget. One that bakes in its outer spacing only fits one layout.
```

**Edit 2 — one new row at the end of the "Existing reusable widgets catalogue"
table** ([1.1-AC12]). The `AddContentDialog` row below is the existing last
row, shown for position only — do not re-add it:

```markdown
| `AddContentDialog` | `add_content_dialog.dart` | Dialog for adding tracker content |
| `ZoneLabel` | `zone_label.dart` | Caps section heading with optional trailing link; adds no spacing of its own |
```

## TEST FILES

### test/widget/components/zone_label_test.dart

Harness: `TestWidgetsFlutterBinding.ensureInitialized()` +
`GoogleFonts.config.allowRuntimeFetching = false` at the top of `main()`; a
`buildSubject({String? linkLabel, VoidCallback? onLinkPressed})` helper
returning `MaterialApp(theme: buildDarkTheme(), home: Scaffold(body:
ZoneLabel(label: ..., ...)))`. Style assertions read individual fields off
`AppTokens.dark.typography.<token>.style`, never whole-`TextStyle` equality.

- `'should render the label in capitals when the caller passes lower case'` —
  pumps `label: 'now playing'`, expects `find.text('NOW PLAYING')` and
  `find.text('now playing')` to find nothing. [1.1-AC3]
- `'should style the label from the zoneLabel token when rendering'` — reads
  the rendered `Text`'s style and asserts `fontSize`, `fontWeight`,
  `letterSpacing` and `color` match `AppTokens.dark.typography.zoneLabel.style`.
  [1.1-AC3]
- `'should style the link from the zoneLink token when a link is supplied'` —
  same field-by-field comparison against
  `AppTokens.dark.typography.zoneLink.style`. [1.1-AC4]
- `'should render the link when both text and callback are supplied'` —
  expects the link text found once. [1.1-AC4]
- `'should render no link when only the text is supplied'` — expects the link
  text and any `GestureDetector` in the subtree to be absent. [1.1-AC4,
  1.1-AC5]
- `'should render no link when only the callback is supplied'` — expects no
  `GestureDetector` in the subtree. [1.1-AC4, 1.1-AC5]
- `'should invoke the callback once when the link is tapped'` — taps the link
  text, asserts a counter incremented to exactly 1. [1.1-AC4]
- `'should render no divider in any configuration'` — with and without a link,
  expects `find.byType(Divider)` to find nothing. [1.1-AC7]
- `'should keep the link tap target at least 44 high when rendering'` —
  `tester.getSize` on the link's tappable region, expects `height >= 44` while
  the link's `fontSize` still matches the `zoneLink` token. [1.1-AC6]
- `'should add no vertical spacing around the label when rendering'` — with no
  link, asserts `tester.getSize(find.byType(ZoneLabel)).height` equals the
  rendered label `Text`'s own height, and that the subtree contains no
  `Padding` above the `Row` (`find.ancestor` of the `Row` inside `ZoneLabel`
  finds no `Padding`). Guards the reversed criterion. [1.1-AC8]

## Approved feedback delta

- [1.1-AC8] reversed at the Phase 3 gate: the widget imposes no vertical
  spacing. `Padding(top: 40, bottom: 16)` removed; `Row` is now `ZoneLabel`'s
  root widget. `tdd.md` and `task-brief.md` corrected in place to match, per
  `handover.md`'s substantial-revision rule — no stale copy remains.
- Spacing must not return as a constructor parameter. An `EdgeInsets`/padding/
  gap argument is explicitly rejected: the widget does not respond to a spacing
  concept at all. Callers separate zones with their own layout.
- The 40 / 16 recommendation is surfaced nowhere — not in the widget, the
  catalogue row, or the skill. Reasoning in `tdd.md ## Revision decisions`; the
  values survive only as `tech-ac.md`'s ASSUMPTION while this run folder lives.
- The `flutter-widgets` skill edit grows from one to two edits in the same
  already-allowlisted file: the catalogue row plus a new standing "No spacing of
  its own" convention bullet. Human-directed, wider than [1.1-AC12]'s wording,
  and approved scope — QA should check future reusable widgets against it too.
- One test added beyond [1.1-AC11]'s enumerated list: the flush-render guard
  for [1.1-AC8].

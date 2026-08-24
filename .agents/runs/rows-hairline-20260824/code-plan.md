# Code Plan
Source: `tech-ac.md` — item 2.6, `system-foundation-specs.md` §3.2 line 246
Date: 2026-08-24

## CREATE NEW

### lib/widgets/label_value_row.dart

```dart
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class LabelValueRow extends StatelessWidget {
  const LabelValueRow({
    super.key,
    required this.label,
    required this.value,
    this.showChevron = false,
  });

  final String label;
  final String value;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final meta = tokens.typography.meta.style;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Text(
              label,
              style: meta.copyWith(color: tokens.color.ink),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(value, style: meta, maxLines: 1, overflow: TextOverflow.ellipsis),
          if (showChevron)
            Icon(Icons.chevron_right, size: 16, color: tokens.color.ink55),
        ],
      ),
    );
  }
}
```

Three notes for the reviewer, none of which appear in the file:

- `meta` is already 14/500 at `ink70`, so the value passes it through unchanged
  and only the label overrides the colour — that is the whole of [2.6-AC2].
- Label `Expanded`, value at natural width, no `Flexible`: the label is the child
  meant to take the leftover space, and this is the shape
  `labeled_text_field.dart`'s `_FieldLabelRow` already ships.
- Chevron size and colour are fixed by no criterion and no design doc. 16 is the
  even step already used for `ActionRow`'s trailing mark, and `ink55` is the
  ramp's secondary step, since a chevron is a marker rather than content. QA's
  visual check, not a test.

### lib/widgets/hairline_group.dart

```dart
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class HairlineGroup extends StatelessWidget {
  const HairlineGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    final tokens = context.tokens;

    return ClipRRect(
      borderRadius: BorderRadius.circular(tokens.radius.lg),
      child: ColoredBox(
        color: tokens.color.surfaceRaised,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var index = 0; index < children.length; index++) ...[
              if (index > 0)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: tokens.color.hairline,
                ),
              children[index],
            ],
          ],
        ),
      ),
    );
  }
}
```

The constructor is the criterion: `key` and `children`, nothing else. `index > 0`
is the entire hairline rule — there is no branch that could place one above the
first child or below the last, and no caller input that reaches it.

## MODIFY EXISTING

### .claude/skills/flutter-widgets/SKILL.md

Two rows appended to the "Existing reusable widgets catalogue" table, in the
style of the surrounding entries. Nothing else in the file changes.

```markdown
| `LabelValueRow` | `label_value_row.dart` | Dense-list row: required label at full ink taking the leftover width, required value at ink-70 beside it, optional trailing chevron. Draws no fill, radius or edge of its own — surface and hairlines belong to `HairlineGroup`. Display-only, not a tap target; adds no spacing of its own |
| `HairlineGroup` | `hairline_group.dart` | Raised card wrapping any list of children: `surfaceRaised` fill at r16, clipped, with a 1px hairline between each adjacent pair — exactly N−1 for N children, never on an outer edge. `children` is the only parameter, so hairline placement cannot be added, removed or moved by a caller. Renders nothing when given no children; adds no spacing of its own |
```

## TEST FILES

### test/widget/components/label_value_row_test.dart

Shared `buildSubject({required String label, required String value, bool showChevron = false})`
wrapping `LabelValueRow` in `MaterialApp(theme: buildDarkTheme())` + `Scaffold`,
per `context_chip_test.dart`.

- `'shows the label in ink and the value in ink70'` — reads both `Text` widgets'
  style colours and compares them to `AppColorTokens.dark.ink` and
  `AppColorTokens.dark.ink70`. [2.6-AC2], and covers [2.6-AC1]'s two texts.
- `'shows one chevron when a chevron is requested'` —
  `find.byIcon(Icons.chevron_right)` is `findsOneWidget`. [2.6-AC3].
- `'hides the chevron by default'` — same finder, `findsNothing`. [2.6-AC3].
- `'draws no separator of its own'` — `find.byType(Divider)` is `findsNothing`
  with the row pumped alone. [2.6-AC4].

### test/widget/components/hairline_group_test.dart

Shared `buildSubject({required List<Widget> children})`, same wrapper. Children
are plain `Text` widgets throughout, which is what makes the counts evidence for
[2.6-AC12].

- `'shows no separator when given a single child'` — `find.byType(Divider)` is
  `findsNothing`. [2.6-AC8] at N = 1.
- `'shows one separator between two children'` — `findsOneWidget`. [2.6-AC8] at
  N = 2.
- `'shows two separators between three children'` — `findsNWidgets(2)`.
  [2.6-AC8] at N = 3.
- `'shows no card fill when given no children'` — no `ColoredBox` descends from
  the group. [2.6-AC11]; deliberately not a size assertion.
- `'fills the card with the surfaceRaised token'` — the group's single descendant
  `ColoredBox` carries `AppColorTokens.dark.surfaceRaised`. [2.6-AC7]'s fill half.
- `'uses the hairline token for the separator'` — the `Divider`'s `color` is
  `AppColorTokens.dark.hairline`. [2.6-AC10]'s colour half.

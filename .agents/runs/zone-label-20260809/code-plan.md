# Code Plan
Source: Week 2 task brief item 1.1 · `system-foundation-specs.md` §3.2 "Zone label"
Date: 2026-08-09

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

    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 16),
      child: Row(
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
      ),
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

Append one row to the end of the "Existing reusable widgets catalogue" table:

```markdown
| `AddContentDialog` | `add_content_dialog.dart` | Dialog for adding tracker content |
| `ZoneLabel` | `zone_label.dart` | Caps section heading with optional trailing link and zone spacing |
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

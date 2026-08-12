# Code Plan
Source: Week 2 task brief item 1.2 · `system-foundation-specs.md` §3.2/§3.3 · `tech-ac.md`
Date: 2026-08-12

## CREATE NEW

### lib/core/enums/library_status.dart
```dart
enum LibraryStatus { playing, backlog, completed, onHold, wishlist, dropped }
```

### lib/widgets/status_chip.dart
```dart
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_status_tokens.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/glass_surface_widget.dart';

import '../generated/l10n.dart';

enum StatusChipVariant {
  onMedia(dotSize: 6),
  list(dotSize: 7);

  const StatusChipVariant({required this.dotSize});

  final double dotSize;
}

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.status,
    required this.variant,
    this.count,
  });

  final LibraryStatus status;
  final StatusChipVariant variant;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final colors = context.tokens.color;
    final pill = context.tokens.typography.pill;
    final count = this.count;

    final statusToken = switch (status) {
      LibraryStatus.playing => colors.status.playing,
      LibraryStatus.backlog => colors.status.backlog,
      LibraryStatus.completed => colors.status.completed,
      LibraryStatus.onHold => colors.status.onHold,
      LibraryStatus.wishlist => colors.status.wishlist,
      LibraryStatus.dropped => colors.status.dropped,
    };

    final label = switch (status) {
      LibraryStatus.playing => S.current.playing,
      LibraryStatus.backlog => S.current.backlog,
      LibraryStatus.completed => S.current.completed,
      LibraryStatus.onHold => S.current.onHold,
      LibraryStatus.wishlist => S.current.wishlist,
      LibraryStatus.dropped => S.current.dropped,
    };

    final filled = statusToken.treatment == StatusTreatment.filled;

    // The filled pill already carries the status hue, so its dot reverts to
    // ink - reading the token's own colour would hide it against the fill.
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          _StatusDot(
            color: filled ? colors.ink : statusToken.color,
            size: variant.dotSize,
          ),
          Flexible(
            child: Text(
              pill.format(label),
              style: pill.style.copyWith(color: colors.ink),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (count != null)
            Text(
              '$count',
              style: pill.style.copyWith(
                color: filled ? colors.ink : colors.ink55,
              ),
            ),
        ],
      ),
    );

    final borderRadius = BorderRadius.circular(context.tokens.radius.pill);

    if (variant == StatusChipVariant.onMedia && !filled) {
      return GlassSurface(
        fill: colors.glass42,
        borderRadius: borderRadius,
        child: content,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: statusToken.fill,
        borderRadius: borderRadius,
      ),
      child: content,
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
```

Notes for the reviewer:
- `statusToken.fill` is the indigo fill for Playing and the `ink08` token for the other
  five, so the flat branch covers both without a colour literal.
- `_StatusDot` is the only `Container` in the tree — that is what the tests key on.
- No outer padding, no `Expanded`, no fixed width, no gesture wrapper.

## MODIFY EXISTING

### lib/config/theme/tokens/app_color_tokens.dart
```dart
    required this.glass30,
    required this.glass32,
    required this.glass34,
    required this.glass42,
...
  final Color glass30;
  final Color glass32;
  final Color glass34;
  final Color glass42;
...
    glass30: Color.fromRGBO(0, 0, 0, 0.3),
    glass32: Color.fromRGBO(0, 0, 0, 0.32),
    glass34: Color.fromRGBO(0, 0, 0, 0.34),
    glass42: Color.fromRGBO(0, 0, 0, 0.42),
...
    Color? glass42,          // copyWith parameter
      glass42: glass42 ?? this.glass42,
...
      glass42: Color.lerp(a.glass42, b.glass42, t)!,   // lerp
```

### lib/l10n/intl_en.arb
```json
  "completed": "Completed",
  "onHold": "On Hold",
  "backlog": "Backlog",
  "dropped": "Dropped",
```

### lib/l10n/intl_zh.arb
```json
  "completed": "Completed",
  "onHold": "On Hold",
  "backlog": "待玩",
  "dropped": "弃坑",
```
The neighbouring status keys are a mix of translated and untranslated; these two use the
common Chinese gaming terms. One-word swap at the gate if the human prefers otherwise.

### .claude/skills/flutter-widgets/SKILL.md
```markdown
| `StatusChip` | `status_chip.dart` | Six-status pill: dot + label + optional count, list or on-media variant; adds no spacing of its own |
```

### .agents/references/system-foundation-specs.md
```markdown
| `rgba(0,0,0,.42)` | status chip, on-media variant | Glass capsule over cover art; tokenised as `glass42` beside the .30/.32/.34 ramp |
```

## TEST FILES

### test/widget/theme/app_tokens_test.dart
- one line inside the existing `'should expose the welcome surface and glass colours'`
  test — `expect(colors.glass42, const Color.fromRGBO(0, 0, 0, 0.42));`

### test/widget/components/status_chip_test.dart
Helper: `buildSubject({required LibraryStatus status, required StatusChipVariant
variant, int? count})` returning `MaterialApp(theme: buildDarkTheme(), home:
Scaffold(body: ...))`. The dot is `find.byType(Container)` inside the chip; the flat
capsule is the first `DecoratedBox` inside the chip; the blurred capsule is
`find.byType(GlassSurface)`. Values are compared against `AppTokens.dark`.

- `'should render each status dot in its token colour when rendering the six statuses'` — loops the six values; asserts the dot's `BoxDecoration.color` matches the status token, and `ink` (not indigo) for Playing
- `'should fill the capsule with indigo when the status is playing'` — flat `DecoratedBox` colour equals `status.playing.fill`, no `GlassSurface` present, dot is `colors.ink`
- `'should fill the capsule with 8% ink when a tinted status renders in the list variant'` — loops the five tinted statuses; capsule colour equals `colors.ink08`
- `'should render no blur when a tinted status renders in the list variant'` — `find.byType(BackdropFilter)` finds nothing
- `'should fill the capsule with 42% black behind a blur in the on-media variant'` — `GlassSurface.fill` equals `colors.glass42`, and a `BackdropFilter` is present
- `'should render a 6px dot on media and a 7px dot in a list'` — `tester.getSize` on the dot for both variants
- `'should render the pill radius on the capsule in both variants'` — `BorderRadius.circular(AppTokens.dark.radius.pill)` on the flat capsule and on `GlassSurface.borderRadius`
- `'should render the label uppercase in the pill token style when rendering'` — text is found uppercased; `fontSize`, `fontWeight`, `letterSpacing` match `AppTokens.dark.typography.pill.style`; colour is `colors.ink`
- `'should render the count after the label when a count is supplied'` — `find.text('12')` found, styled `ink55` on a tinted status
- `'should render the count when the count is zero'` — `find.text('0')` found, not suppressed
- `'should render full ink on the count when the status is playing'` — count colour is `colors.ink`
- `'should render no count when none is supplied'` — the chip contains exactly one `Text`
- `'should add no spacing around the capsule when rendering'` — the `StatusChip`'s size equals the capsule's size, and no `Padding` ancestor sits between the chip and its capsule

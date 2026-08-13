# Code Plan
Source: Week 2 task brief item 1.4 · `system-foundation-specs.md` §0, §1.9, §3.3 ·
`onboarding-auth-design-spec.md` §3, §5, §9, §10 · `flutter-widgets` skill
Date: 2026-08-13
Revised: 2026-08-13 (Phase 3 human override — dashed outlines removed project-wide)

## CREATE NEW

### lib/widgets/placeholder_slot.dart

```dart
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
    final marker = tokens.typography.zoneLabel;

    return SizedBox.square(
      dimension: size.dimension,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.color.ink12,
          borderRadius: BorderRadius.circular(switch (size) {
            // 20 is not in the radius scale; it is a local addition per §6.
            PlaceholderSlotSize.appMark => 20,
            PlaceholderSlotSize.providerMark => tokens.radius.xs,
          }),
          border: Border.all(color: tokens.color.ink24),
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
    );
  }
}
```

That is the whole file. A uniform `Border.all` on the same decoration as the
`borderRadius` is drawn by the framework as one continuous rounded stroke inside the box —
nothing else is needed for [1.4-AC7]. `width` is deliberately not passed: `Border.all`
already defaults to 1.0, and `avoid_redundant_argument_values` is enabled in
`analysis_options.yaml`, so spelling it out would add a new analyzer info beyond the
recorded baseline. The border is 1px either way, and the test asserts 1px.

The `_DashedOutline` `CustomPainter` this plan carried before the revision is **deleted,
not rewritten**: no painter, no `Path`, no `PathMetrics`, no `dart:math` import, no dash or
gap constant ([1.4-AC8]).

## MODIFY EXISTING

### lib/widgets/logo_placeholder.dart

Removed by the rename in step 1. Nothing remains at this path — no class, no `@Deprecated`
alias, no re-export.

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

**§3 anatomy line** ([1.4-AC15a]) — currently `1px dashed rgba(255,255,255,.24)`:

```markdown
- Fill `var(--color-ink-12)`, `1px solid rgba(255,255,255,.24)`
```

**§3 paragraph beneath it** ([1.4-AC15a]) — the current text argues that *dashedness*
signals pending art. Replacement keeps the section's real point and drops the dangling
reason:

```markdown
**This is a reserved slot, not a design.** The design system states no logo or wordmark
exists; the box is deliberately empty, and that emptiness is the signal that real art must
be dropped in. When a real mark ships, replace the span with the SVG at the same 88px box
and drop the placeholder fill and border with it. The word `QuestLoggd` in Space Grotesk
700 remains the sanctioned text stand-in elsewhere in the app, but this screen shows the
mark alone — the app name is already established by the two screens before it.
```

**§5 anatomy line** ([1.4-AC15b]) — the rgba values stay exactly as they are, per
`tech-ac.md ## Out of scope`; only the stroke style changes:

```markdown
- Fill `rgba(255,255,255,.18)`, `1px solid rgba(255,255,255,.32)`
```

**§5 rationale paragraph** ([1.4-AC15b]) — the rejection of a generic glyph now rests on
the slot being empty:

```markdown
Same reserved-slot logic as the header. Official provider marks are third-party trademarks —
they are **not** drawn or approximated in this system. Drop the licensed SVGs into these
boxes at 20px; nothing else changes. Until then the slot stays empty, which is honest, and
is why a generic outline icon (globe, screen, etc.) is explicitly rejected: a wrong glyph
reads as a bug, an empty slot reads as pending.
```

**§9 replacement checklist, first bullet** ([1.4-AC15c]):

```markdown
- [ ] `88px` app mark — use the global `PlaceholderSlot` at its app-mark preset until the
      final app mark is supplied.
```

**§10 Flutter composition, the `LogoPlaceholder` bullet** ([1.4-AC15c]):

```markdown
- `PlaceholderSlot` is a global reusable widget under `lib/widgets/`. It takes one of two
  fixed presets — app mark (`88`, radius 20) and provider mark (`20`, `--radius-xs`) — and
  draws a `--color-ink-12` fill with a solid 1px `rgba(255,255,255,.24)` border. It has no
  width or height input and adds no spacing of its own.
```

### .agents/references/system-foundation-specs.md

**§0 Principles — new entry, appended as item 6** ([1.4-AC18]). Appended rather than
inserted so entries 1–5 keep their numbers; it sits beside principle 4 (which says *when*
lines are used) without contradicting it, because this one says *how* they are stroked:

```markdown
6. **Outlines are always solid.** Every border, outline and hairline in the system is a
   continuous stroke. Dashed and dotted strokes are not used anywhere in the app — including
   reserved placeholder boxes, which read as pending because they are empty, not because
   their edge is broken.
```

**§1.9 Iconography** ([1.4-AC15e]) — loses the word `dashed`; §3.3 owns the anatomy, so
this line does not restate a stroke style at all:

```markdown
Platform marks are text abbreviations — `PS5`, `XSX`, `PC`, `NSW`. Third-party brand marks
(platforms, auth providers) are **never drawn or approximated**: reserve a placeholder box
at the final size and drop licensed art in.
```

**§3.3 App-scale primitives — the "Placeholder slot" row** ([1.4-AC15d]). This is the
source-of-truth line the widget is built against:

```markdown
| **Placeholder slot** | Reserved empty box: `--color-ink-12` fill, `1px solid rgba(255,255,255,.24)`, display 700 caps label | app mark `88` r20 · provider mark `20` r`xs` |
```

### .claude/skills/flutter-widgets/SKILL.md

**New bullet under "Building a new reusable widget"**, directly after the "No spacing of
its own" bullet. Same shape as that one — a short standing rule with a pointer to the full
statement, so a widget built without reading the spec doc still hits it:

```markdown
- **Outlines are always solid.** Borders, outlines and hairlines are continuous strokes.
  No dashed or dotted edge anywhere, and nothing custom-painted to draw one — a `Border` in
  a `BoxDecoration` covers every case in this system. That includes reserved placeholder
  boxes: an empty slot reads as pending because it is empty, not because its edge is
  broken. Full rule: `system-foundation-specs.md` §0.
```

**New catalogue row**, directly after the `StatusChip` row:

```markdown
| `PlaceholderSlot` | `placeholder_slot.dart` | Reserved empty box signalling art is still owed: ink-12 fill, solid 1px ink-24 border, two presets (app mark 88 r20 with a `LOGO` marker, provider mark 20 r-xs, no label); adds no spacing of its own |
```

## TEST FILES

### test/widget/components/placeholder_slot_test.dart

- `'should render an 88 box at the app mark preset and a 20 box at the provider mark preset'` — `tester.getSize(find.byType(PlaceholderSlot))` equals `Size(88, 88)` then `Size(20, 20)`.
- `'should round the app mark to 20 and the provider mark to the xs radius'` — the `BoxDecoration.borderRadius` on the slot's `DecoratedBox` equals `BorderRadius.circular(20)`, then `BorderRadius.circular(radius.xs)`.
- `'should fill both presets with ink12'` — `BoxDecoration.color` equals `colors.ink12` at each preset.
- `'should draw a solid 1px ink24 border at both presets'` — the `BoxDecoration.border` on the slot's `DecoratedBox` is a uniform `Border` whose every side has `color` `colors.ink24`, `width` `1`, and `style` `BorderStyle.solid`, at both presets.
- `'should not custom-paint its outline'` — `find.descendant(of: find.byType(PlaceholderSlot), matching: find.byType(CustomPaint))` finds nothing, at both presets. Guards [1.4-AC8] against a painter creeping back in.
- `'should render the LOGO marker in the display face at 700 only at the app mark preset'` — at `appMark`, `find.text('LOGO')` finds one widget whose style has `fontWeight` `w700`, `fontSize` 14, `letterSpacing` 2.24, `color` `colors.ink55`, and the same `fontFamily` as `typography.zoneLabel.style`; at `providerMark`, `find.byType(Text)` finds nothing.
- `'should hold its box inside a fixed-size parent and inside an unbounded parent'` — the app mark preset measures `Size(88, 88)` both inside a 200×200 `SizedBox` with a `Center` and inside a horizontally unbounded parent, with no overflow exception recorded.
- `'should add no spacing of its own'` — no `Padding` ancestor between the slot and its parent, and the measured size equals the preset dimension exactly at both presets.

Two tests from the pre-revision plan are **removed, not adapted**: the dashed-outline
`paints..path(...)` assertion (replaced by the solid-border test above) and the
"several dashes per side" `PaintPattern` loop (nothing left to count). No
`matchesGoldenFile` and no golden files anywhere in this file.

## Approved feedback delta

- 2026-08-13 — Dashed outline reversed to solid project-wide (human decision at Phase 3).
  `tdd.md`, `task-brief.md` and this file were corrected **in place** rather than only
  appended to, per `handover.md`'s substantial-revision rule; there is no stale earlier
  version to reconcile against, so nothing in this section overrides the plan above.
- Private `_DashedOutline extends CustomPainter` deleted from the design entirely — the
  outline is `Border.all` inside the existing `BoxDecoration` ([1.4-AC7], [1.4-AC8]).
- Doc-correction scope widened from 2 files to 3: `system-foundation-specs.md` added to
  the allowlist for §3.3's row, §1.9's iconography line, and the new §0 principle
  ([1.4-AC15d], [1.4-AC15e], [1.4-AC18]).
- `onboarding-auth-design-spec.md` §3 and §5 added to the correction list — both their
  anatomy lines and both their rationale paragraphs, not just §9/§10's API wording
  ([1.4-AC15a], [1.4-AC15b]).
- `flutter-widgets` SKILL.md gains a second edit beyond the catalogue row: an "Outlines are
  always solid" convention bullet, reinforcing the §0 principle for anyone building a
  widget without reading the spec doc. Human instruction at this revision round; the
  primary location of the standing rule remains `system-foundation-specs.md` §0 per
  [1.4-AC18].
- Test list: dash-geometry assertions removed, solid-border assertion added, plus a new
  "no `CustomPaint` in the subtree" guard ([1.4-AC16]).

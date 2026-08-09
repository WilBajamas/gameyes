# Technical Design Document
Source: Week 2 task brief item 1.1 · `system-foundation-specs.md` §3.2 "Zone label"
Date: 2026-08-09

## Feature summary

One new global presentation widget in `lib/widgets/`, composed of plain Flutter
widgets, that renders a section heading through the existing `zoneLabel` type
token and an optional trailing link through the existing `zoneLink` token, plus
the vertical space that separates zones. No layer below the UI is touched: no
model, repository, use case, state object, route, DI registration, localisation
key or design token is added or changed. The widget is stateless, reads theme
through `context.tokens`, and ships unwired — no existing screen consumes it in
this run.

## Layer map

1.1-AC1: UI
1.1-AC2: UI
1.1-AC3: UI (reads existing theme extension)
1.1-AC4: UI
1.1-AC5: UI
1.1-AC6: UI
1.1-AC7: UI
1.1-AC8: UI
1.1-AC9: UI
1.1-AC10: UI
1.1-AC11: Test (widget)
1.1-AC12: Docs

## Data layer

None. No API contract, model, DTO, repository or datasource is involved.

## Domain layer

None. No use case or entity.

## State layer

None. The widget holds no state and consumes no Cubit/BLoC. Text and the tap
callback arrive as constructor parameters; the caller owns both.

## UI layer

### Screens

None created or modified.

### Widgets

`ZoneLabel` (create) — `lib/widgets/zone_label.dart` — StatelessWidget,
`const` constructor.
- Consumes: `label` (String, required), `linkLabel` (String?, optional),
  `onLinkPressed` (VoidCallback?, optional); theme via `context.tokens`.
- Structure: outer `Padding` (top 40, bottom 16, no horizontal) → `Row` →
  `Expanded(Text)` for the label, followed by the link only when both
  `linkLabel` and `onLinkPressed` are non-null, added through a collection
  `if` so nothing occupies the trailing position otherwise (1.1-AC5).
- Label text: `tokens.typography.zoneLabel.format(label)` for the casing,
  `tokens.typography.zoneLabel.style` for the style, `maxLines: 1`,
  `overflow: TextOverflow.ellipsis`. No literal size, weight, colour or
  letter-spacing anywhere in the file (1.1-AC3, 1.1-AC10).
- Interactions: none of its own; the link forwards taps to `onLinkPressed`.
- Renders no `Divider`, `Border`, `BoxDecoration`, shadow or ordinal in any
  configuration (1.1-AC7).

`_ZoneLink` (create) — private class in the same file — StatelessWidget.
- Consumes: `label` (String), `onPressed` (VoidCallback); theme via
  `context.tokens`.
- Structure: `GestureDetector(behavior: HitTestBehavior.opaque)` →
  `ConstrainedBox(minHeight: 44)` → `Center` → `Text` styled from
  `tokens.typography.zoneLink.style`. The 44px floor is height only, so the
  rendered text size is unchanged (1.1-AC6), and the link adds no horizontal
  padding so it stays flush with the parent's trailing edge (1.1-AC9).
- Sized by its intrinsic width inside the `Row`, so `Expanded` gives the label
  whatever is left — the link never wraps, truncates or overlaps (1.1-AC10).
- Private and file-local per the one-file-per-widget-family rule; it gets its
  own file only when a second caller appears.

Vertical-height note: with a link the row is 44 tall (the hit-target floor),
without one it is the label's line height. That is a direct consequence of
1.1-AC6 plus 1.1-AC8 and is intended, not a defect.

## Reuse decisions

`AppTypeTokens.zoneLabel` / `.zoneLink` at
`lib/config/theme/tokens/app_type_tokens.dart` — reused as-is, including
`AppTextToken.format()` for the uppercase behaviour. No token is added,
duplicated or re-declared (1.1-AC3, tech-ac "Out of scope").

`ContextExtensions.tokens` at `lib/core/utils/extensions.dart` — the project's
sanctioned theme accessor; `Theme.of(context)` is never called directly.

`ButtonPressScale` at `lib/widgets/button_press_scale.dart` — **rejected**,
deliberately. It is the project's standard tap wrapper, but it draws a 2px
green border and 2px padding while focused and applies a 0.97 press scale.
1.1-AC7 forbids a border in any configuration, and §1.8 hover/focus/press
treatments for this link are explicitly out of scope in `tech-ac.md`. A plain
`GestureDetector` is the minimum that satisfies 1.1-AC4 and 1.1-AC6.

`HorizontalSeparator` at `lib/widgets/horizontal_separator.dart` — **not
used**, and named here so nobody adds it later: §3.2 states the label plus the
gap *is* the separation, no rule (1.1-AC7).

No existing widget in `lib/widgets/` covers a caps section heading with an
optional trailing link, so this is a new entry rather than an adjustment of an
existing one.

## Out of scope

- Rewiring any screen, including the 18px bold section headings under
  `lib/features/featured/presentation/widgets/` — items 2.3 and 2.8 own those,
  and nothing is deprecated or deleted here.
- New design tokens of any kind, and any spacing-token abstraction: the project
  has no `AppSpacingTokens` today and this run does not introduce one. The 40 /
  16 / 44 values are inline literals in the widget, matching how
  `primary_button.dart` and `welcome_skip_text.dart` already write their 44px
  floor.
- New localisation keys. The widget holds no string, so no `.arb` edit and no
  Flutter Intl regeneration is needed (1.1-AC2).
- Code generation. Nothing annotated is created and the widget test mocks
  nothing, so there is no `build_runner` checkpoint in the plan.
- Screen-reader header semantics, hover/focus treatments, a suppressed-gap
  first-zone variant, a second link, icon/count/leading slots, iOS verification
  — all excluded by `tech-ac.md`.
- Golden tests, per `execution.md` and `testing-conventions.md`.

## Open questions

None.

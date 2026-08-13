# Technical Design Document
Source: Week 2 task brief item 1.4 · `system-foundation-specs.md` §0, §1.9, §3.3 ·
`onboarding-auth-design-spec.md` §3, §5, §9, §10 · `flutter-widgets` skill
Date: 2026-08-13
Revised: 2026-08-13 (Phase 3 human override — dashed outlines removed project-wide)

## Revision note — 2026-08-13

Corrected in place, not appended as a delta, per `handover.md`'s "a substantial Phase 3
revision may correct `tdd.md`/`task-brief.md` in place". Tracks `tech-ac.md`'s revision
note of the same date.

What changed in this design:

- **The dashed border is gone, and with it the whole painting approach.** The private
  `_DashedOutline extends CustomPainter` is deleted from the design. The outline is now a
  plain `Border.all(color: ink24, width: 1)` inside the `BoxDecoration` the widget already
  builds — no `CustomPaint`, no `Path`, no `PathMetrics`, no `dart:math` ([1.4-AC7],
  [1.4-AC8]).
- **Doc corrections went from two passages in one file to three files.**
  `system-foundation-specs.md` is newly in the allowlist ([1.4-AC15d], [1.4-AC15e],
  [1.4-AC18]).
- **A new standing principle** is added to `system-foundation-specs.md` §0 ([1.4-AC18]),
  and reinforced as a one-bullet convention in the `flutter-widgets` skill.
- **Two tests are dropped and one is flipped** — the dash-count test disappears entirely
  and the outline test now asserts a plain solid `Border` ([1.4-AC16]).

Unchanged: two-preset sizing, `ink12` fill, radii, the label treatment, the caller
migration, and the provider mark shipping unwired.

## Feature summary

Presentation-only rework of one global widget. `lib/widgets/logo_placeholder.dart` is
renamed to `lib/widgets/placeholder_slot.dart` and its free `width`/`height` API is
replaced by a closed two-value preset enum, matching the `CoverTileSize` pattern already in
`lib/widgets/cover_tile.dart`. The existing solid `Border.all` **stays** — the human's
Phase 3 decision makes solid the correct treatment, so the border needs no work beyond
pinning its colour to `ink24` and its width to 1. The marker label moves from the body-face
`microLabel` token to the display-face `zoneLabel` token resized to the spec's 14px /
`+.16em`. The single caller (the auth screen header) is migrated in the same run, the old
file does not survive, and three reference/skill documents are corrected so no doc still
specifies or justifies a dashed border. No domain, data, or state layer is touched.

## Layer map

1.4-AC1: UI (file lifecycle)
1.4-AC2: UI
1.4-AC3: UI
1.4-AC4: UI
1.4-AC5: UI (radius tokens, read-only)
1.4-AC6: UI (colour tokens, read-only)
1.4-AC7: UI (decoration — solid border)
1.4-AC8: UI (decoration — no custom painting, no dash inputs)
1.4-AC9: UI (type tokens, read-only)
1.4-AC10: UI (layout)
1.4-AC11: UI (layout)
1.4-AC12: UI (auth screen call site)
1.4-AC13: UI (no change — provider rows untouched)
1.4-AC14: UI
1.4-AC15: docs (2 reference docs + skill catalogue)
1.4-AC16: tests (widget)
1.4-AC17: build (no dependency change)
1.4-AC18: docs (standing principle, `system-foundation-specs.md` §0)

## Data layer

None. No API, model, or repository work.

## Domain layer

None.

## State layer

None. The slot is display-only with no interaction ([1.4-AC14]), so it consumes no
Cubit/BLoC and introduces no reactive boundary. The auth screen's existing `BlocBuilder`
boundary is unchanged.

## UI layer

### Screens

`AuthScreen` (modify) — `lib/features/auth/presentation/screens/auth_screen.dart` —
stateless — consumes `SignInCubit` (unchanged) — the only change is inside `_AuthContent`'s
column: the header `Center` child swaps from `LogoPlaceholder(width: 88, height: 88)` to
the new widget's app-mark preset, plus the matching import swap. Column order, the
`SizedBox(height: 32)` below it, and the `BlocBuilder` boundary are untouched ([1.4-AC12]).
The two provider rows in `provider_action_button.dart` are not opened at all ([1.4-AC13]).

### Widgets

`PlaceholderSlot` (create, by renaming `logo_placeholder.dart`) —
`lib/widgets/placeholder_slot.dart` — stateless, `const` constructor — consumes
`context.tokens` (colour `ink12`/`ink24`, radius `xs`, typography `zoneLabel`) — no
interactions. One required input, `size`, of type `PlaceholderSlotSize`; no dimension,
padding, or spacing parameter ([1.4-AC3], [1.4-AC11]). Composition is three widgets deep:
`SizedBox.square` → `DecoratedBox` → `Center` + `Text` at the app-mark preset only, `null`
child at the provider-mark preset ([1.4-AC9]).

The single `BoxDecoration` carries all three visual properties at once — the `ink12` fill,
the resolved `BorderRadius`, and `Border.all(color: ink24, width: 1)`. A uniform
`Border.all` with a `borderRadius` is drawn by the framework as one continuous rounded
stroke inside the box's bounds, which is exactly and entirely what [1.4-AC7] asks for.
`DecoratedBox` (not `Container`) keeps the border from insetting the child, and the outer
`SizedBox.square` fixes the box at the preset dimension either way ([1.4-AC4],
[1.4-AC10]).

There is no private helper class in this file any more. The `_DashedOutline` painter this
design previously specified is deleted, not simplified: [1.4-AC8] forbids a
`CustomPainter`, a path-dashing helper, and any dash/gap constant or parameter, and nothing
about a solid rounded border needs painting code.

`PlaceholderSlotSize` (create) — same file — enum, two values: `appMark` (dimension 88) and
`providerMark` (dimension 20), each carrying its own dimension the way `CoverTileSize` does,
plus an `isAppMark` getter for the one place that branches. Radius is resolved in `build`
rather than on the enum, because the provider mark's radius is a theme token and only the
app mark's 20 is a literal ([1.4-AC5]).

## Docs layer

Three files are corrected in the same run ([1.4-AC15]), and one of them also gains a
standing rule ([1.4-AC18]). All three are already-tracked project documentation; none is
Dart source.

- `.agents/references/onboarding-auth-design-spec.md` — §3's anatomy line and the paragraph
  under it, §5's anatomy line and its rationale paragraph, §9's checklist bullet, §10's
  composition bullet. The two anatomy lines change `dashed` to `solid` and keep their
  rgba values; the two paragraphs are rewritten so their argument rests on the slot being
  *empty*, which is the point each was actually making, rather than on its edge being
  broken.
- `.agents/references/system-foundation-specs.md` — §0 gains principle 6 (outlines are
  always solid), §1.9's iconography sentence loses the word `dashed`, and §3.3's
  "Placeholder slot" row becomes a solid 1px border at the same colour. §0 is appended to
  as item 6 rather than inserted mid-list: `tech-ac.md` and other docs cite §0 entries by
  number, so renumbering 1–5 would break live references.
- `.claude/skills/flutter-widgets/SKILL.md` — one catalogue row for the widget, plus one
  convention bullet under "Building a new reusable widget" carrying the same no-dashed rule.
  The skill entry is a pointer, not a second source of truth: `system-foundation-specs.md`
  §0 is where [1.4-AC18] places the rule, and the skill exists so someone building a widget
  without reading the full spec still hits it. Same shape as "No spacing of its own", added
  in item 1.1.

## Reuse decisions

- `CoverTileSize` pattern at `lib/widgets/cover_tile.dart` — the project's established way
  to express "a closed set of sizes chosen by one constructor input". Mirrored rather than
  invented.
- **`Border.all` inside the existing `BoxDecoration`** — the framework's ordinary border
  decoration draws the whole outline ([1.4-AC8]). This is not new code: the widget being
  reworked already draws a solid border this way, so the border is the one part of the old
  widget that survives the rework nearly untouched. Nothing is written, painted, or
  imported for it.
- `AppColorTokens.ink12`/`ink24` and `AppRadiusTokens.xs` at `lib/config/theme/tokens/` —
  already exist and already carry the spec's values; read through `context.tokens`, nothing
  declared or duplicated.
- `AppTypeTokens.zoneLabel` — the only display-face 700 caps token at `ink55` (Space Grotesk
  12/700, `+.18em`, `ink55`). Reused with `copyWith` for the marker's size and tracking so
  the widget declares no font family, weight, or colour of its own ([1.4-AC9]). No new type
  token is added.
- `test/widget/components/cover_tile_test.dart` — the pumping and font warm-up shape for a
  global widget test; the new test file follows it.

## Design notes

Four readings the Dev Agent should not re-litigate:

1. **No painter, and no partial retreat to one.** [1.4-AC8] rules out a `CustomPainter`, a
   `CustomPaint`, a path-dashing helper, and any `dashWidth`/`gap` constant or parameter.
   If the border ever looks wrong, the fix is in the `BoxDecoration` — a painter is not an
   option to fall back on, and neither is a package ([1.4-AC17]).
2. **Marker metrics vs [1.4-AC14]'s literal list.** [1.4-AC9] requires 14px and `+.16em`;
   [1.4-AC14] enumerates allowed literals and does not mention them. Resolved in favour of
   [1.4-AC9]: the two numbers reach the widget as a `copyWith` on the `zoneLabel` token
   (`fontSize: 14`, `letterSpacing: 2.24`), with family, weight, and colour still coming
   from the token. [1.4-AC14]'s intent — no hardcoded colour, no `Theme.of`, no font
   literal — holds. Adding a new type token was rejected: `tech-ac.md`'s summary bars new
   tokens.
3. **"Ignores its parent's constraints" ([1.4-AC10]).** No Flutter widget can render
   smaller than tight incoming constraints, so this is implemented as self-sizing under the
   loose and unbounded constraints [1.4-AC10] actually enumerates (`Row`, `Center`,
   `Column`, unbounded) via `SizedBox.square`. The [1.4-AC16] "tight parent" case is tested
   as a fixed-size 200×200 parent that hands the slot loose constraints — the way every
   real caller places it — not as a conflicting tight box.
4. **The unwired provider preset stays.** [1.4-AC3]/[1.4-AC4]/[1.4-AC5] define the item as
   the spec's two presets, and the preset costs one enum value and one switch arm. Dropping
   it would leave a categorically named widget that supports one preset, needing a rebuild
   the moment provider art or the parked Apple row lands. Kept.

## Out of scope

- Real art for either preset, and the two provider rows' licensed PNGs — the empty box is
  the deliberate "art still owed" signal (`tech-ac.md ## Out of scope`).
- The `rgba(255,255,255,.18)`/`.32` values in `onboarding-auth-design-spec.md` §5 and §8,
  and any `ink18`/`ink32` token to carry them. §5's border line is opened in this run, but
  only its `dashed` → `solid` word changes; the values are superseded by §3.3's single
  anatomy and are left as written, per `tech-ac.md ## Out of scope`.
- A repo-wide sweep for dashed or dotted strokes drawn elsewhere in code. [1.4-AC18] sets
  the standing rule and [1.4-AC15] fixes every doc that stated one; nothing outside this
  widget is known to draw one.
- Any new colour, radius, or type token, any localisation key, any package.
- Interaction, hover/focus/press states, and screen-reader semantics.
- Every screen other than the auth screen header.

## Open questions

NONE

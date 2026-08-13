# Technical Design Document
Source: Week 2 task brief item 1.4 · `system-foundation-specs.md` §3.3 · `onboarding-auth-design-spec.md` §3, §9, §10 · `flutter-widgets` skill
Date: 2026-08-13

## Feature summary

Presentation-only rework of one global widget. `lib/widgets/logo_placeholder.dart`
is renamed to `lib/widgets/placeholder_slot.dart` and its free `width`/`height`
API is replaced by a closed two-value preset enum, matching the `CoverTileSize`
pattern already in `lib/widgets/cover_tile.dart`. The solid `Border.all` is
replaced by a private `CustomPainter` that walks the rounded outline's path
metrics and stamps dashes along it — the only way to draw a dashed rounded
border with the Flutter SDK alone, and no package is added. The marker label
moves from the body-face `microLabel` token to the display-face `zoneLabel`
token resized to the spec's 14px / `+.16em`. The single caller (the auth screen
header) is migrated in the same run, the old file does not survive, and two
stale reference-doc passages plus the widget catalogue are corrected. No domain,
data, or state layer is touched.

## Layer map

1.4-AC1: UI (file lifecycle)
1.4-AC2: UI
1.4-AC3: UI
1.4-AC4: UI
1.4-AC5: UI (radius tokens, read-only)
1.4-AC6: UI (colour tokens, read-only)
1.4-AC7: UI (custom painting)
1.4-AC8: UI (custom painting)
1.4-AC9: UI (type tokens, read-only)
1.4-AC10: UI (layout)
1.4-AC11: UI (layout)
1.4-AC12: UI (auth screen call site)
1.4-AC13: UI (no change — provider rows untouched)
1.4-AC14: UI
1.4-AC15: docs (references + skill catalogue)
1.4-AC16: tests (widget)
1.4-AC17: build (no dependency change)

## Data layer

None. No API, model, or repository work.

## Domain layer

None.

## State layer

None. The slot is display-only with no interaction ([1.4-AC14]), so it consumes
no Cubit/BLoC and introduces no reactive boundary. The auth screen's existing
`BlocBuilder` boundary is unchanged.

## UI layer

### Screens

`AuthScreen` (modify) — `lib/features/auth/presentation/screens/auth_screen.dart`
— stateless — consumes `SignInCubit` (unchanged) — the only change is inside
`_AuthContent`'s column: the header `Center` child swaps from
`LogoPlaceholder(width: 88, height: 88)` to the new widget's app-mark preset,
plus the matching import swap. Column order, the `SizedBox(height: 32)` below it,
and the `BlocBuilder` boundary are untouched ([1.4-AC12]). The two provider rows
in `provider_action_button.dart` are not opened at all ([1.4-AC13]).

### Widgets

`PlaceholderSlot` (create, by renaming `logo_placeholder.dart`) —
`lib/widgets/placeholder_slot.dart` — stateless, `const` constructor — consumes
`context.tokens` (colour `ink12`/`ink24`, radius `xs`, typography `zoneLabel`) —
no interactions. One required input, `size`, of type `PlaceholderSlotSize`; no
dimension, padding, or spacing parameter ([1.4-AC3], [1.4-AC11]). Composition:
`SizedBox.square` → `DecoratedBox` (fill + radius) → `CustomPaint` (dashed
outline) → `Center` + `Text` at the app-mark preset only, `null` child at the
provider-mark preset ([1.4-AC9]).

`PlaceholderSlotSize` (create) — same file — enum, two values: `appMark`
(dimension 88) and `providerMark` (dimension 20), each carrying its own
dimension the way `CoverTileSize` does, plus an `isAppMark` getter for the two
places that branch. Radius is resolved in `build` rather than on the enum,
because the provider mark's radius is a theme token and only the app mark's 20 is
a literal ([1.4-AC5]).

`_DashedOutline` (create) — same file, private — `CustomPainter` — takes the
outline colour and the resolved `BorderRadius`. Builds one `Path` from the
`RRect`, deflated by half the stroke so no dash paints outside the widget's box,
then walks `Path.computeMetrics()` extracting alternating dash/gap segments. One
continuous path means dashes carry through the corners with no seam and no
corner gap ([1.4-AC7]). One dash/gap pattern (2px on, 2px off, 1px stroke)
serves both presets: at the 20px preset that is roughly 17 dashes around a ~70px
outline (≈4 per side), so it reads as dashed rather than broken-solid
([1.4-AC8]).

## Reuse decisions

- `CoverTileSize` pattern at `lib/widgets/cover_tile.dart` — the project's
  established way to express "a closed set of sizes chosen by one constructor
  input". Mirrored rather than invented.
- `AppColorTokens.ink12`/`ink24` and `AppRadiusTokens.xs` at
  `lib/config/theme/tokens/` — already exist and already carry the spec's
  values; read through `context.tokens`, nothing declared or duplicated.
- `AppTypeTokens.zoneLabel` — the only display-face 700 caps token at `ink55`
  (Space Grotesk 12/700, `+.18em`, `ink55`). Reused with `copyWith` for the
  marker's size and tracking so the widget declares no font family, weight, or
  colour of its own ([1.4-AC9]). No new type token is added.
- `test/widget/components/cover_tile_test.dart` — the pumping and font warm-up
  shape for a global widget test; the new test file follows it.
- Nothing reusable exists for a dashed border: `Border`, `BoxDecoration`, and
  `ShapeDecoration` all draw solid only, and the repo carries no dash utility.
  Hence the painter.

## Design notes

Three readings the Dev Agent should not re-litigate:

1. **Marker metrics vs [1.4-AC14]'s literal list.** [1.4-AC9] requires 14px and
   `+.16em`; [1.4-AC14] enumerates allowed literals and does not mention them.
   Resolved in favour of [1.4-AC9]: the two numbers reach the widget as a
   `copyWith` on the `zoneLabel` token (`fontSize: 14`, `letterSpacing: 2.24`),
   with family, weight, and colour still coming from the token.
   [1.4-AC14]'s intent — no hardcoded colour, no `Theme.of`, no font literal —
   holds. Adding a new type token was rejected: `tech-ac.md`'s summary bars new
   tokens.
2. **"Ignores its parent's constraints" ([1.4-AC10]).** No Flutter widget can
   render smaller than tight incoming constraints, so this is implemented as
   self-sizing under the loose and unbounded constraints [1.4-AC10] actually
   enumerates (`Row`, `Center`, `Column`, unbounded) via `SizedBox.square`. The
   [1.4-AC16] "tight parent" case is tested as a fixed-size 200×200 parent that
   hands the slot loose constraints — the way every real caller places it —
   not as a conflicting tight box.
3. **The unwired provider preset stays.** [1.4-AC3]/[1.4-AC4]/[1.4-AC5] define
   the item as the spec's two presets, and the preset costs one enum value and
   one switch arm. Dropping it would leave a categorically named widget that
   supports one preset, needing a rebuild the moment provider art or the parked
   Apple row lands. Kept.

## Out of scope

- Real art for either preset, and the two provider rows' licensed PNGs — the
  dashed box is the deliberate "art still owed" signal (`tech-ac.md ## Out of
  scope`).
- `onboarding-auth-design-spec.md` §5/§8's `rgba(255,255,255,.18)`/`.32`
  provider-slot values. Superseded by §3.3's single anatomy, but [1.4-AC15]
  names only §9 and §10 for correction, so §5 and §8 are left as written.
- Any new colour, radius, or type token, any localisation key, any package.
- Interaction, hover/focus/press states, and screen-reader semantics.
- Every screen other than the auth screen header.

## Open questions

NONE

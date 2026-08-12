# Technical Design Document
Source: Week 2 task brief item 1.2 · `system-foundation-specs.md` §3.2/§3.3 · `tech-ac.md` (21 ACs, no criticals)
Date: 2026-08-12

## Feature summary

A presentation-only primitive. One new `StatelessWidget` in `lib/widgets/` renders the
six-status pill (dot + label + optional count) in two variants, reading every colour,
radius and text style from the existing `AppTokens` theme extension via
`context.tokens`. Supporting work is a closed enum in `lib/core/enums/`, two `.arb`
keys, one new colour token for the on-media capsule fill, and reuse of the existing
`GlassSurface` widget for the blur. No data, domain or state layer is touched, no
screen is rewired, and no package is added.

## Layer map

[1.2-AC1] [1.2-AC3] [1.2-AC5] [1.2-AC12] [1.2-AC14] [1.2-AC16] [1.2-AC17] [1.2-AC18]: UI
[1.2-AC2]: UI (closed enum, `lib/core/enums/`)
[1.2-AC4] [1.2-AC7] [1.2-AC8] [1.2-AC9] [1.2-AC13] [1.2-AC19]: UI + theme tokens (read-only)
[1.2-AC6]: UI + theme tokens (one token added — see Design decisions)
[1.2-AC10] [1.2-AC11]: UI + localisation
[1.2-AC15]: UI (standing "no spacing of its own" convention)
[1.2-AC20]: tests
[1.2-AC21]: docs

## Data layer

### API contracts
None — no criterion touches the network.

### Models
None. `LibraryStatus` (create) — `lib/core/enums/library_status.dart` — bare enum,
values `playing, backlog, completed, onHold, wishlist, dropped`. No fields, no
methods, no imports, so the week-3 library/tracker domain model can adopt it without
depending on presentation. This is the closed set [1.2-AC2] requires.

`AppColorTokens` (modify) — `lib/config/theme/tokens/app_color_tokens.dart` — one new
field `glass42`, `Color.fromRGBO(0, 0, 0, 0.42)`, alongside the existing
`glass30/glass32/glass34` ramp; constructor parameter, `dark` value, `copyWith` and
`lerp` updated in the same pass.

### Repositories
None.

## Domain layer

None — no use case, no `Result<T>`, no repository call.

## State layer

None. The chip takes its status, variant and count as constructor parameters; there is
no reactive boundary and no Cubit/BLoC in this run. Callers own their own state.

## UI layer

### Screens
None — the component ships unplaced ([tech-ac.md ## Out of scope]).

### Widgets
`StatusChip` (create) — `lib/widgets/status_chip.dart` — `StatelessWidget`, `const`
constructor — consumes `LibraryStatus status` (required), `StatusChipVariant variant`
(required), `int? count` — no interactions, no callbacks, no gesture wrapper
([1.2-AC17]). Reads `context.tokens.color.status.*`, `context.tokens.color.ink/ink55`,
`context.tokens.radius.pill` and `context.tokens.typography.pill` ([1.2-AC19]).
Composition: capsule → interior `Padding` → `Row(mainAxisSize: min, spacing: 6)` of
dot, `Flexible` label, optional count ([1.2-AC3], [1.2-AC16], [1.2-AC18]).

`StatusChipVariant` (create) — same file — enum `onMedia(dotSize: 6)` /
`list(dotSize: 7)`. The only per-variant number lives on the enum, so the widget body
holds no size branch ([1.2-AC5]).

`_StatusDot` (create) — same file, private — fixed-diameter circle
([1.2-AC1] "private helper in the same file", [1.2-AC18] "never deforms").

Capsule fill resolution, one expression:
- filled treatment (Playing only) → `statusToken.fill` (indigo) in **both** variants,
  no blur ([1.2-AC7]); a blur behind an opaque fill would be invisible cost.
- tinted + list → `statusToken.fill`, which is already the `ink08` token, flat.
- tinted + on-media → `colors.glass42` inside `GlassSurface` ([1.2-AC6]).

Dot colour: `filled ? colors.ink : statusToken.color`. This is the bug trap BA flagged
— `app_status_tokens.dart` gives `playing` an indigo `color` on an indigo `fill`, so
reading `color` straight through renders an invisible dot. Carries the one comment in
the file that isn't obvious from the code.

Label: `pill.format(label)` for uppercase, `pill.style.copyWith(color: colors.ink)`
([1.2-AC9]). Count: same style, `filled ? colors.ink : colors.ink55` ([1.2-AC13]).

## Reuse decisions

`GlassSurface` at `lib/widgets/glass_surface_widget.dart` — already
`ClipRRect > BackdropFilter(ImageFilter.blur(tokens.effect.glassBlur)) > ColoredBox`.
It is exactly [1.2-AC6]'s "blur clipped to the pill shape" and is reused unchanged, so
the chip writes no blur code of its own. (It is missing from the `flutter-widgets`
catalogue — see Notes.)

`AppStatusTokens` at `lib/config/theme/tokens/app_status_tokens.dart` — the six status
colours, fills and `StatusTreatment` already exist and are read as-is. No token is
added or duplicated for the statuses ([1.2-AC8]).

`AppTypeTokens.pill` / `AppRadiusTokens.pill` / `AppColorTokens.ink`, `ink08`, `ink55` —
read through `context.tokens`; the widget declares no literal colour or text value.

`ContextExtensions.tokens` at `lib/core/utils/extensions.dart` — the only theme access
path ([1.2-AC19]).

`ZoneLabel` at `lib/widgets/zone_label.dart` (item 1.1) — style precedent only: plain
Flutter widgets, no outer padding, `const` constructor, private helper in-file.

`SavedGameStatusTag` — **not** reused and not touched. Its `Status` enum is the legacy
tracker set; BA's out-of-scope call holds and is not overturned.

## Design decisions

1. **`glass42` is added as a colour token rather than a literal in the widget.**
   [1.2-AC8] forbids any `Color(0x…)` literal in the widget file, and §2's colour law
   requires every literal rgba to be a local addition that is logged. The value slots
   into the existing `glass30/32/34` ramp; `AppColorTokens.dark` is its only
   construction site, so no caller breaks, and `test/widget/theme/app_tokens_test.dart`
   asserts token values one line per glass step, so it gains one line.
2. **One interior padding for both variants** — `EdgeInsets.symmetric(horizontal: 8,
   vertical: 4)`. BA's assumptions proposed `4/8` on-media and `4/12` list, but
   [1.2-AC5] is canonical and says the variants differ *only* in dot diameter and
   capsule fill, "nothing else is redrawn between them". Where a criterion and an
   assumption disagree the criterion wins. Both values are on §1.3's 8px scale, so a
   reversal is a number swap. **Flagged for the Phase 3 gate.**
3. **BA's one-fill-per-variant reading holds.** §3.2 fixes the status system's tinted
   fill at 8% ink; §3.3 describes the same primitive's over-media form as
   `rgba(0,0,0,.42)` + `--blur-glass`; §1.6 restricts blur to copy over media. Two
   contexts, not a contradiction, and [1.2-AC6] encodes it. No change to the criteria.
4. **The status hue "open decision" needs no work.** Confirmed stale: the six status
   tokens already encode violet and cyan, and `_allColors` in the token test already
   covers them. No token, no criterion, no step in this run.
5. **`variant` is a required parameter, not defaulted** — two callers are coming (cover
   tile on-media, library list) and a default would let one of them be silently wrong.
6. **No `build_runner` step.** No annotated source, no freezed, no mocks — the widget
   test pumps the widget directly with no Cubit. The only generated artifact in play is
   the `S` class, which regenerates through the Flutter Intl **IDE plugin**, by hand.

## Out of scope

Everything in `tech-ac.md ## Out of scope`, unchanged — no screen rewiring, no filter
surface, no cover tile or game card, no status domain model, no deprecation of
`SavedGameStatusTag`, no count abbreviation, no press/hover states, no golden test.

Additionally excluded by this design: any `lib/widgets/` catalogue correction beyond
the row [1.2-AC21] requires, and any change to `GlassSurface`.

## Open questions

None.

## Notes (non-blocking)

`GlassSurface` is absent from the `flutter-widgets` catalogue even though it is a
global widget. Not fixed here — no criterion covers it — but the next run that touches
that table should add it, or a third agent will rebuild the blur by hand.

Both new `.arb` keys leave the repo in a **known non-compiling state** until a human
runs the Flutter Intl IDE regeneration: `S.current.backlog` and `S.current.dropped` do
not exist yet, so `status_chip.dart` and its test will not analyse or run. Per
`.claude/pipeline/rules/generation.md` this is expected state, not a Dev failure, and
must not consume self-correction attempts. This is the first run in the pipeline to hit
it — the human gate needs to run the regen before QA can execute the suite.

# Technical Design Document
Source: `tech-ac.md` (week 2 Stage 2 item 2.7 — Error states; `system-foundation-specs.md` §3.4
Action / Screen / Item, §2.1, §3.3, §5)
Date: 2026-08-24

## Feature summary

Presentation-layer only. One new widget module, `lib/widgets/error_states/`, ships three sibling
components — `DestructiveActionPair` (Action), `ErrorNotice` + `ErrorNoticeVariant` (Screen) and
`FailedItem` (Item) — plus the one primitive two of them share, `ErrorDot`. One field
(`surfaceToast`) is added to `AppColorTokens`. One dead file is deleted and one commented line
removed from `game_detail_screen.dart`. Nothing is wired: no existing widget, screen, cubit or
route gains a reference to anything built here. No data, domain or state layer is touched, no
package is added, no code generation runs, and no `.arb` key is minted.

## Layer map

- [2.7-AC1]–[2.7-AC4]: theme tokens (`lib/config/theme/tokens/`)
- [2.7-AC5]–[2.7-AC10]: UI (widget)
- [2.7-AC11]–[2.7-AC20]: UI (widget)
- [2.7-AC21]–[2.7-AC27]: UI (widget)
- [2.7-AC28]–[2.7-AC31]: repository hygiene (file deletion + one screen edit)
- [2.7-AC32]–[2.7-AC35]: run-level, cross-cutting (diff review, tokens, type, tests)

## Data layer

None. No API contract, model, DTO, repository or datasource is created or modified.

## Domain layer

None. No use case or entity is created or modified.

## State layer

None. No BLoC, Cubit or state class is created, modified or provisioned. All three components are
caller-driven and hold no state of their own — see [2.7-AC14]'s "stores no dismissal state".

## UI layer

### Grain — module folder, and why

The three levels ship as one **module folder**, `lib/widgets/error_states/`, not as flat files.

- Items 2.5 and 2.6 shipped flat correctly: each was a single widget family with no siblings and
  no shared parts (`LabeledTextField`'s two helpers are private classes in its own file;
  `HairlineGroup` has none). This run is the opposite case — three families, built together,
  sharing one primitive (`ErrorDot`) and one token vocabulary.
- The four shipped module folders (`game_card/`, `bottom_tab_bar/`, `completion_ring/`,
  `countdown/`) all exist for the same reason: a widget concept whose parts belong together and
  have no meaning apart. §3.4 defines "Error states" as one concept in four levels; three of them
  are built here.
- Flat files would put `ErrorDot` in `lib/widgets/` as a general-purpose app-wide primitive.
  §2.1 rations red hard; a freely importable red-dot widget sitting beside `LibraryTick` is an
  invitation to sprinkle red, and it would need its own catalogue row. Inside `error_states/`
  its import path (`widgets/error_states/error_dot.dart`) says what it is for.
- The `flutter-widgets` skill still states "one file per widget family" as absolute. That
  sentence is a known live follow-up (`handover.md`, "contradicts four shipped modules"); it is
  also satisfied here in the sense that matters — each family gets exactly one file. The folder
  groups four families, it does not split one.

The enum lives in an `enum/` subfolder, matching all three existing module folders that carry one.

### Public surface of the module — what tests may import

The module has **no internal files**. Every file in it is public surface, and the helper widgets
that are not public are private classes inside the file that uses them. This is deliberate: QA
caught item 2.4's tests reaching into module internals, and the cleanest way to prevent a repeat
is to leave nothing to reach into.

Public, importable by callers and by tests:

- `widgets/error_states/destructive_action_pair.dart` — `DestructiveActionPair`
- `widgets/error_states/error_notice.dart` — `ErrorNotice`
- `widgets/error_states/enum/error_notice_variant.dart` — `ErrorNoticeVariant`
- `widgets/error_states/failed_item.dart` — `FailedItem`
- `widgets/error_states/error_dot.dart` — `ErrorDot`

Not importable anywhere, including tests: `_ErrorStrip` and `_ErrorToast` (private classes inside
`error_notice.dart`). Tests must never name them, and must never assert on `_`-prefixed types.
`ErrorDot` is public precisely so tests can scope a finder to it by type instead of digging
through a hierarchy — see "Finder discipline" below.

### Widgets

`ErrorDot` (create) — `lib/widgets/error_states/error_dot.dart` — stateless — consumes: `size`
(double, required), `glyph` (`IconData?`) — display-only, no interaction. Draws a circle filled
with the `error` token at `size`, with the glyph centred in `ink` when one is given. Reads the
`error` token itself; it takes no colour parameter, so the two surfaces that use it cannot drift
apart. Adds no spacing of its own.

`DestructiveActionPair` (create) — `lib/widgets/error_states/destructive_action_pair.dart` —
stateless — consumes: `destructiveLabel`, `safeLabel` (String, both required),
`onDestructive`, `onSafe` (`VoidCallback`, both required) — interactions: each action invokes its
own callback and only its own [2.7-AC8]. A `Row` of two `Expanded` `PrimaryButton`s, safe on the
left, destructive on the right. Destructive: fill `errorStrong`, label `ink` [2.7-AC5]. Safe:
fill `ink08`, label `ink` — neutral, off the error ramp [2.7-AC5], and no green in fill, label or
border [2.7-AC6]. No default label anywhere [2.7-AC7]; no outline-variant parameter, enum value
or named constructor [2.7-AC9]. Adds no spacing of its own.

`ErrorNoticeVariant` (create) — `lib/widgets/error_states/enum/error_notice_variant.dart` — a
bare two-value enum, `strip` and `toast`. No fields, no helpers.

`ErrorNotice` (create) — `lib/widgets/error_states/error_notice.dart` — stateless — consumes:
`variant` (`ErrorNoticeVariant`, required, no default, non-nullable), `message` (String,
required), `onDismiss` (`VoidCallback`, required) — interactions: the strip's dismiss affordance
invokes `onDismiss` once. `build` is a two-arm switch on `variant` returning one private surface
widget, so exactly one surface exists in the tree and "both" is unrepresentable [2.7-AC11],
[2.7-AC12]. Holds no dismissal state and no timer [2.7-AC14], [2.7-AC18]. Takes no `child`,
`content`, `visible` or padding parameter [2.7-AC20]. Adds no spacing of its own.

- Strip (`_ErrorStrip`, private): `DecoratedBox` filled `errorTint` with a 1px `errorLine` border
  at `radius.lg`, containing a row of the message in `errorInk` on the 14/500 `meta` step and a
  dismiss affordance — a plain `InkWell` around `Icons.close` in `errorInk` inside a 44px square
  target [2.7-AC13], [2.7-AC10]'s hit-target floor, §5. Its accessibility label comes from
  `MaterialLocalizations.of(context).closeButtonTooltip`, the same framework-localised path item
  2.4's tab bar cell already uses — no hardcoded English, no new `.arb` key [2.7-AC19].
- Toast (`_ErrorToast`, private): `ClipRRect` at `radius.sm` over a `ColoredBox` filled with the
  new `surfaceToast` token [2.7-AC15], containing an 8px `ErrorDot` with no glyph [2.7-AC16] and
  the message in `ink` on the 14/500 `meta` step, `maxLines: 1` with `TextOverflow.ellipsis`
  [2.7-AC17]. No `Icon` descendant, no `Duration`, no dismiss affordance.

`FailedItem` (create) — `lib/widgets/error_states/failed_item.dart` — stateless — consumes:
`semanticsLabel` (String, required), `child` (Widget, required) — display-only wrapper, no
interaction of its own; the child keeps whatever gestures it had. A `Stack` of (1) a
foreground-positioned `DecoratedBox` drawing a 1px `errorLine` border at `radius.lg` around an
`Opacity` of `0.55` wrapping the child — the border sits outside the `Opacity` so the hairline
is not itself dimmed [2.7-AC21], [2.7-AC22] — and (2) a `Positioned(top: 8, right: 8)` badge:
`Semantics(label: semanticsLabel)` around a 20px `ErrorDot` with `Icons.priority_high` at 12px in
`ink` [2.7-AC24], [2.7-AC25]. Renders no `Text` and accepts no badge label string [2.7-AC23].
Exposes no `isFailed` or pass-through parameter [2.7-AC27]. Adds no spacing of its own.

### One shared primitive, not two

The toast dot and the item badge are **one primitive**, `ErrorDot`, configured by size and an
optional glyph. Both are a circle filled with the `error` token; two classes would let the two
reds drift and would duplicate the "is it `error` or `errorStrong`" decision that [2.7-AC16] and
[2.7-AC25] both pin to `error`. Both parameters have a live caller in this run — 8px without a
glyph in the toast, 20px with one in the badge — so neither is speculative.

The badge carries a glyph and the toast dot does not, deliberately: the badge's slot is
`LibraryTick`'s (20px circle, 12px glyph inside), so the two read as a matched pair distinguished
by hue and mark, while the toast's dot must stay a dot because [2.7-AC16] forbids an `Icon` in
that variant. A glyph is not a word, so the badge stays wordless per §3.4 and [2.7-AC23].

### Positional reference

`FailedItem`'s badge uses `Positioned(top: 8, right: 8)` — the exact slot `game_card.dart:97`
gives `LibraryTick` [2.7-AC26]. Whether the two overlap legibly on an item that is both
in-library and failed is QA's visual check, as `tech-ac.md` states; nothing in this run can make
that determination in code.

### Finder discipline for the widget tests

Item 2.6's Dev found an unscoped `find.byType(ColoredBox)` matching a `MaterialApp` internal, so
the test asserted nothing. Three error surfaces all want a container-and-colour finder, so the
components are shaped to give each one a **single-match, `find.descendant`-scoped finder** with
no `.first`, no `Key`, and no hierarchy mirroring. One rule does it: **surfaces and hairlines are
the only `BoxDecoration`s in the module; `ErrorDot` draws its circle with `ClipOval` over a
`ColoredBox` instead.** That yields:

- dot fill — `find.descendant(of: find.byType(ErrorDot), matching: find.byType(ColoredBox))`
- toast surface — `find.descendant(of: find.byType(ErrorNotice), matching: find.byType(ColoredBox))`
  (the toast's dot contributes no `ColoredBox` of its own outside `ErrorDot`; scope through
  `ErrorDot` when the dot is what is being asserted)
- strip surface and border — `find.descendant(of: find.byType(ErrorNotice), matching: find.byType(DecoratedBox))`
- item hairline — `find.descendant(of: find.byType(FailedItem), matching: find.byType(DecoratedBox))`
- item dim — `find.descendant(of: find.byType(FailedItem), matching: find.byType(Opacity))`
- action colours — `tester.widget<PrimaryButton>(...)` on `backgroundColor` / `labelColor`, the
  composed-public-component form the `flutter-widget-test` skill sanctions

Every colour assertion compares against `AppColorTokens.dark.<token>`, never a literal, per
[2.7-AC33] and [2.7-AC35]. Two traps to hand Dev explicitly: `FailedItem`'s "renders no `Text`"
check only means anything if the test's child is not itself a `Text`; and the `ErrorNotice`
variant tests must scope `find.byType(Icon)` under `ErrorNotice`, since a bare `MaterialApp`
harness carries icons of its own.

## Theme tokens

`AppColorTokens.surfaceToast` (create) — `lib/config/theme/tokens/app_color_tokens.dart` —
`Color(0xFF2E3236)`, declared in the Surfaces group immediately after `surfaceTabChrome` and
wired through the constructor, `dark`, `copyWith` and `lerp` exactly as every other field
[2.7-AC1]. Named for the surface it serves, not the tab bar. No doc comment — the name says it,
and `execution.md` bans the field comment that restates a field name.

`surfaceTabChrome` is untouched: same name, same value, same two readers
(`bottom_tab_bar.dart:21`, `theme_data_dark.dart:57`) [2.7-AC2]. No other foundations file is
opened [2.7-AC4] — no new type step (14/500 is the existing `typography.meta`; §1.2's "14–15" is
a range, so the standing 15px gap stays closed here) and no new radius (`radius.lg` and
`radius.sm` already exist).

One trap in the existing token test: `app_tokens_test.dart:38–50` asserts three *distinct* raised
surfaces via a `Set` length. `surfaceToast` shares `surfaceTabChrome`'s value, so adding it to
that set would fail on a coincidence. [2.7-AC3]'s two assertions must be independent — each names
its own token and its own expected value, and neither couples the two.

## Testing

Mode: **smoke**. Rule applied: UI-only, no new logic, isolated with no shared dependencies. The
token addition is one field on an existing immutable class with an existing unit test file to
extend.

Dedicated test files, decided per the `flutter-widget-test` skill's "does this widget own
meaningful behaviour or a public contract worth protecting" question:

- `DestructiveActionPair` — **yes**. Two callbacks that must fire independently, and a
  destructive-versus-safe distinction that is the whole point of the component.
- `ErrorNotice` — **yes**. Variant-conditional content, a dismissal callback, and a single-line
  constraint that regresses silently.
- `FailedItem` — **yes**. The dim/hairline/badge treatment and the semantics label are its
  documented contract.
- `ErrorDot` — **no dedicated file**. Display-only, no conditional content, no interaction; a
  passive primitive. Its one meaningful contract — it fills with `error` — is asserted where it
  carries meaning, inside the notice and item tests, scoped through `find.byType(ErrorDot)`.
- `PrimaryButton` — **no new file**. Not built here; reused unchanged.

Existing file extended: `test/widget/theme/app_tokens_test.dart` for [2.7-AC3].

Never a golden test, and no assertion on a dimension, gap, radius, offset or position anywhere in
this run [2.7-AC35].

### Criteria that are NOT tested — preserve this distinction

`tech-ac.md` marks ten criteria as verified by inspection rather than by a test. QA must not try
to write or demand a test for any of them, and Dev must not invent one:

- API-surface check on the constructor parameter list: [2.7-AC9], [2.7-AC11], [2.7-AC20],
  [2.7-AC27]
- Code review: [2.7-AC18], [2.7-AC34]
- Code review / QA visual check: [2.7-AC10], [2.7-AC26], [2.7-AC29]
- Diff review against the base SHA: [2.7-AC32]

[2.7-AC31] (analyzer against baseline) and [2.7-AC35] (no goldens, no dimension assertions) are
likewise checks on the run, not behaviours to assert.

## Reuse decisions

- **`PrimaryButton` (`lib/widgets/primary_button.dart`) — reused for both actions of
  `DestructiveActionPair`.** It already is what §3.4's Action level needs: caller-supplied label,
  required `onPressed`, overridable fill and label colour, `minHeight: 44` (§5's floor,
  [2.7-AC10]), `radius.sm`, and the 14/500 `meta` step ([2.7-AC34] comes free). Writing two
  near-identical buttons inside the error module would duplicate a shipped widget for no gain.
  Each goes in an `Expanded` — `PrimaryButton` is `width: double.infinity`, which a bare `Row`
  child cannot be, and `Expanded` is the skill's default anyway.
  Recorded tension, decided not deferred: `PrimaryButton` composes `ButtonPressScale`, whose
  **focus ring is green**. [2.7-AC6] reads "no green in any form — not as fill, label or border."
  Read against the component's own resolutions, this run passes: `DestructiveActionPair` resolves
  no green, both fills and both label colours are passed explicitly (so
  `primary_button.dart:29`'s green default — a standing ownership question in `handover.md` —
  never resolves), and nothing green is drawn at rest. The only green is §5's app-wide focus
  outline, drawn by another component and one of §2's two sanctioned green exceptions. If a
  reviewer prefers the strict reading at the Phase 3 gate, the fallback is a private button class
  inside `destructive_action_pair.dart` and no focus ring — say so at the gate rather than after.
- **`AppColorTokens` error ramp — reused, not extended.** `error`, `errorStrong`, `errorInk`,
  `errorLine` and `errorTint` all exist. Only the toast surface is new [2.7-AC1].
- **`typography.meta` (14/500) — reused for every string in all three levels** [2.7-AC34].
- **`MaterialLocalizations.closeButtonTooltip` — reused for the strip's dismiss affordance**,
  the same framework path `bottom_tab_bar_cell.dart:34` uses for its tab label. Keeps
  [2.7-AC19] and [2.7-AC7] intact with no `.arb` edit and no extra constructor parameter.
- **`LibraryTick` (`lib/widgets/library_tick.dart`) — read as the positional and dimensional
  reference only** (20px circle, 12px glyph, `top: 8, right: 8`). Not modified, not subclassed,
  not parameterised.
- **`ErrorRetryWidget` and `DefaultSnackbar` — deliberately not reused and not touched.** The
  gate decision of 2026-08-24 is pure extraction; §3.4 does not describe `ErrorRetryWidget`'s
  anatomy at all.

## Assumptions confirmed or overruled

- **Toast message in `ink`, strip message in `errorInk` — CONFIRMED.** White on `#2e3236` is the
  strongest contrast available on that surface, the red dot already carries the signal, and §2.1
  rations red. The strip has no dot, so §3.3's "signal hairline + `#ff8f88` message" applies to
  it unchanged. Cheap to reverse: one `copyWith(color:)` in `_ErrorToast`.
- **The dangling `/// TODO: fetch screenshots - from game detail` comment goes with the deleted
  reference — CONFIRMED.** It annotates only the commented-out
  `DetailScreenshotsSection(id: gameExtra!.$1)` line and would otherwise sit above the closing
  bracket of a list, describing nothing. `game_detail_screen.dart:71–73` (the blank line, the
  TODO and the commented call) go together; the live `S.current.screenshots` heading and its
  `Padding` above them stay exactly as they are [2.7-AC29].
- Every other assumption in `tech-ac.md` is carried unchanged into the design above.

New decisions this run, recorded so the gate can overrule them cheaply:

- **`onDismiss` is required on `ErrorNotice`, and the toast ignores it.** Making it nullable
  would introduce a strip-with-no-dismiss branch nothing needs — the "no parameter or branch
  nothing calls" rule — and would weaken [2.7-AC14]'s guarantee to a conditional. The toast's
  dismissal belongs to whatever shows it [2.7-AC18], so an inert callback there is honest, not
  dead API. It cannot render a second surface, so [2.7-AC11] is unaffected.
- **The safe action carries an `ink08` fill, not a bare transparent label.** §3.4 says "in ink,
  never styled as the loud one"; `ink08` is this system's neutral quiet surface (status chips,
  stat tiles, filter chips), carries nothing from the error ramp, and keeps the action legibly
  tappable. Overrule at the gate if the safe choice should be text-only.
- **The badge glyph is `Icons.priority_high` at 12px in `ink`.** Mirrors `LibraryTick`'s mark
  size so the two read as one family in the same slot.

## Out of scope

- The Field level — shipped by item 2.5's `LabeledTextField`, inherited unchanged.
- `ErrorRetryWidget`, `DefaultSnackbar`, `games_screen.dart:88`'s empty state and
  `task_detail_screen.dart:70`'s snackbar — the pure-extraction decision, [2.7-AC30] and
  `tech-ac.md ## Out of scope`.
- Wiring. No existing file gains a reference to any new component [2.7-AC32]. Consequence carried
  forward honestly: two error vocabularies coexist after this run and nothing exercises the new
  components outside their tests.
- The rest of the screenshot chain — `GameScreenshotCubit`, the screenshot models and entity,
  `ImageRouteView`'s route registration, and above all `lib/widgets/game_screenshot.dart`, which
  is **live** via `image_page_view.dart:32`. [2.7-AC30] is the fence and is honoured exactly.
- The `flutter-widgets` skill's catalogue row for the new module, and its "one file per widget
  family" sentence. Editing that file has been a gate decision every time (item 2.5); it is not a
  `lib/` file, no criterion covers it, and [2.7-AC32] fences the diff. Raise both as a post-merge
  docs update — the module folder shipped here is the fifth instance of the contradiction.
- The 15px type collision, `library_stats.dart`'s dashed border, and screen-doc precedence — all
  settled or out of scope per `tech-ac.md`.

## Open questions

None.

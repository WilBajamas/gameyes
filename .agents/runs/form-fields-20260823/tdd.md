# Technical Design Document
Source: `tech-ac.md` — week 2 Stage 2 item 2.5 Form fields (`system-foundation-specs.md` §3.2)
Date: 2026-08-24

## Feature summary

Presentation-layer only. The stock `TextFormField` in
`lib/widgets/default_border_text_field.dart` is replaced by one new global widget,
`LabeledTextField` (`lib/widgets/labeled_text_field.dart`), that owns the whole
field anatomy itself: a label row above the box, a Material `TextField` inside a
token-driven `InputDecoration` (raised fill at r16, no stroke at rest, error tint
plus error hairline when invalid), a green focus ring drawn by a private wrapper
*outside* the box, and the validation message rendered below the ring. Validation
plumbing is a `FormField<String>` the widget composes itself, so the enclosing
`Form.validate()` contract at the dialog is unchanged while the widget keeps
control of where the error message renders. No domain, data or state layer is
touched, no package is added, no token is minted, no localised string is added,
and no code generation is needed. All 7 call sites in the 3 caller files are
rewired in this run and the old widget file is deleted (GATE-1 option A).

## Layer map

Every criterion is UI-layer only; none reaches state, domain or data.

[2.5-AC1] [2.5-AC2] [2.5-AC3] [2.5-AC4]: UI (`LabeledTextField` + its private label row)
[2.5-AC5] [2.5-AC6] [2.5-AC8] [2.5-AC9] [2.5-AC11] [2.5-AC13] [2.5-AC15] [2.5-AC17] [2.5-AC18]: UI (`LabeledTextField`)
[2.5-AC7] [2.5-AC10]: UI (`LabeledTextField` + its private focus ring)
[2.5-AC12]: UI (`LabeledTextField`'s composed `FormField<String>`)
[2.5-AC14]: UI (`LabeledTextField`) + the 2 read-only call sites in `filter_bottom_sheet.dart`
[2.5-AC16]: UI (`LabeledTextField` constructor) + all 3 caller files

## Data layer

None. No API contract, model, DTO, repository or storage is involved.

## Domain layer

None.

## State layer

None. The field holds only local ephemeral state — one `FocusNode` — which the
`flutter-widgets` skill puts squarely in `StatefulWidget` territory, not a Cubit.

## UI layer

### Widgets

`LabeledTextField` (create) — `lib/widgets/labeled_text_field.dart` —
**stateful** (owns a `FocusNode` so the ring can follow focus; disposes it) —
consumes `context.tokens` for every colour, type step and radius —
interactions: typing (`onChanged`), tapping (`onClicked`, the read-only date
pickers), validation driven by the enclosing `Form`.

Public API (the rename off the `Default` prefix is GATE-1's, the parameter
changes follow from the criteria):

| Parameter | Type | Note |
|---|---|---|
| `label` | `String` (required) | was `title`. Renders above the box, always |
| `controller` | `TextEditingController?` | was `textEditingController` |
| `placeholder` | `String?` | was `hint`. AC2's language |
| `helper` | `String?` | new — AC3's slot |
| `prefixIcon` | `Widget?` | unchanged, one caller (search) |
| `inputType` | `TextInputType?` | unchanged |
| `isRequired` | `bool` = false | unchanged |
| `readOnly` | `bool` = false | unchanged |
| `minLines` / `maxLines` | `int?` / `int?` = 1 | unchanged |
| `maxLength` | `int?` | unchanged |
| `enforceMaxLength` | `bool` = false | was `maxLengthEnforce` — plain-English word order |
| `onChanged` | `ValueChanged<String>?` | unchanged |
| `onClicked` | `VoidCallback?` | unchanged |

Removed: `context` (AC16 — the widget resolves theme from its own build context),
and `suffixIcon` (zero callers; `flutter-widgets` forbids a parameter nothing
calls).

Two private sub-widgets live in the same file:
`_FieldLabelRow` (label at 14/500 full ink, trailing helper-or-counter at the 13
caption step, label in an `Expanded` so a long label ellipsises rather than
overflowing the counter) and `_FieldFocusRing` (2px border at a 2px inset,
`tokens.color.green` when focused, transparent when not — so focus adds no
layout shift).

### Screens

None created. Three existing files are edited only to swap the constructor —
see "Call-site review" below.

## Design decisions worth the reviewer's eye

**1. Why the widget composes its own `FormField<String>` instead of keeping
`TextFormField`.** AC7 puts the focus ring *outside the box*, AC9 puts the
message *below the input*. `TextFormField` renders its `errorText` inside the
same `InputDecorator` as the box, so a ring wrapped around a `TextFormField`
would enclose the box *and* the message and stop being a ring around the box.
Owning the `FormField` is what lets the message sit outside the ring. It is the
same wiring `TextFormField` does internally (initial value from the controller,
`field.didChange` from `onChanged`), roughly ten extra lines, and it keeps the
caller's `Form.validate()` contract intact because our `FormField` is still a
descendant of the caller's `Form`.
*Known boundary:* the `FormField`'s value tracks the controller at first build
and thereafter through `onChanged`. A field that is both validated (or counted)
**and** has its controller mutated externally after first build would validate
against a stale value. None of the 7 sites does that — the two required fields
seed their controllers in `initState`, and the two externally-written date
controllers are neither required nor counted.

**2. The read-only fields stay tap targets (AC14).** `readOnly: true` on a
Material `TextField` already gives all three halves of the criterion: `onTap`
fires, no soft keyboard, text not editable. Nothing in the restyle changes it —
the fill, ring and content padding are decoration, and the tap surface is still
the whole decorated box. Two consequences worth stating rather than discovering:
a read-only field still *takes focus* on tap, so the green ring shows on the date
fields, which is correct per AC7 and not a bug; and the resting fill is used
unchanged for them (no disabled treatment exists, per the BA's assumption), which
is AC5's failure case.

**3. The character counter (AC4).** `maxLength` is passed to the `TextField` so
enforcement still works, and Material's own below-field counter is suppressed
with `counterText: ''` — verified in the SDK, `InputDecorator` builds no counter
widget at all when `counterText` is the empty string, so no space is reserved
either and §3.2's "never a third line" holds. The count itself is composed by the
widget as `'<used>/<max>'` and handed to the label row's trailing slot; it stays
current because `field.didChange` rebuilds the `FormField` on every keystroke.
It is digits and a slash, not prose, so **no `.arb` key and no l10n
regeneration** is needed. When both `maxLength` and `helper` are supplied the
counter takes the slot — `maxLength` is the only live producer, and a helper on a
counted field is a requirement nobody has.

**4. `MaxLengthEnforcement` is now explicit, and that changes behaviour at 2
sites.** The current widget passes `maxLengthEnforcement: null` when
`maxLengthEnforce` is false, and `null` resolves to the platform default —
`enforced` on Android. So today's "not enforced" sites are silently enforced.
AC15 requires the opposite, so the new widget passes
`MaxLengthEnforcement.none` explicitly when `enforceMaxLength` is false.
The two `task_detail_screen.dart` editors (30 and 100) are the affected sites:
typing past the limit becomes possible there and the counter reads over its
maximum. Deliberate, criterion-driven, and a visible behaviour change to a
shipped surface — flag it to the human at the gate with the three appearance
changes.

**5. One file, not a module folder.** Items 2.1–2.4 each earned a folder by
having an `enum/` variant type and several parts substantial enough for siblings
to compose. This component has neither: no variant enum, no painter, and exactly
two small private sub-widgets that only its own `build` uses — which the
`flutter-widgets` skill places in the parent's file. A folder would buy nothing
and would import the public-surface question (the exact trap QA caught in 2.4)
for no benefit. Single file, so **the file itself is the public entry point** and
there is no internal surface for a test to reach into.

**6. Type and ink.** GATE-3 option A: label and validation message use the
existing `meta` token (14/500), input text and placeholder use `body` (16/400),
helper and counter use `caption` (13/400). Nothing minted. Two colour pins are
deliberate, not drift: `meta` carries `ink70`, so the label is `copyWith(ink)` to
meet the BA's full-ink assumption (same trap item 1.9 recorded), and `body`
carries no colour at all, so the input text is pinned to `ink` and the
placeholder to `ink55` rather than inheriting whatever `bodyMedium` supplies.
The prefix icon is pinned to `ink55` for the same reason — otherwise it resolves
from the seeded `ColorScheme`. Green appears only in the ring; the cursor uses
`colorScheme.primary`, which is indigo, so AC7's "green nowhere else" holds.

**7. The ring's radius is `radius.lg + 4`.** The ring sits 4px outside a box of
radius 16 (2px border over 2px padding), so a concentric ring is 20. Both numbers
even; derived from the token rather than a second literal. The 1px error hairline
and the 2px ring/offset are the spec's own numbers (§3.2, §1.8, §2.1) and are the
one sanctioned place odd/2px values appear.

**8. The theme's `inputDecorationTheme` is left alone.** It carries an r12 outline
and an `errorBorder` in raw `error`; the widget overrides `border`,
`enabledBorder` and `focusedBorder` locally so none of it applies. Changing the
theme would be a foundations change with reach past this item, and this widget is
the only `TextField` in the app.

## Call-site review (GATE-1 option A — all 7 revisited)

Verified by grep; nothing else in `lib/` builds a text input.

| File | Site | Change |
|---|---|---|
| `add_content_dialog.dart` | title | drop `context`, rename to `label`/`controller`/`placeholder`/`enforceMaxLength`, drop the redundant `minLines: 1`. Copy stands: real label + genuine placeholder |
| `add_content_dialog.dart` | description | same renames. Multi-line config (`minLines: 5`, `maxLines: null`) and placeholder stand |
| `filter_bottom_sheet.dart` | search | drop `context`, rename. Label above the box beside the magnifier reads correctly; `prefixIcon` stays |
| `filter_bottom_sheet.dart` | date from | drop `context`, rename, **drop `inputType: TextInputType.number`** — inert on a read-only field that never raises a keyboard. `readOnly`/`onClicked` stand |
| `filter_bottom_sheet.dart` | date to | as above |
| `task_detail_screen.dart` | title editor | drop `context`, rename. `maxLength: 30` now un-enforced per decision 4 |
| `task_detail_screen.dart` | description editor | drop `context`, rename. `maxLength: 100` now un-enforced per decision 4 |

No copy changes are needed: all 7 sites already pass a real label, and the only
two placeholders sit beside one rather than standing in for one.

## Testing

**Mode: smoke.** Rule applied: "UI-only with no new logic ... isolated with no
shared dependencies." Nothing here is auth, payment, persistence or sync; the
required-field rule and the max-length behaviour are carried over from the widget
being replaced, not invented. Unit and widget tests only. **Never a golden test**
— every pixel claim in AC5–AC8, AC10, AC13 and AC17 is a manual check.

Per `flutter-widget-test`, which widgets get a dedicated file:

- `LabeledTextField` — **yes.** It owns behaviour worth protecting: a validated
  state that renders a message, a tap target that fires a callback without
  becoming editable, and a count that changes with input and must not be
  duplicated below the field.
- `_FieldLabelRow`, `_FieldFocusRing` — **no.** Private, passive, and observable
  only through the parent.
- `add_content_dialog.dart`, `filter_bottom_sheet.dart`,
  `task_detail_screen.dart` — **no new test files.** None has an existing test,
  and none gains behaviour of its own; the change at each is a constructor swap.

**What the test file may import:** only
`package:gaming_library_assessment_flutter/widgets/labeled_text_field.dart`, plus
the same harness imports the reference files use (`theme_data_dark.dart`,
`generated/l10n.dart`, `flutter_localizations`, `google_fonts`). There is no
module internal to import and no private class to find by type. Do not
pre-resolve `AppTokens.dark` or any theme value in `setUpAll` — pass the real
theme into `pumpWidget` (handover gotcha #10).

No dimension, gap, radius, offset or position is asserted anywhere, per the
binding constraints in `tech-ac.md`.

## Reuse decisions

- `ContextExtensions.tokens` (`lib/core/utils/extensions.dart`) — every token
  lookup, per `flutter-widgets`; `Theme.of` is never called directly.
- `S.current.please_enter_value` — the existing localised required-field message
  is reused unchanged (AC12), so no `.arb` edit and no intl regeneration.
- Material's `TextField` + `InputDecoration` for the box — reused rather than
  hand-drawing a surface, because it already gives the rounded fill, the prefix
  icon layout, placeholder handling and max-length enforcement. The parts it does
  *not* place correctly (label, helper, counter, error message) are the parts the
  widget takes over.
- Existing colour, type and radius tokens only — `surfaceRaised`, `green`,
  `errorTint`, `errorLine`, `errorInk`, `ink`, `ink55`, `radius.lg`, `meta`,
  `body`, `caption`. Nothing minted, no literal hex, no `Colors.red`.
- `BottomTabBarFocusRing`'s anatomy is copied, **not imported** — it is an
  internal of the tab bar module and imports from outside that folder are barred.
  A shared focus-ring primitive is now the second hand-rolled copy; noted as a
  follow-up below, not built here.
- No new package. `pubspec.yaml` is untouched.

## Out of scope

- Screen-reader association between the external label and the input. No
  criterion covers it, and doing it properly is a semantics decision (the label
  leaves `InputDecoration`, so Material no longer announces it). Raise as its own
  follow-up rather than inventing a treatment mid-run.
- The theme's `inputDecorationTheme` (decision 8), disabled styling, hover, the
  other three §3.4 error levels (2.7 owns them, and per GATE-2 inherits the field
  level from here unchanged), the Add-to-library sheet's fields, and any 15px
  token.
- Layout, copy and validation rules of the three calling surfaces beyond the
  constructor swap. The filter sheet's date-picker behaviour and the tracker
  screen's edit toggle are untouched.
- A shared focus-ring widget. `_FieldFocusRing` is the second copy of the same
  four lines (after `BottomTabBarFocusRing`); extracting it would mean editing a
  shipped module outside this allowlist. Follow-up.
- **Not fixed, but worth recording:** `_AddContentDialogState.initState` calls
  `super.initState()` *inside* its `if (widget.titleDescription case final
  values?)` branch, so constructing the dialog with no initial title/description
  skips it and trips Flutter's debug assertion. Pre-existing, unrelated to this
  item, and the file is in the allowlist only for the constructor swap — flagging
  it for the human rather than widening scope unasked.

## Open questions

None.

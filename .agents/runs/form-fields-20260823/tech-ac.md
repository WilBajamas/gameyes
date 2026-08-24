# Technical Acceptance Criteria
Source: `week-2-task-briefs.md` item 2.5 — Form fields; `system-foundation-specs.md` §3.2 "Form fields" row (with §1.8 Focus, §2.1 error ramp, §3.4 Field, §5)
Date: 2026-08-23
BA Agent version: 1.0

## Feature summary

Rework the app's single text input from stock Material chrome — floating label,
default outline, hardcoded red error — onto the token-driven treatment: a
persistent label above the box, an optional helper on that same label row, a solid
raised fill at radius 16, a green focus ring drawn outside the edge, and an error
state that swaps the fill for the error tint and adds a hairline on the edge so
the error and the focus ring never occupy the same edge. Every colour comes from
an existing token; nothing new is minted. All existing input behaviour —
required-field validation, multi-line, maximum length, and the read-only variant
that acts as a tap target — is preserved. Three gate decisions are open and listed
in `ambiguities.md`; none of them changes a criterion below, but GATE-1 decides
which files get edited and GATE-2 decides whether `[2.5-AC8]`–`[2.5-AC11]` belong
to this item or to 2.7.

## Technical acceptance criteria

[2.5-AC1] Presentation: The label renders as a persistent element above the input
box, outside it, in every state — empty, focused, and filled. It never animates
into or out of the box edge and never renders inside the box.
  Failure case: given no label text, the field renders with no label row and does
  not substitute the placeholder text for one.

[2.5-AC2] Presentation: Placeholder text, when supplied, renders inside the empty
box only and disappears as soon as the field has content. It is never the only
thing naming the field.
  Failure case: with no placeholder supplied, the empty box renders empty — the
  label text is not repeated inside it.

[2.5-AC3] Presentation: Helper text, when supplied, renders on the label row
opposite the label. No helper text renders below the input.
  Failure case: with no helper text supplied, the label row carries the label
  alone.

[2.5-AC4] Presentation: Where a maximum length is set, the remaining/used count
renders in the label row's helper slot. No character counter renders below the
input.
  Failure case: where no maximum is set, no count renders anywhere.

[2.5-AC5] Presentation: At rest the input box is filled with the raised-surface
token (`surfaceRaised`, `#2f333c`) at radius 16 and draws no outline stroke on any
edge.
  Failure case: no stroke and no hardcoded grey appears in the read-only or
  non-editable case either — the fill is the only surface treatment at rest.

[2.5-AC6] Presentation: Every stroke the component draws — focus ring and error
hairline — is a continuous solid stroke. No dashed or dotted edge in any state.
  Failure case: n/a — this holds in all states.

[2.5-AC7] Presentation: While the field holds focus, a 2px green ring is drawn
outside the box at a 2px offset and the fill is unchanged. Green appears nowhere
else in the component.
  Failure case: on blur the ring is removed entirely, leaving the resting fill
  alone.

[2.5-AC8] Presentation: When the field is invalid, the box fill is the error-tint
token and a 1px error-line hairline is drawn on the box edge. The raised resting
fill is not retained underneath.
  Failure case: when the field becomes valid again, the raised resting fill
  returns and the hairline is removed.

[2.5-AC9] Presentation: The validation message renders below the input in the
error-ink token. No error-ramp colour appears in any non-error state, and no
literal red value is used anywhere in the component.
  Failure case: when validation passes, no message renders below the input.

[2.5-AC10] Presentation: A field that is both invalid and focused renders the
green ring at its offset and the error hairline on the edge at the same time;
neither replaces or suppresses the other.
  Failure case: n/a — both are present whenever both conditions hold.

[2.5-AC11] Presentation: The error state adds no glow, no shake or other motion,
and no icon inside the box, and the text the user typed is preserved unchanged
when validation fails.
  Failure case: re-running validation on the same content does not clear or alter
  the field's text.

[2.5-AC12] Presentation: A field marked required fails validation when empty and
reports the existing localised required-field message; a non-empty required field
passes.
  Failure case: a field not marked required never fails validation on empty
  content.

[2.5-AC13] Presentation: A multi-line field renders with the label above the box
and the fill wrapping the whole box at its grown height, and takes the focus and
error treatments identically to a single-line field.
  Failure case: with no line configuration given, the field renders as a single
  line.

[2.5-AC14] Presentation: A read-only field invokes its tap callback when tapped,
does not raise the soft keyboard, and cannot have its text edited, while keeping
the normal resting fill.
  Failure case: a read-only field with no tap callback absorbs the tap and does
  nothing.

[2.5-AC15] Presentation: Where maximum-length enforcement is enabled, input beyond
the limit is rejected and the field's content stops at the limit; where a maximum
is set without enforcement, typing past it is allowed.
  Failure case: with no maximum set, input length is unconstrained.

[2.5-AC16] Presentation: The component resolves theme and design tokens from its
own build context. It accepts no context from its caller, and no call site passes
one.
  Failure case: any remaining call site that passes a context fails to compile —
  this is the intended signal, not a regression.

[2.5-AC17] Presentation: The input's tappable area is at least 44px tall in every
configuration, including the read-only tap-target form. (§5. Manual check — see
constraints below.)
  Failure case: a single-line field with no placeholder still meets the floor.

[2.5-AC18] Presentation: Type comes from existing tokens only — label at the
14/500 step, input text at the 16/400 body step, helper and counter at the 13
caption step, validation message at 14/500 in error ink. No new type token is
minted.
  Failure case: if the human picks 15px at GATE-3, this criterion is void and a
  token must be minted first — see `ambiguities.md` GATE-3.

## Out of scope

- The other three error levels in §3.4 — Action, Screen and Item. Item 2.7 owns
  them. The field level's ownership is GATE-2, not settled here.
- The Add-to-library sheet's fields — deferred to week 3 with the sheet itself.
- Disabled (`enabled: false`) styling. Unspecified by the spec and unused by every
  call site; the existing hardcoded grey disabled stroke is removed, not replaced.
- Hover treatment for inputs — §1.8 defines hover for other surfaces and names
  none for a field.
- Layout, copy, validation rules and behaviour of the three calling surfaces
  beyond what this treatment forces. In particular the filter sheet's date-range
  picker behaviour and the tracker screen's edit toggle are untouched.
- Minting a 15px type token, or any other foundations-level token change.
- Deciding whether the component is renamed, split into a module folder, or
  deprecated in favour of a new one — that follows from GATE-1 and is the Tech
  Lead's design call.

### Constraints (binding, not independently testable — do not turn into criteria)

- No golden tests, ever. Pixel appearance is a manual check.
- No test asserts a dimension, gap, radius, offset or position, even where a
  criterion above states the number. The criterion is the contract; the test is
  not where it is enforced.
- Colour assertions are written only where the colour carries meaning a reader
  would otherwise miss (focused vs resting, error vs valid) and always name the
  design token, never a literal hex.
- The widget file carries no comments at all.
- The component adds no spacing of its own outside its outer edge; callers own the
  vertical rhythm between fields.
- Red is used only through the error-ramp tokens, never as an accent and never in
  a non-error state.

## Assumptions

ASSUMPTION: Placeholder text is kept as an optional capability — "no
placeholder-as-label" bars a placeholder standing in for a label, not a
placeholder beside a real one.
ASSUMPTION: The character counter is treated as helper text and moved onto the
label row, because §3.2 forbids a third line under the input.
ASSUMPTION: The helper slot is built despite having no current caller, since the
counter needs it.
ASSUMPTION: Label renders at full ink and helper/counter at 55% ink; the spec sets
no ink level for this component.
ASSUMPTION: No disabled treatment is introduced; read-only fields keep the resting
fill.
ASSUMPTION: The existing localised required-field message is reused unchanged.
ASSUMPTION: Hover is not built.

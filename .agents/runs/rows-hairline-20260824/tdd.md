# Technical Design Document
Source: `tech-ac.md` — `week-2-task-briefs.md` item 2.6 + `system-foundation-specs.md` §3.2 line 246 + `game-detail-design-conventions.md` §4.4 / §5.2
Date: 2026-08-24

## Feature summary

Two new presentation-layer widgets in `lib/widgets/`, both stateless, both
unwired. `LabelValueRow` renders a label and a value on one line with an
optional trailing chevron and draws no surface and no edge of its own.
`HairlineGroup` owns the card: `surfaceRaised` fill, `lg` (16) radius, a clip,
and a hairline inserted between each adjacent pair of the generic children it is
given. No data, domain or state layer is touched; no existing file's rendered
output changes.

## Layer map

Every criterion lands in the UI layer only.

[2.6-AC1]–[2.6-AC6]: UI (`LabelValueRow`)
[2.6-AC7]–[2.6-AC12]: UI (`HairlineGroup`)
[2.6-AC13]: no layer — scope guarantee, verified by diff review

## Data layer

None. No API, model, DTO or repository work.

## Domain layer

None. No use case, no entity.

## State layer

None. Both widgets are display-only and hold no state; neither reads or writes a
Cubit/BLoC.

## UI layer

### Screens

None created or modified.

### Widgets

`LabelValueRow` (create) — `lib/widgets/label_value_row.dart` — stateless.
Consumes: `label` (String, required), `value` (String, required),
`showChevron` (bool, default `false`). Interactions: none — no tap target, no
callback. Composition: interior padding, then a row of the label taking the
leftover width, the value at its natural width, and the chevron when asked for.
Both texts use the existing `meta` type token (14/500); the label overrides its
colour to `ink`, the value keeps the token's own `ink70`.

`HairlineGroup` (create) — `lib/widgets/hairline_group.dart` — stateless.
Consumes: `children` (`List<Widget>`, required). Interactions: none.
Composition: an empty list returns a shrunken box; otherwise a clip at the `lg`
radius wraps the `surfaceRaised` fill, which wraps a column of the children with
a `Divider` inserted before every child except the first.

**The two widgets do not import each other.** `HairlineGroup` accepts any
widget, and `LabelValueRow` knows nothing about a container. They compose at the
call site, not in code.

## How the N−1 guarantee survives generic children

`[2.6-AC9]` is the primary constraint of this item, and `[2.6-AC12]` pulls
against it: if children are arbitrary widgets, the group cannot use their type to
decide where hairlines go, and a caller could hand it a child that paints its own
edge. The design answers that in four parts.

1. **Placement is derived, never supplied.** `HairlineGroup`'s entire public
   surface is `key` and `children`. Separator positions are computed from
   `children.length` alone — the index loop emits a `Divider` only when the index
   is greater than zero, so a leading or trailing hairline is not something a
   caller can request or a maintainer can toggle; it is a case the code does not
   contain. There is no divider flag, no `showDividers`, no per-child wrapper
   object, no `separatorBuilder`. Removing the possibility is what makes this a
   construction guarantee rather than a documented convention.
2. **The group never inspects a child.** It does not type-test, read a property
   off, or unwrap any element of `children`, so no child can influence hairline
   placement even by accident. This is also why `[2.6-AC12]` costs nothing to
   honour: arity is the only input, and arity is type-agnostic.
3. **What the group guarantees is scoped to what the group draws.** The group
   owns every separator element in its own subtree and there are exactly N−1 of
   them. It cannot stop a bespoke child from painting a line inside its own
   bounds, and it should not try — the alternative that could (a typed child list)
   is exactly the option the human rejected. The shipped row closes the case that
   matters: `[2.6-AC4]` forbids `LabelValueRow` from drawing any edge, so the
   intended composition is safe, and a bespoke child that draws its own rule is
   that child's defect, visible in review, not a hole this API left open.
4. **The clip contains the failure it can contain.** Clipping at the `lg` radius
   (`[2.6-AC7]`) means an unruly child cannot square off the card's corners or
   paint outside the group's shape, whatever it draws inside.

`[2.6-AC8]`'s count is the observable shadow of all this, which is why it is
stated as N−1 at N = 1, 2, 3 and is the only part a test can hold.

## Single files vs. a module folder

**Two flat files in `lib/widgets/`, no folder.** Reasoning, per the "decide per
item" position the last two items have actually established (2.1–2.4 folders,
2.5 single file):

- A folder exists to hide internals behind a public entry point. Here there are
  no internals to hide: two public classes, no variant enum, no painter, and one
  private helper at most. `bottom_tab_bar/` and `game_card/` each hide four or
  five collaborators; this hides nothing.
- A folder would have to hold **two** public entry points, which is precisely the
  ambiguity that let item 2.4's tests reach into a module's internals and needed a
  post-QA commit. Two files named after the two public classes leave no second
  question about what may be imported.
- The two classes are decoupled (see above), so there is no cohesion argument for
  binding them into one directory; a caller wanting only the row should not import
  a folder named after the group.

Consequence for tests: each test file imports exactly one widget file, and there
is no internal file for it to reach into.

Note for the Phase 3 gate: `flutter-widgets` still states "one file per widget
family" as absolute, which matches neither the four shipped module folders nor
2.5's single file. This design agrees with the rule by coincidence, not by
obedience. Settling that sentence is a live follow-up (`handover.md`) and is
deliberately **not** done in this run — it is a convention change for the human,
not a Tech Lead call.

## Verification map

Preserves `tech-ac.md`'s own split. QA should not attempt a widget test for
anything in the second table.

**Widget test**

| Criterion | Where |
|---|---|
| [2.6-AC2] label `ink` / value `ink70` | `label_value_row_test.dart` — colour assertion naming both tokens |
| [2.6-AC3] chevron optional, one when asked | `label_value_row_test.dart` — two presence/count tests |
| [2.6-AC4] row draws no separator | `label_value_row_test.dart` — no separator when pumped alone |
| [2.6-AC7] fill only | `hairline_group_test.dart` — fill asserted as `surfaceRaised` |
| [2.6-AC8] N−1 at N = 1, 2, 3 | `hairline_group_test.dart` — three count tests |
| [2.6-AC10] hairline colour only | `hairline_group_test.dart` — colour assertion naming `hairline` |
| [2.6-AC11] empty group draws nothing | `hairline_group_test.dart` — no card fill with no children |
| [2.6-AC12] children are generic | no separate test — the [2.6-AC8] count tests pass plain `Text` children, so they only pass if arity is the sole input |

**Not test-assertable — code review / QA visual check**

| Criterion | Why |
|---|---|
| [2.6-AC1] both texts required | Enforced by `required` constructor params at compile time; both texts are observed incidentally by the [2.6-AC2] test |
| [2.6-AC5] no fill, no radius on the row | Absence of any decoration in the row's tree; asserting it would be a structural assertion of no meaning |
| [2.6-AC6] padding 14 / 16 | A dimension — never asserted in this project |
| [2.6-AC7] radius and clipping | Dimension and paint behaviour |
| [2.6-AC9] no hairline parameter | The absence of a parameter is the criterion — constructor review |
| [2.6-AC10] 1px stroke | A dimension |
| [2.6-AC13] ships unwired | Diff review plus the recorded analyzer and test baselines |

Ten tests across two files is longer than `context_chip_test.dart` and
`stat_pill_test.dart`, deliberately: `[2.6-AC8]` alone is a three-case contract
and four of the ten are named by `tech-ac.md`'s own "Verified by" lines. Every
one is a single pump and one or two expectations; none measures anything.

## Reuse decisions

`AppTypeTokens.meta` (`lib/config/theme/tokens/app_type_tokens.dart`) — already
the 14/500 Inter step and already carries `ink70`, so the value needs no colour
override and the label needs one line. Satisfies `[2.6-AC2]`'s "no new type
token".

`AppColorTokens.surfaceRaised` / `.hairline` / `.ink` / `.ink70` / `.ink55` —
every colour this item needs already exists; nothing is added to the token set.

`AppRadiusTokens.lg` — resolves to 16, §3.2's r16.

Flutter's `Divider` for the hairline rather than a new widget — it is a plain
built-in, it takes an explicit colour and thickness, and being a public type it
is what makes `[2.6-AC8]`'s count assertable without a test reaching into a
private class.

`_FieldLabelRow` in `lib/widgets/labeled_text_field.dart` — pattern reference
only, not imported: the same label-takes-the-leftover-width, trailing-text shape
that item 2.5 shipped. `LabelValueRow` follows it rather than inventing a second
approach to the same row.

`HorizontalSeparator` — **deliberately not reused.** It hardcodes `Colors.grey`
and forces `context.screenWidth`, both wrong inside a padded card, and touching
it would change `detail_mid_section.dart` on merge, ending the unwired ship. Its
two defects stay a recorded follow-up per the gate's CRITICAL-1 answer.

## Out of scope

- `horizontal_separator.dart`, `group_task_item.dart`, `task_item.dart` — all
  untouched (`[2.6-AC13]`).
- Any tap, press or navigation callback on the row.
- A per-row value colour override, including §4.4's green `Day one` price.
- Adopting either component anywhere, including `_SignOutButton` and tracker's
  rows.
- `library_stats.dart`'s `_DashedBorderPainter` — item 2.8's.
- Golden tests and any pixel comparison.
- The `flutter-widgets` "one file per widget family" rule sentence.

## Open questions

NONE.

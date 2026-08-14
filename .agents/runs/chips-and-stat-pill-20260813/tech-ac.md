# Technical Acceptance Criteria
Source: Week 2 task briefs items 1.5, 1.6, 1.7 (combined run) · `system-foundation-specs.md` §0.6, §1.2, §1.4, §1.6, §1.9, §2, §3.2, §3.3, §5, §6 · `onboarding-welcome-design-spec.md` §3, §3b · `home-screen-design-conventions.md` §3.2, §5.1 · `game-detail-design-conventions.md` §5 · build conventions from the `flutter-widgets` skill
Date: 2026-08-13
BA Agent version: 1.0

## Revision note — 2026-08-14 (Phase 3, human override)

**Widget test authorship for these three components moves to the human.** The Dev Agent still
implements the three widgets, both call-site migrations and the catalogue update exactly as
specified below, but writes no test file for them this run — `filter_count_chip_test.dart`,
`context_chip_test.dart` and `stat_pill_test.dart` are authored by the human afterwards, to be
reviewed and graded in a later pass.

This is deferred authorship, not waived coverage. The state matrix [ALL-AC7] previously required
Dev to cover is kept verbatim, restated as behaviour each component must exhibit and as the
checklist the human-supplied tests are reviewed against. Dev's remaining test-side obligation is
unchanged: the two migrated call sites must still build, the tests already covering them must
still pass, no existing test is weakened or deleted, and no golden test is added.

Corrected by this note: [ALL-AC7] only. No per-item criterion (1.5-ACn, 1.6-ACn, 1.7-ACn) referred
to Dev-authored tests, so none needed rewording. Everything else is untouched — every behavioural
and visual criterion for the three components, the decision to ship the context chip and the glass
stat-pill form unwired, the `_DashedBorderPainter` follow-up, "Out of scope" and "Assumptions".

Consequential for Phase 2: the three test files come out of `task-brief.md`'s allowlist and
`code-plan.md`'s test section before Phase 4.

## Feature summary

Three independent Stage 1 primitives in one run. **1.5** reworks the existing global choice
chip into the spec's filter / count chip: a pill capsule with an indigo active state, an 8%-ink
inactive state, and an optional count slot, replacing a stock Material chip that carries its own
theme, checkmark and padding. **1.6** adds the context chip, a new glass capsule with a small
leading icon that names where the user is inside a hero; nothing in the repo draws one today and
nothing calls it after this run either — it is component-library groundwork for heroes that do
not exist yet. **1.7** replaces a feature-local `_buildStatTile` helper method with a global stat
pill in two forms of one anatomy: the tile form (a figure over a label on 8% ink at r16, laid out
in threes by its caller) and the glass hero form (2–3 figure/label pairs inside one glass pill).
Only the tile form has a live caller. All three are stateless presentation widgets: no new state,
no repository, no persistence, no network, no new localisation key and no new dependency. Two
existing call sites are migrated in the same run (the filter bottom sheet's three chip groups and
the featured screen's stat row); no other screen changes.

Criterion IDs are namespaced per item. `ALL-ACn` covers the standing rules that apply
identically to all three components — they are not a fourth component.

## Technical acceptance criteria

### 1.5 — Filter / count chip

[1.5-AC1] PRESENTATION: After this run exactly one filter-chip widget exists in `lib/widgets/`,
produced by reworking `default_choice_chip.dart` rather than adding a second chip beside it. Both
existing callers are migrated in the same run ([1.5-AC11]), so no `@Deprecated` alias and no old
class is retained.
  Failure case: a new chip added while `DefaultChoiceChip` survives, a deprecated shim with no
  caller, or two widgets in `lib/widgets/` drawing the same capsule.

[1.5-AC2] PRESENTATION: The widget is named categorically for what it is, without a `default`
prefix, and its class name does not collide with Flutter's own `FilterChip`, `ChoiceChip` or
`Chip` — no call site or the widget's own file needs an import alias, `hide`, or a
`package:flutter/material.dart` qualification to disambiguate it. File and class names agree. It
has a `const` constructor and is built from plain Flutter widgets in the style of the existing
hand-written `lib/widgets/` components.
  Failure case: a name that forces an import alias anywhere, a `default` prefix, or a
  Widget-returning function or getter instead of a widget class.

[1.5-AC3] PRESENTATION: The capsule uses the `pill` radius token in both states.
  Failure case: a literal radius, a per-state radius, or a stadium shape supplied by a Material
  chip's default theme.

[1.5-AC4] PRESENTATION: In the active state the capsule fill is the indigo primary token and the
label renders in white.
  Failure case: an indigo tint rather than a solid fill, a label in ink55/ink70, or the fill
  resolved from `ColorScheme` instead of the app's colour tokens.

[1.5-AC5] PRESENTATION: In the inactive state the capsule fill is the `ink08` token and the label
renders in the full `ink` token.
  Failure case: an `ink12`-and-up fill, a dimmed label, or the inactive state drawn as an outline
  instead of a fill.

[1.5-AC6] PRESENTATION: The chip has an optional count slot. When a count is supplied it renders
after the label inside the same capsule; when none is supplied no count widget exists in the tree
and the capsule shrinks accordingly. A supplied count of `0` renders as `0` and is not treated as
absent. The count renders in `ink55` in the inactive state and in white in the active state.
  Failure case: a count rendered when none was supplied, `0` silently suppressed, a count outside
  the capsule, or the count taking the label's colour in the inactive state.

[1.5-AC7] PRESENTATION: The capsule's interior padding is 14 logical pixels horizontally and 8
vertically, and the label renders at 14px, weight 500, in the body face. Neither is a constructor
parameter — no caller can change the chip's padding, text size or capsule height.
  Failure case: the stock chip's own `labelPadding`/`materialTapTargetSize` insets surviving, a
  padding or size parameter on the constructor, or a label size differing from 14px.

[1.5-AC8] PRESENTATION: The chip is tappable in both states and fires its single callback exactly
once per tap. The tappable region is at least 44 logical pixels tall; the drawn capsule keeps the
padding in [1.5-AC7] and does not grow to meet it.
  Failure case: a tap that fires twice or not at all, a tap that only registers on the label's own
  glyphs, a hit target under 44px tall, or the capsule visibly taller than its padding dictates.

[1.5-AC9] PRESENTATION: The chip renders a label and an optional count and nothing else — no
checkmark, no leading or trailing icon, no avatar, no delete affordance, no elevation or shadow,
and no border. Its two states are driven by one boolean input; none of its colours are resolved
from the app's Material chip theme, so changing that theme does not change this chip.
  Failure case: a checkmark appearing on selection, a shadow, a border, an icon slot nothing
  needs, or a colour that moves when the Material theme moves.

[1.5-AC10] PRESENTATION: The chip sizes itself to its content — it never expands to fill its
parent's width and never adopts a fixed width. A label longer than the available width renders on
one line, truncated with an ellipsis; the count stays on the same line and is never truncated.
  Failure case: a wrapped or clipped label, the count pushed to a second line or ellipsised, an
  overflow error in a constrained row, or a chip stretching to the parent's width.

[1.5-AC11] PRESENTATION: `type_values_selection.dart` and `multi_type_values_selection.dart` use
the reworked chip, and the filter bottom sheet still renders its ordering, platform and genre
groups with unchanged selection behaviour — single-select for ordering, multi-select for platforms
and genres, same callbacks, same order, same items. No current caller supplies a count. The
spacing between chips and between a group's title and its chip row stays owned by the two group
widgets, not moved into the chip.
  Failure case: a call site failing to compile, a selection group changing which items it marks
  selected, a chip group losing or gaining spacing, or the chip acquiring the group's `Wrap`
  spacing as its own.

### 1.6 — Context chip

[1.6-AC1] PRESENTATION: A new context-chip widget is added to `lib/widgets/`, named categorically,
with a `const` constructor, no `default` prefix, and no name collision requiring an import alias.
Any helper it needs is a private class in the same file.
  Failure case: the widget placed in a feature folder, a `default` prefix, or a helper split into
  its own file with no second caller.

[1.6-AC2] PRESENTATION: The capsule is glass — a translucent black fill drawn from the tokenised
`.30`/`.32`/`.34` glass ramp (one fixed value chosen at build time, never a constructor
parameter), with the existing glass-blur effect applied behind it and clipped to the capsule's
shape.
  Failure case: an `rgba`/hex literal instead of a token, a fill outside the `.30–.34` ramp
  (including the status chip's `.42`), blur bleeding outside the capsule's bounds, or no blur at
  all.

[1.6-AC3] PRESENTATION: The capsule uses the `pill` radius token, and its interior padding is 12
logical pixels horizontally and 6 vertically. Neither is a constructor parameter.
  Failure case: any other radius, padding supplied by a caller, or a fixed capsule height.

[1.6-AC4] PRESENTATION: The label renders at 11px, weight 500, `.08em` tracking, uppercase, in the
full `ink` token, from the app's existing chip/pill type token rather than a locally declared
`TextStyle`.
  Failure case: sentence-case output, a font family or weight declared inside the widget file, or
  a colour dimmer than full ink.

[1.6-AC5] PRESENTATION: A leading icon renders at 13 logical pixels, in the same colour as the
label, before the label inside the capsule, separated from it by a fixed 6px gap. The icon is
required — there is no iconless variant.
  Failure case: an icon at 16px/20px, an icon tinted differently from the label, an optional icon
  branch, or the gap exposed as a parameter.

[1.6-AC6] PRESENTATION: The chip sizes itself to its content and renders its label on one line,
truncated with an ellipsis if the parent is too narrow. It is display-only: no tap callback, no
ink ripple, no press, hover or focus treatment.
  Failure case: a wrapped label, an overflow error, or any interaction affordance.

[1.6-AC7] PRESENTATION: The chip applies no position of its own. It contains no `Positioned`,
`Align`, `Transform`, offset or `top`-style constructor parameter, and nothing in it encodes the
spec's `top:54px` — placing it inside a hero is entirely the hero's job.
  Failure case: the 54px inset baked into the widget, a positioning parameter on the constructor,
  or the widget only rendering correctly inside a `Stack`.

[1.6-AC8] PRESENTATION: The chip ships with no caller. No screen, hero or existing widget is
edited to render it, and the welcome screens' flat header art is untouched.
  Failure case: a screen wired up to it in this run, or any change to the welcome screens.

### 1.7 — Stat pill

[1.7-AC1] PRESENTATION: One stat-pill widget family lives in one new file in `lib/widgets/`,
covering both forms — the tile form and the glass hero form. The figure-over-label pair is built
once and shared by both forms rather than written twice, and any helper is a private class in the
same file.
  Failure case: two unrelated widgets in separate files, the pair's type treatment duplicated per
  form, or one form built as a special case of a screen rather than of the component.

[1.7-AC2] PRESENTATION: The tile form renders exactly one figure/label pair on an `ink08` fill at
the `lg` radius token (16), with 13 logical pixels of interior padding on all sides. The figure
renders above the label, both horizontally centred. It never draws its own siblings, separators or
row.
  Failure case: a border or shadow on the tile, a radius other than `lg`, the label above the
  figure, left-aligned content, or the widget rendering two or three pairs at once.

[1.7-AC3] PRESENTATION: The tile form's figure uses the existing stat-figure type token — display
face, weight 700, 18px, full `ink`. Its label renders at 11px, weight 500, in `ink55`.
  Failure case: a figure in the body face or below 700, a figure size differing from the token, a
  label at 13px+ or in `ink70`, or either style declared as a local `TextStyle` literal.

[1.7-AC4] PRESENTATION: The tile form fills whatever width its parent allocates and sizes its
height to its content, so three of them in an equal-width row render identically sized without the
widget knowing about the other two.
  Failure case: a fixed or intrinsic width that breaks a three-up row, a hardcoded height, or the
  tile collapsing in an unbounded-width parent.

[1.7-AC5] PRESENTATION: The glass hero form renders 2 or 3 figure/label pairs inside a single
capsule, distributed with equal space between them. Its fill is drawn from the tokenised
`.30`/`.32`/`.34` glass ramp with the glass-blur effect applied behind it and clipped to the
capsule; its radius is the `pill` token; its interior padding is 14 logical pixels horizontally
and 10 vertically.
  Failure case: one pair per capsule, pairs evenly spaced by inserted gap widgets rather than
  distributed, blur bleeding outside the capsule, an `ink08` fill, or padding supplied by a caller.

[1.7-AC6] PRESENTATION: In the glass hero form the figure uses the same stat-figure type token as
the tile form (display 700, 18px, `ink`) and the label renders at 10px in `ink70`.
  Failure case: a figure size differing between the two forms, a label at 11px, or a label in
  `ink55`.

[1.7-AC7] PRESENTATION: The glass hero form accepts exactly 2 or 3 pairs. A caller supplying fewer
or more fails loudly in debug builds rather than rendering a capsule the spec does not define.
  Failure case: 1 or 4+ pairs rendering silently, a runtime layout overflow standing in for the
  check, or the limit enforced only by a comment.

[1.7-AC8] PRESENTATION: Neither form has an icon slot and neither takes a per-stat colour, fill or
accent parameter. Figure and label colours are fixed by the criteria above in every instance.
  Failure case: an `IconData` parameter, a caller-supplied colour, or the current tiles' blue /
  orange / green treatment carried over.

[1.7-AC9] PRESENTATION: Figure and label are caller-supplied strings rendered verbatim. The widget
performs no number formatting, rounding, abbreviation, pluralisation or localisation, and holds no
user-facing string of its own. Each renders on one line, truncated with an ellipsis if the width
does not allow it.
  Failure case: an `int`/`double` parameter formatted inside the widget, an `S.current` lookup in
  the file, a wrapped figure, or an overflow error in a narrow parent.

[1.7-AC10] PRESENTATION: `library_stats.dart`'s three stat tiles render with the tile form. The
three values and labels are unchanged (total games, wishlist count, this-week hours, each already
formatted by the screen), they stay in the same equal-width three-up row in the same order, and
the 12px gaps between them and the 20px gap below stay in `library_stats.dart`. The three icons
and their `blueAccent` / `orangeAccent` / `green` colours are removed with no replacement.
  Failure case: a stat losing its value or label, the row's order or gaps changing, an icon
  surviving, or the gaps migrating into the new widget.

[1.7-AC11] PRESENTATION: The `_buildStatTile` Widget-returning method is deleted from
`library_stats.dart`, and no other part of that file changes — the checklist card, the checklist
item rows, the now-playing card and the dashed-border painter behind the empty now-playing state
are all left exactly as they are.
  Failure case: `_buildStatTile` left in place unused, an unrelated section of the file rewritten,
  or the file's other `// TODO` cleanup attempted in this run.

[1.7-AC12] PRESENTATION: The glass hero form ships with no caller. No screen is wired to it and
the welcome screens' flat header art is untouched.
  Failure case: a screen wired up to it in this run.

### ALL — standing rules, applied identically to 1.5, 1.6 and 1.7

[ALL-AC1] PRESENTATION: None of the three adds spacing of its own. No outer padding, margin or
spacer around its content, and no `EdgeInsets`, `padding`, `margin`, `gap` or spacing constructor
parameter on any of them. Each renders flush inside the bounds its parent gives it. The interior
padding of each component's own capsule or tile ([1.5-AC7], [1.6-AC3], [1.7-AC2], [1.7-AC5]) is
that component's anatomy and is unaffected by this rule.
  Failure case: any outer padding or margin baked into one of the three, a spacing parameter on
  any of the three constructors, or a caller's row/wrap spacing absorbed into a component.

[ALL-AC2] PRESENTATION: None of the three draws a dashed or dotted stroke, and none custom-paints
an edge. As specified, none of the three draws a border at all — every surface is a fill.
  Failure case: a `CustomPainter`/`CustomPaint` drawing an edge in any of the three files, a dash
  or gap constant, or a decorative border added where the spec gives a fill.

[ALL-AC3] PRESENTATION: Every colour, radius, type style and blur value in all three components
comes from the app's design tokens, read through the project's context extension — never
`Theme.of(context)`, never `ColorScheme`, never a `Colors.*` or hex/`rgba` literal, never a
locally declared font family or weight. The only literals permitted in the three files are the
padding, gap, icon-size and dot-free dimension numbers this document states explicitly.
  Failure case: a direct `Theme.of(context)` call, a colour literal, a `GoogleFonts.*` call inside
  a component file, or a token value re-declared locally.

[ALL-AC4] LOCALISATION: No new localisation key is added and none of the three contains a
user-facing string — every label, count, figure and chip caption is supplied by the caller.
`intl_en.arb`, `intl_zh.arb` and the generated `S` class are untouched by this run.
  Failure case: a hardcoded caption in any of the three, a new `.arb` key, or a regenerated `S`
  class in the diff.

[ALL-AC5] BUILD: No new third-party dependency is added for any of the three. `pubspec.yaml` stays
read-only.
  Failure case: a package added without a recorded deviation approval.

[ALL-AC6] DOCS: The `flutter-widgets` skill's reusable-widget catalogue ends this run describing
what actually exists: the `DefaultChoiceChip` row is replaced by the reworked filter chip's row
rather than left beside it, and rows are added for the context chip and the stat pill. Each of the
three rows notes that the widget adds no spacing of its own, matching the existing `ZoneLabel`,
`StatusChip`, `CoverTile` and `PlaceholderSlot` entries.
  Failure case: a stale `DefaultChoiceChip` row surviving, a component missing from the catalogue
  so the next agent rebuilds it, or a row omitting the no-spacing note.

[ALL-AC7] TESTS: **Dev writes no widget test file for the three components in this run.** Test
authorship for the filter/count chip, the context chip and the stat pill is deferred to the human,
who supplies those files separately for review in a later pass (see the revision note at the top of
this document). Coverage is deferred, not waived, and nothing below is optional behaviour — each of
the following must hold and must be independently verifiable at widget-test level. This list is
also the checklist the human-supplied tests are reviewed against:
  · 1.5: active fill and white label; inactive `ink08` fill and `ink` label; count present, count
    absent, and count `0`; count colour in each state; the pill radius; label truncation in a
    narrow parent; one callback per tap in each state; a hit target of at least 44px; no checkmark
    or icon in the tree.
  · 1.6: the glass fill token and blur present and clipped; the pill radius; the uppercase 11px
    label; the 13px leading icon in the label's colour; no tap handler in the tree; no
    `Positioned`/offset applied by the widget itself.
  · 1.7: the tile form's `ink08` fill, `lg` radius, figure-above-label order and 11px `ink55`
    label; the tile adopting its parent's width; the glass form's glass fill, blur, pill radius,
    space-between distribution and 10px `ink70` label; 2 and 3 pairs accepted; fewer or more
    rejected per [1.7-AC7]; strings rendered verbatim with no formatting.
  Dev's own test-side obligation is unchanged and still applies: the migrated call sites keep
  working — the filter bottom sheet's three groups and the featured screen's stat row still build
  and still pass whatever tests already cover them. No golden test and no `matchesGoldenFile`,
  whatever the criteria above say about appearance; that rule binds the human-supplied files too.
  Failure case: Dev committing a widget test file for any of the three this run, a new test failure
  beyond the recorded baseline, an existing test weakened or deleted to make the run pass, or a
  golden test added.

## Out of scope

- The two other ad-hoc filter chips in the repo — `_SelectionChip` inside
  `default_filter_list_app_bar.dart` and inside `filter_list_app_bar.dart`. Both draw a
  filter-chip-shaped control off-spec, but item 1.5 names only `default_choice_chip.dart`, both are
  app-bar tab controls with a different API and an icon slot, and one is covered by an existing
  widget test on a live tracker surface. Flagged for Tech Lead in `ambiguities.md`; converting them
  is a separate item.
- The rest of `library_stats.dart`, including the file's `// TODO: Refactor this widget` and its
  `_DashedBorderPainter`. The painter is a live violation of the standing "outlines are always
  solid" rule, found during this analysis and reported in `ambiguities.md`; the empty state it
  draws belongs to item 2.8, and fixing it here would change a screen area this run has no
  criteria for.
- Wiring the context chip or the glass stat-pill form to any screen. Neither has a surface — the
  welcome heroes that carried both were replaced with flat PNG art by item 6.1.
- The Home screen's own chip and stat-triplet numbers (`9px 14px` / 13px chips, 24px stat figures)
  and the game detail screen's 20px stat grid. Per-surface variances recorded against screens that
  do not exist yet; this run builds §3.3's single anatomy. See `ambiguities.md`.
- Hover, press (`scale(0.97)`) and focus-ring treatments, and any animated transition between the
  chip's two states. No press-state token exists and no prior component in this library implements
  one; adding the first is its own decision.
- Screen-reader semantics and any iOS/device verification.
- New design tokens. Every colour, radius, blur and most type values already exist; the two type
  values with no exact token (the chip's 14px/500 label, the tile form's 11px/500 `ink55` label)
  are Tech Lead's call to add as tokens or compose from existing ones — either way the rendered
  values are fixed by [1.5-AC7] and [1.7-AC3].
- Promoting §6's local additions into the bound design system, and the §7.1 status-hue decision.
- Any screen other than the filter bottom sheet and the featured screen's stat row.

## Assumptions

ASSUMPTION: All three are in-run reworks/additions with their existing callers migrated in the same
run; no `@Deprecated` alias survives, because nothing is left pointing at an old API.
ASSUMPTION: §3.3 wins over the surface docs for anatomy. The chip is `8px 14px` at 14px/500 (§3.3),
not Home's `9px 14px` at 13px/500; the stat figure is 18px (§3.3 and the app type ramp), not Home's
24px or game detail's 20px.
ASSUMPTION: The `.30–.34` glass range is one fixed value per component, not a range exposed to
callers. `.32` is the midpoint and all three points are already tokenised; any of the three
satisfies the spec, so the exact pick is Tech Lead's.
ASSUMPTION: The active chip's count takes the label's white, mirroring how the existing status
chip's filled state handles its count. Only the inactive count colour is specified.
ASSUMPTION: The chip's 44px hit target follows the project's accessibility rule ("44px minimum hit
targets everywhere") and the existing `ZoneLabel` link precedent, expanding the tap area without
changing the drawn capsule. The Home doc's counter-note ("chips at 35px tall are text-adjacent, not
primary actions") is the alternative if Tech Lead prefers it — but these chips are tapped.
ASSUMPTION: The context chip's icon is required and its icon-to-label gap is 6px, matching the
status chip's internal gap. No doc gives the gap.
ASSUMPTION: The context chip's label is uppercased by its type token, per §3.3's `.08em` caps.
ASSUMPTION: The stat pill's tile form centres its figure and label, matching what the featured
screen renders today, so the rewire is not also an alignment change. No doc states the alignment.
ASSUMPTION: The tile form's 13px interior padding comes from the Home doc's stat triplet — the only
padding any doc gives the tile form. §3.2 gives none.
ASSUMPTION: The glass form's 10px label sits at `ink70`, per the welcome doc's stat bar; §3.3 gives
the size only. The tile form's label sits at `ink55` per §3.2.
ASSUMPTION: "Used in threes" is the caller's layout for the tile form (one pair per tile) and the
widget's own constraint for the glass form (2–3 pairs in one capsule). §3.2 and §3.3 describe the
same component packaged two ways, which is what "two size contexts" means here.
ASSUMPTION: Dropping the featured screen's stat icons and their blue/orange/green tints is required
by the spec's anatomy (no icon slot) and by colour law (green is rationed to one CTA; no fourth
loud accent), not a preference.
ASSUMPTION: Both the context chip and the glass stat-pill form are built despite having no caller —
the checklist defines them as Stage 1 primitives, and the same call was already taken for the
placeholder slot's provider preset and is stated for item 2.2's completion ring.
ASSUMPTION: No new l10n key, no new dependency, no generated output; `pubspec.yaml` is read-only.

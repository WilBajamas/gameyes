# Technical Design Document
Source: Week 2 task briefs items 1.5, 1.6, 1.7 (combined run) · `tech-ac.md` 2026-08-13
Date: 2026-08-13
Revised: 2026-08-14 (Phase 3, human override)

## Revision note — 2026-08-14

Corrected in place against the BA's 2026-08-14 revision of `tech-ac.md` [ALL-AC7]: **the
Dev Agent writes no widget test file for the three components this run.** The human
authors `filter_count_chip_test.dart`, `context_chip_test.dart` and `stat_pill_test.dart`
separately, to be reviewed and graded in a later pass. Coverage is deferred, not waived —
[ALL-AC7]'s state matrix stands as the checklist those files are reviewed against.

Changed here: `## Layer map`'s ALL-AC7 line and `## Testing mode`. Everything else — the
three widgets' design, both call-site migrations, the catalogue update, and every reuse
and design decision — is unchanged. The design is still written to be verifiable at
widget-test level, so the human's tests have something to bite on.

## Feature summary

Presentation-layer only. Three stateless global widgets in `lib/widgets/`, all composed
from plain Flutter widgets and the existing design tokens read through
`context.tokens`: a reworked filter/count chip (replacing `DefaultChoiceChip`), a new
glass context chip, and a new stat-pill family whose tile and glass-hero forms share one
private figure/label pair widget. No new state, use case, repository, datasource, model,
route, DI registration, localisation key, design token or package. Two existing call
sites are migrated in the same run: the filter bottom sheet's three chip groups (via
`TypeValuesSelection` / `MultiTypeValuesSelection`) and the featured screen's stat row in
`library_stats.dart`. The reusable-widget catalogue in the `flutter-widgets` skill is
updated to match what exists after the run.

## Layer map

All 41 criteria are UI-layer. Nothing touches API, repository, use case, state or storage.

- 1.5-AC1 … 1.5-AC10: UI (new widget `lib/widgets/filter_count_chip.dart`)
- 1.5-AC11: UI (call sites `type_values_selection.dart`, `multi_type_values_selection.dart`)
- 1.6-AC1 … 1.6-AC8: UI (new widget `lib/widgets/context_chip.dart`)
- 1.7-AC1 … 1.7-AC9, 1.7-AC12: UI (new widget family `lib/widgets/stat_pill.dart`)
- 1.7-AC10, 1.7-AC11: UI (call site `library_stats.dart`)
- ALL-AC1, ALL-AC2, ALL-AC3: UI (standing rules across the three new files)
- ALL-AC4, ALL-AC5: no layer — assertions that l10n and `pubspec.yaml` stay untouched
- ALL-AC6: docs (`.claude/skills/flutter-widgets/SKILL.md` catalogue)
- ALL-AC7: UI behaviour, no Dev deliverable — the state matrix is behaviour each of the
  three widgets must exhibit and the checklist for the human's own test files. Dev writes
  no test file for them; Dev's only test-side obligation is that the existing suite still
  passes at baseline after the two call-site migrations.

## Data layer

None. No API contract, model, repository or datasource is created or modified.

## Domain layer

None.

## State layer

None. All three widgets are `StatelessWidget`; every value is a constructor parameter
supplied by the caller. No Cubit or BLoC is added, provisioned or read.

## UI layer

### Screens

No screen file is created or modified. `featured_screen.dart` and
`filter_bottom_sheet.dart` keep their current composition — only the widgets they already
compose change internally.

### Widgets

**`FilterCountChip` (create) — `lib/widgets/filter_count_chip.dart` — StatelessWidget**
Replaces `DefaultChoiceChip`; that file is deleted in the same run, so no `@Deprecated`
shim survives ([1.5-AC1]). Name is categorical, carries no `default` prefix, and does not
collide with Flutter's `FilterChip`/`ChoiceChip`/`Chip`, so no call site needs an alias or
`hide` ([1.5-AC2]).
- Consumes: `String label`, `bool isSelected`, `VoidCallback onSelected`, `int? count`.
  No padding, size, colour, style, icon or spacing parameter ([1.5-AC7], [1.5-AC9],
  [ALL-AC1]).
- Structure: `GestureDetector(behavior: HitTestBehavior.opaque)` →
  `ConstrainedBox(minHeight: 44)` → `Center(widthFactor: 1)` → `DecoratedBox` →
  `Padding` → `Row(mainAxisSize: min)`. The `widthFactor: 1` keeps the chip content-width
  inside a `Wrap`, which hands children a bounded max width ([1.5-AC10]); the
  `ConstrainedBox`/`Center` pair lifts the hit target to 44px without growing the drawn
  capsule ([1.5-AC8]), the same shape `ZoneLabel`'s `_ZoneLink` already uses.
- Surface: `BoxDecoration(color:, borderRadius: BorderRadius.circular(radius.pill))` —
  fill only, no border, no shadow, no `CustomPaint` ([1.5-AC3], [1.5-AC9], [ALL-AC2]).
  Fill is `color.accentIndigo` when selected, `color.ink08` otherwise ([1.5-AC4],
  [1.5-AC5]).
- Content: `Flexible(Text(label, maxLines: 1, overflow: ellipsis))` then, when `count`
  is non-null, an unconstrained `Text('$count')` so the count is never ellipsised and
  never wraps ([1.5-AC6], [1.5-AC10]). A `null` count builds no widget at all; `0`
  builds one ([1.5-AC6]).
- Interactions: one `onSelected` callback, fired by the single `GestureDetector` in both
  states. No `InkWell`, ripple, hover, press or focus treatment (out of scope per
  `tech-ac.md ## Out of scope`).

**`ContextChip` (create) — `lib/widgets/context_chip.dart` — StatelessWidget**
- Consumes: `IconData icon` (required — no iconless branch, [1.6-AC5]) and `String label`.
  No tap callback, no position, no padding, no colour parameter ([1.6-AC6], [1.6-AC7],
  [ALL-AC1]).
- Structure: `GlassSurface` → `Padding(horizontal: 12, vertical: 6)` →
  `Row(mainAxisSize: min, spacing: 6)` → `Icon(size: 13)` +
  `Flexible(Text(maxLines: 1, overflow: ellipsis))` ([1.6-AC3], [1.6-AC5], [1.6-AC6]).
- No `Positioned`, `Align`, `Transform`, `Stack` or offset anywhere in the file; the
  spec's `top: 54px` belongs to the hero that eventually places it ([1.6-AC7]).
- Ships with no caller ([1.6-AC8]).

**`StatTile` (create) — `lib/widgets/stat_pill.dart` — StatelessWidget**
The tile form of the stat pill ([1.7-AC2]).
- Consumes: `String figure`, `String label`. No icon, no colour, no padding ([1.7-AC8],
  [1.7-AC9], [ALL-AC1]).
- Structure: `DecoratedBox(color: ink08, borderRadius: circular(radius.lg))` →
  `Padding(EdgeInsets.all(13))` → `_StatPair`. Fill only, no border, no shadow
  ([1.7-AC2], [ALL-AC2]).
- Sizing: no `SizedBox`, no width, no height — it adopts whatever width its parent
  allocates and sizes its height to content, so three of them under `Expanded` render
  identically without knowing about each other ([1.7-AC4]).

**`StatPill` (create) — `lib/widgets/stat_pill.dart` — StatelessWidget**
The glass hero form ([1.7-AC5]). Named for §3.3's own row, which describes the glass
capsule; `StatTile` is named for §3.2's row. Both live in `stat_pill.dart` as one family
([1.7-AC1]).
- Consumes: `List<StatEntry> stats`, with
  `assert(stats.length == 2 || stats.length == 3)` in the `const` constructor so a wrong
  count fails loudly in debug rather than rendering an undefined capsule ([1.7-AC7]).
- Structure: `GlassSurface` → `Padding(horizontal: 14, vertical: 10)` →
  `Row(mainAxisAlignment: spaceBetween)` with each pair in a `Flexible`. `spaceBetween`
  distributes the leftover space rather than inserting gap widgets; the loose `Flexible`
  caps each pair's width so a long string ellipsises instead of overflowing
  ([1.7-AC5], [1.7-AC9]).
- Ships with no caller ([1.7-AC12]).

**`StatEntry` (create) — `lib/widgets/stat_pill.dart`** — `@immutable` value class holding
`figure` and `label` strings, so `StatPill` takes one list rather than two parallel ones.

**`_StatPair` (create) — private in `lib/widgets/stat_pill.dart`** — the figure-over-label
column both forms render, written once ([1.7-AC1]). Takes `figure`, `label` and the
resolved `labelStyle`; reads the shared figure style itself so the two forms cannot drift
([1.7-AC3], [1.7-AC6]). `Column(mainAxisSize: min)`, both children centred, each
`maxLines: 1` with an ellipsis ([1.7-AC2], [1.7-AC9]).

**`TypeValuesSelection` (modify) — `lib/widgets/type_values_selection.dart`** — swaps
`DefaultChoiceChip` for `FilterCountChip`. Identical parameter names, so the change is the
class name and the import. Its `Wrap(spacing: 5)`, its title and its `SizedBox(height: 2)`
stay where they are ([1.5-AC11], [ALL-AC1]).

**`MultiTypeValuesSelection` (modify) — `lib/widgets/multi_type_values_selection.dart`** —
same swap; `Wrap(spacing: 4)` and title spacing unchanged ([1.5-AC11]).

**`LibraryStatsWidget` (modify) — `lib/features/featured/presentation/widgets/library_stats.dart`** —
the three `_buildStatTile(...)` calls inside `_buildLibraryStats` become `StatTile`
instances with the same three already-formatted values and the same three `S.current`
labels, in the same order, still inside `Expanded` with the same `SizedBox(width: 12)`
gaps and the same `SizedBox(height: 20)` below. `_buildStatTile` is deleted, taking the
three `IconData`s and the `blueAccent`/`orangeAccent`/`green` tints with it
([1.7-AC10], [1.7-AC11]). Nothing else in the file is touched.

## Reuse decisions

- **`GlassSurface` at `lib/widgets/glass_surface_widget.dart`** — used by both `ContextChip`
  and `StatPill`. It already applies `context.tokens.effect.glassBlur` behind a tokenised
  fill and clips both to a `BorderRadius`, which is exactly [1.6-AC2] and [1.7-AC5]. No
  second blur helper is written.
- **`context.tokens` (`ContextExtensions`)** — the single access path for every colour,
  radius, type and blur value in all three files. No `Theme.of(context)`, no
  `ColorScheme`, no literals ([ALL-AC3]).
- **Existing type tokens, composed rather than extended** — `tech-ac.md ## Out of scope`
  left the two unmatched type values to this phase. Both compose from a token with a
  colour override, the same pattern `StatusChip` and `PlaceholderSlot` already use, so no
  token file changes and no `app_tokens_test.dart` churn:
  - filter chip label 14px/500 body face → `typography.meta.style` (Inter 14/500) with
    the colour overridden per state ([1.5-AC7]).
  - stat tile label 11px/500 `ink55` → `typography.pill.style` (Inter 11/500, `.08em`)
    with `ink55` ([1.7-AC3]).
  - stat figure → `typography.statFigure` verbatim (Space Grotesk 18/700, `ink`), shared
    by both forms ([1.7-AC3], [1.7-AC6]).
  - glass form label 10px `ink70` → `typography.microLabel.style` verbatim ([1.7-AC6]).
  - context chip label → `typography.pill`, used *with* its `format()` because [1.6-AC4]
    requires uppercase ([1.6-AC4]).
- **`ZoneLabel`'s `_ZoneLink` hit-target shape** — copied structurally (opaque
  `GestureDetector` + `ConstrainedBox(minHeight: 44)` + centre) rather than reinvented
  ([1.5-AC8]).
- **`DefaultChoiceChip` is not reused.** The `flutter-widgets` skill's "mark the old
  widget `@Deprecated` rather than deleting it" clause exists for widgets that still have
  callers; both of this one's callers are migrated in the same run, so [1.5-AC1] requires
  deletion instead. Recorded here so the deletion does not read as a convention breach.

## Design decisions

Choices this phase had to make, all inside the criteria, all cheap to reverse at the
Phase 3 gate:

1. **Names.** `FilterCountChip`, `ContextChip`, `StatTile` + `StatPill`. None collides
   with a Flutter class, none carries a `default` prefix, and `StatPill`/`StatTile` take
   their names from §3.3's and §3.2's own rows for the two forms ([1.5-AC2], [1.6-AC1],
   [1.7-AC1]).
2. **Glass values.** `StatPill` uses `glass30` — the exact value the welcome doc's §3b
   stat bar states. `ContextChip` uses `glass32`, the midpoint of §3.3's `.30–.34` range.
   Both are fixed at build time, neither is a parameter ([1.6-AC2], [1.7-AC5]).
3. **Label/count gap on the filter chip: 6px.** No doc states it, and running the count
   flush against the label is not shippable. 6px is the status chip's existing internal
   gap, which is the nearest precedent in the same library, and the BA already applied
   that precedent to the context chip's icon gap.
4. **Figure/label gap in the stat pair: none.** No doc states one, and [ALL-AC3] allows
   only the dimension numbers `tech-ac.md` states explicitly, so no number is invented.
   The pair relies on the figure token's own `1.1` line height. Unlike the count case,
   stacked text does not run together without a gap. Reversible in one line if the human
   wants air there.
5. **Two public classes, one file, one private pair.** A single class with two named
   constructors would need nullable fields and a form discriminator to express "exactly
   one pair" versus "exactly 2–3 pairs". Two classes sharing `_StatPair` keeps each
   constructor honest about its own arity ([1.7-AC1], [1.7-AC2], [1.7-AC7]).
6. **The context chip and the glass stat pill ship unwired**, as the BA proposed. Both
   are Stage 1 primitives on the week-2 checklist, the same call is already recorded for
   item 2.2's completion ring and was taken for the placeholder slot's provider preset,
   and the glass form costs a few lines on top of the tile form because they share
   `_StatPair`. Public widgets do not trip the analyzer's unused-declaration warnings, so
   nothing regresses the baseline. Trimming either is a one-file reversal at the gate.

## Testing mode

`smoke`, and **for this run smoke carries no Dev-authored test file.** Per the BA's
2026-08-14 revision of [ALL-AC7], test authorship for all three components moves to the
human, who writes `filter_count_chip_test.dart`, `context_chip_test.dart` and
`stat_pill_test.dart` after this run for separate review. The Dev Agent creates no test
file; `task-brief.md`'s allowlist has no `### TEST FILES` section, so writing one is an
allowlist breach, not a bonus.

Why the mode label stays `smoke` rather than dropping to `none`: `none` means
cosmetic/config-only work that warrants no coverage at all, and that is not what happened
here — coverage is deferred to a named author, not waived. Recording `smoke` keeps the
mode honest for QA and for whoever reads this after the human's files land. Working the
first-match rule mechanically also still gives `smoke`: no criterion touches
authorisation, payments, persistence, offline sync, or a shared utility used by three or
more features — `FilterCountChip` reaches one feature, `StatTile` one, `ContextChip`
none — so `coverage` does not fire, matching the three comparable runs in this
component-library push (zone label, status chip, placeholder slot).

**What the deferral does not change: the design must still be testable.** Every item in
[ALL-AC7]'s matrix has to be independently verifiable at widget-test level against the
implementation as designed above — the fills, radii, type styles and the assert are all
reachable through public constructors and the rendered tree, with no private-only state to
reach past. The matrix in `tech-ac.md` is the checklist the human's files get reviewed
against; nothing in it is optional behaviour.

**Dev's remaining verification obligation, unchanged by this revision:** run the full
existing suite and confirm the two migrated call sites did not regress it. No test covers
`filter_bottom_sheet.dart` or `LibraryStatsWidget` directly today, so the check is that
the suite still compiles and the recorded baseline still holds after
`type_values_selection.dart`, `multi_type_values_selection.dart` and `library_stats.dart`
change and `default_choice_chip.dart` is deleted — in particular that nothing else in the
repo still imports the deleted file. No existing test may be weakened, skipped or deleted
to make the run pass.

Unit and widget tests only in this project. **No golden test and no `matchesGoldenFile`**,
whatever the criteria say about appearance — that rule binds the human-supplied files too.

## Out of scope

- **Dev-authored widget tests for the three components** — moved to the human by the
  2026-08-14 [ALL-AC7] revision; see `## Testing mode`. Deferred, not waived.
- **The `_DashedBorderPainter` in `library_stats.dart`.** A real, pre-existing violation
  of the standing "outlines are always solid" rule (`system-foundation-specs.md` §0.6):
  it draws a dashed edge around the empty now-playing card behind
  `style: BorderStyle.none, // We want dashed border`. This run edits that file for the
  stat tiles only. **Follow-up for item 2.8** (empty states), which owns the card the
  painter draws — fixing it here would change a screen area this run has no criterion for
  and would be a silent scope expansion. [1.7-AC11] names it as must-not-touch.
- **The two other off-spec filter chips** — `_SelectionChip` in
  `default_filter_list_app_bar.dart` and in `filter_list_app_bar.dart`. Item 1.5 names
  only `default_choice_chip.dart`; both are app-bar tab controls with a different API and
  an icon slot, and one is covered by `test/widget/tracker/default_filter_list_app_bar_test.dart`
  on a live surface. Converting them is its own item. **Follow-up.**
- **New design tokens.** Composed from existing tokens instead — see ## Reuse decisions.
- **Wiring the context chip or the glass stat pill to a screen**, and any change to the
  welcome screens' flat header art ([1.6-AC8], [1.7-AC12]).
- Hover, press, focus and animated state transitions; screen-reader semantics; device
  verification; the rest of `library_stats.dart` including its `// TODO: Refactor this
  widget`; the Home and game-detail per-surface size variances.

## Open questions

None.

# Task Brief
Source: Week 2 task briefs items 1.5, 1.6, 1.7 (combined run) · `tech-ac.md` 2026-08-13
Date: 2026-08-13

## Context

Build three Stage 1 component-library primitives — the filter/count chip, the context
chip and the stat pill — as stateless widgets in `lib/widgets/`, and migrate the two
existing call sites (the filter bottom sheet's chip groups and the featured screen's stat
row) onto them in the same run.

## Testing mode

`smoke` — Rule applied: "UI-only with no new logic; isolated with no shared dependencies."
Justification: no authorisation, payments, persistence or offline sync is touched, and no
component here reaches three features, so `coverage` does not fire; the zone label, status
chip and placeholder slot shipped `smoke` for the same reason. Breadth is covered anyway —
[ALL-AC7] lists the required state matrix as a canonical criterion and is binding at this
mode. One test file per implementation file. **No golden test, no `matchesGoldenFile`.**

## File allowlist

### CREATE NEW
- `lib/widgets/filter_count_chip.dart` — `FilterCountChip`: pill capsule, indigo active /
  `ink08` inactive, optional count slot, one tap callback.
- `lib/widgets/context_chip.dart` — `ContextChip`: glass pill capsule with a required 13px
  leading icon and an uppercase caps label; display-only.
- `lib/widgets/stat_pill.dart` — the stat-pill family: `StatTile` (tile form),
  `StatPill` (glass hero form), `StatEntry` (figure/label value class) and the private
  `_StatPair` both forms render.

### MODIFY EXISTING
- `lib/widgets/default_choice_chip.dart` — **delete.** Replaced by `filter_count_chip.dart`;
  both callers migrate in this run, so no `@Deprecated` shim is kept ([1.5-AC1]).
- `lib/widgets/type_values_selection.dart` — swap `DefaultChoiceChip` for
  `FilterCountChip`; nothing else changes.
- `lib/widgets/multi_type_values_selection.dart` — same swap; nothing else changes.
- `lib/features/featured/presentation/widgets/library_stats.dart` — the three stat tiles
  in `_buildLibraryStats` become `StatTile`s; delete `_buildStatTile` and its icons and
  colour tints. Nothing else in the file changes.
- `.claude/skills/flutter-widgets/SKILL.md` — in the reusable-widget catalogue, replace
  the `DefaultChoiceChip` row with `FilterCountChip` and add rows for `ContextChip` and
  the stat-pill family; each of the three notes it adds no spacing of its own ([ALL-AC6]).

### TEST FILES
- `test/widget/components/filter_count_chip_test.dart` — the chip's two fills and label
  colours, the three count cases and their colours, the pill radius, truncation, one
  callback per tap in each state, the 44px hit target, and that no checkmark or icon is in
  the tree.
- `test/widget/components/context_chip_test.dart` — the glass fill token, blur present and
  clipped, the pill radius, the uppercase 11px label, the 13px icon in the label's colour,
  no tap handler, and no positioning applied by the widget.
- `test/widget/components/stat_pill_test.dart` — the tile form's fill, radius, order,
  label style and parent-width behaviour; the glass form's fill, blur, radius,
  space-between distribution and 10px `ink70` label; 2 and 3 pairs accepted, 1 and 4
  rejected; strings rendered verbatim.

## Implementation plan

Step 1: Create `lib/widgets/filter_count_chip.dart` — `FilterCountChip` per
[1.5-AC2] … [1.5-AC10] and [ALL-AC1] … [ALL-AC3].

Step 2: Create `lib/widgets/context_chip.dart` — `ContextChip` per [1.6-AC1] … [1.6-AC7]
and [ALL-AC1] … [ALL-AC3], reusing `GlassSurface`.

Step 3: Create `lib/widgets/stat_pill.dart` — `StatEntry`, `StatTile`, `StatPill` and the
private `_StatPair` per [1.7-AC1] … [1.7-AC9] and [ALL-AC1] … [ALL-AC3], reusing
`GlassSurface` for the glass form.

Step 4: Update `lib/widgets/type_values_selection.dart` — replace the `DefaultChoiceChip`
construction and import with `FilterCountChip`; leave the `Wrap`, the title and the
`SizedBox` untouched ([1.5-AC11]).

Step 5: Update `lib/widgets/multi_type_values_selection.dart` — the same swap ([1.5-AC11]).

Step 6: Delete `lib/widgets/default_choice_chip.dart` ([1.5-AC1]).

Step 7: Update `lib/features/featured/presentation/widgets/library_stats.dart` — replace
the three `_buildStatTile(...)` calls with `StatTile(figure:, label:)` carrying the same
values, labels and order, then delete the `_buildStatTile` method. Do not touch the
checklist card, the checklist items, the now-playing card, `_DashedBorderPainter`, or the
file's `// TODO` ([1.7-AC10], [1.7-AC11]).

Step 8: Update the catalogue table in `.claude/skills/flutter-widgets/SKILL.md`
([ALL-AC6]).

Step 9: Create `test/widget/components/filter_count_chip_test.dart` covering [ALL-AC7]'s
1.5 list.

Step 10: Create `test/widget/components/context_chip_test.dart` covering [ALL-AC7]'s
1.6 list.

Step 11: Create `test/widget/components/stat_pill_test.dart` covering [ALL-AC7]'s
1.7 list.

Step 12: Run `flutter analyze` and `flutter test`. Compare against
`orchestrator-state.md`'s recorded baselines, quoted verbatim: **Analyzer baseline:
"0 errors, 2 warnings, 32 info — captured 2026-08-13T13:39:30Z"**; **Test baseline:
"+265 -11 — captured 2026-08-13T13:43:00Z"**, with pre-existing failures in
`test/repository/tracker/tracker_repository_test.dart` (4),
`test/cubit/game_detail/game_detail_cubit_test.dart` (3),
`test/cubit/games/games_bloc_test.dart` (3) and `test/widget_test.dart` (1). Neither
"all tests pass" nor "the analyzer is clean" is true here — only a new, in-scope
regression against those numbers is yours to fix.

No `build_runner` step: nothing in this run is an annotated source, and none of the three
widget tests mocks anything, so no `*.mocks.dart` is generated. No `.arb` edit and no `S`
regeneration: no component holds a user-facing string ([ALL-AC4]).

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: 1.5-AC1 … 1.5-AC11, 1.6-AC1 … 1.6-AC8, 1.7-AC1 … 1.7-AC12,
ALL-AC1 … ALL-AC7.

## Constraints

**Placement and naming** (`flutter-widgets` skill)
- All three files go in `lib/widgets/` — global widgets, generic APIs, no feature folder.
- One file per widget family. A helper only the family uses is a private class in the same
  file, never its own file.
- No `default` prefix on a new widget. Names are categorical.
- Never a `Widget`-returning function or getter — extracted UI is always a widget class.
  This is why `_buildStatTile` goes away rather than being kept and restyled.
- `const` constructors everywhere the linter allows; `EdgeInsets`/`TextStyle`/`Color`
  literals are `const`.

**Standing conventions** (`flutter-widgets` skill — both apply to every file here)
- **No spacing of its own.** No outer padding, margin or spacer around a component's
  content, and no `EdgeInsets`/`padding`/`margin`/`gap`/spacing constructor parameter
  reintroducing it. Interior padding of a capsule or tile the widget itself draws is that
  widget's anatomy and is fine. The caller's `Wrap` spacing and the featured row's 12px /
  20px gaps stay with the caller ([ALL-AC1], [1.5-AC11], [1.7-AC10]).
- **Outlines are always solid.** None of the three draws a border at all — every surface
  is a fill. No `CustomPaint`/`CustomPainter`, no dash or gap constant, in any of the
  three files ([ALL-AC2]). The pre-existing `_DashedBorderPainter` in `library_stats.dart`
  violates this rule but belongs to item 2.8's empty-state work: **leave it exactly as it
  is.** Do not fix it, do not comment on it in code, do not delete it.
- Build for what the current callers need. No parameter, variant or branch for a case
  nothing calls yet.
- Few comments. Comment the one thing the code does not already say, once.

**Theme and tokens**
- Every colour, radius, type style and blur comes from `context.tokens` (the
  `ContextExtensions` accessor). Never `Theme.of(context)`, never `context.themeData`,
  never `ColorScheme`, never `Colors.*`, never a hex or `rgba` literal, never a
  `GoogleFonts.*` call or a locally declared font family or weight ([ALL-AC3]).
- Compose the two unmatched type values from existing tokens with a colour override — the
  pattern `StatusChip` and `PlaceholderSlot` already use. Do **not** add a token: no file
  under `lib/config/theme/tokens/` is in the allowlist.
- The only numeric literals permitted in the three new files are the dimensions
  `tech-ac.md` states explicitly, plus the two gaps recorded in `tdd.md ## Design
  decisions` (6px label-to-count on the filter chip; no gap in the stat pair).

**Dart style** (`dart-style.md`)
- Single quotes, trailing commas on multi-line argument lists, 80-column limit.
- Import order: Dart SDK, then packages (flutter → third-party → project), then relative
  imports (only `part` and `generated/l10n.dart`), each group blank-line-separated and
  alphabetised. Prefer package imports.
- No `dynamic`, no `var` for class fields, no `late`, no `print`.

**Testing** (`testing-conventions.md`)
- Widget tests live in `test/widget/components/` — the established bucket for these global
  widgets (`zone_label_test.dart`, `status_chip_test.dart`, `cover_tile_test.dart`,
  `placeholder_slot_test.dart`). Follow their shape: `GoogleFonts.config.allowRuntimeFetching
  = false`, the `setUpAll` font warm-up, and a `MaterialApp(theme: buildDarkTheme())`
  wrapper with the `S` delegates.
- Test names: `'should [expected behaviour] when [condition]'`.
- Never a golden test.

**Scope boundaries**
- `pubspec.yaml` is read-only — no new package ([ALL-AC5]).
- `lib/l10n/intl_en.arb`, `lib/l10n/intl_zh.arb` and the generated `S` class stay out of
  the diff ([ALL-AC4]).
- `_SelectionChip` in `default_filter_list_app_bar.dart` and `filter_list_app_bar.dart` is
  a follow-up item, not this run's work. Do not convert them.
- No screen file changes. `featured_screen.dart` and `filter_bottom_sheet.dart` are not in
  the allowlist.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make tests
pass. Do not add packages to `pubspec.yaml` or touch files outside the allowlist —
escalate instead.

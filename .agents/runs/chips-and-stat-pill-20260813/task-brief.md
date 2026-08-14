# Task Brief
Source: Week 2 task briefs items 1.5, 1.6, 1.7 (combined run) · `tech-ac.md` 2026-08-13
Date: 2026-08-13
Revised: 2026-08-14 (Phase 3, human override)

## Revision note — 2026-08-14

Corrected in place against the BA's 2026-08-14 revision of `tech-ac.md` [ALL-AC7]: **the
Dev Agent writes no widget test file for the three components this run.** The three test
files are gone from the allowlist below and the three test-writing steps are gone from the
implementation plan. The human authors them afterwards for separate review.

Creating any of `test/widget/components/filter_count_chip_test.dart`,
`context_chip_test.dart` or `stat_pill_test.dart` in this run is an allowlist breach.

Unchanged: the 8 source files, both call-site migrations, the catalogue update, and Dev's
obligation to run the full suite and confirm no regression against the recorded baseline.

## Context

Build three Stage 1 component-library primitives — the filter/count chip, the context
chip and the stat pill — as stateless widgets in `lib/widgets/`, and migrate the two
existing call sites (the filter bottom sheet's chip groups and the featured screen's stat
row) onto them in the same run.

## Testing mode

`smoke`, **with no Dev-authored test file this run.** Rule applied: "UI-only with no new
logic; isolated with no shared dependencies." Justification: no authorisation, payments,
persistence or offline sync is touched, and no component here reaches three features, so
`coverage` does not fire; the zone label, status chip and placeholder slot shipped `smoke`
for the same reason.

Test authorship for all three components is deferred to the human by [ALL-AC7] — the mode
label stays `smoke` because coverage is deferred to a named author, not waived. Dev writes
**no** test file for the three components; the allowlist below has no `### TEST FILES`
section, and adding one is a breach.

Dev's test-side obligation is the regression check only: run the full existing suite after
the two call-site migrations and the deletion of `default_choice_chip.dart`, and confirm
the recorded baseline still holds. No existing test may be weakened, skipped or deleted.
**No golden test, no `matchesGoldenFile`** — ever, and that binds the human's files too.

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

None. Per [ALL-AC7] as revised 2026-08-14, the human authors the widget tests for all
three components after this run. **No test file may be created or modified in this run** —
the existing suite is run, not extended.

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

Step 9: Run `flutter analyze` and `flutter test` — the **full existing** suite, writing no
new test. Confirm the two migrated call sites and the deleted chip file caused no
regression: everything still compiles (nothing else imports `default_choice_chip.dart`)
and the numbers still match `orchestrator-state.md`'s recorded baselines, quoted verbatim:
**Analyzer baseline: "0 errors, 2 warnings, 32 info — captured 2026-08-13T13:39:30Z"**;
**Test baseline: "+265 -11 — captured 2026-08-13T13:43:00Z"**, with pre-existing failures
in `test/repository/tracker/tracker_repository_test.dart` (4),
`test/cubit/game_detail/game_detail_cubit_test.dart` (3),
`test/cubit/games/games_bloc_test.dart` (3) and `test/widget_test.dart` (1). Neither
"all tests pass" nor "the analyzer is clean" is true here — only a new, in-scope
regression against those numbers is yours to fix.

No `build_runner` step: nothing in this run is an annotated source and no mock is
generated, so no `*.mocks.dart` exists to build. No `.arb` edit and no `S` regeneration:
no component holds a user-facing string ([ALL-AC4]).

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: 1.5-AC1 … 1.5-AC11, 1.6-AC1 … 1.6-AC8, 1.7-AC1 … 1.7-AC12,
ALL-AC1 … ALL-AC7.

Note on [ALL-AC7]: its state matrix is binding as **behaviour the three widgets must
exhibit**, not as a list of tests to write. Build so every line of it is verifiable at
widget-test level; the human's own test files check it later.

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
- **Write no test file in this run**, and modify none. The three component test files are
  the human's to author afterwards ([ALL-AC7], revised 2026-08-14).
- Run the full existing suite and compare to the baseline. If a pre-existing test breaks,
  fix the cause in the source, inside the allowlist — never by editing the test.
- Never a golden test.
- For reference when the human's files land later, the established shape in
  `test/widget/components/` (`zone_label_test.dart`, `status_chip_test.dart`,
  `cover_tile_test.dart`, `placeholder_slot_test.dart`) is
  `GoogleFonts.config.allowRuntimeFetching = false`, the `setUpAll` font warm-up, a
  `MaterialApp(theme: buildDarkTheme())` wrapper with the `S` delegates, and test names
  reading `'should [expected behaviour] when [condition]'`. Nothing for Dev to do here.

**Scope boundaries**
- `pubspec.yaml` is read-only — no new package ([ALL-AC5]).
- `lib/l10n/intl_en.arb`, `lib/l10n/intl_zh.arb` and the generated `S` class stay out of
  the diff ([ALL-AC4]).
- `_SelectionChip` in `default_filter_list_app_bar.dart` and `filter_list_app_bar.dart` is
  a follow-up item, not this run's work. Do not convert them.
- No screen file changes. `featured_screen.dart` and `filter_bottom_sheet.dart` are not in
  the allowlist.
- No file under `test/` is in the allowlist.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make tests
pass. Do not add packages to `pubspec.yaml` or touch files outside the allowlist —
escalate instead.

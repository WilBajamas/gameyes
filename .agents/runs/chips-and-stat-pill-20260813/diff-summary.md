# Diff Summary
Source: Week 2 task briefs items 1.5, 1.6, 1.7 (combined run) · `tech-ac.md` 2026-08-13
Date: 2026-08-14
Branch: claude/questloggd-week-2-components-ha43qm
Commit: bb9b6e596fa4b136bd1aa683c4c7d0b33adbc937

## Files created
lib/widgets/filter_count_chip.dart — `FilterCountChip`: pill capsule chip, indigo fill selected / ink08 unselected, optional trailing count, one tap callback
lib/widgets/context_chip.dart — `ContextChip`: glass pill with a required 12px leading icon and uppercase caps label, display-only, no caller yet
lib/widgets/stat_pill.dart — `StatEntry`, `StatTile` (ink08 tile form), `StatPill` (glass hero form, 2-3 pairs), and private `_StatPair` shared by both forms

## Files modified
lib/widgets/type_values_selection.dart — swapped `DefaultChoiceChip` for `FilterCountChip`; `Wrap`, title and `SizedBox` untouched
lib/widgets/multi_type_values_selection.dart — same swap; `Wrap` and title spacing untouched
lib/features/featured/presentation/widgets/library_stats.dart — the three `_buildStatTile(...)` calls in `_buildLibraryStats` replaced with `StatTile(figure:, label:)`; `_buildStatTile` and its icon/tint parameters deleted; checklist card, now-playing card, `_DashedBorderPainter` and the `// TODO` left untouched
.claude/skills/flutter-widgets/SKILL.md — catalogue table: `DefaultChoiceChip` row removed, `FilterCountChip`, `ContextChip` and `StatTile`/`StatPill` rows added

## Files deleted
lib/widgets/default_choice_chip.dart — replaced by `FilterCountChip`; both former callers migrated in this run, no `@Deprecated` shim kept

## Test files
None — testing-mode: smoke, with test authorship for the three components deferred to the human per [ALL-AC7] (revised 2026-08-14). Dev's only test-side obligation this run is the full-suite regression check below.

## Self-corrections
NONE

## Deviations from implementation plan
NONE — plan followed exactly, including the second-pass even-dimension values (context chip icon 12px, stat tile padding 14px), `Expanded` + spread operator in `StatPill`, `Flexible` held in `FilterCountChip`/`ContextChip`, and no shipped comments.

## Verification against baseline
`flutter analyze`: 0 errors, 2 warnings, 31 info (baseline: 0 errors, 2 warnings, 32 info — captured 2026-08-13T13:39:30Z). No new issue; one fewer info than baseline, consistent with deleting `default_choice_chip.dart`. Confirmed no remaining reference to `default_choice_chip.dart` or `DefaultChoiceChip` anywhere in the repo before deleting it.

`flutter test` (full suite): +265 -11, matching the recorded baseline exactly (`+265 -11 — captured 2026-08-13T13:43:00Z`). The 11 failures are the same pre-existing ones: `test/repository/tracker/tracker_repository_test.dart` (4), `test/cubit/game_detail/game_detail_cubit_test.dart` (3), `test/cubit/games/games_bloc_test.dart` (3), `test/widget_test.dart` (1). No test was weakened, skipped, deleted or added.

## Acceptance criteria status
1.5-AC1: satisfied — `default_choice_chip.dart` deleted, no `@Deprecated` shim
1.5-AC2: satisfied — `FilterCountChip` name, no `default` prefix, no collision
1.5-AC3: satisfied — fill-only `BoxDecoration`, no border/shadow
1.5-AC4: satisfied — `accentIndigo` fill when selected
1.5-AC5: satisfied — `ink08` fill when unselected
1.5-AC6: satisfied — optional count slot, `null` renders nothing, `0` renders
1.5-AC7: satisfied — `label`, `isSelected`, `onSelected`, `count` only; `typography.meta` 14/500 label
1.5-AC8: satisfied — `ConstrainedBox(minHeight: 44)` + `Center` hit-target shape from `ZoneLabel`'s `_ZoneLink`
1.5-AC9: satisfied — no padding/size/colour/style/icon/spacing parameter
1.5-AC10: satisfied — `Center(widthFactor: 1)` keeps content width inside `Wrap`; count never ellipsised
1.5-AC11: satisfied — both call sites migrated, `Wrap`/title/`SizedBox` untouched
1.6-AC1 … 1.6-AC8: satisfied — `ContextChip` per plan, `GlassSurface` reuse, required 12px icon (even-dimension delta), uppercase `pill` label, no tap/position/padding/colour parameter, no `Positioned`/`Align`/`Transform`/`Stack`, ships with no caller
1.7-AC1 … 1.7-AC9, 1.7-AC12: satisfied — `StatEntry`/`StatTile`/`StatPill`/`_StatPair` family in one file, `assert` on `StatPill`'s 2-3 length, `Expanded` layout, shared figure/label styles, `StatPill` ships with no caller
1.7-AC10, 1.7-AC11: satisfied — `library_stats.dart` migrated to `StatTile`, `_buildStatTile` deleted, `_DashedBorderPainter` and now-playing card untouched
ALL-AC1: satisfied — no outer spacing/padding parameter in any of the three new files
ALL-AC2: satisfied — no border, no `CustomPaint`/`CustomPainter`, no dash constant in any of the three new files
ALL-AC3: satisfied — every colour/radius/type/blur value from `context.tokens`, no `Theme.of`/`ColorScheme`/`Colors.*`/literal/`GoogleFonts.*`
ALL-AC4: satisfied — no `.arb` or `S` class change; no user-facing string introduced
ALL-AC5: satisfied — `pubspec.yaml` untouched
ALL-AC6: satisfied — catalogue table updated per plan
ALL-AC7: satisfied as design behaviour — no Dev-authored test file this run per the 2026-08-14 revision; full-suite regression check confirms baseline holds

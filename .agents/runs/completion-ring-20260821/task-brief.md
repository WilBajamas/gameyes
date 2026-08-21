# Task Brief
Source: `.agents/runs/completion-ring-20260821/tech-ac.md` — week 2 Stage 2 item 2.2, Completion ring
Date: 2026-08-21

## Context

Build the spec's one-anatomy, three-size completion ring as a display-only component, so the
week 3/4 Game Detail panel has a ring to reach for instead of hand-rolling one. It ships
unwired: no screen consumes it and none is to be invented.

## Testing mode

`smoke` — Rule applied: UI-only, isolated, with no shared dependencies. Justification: one
new widget, nothing below the presentation layer, no auth, payment, persistence or sync. The
tests exist to protect the value contract (clamping, truncation, the colour switch), the
caption's per-size drop and the semantics announcement — not appearance.

**Dedicated test file, decided against the `flutter-widget-test` skill:**

- `CompletionRing` — **yes**, 5 tests. It owns real behaviour a caller relies on: content
  that changes with its input (the label), an explicit documented contract (clamp,
  truncate-toward-zero, indigo below 100 and magenta only at exactly 100), conditional
  content (the caption at 80/88, dropped at 60) and accessibility (the semantics label).
- `CompletionRingPainter` — **no separate file**. It has no independent contract; its colours
  are asserted through `CompletionRing`'s file, which is the layer that owns the choice.
- `CompletionRingSize` — **no**. A closed enum of numbers. Its values are a manual device
  check (C1, C12) and must not be asserted anywhere.

**Five tests, not one per `Verify:` line.** Independent conditions that fail on the same
regression are asserted in one pump. The exact list is in `code-plan.md`. A file that grows
past five is a signal to cut, not to keep going — the reference files are
`context_chip_test.dart` (1 test) and `stat_pill_test.dart` (2), and item 2.1's far larger
game card landed at 10.

**Not tested, verified on device instead** (hand to QA, do not write a test for either):

- Everything `tech-ac.md` marks `manual device check`: C1's three box numbers, C4's arc
  geometry (12 o'clock start, clockwise, proportional sweep, nothing painted at 0), C9's
  stroke weight and cap shape, C12's type steps, C13's caption size.
- C12's inline step is **14, not 15** — see `## Constraints`. QA verifies 14.
- C7's "no nullable or indeterminate input" and C10's "no error path" and C15's "no callback
  parameter" are compile-time/code-review facts, not tests. The only interaction assertion
  worth having is that no tap handler exists, and that is visible in the constructor — do not
  write a tap test that asserts nothing happened.

**Binding test rules** (`flutter-widget-test`, revised four times — read it in full; do not
pattern-match off `status_chip_test.dart` or `cover_tile_test.dart`, both of which predate
the current rules):

- No assertion on a dimension, stroke, radius, gap, offset or position — ever, including
  every number named in C1, C9, C12 and C13.
- No golden test, no `matchesGoldenFile`, whatever C4 and C9 imply about painted appearance.
- Exactly three colour assertions in the run, all in the one colour test, all naming a token
  (`AppColorTokens.dark.accentIndigo` / `.accentMagenta` / `.ink12`) — never a hex literal.
- Do **not** pre-resolve the theme or tokens in `setUpAll`, and do not use
  `runZonedGuarded`. `AppColorTokens.dark` is a plain const and is referenced directly; pass
  `buildDarkTheme()` into the pumped widget as `context_chip_test.dart` does.
- No `Completer`, no fake image bytes, no arbitrary delays, no manually invoked builders.

## File allowlist

### CREATE NEW

`lib/widgets/completion_ring.dart` — `CompletionRingSize` (closed three-member enum with the
per-size box, stroke, centre type size and caption flag), `CompletionRing` (the widget), and
`CompletionRingPainter` (track + arc). One flat file, no folder, no `enum/` subfolder — see
`tdd.md` Design decision 2.

### MODIFY EXISTING

`.claude/skills/flutter-widgets/SKILL.md` — catalogue table: add one `CompletionRing` row.
Do not edit any rule text in that file.

### TEST FILES

`test/widget/components/completion_ring_test.dart` — 5 tests: truncation, clamping, the
indigo→magenta switch over an unchanged track, the caption's per-size drop, and the
semantics label.

No `.arb` edits and no localisation regeneration in this run — the semantics label reuses the
existing `completed_percentage` key.

## Implementation plan

Step 1: `lib/widgets/completion_ring.dart` — the enum, the widget and the painter, in that
order in the file. No comments in this file, none. The clamp and the truncation each appear
exactly once, at the top of `build`.

Step 2: `.claude/skills/flutter-widgets/SKILL.md` — add the `CompletionRing` catalogue row.

Step 3: `test/widget/components/completion_ring_test.dart` — the 5 tests, in the order listed
in `code-plan.md`.

Final step: run `flutter analyze` and `flutter test` and compare against
`orchestrator-state.md`, quoted verbatim — `Analyzer baseline: 0 errors, 2 warnings, 31 info
(33 issues) — captured 2026-08-21` and `Test baseline: +284 -10 — captured 2026-08-21`, with
pre-existing failures in `test/repository/tracker/tracker_repository_test.dart` (4),
`test/cubit/game_detail/game_detail_cubit_test.dart` (3) and
`test/cubit/games/games_bloc_test.dart` (3). Those ten stay red and are not yours. Only a new,
in-scope failure is yours to fix or escalate.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: 2.2-C1 … 2.2-C15

## Constraints

- **The widget file carries no comments at all.** Not a header, not a `///`, not a note above
  the painter or a token lookup — and this includes `CompletionRingPainter`, which is not
  exempt for being a `CustomPainter`. If a line needs explaining, rename it
  (`flutter-widgets`, `execution.md`).
- **Three sizes, fixed, closed.** No free-form diameter, no `double size` parameter, no
  fourth member. A caller needing another diameter is a spec change that escalates (C1).
- **No caller, no screen.** Nothing outside the allowlist is touched. Do not wire the ring
  into Game Detail, Home, a shimmer or a demo screen, and do not add one "to prove it works".
- **`value` is `double`, required and non-nullable.** No default, no `int?`, no
  indeterminate/unknown mode, no loading state (C7).
- **Clamp once, truncate once.** `value.clamp(0, 100).toDouble()` and `.truncate()` each
  appear exactly once, at the top of `build`; the painter fraction, the visible label, the
  semantics label and the colour choice all read from those two locals. Do not re-clamp
  inside the painter and do not round anywhere — `100%` must mean exactly 100 (C5, C6, C8).
- **No assert, no throw, no debug guard on the value.** Out-of-range is ordinary input.
- **Display-only.** No `onTap`, no `GestureDetector`, no `InkWell`, no `MouseRegion`, no
  `StatefulWidget`, no animation or tween. The 44px minimum-target rule does not apply (C15).
- **No error, warning or failure path.** Magenta appears only as the 100% close; red never
  enters this component (C10).
- **The centre type step is 14 / 18 / 22** — 14 at inline is a deliberate even-number
  rounding of the spec's 15 (`flutter-widgets`: dimensions and code-declared font sizes are
  even; the widest label `100%` must clear the 44 inner circle). All three come from
  `tokens.typography.statFigure.style.copyWith(fontSize:)` so the face, weight, line height
  and colour stay identical across sizes. Do not introduce a second display token for one
  size.
- **Every dimension the widget writes is even**: boxes 60/80/88, strokes 6/8, inset 2, font
  sizes 14/18/22. Values derived at runtime (the centre-line radius, an arc sweep) are not
  "written" and are exempt.
- **Outlines are solid.** The track is one continuous stroke — no dash, no dot, no
  `computeMetrics` path extraction. Do not copy `_DashedBorderPainter` from
  `lib/features/featured/presentation/widgets/library_stats.dart`, do not import from it, and
  do not fix it — it belongs to item 2.8.
- **`shouldRepaint` compares every painted field.** `=> false` (as `_DashedBorderPainter`
  does) would freeze the arc at its first value.
- **Nothing is painted at 0.** Return before `drawArc` when the fraction is 0, otherwise the
  round cap leaves a dot on an untouched track (C4).
- **No spacing of its own.** No outer padding or margin, no padding/gap constructor
  parameter. Padding inside the ring's own box is its anatomy and is fine.
- **`Expanded` vs `Flexible`:** neither. The centre stack is a `Column` with
  `MainAxisSize.min` inside a fixed square — the hug-content case. Do not wrap the label or
  the caption in `Expanded`.
- All colours and text styles come from `context.tokens`; no literal hex, no `Colors.*`, no
  `Theme.of(context)`.
- The semantics label is `S.current.completed_percentage('$percentage')` — reuse the existing
  key. Do not add an `.arb` key, do not run `intl_utils`, and never `flutter gen-l10n`. The
  visible label stays a plain `'$percentage%'` interpolation, matching `CriticBadge`'s
  `'${score.round()}'`.
- Import order: dart, then package (flutter → third-party → project), then relative (only
  `part` / `generated/l10n.dart`), alphabetised within each group.
- Test folders are layer-based (`test/widget/components/`), never mirrored from `lib/`.
- Do not touch `library_stats.dart`, `cover_tile.dart`, `status_chip.dart`, `stat_pill.dart`,
  `progress_dots.dart`, any `game_card/` file, or any `.arb` file.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make tests
pass. Do not add packages to `pubspec.yaml` or touch files outside the allowlist — escalate
instead.

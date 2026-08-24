# Requirements — Week 2 Stage 2 item 2.8: Async states, shared empty state

Source: `.agents/week-2-task-briefs.md` item 2.8, against
`.agents/references/system-foundation-specs.md` §3.2 "Async states" row.
Scope decisions below were settled by the human at this run's Phase 0 gate and
are not open questions.

## FR-2.8.1 — A shared empty-state component

The app has no shared empty-state component. Build one, in `lib/widgets/`.

§3.2's Async states row specifies the empty half as: **"Empty = art-deep card,
glyph, caps display headline, one line, one action; empty states recruit, they
never apologise."**

Anatomy, from that sentence:
- an **art-deep card** (the deep art surface, at the standard card radius),
- a **glyph**,
- a **headline in caps**, in the display type role,
- **one line** of supporting copy,
- **one action**.

The tone rule ("recruit, never apologise") is a copy constraint on every string
this component renders: the copy invites the next step, it does not apologise for
absence.

## FR-2.8.2 — Scope boundary: empty only

The **loading/shimmer half** of the same §3.2 row is explicitly OUT of scope and
already correct. Do not change any shimmer, `Skeletonizer`, or loading branch.
Error states are also out of scope — item 2.7 shipped those.

## FR-2.8.3 — Rewire five sites

The component replaces the improvised empty state at each of these, verified on
disk at Phase 0:

1. `lib/features/games/presentation/screens/games_screen.dart:85-95` — currently
   renders `ErrorRetryWidget(text: S.current.no_results_found)` for
   `GamesStatus.empty`. This is an empty state wearing an **error** component.
   `ErrorRetryWidget` itself stays — its two other callers in this same file
   (`GamesStatus.failed`, `GamesNextPageStatus.failed`) are genuine error states
   and must be left exactly as they are.
2. `lib/features/featured/presentation/widgets/library_stats.dart:270-320` — the
   empty now-playing card, drawn with a `_DashedBorderPainter` and
   `BorderStyle.none, // We want dashed border`. The dashed outline violates the
   standing **"outlines are always solid"** convention (established at item 1.4,
   recorded in `system-foundation-specs.md` §0 item 6 and the `flutter-widgets`
   skill). `_DashedBorderPainter` becomes unreferenced once this card is replaced.
3. `lib/features/featured/presentation/widgets/critics_grid.dart:147-164` — a
   160px `Container` on `surfaceContainerLow` with the **hardcoded, untranslated
   English string** `'No critic reviews found'`. No glyph, no action.
4. `lib/features/featured/presentation/widgets/countdown_releases.dart:83-101` —
   the same improvised recipe at 170px, hardcoded `'No releases in this period'`.
5. `lib/features/featured/presentation/screens/featured_screen.dart:199-201` —
   currently `SizedBox.shrink()`: when the countdown section has no data it
   **vanishes silently**. The human ruled at the Phase 0 gate that this is in
   scope and must recruit rather than disappear. Note this is a visible change to
   a shipped screen that no design doc specifies — a deliberate human decision,
   recorded here so no later phase reads it as drift.

Every string these sites render must be **localised** (`.arb` + `S.current`),
including the two that are hardcoded English today. Sites 3, 4 and 5 need copy
that does not exist yet; write criteria for it under the "recruit, never
apologise" rule.

## FR-2.8.4 — Out of scope, deliberately

Two further improvised empty states were found at Phase 0 and the human ruled
them OUT of this run — do not touch them, and do not write criteria for them:
- `tracker_tasks_section.dart:42-49` (bare `Text`, and its action button is a
  sibling rendered in *both* the empty and non-empty branches, so folding it in
  would change that screen's non-empty layout),
- `tracker_game_detail_section.dart:147-151` (bare `Text`, no action).

## FR-2.8.5 — The convention doc this supersedes

`.claude/skills/flutter-widgets/SKILL.md:218-220` currently reads: "**Empty
state** — no dedicated `EmptyStateWidget` today. Use `ErrorRetryWidget` with
custom `text` when retry is meaningful; otherwise a plain centred `Text`,
localised, `textAlign: TextAlign.center`." That workaround is exactly what this
item removes, so the note must be replaced by one naming the new component, and
the skill's widget catalogue updated.

**The checklist is wrong about where this note lives** — it says
`project-conventions.md`. It was moved into the skill by the 2026-08-07 skills
restructuring; `project-conventions.md:11` now only points at the skill. Update
the skill. This is the fourth time a Stage 2 checklist bullet has been wrong
about the code or docs it names.

## Constraints that already bind this run

- **Outlines are always solid** (item 1.4). No dashed border may survive.
- §2's colour law: no `Colors.*` literals, tokens only. Sites 3 and 4 currently
  reach for `colorScheme.surfaceContainerLow` / `onSurfaceVariant` rather than
  app tokens.
- Widgets carry **no comments at all**.
- Widget tests never assert dimensions, gaps, radii or positions; colour
  assertions must name a token; never a golden test. `context_chip_test.dart` and
  `stat_pill_test.dart` are the reference files for shape and length.
- §3's type steps have collided with "dimensions are even numbers" at 15px three
  times (items 1.9, 2.2, 2.5). No 15px token exists and minting one is a
  foundations change. If the display/caps headline step lands on an odd value,
  raise it rather than silently inventing a token.
- A criterion phrased about position or pixels usually has a checkable form —
  reach for a count, or the absence of a parameter that could break the rule,
  before marking something manual-only.

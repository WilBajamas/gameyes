# Diff Summary
Source: `tech-ac.md` — Week 3 item 3.1 (D1–D5, `orchestrator-state.md`)
Date: 2026-08-26
Branch: feature/library-foundations
Commit: PENDING

## Files created
NONE

## Files modified
lib/config/theme/tokens/app_color_tokens.dart — added `surfaceArt` (`Color(0xFF2F3782)`) and `surfaceArtDeep` (`Color(0xFF7D4EE0)`) as required `Color` fields, in the `// ** Surfaces` group immediately after `surfaceToast`, carried through `dark`, `copyWith` and `lerp` in the same relative position at all five sites. Inline literals only; no private const introduced or reused; no comment added; no existing field changed.
.agents/references/system-foundation-specs.md — §2.2 rewritten as a two-row table stating both flat fills, their roles separately, and why violet is admissible as a surface here (`3.1-AC10`, `3.1-AC12a`); §2 rule 4 records the dated violet-as-surface carve-out and points at §2.2 (`3.1-AC11`); §2 rule 7's `(§5)` corrected to `(§6)`; §3.2 Game card row drops the 50% desaturation, keeps the scrim; §3.3 Cover tile row drops the filter, keeps the flat indigo wash (`3.1-AC14`); §6 register row fills in both hexes (`3.1-AC13`); §7.1 replaces "never a surface" with the same dated carve-out (`3.1-AC12`).
.agents/references/library-design-conventions.md — §3 Playing's dot becomes `accentIndigo` `#5865f2` with the shipped ink-reversion carve-out on the filled pill (`3.1-AC16`); §5 drops the filter, keeps the veil and `--surface-art` fill (`3.1-AC15`); §11 recruit card becomes a flat `--surface-art-deep` fill with a rewritten no-decorative-circle reason (`3.1-AC18`); §12 widens the indigo ration to the chip dot, grid pill and list status line (`3.1-AC17`).
.agents/references/home-screen-design-conventions.md — line 51 drops the filter, keeps the veil, its stops, purpose sentence and 2026-07-30 note; line 123 keeps the veil declared app-wide, drops the filter (`3.1-AC19`); line 83 back-reference now names the veil only (`3.1-AC20`).
.agents/references/game-detail-design-conventions.md — line 36 drops the filter, keeps the "app-wide cover treatment" reference (`3.1-AC21`). Lines 41 and 162 untouched.
.agents/references/onboarding-welcome-design-spec.md — line 85 drops the filter, keeps the top-to-bottom indigo→canvas tint (`3.1-AC21`). Line 67 (`saturate(.4)`) untouched.

## Test files
None — testing-mode: none (D5). `test/widget/theme/app_tokens_test.dart` not opened, not edited.

## Self-corrections
NONE

## Deviations from implementation plan
NONE — all 17 steps followed as written.

## Step 2 — source-read verification (`3.1-AC4`)

Read `copyWith` and `lerp` bodies back after the edit:
- `copyWith` return block: `surfaceArt: surfaceArt ?? this.surfaceArt,` and
  `surfaceArtDeep: surfaceArtDeep ?? this.surfaceArtDeep,` — same `x ?? this.x`
  form as every neighbouring field (e.g. `surfaceToast: surfaceToast ?? this.surfaceToast,`).
- `lerp`: `surfaceArt: Color.lerp(a.surfaceArt, b.surfaceArt, t)!,` and
  `surfaceArtDeep: Color.lerp(a.surfaceArtDeep, b.surfaceArtDeep, t)!,` — same
  `Color.lerp(a.x, b.x, t)!` form as every neighbouring field.

Both fields are present, correctly wired, in both bodies. No runtime check backs
this (D5); this read is the verification.

## Verification against baseline
`flutter analyze` — 30 issues (0 errors, 2 warnings, 28 info), matches recorded
baseline exactly. The two `_TaskReminder` warnings are the pre-existing deliberate
pair.
`flutter test` — `+361 -10`, matches recorded baseline exactly. The 10 failures are
the pre-existing `tracker_repository_test` (4), `game_detail_cubit_test` (3),
`games_bloc_test` (3).
`git status --porcelain -- test/` — empty, confirming no test-file diff (`3.1-AC23`).
`grep -rn "saturate(.5) contrast(1.05)" .agents/references/` — zero hits.
`grep -rn "desaturat" .agents/references/` — exactly four hits: `library-design-conventions.md:179`, `home-screen-design-conventions.md:154`, `game-detail-design-conventions.md:162` (production notes) and `game-detail-design-conventions.md:41` (rejected hero-ramp option) (`3.1-AC22`).

## Acceptance criteria status
3.1-AC1: satisfied
3.1-AC2: satisfied
3.1-AC3: satisfied
3.1-AC4: satisfied — verified by source read, see above
3.1-AC5: satisfied
3.1-AC10: satisfied
3.1-AC11: satisfied
3.1-AC12: satisfied
3.1-AC12a: satisfied
3.1-AC13: satisfied
3.1-AC14: satisfied
3.1-AC15: satisfied
3.1-AC16: satisfied
3.1-AC17: satisfied
3.1-AC18: satisfied
3.1-AC19: satisfied
3.1-AC20: satisfied
3.1-AC21: satisfied
3.1-AC22: satisfied
3.1-AC23: satisfied

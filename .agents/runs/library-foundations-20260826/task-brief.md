# Task Brief
Source: `tech-ac.md` — Week 3 item 3.1 (Stage 3 foundations; D1–D4 in `orchestrator-state.md`)
Date: 2026-08-26

## Context

Mint `surfaceArt` and `surfaceArtDeep` on `AppColorTokens` as flat, unused colour
tokens, and correct the five reference docs whose stale colour law and rejected
cover filter keep re-seeding bad criteria into later items.

## Testing mode

`coverage` — Rule applied: shared utility used by 3+ features (`AppColorTokens` is
the app-wide theme extension). Justification: no new test file and no widget test —
no widget or screen changes, so nothing qualifies for one under
`flutter-widget-test`. Only the four sites named by `3.1-AC6` – `3.1-AC9` in the
existing token-contract test change.

## File allowlist

### CREATE NEW
NONE

### MODIFY EXISTING
`lib/config/theme/tokens/app_color_tokens.dart` — add `surfaceArt` and
`surfaceArtDeep` as required `Color` fields carried through the constructor, the
`// ** Surfaces` field group, `dark`, `copyWith` and `lerp`.
`.agents/references/system-foundation-specs.md` — §2.2, §2 rules 4 and 7, §3.2,
§3.3, §6 register row, §7.1.
`.agents/references/library-design-conventions.md` — §3, §5, §11, §12.
`.agents/references/home-screen-design-conventions.md` — lines 51, 83, 123.
`.agents/references/game-detail-design-conventions.md` — line 36 only.
`.agents/references/onboarding-welcome-design-spec.md` — line 85 only.

### TEST FILES
`test/widget/theme/app_tokens_test.dart` — pins both new hexes, adds `surfaceArt`
to the violet-exclusion list while excluding `surfaceArtDeep` with a written
reason, leaves the distinctness `Set` at three members with a written reason, and
adds both tokens to `_allColors()`.

Nothing else. No widget, no screen, no other test, no `pubspec.yaml` change, no
generated file (there is none to generate here).

## Implementation plan

Step 1: `lib/config/theme/tokens/app_color_tokens.dart` — add `surfaceArt` then
`surfaceArtDeep` (`Color`, required, inline literals `Color(0xFF2F3782)` and
`Color(0xFF7D4EE0)` in `dark`) in the same relative position in all five sites,
immediately after `surfaceToast`. No private const is introduced or reused for
either; no existing line changes; no comment is added. (`3.1-AC1` – `3.1-AC5`)

Step 2: `test/widget/theme/app_tokens_test.dart` — in the surfaces group, assert
both new values, and add the written reason beside the distinctness `Set` at
`:44-49` explaining that `surfaceArt` deliberately aliases `surfaceIndigoPanel` and
is kept out. The `Set` keeps exactly its three members and `expect(distinct.length,
3)`. (`3.1-AC6`, `3.1-AC9` — see `tdd.md` for why adding it would pass silently)

Step 3: same file — in the violet test at `:97-111`, add `colors.surfaceArt` to
`surfacesAndAccents` and add the written reason that `surfaceArtDeep` is excluded
because D1 (2026-08-26) ratified violet as a surface in exactly that one place.
Do not weaken or delete the assertion. (`3.1-AC7`)

Step 4: same file — append `colors.surfaceArt` and `colors.surfaceArtDeep` to
`_allColors()` at `:493+`, in class order. (`3.1-AC8`)

Step 5: `system-foundation-specs.md` §2.2 — replace the prose with the resolved
values, both stated as flat fills, with the two roles stated separately and
explicitly not as a pair or a ramp. (`3.1-AC10`)

Step 6: same file §2 — amend rule 4 to record violet ratified as a surface in
exactly one place, dated, keeping "no fourth loud accent" and noting that violet as
a status hue is still §7.1's open decision; and change rule 7's "(§5)" to "(§6)".
(`3.1-AC11`, half of `3.1-AC13`)

Step 7: same file §7.1 — replace "never a surface" with the same dated carve-out.
Leave the options `1a`/`1b`/`1c` and everything else in §7.1 alone. (`3.1-AC12`)

Step 8: same file §6 register — put both hexes in the `--surface-art` /
`--surface-art-deep` row. Leave register line 327 (violet/cyan as status dots)
standing. (`3.1-AC13`)

Step 9: same file — §3.2 Game card row: drop the 50% desaturation, keep the
indigo→canvas scrim. §3.3 Cover tile row: drop `saturate(.5) contrast(1.05)`, keep
the flat indigo wash. (`3.1-AC14`)

Step 10: `library-design-conventions.md` §3 — Playing's dot becomes `accentIndigo`
`#5865f2`, with the shipped carve-out that on the filled Playing pill the dot
reverts to ink. (`3.1-AC16`)

Step 11: same file §5 — drop the filter; keep the veil and the `--surface-art`
cover fill so §6's "the same veil" still resolves. (`3.1-AC15`)

Step 12: same file §11 — the recruit card is a flat `--surface-art-deep` fill, and
the "no decorative oversized circle" reason no longer credits a gradient. (`3.1-AC18`)

Step 13: same file §12 — widen the indigo ration to admit the Playing dot (§3), the
grid cover's status pill (§5) and the list row's status line (§6). (`3.1-AC17`)

Step 14: `home-screen-design-conventions.md` — line 51: drop the filter, keep the
veil, its exact stops, the purpose sentence and the 2026-07-30 recomputation note.
Line 123: the app-wide sentence declares the veil app-wide and no longer declares
the filter. (`3.1-AC19`)

Step 15: same file line 83 — the back-reference names the veil only, not a saturate
treatment. (`3.1-AC20`)

Step 16: `game-detail-design-conventions.md` line 36 — drop the filter, keep the
"app-wide cover treatment" reference. Do not touch line 41 or line 162. (`3.1-AC21`)

Step 17: `onboarding-welcome-design-spec.md` line 85 — drop the filter, keep the
top-to-bottom indigo→canvas tint. **Do not touch line 67** (`saturate(.4)`).
(`3.1-AC21`)

Step 18: sweep `.agents/references/` for `saturate(.5) contrast(1.05)` (expect
zero) and for `desaturat` (expect exactly four: `library-design-conventions.md:179`,
`home-screen-design-conventions.md:154`, `game-detail-design-conventions.md:162`,
`game-detail-design-conventions.md:41`). Any other hit means a site was missed.
(`3.1-AC22`)

Step 19: run `flutter analyze` and `flutter test` and compare against
`orchestrator-state.md` verbatim — `Analyzer baseline: 0 errors, 2 warnings, 28
info (30 issues total)` and `Test baseline: +361 -10`, the 10 being
`tracker_repository` (4), `game_detail_cubit` (3), `games_bloc` (3). The suite is
expected at +361 plus the new token assertions, -10 unchanged. **28 total analyzer
issues means the deliberate `_TaskReminder` pair was "fixed" — that is a
regression, not a win.** (`3.1-AC23`)

No `build_runner` step: nothing here is annotated source. No `.arb` change: no new
user-facing string.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: `3.1-AC1` – `3.1-AC23` (all).

## Constraints

- **Locate every doc edit by its quoted text, not by line number.** The `tech-ac.md`
  line numbers are pre-edit; §2.2 grows into a table and shifts every later line in
  `system-foundation-specs.md`.
- **The indigo→canvas veil survives at every one of the eight filter sites.** Only
  the desaturation goes (D4). Make the smallest edit that removes the wrong clause
  and leaves the surrounding sentence true, in each doc's existing table/prose style.
- **`AppColorTokens` stays uniform** — every field is a `Color` or an existing token
  group. No `Gradient`, `List<Color>` or stop list (D3, `system-foundation-specs.md`
  §2 rule 6).
- **Do not bind either new token to a private const** (`_statusViolet`,
  `_accentIndigo`) and do not refactor `surfaceIndigoPanel`'s literal. `tdd.md`
  explains why: §7.1's status-hue decision is still open and would otherwise move a
  ratified surface. Inline literals, matching the Surfaces group and the
  `surfaceToast` alias precedent.
- **No comment in `app_color_tokens.dart`.** The written reasons live in the token
  test and in `system-foundation-specs.md` §2.2. Comments elsewhere: plain English,
  the why, few — per `execution.md`.
- **Do not weaken the violet assertion at `:97-111` or the distinctness `Set` at
  `:44-49`.** Both keep asserting what they assert today; see `tdd.md` for the
  reason each is handled differently. Do not add either new token to the `Set`.
- The token test is a token-contract test, not a widget test — its exact-value
  assertions are the contract. Do not simplify them away, and do not remove the
  existing `setUpAll` resolution.
- **Never a golden test**, whatever a criterion says about appearance
  (`execution.md`). The visual read of the two fills is a manual check.
- Nothing under `lib/` other than `app_color_tokens.dart` and no test other than
  `app_tokens_test.dart` may be modified (`3.1-AC23`). If the analyzer points at a
  file outside the allowlist, escalate rather than edit it.
- Any design question that would touch a screen or a widget belongs to a later
  item — record it, do not build it.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make
tests pass. Do not add packages to `pubspec.yaml` or touch files outside the
allowlist — escalate instead.

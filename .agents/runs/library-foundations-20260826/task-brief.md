# Task Brief
Source: `tech-ac.md` — Week 3 item 3.1 (Stage 3 foundations; D1–D5 in `orchestrator-state.md`)
Date: 2026-08-26
Revised: 2026-08-26 — D5 (Phase 3 design gate) removes
`test/widget/theme/app_tokens_test.dart` from this item's scope entirely. Testing
mode, file allowlist, plan steps and constraints are corrected in place; the plan
drops from 19 steps to 17. No other decision changes.

## Context

Mint `surfaceArt` and `surfaceArtDeep` on `AppColorTokens` as flat, unused colour
tokens, and correct the five reference docs whose stale colour law and rejected
cover filter keep re-seeding bad criteria into later items.

## Testing mode

`none` — **no test file is created or modified in this item (D5).**

Justification: the change adds two colour constants that nothing consumes, plus
prose edits to five reference docs. No runtime behaviour, no widget, no screen, so
per `flutter-widget-test` nothing qualifies for a dedicated test file. The one
existing test that owns this contract — `test/widget/theme/app_tokens_test.dart` —
was taken out of scope by human decision D5 at the Phase 3 gate, which accepts as a
stated trade-off that both new tokens ship with zero coverage (`tech-ac.md
## Retired criteria`). `AppColorTokens` is an app-wide shared utility, so the
`coverage` rule would ordinarily match; D5 overrides it. `3.1-AC1` – `3.1-AC5` are
verified by a source read of `app_color_tokens.dart` instead — see step 2, which is
the only thing standing in for the retired lerp-coverage check.

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
NONE. `test/widget/theme/app_tokens_test.dart` is **out of scope (D5)** — do not
open it, do not add an assertion to it, do not touch `_allColors()`, the
distinctness `Set` or the violet-exclusion list. No test file anywhere changes.

Nothing else. No widget, no screen, no test file at all, no `pubspec.yaml` change,
no generated file (there is none to generate here).

## Implementation plan

Step 1: `lib/config/theme/tokens/app_color_tokens.dart` — add `surfaceArt` then
`surfaceArtDeep` (`Color`, required, inline literals `Color(0xFF2F3782)` and
`Color(0xFF7D4EE0)` in `dark`) in the same relative position in all five sites,
immediately after `surfaceToast`. No private const is introduced or reused for
either; no existing line changes; no comment is added. (`3.1-AC1` – `3.1-AC5`)

Step 2: same file — **source-read verification, and it is a real step, not a
formality.** Read the `copyWith` and `lerp` bodies back and confirm each new field
appears in both, in the same form as its neighbours (`x ?? this.x` and
`Color.lerp(a.x, b.x, t)!`). Nothing at runtime checks this: the `_allColors()`
lerp coverage that would have backed it is out of scope under D5, so a green suite
proves nothing here. Record the confirmation explicitly in `diff-summary.md` — QA
must read it, not infer it. (`3.1-AC4`)

Step 3: `system-foundation-specs.md` §2.2 — replace the prose with the resolved
values, both stated as flat fills, with the two roles stated separately and
explicitly not as a pair or a ramp. **Also state why violet is admissible as a
surface here** — rule 4 bars violet as a fourth loud *accent*, and a large flat
non-interactive block on one empty state is not that. With no test edit in this
item, §2.2 is the only place in the repo that reason exists, so it cannot be left
out. (`3.1-AC10`, `3.1-AC12a`)

Step 4: same file §2 — amend rule 4 to record violet ratified as a surface in
exactly one place, dated, pointing at §2.2 for the reason rather than restating it,
keeping "no fourth loud accent" and noting that violet as a status hue is still
§7.1's open decision; and change rule 7's "(§5)" to "(§6)".
(`3.1-AC11`, `3.1-AC12a`, half of `3.1-AC13`)

Step 5: same file §7.1 — replace "never a surface" with the same dated carve-out,
cross-referencing §2.2. Leave the options `1a`/`1b`/`1c` and everything else in
§7.1 alone. (`3.1-AC12`, `3.1-AC12a`)

Step 6: same file §6 register — put both hexes in the `--surface-art` /
`--surface-art-deep` row. Leave register line 327 (violet/cyan as status dots)
standing. (`3.1-AC13`)

Step 7: same file — §3.2 Game card row: drop the 50% desaturation, keep the
indigo→canvas scrim. §3.3 Cover tile row: drop `saturate(.5) contrast(1.05)`, keep
the flat indigo wash. (`3.1-AC14`)

Step 8: `library-design-conventions.md` §3 — Playing's dot becomes `accentIndigo`
`#5865f2`, with the shipped carve-out that on the filled Playing pill the dot
reverts to ink. (`3.1-AC16`)

Step 9: same file §5 — drop the filter; keep the veil and the `--surface-art`
cover fill so §6's "the same veil" still resolves. (`3.1-AC15`)

Step 10: same file §11 — the recruit card is a flat `--surface-art-deep` fill, and
the "no decorative oversized circle" reason no longer credits a gradient. (`3.1-AC18`)

Step 11: same file §12 — widen the indigo ration to admit the Playing dot (§3), the
grid cover's status pill (§5) and the list row's status line (§6). (`3.1-AC17`)

Step 12: `home-screen-design-conventions.md` — line 51: drop the filter, keep the
veil, its exact stops, the purpose sentence and the 2026-07-30 recomputation note.
Line 123: the app-wide sentence declares the veil app-wide and no longer declares
the filter. (`3.1-AC19`)

Step 13: same file line 83 — the back-reference names the veil only, not a saturate
treatment. (`3.1-AC20`)

Step 14: `game-detail-design-conventions.md` line 36 — drop the filter, keep the
"app-wide cover treatment" reference. Do not touch line 41 or line 162. (`3.1-AC21`)

Step 15: `onboarding-welcome-design-spec.md` line 85 — drop the filter, keep the
top-to-bottom indigo→canvas tint. **Do not touch line 67** (`saturate(.4)`).
(`3.1-AC21`)

Step 16: sweep `.agents/references/` for `saturate(.5) contrast(1.05)` (expect
zero) and for `desaturat` (expect exactly four: `library-design-conventions.md:179`,
`home-screen-design-conventions.md:154`, `game-detail-design-conventions.md:162`,
`game-detail-design-conventions.md:41`). Any other hit means a site was missed.
(`3.1-AC22`)

Step 17: run `flutter analyze` and `flutter test` and compare against
`orchestrator-state.md` verbatim — `Analyzer baseline: 0 errors, 2 warnings, 28
info (30 issues total)` and `Test baseline: +361 -10`, the 10 being
`tracker_repository` (4), `game_detail_cubit` (3), `games_bloc` (3). **The expected
result is exactly `+361 -10`, unchanged** — no test is added, changed or removed, so
any movement in either number is a regression to investigate, not a win. **28 total
analyzer issues means the deliberate `_TaskReminder` pair was "fixed" — also a
regression.** Also confirm `git status` shows no diff under `test/`. (`3.1-AC23`)

No `build_runner` step: nothing here is annotated source. No `.arb` change: no new
user-facing string.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: `3.1-AC1` – `3.1-AC5`, `3.1-AC10` – `3.1-AC23`, plus `3.1-AC12a`.
`3.1-AC6` – `3.1-AC9` are **retired by D5** and live in `tech-ac.md
## Retired criteria` — do not implement them.

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
- **No comment in `app_color_tokens.dart`.** The written reason for the two
  duplicated hexes lives solely in `system-foundation-specs.md` §2.2 (`3.1-AC12a`) —
  there is no longer a test carrying any part of it. Comments elsewhere: plain
  English, the why, few — per `execution.md`.
- **No test file may be touched at all, `test/widget/theme/app_tokens_test.dart`
  included (D5, `3.1-AC23`).** A test diff of any size fails this item. If something
  looks like it needs a test change, escalate — do not make it. The two new tokens
  ship uncovered on purpose.
- **Never a golden test**, whatever a criterion says about appearance
  (`execution.md`). The visual read of the two fills is a manual check.
- Nothing under `lib/` other than `app_color_tokens.dart` may be modified
  (`3.1-AC23`). If the analyzer points at a file outside the allowlist, escalate
  rather than edit it.
- Any design question that would touch a screen or a widget belongs to a later
  item — record it, do not build it.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files —
neither to make a test pass nor for any other reason. Do not add packages to
`pubspec.yaml` or touch files outside the allowlist — escalate instead.

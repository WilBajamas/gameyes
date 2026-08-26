# Code Plan
Source: `tech-ac.md` — Week 3 item 3.1 (D1–D5 in `orchestrator-state.md`)
Date: 2026-08-26
Revised: 2026-08-26 — D5. See `## Approved feedback delta` at the foot, which is
authoritative wherever it conflicts with anything above it.

## CREATE NEW

NONE.

## MODIFY EXISTING

### lib/config/theme/tokens/app_color_tokens.dart

Five insertion points, same relative position in each — immediately after
`surfaceToast`. No other line changes; no private const added or reused.

```dart
  const AppColorTokens({
    required this.canvas,
    required this.surfaceRaised,
    required this.surfaceIndigoPanel,
    required this.surfaceMagentaPanel,
    required this.surfaceTabChrome,
    required this.surfaceToast,
    required this.surfaceArt,        // new
    required this.surfaceArtDeep,    // new
    required this.accentIndigo,
    // ...unchanged

  // ** Surfaces
  final Color canvas;
  final Color surfaceRaised;
  final Color surfaceIndigoPanel;
  final Color surfaceMagentaPanel;
  final Color surfaceTabChrome;
  final Color surfaceToast;
  final Color surfaceArt;            // new
  final Color surfaceArtDeep;        // new

  static const AppColorTokens dark = AppColorTokens(
    // ...
    surfaceToast: Color(0xFF2E3236),
    surfaceArt: Color(0xFF2F3782),      // new — same value as surfaceIndigoPanel
    surfaceArtDeep: Color(0xFF7D4EE0),  // new — same value as statusViolet
    accentIndigo: _accentIndigo,
    // ...

  AppColorTokens copyWith({
    // ...
    Color? surfaceToast,
    Color? surfaceArt,
    Color? surfaceArtDeep,
    // ...
  }) {
    return AppColorTokens(
      // ...
      surfaceToast: surfaceToast ?? this.surfaceToast,
      surfaceArt: surfaceArt ?? this.surfaceArt,
      surfaceArtDeep: surfaceArtDeep ?? this.surfaceArtDeep,
      // ...

  static AppColorTokens lerp(AppColorTokens a, AppColorTokens b, double t) {
    return AppColorTokens(
      // ...
      surfaceToast: Color.lerp(a.surfaceToast, b.surfaceToast, t)!,
      surfaceArt: Color.lerp(a.surfaceArt, b.surfaceArt, t)!,
      surfaceArtDeep: Color.lerp(a.surfaceArtDeep, b.surfaceArtDeep, t)!,
      // ...
```

The `// new` markers above are for this review only — **no comment is written into
the file** (see `task-brief.md ## Constraints`).

The `copyWith` and `lerp` blocks are the two that nothing checks at runtime under
D5. `task-brief.md` step 2 is a source read of exactly these two bodies
(`3.1-AC4`).

### .agents/references/system-foundation-specs.md

§2 rule 4 — before:

```text
4. **No fourth loud accent.** Violet `#7d4ee0` exists inside `--gradient-mesh` only; it is not a
   UI colour until ratified.
```

after:

```text
4. **No fourth loud accent.** Indigo, magenta and cyan are the set; nothing joins them. Violet
   `#7d4ee0` was ratified 2026-08-26 as a **surface** in exactly one place — `--surface-art-deep`
   — and nowhere else. It is not an accent; §2.2 states why a surface is not an accent. Violet as
   a *status hue* is still the open decision in §7.1.
```

§2 rule 7 — `must be logged (§5)` → `must be logged (§6)`.

§2.2 — before:

```text
### 2.2 Art surfaces *(local — pending promotion)*

`--surface-art` and `--surface-art-deep` — indigo and violet fills standing in behind cover
imagery so a failed image load still reads as a brand block rather than a hole. `art-deep` is
also the empty-state card fill.
```

after:

```text
### 2.2 Art surfaces *(local — pending promotion)*

Two flat fills, resolved 2026-08-26. They are **not a pair and not a ramp** — each has one role,
and neither is derived from the other.

| Token | Value | Role |
|---|---|---|
| `--surface-art` | `#2f3782` | Stands in behind cover imagery so a failed image load reads as a brand block rather than a hole (Library spec §5). Reuses the canvas-indigo step rather than minting a hex. |
| `--surface-art-deep` | `#7d4ee0` | The empty-state recruit card fill (Library spec §11). A flat fill, never a gradient — see rule 6. |

**Why violet is admissible as a surface here.** Rule 4 bars violet as a fourth loud *accent* — a
hue competing for attention on small, repeated, interactive parts. `--surface-art-deep` is the
opposite of that: one large flat block, non-interactive, on one empty state, carrying no status
or action meaning. On that basis violet was ratified as a **surface** on 2026-08-26, in this one
place and nowhere else; it remains barred as an accent, and whether it is a status hue is still
open (§7.1). Rule 4 and §7.1 point here rather than restating this, so if the carve-out is ever
withdrawn this is the paragraph to change.
```

§3.2 Game card row — `Covers desaturated 50% + indigo→canvas scrim.` →
`Covers carry an indigo→canvas scrim.`

§3.3 Cover tile row — ``Image at `saturate(.5) contrast(1.05)` + flat indigo wash``
→ ``Image with a flat indigo wash``.

§6 register row — before:

```text
| `--surface-art` / `--surface-art-deep` | cover fallbacks, empty states | Brand block behind failed imagery |
```

after:

```text
| `--surface-art` `#2f3782` / `--surface-art-deep` `#7d4ee0` | cover fallbacks, empty states | Flat fills (§2.2); art-deep is also the empty-state card |
```

§7.1 — before:

```text
`#7d4ee0`** · **Wishlist link cyan** · Dropped 28% white. Violet is held over from the retired
gradient mesh as a status hue only and is never a surface; cyan is a small extension of the
"inline links only" rule. Strict fallback for either is 55% ink.
```

after:

```text
`#7d4ee0`** · **Wishlist link cyan** · Dropped 28% white. Violet is held over from the retired
gradient mesh. As of 2026-08-26 it is ratified as a **surface** in exactly one place,
`--surface-art-deep` (§2.2, which states why); whether it stays a *status hue* is what this
decision is about and is still open. Cyan is a small extension of the "inline links only" rule.
Strict fallback for either is 55% ink.
```

Options `1a`/`1b`/`1c` in §7.2, and register line 327, are untouched.

### .agents/references/library-design-conventions.md

§3 (line 41) — before:

```text
- Every chip carries a 7px status dot and a live count. Dots follow the status system exactly: Playing white, Backlog 55% white, Completed magenta `#ec48bd`, On hold violet `#7d4ee0`, Wishlist link cyan `#00b0f4`, Dropped 28% white. `All` has no dot.
```

after:

```text
- Every chip carries a 7px status dot and a live count. Dots follow the status system exactly: Playing indigo `#5865f2`, Backlog 55% white, Completed magenta `#ec48bd`, On hold violet `#7d4ee0`, Wishlist link cyan `#00b0f4`, Dropped 28% white. `All` has no dot. On the **active** Playing chip the dot reverts to ink: the filled pill already carries the hue, so an indigo dot on it would be invisible (this ships today).
```

§5 (line 65) — before:

```text
- Card: `--radius-lg`, `--color-ink-08`, `overflow:hidden`. Cover `aspect-ratio:3/4` on `--surface-art` with the app-wide treatment (`saturate(.5) contrast(1.05)` plus an indigo→canvas veil).
```

after:

```text
- Card: `--radius-lg`, `--color-ink-08`, `overflow:hidden`. Cover `aspect-ratio:3/4` on `--surface-art` with the app-wide indigo→canvas veil.
```

§11 (line 143) — before:

```text
- **Recruit card**: `--surface-art-deep` gradient, `--radius-xl`, `padding:24px`. 26px gamepad glyph, headline `START WITH ONE GAME` in display 700 24px caps, one line of body at 14px `rgba(255,255,255,.84)`, then the screen's single green CTA `Log a game` full width with a black label. No decorative oversized circle — the gradient carries the card on its own.
```

after:

```text
- **Recruit card**: flat `--surface-art-deep` fill (`#7d4ee0`), `--radius-xl`, `padding:24px`. 26px gamepad glyph, headline `START WITH ONE GAME` in display 700 24px caps, one line of body at 14px `rgba(255,255,255,.84)`, then the screen's single green CTA `Log a game` full width with a black label. No decorative oversized circle — on an otherwise empty screen the violet block is already the one loud shape, and a second would pull attention off the CTA. *(Flat, not a gradient, decided 2026-08-26 under colour law rule 6. The card was originally drawn around a ramp; the trade-off was accepted. Do not reintroduce one.)*
```

§12 (line 154) — before:

```text
- Indigo `#5865f2` — active status chip, active tab. Nothing else.
```

after:

```text
- Indigo `#5865f2` — active status chip, active tab, and the Playing status dot wherever it appears: the chip row (§3), the grid cover's status pill (§5), the list row's status line (§6). Nothing else.
```

### .agents/references/home-screen-design-conventions.md

Line 51 — before:

```text
- **Cover** 112 × 150, `--radius-lg`, `object-fit:cover`, `filter:saturate(.5) contrast(1.05)` plus an indigo→canvas gradient veil `rgba(88,101,242,.26) → rgba(35,39,42,.6)`. Purpose: …
```

after (only the filter clause goes; the veil, its stops, the purpose sentence, the
2026-07-30 recomputation note and the platform-tag sentence stay verbatim):

```text
- **Cover** 112 × 150, `--radius-lg`, `object-fit:cover`, with an indigo→canvas gradient veil `rgba(88,101,242,.26) → rgba(35,39,42,.6)`. Purpose: …
```

Line 83 — ``cover 120px tall `--radius-lg` with the same saturate/veil treatment``
→ ``cover 120px tall `--radius-lg` with the same veil``.

Line 123 — before:

```text
**Cover-art treatment.** Every cover in the app: `object-fit:cover`, `saturate(.5) contrast(1.05)`, indigo→canvas gradient veil. Applied uniformly so a grid of unrelated art still reads as one surface. …
```

after (the veil stays declared app-wide; the filter stops being system law):

```text
**Cover-art treatment.** Every cover in the app: `object-fit:cover` plus the indigo→canvas gradient veil. Applied uniformly so a grid of unrelated art still reads as one surface. …
```

### .agents/references/game-detail-design-conventions.md

Line 36 — before:

```text
- Key art `object-fit:cover` with `filter:saturate(.5) contrast(1.05)`, the app-wide cover treatment.
```

after:

```text
- Key art `object-fit:cover` with the app-wide cover treatment — the indigo→canvas veil.
```

Lines 41 and 162 are untouched.

### .agents/references/onboarding-welcome-design-spec.md

Line 85 — before:

```text
Every cover image gets `filter: saturate(.5) contrast(1.05)` plus a top-to-bottom
indigo→canvas tint so no cover can out-shout the UI.
```

after:

```text
Every cover image gets a top-to-bottom indigo→canvas tint so no cover can
out-shout the UI.
```

Line 67 (`saturate(.4) contrast(1.05)`, screen-2 key art) is **not** touched.

## TEST FILES

NONE (D5). `test/widget/theme/app_tokens_test.dart` is out of this item's scope
entirely — not opened, not edited. The four edits this plan previously sketched
(the value assertions, the distinctness-`Set` reason, the violet-exclusion reason,
the `_allColors()` additions) are withdrawn; see `tdd.md ## Withdrawn design
decisions`. No test file anywhere changes and the suite stays at exactly `+361 -10`.

## Approved feedback delta

Human decision **D5**, Phase 3 design gate, 2026-08-26 (`orchestrator-state.md`,
"Human decisions — 2026-08-26, Phase 3 design gate"). Authoritative on conflict.

- `test/widget/theme/app_tokens_test.dart` is removed from the file allowlist
  entirely. No test file is created or modified in this item.
- `3.1-AC6` – `3.1-AC9` are retired (`tech-ac.md ## Retired criteria`) and must not
  be implemented. `3.1-AC12a` is added and must be.
- Testing mode is `none`, not `coverage`. Both new tokens ship with zero test
  coverage — stated and accepted at the gate.
- Test baseline expectation is exactly `+361 -10`, unchanged. Not "+361 plus the
  new token assertions".
- The implementation plan drops the three token-test steps and renumbers: 19 steps
  → 17. A new step 2 carries `3.1-AC4` as a source read of `copyWith` and `lerp`,
  recorded in `diff-summary.md`, because no runtime check remains behind it.
- `system-foundation-specs.md` §2.2 must state **why** violet is admissible as a
  surface (`3.1-AC12a`), not just the values and roles — it is now the only place
  in the repo carrying D1's required reason. Copy is above, in the §2.2 "after"
  block. §2 rule 4 and §7.1 cross-reference it instead of restating it.
- Withdrawn, not overruled: the distinctness-`Set` decision and the asymmetric
  violet-assertion handling (`surfaceArt` added / `surfaceArtDeep` excluded). Both
  dissolve with the test edit — do not reinstate either.
- `tdd.md` and `task-brief.md` were corrected **in place** as well, because a stale
  `### TEST FILES` entry would have the Dev Agent's literal allowlist check
  authorise a file that is now out of scope.

Unchanged by D5: both token values (`#2F3782`, `#7D4EE0`), the flat-fill shape,
violet ratified as a surface, and all eight desaturation doc corrections.

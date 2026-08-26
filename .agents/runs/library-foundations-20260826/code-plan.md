# Code Plan
Source: `tech-ac.md` — Week 3 item 3.1 (D1–D4 in `orchestrator-state.md`)
Date: 2026-08-26

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
   (§2.2) — and nowhere else. It is not an accent. Violet as a *status hue* is still the open
   decision in §7.1.
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
`--surface-art-deep` (§2.2); whether it stays a *status hue* is what this decision is about and
is still open. Cyan is a small extension of the "inline links only" rule. Strict fallback for
either is 55% ink.
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

### test/widget/theme/app_tokens_test.dart

Four edits, no new test file.

- Surfaces group, new assertion — `'should expose the two art surfaces when
  reading the dark set'` — asserts `colors.surfaceArt` is `Color(0xFF2F3782)` and
  `colors.surfaceArtDeep` is `Color(0xFF7D4EE0)`. (`3.1-AC6`)
- `'should expose three distinct raised surfaces…'` (`:38-50`) — **unchanged
  members, unchanged `expect(distinct.length, 3)`**, plus the written reason:

```dart
      // surfaceArt is a deliberate alias of surfaceIndigoPanel, so it stays out
      // of this set - adding it would leave four members with three unique
      // values and the check below would pass without checking anything.
      final distinct = <Color>{
        colors.surfaceRaised,
        colors.surfaceIndigoPanel,
        colors.surfaceTabChrome,
      };
      expect(distinct.length, 3);
```

- `'should keep violet out of the surface and accent tokens…'` (`:97-111`) —
  `surfaceArt` joins the list, `surfaceArtDeep` is excluded with the reason:

```dart
      // surfaceArtDeep is left out on purpose: violet was ratified as a surface
      // in that one place on 2026-08-26 (see system-foundation-specs.md 2.2).
      // Every other token still has to keep clear of violet.
      final surfacesAndAccents = <Color>[
        colors.canvas,
        colors.surfaceRaised,
        colors.surfaceIndigoPanel,
        colors.surfaceTabChrome,
        colors.surfaceArt,
        colors.accentIndigo,
        colors.accentMagenta,
        colors.accentLinkCyan,
      ];
      expect(surfacesAndAccents.contains(colors.statusViolet), isFalse);
```

- `_allColors()` (`:493+`) — `colors.surfaceArt` and `colors.surfaceArtDeep`
  appended after `colors.surfaceToast`, in class order. (`3.1-AC8`)

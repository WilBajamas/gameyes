# QuestLoggd — Game Detail Screen Design Convention

Reference spec for the game detail screen as built in `QuestLoggd App.dc.html`. Two states ship: **not in library** (a decision screen) and **in library** (a tracking screen). Same skeleton, different first fold.

Frame 390 × 844, canvas `var(--color-canvas)` **`#23272a` (onyx)**. Full-height scroll, no sticky chrome.

> **Canvas resolved 2026-07-30.** This doc previously specified `#0a0d3a`, the design system's indigo canvas. `system-foundation-specs.md` overrules it: that indigo is a marketing surface, and the app canvas is onyx. The hero legibility ramp in §2 derives from the canvas and needs a design decision — see the flag there.

---

## 1. The two states, and why they diverge

| | Not in library | In library |
|---|---|---|
| Question | Should I play this? | Where was I? |
| Hero height | 300px | 262px |
| Hero status pill | `Out 14 Aug` + clock icon | `Playing · PS5` + green dot |
| Hero subtitle | Developer · platforms | Chapter · location |
| Primary action | `Add to library` (green) | `Log session` (green) |
| Secondary action | Heart (wishlist) | Status dropdown showing `Playing` |
| First content block | Global scores triplet | **Your run** panel |
| Global scores | First block | Last block |

**The governing decision: personal data outranks global data the moment it exists.** Before you own a game, critic score and time-to-finish are the whole decision — they go directly under the CTA. Once you own it, your own progress, hours and rating are what you came back for, and the global numbers demote to the bottom of the scroll. Nothing is removed between states, only reordered.

The hero shrinks by 38px in the library state because the top-right actions collapse from two buttons to one overflow, and the subtitle is progress rather than a sell.

---

## 2. Hero

The most distinctive element in the app.

- Height 300px (new) / 262px (owned), `background:var(--surface-art)`, `padding:20px`, `align-items:flex-end`.
- **`border-radius:0 0 88px 88px`** — the design system's directional bottom-only swoop, taken from the marketing hero media block and applied at app scale. It is the reason this screen is recognisable at a glance and appears **nowhere else** in the app.
- Key art `object-fit:cover` with `filter:saturate(.5) contrast(1.05)`, the app-wide cover treatment.
- **Three-stop legibility ramp**, not a two-stop scrim: `.3 0%` → `.6 48%` → `.93 100%`. Near-opaque at the base so 34px white display type survives any artwork.

  > **⚠ NEEDS A DESIGN DECISION — 2026-07-30, canvas change.** The ramp colour was `rgba(10,13,58,…)`, and its stated rationale was *"indigo-tinted rather than black, so the art is pushed toward the canvas hue instead of being greyed out."* Both halves of that sentence were true when the canvas was indigo. They now conflict: onyx `#23272a` is a near-neutral dark grey, so tinting toward the canvas hue **is** greying the art out. I have deliberately not picked for you. Two options:
  >
  > **(a) Match the canvas — `rgba(35,39,42,…)`.** The hero blends seamlessly into the page below it. Cost: cover art desaturates toward grey at the base, which is exactly what the original spec was written to avoid, and the hero loses its brand tint.
  >
  > **(b) Keep an indigo tint — `rgba(47,55,130,…)` (`#2f3782`, the raised-indigo panel step).** Preserves the art treatment and the brand cast. Cost: the hero base no longer matches the canvas it meets, so you need a short final blend or the seam becomes visible.
  >
  > **Recommendation: (b).** The ramp's job is art legibility, not canvas continuity, and the whole design system rations indigo as the carrier hue. Option (a) trades a visible design quality for an invisible token tidiness. Whichever you pick, `home-screen-design-conventions.md` §Now-playing cover veil uses the same indigo→canvas logic and should match.
- **Glass icon buttons** 40px, `--radius-full`, `rgba(0,0,0,.34)` + `backdrop-filter:var(--blur-glass)`, 19–20px glyphs, positioned `top:52px` (clear of the status bar). Back left; bookmark + share right (new) or overflow right (owned). This is the one place blur is used in the app — it sits over media, never over the mesh.
- **Status pill** — `rgba(0,0,0,.34)` glass, `--radius-pill`, 11px/500 uppercase `.08em`. Clock icon for an unreleased game; green dot for an active playthrough. Same component as the Home hero pill.
- **Title** Space Grotesk 700, **34px**, line-height 1.02, all-caps — the largest type anywhere in the app. Titles wrap to two lines without touching the pill above or the subtitle below.
- **Subtitle** 14px `rgba(255,255,255,.8)`, middot-separated. Platforms ride the hero as text abbreviations (`PS5 XSX PC`) because platform trademarks are not reproduced in this system.

Developer, platforms and release date live in the hero rather than in a metadata table: they are identity, not statistics, and putting them here keeps the numbers block down to three figures.

---

## 3. Action row

Directly under the hero, `padding-top:20px`, `gap:8px`. It never scrolls out of thumb reach on first paint — the single most important placement decision on the screen.

- **Primary** — `Button variant="green"`, full width, 44px, black label per system rule. `Add to library` carries an 18px plus glyph; `Log session` is label-only.
- **Secondary (new state)** — 48 × 44 square, `--radius-sm`, `--surface-raised`, 20px heart. Icon-only because wishlist is a recognised affordance and a second label would compete with the CTA.
- **Secondary (owned state)** — 44px tall labelled control, `padding:0 14px`, showing current status (`Playing`) with a 16px chevron-down. Labelled because a status value must be readable without tapping.

**One green element per screen.** The green CTA is the only green here except critic scores, which are data.

Section gap throughout the body is **32px** — larger than Home's 40px zone gap would be at this density, and consistent because every block below is peer-level content about one game rather than a priority ladder.

---

## 4. Not-in-library state, block by block

### 4.1 Scores triplet
Three `flex:1` cards, `--surface-raised`, `--radius-lg`, padding 14px. Figure Space Grotesk 700 24px; label 11px `--color-ink-55`.

- `88` in **`--color-green`** — `Critics · 42 reviews`. Green because a critic score is the closest thing to a verdict, and the sample size is in the label so the number is never naked.
- `4.6` in ink — `Players · 8.1K`
- `42h` in ink — `To finish`

Exactly three numbers. Release date, engine, publisher, languages and file size are all knowable and all excluded — they don't change the decision on a phone.

### 4.2 Description + genre chips
- 15px/1.55 `--color-ink-70`, two sentences, with an inline `More` in `--color-link` weight 500. Truncated by writing, not by a line clamp: the copy is authored to work at two sentences.
- Chips `--radius-pill`, `--color-ink-08`, `padding:6px 12px`, 12px/500 `--color-ink-70`. Four maximum, wrapping. Smaller and dimmer than Home's genre chips because here they are metadata, not a filter you tap.

### 4.3 Media rail
- Eyebrow `MEDIA`. Horizontal scroll, `gap:10px`, `margin:0 -20px; padding:0 20px` — full-bleed so it reads as scrollable.
- Tiles 228 × 128 (16:9), `--radius-lg`, alternating `--surface-art` / `--surface-art-deep` fills behind the image so a missing still still looks intentional.
- First tile carries a 48px `rgba(0,0,0,.45)` play circle with a filled 22px glyph — the only filled icon in the app, sanctioned because a hollow play triangle reads as disabled.

### 4.4 Where to play
- `--surface-raised` container, `--radius-lg`, `overflow:hidden`, rows `padding:14px 16px` split by `1px solid var(--color-hairline)`. Last row has no divider.
- Store name 14px/500 ink, price 14px `--color-ink-70`, right-aligned.
- `Day one` on Game Pass is set in **`--color-green`** — a price of zero is the standout value in the list, and this is the third and last sanctioned use of green on the screen.

This is a **dense structure**, which is the only context the design system permits hairlines in. Prices are not compared, ranked or badged as "best" — the app tracks games, it doesn't sell them.

### 4.5 If you liked this
- Horizontal rail, tiles 104px wide, cover 139px (2:3 box art ratio), `--radius-lg`, same veil treatment.
- Owned marker 18px indigo circle with a white check at `stroke-width:3` — indigo means "in your library" everywhere in the app.
- Title 12px/500 ellipsised, meta 11px `--color-ink-55` as `2024 · 86`.

Placed last: recommendations are the exit, and they should sit after every reason to stay on this game.

---

## 5. In-library state, block by block

### 5.1 Your run
The screen's anchor panel. `--surface-raised`, **`--radius-xl`** (one step above every other card here, marking it as the hero of the body), padding 20px, `gap:18px`.

- Header row: eyebrow `YOUR RUN` left, `Last played 2 days ago` 12px `--color-ink-55` right. Recency is context, so it sits at label scale.
- **Completion ring** 88px, r=38, 8px stroke, track `rgba(255,255,255,.12)`, fill **`#5865f2` indigo**, `stroke-linecap:round`, rotated `-90deg`. Centre stacks `68%` (Space Grotesk 700 22px) over `done` (10px `--color-ink-55`). Indigo, not green: green belongs to `Log session` 20px above it, and two greens in one glance is two CTAs. (The Home hero's ring is white for the same reason — it sits on indigo.)
- **2 × 2 stat grid**, `gap:12px`, figures Space Grotesk 700 20px, labels 11px `--color-ink-55`: `24h` Logged · `11` Sessions · rating · `~11h` To finish. The tilde stays on estimates.
- **Rating** is five 15px stars, four filled `--color-magenta` and one hollow `--color-ink-12`. Magenta is the system's badge/accent colour, so a personal rating never gets mistaken for a critic score.
- **Your note** nested at `--color-ink-08` / `--radius-lg` / padding 14px: label 12px/500 `--color-ink-55`, body 14px/1.5 `--color-ink-70`. A darker inset inside the panel rather than a sibling card, because the note is part of your run. Written as a real handoff to your future self ("Left off at the bell tower") — that is the whole feature.

### 5.2 Recent sessions
Same dense-list pattern as Where to play: `--surface-raised`, `--radius-lg`, rows `13px 16px`, hairline dividers. Date 14px ink left, duration 14px/500 `--color-ink-70` right. Three rows shown; the full log is a separate destination.

### 5.3 Global scores (demoted)
Identical triplet component to the new state, now last and with tighter labels — `Critics` / `Players` / `Average`, since `Average` reads against your own `24h` a screen above. Critic score keeps its green.

---

## 6. Cross-cutting conventions

**Component reuse.** The scores triplet, the hairline list, the completion ring, the status pill, the cover rail tile and the green CTA row are all shared with Home and the component library. This screen introduces exactly two new patterns: the 88px swoop hero and the Your-run panel.

**Colour rationing on this screen.**
- Green — the CTA, critic scores, `Day one`, the playing dot. Nothing else.
- Indigo — the completion ring, owned markers.
- Magenta — your rating only.
- Cyan `#00b0f4` — the inline `More` link.

**Radius ladder.** `--radius-sm` secondary action → `--radius-lg` cards, lists, media tiles, covers → `--radius-xl` Your run → `--radius-pill` chips and status pills → `--radius-full` glass buttons, dots, rating circles → `0 0 88px 88px` the hero, once.

**Surfaces.** `--surface-raised` for structural cards and lists; `--color-ink-08` for nested or lower-priority blocks (note, genre chips); `--surface-art` / `--surface-art-deep` behind imagery only. No shadows on content — separation is a colour step. Hairlines only inside the two dense lists.

**Type.** Space Grotesk 700 for the title and every figure; all-caps for the game title and eyebrows. Inter 400/500 for copy, labels and list rows. Body never below 11px, and 11px is reserved for stat labels.

**Touch targets.** 44px minimum: CTA, secondary action, glass buttons (40px visual with padding around them), list rows (43–46px). Chips are not tappable in this screen.

**Scroll behaviour.** No sticky action bar. The green CTA is above the fold at first paint and the screen is short enough that returning to it is one flick; a docked bar would cost 60px of hero on the only screen where the art is the point.

---

## 7. Accessibility notes

- Hero title on the three-stop ramp clears 4.5:1 against the darkest artwork tested; the base of the ramp is `.93` opacity for exactly this reason.
- Every hero glass button is icon-only — each needs an `aria-label` in build (`Back`, `Wishlist`, `Share`, `More options`).
- The completion ring communicates by number as well as arc; the arc alone is never the only carrier.
- Rating stars need a text equivalent (`4 of 5`) for screen readers.
- `Day one` in green is reinforced by its position and label, not colour alone.

---

## 8. Open items

1. **Quests / achievements** — the brand's vocabulary promises them and this screen has no slot yet. Likely a section between Your run and Recent sessions, owned state only.
2. **Community reviews** — deliberately out of scope for v1; the decision was to surface them in Feed first.
3. **Multi-platform ownership** — the status dropdown shows one platform. A game owned on two needs a rule.
4. **Completed state** — a third variant (finished, rated, archived) where the ring is full and `Log session` becomes something else.
5. Key art is stand-in photography (Picsum), tinted and desaturated; icons are the flagged Lucide substitution. No imagery or icon set was supplied.

# QuestLoggd — Home Screen Design Convention

Reference spec for the Home tab as built in `QuestLoggd App.dc.html`. Every value here is either a QuestLoggd Design System token or a documented deviation. Deviations are flagged inline.

Frame: 390 × 844 (iPhone 14/15 class). Canvas `var(--color-canvas)` **`#23272a` (onyx)**. Device shell radius 44px, hairline `--color-ink-12`, `--shadow-float` for the mockup only (not a product shadow).

> **Canvas resolved 2026-07-30.** This doc previously specified `#0a0d3a`, the design system's indigo canvas. `system-foundation-specs.md` overrules it: the indigo canvas is a marketing surface, and the app canvas is onyx `#23272a`. Every value derived from the canvas has been recomputed below and flagged inline. Note `#0a0d3a` survives as the **light-theme ink** colour in §on light theme — that reference is correct and unchanged.

---

## 1. Screen architecture

Home is a **single vertical scroll of three named zones**, in fixed priority order:

| Zone | Eyebrow label | Question it answers |
|---|---|---|
| 1 | YOU | What am I in the middle of? |
| 2 | RIGHT NOW | What lands soon that I care about? |
| 3 | DISCOVER | What should I play next? |

Order is by decreasing personal stake. Zone 1 is the reason the user opened the app; zone 3 is the reason they stay. Nothing outside these three zones belongs on Home — social activity lives in Feed, aggregate numbers live in Profile.

**Spacing rhythm.** Scroll container padding `8px 20px 24px`. Zone gap **40px** — deliberately larger than any internal gap so the three zones read as separate answers, not one list. Inside a zone: `14–16px` between blocks, `8–12px` between siblings in a row.

**Eyebrow labels.** Space Grotesk, 12px, `letter-spacing:.18em`, uppercase, `--color-ink-55`. The same treatment is used at every level of the design (section headers, device labels), so a zone label never competes with a card headline. No icons on eyebrows.

**Section links.** Right-aligned inline text link, 13px, weight 500, `--color-link` `#00b0f4`, with a 14px chevron-right. Only two exist on Home (Calendar, All) — a link per section would dilute both.

---

## 2. App header (not a nav bar)

Row: wordmark left, two affordances right, `justify-content:space-between`.

- **Wordmark** — `QuestLoggd`, Space Grotesk 700, 19px, `-0.01em`. Text, not a logo; no mark was supplied by the system.
- **Streak pill** — `--radius-pill`, `--color-ink-08` fill, 13px/500, magenta 14px flame glyph + the number. Magenta is the system's badge/accent colour, so the streak reads as an achievement, not an alert.
- **Notification button** — 36px circle, `--radius-full`, `--color-ink-08`, 18px bell, 7px magenta dot with a 2px canvas-coloured ring so the dot separates from the glyph.

The header **scrolls with the content**. It is not sticky and not blurred: the design system reserves `blur(18px)` for the marketing nav overlaying scroll, and a sticky bar at 390px would cost 50px of a screen whose first fold is the whole point.

---

## 3. Zone 1 — YOU

### 3.1 Continue-playing card (the hero)

The single most important element on Home. Everything else on the screen is sized down relative to it.

- Fill `--color-surface-indigo` (raised indigo `#1e2353`), `--radius-xl`, padding 20px, `gap:18px`.
- **Signature shape**: a 180px circle at `--radius-jumbo`, `rgba(255,255,255,.08)`, positioned `top:-46px; right:-40px`, clipped by `overflow:hidden`. This is the system's oversized-shape motif at app scale — one per screen, never two.
- **Cover** 112 × 150, `--radius-lg`, `object-fit:cover`, `filter:saturate(.5) contrast(1.05)` plus an indigo→canvas gradient veil `rgba(88,101,242,.26) → rgba(35,39,42,.6)`. Purpose: third-party art of any hue is forced into the brand's cool palette so white type stays legible over it. *(Lower stop recomputed 2026-07-30 from `rgba(10,13,58,.6)` — it is the canvas end of the veil, and the canvas is now onyx. The indigo top stop is unchanged and is what keeps the treatment brand-tinted rather than grey.)* Platform tag sits bottom-left in its own transparent-to-black ramp.
- **Status pill** — `rgba(0,0,0,.28)` glass, `--radius-pill`, 11px/500 uppercase `.08em`, prefixed with a 6px **green** dot. The dot is the only green on the card besides the CTA; green means live.
- **Title** Space Grotesk 700, 26px, line-height 1.05, all-caps. Largest type on the screen.
- **Progress line** 13px `rgba(255,255,255,.78)` — chapter context, not a number.
- **Completion ring** 60px, r=25, 6px stroke, track `rgba(255,255,255,.24)`, fill pure white with `stroke-linecap:round`, rotated `-90deg` so it starts at 12 o'clock. Percentage centred in Space Grotesk 700 15px. White, not green: green is rationed to the CTA, and a green ring next to a green button reads as two calls to action.
- **Time pair** 13px/500 white "24h logged" over 12px `rgba(255,255,255,.7)` "~11h to go". Estimate is hedged with `~` because it is one.
- **Actions** green `Button` (`variant="green"`, full width, black label per system rule) + a 48 × 44 overflow button on `rgba(0,0,0,.28)`. `Log session` is the only green element on Home — one high-intent CTA per screen.

### 3.2 Stat triplet

Three equal `flex:1` cards, `--color-ink-08`, `--radius-lg`, padding 13px, `gap:1px`. Figure in Space Grotesk 700 24px `--color-ink`; label 11px `--color-ink-55`. Numbers abbreviated per voice rules (`1,204`, `41%`), labels one word (Games, Hours, Cleared).

They sit **inside** zone 1 rather than in their own zone: they are context on "you", and promoting them would put vanity metrics above upcoming releases. Deeper analytics are a Profile destination.

---

## 4. Zone 2 — RIGHT NOW

### 4.1 Countdown card

- `--surface-raised`, `--radius-lg`, padding 16px, `gap:12px`.
- Meta row: `On your wishlist` in `#00b0f4` with a 13px bookmark icon (the reason this game is here), and `14 Aug · PS5` right-aligned in `--color-ink-55` — middot separator per system punctuation.
- Title Space Grotesk 700 20px caps.
- **Countdown**: three digit groups (DAYS / HRS / MIN), each Space Grotesk 700 22px on `--color-ink-08` at `--radius-xs`, `min-width:40px`, padding `5px 8px`, unit caption 10px `.06em` `--color-ink-55`. Separators are `:` in `--color-ink-12` with `padding-bottom:20px` to sit on the digit baseline, not the caption. Seconds are omitted on purpose — a per-second repaint on a card you glance at is noise, and it forces a live timer for no gain.
- **Remind** button `--color-ink-12`, `--radius-xs`, 13px/500 with a 14px bell. Neutral, not green — one CTA per screen.

Only **one** countdown is ever shown: the nearest release the user has actually wishlisted. Two countdowns is a list, and the list is the rail below.

### 4.2 Next-7-days rail

- Caption `Next 7 days`, 13px/500 `--color-ink-70` (a caption, not a zone eyebrow — the hierarchy is one level down).
- Horizontal scroll, `gap:10px`, `margin:0 -20px; padding:0 20px` so covers **bleed to the frame edge** and the rail reads as scrollable without a scrollbar (`scrollbar-width:none`, `.ql-scroll`).
- Tile 92px wide: date row (day 10px `.14em` `--color-ink-55` + date Space Grotesk 700 13px), cover 120px tall `--radius-lg` with the same saturate/veil treatment, then title 12px/500 with `text-overflow:ellipsis` and platform 11px `--color-ink-55`.
- **Owned marker** — 17px indigo circle, white 10px check at `stroke-width:3`, `top:5px right:5px`. Indigo = in your library, everywhere in the app.

Six items ship in the data so the seventh is always partly visible — the rail must never look like it ends at the frame.

---

## 5. Zone 3 — DISCOVER

### 5.1 Taste prompt + genre chips

- One sentence, 15px/500 `--color-ink`: `You clear RPGs fastest. More of those?` Second person, one observation, one question. This is the app reasoning out loud from the user's own data — it earns the recommendations that follow.
- Chips: `--radius-pill`, `--color-ink-08`, padding `9px 14px`, 13px/500, name in `--color-ink` and count in `--color-ink-55`. Wrapping row (`flex-wrap`), not a scroll — the set is finite and worth seeing whole. Six chips, descending count.

### 5.2 Best reviewed this month

- Two-column grid, `gap:12px`. Card `--radius-lg`, `--color-ink-08`, cover 150px + metadata footer `9px 11px 11px`.
- **Score chip** top-left: `--color-green` fill, `--color-ink-dark` text, Space Grotesk 700 14px, `--radius-xs`, `min-width:30px; height:24px`. The one sanctioned second use of green — it is data, not an action, and never appears on the same card as a button.
- Owned badge (indigo check, 20px) top-right; **quick-add** (26px `rgba(0,0,0,.45)` circle, 15px plus) bottom-right. Mutually exclusive by definition: a game is either tracked or addable. Quick-add opens the add-to-library sheet with status pre-set to Backlog.
- Footer: title 13px/500 ellipsised, meta 11px `--color-ink-55` as `PS5 · 88 critics`.

Two columns, not one: at 390px a two-up grid gives four games in one fold, and cover art is the primary recognition cue for games.

---

## 6. Tab bar

- Fixed to the bottom of the frame, **`#2e3236`** — a lightness step above the onyx canvas, which separates chrome from canvas without a border or shadow.

  > **Changed 2026-07-30 as a consequence of the canvas resolution.** This was `--color-surface-onyx` `#23272a` back when the canvas was indigo. Now that the canvas *is* `#23272a`, the original value would make the tab bar identical to the canvas and destroy the stated separation mechanism. `#2e3236` is the tab-bar chrome value specified in `system-foundation-specs.md`. Padding `8px 6px 22px` (bottom accounts for the home indicator).
- Five tabs: Home · Library · Search · Feed · Profile. `flex:1` each, `min-height:44px`.
- Active: `#5865f2` icon + label, plus an 18 × 3px indigo cap bar above the icon at `--radius-full`. Inactive: `rgba(255,255,255,.55)`, cap transparent (space reserved so nothing shifts).
- Icon 20px, label 10px/500 sentence case. Labels always present — five destinations is too many to teach by glyph alone.

**Decision:** Stats does not get a tab; it folds into Profile as a full-width section. Stats is a destination you arrive at, not a place you check. Feed keeps its tab because social is the growth loop.

---

## 7. Cross-cutting conventions

**Cover-art treatment.** Every cover in the app: `object-fit:cover`, `saturate(.5) contrast(1.05)`, indigo→canvas gradient veil. Applied uniformly so a grid of unrelated art still reads as one surface. Missing art falls back to `--color-surface-onyx` with a hairline and a gamepad glyph — never a coloured placeholder, which would read as real art.

**Colour rationing.**
- Green — `Log session` CTA, the live dot, critic scores. Nothing else.
- Indigo — library membership, active tab, hero card fill.
- Magenta — streak, notification dot, badges. Never structural.
- Cyan `#00b0f4` — inline text links only.

**Radius ladder on Home.** `--radius-xs` digit tiles and small buttons → `--radius-lg` cards, covers, stat cards → `--radius-xl` hero card → `--radius-pill` chips and status pills → `--radius-full` avatars, dots, icon buttons → `--radius-jumbo` the decorative shape.

**No shadows and no borders on content.** Separation is a colour step: `--color-ink-08` and `--surface-raised` against `--color-canvas`. Hairlines only inside dense structures.

**Type.** Space Grotesk 700 for every number and every title, all-caps for game titles. Inter 400/500 for everything else. No mid-weight anywhere.

**Touch targets.** 44px minimum: tab items, buttons, the overflow and quick-add controls. Chips at 35px tall are text-adjacent, not primary actions, and sit inside a padded row.

**Motion.** Mesh drift only; no entrance animation on scroll. State changes 140ms `cubic-bezier(0.2,0.7,0.2,1)`, press `scale(0.97)`, focus 2px green ring at 2px offset. All under `prefers-reduced-motion`.

---

## 8. Light theme (proposal — not in the system)

The design system ships no light tokens. Minimum viable set: canvas `#f2f2f8`, cards white, ink `#0a0d3a`, secondary `#333333`. Indigo, green, magenta unchanged. Mesh drops to 6% so it tints rather than washes. Green keeps black text, which the system already specifies. The hero card **stays indigo** in light mode — it is the anchor, and flipping it would lose the one surface that carries the brand.

---

## 9. Open items

1. Cold-start Home (zero games) — needs the three-step checklist variant; not yet designed.
2. Status chip colours in the Library screen are unresolved and will affect the owned/indigo convention here.
3. Light-theme tokens need ratifying into the system before the light screens are more than a proposal.
4. Cover art is stand-in photography (Picsum), tinted and desaturated. No imagery or icon set was supplied; icons are the flagged Lucide substitution.

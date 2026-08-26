# Onboarding — Welcome screens design convention

Scope: the two **welcome** screens of onboarding only (`welcome 1 of 2`, `welcome 2 of 2`).
Splash and auth are out of scope and documented elsewhere.

Source of truth: `QuestLoggd App.dc.html`. Tokens from the QuestLoggd Design System bundle;
local additions are flagged.

---

## 1. Purpose & sequence

| # | Headline | Job |
|---|---|---|
| 1 | `TRACK EVERY GAME YOU'VE EVER TOUCHED` | Show that the library is the product. Proof via a real-looking shelf + stats. |
| 2 | `AND KNOW WHAT DROPS NEXT` | Show forward-looking value: release countdowns for the wishlist. |

Two screens, never three. Screen 1 offers `Next` + `Skip`; screen 2 ends the flow with
`Get started` and no skip — by then the user has already been given an exit.

**Note (2026-08-04, item 6.1/6.2 revisions):** the hero content described in §3
below (fanned cover tiles, glass stat pill, key art, countdown) was the *original*
spec, implemented in item 6. Item 6.1 replaced both heroes' composed-widget content
with flat PNG art (`welcome-1-header.png`, `welcome-2-header.png`,
`welcome-2-header-bg.png`) — see `.agents/runs/welcome-screens-header-rework-20260804/`
for the accepted design. This section is retained as historical/design rationale for
the anatomy the flat art replaced; it is **not** what's currently implemented. A
follow-up should fold the current PNG-based anatomy back into this doc as the
authoritative version.

---

## 2. Frame

- Device frame `330 × 714`, `border-radius: 38px`, `overflow: hidden`.
- Fill `var(--color-surface-onyx)`, hairline `1px solid var(--color-ink-12)`.
- Column layout: **hero panel** (fixed height) then **copy block** (`flex:1`).
- Screen label above the frame: display face, `12px`, `letter-spacing:.18em`, uppercase.

Both screens share the frame exactly. Only the hero differs.

Note: the device frame itself (`330×714`, `38px` radius, hairline, screen label) is
**mockup chrome, not app UI** — it is not built in the Flutter implementation. The
screens fill the device viewport. See `system-foundation-specs.md § 6`, "hardware
geometry, not a UI radius."

---

## 3. Hero panel *(original spec — see note under §1; superseded by item 6.1's flat art)*

The hero is a full-bleed colour field with a **directional bottom radius**
`border-radius: 0 0 88px 88px` — the brand's swooping hero base, reused at app scale.

| | Screen 1 | Screen 2 |
|---|---|---|
| Height | `240px` | `216px` |
| Fill | `#2f3782` (indigo step above canvas) | `#8a2f86` (magenta step) — item 6.1 replaced with a background image on screen 2 only |
| Content | Fanned cover tiles + stat bar | Key art + title + countdown — item 6.1 replaced both with flat PNG content |

Rules (original anatomy, historical):

- **Flat fills only.** No radial gradients, no gradient mesh, no clipped shapes inside the
  hero. Atmosphere comes from plain translucent circles (below), not from gradients.
- **Ambient circles**: 1–2 per hero, `border-radius: var(--radius-full)`, bled off the panel
  edge, `rgba(255,255,255,.09)` for the neutral one and `rgba(236,72,189,.2)` for the accent.
  Never more than two — they are atmosphere, not decoration. **Removed entirely by item 6.1.**
- **Screen 2 key art** is a real image at `opacity:.42`, `filter: saturate(.4) contrast(1.05)`,
  under a flat `rgba(30,20,64,.5)` wash. The wash is a solid colour, not a scrim gradient.
  **Superseded by item 6.1's background image.**
- Each hero carries exactly **one glass context chip**, top-left at `top:54px`:
  `padding:6px 12px`, `--radius-pill`, `rgba(0,0,0,.30–.34)`, `backdrop-filter: var(--blur-glass)`,
  `11px/500`, `.08em`, uppercase, with a `13px` leading `ql-icon`.
  Copy names *where you are*: `Your library`, `Wishlisted · PS5`. **Removed entirely by
  item 6.1 — baked into the flat content art instead.**

### 3a. Cover fan (screen 1) *(superseded by item 6.1)*

Three tiles, `--radius-lg`, tilted so the eye reads depth without a shadow scale:

- left `100 × 134`, `rotate(-9deg)`, `bottom:96px`
- right `100 × 134`, `rotate(10deg)`, `bottom:88px`
- centre `124 × 166`, `rotate(2deg)`, `bottom:112px`, `box-shadow: var(--shadow-float)`

Only the centre tile floats — `--shadow-float` marks the focal tile and nothing else.
Every cover image gets a top-to-bottom
indigo→canvas tint so no cover can out-shout the UI. The centre tile carries a small
status chip (`Playing`) with a 5px dot.

### 3b. Stat bar (screen 1) *(superseded by item 6.1)*

Glass pill inset `left/right:24px`, `bottom:34px`, `padding:10px 14px`, `--radius-pill`,
`rgba(0,0,0,.3)` + blur. Three stacked pairs, space-between: figure in display 700 `18px`,
label `10px` at `rgba(255,255,255,.7)`. Numbers are the copy — `312 / 1,204 / 7`, abbreviated,
never spelled out.

### 3c. Countdown (screen 2) *(superseded by item 6.1)*

`DAYS : HRS : MIN`. Each unit is a glass tile — display 700 `30px`, `--radius-xs`,
`padding:8px 12px`, `min-width:52px`, `rgba(0,0,0,.32)` + blur — with a `10px`, `.1em`
uppercase label beneath. Separator colons are display `22px` at `rgba(255,255,255,.4)`,
optically aligned with `padding-bottom:26px`. Title above sits in display 700 `26px`.

---

## 4. Copy block

`flex:1`, `justify-content:flex-end`, `padding:20px 24px 28px` (screen 2: `18px 24px 28px`),
`gap:16px` (screen 2: `12px`). Content is bottom-anchored so the two screens' buttons and
headlines land on the same baseline as the user advances.

Order, top to bottom:

1. *(screen 2 only, original spec)* social-proof row — three overlapping `26 × 34` covers, `radius 5px`,
   `1.5px solid var(--color-surface-onyx)` border, `margin-left:-8px` overlap, next to
   `13px` `--color-ink-55` copy. **Removed entirely by item 6.1/6.2 — no replacement.**
2. **Progress dots** — active `22 × 5` pill in `--color-ink`; inactive `5 × 5` dot in
   `--color-ink-12`. `gap:6px`. Never numbers, never a bar.
3. **Headline** — display 700, `34px`, `line-height:1.02`, `letter-spacing:-0.01em`,
   ALL-CAPS, `--color-ink`. 4–6 words. No terminal period.
4. **Body** — `16px/1.45`, `--color-ink-70`, one sentence, sentence case, ends in a period.
5. **Action row**.

There is no mid-weight anywhere: 700 display drops straight to 400/500 body.

---

## 5. Actions

- Primary is the design system `Button` `variant="green"`, `full-width`, `44px` min height —
  **one green button per screen**, and it is the only green on the screen.
- Screen 1 pairs it with a plain-text `Skip` (`14px/500`, `--color-ink-70`, `padding:0 8px`)
  in a `gap:10px` row. Skip is text, never a second button.
- Screen 2 has no secondary — the flow ends here.
- Press is the global `scale(0.97)`; focus is the green ring at 2px offset.

Item 6.2 adds horizontal swipe between the two screens **alongside** these buttons — Next,
Skip, and Get started all keep working exactly as specified above; nothing here changes.

---

## 6. Separation & elevation

Separation on onyx is by **lightness step**, not hue shift — hero fills are lighter steps of
the same indigo/magenta family, never a new accent. No borders between hero and copy block;
the radius and colour step do the work. `--shadow-float` appears exactly once (the focal
cover). No other shadows.

---

## 7. Motion

Welcome screens are static by default. Permitted:

- Ambient circles may breathe on the splash convention's `ql-breathe` (18s,
  `cubic-bezier(.2,.7,.2,1)`, infinite alternate) — currently unused on welcome and should
  stay that way unless the hero feels dead in motion review. (Moot after item 6.1 removed
  the ambient circles.)
- Screen transitions: 420ms entrance, `cubic-bezier(0.16,1,0.3,1)`. No parallax, no springs.
  **Item 6.2 intentionally reverses the no-parallax/no-scroll-jacking stance for
  navigation** by adding swipe — confirmed product-owner decision, see the item 6.2 run.
- Everything collapses under `prefers-reduced-motion`.

---

## 8. Copy rules

Second person, arcade-barker register. Headline shouts in caps and stays ≤6 words; body is one
sentence, 12–18 words, and does the qualifying (`312 games or 3.`). Middot separates metadata
in chips (`Wishlisted · PS5`). No emoji. No "users", no "seamless", no exclamation marks.

---

## 9. Local additions (pending promotion)

| Value | Where | Note |
|---|---|---|
| `#2f3782` | welcome 1 hero fill | Lightness step between canvas and raised indigo. |
| `#8a2f86` | welcome 2 hero fill | Darkened magenta so white display type clears contrast. Superseded by a background image, item 6.1. |
| `rgba(30,20,64,.5)` | key-art wash | Flat wash replacing a scrim gradient. Superseded, item 6.1. |
| `radius 5px` | mini cover stack | Below the 6px compact chip token; smallest media in the system. |

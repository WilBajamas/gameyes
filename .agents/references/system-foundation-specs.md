# QuestLoggd — System foundations, colour & component spec

Scope: the app-side foundations for **QuestLoggd component library**. This is the reference for
tokens, colour law, and the component inventory used across the app screens.

Surface conventions live in sibling docs and take precedence for their own screen:
`home-screen-design-conventions.md`, `game-detail-design-conventions.md`,
`onboarding-welcome-design-spec.md`, `onboarding-auth-design-spec.md`.
Component anatomy and rationale live in §3 below — this is the single source of
truth for design; nothing else needs to be read alongside it.

Bound system: **QuestLoggdDesignSystem_347483** at
`_ds/questloggd-design-system-34748358-042a-4a5b-92fb-0c291cc953b2/`. Values below are read from
that bundle's token files — never restated by hand in a design. Always `var(--token)`.

---

## 0. Principles

1. **One anatomy per concept, sized rather than redrawn.** The game card has three sizes and one structure. Nothing gets a bespoke variant because it sits in a different place.
2. **Green is rationed.** Exactly one green CTA per screen, always the highest-intent action, always with black text. No component uses green as an accent, a status colour, or a highlight.
3. **Accents stay closed; error is a signal, not an accent.** Indigo, magenta and link cyan carry the interface. When a component needs to signal "nearly done", it uses proportion and copy, not a new hue. Red is added for failure only (see §2.1) and is rationed harder than green: never a card fill, never a zone accent, never twice on one screen.
4. **Colour steps separate, not lines or shadows.** Cards get a real fill and a large radius. Hairlines appear only inside dense structures (session rows, price rows, settings groups).
5. **Personal data outranks global data.** Wherever a component can show either, the user's own number wins the prominent slot.
6. **Outlines are always solid.** Every border, outline and hairline in the system is a
   continuous stroke. Dashed and dotted strokes are not used anywhere in the app — including
   reserved placeholder boxes, which read as pending because they are empty, not because
   their edge is broken.

---

## 1. Foundations

### 1.1 Colour tokens

**Accents — three, closed.**

| Token | Value | Owns |
|---|---|---|
| `--color-primary` | `#5865f2` Royal Indigo | The brand and everything action-shaped: primary buttons, bands, active chips |
| `--color-green` | `#35ed7e` Electric Green | Exactly one CTA per screen, black text, plus the focus ring |
| `--color-magenta` | `#ec48bd` Vibrant Magenta | Progress and completion: Completed, ratings, feature panels, badges |
| `--color-link` | `#00b0f4` Link Cyan | Inline text links on dark surfaces only |

`--color-on-primary` is `#ffffff`. No fourth loud accent — see §2.

**Surfaces — stack cool and dark.**

`--color-canvas` `#0a0d3a` → `--color-surface-indigo` `#1e2353` → `--color-surface-onyx`
`#23272a` (product chrome; the app's default) → `--color-surface-black` `#000000` (showcase
bands only).

**The app canvas is onyx, not the indigo canvas** — the indigo canvas and its mesh are a
marketing surface. One consequence: `--color-surface-indigo` `#1e2353` is **unusable as a raised
surface on onyx**, because it matches onyx in luminance and differs only in hue. Raised app
surfaces are lightness steps instead: `#2f333c` raised, `#2f3782` indigo panels (hero card,
sheet header), `#2e3236` tab-bar chrome and toasts.

**Ink and derived tints** (transparency only, no new hues):

`--color-ink` `#fff` · `--color-ink-dark` `#000` · `--color-muted` `#333333` (light cards only) ·
`--color-hairline` `#23272a` · `--color-ink-70` · `--color-ink-55` · `--color-ink-12` ·
`--color-ink-08` · `--color-primary-24` · `--color-magenta-24`.

There is **no `--color-ink-24`**. Where a mid-strength border is needed, write the literal
`rgba(255,255,255,.24)` and log it as a local addition (§5).

**Gradients** — `--gradient-brand`, `--gradient-magenta`, `--gradient-mesh` (three drifting
radial pools). These belong to the marketing surface. **The app screens use flat fills only** —
no gradient mesh, no scrim gradients, no gradient panels. Atmosphere on app screens comes from
plain translucent circles.

### 1.2 Type

`Space Grotesk` display (700, `--type-tracking-display` `-0.01em`, usually caps) and `Inter`
body (400–500). **No mid-weight** — 700 drops straight to 500/400.

Web scale: `display-xl` 82/800/1.0 · `display-lg` 62/800/1.05 · `display-md` 56/700/1.05 ·
`heading-lg` 48/700/1.1 · `heading-sm` 22/700/1.2 · `body-lg` 20/500/1.4 · `link-lg` 18/500/1.4 ·
`body` 16/400/1.5 · `link` 16/500/1.4 · `link-sm` 14/500/1.4.

Space Grotesk ships to 700; the 800 tokens render at 700 with tight tracking.

**App-scale ramp** (the 330×714 frame cannot take the web scale). Fixed sizes, display face
700 caps at the top three steps:

| Role | Size / lh | Face |
|---|---|---|
| Screen headline (welcome) | 34 / 1.02 | display 700 caps |
| Screen headline (auth, sections) | 32 / 1.05 | display 700 caps |
| Panel title / countdown figure | 26–30 / 1.05 | display 700 |
| Section heading | 22 / 1.2 | display 700 caps |
| Stat figure | 18 / 1.1 | display 700 |
| Lead | 15–16 / 1.45 | body 400 |
| Row label / button | 14–15 / 500 | body 500 |
| Chip / meta | 11–13 / 500, `.08–.14em` caps | body 500 |
| Zone label | 12 / `+.18em` caps, 55% ink | display 700 |
| Meta | 14 / 500, 70% ink | body 500 |
| Micro label | 10 / `.1–.18em` caps | body or display 500–700 |

### 1.3 Spacing

8px base: `4 / 8 / 12 / 16 / 20 / 24 / 32 / 40`, `--container-max` 1200px.

App frame: `24px` horizontal gutters, `28px` bottom, `56px` top where a screen replaces a hero.
Card interiors 24px at doc scale, 14–16px inside app rows. Stacks use flex `gap`, never margins
between siblings.

### 1.4 Radius

`xs` 6 (compact chips) · `sm` 12 (buttons, rows) · `md` 14 (rank rows) · `lg` 16 (cards, media) ·
`xl` 40 (feature panels, large tiles) · `pill` 50 · `jumbo` 120 (signature shapes) ·
`full` 9999 (avatars, dots, icon buttons). `--radius-hero-media` `0 0 88px 88px` for the
swooping hero base — reused at app scale on the welcome heroes.

Nothing is sharp. Media keeps its radius at every breakpoint.

### 1.5 Elevation

Two levels. **Flat** is the default for nearly everything. `--shadow-float`
`0 3px 68px rgba(69,42,124,0.1)` lifts one focal element per screen and nothing else.

Separation is by **colour step**, and on onyx specifically by **lightness step of the same
family** — never a hue shift, never a border between two stacked blocks. Hairlines
(`--border-hairline`, `--border-ink`) appear only inside dense structures: table rows, list
dividers, frame outlines.

### 1.6 Transparency & blur

8–12% white for glass chips and inline dividers. `--blur-glass` `blur(18px)` behind glass chips
and overlaying chrome. Never a translucent white *card* fill — cards get real colour. Copy over
media sits in a `--radius-pill` glass capsule, not on a scrim gradient.

### 1.7 Motion

`--motion-fast` 140ms (state changes) · `--motion-base` 220ms (expand/collapse) ·
`--motion-slow` 420ms (entrances). `--ease-standard` `cubic-bezier(0.2,0.7,0.2,1)` ·
`--ease-out` `cubic-bezier(0.16,1,0.3,1)`. Ambient loops: `--mesh-duration` 18s,
`--marquee-duration` 22s, both infinite alternate/linear.

No bounces, springs, parallax or scroll-jacking. Everything collapses under
`prefers-reduced-motion`.

### 1.8 States

- **Hover** — solid fills `brightness(1.08)`; ghost/raised surfaces lift toward `--color-ink-12`;
  links to 75% opacity + underline; media tiles do not move.
- **Press** — `--press-scale` `0.97`, no colour change.
- **Focus** — 2px `--color-green` outline at 2px offset. The only sanctioned green outside a CTA.

Hover and focus are documented *additions* to the source spec, kept minimal so they can be
replaced wholesale.

### 1.9 Iconography

Lucide via `ql-icons.js` — **outline only**, 2px stroke, `currentColor`, never filled.
16px inline with body, 20px in nav and rows, 24px in circular icon buttons (44px hit target min).
Always label-paired except the hamburger and circular icon buttons.

No emoji. No unicode dingbats. The middot `·` is punctuation, not an icon.

Platform marks are text abbreviations — `PS5`, `XSX`, `PC`, `NSW`. Third-party brand marks
(platforms, auth providers) are **never drawn or approximated**: reserve a placeholder box
at the final size and drop licensed art in.

---

## 2. Colour law

1. **Green is rationed.** One green element per screen, the highest-intent action, always black
   text. If a screen has three equal choices (auth), green is withheld entirely rather than
   spent arbitrarily. Green is never a general accent, never a status colour, never a border.
   Two sanctioned exceptions, both non-actions: the **focus ring**, and the **critic score
   badge** on a game card — that one is data, not an affordance. Green never appears in a
   destructive confirm.
2. **Magenta means progress, red means failure.** Magenta keeps Completed, ratings and
   celebration. It is never repurposed for errors.
3. **Cyan is for links.** Inline links, plus the paired `See all` / `Calendar` zone links at
   13px/500. Wishlist state borrows it — a flagged extension, resolved by the open status-hue
   decision (option `1c`).
4. **No fourth loud accent.** Indigo, magenta and cyan are the set; nothing joins them. Violet
   `#7d4ee0` was ratified 2026-08-26 as a **surface** in exactly one place — `--surface-art-deep`
   — and nowhere else. It is not an accent; §2.2 states why a surface is not an accent. Violet as
   a *status hue* is still the open decision in §7.1.
5. **Separation is a lightness step, not a hue.** Raised blocks on onyx are lighter steps of the
   same family (`#2f333c` above onyx, `#2f3782` above canvas indigo).
6. **No hard gradients in the app.** Flat fills, plain translucent circles for atmosphere.
7. **Every literal hex or rgba in a design is a local addition** and must be logged (§6).

### 2.1 Error ramp *(local — pending promotion)*

| Token | Value | Role |
|---|---|---|
| `--color-error` | `#f8443c` | Icons, dots, hairlines — the signal |
| `--color-error-strong` | `#d92d20` | Solid destructive fills, so white label text clears AA |
| `--color-error-ink` | `#ff8f88` | Error body copy — pure red fails at 14px on onyx |
| `--color-error-tint` | `rgba(248,68,60,.14)` | Tinted invalid-field and strip fills |
| `--color-error-line` | `rgba(248,68,60,.55)` | Error hairline |

Red is rationed **harder than green**: never a card fill, never a zone accent, never twice on one
screen. Applies to error fields, actions, screens and items (§3.4). Never mixed with magenta in
the same component — magenta means Completed.

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

---

## 3. Component library

### 3.1 From the bound bundle — compose, never recreate

Mount via `<x-import component-from-global-scope="QuestLoggdDesignSystem_347483.<Name>">`.

- **actions** — `Button` (primary · green · white · ghost · ghost-sm), `Badge`, `Icon`
- **navigation** — `NavBar`, `Footer`, `AppShellRow`
- **sections** — `Hero`, `FeatureCard` (gradient · dark), `ShowcaseBand`, `StatCard`, `StepCard`,
  `CtaBand`, `MarqueeBand`
- **commerce** — `PricingTable`, `PricingTier` (default · featured), `SummaryCard`
- **game** — `GameRankFeature`, `GameRankRow`
- **data** — `DataTable`
- **disclosure** — `FaqAccordion`, `Modal`
- **feedback** — `Toast`, `EmptyState`
- **forms** — `TextInput`, `AuthFormCard`

`Button` is the only sanctioned button. A styled `<span>` row (auth providers) is acceptable
*only* as a quieter sibling to a real `Button` in the same stack, at the same height.

### 3.2 Named components defined in this project

This is the full anatomy reference — sizes, treatments, and the load-bearing numbers.

| Component | Essentials |
|---|---|
| **Game card** | One anatomy, three sizes: `xs` 64px (no footer), `sm` 132px (library default — title, platform, one number), `md` 220px+ (date, platforms, inline add). Cover 3:4 at r16 at every size. Overlays: indigo library tick top-right, status chip bottom-left, green critic badge top-left. Covers carry an indigo→canvas scrim. Missing art = onyx fill + hairline + gamepad glyph, never a title initial. |
| **Status system** | Six glass pills: dot + label + count. Playing is the only filled state (indigo); the rest on 8% ink. Counts are load-bearing — a filter never reads as a dead end. Dot hues in §6.1. |
| **Completion ring** | A ring, not a bar. Indigo the whole way up, closed magenta ring at 100% matching the Completed dot. 60px inline / 80px specimen / 88px detail panel; percentage in display face at centre. |
| **Stat pill** | Figure in display 700, label beneath 11–12px at 55% ink, on 8% ink at r16. Used in threes; never more than three at 390px. (The glass `--radius-pill` variant is the hero-panel form — see §3.3.) |
| **Zone label** | 12px display face, `+.18em`, caps, 55% ink. That label plus a large vertical gap **is** the zone separation — no rules, no dividers, no numbering. Optional right-aligned cyan link at 13px/500. |
| **Async states** | Loading = shimmer skeletons shaped like their content, 1.4s linear, never spinners. Error = per section, never full page. Empty = art-deep card, glyph, caps display headline, one line, one action; empty states recruit, they never apologise. |
| **Add-to-library sheet** | One component, five entry points. Bottom sheet on raised indigo, 40px top radius, grab handle. Status pre-selected to Backlog so one-tap add works; platform and rating never blocking. Full-width green CTA at the base. |
| **Countdown** | Digit blocks on 8% ink at r6, colons at 12% ink, unit labels 10px beneath, inside a raised-indigo card so it can't out-shout the primary zone. Pairs with Remind + a cyan wishlist line. (Glass-tile variant on the welcome hero — §3.3.) |
| **Tab bar** | Onyx chrome `#2e3236`, five destinations, 44px min targets. Active indigo with a 3px cap above the glyph, inactive 55% white, 10px/500 labels always visible. |
| **Form fields** | Label above the input, always — no placeholder-as-label anywhere. Helper text folds onto the label row, never a third line. Fill `#2f333c` at r16; focus 2px green at 2px offset. Invalid swaps fill for error tint + 1px error hairline, so error and focus never fight for the same edge. |
| **Rows & hairline groups** | Price, session and settings rows share one pattern: raised card at r16, `overflow:hidden`, a single hairline *between* rows only — never a border on both edges of every row. Label left, value right, optional chevron. |
| **Error states** | Four levels — §3.4. |

### 3.3 App-scale primitives

One anatomy per concept, **sized rather than redrawn**.

| Pattern | Anatomy | Sizes |
|---|---|---|
| **Cover tile** | Image with a flat indigo wash, `--radius-lg`, optional bottom-left status chip | mini `26×34` r5 · row `112×150` · fan `100×134` / focal `124×166` |
| **Status chip** | Glass capsule, `--radius-pill`, `rgba(0,0,0,.42)` + `--blur-glass`, 6–7px dot + `11px/500` label | on-media 6px dot · list 7px dot |
| **Filter / count chip** | `--radius-pill`, active `--color-primary` white text; inactive `--color-ink-08`, `--color-ink` label + `--color-ink-55` count | `8px 14px`, `14px/500` |
| **Context chip** | Glass, `top:54px` in a hero, `rgba(0,0,0,.30–.34)` + blur, `11px/500` `.08em` caps, 13px leading icon | one per hero |
| **Stat pill** | Glass `--radius-pill`, `10px 14px`, 2–3 figure/label pairs space-between | figure display 700 18px, label 10px |
| **Countdown tile** | Glass `--radius-xs`, `min-width:52px`, `8px 12px`, display 700 30px + 10px `.1em` caps label | colons display 22px at 40% |
| **Provider / list row** | Full-width `52px`, `--radius-sm`, fill `#2f333c`, centred `15px/500` label, 20px leading mark slot | 44px hit target floor |
| **Progress dots** | Active `22×5` pill `--color-ink`; inactive `5×5` `--color-ink-12`, `gap:6px` | never numbers or a bar |
| **Placeholder slot** | Reserved empty box: `--color-ink-12` fill, `1px solid rgba(255,255,255,.24)`, display 700 caps label | app mark `88` r20 · provider mark `20` r`xs` |
| **Error field / action / screen / item** | Per §2.1 — signal hairline + `#ff8f88` message; destructive fill `#d92d20` | one destructive action per screen |

### 3.4 Error states — four levels

- **Field** — tinted fill + red hairline, label above, message below in error ink. The input keeps
  what you typed. No red glow, no shake, no extra icon inside the field.
- **Action** — destruction is a solid `--color-error-strong` fill with a plain-language verb
  ("Remove", not "Confirm"); the safe choice sits beside it in ink, never styled as the loud one.
  An outline variant in error ink is reserved for the rarer, heavier destruction (account
  deletion).
- **Screen** — either a dismissable strip on error tint with a hairline, **or** a single-line
  toast on `#2e3236` carrying a red dot rather than an icon so it stays one line at 390px. Never
  both for the same failure. Data already loaded keeps rendering underneath.
- **Item** — the failed row or card dims to 55%, takes a red hairline, and gets a wordless corner
  alert badge in the same slot as the indigo library tick. No label fits a 64px cover; the point
  is finding the failure in a grid of 300 without reading anything.

### 3.5 Device frame

`330 × 714`, `border-radius: 38px`, `overflow: hidden`, fill `--color-surface-onyx`, hairline
`--border-ink`. Screen label above the frame: display face, `12px`, `.18em`, uppercase. Every app
screen uses this frame unchanged.

---

## 4. Content fundamentals

Second person, arcade-barker register. Headlines ALL-CAPS display, 2–6 words, no terminal period.
Body one sentence, sentence case, ends in a period. Numbers *are* the copy — abbreviate
(`2.4M`, `312`), never spell out. Middot separates metadata. Gaming vocabulary is native:
quests, backlog, completion, platforms, drops, ranks.

Never: emoji, "users", "seamless", "leverage", exclamation marks, or a corporate register.

---

## 5. Accessibility

44px minimum hit targets everywhere. Body copy and all metadata meet WCAG AA against their own
surface — including white overlay text on cover imagery, which is why the cover scrim is fixed
rather than optional. Focus is a visible 2px green outline at 2px offset. All motion collapses
under `prefers-reduced-motion`. Icons pair with a label except in the tab bar and circular icon
buttons, where the affordance is unambiguous.

## 6. Local additions register

Everything below is used in this project and has no token in the bound system. Promote or replace.

| Value | Where | Note |
|---|---|---|
| `#2f333c` | provider rows, raised app rows | Lightness step above onyx |
| `#2f3782` | welcome 1 hero | Step between canvas and raised indigo |
| `#8a2f86` | welcome 2 hero | Darkened magenta for white display type contrast |
| `rgba(30,20,64,.5)` | key-art wash | Flat wash replacing a scrim gradient |
| `rgba(10,13,58,.42)` | cover tile wash | Keeps covers from out-shouting UI |
| `#2e3236` | tab-bar chrome, toasts | Third onyx step |
| `--surface-art` `#2f3782` / `--surface-art-deep` `#7d4ee0` | cover fallbacks, empty states | Flat fills (§2.2); art-deep is also the empty-state card |
| `rgba(255,255,255,.24)` | placeholder borders | No `--color-ink-24` exists |
| `rgba(255,255,255,.18)` / `.32` | provider mark slots | Removed when licensed marks land |
| `radius 5px` | mini cover stack | Below `--radius-xs`; smallest media in the system |
| `radius 20px` | 88px logo slot | Between `lg` and `xl` |
| `radius 38px` | device frame | Hardware geometry, not a UI radius |
| Error ramp (§2.1) | error states | Five named tokens, promote as a set — otherwise a second product on this system invents a different red |
| `#7d4ee0` / `#00b0f4` as status dots | status chips | **Open decision** — see the app doc's status-hue section |
| `rgba(0,0,0,.42)` | status chip, on-media variant | Glass capsule over cover art; tokenised as `glass42` beside the .30/.32/.34 ramp |

## 7. Open decisions

### 7.1 Status chip hues

Current dots: Playing white on indigo · Backlog 55% white · Completed magenta · **On hold violet
`#7d4ee0`** · **Wishlist link cyan** · Dropped 28% white. Violet is held over from the retired
gradient mesh. As of 2026-08-26 it is ratified as a **surface** in exactly one place,
`--surface-art-deep` (§2.2, which states why); whether it stays a *status hue* is what this
decision is about and is still open. Cyan is a small extension of the "inline links only" rule.
Strict fallback for either is 55% ink.

### 7.2 Register

1. **Status chip hues** — violet (`On hold`) and cyan (`Wishlist`) are used outside the closed
   palette. Three resolutions are laid out in `QuestLoggd App.dc.html` (`1a` ratify both, `1b`
   shape not hue, `1c` one exception). Recommendation: `1c`.
2. **Error palette promotion** — five values awaiting system tokens.
3. **Real assets** — no logo, no icon set, no imagery was supplied. All four onboarding
   placeholders and every platform/provider mark are reserved slots. Icons are the system's
   flagged Lucide substitution, inlined via `ql-icons.js` — replacing them touches one file.
   Cover art in this build is stand-in photography; swap in real key art and the geometry holds.
4. **Light theme** — no tokens in the system. Proposal: canvas `#f2f2f8`, white cards, ink
   `#0a0d3a` with `#333333` secondary, accents unchanged. **Not locked.**

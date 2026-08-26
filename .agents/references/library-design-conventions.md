# QuestLoggd — Library Screen Design Convention

Reference spec for the Library tab as built in `QuestLoggd App.dc.html`. Every value here is either a QuestLoggd Design System token or a documented deviation. Deviations are flagged inline. Three states ship: **populated** (312 games, live in the first device), **cold start** (3 games), **empty** (0 games).

Frame 390 × 844, canvas `var(--color-surface-onyx)` `#23272a`. Scroll container padding `8px 20px 24px`, block gap **20px** — tighter than Home's 40px zone gap, because Library is one continuous list under one set of controls, not three separate answers.

---

## 1. Screen architecture

Five stacked blocks in fixed order, then the count line:

| # | Block | Question it answers |
|---|---|---|
| 1 | Title | Where am I? |
| 2 | Search + filter button | Find one specific game |
| 3 | Status chips | Show me one slice of the shelf |
| 4 | Sort control + view toggle | How is this ordered, and how dense? |
| 5 | Grid or list, ending in the Log-a-game cell | The shelf itself |
| 6 | Count line | How much of the shelf am I looking at? |

Controls stack top to bottom in decreasing frequency of use: search is used most, the view toggle least. Nothing above the shelf is sticky — at 390px a pinned control stack costs three rows of covers, and the chips are one flick away.

**Title.** `LIBRARY`, Space Grotesk 700, 34px, `-0.01em`, all-caps. No subline, no game count beside it: the count belongs at the bottom of the list, where it describes what you actually scrolled through.

---

## 2. Search and filter

- Field: 44px tall, `--radius-lg`, `#2f333c`, 17px search glyph in `--color-ink-55`, label `Search your library` at 15px `--color-ink-55`. Search scopes to the library, never the catalogue — a global search is what the Search tab is for.
- Filter button: 44 × 44, `--radius-lg`, `#2f333c`, 19px sliders glyph. Opens the sort-and-filter sheet (platform, genre, year, score). Icon-only: it sits beside a labelled field, and a second label would read as a second search.
- In the empty state the field renders at `opacity:.5` and does nothing. A search box over zero games is a dead control, but removing it would move the layout under people the moment they add their first game.

---

## 3. Status chips

Seven chips — `All · Playing · Backlog · Completed · On hold · Wishlist · Dropped` — in one horizontal scroller, `gap:8px`, `margin:0 -20px; padding:0 20px` so the row bleeds to the frame edge and reads as scrollable (`scrollbar-width:none`, `.ql-scroll`).

- Chip: 35px tall, `padding:0 13px`, `--radius-pill`, 13px/500. Inactive `--color-ink-08` with `--color-ink-70` label; **active `#5865f2` with white label** — indigo is the app's active-state colour, same as the tab bar.
- Every chip carries a 7px status dot and a live count. Dots follow the status system exactly: Playing indigo `#5865f2`, Backlog 55% white, Completed magenta `#ec48bd`, On hold violet `#7d4ee0`, Wishlist link cyan `#00b0f4`, Dropped 28% white. `All` has no dot. On the **active** Playing chip the dot reverts to ink: the filled pill already carries the hue, so an indigo dot on it would be invisible (this ships today).
- Counts are dimmer than the label (`rgba(255,255,255,.4)`, or 72% white on the active chip) and are load-bearing: they tell you a slice has contents before you tap it, so a filter never presents as a dead end.

**Why chips and not tabs or status cards.** Six statuses plus All will not fit as a segmented control at 390px, tabs would cap the set at four, and status cards (the Backlogr pattern) cost a tap to reach any game at all. Chips scroll, carry counts, and keep the shelf on screen while you switch.

Chips are dropped entirely in the empty state.

---

## 4. Sort control and view toggle

One row, `space-between`, `margin-top:-6px` so it tucks under the chip scroller.

- **Sort**: pill on `--color-ink-08`, 34px, 13px/500, current value as the label (`Recently added`) with a 15px chevron-down. The value is the label — a control reading "Sort" tells you nothing about the order you are looking at. Options: recently added, alphabetical, release date, rating, playtime.
- **View toggle**: two 40 × 30 segments in a 3px `--color-ink-08` trough, `--radius-pill`. Active segment `rgba(255,255,255,.16)` with a white glyph; inactive glyph at 55% white. Grid and list icons, no labels.

The toggle is neutral, not indigo: it changes how you look, not what you are looking at, and a second indigo control in the same fold would compete with the active status chip.

---

## 5. Grid view (default)

Two columns, `repeat(2,minmax(0,1fr))`, `align-items:start`, `gap:12px`.

- Card: `--radius-lg`, `--color-ink-08`, `overflow:hidden`. Cover `aspect-ratio:3/4` on `--surface-art` with the app-wide indigo→canvas veil.
- **Status pill**, bottom left of every cover: `rgba(0,0,0,.42)` glass, `--radius-pill`, 10px/500 uppercase `.08em`, 5px status dot. It is on every card, not just some, because at `All` the status *is* the sort you are reading.
- Footer `9px 11px 11px`: title 13px/500 `--color-ink`, meta 11px `--color-ink-55` as `platform · contextual number` (`PS5 · 24h · Ch. 9`, `NSW · Added 3d ago`, `PS5 · Out 14 Aug`). Both lines nowrap and ellipsise.
- No library tick. Indigo means "in your library" everywhere else in the app; inside the Library it would be on all 312 covers.

**Why two-up and not three.** This is the middle option between a pure cover wall and a list: 168px covers stay recognisable, and the footer strip plus the status pill mean the grid carries platform, status and one number per game. Three columns would drop the footer and turn the shelf back into wallpaper.

---

## 6. List view

One `--radius-lg` container with `background:var(--color-hairline)` and `gap:1px`, rows on `#2f333c` — so a hairline falls **between** rows only, never on the outer edges.

- Row: `padding:10px 14px`, `min-height:44px`. Cover 46 × 62 at `--radius-sm` with the same veil.
- Middle: title 15px/500, then a status line at 12px `--color-ink-55` with the 6px status dot — `Playing · PS5`.
- Right, aligned end: the contextual figure in Space Grotesk 700 15px (`68%`, `100%`, `—`), with the 11px meta under it. Progress statuses show a percentage; Backlog and Wishlist show `—`, because a fabricated 0% reads as failure rather than as "not started".

Twelve rows fit in a fold against six covers, which is the point: list is the 300-game view, grid is the browsing view.

---

## 7. Log a game

The last cell of the shelf in both views, never a floating button.

- Grid: 282px tall cell on `--color-ink-08` with a **1px solid** `--color-ink-12` border, 24px plus glyph, `Log a game` at 12px/500 `--color-ink-70`.
- List: a final row on `#2f333c` with a `1px solid --color-ink-12` top edge, a 46 × 62 bordered plus tile in the cover slot, and the label at 15px/500.

Solid borders, not dashed — dashes read as an upload target, and everything else on the screen separates by fill and radius.

It sits inside the shelf so the empty half of a small library is an action rather than a gap, and it never covers a cover the way a FAB does.

---

## 8. Count line

Centred under the shelf, 13px `--color-ink-55`: `Showing 12 games out of 312`. It reports the **active filter** against the library total, so it doubles as confirmation that a chip did something. It renders in all three states, including `Showing 0 games out of 0` — a screen that reports zero is working; a screen that reports nothing looks broken.

---

## 9. Behaviour

**Status chip.** Tap filters the shelf in place, 140ms. Chip fill goes indigo, the count line updates, the sort and the view are preserved. The chip row does not re-order or scroll itself — the set is stable so muscle memory holds. Only one status is active at a time; multi-select lives in the filter sheet, not the chips.

**View toggle.** Tap switches grid ⇄ list instantly, keeping the active filter, the sort and the scroll anchor. The choice persists across visits — a 300-game user who picks list should never be handed the grid again.

**Sort.** Tapping the pill opens the sort sheet; the pill label becomes the chosen value on dismiss. Order changes do not reset the status filter.

**Search.** Focus expands recent searches over the shelf; typing filters the current status slice, not the whole library, so search composes with the chip rather than overriding it. Clearing restores the previous scroll position.

**Filter sheet.** Platform, genre, year and score. Active filters return as a count badge on the sliders button, so a filtered shelf can never be mistaken for the whole one.

**Log a game.** Opens the add-to-library sheet with status pre-selected to Backlog, the same component and the same pre-selection as every other entry point.

**Card tap.** Opens Game Detail in its in-library state. There is no long-press and no per-card overflow: a menu on 312 cards is 312 chances to mis-tap, and every action it would carry already exists one level down.

**Bulk edit.** Not on this screen. Multi-select was cut in review; when it returns it belongs in the filter sheet's neighbourhood, not on the default shelf.

**Motion.** Filter and toggle changes 140ms `cubic-bezier(0.2,0.7,0.2,1)`, press `scale(0.97)`, focus a 2px green ring at 2px offset. Loading is shimmer skeletons in the shape of the cards they replace, never spinners. All of it collapses under `prefers-reduced-motion`.

---

## 10. Cold start — 3 games

Same header, same search row, same grid. Differences only:

- Chips reduce to the statuses that exist plus `All` (`All 3 · Playing 1 · Backlog 2`), with `Wishlist 0` kept visible as the one route out of the library you own into the one you want.
- No view toggle: three games do not need a density choice.
- The Log-a-game cell lands where the fourth cover would be, so the first thing that reads as unfinished is also the thing that finishes it.
- Count line reads `Showing 3 games out of 3`.

A user with 3 games and a user with 312 get the same screen; the small library differs by what is absent, not by a special layout.

---

## 11. Empty — 0 games

- Header, then the search field at `opacity:.5`. No chips, no sort, no toggle.
- **Recruit card**: flat `--surface-art-deep` fill (`#7d4ee0`), `--radius-xl`, `padding:24px`. 26px gamepad glyph, headline `START WITH ONE GAME` in display 700 24px caps, one line of body at 14px `rgba(255,255,255,.84)`, then the screen's single green CTA `Log a game` full width with a black label. No decorative oversized circle — on an otherwise empty screen the violet block is already the one loud shape, and a second would pull attention off the CTA. *(Flat, not a gradient, decided 2026-08-26 under colour law rule 6. The card was originally drawn around a ramp; the trade-off was accepted. Do not reintroduce one.)*
- Two lighter routes under it in one hairline group on `#2f333c`: `Import from Steam or PSN` and `Browse this month's releases`, each with a 19px glyph, a one-line reason, and a chevron. They exist because the fastest path to a full shelf is rarely typing a title.
- Count line reads `Showing 0 games out of 0`.

Empty states recruit. They do not apologise, and they name the action that fills the screen.

---

## 12. Cross-cutting conventions

**Colour rationing on this screen.**
- Indigo `#5865f2` — active status chip, active tab, and the Playing status dot wherever it appears: the chip row (§3), the grid cover's status pill (§5) and the list row's status line (§6). Nothing else.
- Magenta — the Completed status dot only.
- Violet `#7d4ee0` / cyan `#00b0f4` — On hold and Wishlist dots (both flagged in the component brief).
- Green — one CTA, and only in the empty state (`Log a game`). The populated and cold-start screens carry no green at all, because their highest-intent action is a neutral cell inside the shelf.
- Red — unused here. The item-level failure treatment (55% dim, red hairline, wordless corner badge) applies if a cover fails to load.

**Surfaces.** Canvas `#23272a`; cards and chips `--color-ink-08`; search field, list rows and the sort trough `#2f333c`; tab bar `#2e3236`; hairlines `--color-hairline` between list rows only. No shadows, no borders on content — separation is a lightness step.

**Radius ladder.** `--radius-sm` list-row covers → `--radius-lg` cards, covers, search field, filter button → `--radius-xl` the empty-state recruit card → `--radius-pill` chips, status pills, view toggle → `--radius-full` dots.

**Type.** Space Grotesk 700 for the screen title and every figure; Inter 400/500 for labels, titles and meta. No mid-weight.

**Touch targets.** 44px minimum: search field, filter button, tab items, list rows, the Log-a-game cell. Chips at 35px are text-adjacent controls inside a padded row.

**Tab bar.** Unchanged from Home. Library active: indigo glyph and label with the 18 × 3px indigo cap.

---

## 13. Open items

1. **Custom lists** are not built. They pin above the status chips as a separate scroller, so a user-made set never competes with the six system statuses.
2. **Filter sheet** contents are specified but not drawn; the badge-on-sliders convention above assumes it.
3. **Search-within-library results** — the recent-searches expansion and the no-results state still need designing.
4. **Per-status empty states.** The count line covers the "nothing here" case for now, but Wishlist and Dropped at zero deserve their own one-line recruit.
5. **Status chip colours** (violet, cyan) are still the two flagged hues from the component brief.
6. Cover art is stand-in photography, tinted and desaturated; icons are the design system's flagged Lucide substitution.

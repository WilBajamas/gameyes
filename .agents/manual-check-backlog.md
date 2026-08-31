# Manual check backlog — QuestLoggd

On-device checks a QA pass identified and nobody has performed. Each shipped as
`PASS — pending manual checks`: the automated side passed, and what remains is
something only a human looking at a real device can confirm — paint overflow,
`BackdropFilter` edge bleed, colour fidelity, a held drag mid-gesture.

**Tick a check off by deleting it.** If one fails it stops being a backlog item and
becomes a bug — file it in `handover.md` rather than leaving a failing check here.

**74 checks**, counted from this file on 2026-08-25. **Recount rather than quoting a
total** — four different figures (82, 88, 90, 92) have all been wrong at some point.

## Read this before spending a session here

**Only three entries are reachable in the app as it stands**: `2.8-MC-3`, `2.8-MC-4`
and `2.7-MC-3`. Everything else is gated on a screen that does not exist yet, so this
is **a per-screen checklist to consult while building, not a queue to work down.**

- **Most of the rest belong to components with no caller anywhere** —
  `CompletionRing`, `LabelValueRow`, `HairlineGroup`, `ErrorNotice`, `FailedItem`,
  `DestructiveActionPair`, `ContextChip`, `StatPill`, `CountdownTile`, `ZoneLabel`,
  `CoverTile`. **Perform each one on the screen that first adopts it**, in week 3/4.
- **Do not build a scratch harness.** One was built on 2026-08-25 and deleted the same
  day: it would check components in isolation rather than in the layout they ship in,
  and several of these checks are only meaningful in a real screen. `git show faa108b`
  has the file if a future session wants to argue the case again.
- **Featured's checks are low value.** That screen is on an old design and is due to be
  rebuilt against `home-screen-design-conventions.md`. Check behaviour that survives a
  rebuild (a tab switch working, a cubit reaching a state), not pixels. Affects
  `2.8-MC-3` and the Featured half of `2.8-MC-4`.

## What the 2026-08-25 sitting actually bought

Eighteen checks cleared — all fifteen of item 2.4, plus `2.8-MC-1`, `2.8-MC-2` and
`2.8-MC-5` — including the only two entries in the whole file that had no automated
guard at all: keyboard Enter/Space activation (the `ButtonPressScale`/`ActivateIntent`
defect) and the tab bar's selected/unselected colour correction, which the old bar had
shipped **inverted** the entire time.

**But the checks were not the value. It found three bugs nothing was hunting for**,
all filed in `handover.md`: the screen-title overflow at large font sizes, 65 of 167
Chinese strings being untranslated English, and — the significant one —
**`GamesStatus.empty` never being emitted, so the games empty state had never once
been reachable**, despite two QA passes examining that exact branch. Two are fixed;
the translations are being done per-screen as building continues.

**The lesson for the next sitting**: driving the real app found things no checklist
entry described. Budget time for looking around, not only for ticking.

---

## Week 1 — item 10.1 (IGDB transport)

Retired run folder; these came from that run's QA report.

- **10.1-AC-16** — debug **dev** build: each IGDB call should print its request
  line and `{endpoint, query}` body, and a failed call should print status,
  message and the function's error body. No 50-line trim, no caller stack trace
  — both gone by approved deviation, don't expect them.
- **10.1-AC-17** — **release** build and **prod-flavour** build: exercise the
  games list, expect zero IGDB transport output in the console.
- **10.1-AC-2** — a dev build and a prod build each hit their own Supabase
  project host (visible in the dev build's logger output).
- **10.1-AC-10** — with an expired access token, or a forced 401, the games list
  still loads with no error shown to the user.

Note `flutter run` needs `--flavor dev`, not just `-t lib/main.dart` — see
gotcha #8.

---

## Week 2 Stage 1 — component library primitives

### 1.1 Zone label

- **1.1-AC10** — Place `ZoneLabel(label: <a label longer than the row width>,
  linkLabel: 'See all', onLinkPressed: ...)` in a 24px-guttered column — expect
  the label on one line ending in an ellipsis, the link fully rendered at its
  intrinsic width, no yellow overflow stripe and no overlap between the two.

### 1.2 Status chip

- **1.2-AC6** — Render `StatusChip(status: LibraryStatus.backlog, variant:
  StatusChipVariant.onMedia)` as a `Stack` overlay on a cover image (any screen,
  or the first screen that adopts it) — expect the blur to stop exactly at the pill outline
  with no soft halo bleeding past the capsule's rounded edge onto the
  surrounding art. Structure is proven correct
  (`lib/widgets/glass_surface_widget.dart:21-25` clips the `BackdropFilter`
  inside a `ClipRRect` at the same `borderRadius`), but `BackdropFilter`
  edge-clipping is a render behaviour a widget test cannot observe, and this is
  the criterion's own named failure case. The chip ships unplaced, so nothing in
  the app exercises this yet.
- **1.2-AC18** — Place the chip in a `Row`/`SizedBox` narrower than its
  intrinsic width (e.g. 60px, status `wishlist`, count `12`) — expect the label
  to stay on one line and ellipsise, the dot to stay a perfect 7px circle (not
  an ellipse), and the count to render in full. No test covers the
  constrained-width case.

### 1.3 Cover tile

- **1.3-AC6** — Render a `CoverTile` at each size with a real cover whose aspect
  ratio is not 3:4 — expect the art centred and cropped to fill, no letterbox
  bars, no distortion, no tile fill showing through.
- **1.3-AC7** — Render a loaded cover at `row`/`fan`/`focal` beside the same
  source image — expect identical hue and saturation, the wash being the only
  difference. The saturate/contrast treatment must be visibly absent.
- **1.3-AC8** — Same screen — expect one flat uniform indigo wash across the
  whole artwork area, no gradient ramp, no per-size opacity difference.
- **1.3-AC10** — `row` tile with a status supplied — expect the on-media chip
  inset from the bottom-left corner, fully inside the tile's rounded bounds, not
  clipped.
- **1.3-AC12** — Tile with a null URL and a tile with an unreachable URL —
  expect the same onyx block, hairline outline and centred gamepad glyph; at
  `mini` (26×34) expect fill + hairline only, and confirm the glyph's default
  24px size still reads correctly inside `fan` (100×134) and `row` (112×150).
- **1.3-AC13** — Tile on a slow connection — expect a shimmer block at the
  tile's exact box and radius, never a spinner, and no layout shift when the
  image arrives.
- **1.3-AC15** — Home/featured screens (`library_stats`, `countdown_releases`
  ×2, `critics_grid`) and `game_item`/`saved_game_item` — expect the spinner
  while loading and the error icon on failure, exactly as before that change.

### 1.4 Placeholder slot

- **1.4-AC9** — Open the auth screen (`AuthScreen`, any state) — expect the
  `LOGO` marker centred inside the 88px box in Space Grotesk 700 at 14px with
  wide tracking, fully contained: no clipping at the box edges and no horizontal
  bleed past the border. The label grew from the old 10px `microLabel` to 14px
  with `letterSpacing: 2.24`, so the glyph run is roughly 55–60px wide inside an
  88px box minus a 1px border. Tight but expected to fit; a widget test cannot
  see paint overflow from a `Center` child, so a human must look.
- **1.4-AC7** — Open the auth screen — expect one continuous solid hairline
  around all four sides of the box, following the 20px corner radius, with no
  visible break, doubling, or corner artefact.
- **1.4-AC12** — Open the auth screen — expect the placeholder in the same
  header position as before, still 88×88, still centred, with the same 32px gap
  to the welcome headline beneath it; only the marker's type treatment should
  look different.

### 1.5 / 1.6 / 1.7 Filter chip, context chip, stat pill

- **1.5-AC11** — Open the filter bottom sheet (ordering, platform, genre groups)
  — expect three chip groups rendering as before, indigo-filled capsules when
  selected and 8%-ink when not, single-select on ordering and multi-select on
  platforms/genres, same items in the same order, chip and title spacing
  unchanged. No automated test covers `filter_bottom_sheet.dart`.
- **1.7-AC10** — Open the featured screen with a non-empty library — expect
  three equal-width stat tiles (total games, wishlist, this week) in that order,
  figure above label, no icons and no blue/orange/green tints, 12px gaps between
  them and 20px below. No automated test covers `LibraryStatsWidget`.
- **1.6-AC2** — Render `ContextChip` over busy artwork — expect the blur to read
  as glass and to stop at the capsule's rounded edge (structure is correct; only
  the visual can confirm it).
- **1.7-AC5** — Render `StatPill` with 2 and with 3 entries over artwork —
  expect the pairs to read as evenly distributed. Note the trade-off flagged
  during that run: `Expanded` gives each pair an equal *slot*, so the outer pairs
  no longer touch the capsule's inner edges as `spaceBetween` would have made
  them.

### 1.8 / 1.9 Progress dots, provider row

- **1.8-AC12** — Open the welcome flow, both pages — expect page one to show a
  22-wide active dot then a 5-wide inactive dot, page two the reverse, at the
  same left alignment, same 6px gap, and same gap to the headline as before the
  run. Swipe forward and back, including a partial drag held mid-swipe, and
  confirm the dots track the page exactly as they do today.
- **1.9-AC12** — Open the sign-in screen — expect tapping either row to start
  that provider's sign-in; while in flight both rows ignore taps and only the
  tapped provider's row shows the busy indicator; on failure the inline error
  still renders below the rows and both rows remain tappable for a retry.
- **ALL-AC4** — Compare the two welcome pages and the sign-in screen against the
  pre-run build — expect no visible difference in size, colour, position,
  spacing or state anywhere. Pay particular attention to the sign-in row labels,
  which must still render at 70% ink, and to the 10px gap between the two rows.

---

## Week 2 Stage 2 — item 2.1 (Game card)

From the `game-card-20260821` run, QA `PASS — pending manual checks`. The card
replaced `GameItem` on the games grid and both shimmers, so most of these are
about a shipped screen changing appearance, not a new component in isolation.

- **2.1-C1** — Open Games, loaded grid, plus any `sm`/`xs` surface — expect `xs`
  64 wide and `sm` 132 wide; `md` fills its column. `md`'s 220 is a design
  reference, not enforced: two columns on a 360dp phone give each card ~168.
  Do not raise the shortfall as a defect.
- **2.1-C2** — Open Games, loaded grid, a game with cover art — expect a 3:4
  cover at r16 carrying the flat indigo→canvas wash, and expect the
  saturate/contrast desaturation to be **visibly absent**. The spec's 50%
  desaturation clause ships deliberately unmet by human decision; its absence is
  the pass condition, matching 1.3-AC7. Also expect no gradient scrim.
- **2.1-C12** — Open Games with a game whose title is long enough to truncate and
  whose platform list exceeds the size's cap, at `sm` and at `md` — expect
  ellipsis truncation, no yellow overflow stripe, the platform row clipped rather
  than scrolling, and the card's height identical to a short-title card in the
  same row.
- **2.1-C13** — Any surface rendering a `GameCard` with no `onTap` (both
  shimmers) — expect no ripple or press response on touch. The invocation half is
  covered by test; only the "inert card shows no press response" half is manual.
- **2.1-R2** — Open Games, loaded grid, at a narrow (~320dp) and a wide (~430dp)
  device — expect two columns, no clipped footer, no stretched cover, no overflow
  stripe. Note the card now draws **no surface fill** — `GameItem`'s Material
  `Card` wrapper is gone, so the grid reads as covers on the canvas. That is
  intended, and the leftover vertical space should read as whitespace, not as an
  empty box.
- **2.1-R4** — **Highest-value check of this set.** Tap a games grid card, then go
  back, twice: once for a game with cover art and once for a game with none —
  expect a shared-element cover transition in both directions in both cases, not
  a cross-fade and not a flash of the missing-art fallback. This is the path that
  fails silently: no analyzer error and no test catches a broken hero tag beyond
  the string assertion.
- **2.1-R5** — Open Games while the first page is loading — expect the skeleton
  cells to be the same shape and pitch as the loaded grid's cells, with no
  visible jump at the moment data arrives.
- **2.1-C4/C5/C6 at `xs`** — Any surface rendering a `GameCard` at `xs` (64px
  cover) with all three overlays supplied — expect the critic badge (top-left),
  library tick (top-right) and on-media status chip (bottom-left) to sit inside
  the cover without colliding or clipping. Overlay insets are a fixed 8 at every
  size, so `xs` is the tightest case and the only one no automated check covers.

---

## Week 2 Stage 2 — item 2.2 (Completion ring)

From the `completion-ring-20260821` run, QA `PASS — pending manual checks`. The
ring ships **unwired** — no caller until Game Detail in week 3/4 — so these need
the first real caller before they can be performed — no harness, see the preamble.

Six are tech-ac's own manual lines. **Four (C8, C9's colour, C10's colour, C5's
magenta) exist because the single indigo→magenta test was removed at Phase 4B by
human decision** — that one test was carrying more than the colour switch, so
these are now the only verification of those criteria. Recorded, not raised as a
defect.

- **2.2-C1** — Render all three sizes side by side — expect outer boxes measuring
  exactly 60×60, 80×80 and 88×88, fixed rather than minimums, and no way for a
  caller to pass a fourth diameter.
- **2.2-C4** — Render at 0 / 25 / 50 / 75 / 100 — expect the sweep to start at 12
  o'clock, run clockwise, and be proportional at each step. At 0 expect an
  untouched track with no round-cap dot anywhere on it. At 100 expect a fully
  closed circle.
- **2.2-C5** — Render at `-5` and `140` — expect `-5` to look identical to 0
  (track only) and `140` identical to 100 (closed magenta ring, `100%` label).
- **2.2-C8** — **Now the only verification of this criterion.** Render at 99, then
  99.9, then 100 — expect the arc `accentIndigo` at 99 and 99.9, switching to
  `accentMagenta` at exactly 100 and above. Expect one flat colour at a time: no
  gradient, no blend, no transition across the arc. Confirm the `100%` label and
  the magenta appear together and never one without the other.
- **2.2-C9** — Render at several values including 0 and 100 — expect the track to
  be the `ink12` token at every size and value, one continuous solid stroke for
  the full circle, never dashed or dotted, and never recoloured by value (at 100
  it is simply covered by the magenta ring). Confirm stroke weight 6 at the 60
  size and 8 at 80 and 88, and that the arc's cap is round.
- **2.2-C10** — Sweep the value across its whole range — expect magenta only at
  exactly 100 and above, and no value to produce red or any warning/error
  treatment.
- **2.2-C12** — Render all three sizes — expect the centre percentage at **14** at
  the 60 inline size (not §3.2's 15 — approved deviation, the even-number
  convention binds new code), 18 at 80 and 22 at 88, all display face 700 in ink.
  Confirm the widest label `100%` clears the ring stroke at the 60 size,
  including at a text scale above 1.0.
- **2.2-C13** — Render the 80 and 88 sizes with a caption — expect the caption at
  10 in the `ink55` token beneath the percentage, and dropped entirely at 60.
- **2.2-C2 / C3** — Render each size inside a `Row` with no width and inside a
  loose-constrained parent — expect no overflow stripe or layout exception,
  identical anatomy at all three sizes (track, then arc over it, then centred
  percentage), and no stretching or collapsing with the parent.
- **2.2-C14** — With a screen reader on, focus the ring at 37 — expect a single
  announcement of `37% completed` (approved copy, not `37% complete`), with the
  centre text not read a second time and the caption not announced.

---

## Week 2 Stage 2 — item 2.3 (Countdown + Countdown tile)

From the `countdown-20260821` run, QA `PASS — pending manual checks`. This item
rewired a **shipped screen** (Featured's countdown section) and changed a second
element on it (the rail's owned marker), so most of these are regression checks
on visible UI rather than new-component checks. Two need a scratch host: C11
(Remind is handler-gated, so it renders nowhere this run) and C13 (the tile ships
unwired).

- **2.3-C1/C9** — Featured, countdown game with a future release date — three digit
  blocks on 8% ink at radius `xs`, min width 40, `DAYS`/`HRS`/`MIN` caps at ink55
  directly under each block, no seconds group.
- **2.3-C1 (long)** — Featured, countdown game more than 99 days out — the day block
  shows all digits (e.g. `120`) and grows past its 40px minimum rather than
  clipping or wrapping.
- **2.3-C2** — Featured, counting state — the two colons sit on the digit baseline,
  not the caption baseline, at both figure sizes.
- **2.3-C4** — Featured, countdown game releasing today — the released label only: no
  digits, no colons, no unit labels, neutral ink, no green and no magenta.
- **2.3-C5** — Featured, countdown game with no resolvable release date — the
  caller's release-date text if IGDB supplied one, otherwise the caps
  unannounced-date label; no `00` placeholders, no empty box.
- **2.3-C6** — The same duration through `CountdownCard` and `CountdownTile` side by
  side — identical digits, labels and colon count; only surface treatment and type
  scale differ (22px figure on the card, 30px on the tile).
- **2.3-C7** — Featured with a screen reader on the countdown — one announcement
  reading the remaining time as a sentence, not three loose numbers. Released and
  unannounced states announce their own single label.
- **2.3-C8** — Featured countdown card — flat `#2F333C` fill at radius `lg`, no
  gradient, no elevation shadow, and **no cover thumbnail** (the 80×110 art is
  deliberately gone — human-confirmed, not a regression).
- **2.3-C10** — Featured, a countdown game that IS on the wishlist vs. one that is
  not — cyan reason line with an outline bookmark glyph in the first case; one
  neutral ink55 line with no glyph and no cyan in the second. **Needs a real
  wishlist entry** for the selected game to reach the true branch. This is the
  check that proves the wishlist-accuracy fix actually works end to end.
- **2.3-C11** — Not reachable in the app this run: `featured` passes no `onRemind`.
  When a caller is wired, check the ink12 `radius.xs` control, its outline bell
  glyph, that it is never green, and a hit target of at least 44px.
- **2.3-C13** — `CountdownTile` in a harness over a photographic background — glass
  32% fill with the blur visibly applied at radius `xs`, colons at the 40%
  countdown-colon token rather than ink12, caps micro labels beneath.
- **2.3-C15** — Featured, every countdown state — no emoji, no dingbat and no
  exclamation mark in any rendered string, in both `en` and `zh`.
- **2.3-C17/C18** — Featured, all four section paths: (a) success with a countdown
  game and releases; (b) the `Skeletonizer` loading path; (c) the countdown failure
  path; (d) no countdown game and no releases, where the section must still
  collapse. The out-this-week rail, its heading and its "n games" count must look
  and behave exactly as before the rewire.
- **2.3-Phase4B** — Featured, out-this-week rail with a game already in the local
  library — the owned marker is now `LibraryTick`'s 20×20 indigo circle with a 12px
  ink check, replacing the old green circle with a white check. The green→indigo
  change is the intent; confirm it reads correctly over cover art.
- **2.3-l10n** — Featured with the device set to Chinese — the nine new keys render
  at their token sizes without clipping (`发售日期待公布` and `距发售还有 … 分钟` are
  the longest), and the caps type tokens degrade harmlessly on CJK, which has no
  uppercase form.

---

## Week 2 Stage 2 — item 2.4 (Tab bar) — CLEARED 2026-08-25

**All fifteen are done. Nothing remains here.** Kept as a record rather than
deleted, because this item carried more manual weight than any other — four widget
tests were removed at Phase 4B by human decision, and the bar deliberately lost a
shipped behaviour.

Twelve were performed and passed, including both entries that had no automated
guard at all: `MC-1` (keyboard Enter/Space activation — the
`ButtonPressScale`/`ActivateIntent` defect) and `MC-2` (the selected/unselected
colour correction, which the old `CustomNavigationDestination` had shipped
**inverted** the whole time). **Both are now confirmed on device rather than
inferred.** `MC-10` was verified afterwards by switching navigation modes on the
one emulator rather than sourcing a second device.

`MC-4` and `MC-13`'s duration halves were **closed by human decision without being
observed** — 0ms versus 140ms on a colour crossfade is at or below naked-eye
perception, and the human judged the distinction not worth a frame-accurate
recording. `MC-13`'s negative half (nothing slides horizontally, the bar never
animates its own height, position or background) did pass by eye.

Two notes that outlive the checks. `MC-9` passed, but the Tracker glyph is declared
`Icons.format_list_numbered_rtl` with **no `_outlined` suffix**, unlike the other
four — invisible in the render, real in the source, so it is a tidiness point
rather than a bug. And `MC-12` was **under-exercised**: it wants over-long *Chinese*
labels to ellipsise, but `tracker` and `browse` rendered as English at the time.
Both strings were translated on 2026-08-25, so that case is now genuinely
reachable and is worth one more look next time a device is out.

---

## Week 2 Stage 2 — item 2.5 (Form fields)

From the `form-fields-20260823` run, QA `PASS — pending manual checks`. Ten
criteria passed automatically, these eight are pixel-appearance only. Every text
input in the app now renders through `LabeledTextField`, so a single wrong token
shows up on **three shipped surfaces at once** — the Add-content dialog, the
filter sheet, and the tracker's task detail editors.

**Three of those surfaces change appearance on merge, deliberately** (GATE-1,
option A). Seeing that once is worth as much as any single check below: the
change is expected, and the point is to confirm it looks right rather than to
confirm nothing moved.

- **2.5-MC-1** `[2.5-AC5]` — Open the filter sheet, Search field untouched — a
  solid `surfaceRaised` (#2f333c) fill at radius 16 and **no stroke on any edge**,
  including the two read-only date fields.
- **2.5-MC-2** `[2.5-AC7]` — Add-content dialog, tap into Title — a 2px green ring
  drawn **outside** the box at a 2px gap, fill unchanged, ring gone on blur. Green
  appears nowhere else in the field.
- **2.5-MC-3** `[2.5-AC8]` — Add-content dialog, submit with Title empty — the fill
  swaps to the error tint (the raised fill must not show through) plus a 1px
  error-line hairline on the box edge; both clear once a valid value is entered and
  validation re-runs.
- **2.5-MC-4** `[2.5-AC10]` — **The point of the whole error design.** Same dialog,
  submit empty then tap back into Title — the green ring and the error hairline are
  visible **at the same time**, neither suppressing the other. This is what "error
  and focus never fight for the same edge" means, and it is the reason the widget
  composes its own `FormField` instead of using `TextFormField`.
- **2.5-MC-5** `[2.5-AC11]` — Same state, re-run validation on unchanged content —
  no glow, no shake, no icon inside the box, and the typed text unchanged.
- **2.5-MC-6** `[2.5-AC13]` — Add-content dialog, Description (minLines 5, maxLines
  null) — label above the box, fill wrapping the whole grown box, focus and error
  treatment identical to the single-line Title.
- **2.5-MC-7** `[2.5-AC17]` — Every configuration, especially the filter sheet's
  read-only date fields and a single-line field with no placeholder — the tappable
  box measures at least 44px tall.
- **2.5-MC-8** `[2.5-AC18]` — Any of the three surfaces — label and validation
  message at 14/500, input and placeholder at 16/400, counter at 13/400. Token
  values were verified in source; only the rendered result is manual. Note this is
  the **third** run to hit the 15px collision (after 1.9 and 2.2) — it ships at 14
  by human decision, so a label looking a touch small is expected, not a defect.

---

## Week 2 Stage 2 — item 2.6 (Rows & hairline groups)

From the `rows-hairline-20260824` run, QA `PASS — pending manual checks`. Ten of
thirteen criteria passed automatically; these three are the ones the project's own
rules forbid testing (dimensions, radii and stroke widths are never asserted in a
widget test).

**All three wait for a real caller** (no harness — see the preamble) — `LabelValueRow` and `HairlineGroup` ship
**unwired**, with no caller anywhere in the app. Same position 2.2's completion ring
is still in. Cheapest route is to check these the first time a real screen adopts
the components rather than building a harness twice.

- **2.6-MC-1** `[2.6-AC6]` — Host a `LabelValueRow` — expect 16 horizontal / 14
  vertical interior padding, and confirm the row's height clears a 44px touch
  target once it sits in a group.
- **2.6-MC-2** `[2.6-AC7]` — Host a `HairlineGroup` of three rows — expect the card
  corners clipped at r16 with the `surfaceRaised` fill reaching the rounded edge,
  and no child painting outside the clip.
- **2.6-MC-3** `[2.6-AC10]` — Same group — expect each separator to read as a 1px
  hairline at the `hairline` token, and confirm by eye what the tests already prove
  by count: a separator between rows only, never above the first or below the last.

---

## Week 2 Stage 2 — item 2.7 (Error states)

From the `error-states-20260824` run, QA `PASS — pending manual checks` after 2
cycles. Thirty of thirty-five criteria passed automatically; these five are visual.

**All five wait for a real caller** (no harness — see the preamble) — the `error_states/` module ships **unwired**,
with no caller anywhere. Same position as 2.2's ring and 2.6's rows. One harness
hosting all three levels would clear these in a single sitting.

- **2.7-MC-1** `[2.7-AC10]` — Host an `ErrorNotice` in each variant — the **strip**
  reads as an error-tinted panel with a 1px `errorLine` edge and its message in
  `errorInk`; the **toast** reads as a single line on `surfaceToast` (`#2e3236`)
  carrying a red dot rather than an icon, with its message in `ink`. Confirm the
  toast holds one line at 390px width.
- **2.7-MC-2** `[2.7-AC26]` — **Known spec gap, check what it actually looks like.**
  Host a `FailedItem` wrapping a `GameCard` that is *also* in the library.
  `failed_item.dart:29-31` and `game_card.dart:97` are character-identical
  `Positioned(top: 8, right: 8)`, so the red badge lands directly on the indigo
  library tick. §3.4 asks for the same slot and never says what happens when both
  marks apply. **This needs a design answer, not a code fix** — see the handover
  follow-up. Look at it before deciding.
- **2.7-MC-3** `[2.7-AC29]` — Open Game Detail and confirm the screenshots deletion
  changed nothing visible: the "Screenshots" heading still renders and no gap or
  stray spacing appeared where the commented-out section used to sit.
- **2.7-MC-4** `[2.7-AC13/15/17]` — `ErrorNotice` strip: the dismiss control reads as
  tappable at a 44px target, and dismissing then re-showing the strip looks
  identical the second time.
- **2.7-MC-5** `[2.7-AC21]` — `FailedItem`: the child dims to 55% *including cover
  artwork* (an opacity, not a text recolour), the error hairline is visible against
  the dimmed content, and the corner badge carries no text at any size.

---

## Week 2 Stage 2 — item 2.8 (Async states: shared empty state)

From the `async-empty-state-20260824` run, QA `PASS — pending manual checks`, 0
cycles. Twenty-six of twenty-eight criteria passed automatically; AC-15 and AC-16
are worded observationally and cannot be asserted, and the rest are visual.

**These need no waiting** — unlike 2.2, 2.6 and 2.7, this module
ships **wired** at five live sites, so every check is reachable by driving the real
app.

**`MC-1`, `MC-2` and `MC-5` are cleared as of 2026-08-25.** Both Browse tab-switch
actions work, and site 5's card now renders where the section used to vanish
silently. `MC-5` was a wording judgement and the judgement was made: the headline
became **"Nothing matches yet"** and the action became **"Clear filters"**, which now
resets `FilterState` through a new `GamesFiltersCleared` event rather than re-running
the same failing filters. **This overrides `2.8-AC-24`**, which had mandated reusing
the `no_results_found` key — a human decision, not drift. Both keys were renamed
(`nothing_matches_yet`, `clear_filters`) since each had exactly one call site.

**Three sites cannot be reached without forcing them**, because they only appear
when the app genuinely has no data. Flip the guard, hot-restart, look, then revert
(`git checkout lib/` clears them all):
`featured_screen.dart:200` → `if (false)` for site 5,
`countdown_releases.dart:87` → `if (true)` for site 4 **plus** the featured_screen
edit above (the two sites are mutually exclusive — forcing only `countdown_releases`
does nothing, because the parent returns site 5's card and never builds that widget),
`critics_grid.dart:149` → `if (true)` for site 3,
`library_stats.dart:271` → `if (true)` for site 2.

**Site 1 needed no forcing after 2026-08-25** — it was unreachable for a different
reason entirely (`GamesStatus.empty` was never emitted; see `handover.md`), and a
real filter that returns nothing now shows it.

- **2.8-MC-3** `[2.8-AC14]` — **Human-approved side effect, confirm it looks right.**
  Featured with genre preferences selected and the critics grid empty (site 3, "OPEN
  UP YOUR GENRES") — tap **Show every pick**. Expect exactly one reload, and expect
  the genre-picker row above the grid to disappear, because `skipGenrePreferences()`
  also sets `isSkipped: true`. Approved at this run's Phase 3 gate; the check is
  whether the section looks coherent with the picker gone, not whether it happens.
- **2.8-MC-4** — `EmptyStateCard`'s appearance at all five sites: one raised-surface
  card (`#2F333C`) at r16 holding, top to bottom, an optional 44px glyph at ink55, a
  capitalised headline at 22/700 in full ink, one wrapping supporting line at
  16/1.45/400 in ink70, and one full-width green primary button. **Sites 3 and 4 lost
  fixed heights of 160 and 170**, and sites 3–5 lost their old surface, so check none
  overflows or collapses. Site 2's card must read as solid-edged and undashed — that
  card is the "outlines are always solid" violation this item was reserved to fix.
  Note the card declares no width of its own; it fills its parent only because
  `PrimaryButton` sets `width: double.infinity`.
---

## Week 3 Stage 3 — item 3.2 (Tab swap, Library and Feed shells)

From the `library-tab-swap-20260826` run, QA `PASS — pending manual checks`, 0 QA
cycles. 38 of 39 criteria passed automatically (`3.2-AC34` was retired by human
decision D8). **These six are reachable in the app right now** — unlike most of this
file, they need no screen that does not exist yet.

- **3.2-MC-1** `[3.2-AC1]` — Open the app, any tab — expect five tabs left to right:
  Featured (`featured_play_list_outlined`), Library (`collections_bookmark_outlined`),
  Browse (`search_outlined`), Feed (`dynamic_feed_outlined`), Settings
  (`settings_outlined`), the selected one indigo in glyph, label and cap, the other
  four ink-55.
- **3.2-MC-2** `[3.2-AC1]/[3.2-AC19]` — **The highest-risk check of the six.** Switch
  the device locale to Chinese — expect 精选 · 游戏库 · 浏览 · 动态 · 设置, and expect
  **游戏库 not to clip or wrap**. It is the first three-character label this bar has
  ever carried, in a cell that did not grow. The `textScaleFactor: 2` case passes in
  the suite, so this is a visual-fit check at normal scale, not a correctness one.
  **`收藏` is pre-approved as the fallback if it clips. Never widen the cell.**
- **3.2-MC-3** `[3.2-AC11]/[3.2-AC14]` — Open Library — expect the title "Library" and
  one `EmptyStateCard` (NO GAMES SAVED, its supporting line, a "Browse games" button),
  with no spinner, no error state, no recruit card, no status chips, no search field,
  no view toggle and no count line. Tapping the button must land on **Browse**, the
  third tab.
- **3.2-MC-4** `[3.2-AC32]` — Open Feed — expect the title "Feed" and a single
  vertically centred "Coming Soon": no card, no glyph, no button. **This screen has
  zero automated coverage by human decision D8, so this is the only run-time look it
  will get before it ships.**
- **3.2-MC-5** `[3.2-AC35]` — Open Browse — expect the app-bar title to read "Browse"
  with the existing subtitle "Search for your favourite games here" unchanged beneath
  it.
- **3.2-MC-6** `[3.2-AC6]` — **NOW PERFORMABLE as of item 3.4b (2026-08-30).** It was
  blocked because `library_stats.dart:314` sits in the `playingGames.isNotEmpty` branch,
  which had never rendered — Featured's `statusEqualTo('Playing')` filter has no writers.
  3.4b repointed that source at `library_entries`, so the branch can fire for the first
  time in the app's history. Perform it as **3.4b-MC-1** below, which supersedes this
  entry; do not run both.

---

## Week 3 Stage 3 — item 3.4b (Featured repair)

Landed 2026-08-30, impl `d172b58`. One check, and it is the only thing between item 3.4b
and a plain QA PASS. **Requires at least two games at status `playing` in
`library_entries` for the signed-in user** — add them through the Library before sitting
down, or the interesting half cannot be run.

- **3.4b-MC-1** `[3.4-AC36]` — Supersedes `3.2-MC-6`. With **exactly one** game at status
  `playing`, open Featured and tap the now-playing card — expect the **Library** tab
  (index 1). Not Browse, and **not** the tracker game-detail screen: that push was removed
  by D14, and the single-game branch is the one that used to make it. Then repeat with
  **several** playing games (the card reads "+N more playing") — expect the same Library
  tab. **Index 1 has never executed in either branch**, so both halves are a first run,
  and the two branches used to do different things — checking only one proves nothing
  about the other.

---

## Also deferred, for a different reason

Not QA manual checks, but the same "needs a device or a thing that doesn't exist
yet" shape. Full detail in `handover.md`.

- **Item 3's cross-account RLS check** — blocked until week 3's Library feature
  writes to `library_entries`; nothing in the app writes there yet.
- **Item 8's four deep-link checks** — blocked on Android having no `VIEW`
  intent filter for app routes, so URL deep links can't be delivered at all.

# Manual check backlog — QuestLoggd

Every on-device check that a QA pass identified but nobody has performed. All of
these shipped as `PASS — pending manual checks`: the automated side passed, and
the remaining criterion is something only a human looking at a real device can
confirm — paint overflow, `BackdropFilter` edge bleed, colour fidelity, a held
drag mid-gesture.

**This file is the durable home for these.** It was created 2026-08-20 when the
week 2 Stage 1 run folders were retired — their `qa-report.md` files had been
the only copy, so the checks were consolidated here first (gotcha #9 in
`handover.md`: promote before deleting, and verify the promotion happened).

**Tick a check off by deleting it**, once performed and passing. If one fails,
it stops being a backlog item and becomes a bug — file it properly rather than
leaving a failing check sitting here.

None of these block anything. They are a debt to settle when a device is
available, ideally in one sitting per screen rather than one item at a time.

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
  or a scratch harness) — expect the blur to stop exactly at the pill outline
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

## Also deferred, for a different reason

Not QA manual checks, but the same "needs a device or a thing that doesn't exist
yet" shape. Full detail in `handover.md`.

- **Item 3's cross-account RLS check** — blocked until week 3's Library feature
  writes to `library_entries`; nothing in the app writes there yet.
- **Item 8's four deep-link checks** — blocked on Android having no `VIEW`
  intent filter for app routes, so URL deep links can't be delivered at all.

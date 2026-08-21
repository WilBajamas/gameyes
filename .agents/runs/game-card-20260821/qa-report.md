# QA Report
Source: `.agents/runs/game-card-20260821/tech-ac.md` — week 2 Stage 2 item 2.1, Game card
Date: 2026-08-21
Verified at: `1b8c958` (Dev commit `26b5951` plus the human's enum-move commit)

Overall result: PASS — pending manual checks

## Manual verification required

Carry all eight to `.agents/manual-check-backlog.md`.

[2.1-C1] — Open Games, loaded grid, plus any `sm`/`xs` surface — expect `xs` 64 wide and
`sm` 132 wide; `md` fills its column. `md`'s 220 is a design reference, not enforced: two
columns on a 360dp phone give each card ~168. Do not raise the shortfall as a defect.

[2.1-C2] — Open Games, loaded grid, a game with cover art — expect a 3:4 cover at r16
carrying the flat indigo→canvas wash, and expect the saturate/contrast desaturation to be
**visibly absent**. The spec's 50% desaturation clause ships deliberately unmet (resolved
OQ-1); its absence is the pass condition, matching live check 1.3-AC7. Also expect no
gradient scrim.

[2.1-C12] — Open Games with a game whose title is long enough to truncate and whose
platform list exceeds the size's cap, at `sm` and at `md` — expect ellipsis truncation, no
yellow overflow stripe, the platform row clipped rather than scrolling, and the card's
height identical to a short-title card in the same row.

[2.1-C13] — Any surface rendering a `GameCard` with no `onTap` (both shimmers) — expect no
ripple or press response on touch. The invocation half is covered by test; only the
"inert card shows no press response" half is manual.

[2.1-R2] — Open Games, loaded grid, at a narrow (~320dp) and a wide (~430dp) device —
expect two columns, no clipped footer, no stretched cover, no overflow stripe. Note the
card now draws **no surface fill** — `GameItem`'s Material `Card` wrapper is gone, so the
grid reads as covers on the canvas. That is intended (tdd.md decision 5), and the leftover
vertical space should read as whitespace, not as an empty box.

[2.1-R4] — **Highest-value check.** Tap a games grid card, then go back, twice: once for a
game with cover art and once for a game with none — expect a shared-element cover
transition in both directions in both cases, not a cross-fade and not a flash of the
missing-art fallback.

[2.1-R5] — Open Games while the first page is loading — expect the skeleton cells to be
the same shape and pitch as the loaded grid's cells, with no visible jump at the moment
data arrives.

[2.1-C4/C5/C6 at `xs`] — Any surface rendering a `GameCard` at `xs` (64px cover) with all
three overlays supplied — expect the critic badge (top-left), library tick (top-right) and
on-media status chip (bottom-left) to sit inside the cover without colliding or clipping.
Overlay insets are a fixed 8 at every size, so `xs` is the tightest case and the only one
no automated check covers.

## Static analysis

Status: PASS
Errors: NONE

`dart run build_runner build --delete-conflicting-outputs` ran clean and wrote no change to
the working tree — generated code is current, so analysis is meaningful.

`flutter analyze`: 33 issues — 0 errors, 2 warnings, 31 info. Byte-identical to the
`Analyzer baseline` in `orchestrator-state.md`. No diagnostic of any severity is attributed
to an allowlisted file. Both warnings are the recorded `_TaskReminder` pair in
`task_detail_screen.dart`, untouched by this run. No `deprecated_member_use` for `GameItem`
anywhere, which independently confirms 2.1-R7.

## Test results

Status: PASS
Tests run: 294  |  Passed: 284  |  Failed: 10

`+284 -10` against a `+267 -10` baseline — exactly the 17 new tests, all passing. The 10
failures are the recorded pre-existing set, confirmed by name:

- `test/repository/tracker/tracker_repository_test.dart` — 4
- `test/cubit/game_detail/game_detail_cubit_test.dart` — 3
- `test/cubit/games/games_bloc_test.dart` — 3

No new failure, in scope or out. Testing mode is `smoke`, so no coverage run.

## Coverage gaps (coverage mode only)

N/A — testing mode `smoke`.

## Acceptance criteria

2.1-C1: PASS — `game_card/enum/game_card_size.dart:3-6` declares exactly three values and
no variant hook; one structure proven by the size tests `hides the title at xs`, `shows the
title and the platform row capped at one at sm`, `shows the release date, the platform row
and the add action at md`. Widths themselves are manual (above).

2.1-C2: MANUAL — `game_card.dart:115-116` (3:4 `AspectRatio`), `:86,88` (`radius.lg` clip),
`:147` (`ColoredBox(color: tokens.color.coverWash)` over the image, no scrim). The
desaturation clause is deliberately unmet per resolved OQ-1 and is not a defect; the manual
check confirms its absence.

2.1-C3: PASS — `game_card.dart:137-139` routes a null or empty url to `_MissingArt`, and
`:152-153` routes a load error to the same widget; `_MissingArt` (`:167-176`) is
`colors.canvas` fill + `Border.all(colors.hairline)` + `Icons.videogame_asset_outlined`. No
title initial, no `error404` asset. Test: `shows the missing-art glyph when no cover url is
supplied`, which also asserts no `DefaultCachedNetworkImage` is built.

2.1-C4: PASS — `game_card.dart:96-97`, gated on the caller's `inLibrary` only; nothing in
the module reads library membership from the entity. Tests: overlays-present and
overlays-absent pair in `game_card_test.dart`, plus `games_screen_test.dart`'s
`shows a card for each game with no status chip and no library tick`.

2.1-C5: PASS — `game_card.dart:98-110`, `StatusChipVariant.onMedia`, bottom-left, built
only when `status != null`, with no reserved gap in the `Stack` otherwise. Test asserts the
chip's `status` and `variant` as public properties.

2.1-C6: PASS — `game_card.dart:94-95` (top-left, present iff a score is supplied);
`critic_badge.dart:5-7` takes `score` and nothing else — no colour, threshold, variant or
ramp parameter exists to reintroduce featured's 80/60 bands. Rounding and the single green
are owned and tested in `critic_badge_test.dart`.

2.1-C7: PASS — `game_card.dart:50` builds the footer only when `size.hasFooter`, and
`game_card_size.dart:15` excludes `xs`. Test: `hides the title at xs`.

2.1-C8: PASS — `game_card_small_footer.dart:28-35` title, `:44-53` the shared
`PlatformRowList` at `showMax: 1`, `:56-60` the critic number present only with a score. No
release date and no add control in the file. Test asserts the row's `showMax` and
`platforms` inputs, never a loaded logo.

2.1-C9: PASS — `game_card_medium_footer.dart:31-38` title, `:45-51` release date,
`:58-64` the shared row at its own cap, `:67-72` the add `IconButton` built only when
`onAddTap != null`. Tests: `shows the release date, the platform row and the add action at
md` and the all-absent test.

2.1-C10: PASS — the add control is a distinct `IconButton` inside the footer, so it wins
the gesture arena over the card's outer `InkWell`. Test: `calls the add action without
calling the card tap when the add is tapped` asserts both halves.

2.1-C11: PASS — `PlatformRowList` is composed unchanged in both footers, with no error or
loading builder added; the null/empty guard is `small_footer.dart:44` and
`medium_footer.dart:58`, each falling through to a `Spacer` so no row and no reserved gap
appear. Bounded box: `SizedBox(height: 16)` inside an `Expanded` in both. The §1.9
text-abbreviation deviation is the recorded human decision and is not raised here.

2.1-C12: MANUAL — implementation supports it: every footer slot is a fixed-height
`SizedBox` (`small_footer.dart:24,38`; `medium_footer.dart:27,41,54`) and
`game_card_footer.dart:23-24` pins the whole footer to `size.footerHeight`, so card height
cannot grow with content; titles carry `maxLines` + `TextOverflow.ellipsis`. The
no-overflow-stripe outcome is a pixel observation, moved to manual by D3.

2.1-C13: PASS (tap half) — `game_card.dart:37-38` passes `onTap` straight to the `InkWell`,
so a null callback is inert. Test: `calls the tap action once when the card is tapped`.
The "no ripple when inert" half is manual (above), per D3.

2.1-C14: PASS — `game_card.dart:119` builds
`'${ConfigConstants.heroTag}/${game.id}/$fromScreen'` verbatim, and `:115-122` wraps the
whole cover box, fallback included, so the tag survives missing art. Test: `uses the shared
hero tag built from the game id and fromScreen` asserts the exact string.

2.1-C15: PASS — every constructor parameter but `size` is optional
(`game_card.dart:14-24`); both footers render `GameCardPlaceholderBar` when `game == null`;
`:117` registers a `Hero` only when both `game` and `fromScreen` are non-null. Test:
`registers no hero when several dataless cards render together`.

2.1-R1: PASS — `games_screen.dart:136-140` passes `GameCardSize.md`, the game,
`RouteConstants.games` and `criticScore`, and passes no `status`, no `inLibrary` and no
`onAddTap`. Test: `shows a card for each game with no status chip and no library tick`.

2.1-R2: PASS — `games_screen.dart:118-133`: `SliverLayoutBuilder` derives `columnWidth`
from the live cross-axis extent through `GamesGridConstants.columnWidth`
(`const.dart:97-98`), `childAspectRatio` is gone, and `mainAxisExtent` is
`GameCardSize.md.cellHeightFor(columnWidth)`; `crossAxisCount` stays 2. Test: `renders the
grid without overflow at a narrow and a wide surface` at 320 and 430, asserting no
exception and that title text is still found. Grid appearance is manual (above).

2.1-R3: PASS — `games_screen.dart:142-147` builds the `(id, RouteConstants.games,
cover.url)` record and pushes `GameDetailRoute` unchanged. Test: `pushes the game detail
route with the unchanged payload when a card is tapped` captures the pushed route and
asserts the record.

2.1-R4: MANUAL — no automated check exists by design; C14 is the automated half. See the
manual list.

2.1-R5: PASS — `game_item_grid_loading_shimmer.dart:13-28` uses the same
`GamesGridConstants.columnWidth` + `cellHeightFor` derivation as the live grid and builds
`const GameCard(size: GameCardSize.md)`, i.e. dataless, so no `Hero` and no duplicate tag.
Test: `renders the grid shimmer cells without throwing`. Skeleton shape is manual.

2.1-R6: PASS — `game_item_loading_shimmer.dart:11-19` rewired to dataless
`GameCard(size: GameCardSize.sm)` inside a `SizedBox` bounded by
`GameCardSize.sm.cellHeightFor(GameCardSize.sm.width)`. Not deleted, class and file name
unchanged. Test: `renders the horizontal shimmer cells without throwing`.

2.1-R7: PASS — `game_item.dart:9` carries
`@Deprecated('Use GameCard in lib/widgets/game_card/game_card.dart')`, the file still
exists, and a repository search for `GameItem` across `lib/` returns hits only inside
`game_item.dart` itself (`:10`, `:16`). Independently confirmed by the analyzer emitting no
`deprecated_member_use` for it.

2.1-R8: PASS — `.claude/skills/flutter-widgets/SKILL.md:139-144`: `GameCard` at
`game_card/game_card.dart` with its public-surface note, new `LibraryTick` and
`CriticBadge` rows, `GameItem` marked deprecated, and both shimmer rows re-described as
shimmering the new card. Rule text in that file is unedited.

## Architectural compliance

Status: PASS

Checked against `tdd.md` + `code-plan.md`'s D1–D4 delta, and independently against the
`flutter-widgets` and `flutter-widget-test` skills.

FAILs: NONE

**`tdd.md` / D1–D4** — module layout, class names, visibility and public surface all match:
six files under `lib/widgets/game_card/`, one class per file, no barrel and no `export`, and
a grep confirms nothing outside the folder imports `GameCardFooter`,
`GameCardSmallFooter`, `GameCardMediumFooter` or `GameCardPlaceholderBar`. `GameCardSize`
carries `width`/`footerHeight`/`fillsParent`/`hasFooter`/`cellHeightFor` as designed and is
the single source of the cell geometry both the grid and the grid shimmer call. No package
added to `pubspec.yaml`. `GamesGridConstants` sits in the shared `lib/core/res/const.dart`
as specified. Deviations reported by Dev: none, and git agrees.

**`flutter-widgets`** — all eight new widget files carry **zero comments** of any kind,
checked line by line. Every dimension written in code is even (64/132/220, 0/56/126, 8, 24,
20, 48, 18, 44, 16, 12, 20/12, 6/2). All colours, radii and text styles come from
`context.tokens`; no hex literal, no `Colors.*`, no `Theme.of(context)` in any of the eight.
`Border.all` is a solid stroke. No `Widget`-returning function or getter. `Expanded`, not
`Flexible`, for the platform row. The card, tick and badge add no outer padding or margin
and expose no padding parameter. Cover art goes through `DefaultCachedNetworkImage`;
`PlatformRowList`'s bare `Image.network` is untouched. `S.current.add_to_library` is the
only new user-facing string and exists in both `.arb` files and all three generated files.
Navigation stays on `context.router`.

**`flutter-widget-test`** (read in full; existing repo test files were not used as
evidence) — all four test files clear the checklist. No assertion anywhere measures a
dimension, gap, radius, offset or position; `tester.view.physicalSize` is used to size the
*surface* under test, never asserted. No `matchesGoldenFile` and no golden anywhere. Exactly
one colour assertion exists in the whole run — `critic_badge_test.dart:33`,
`AppColorTokens.dark.green` named by token, in the file of the widget that owns the colour,
protecting C6's "the badge is one colour". No fake image bytes, no `Completer`, no manual
`imageBuilder`/`errorWidget` invocation, no zone, no arbitrary delay, no swallowed error
(`takeException()` is asserted `isNull`, not discarded). No theme or token pre-resolution in
`setUpAll`; `buildDarkTheme()` is passed into the pumped widget in every file. Mock data
comes from `test/mocks/`, never inline. Test names are behaviour statements; no test carries
a comment. The `tester.widget<T>()` uses are all the sanctioned kind — a composed public
component's supplied domain value or documented variant (`StatusChip.status`/`.variant`,
`CriticBadge.score`, `PlatformRowList.showMax`/`.platforms`, `Hero.tag`) — never a builder
invoked by hand. Under-coverage relative to a `Verify:` line is the D3 trim and is expected.

WARNINGs:

1. **Import ordering is no longer alphabetised in six files** — `game_card.dart:8-9`,
   `game_card_footer.dart:3-5`, `games_screen.dart:13-14`, both shimmers, and two test
   files each place `widgets/game_card/game_card*.dart` before
   `widgets/game_card/enum/game_card_size.dart`, where `enum/` sorts first. Dev's ordering
   was correct at `26b5951`; the human's rename commit `1b8c958` moved the enum without
   resorting the import blocks. Cosmetic, no analyzer diagnostic, and human-authored — noted
   for whoever next edits these files, not routed anywhere.
2. **`enum/` (singular) vs the repo's `lib/core/enums/` (plural)** — the new subfolder from
   `1b8c958` names itself differently from the only other enum folder in the project. Also
   human-authored; flagging only so the naming is a deliberate choice rather than drift.
3. **`.claude/skills/flutter-widgets/SKILL.md`'s "one file per widget family" rule text
   still contradicts `lib/widgets/game_card/`** — the human-approved subfolder exception was
   recorded but the rule sentence was not updated, by explicit decision. Known follow-up,
   restated here only so it is not lost.

## Advisory — outside this run

`lib/widgets/primary_button.dart:29` defaults its fill to `tokens.color.green`, a third
`color.green` resolution in `lib/` beyond `critic_badge.dart:15` and the focus ring at
`button_press_scale.dart:40`. Confirmed pre-existing and outside this run's allowlist. Dev
flagged rather than fixed it, which was correct. Recording it as a candidate follow-up —
either the button is a sanctioned CTA green and the two-exception wording in the catalogue
needs widening, or it is a leak and belongs to a run that owns that file. Not a defect
against item 2.1.

## Escalation required

NONE — `escalation.md` not written.

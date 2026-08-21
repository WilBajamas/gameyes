# Technical Design Document
Source: `.agents/runs/game-card-20260821/tech-ac.md` — week 2 Stage 2 item 2.1, Game card
Date: 2026-08-21
Revised: 2026-08-21 at the Phase 3 gate. The card became a multi-file module, the two
cover overlays were promoted to app-wide widgets, and the test plan was trimmed. Full
reasoning and the authoritative wording are in `code-plan.md ## Approved feedback delta`
(D1–D4); the sections below are corrected so the design and the file allowlist agree.

## Feature summary

One new global widget module, `GameCard` (`lib/widgets/game_card/`), replaces `GameItem`
at its three call sites, alongside two new app-wide primitives lifted out of it,
`LibraryTick` and `CriticBadge`. It is presentation-only: no bloc, no use case, no
repository, no API. Everything it shows is either read off the `GameEntity` it is handed
(title, release date, platforms, cover url) or passed in as a discrete parameter (critic
score, status, library membership, tap and add callbacks). Three sizes come from one enum
that also owns the card's cell geometry, so the games grid and the grid shimmer derive
their cell height from the card instead of hardcoding an aspect ratio. Composition reuses
the Stage 1 primitives and existing app widgets — `StatusChip`, `PlatformRowList`,
`DefaultCachedNetworkImage` — and adds nothing to any of them.

## Layer map

- 2.1-C1 … C15: UI (shared widget)
- 2.1-R1, R2, R3, R4: UI (games screen)
- 2.1-R5, R6: UI (shared shimmer widgets)
- 2.1-R7: UI (deprecation of the retired widget)
- 2.1-R8: Documentation

No data, domain or state layer is touched by any criterion.

## Data layer

None. No API contract, model, repository or datasource is created or changed.

## Domain layer

None. `GameEntity`, `PlatformEntity`, `GameCoverEntity` and `ReleaseDateEntity` are
consumed as they are.

## State layer

None. `GamesBloc` and `GamesState` are unchanged; `GamesSliverGrid` keeps reading
`state.games` through the same `context.watch` boundary it uses today.

## UI layer

### Widgets

**`GameCard` (create) — `lib/widgets/game_card/game_card.dart` — stateless.**
Consumes: `GameCardSize size` (required), `GameEntity? game`, `String? fromScreen`,
`double? criticScore`, `LibraryStatus? status`, `bool inLibrary`, `VoidCallback? onTap`,
`VoidCallback? onAddTap`. Interactions: whole-card tap through an `InkWell` that is
inert when `onTap` is null (C13); a separate inline add control at `md` that fires only
`onAddTap` (C9, C10). Registers a `Hero` around the cover box when — and only when —
both `game` and `fromScreen` are non-null (C14, C15). File-private children that stay in
this file: `_CardCover`, `_CoverArt`, `_MissingArt`. No comments anywhere in the file,
per `flutter-widgets`.

**The card is a multi-file module — `lib/widgets/game_card/`.** The footers each get
their own file beside the card, and the placeholder bar moves with them because both
footers use it:

| File | Class | Visibility |
|---|---|---|
| `game_card.dart` | `GameCard` | public, module entry point |
| `game_card_size.dart` | `GameCardSize`, `coverAspectRatio` | public |
| `game_card_footer.dart` | `GameCardFooter` | module-internal |
| `game_card_small_footer.dart` | `GameCardSmallFooter` | module-internal |
| `game_card_medium_footer.dart` | `GameCardMediumFooter` | module-internal |
| `game_card_placeholder_bar.dart` | `GameCardPlaceholderBar` | module-internal |

"Module-internal" means public in Dart's sense — they are no longer file-private — but not
app-wide: they carry the `GameCard` prefix, they are not in the reusable-widget catalogue,
they get no dedicated test file, and nothing outside the folder imports them. The card
moves into the folder rather than sitting beside it, so the module's entry point is at its
root. `GameCardSize` moves to its own file because the footers need it and the card
imports the footers — leaving the enum in `game_card.dart` would close an import circle.
No barrel file: a caller needing both writes two imports. Naming follows the one rule this
repo is consistent about — one class per file, file named the snake_case of the class.

**`GameCardSize` (create) — `game_card_size.dart` — enum, three values.**
`xs` width 64, `sm` width 132, `md` width 220. Carries `width`, `footerHeight`,
`fillsParent`, `hasFooter` and `cellHeightFor(double cardWidth)`. This enum is the single
source of truth for the card's geometry; the games grid and the grid shimmer both call
`cellHeightFor` rather than restating a ratio (R2, R5).

**`LibraryTick` (create) — `lib/widgets/library_tick.dart` — stateless, app-wide.**
A 20px indigo circle with a check, marking a cover as already in the library (C4). No
parameters — it is a fixed glyph with nothing a caller varies. Catalogued as a
component-library primitive; the card composes it, it does not own it.

**`CriticBadge` (create) — `lib/widgets/critic_badge.dart` — stateless, app-wide.**
A green pill showing a critic score rounded to a whole number (C6). `score` is its only
parameter — no colour, fill, threshold, variant or size knob, and no score ramp, so a
caller cannot turn it into a general-purpose green badge or reintroduce featured's 80/60
ramp. Its green is one of the two exceptions §2 rule 1 sanctions (with the focus ring),
because the badge is data rather than an affordance; the catalogue row says so, and after
implementation `color.green` resolves in only two places in `lib/`.

**`GamesSliverGrid` (modify) — `lib/features/games/presentation/screens/games_screen.dart`.**
Renders `GameCard` at `md` per game, supplying the game, `RouteConstants.games`,
`state.games[index].criticScore`, and the existing tap callback with its unchanged
`(id, RouteConstants.games, cover.url)` push payload (R1, R3). Supplies no status, no
library tick and no add action. Its grid delegate is re-derived — see "Grid geometry"
below.

**`GameItemGridLoadingShimmer` (modify) — `lib/widgets/game_item_grid_loading_shimmer.dart`.**
Renders a dataless `GameCard` at `md` inside `Skeletonizer`, using the same column-width
and cell-height derivation as the live grid (R5).

**`GameItemLoadingShimmer` (modify) — `lib/widgets/game_item_loading_shimmer.dart`.**
Renders dataless `GameCard`s at `sm` in its horizontal list, and gives that list a
bounded height taken from `GameCardSize.sm.cellHeightFor(GameCardSize.sm.width)` so it
is renderable by any future caller (R6). Class name and file name are unchanged —
renaming them is not asked for by any criterion and would ripple into `games_screen`'s
import for no behavioural gain.

**`GameItem` (modify) — `lib/widgets/game_item.dart`.**
Gains a `@Deprecated` annotation naming `GameCard` at
`lib/widgets/game_card/game_card.dart` as its replacement. Nothing else in the file
changes; it keeps its existing body and its existing comments, which belong to a retired
widget and are not this run's to sweep (R7).

### Screens

No screen structure changes. `GamesScreen` itself is untouched apart from the widget
its grid builds.

## Design decisions the criteria left to the Tech Lead

### 1. The hero-tag contract (C14, C15, R4)

The tag string is unchanged: `'${ConfigConstants.heroTag}/${game.id}/$fromScreen'`,
byte-identical to `detail_top_header.dart:171`. Three things change around it.

- **`fromScreen` becomes nullable.** `GameItem` required it and the shimmers passed
  `''`, which is a real string and would have registered a real `Hero` had a game been
  present. `GameCard` takes `String? fromScreen` and registers a `Hero` only when
  `game != null && fromScreen != null`. That is the C14/C15 split stated in one
  condition: data present and a caller-declared origin means a shared element; anything
  else means none.
- **The `Hero` no longer depends on the cover url.** `GameItem` wrapped only the loaded
  image, so a game with no art registered nothing while the detail side registered
  unconditionally — the tags could not match. `GameCard` wraps the whole cover box,
  fallback included, so the id-derived tag exists whether or not there is art (C14).
- **A dataless card registers nothing at all**, which is what makes the shimmers legal:
  four cells with no game means four cards with no `Hero`, so there is no duplicate tag
  to collide (C15, R5).

Only one automated assertion protects this: the exact tag string for a known id and
`fromScreen`. Everything else about the transition is R4's manual device check.

### 2. Grid geometry (R2, R5)

`childAspectRatio: 0.6` is not re-derived to another ratio — a fixed ratio is the wrong
instrument here and is why the current grid would break. The card's height is
`columnWidth × 4/3` (the 3:4 cover) plus a **fixed** footer height, so the correct
ratio changes with device width and no single constant fits the 320–430dp range: it
lands near 0.46 at 320dp and 0.51 at 430dp, and picking either one either overflows or
leaves a large dead band.

The delegate therefore keeps `crossAxisCount: 2`, `mainAxisSpacing: 8`,
`crossAxisSpacing: 8` and the existing horizontal padding of 8, drops
`childAspectRatio`, and sets **`mainAxisExtent: GameCardSize.md.cellHeightFor(columnWidth)`**,
where `columnWidth` comes from the live cross-axis extent via `SliverLayoutBuilder`
(`LayoutBuilder` in the box-based grid shimmer). The column-width arithmetic lives once,
in `GamesGridConstants` in `lib/core/res/const.dart`, because both a feature screen and
a global widget need the identical number:
`columnWidth = (crossAxisExtent - gutter × (columnCount + 1)) / columnCount`,
gutter 8, columnCount 2. At 360dp that is 168; the cell is then 168 × 4/3 + 126 = 350.

Consequence of the derivation, stated for the gate: `md`'s "220 minimum" is not
enforceable inside a two-column phone grid — two columns at 360dp give each card 168.
C1 and the BA's own assumption both describe 220 as a minimum the card fills *up to*,
not a constraint it imposes, so `GameCard` sets no width at `md` and the 220 stays a
design reference. Enforcing it would need one column (contradicting R2) or `sm`
(contradicting R1).

Footer heights, fixed per size so the cell never depends on a game's content (C12):
`xs` 0; `sm` 56 (8 gap + 24 title line + 4 + 20 metadata row); `md` 126 (8 gap + 48
two title lines + 4 + 18 date + 4 + 44 platform-and-add row, 44 being §5's hit-target
floor for the add control). All even per `flutter-widgets`.

### 3. `PlatformRowList` composition (C11, C12)

Composed exactly as it ships. The card supplies three things and nothing else:

- **The null/empty guard.** `GameEntity.platforms` is `List<PlatformEntity>?` and the
  row's parameter is non-nullable, so the footer builds the row only when the list is
  non-null and non-empty; otherwise no row is built and no vertical space is reserved.
- **A height-bounded parent.** The row is a horizontal `ListView`, so it is wrapped in a
  `SizedBox(height: 16)` — the same bound `GameItem` and `SavedGameItem` already give
  it — and placed in an `Expanded` inside the footer row so its width is bounded too.
  `NeverScrollableScrollPhysics` plus a bounded viewport clips a long list rather than
  throwing, which is what C12 needs.
- **The per-size cap.** `showMax: 1` at `sm`; the row's own default of 4 (and therefore
  its own `+N` counter) at `md`.

Nothing is added to the row: no error builder, no loading builder, no restyle, no fork.
Its `Image.network` stays bare, which is why no test in this run may depend on a logo
image resolving.

### 4. Retiring `GameItem` (R7, R8)

Deprecated, not deleted, per the week-2 checklist's reuse-before-rebuild rule and R7.
Effect on the analyzer baseline (0 errors / 2 warnings / 31 info): **none**.
`deprecated_member_use` is reported at use sites only, and after steps R1/R5/R6 there
are none — the three files above are the complete reference set, confirmed by search
(`tracker_screen.dart` and `saved_game_item.dart` match only on the substring
`SavedGameItem`). A reference left behind would show up as a *new* info-level
diagnostic, which is the cheap signal that a caller was missed.

R8's catalogue is the "Existing reusable widgets catalogue" table in
`.claude/skills/flutter-widgets/SKILL.md` — the only catalogue of reusable widgets this
project keeps. The edit is six table rows: add `GameCard` at its module path, add
`LibraryTick`, add `CriticBadge`, mark `GameItem` deprecated, and update the two shimmer
rows to say they shimmer the new card. R8's wording asks for the shimmer entries to be
"marked as deprecated"; they are not deprecated, because R5 and R6 rewire them, so they
are re-described instead. The card's row also records that only `GameCard` and
`GameCardSize` are its public surface, so the next reader does not adopt a footer class
as a component. Rule text in that skill is not touched — only the catalogue rows.

### 5. Card surface and interior

The card draws no surface fill and no interior padding: cover at r16, footer text flush
to the cover's left edge, on whatever surface the caller places it. §3.2 describes the
card as cover-plus-footer and lists no fill, and a fill would fight §1.5's "separation
is a colour step" on the onyx canvas. It also makes the grid's leftover vertical space
read as ordinary whitespace rather than as a stretched empty box. `GameItem`'s Material
`Card` wrapper does not carry over. This is a visible change to the games grid and is
listed as a manual check.

### 6. Which overlays are the card's and which are the app's

`StatusChip` was already app-wide, and after the gate revision the other two are too.
`LibraryTick` and `CriticBadge` are component-library citizens on the same footing as the
Stage 1 primitives, so all three cover overlays now come from `lib/widgets/` and the card
composes rather than owns them. The footers went the other way: split into files for
readability, but kept module-internal because nothing outside the card can use a footer
shaped by `GameCardSize`. The dividing line is whether the widget's API means anything
without the card — a tick and a score badge do, a card footer does not.

## Reuse decisions

- **`StatusChip` (`lib/widgets/status_chip.dart`)** — reused directly for C5, in its
  `onMedia` variant. Given a bounded width by its `Positioned` so its existing
  `Flexible`/ellipsis handles a 64px cover at `xs` instead of clipping.
- **`PlatformRowList` (`lib/widgets/platform_row_list.dart`)** — reused as-is for C8,
  C9, C11. See decision 3.
- **`DefaultCachedNetworkImage` (`lib/widgets/default_cached_network_image.dart`)** —
  reused for the cover art, with `imageBuilder` / `placeholder` / `errorWidget`
  supplied in the same shape `CoverTile` uses, so the wash and the missing-art fallback
  are one treatment expressed in one way in both widgets.
- **Existing tokens** — `radius.lg` (16), `color.coverWash`, `color.canvas`,
  `color.hairline`, `color.ink12`, `color.accentIndigo`, `color.green`,
  `color.inkDark`, `typography.body` / `meta` / `pill`. No new token, no literal hex.
  Worth recording: **`AppColorTokens.dark.canvas` is `#23272A`, which *is* §1.1's
  `--color-surface-onyx`** — this project's canvas token and the spec's onyx surface are
  the same colour, so C3's "onyx fill" and `CoverTile`'s canvas-token fallback do not
  actually disagree, and the tech-ac assumption flagging them as different can be
  closed.
- **`CoverTile` (`lib/widgets/cover_tile.dart`) — considered, not composed.** Its four
  sizes are fixed width/height pairs baked into its enum, so it cannot produce a 3:4 box
  at 64/132 or a cover that fills an arbitrary column width at `md`; and it owns exactly
  one overlay slot, while the card needs three. Making it serve the card would mean
  turning a shipped Stage 1 primitive with a live caller (`auth_screen.dart`) into an
  aspect-driven widget with a tick and a badge — a larger and riskier change than the
  card itself, for a primitive whose remaining job is the auth screen's fan. The card's
  cover is therefore a private `_CardCover` that reuses the *same tokens and the same
  composition*, not a second styling. Flagged because the run prompt named the cover
  tile as something to compose: this is the one primitive that could not be. Note that
  after the gate revision `CoverTile` and `GameCard` do share the two overlay widgets,
  so the divergence is narrower than it was.
- **`PlaceholderSlot` (`lib/widgets/placeholder_slot.dart`) — considered, not used.**
  Its two presets are an 88px app mark with a `LOGO` marker and a 20px provider mark,
  both meaning "licensed art is still owed". Neither is the card's missing-art fallback
  (§3.2: onyx fill + hairline + gamepad glyph) nor a footer skeleton line. Using it
  would put the wrong semantics on screen.
- **`MetacriticIndicator` (`lib/widgets/metacritic_indicator.dart`) — considered,
  rejected.** It is a 40px circle with an off-palette red/yellow/green score ramp —
  the exact thing C6's failure case forbids, and the reason `CriticBadge` ships with no
  threshold parameter. Left untouched; it is not in scope to retire here.
- **`Skeletonizer`** — already the project's shimmer mechanism; both shimmers keep it
  and simply wrap the new card.

## Out of scope

- `lib/features/featured/presentation/widgets/critics_grid.dart` and
  `lib/widgets/saved_game_item.dart` — deferred by the human's CRITICAL-1 Option B
  decision; neither appears in the allowlist. In particular, `critics_grid.dart` is not
  rewired onto the new `CriticBadge` in this run even though it now could be.
- Any change to `PlatformRowList`, including an error or loading builder, and §1.9's
  text-abbreviation conversion (FOLLOW-UP-1).
- Any change to `CoverTile`, `StatusChip` or `PlaceholderSlot`.
- Deletion of `game_item.dart` or of either shimmer file.
- Hover, press-scale and focus treatments beyond the existing `InkWell` response.
- Golden tests and dimension assertions, in any form.

## Open questions

**NONE OPEN.** OQ-1 below was settled by the human at the Phase 3 gate on 2026-08-21 —
recorded here by the orchestrator, analysis left intact for the record.

**RESOLVED 2026-08-21 — wash only, no desaturation.** The human reaffirmed the item 1.3
decision in their own words ("i rejected the filter for a reason"). The card applies the
flat indigo wash and no `saturate`/`contrast` filter, matching `CoverTile` and keeping
manual check `1.3-AC7` valid. [2.1-C2] is amended as written from stale spec text; that
clause of it ships deliberately unmet, and this is not a defect for QA to raise.
`system-foundation-specs.md` §3.2 still describes the filter and was NOT corrected in
this run — recorded as a follow-up.

**OQ-1 (resolved above) — [2.1-C2]'s 50% desaturation contradicts a recorded human decision, and it is
not the Tech Lead's to overrule.** C2 requires the cover to carry "the 50%
desaturation and the flat indigo→canvas wash" at every size, and its failure case
forbids shipping with the treatment omitted. But week 2 item 1.3 ended in a Phase 3
reversal in which the human **rejected** the spec's `saturate(.5) contrast(1.05)`
filter for exactly this treatment on exactly this kind of surface: `CoverTile` keeps
the artwork's original colours and applies the indigo wash only
(`.agents/handover.md` lines 95–98), and `.agents/manual-check-backlog.md` item
**1.3-AC7** now stands as a live check that "the saturate/contrast treatment must be
**visibly absent**". The BA's criteria do not mention that decision, so C2 appears to
have been written from the spec text alone.

Either answer has a consequence beyond this run: honouring C2 puts a filter on the card
that the cover tile deliberately does not have, giving one concept two treatments
(against §0 principle 1) and contradicting a live manual check; dropping it means C2
ships knowingly unmet on that clause. Reinstating it properly would also mean changing
`CoverTile`, which is not in this run's allowlist.

Designed as: **wash only, no saturation filter**, consistent with the 1.3 decision —
but the plan is written so this is a one-line change either way, and the decision is
the human's. `escalation.md` is open on this. Confirmed still open and unchanged by the
Phase 3 revision — the human's three changes did not touch it.

(if non-empty: write escalation.md before halting) — done.

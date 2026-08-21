# Technical Acceptance Criteria
Source: `.agents/week-2-task-briefs.md` Stage 2 item 2.1 — Game card
(anatomy from `.agents/references/system-foundation-specs.md` §3.2 "Game card",
§3.3 primitives, §1 foundations, §2 colour law)
Date: 2026-08-21
BA Agent version: 1.0

## Feature summary

Replace the single-anatomy game card with one component that carries three sizes
(`xs` 64, `sm` 132, `md` 220+), a 3:4 cover at r16 with the spec's desaturation and
wash, three optional overlays (library tick, status chip, critic badge), and an
onyx missing-art fallback. Scope is the component plus its three direct references
(human decision on CRITICAL-1, Option B): the games grid, the grid shimmer, and the
callerless horizontal shimmer. The card renders only what a caller hands it — it
fetches and derives nothing. Two contracts that fail silently today are pulled into
this run because the swap can break them without any analyzer error or test failure:
the games → detail hero tag, and the games grid's cell geometry.

**Verification convention for every criterion below.** Widget tests never assert
dimensions, gaps, radii or positions; colour assertions must carry meaning and name a
token; golden tests are never used. Every criterion therefore carries a `Verify:` line
naming its real check. Where that line says `manual device check`, the number in the
criterion is the contract and QA confirms it on device — no test may enforce it.

## Technical acceptance criteria

### Card component — structure and sizes

[2.1-C1] Presentation — shared widget: The card exposes exactly three sizes and one
structure — `xs`, `sm`, `md`. `xs` is 64 wide, `sm` is 132 wide, `md` is a 220
minimum that fills the width its parent gives it. No fourth size and no
per-caller structural variant exists.
  Verify: widget test that each size renders its own content set (see C7–C9);
  manual device check for the three widths.
  Failure case: a caller needing a different anatomy is a spec change, not a new
  variant — the card is not extended and the request escalates.

[2.1-C2] Presentation — shared widget: At every size the cover is a 3:4 box at r16,
carrying the 50% desaturation and the flat indigo→canvas wash. No gradient scrim.
  Verify: manual device check.
  Failure case: an untreated cover out-shouts the UI and overlay text drops below
  AA — the card is not shipped with the treatment omitted at any size.

[2.1-C3] Presentation — shared widget: When no cover URL is supplied, or the image
fails to load, the cover box renders an onyx fill, a hairline, and a gamepad glyph.
It never renders a title initial and never renders the `error404` asset.
  Verify: widget test — with a null and with an empty cover URL, the gamepad glyph
  is found and no asset image is rendered.
  Failure case: any other fallback (blank hole, stretched asset, letter tile) fails
  this criterion outright.

### Card component — overlays

[2.1-C4] Presentation — shared widget: A library tick overlays the cover top-right
only when the caller states the game is in the library, at all three sizes, and is
absent otherwise. The card never derives library membership.
  Verify: widget test — present when the caller says in-library, absent when not.
  Failure case: an always-present tick reads as "everything is saved" and is a
  defect, not a placeholder.

[2.1-C5] Presentation — shared widget: A status chip overlays the cover bottom-left,
in its on-media form, only when the caller supplies a status, at all three sizes.
No status supplied means no chip and no reserved gap.
  Verify: widget test — chip present with the supplied status and the on-media
  variant; absent when no status is supplied.
  Failure case: a default status (e.g. Backlog) invented by the card is a data
  claim it cannot make.

[2.1-C6] Presentation — shared widget: A green critic badge overlays the cover
top-left whenever a critic score is supplied, showing the score rounded to a whole
number, at all three sizes. No score means no badge, and no threshold suppresses it.
  Verify: widget test — badge shows the rounded whole number for a fractional score;
  absent when the score is null. Green here is the §2 rule-1 sanctioned exception,
  so a single colour assertion naming the green token is permitted.
  Failure case: a score ramp (amber/red bands) is off-palette and fails this
  criterion — the badge is one colour.

### Card component — footer

[2.1-C7] Presentation — shared widget: `xs` renders no footer — cover and overlays
only, no title, no metadata, no number, no add affordance.
  Verify: widget test — supplied title text is not found at `xs`.
  Failure case: a footer at `xs` breaks the 64 grid it exists for.

[2.1-C8] Presentation — shared widget: `sm` renders title, one platform, and one
number — the critic score when one is supplied, no number otherwise. No release date,
no add affordance. The single platform is shown through the shared platform row of
C11, capped at one — not as a text abbreviation.
  Verify: widget test — title found; the shared platform row present and capped at
  one when the caller supplies platforms; number present with a score and absent
  without one. No assertion on abbreviation text and none on image loading.
  Failure case: a `sm` card showing a date or an add control is the `md` anatomy in
  the wrong slot.

[2.1-C9] Presentation — shared widget: `md` renders title, release date, platforms,
and an inline add affordance when — and only when — the caller supplies an add
action. Platforms are shown through the shared platform row of C11.
  Verify: widget test — date found; the shared platform row present when the caller
  supplies platforms; add affordance present with a supplied action, absent without
  one. No assertion on abbreviation text and none on image loading.
  Failure case: an always-present add control is dead until week 3's Add-to-library
  sheet and must not ship.

[2.1-C10] Presentation — shared widget: Triggering the inline add invokes the
supplied add action once and does not invoke the card's own tap action.
  Verify: widget test — tap the add affordance, assert add fired and card tap
  did not.
  Failure case: the add press falling through to navigation sends the user to the
  detail screen instead of adding.

[2.1-C11] Presentation — shared widget: Platform marks are the existing shared
platform row (`lib/widgets/platform_row_list.dart`) composed as-is — its logo imagery
and its `+N` overflow counter — not text abbreviations. The card supplies the platform
list and the per-size cap (one at `sm`, the row's own cap at `md`) and gives the row a
bounded box; it does not fork, restyle, or reimplement the row, and it does not add an
error or loading builder to the row's images. When the caller supplies no platforms or
an empty list, the card renders no platform row at all and still builds — the dataless
form in C15 carries no row and no reserved gap.
  Verify: widget test — the shared platform row is found in the footer when platforms
  are supplied, and is absent for a null and for an empty list, with the card building
  in both cases. No assertion depends on a logo image resolving: the row uses a bare
  `Image.network` with no error or loading builder, so tests assert the row's presence
  and its inputs, never a loaded image.
  Failure case: a copy of the row inside the card, or a per-card restyle of it, leaves
  two platform treatments to migrate in week 3 instead of one.
  Known deviation — deliberate: §1.9 calls for text abbreviations (`PS5`, `XSX`, `PC`,
  `NSW`) and forbids drawn or approximated third-party marks, so this criterion ships
  knowingly off-spec on that one detail, by human decision of 2026-08-21 (recorded in
  `ambiguities.md`). It is not a missed requirement and is not to be "fixed" inside
  this run; §1.9 conformance for platform marks is a follow-up covering this card and
  `lib/widgets/saved_game_item.dart` together.

[2.1-C12] Presentation — shared widget: Title and metadata truncate with an ellipsis
inside the space their size allows, and the platform row stays inside its bounded box —
it neither scrolls nor overflows. The card's height for a given size never grows with
longer content.
  Verify: widget test — a very long title and a platform list longer than the size's
  cap render without a layout overflow exception at each size that has a footer.
  Failure case: an overflow stripe on a long title or a long platform list means the
  footer is unbounded.

### Card component — interaction and the hero contract

[2.1-C13] Presentation — shared widget: With a tap action supplied, tapping anywhere
on the card invokes it exactly once. With none supplied, the card is inert — no
callback, no ripple.
  Verify: widget test — one tap, one invocation; and no callback path when none is
  supplied.
  Failure case: an inert card that still shows a press response reads as broken.

[2.1-C14] Presentation — shared widget: When a game and a `fromScreen` are supplied,
the cover is wrapped in a `Hero` whose tag is
`'${ConfigConstants.heroTag}/${game.id}/$fromScreen'` — byte-identical to the tag
`lib/features/game_detail/presentation/screens/detail_top_header.dart:171` builds
from the same id and `fromScreen`. The tag is built from the game id even when the
cover art is missing, so the fallback still carries the transition.
  Verify: widget test asserting the exact tag string for a known id and
  `fromScreen`. This is the documented contract the transition depends on, and is
  the only assertion protecting it.
  Failure case: a dropped `fromScreen` segment, a dropped `Hero`, or a renamed
  constant silently degrades games → detail to a cross-fade — no analyzer error, no
  other test fails. Treat any change to this string as a breaking change.

[2.1-C15] Presentation — shared widget: The card is constructible with no game and no
callbacks, renders its cover box and footer placeholders for its size, and registers
no `Hero` in that state.
  Verify: widget test — a dataless card renders without throwing, and several
  dataless cards render together in one subtree without a duplicate-tag exception.
  Failure case: a dataless card that registers a `Hero` crashes any shimmer that
  renders more than one of them.

### Rewiring — games grid (`lib/features/games/presentation/screens/games_screen.dart`)

[2.1-R1] Presentation — games screen: `GamesSliverGrid` renders the new card at `md`
for each game, passing the game, `RouteConstants.games` as `fromScreen`, and the tap
action. It supplies no library tick and no status — neither has a source before
week 3 — and supplies the critic score when the entity carries one.
  Verify: widget test on the grid — a card per game in state; no status chip and no
  library tick rendered.
  Failure case: a hardcoded tick or status on this screen is fabricated data.

[2.1-R2] Presentation — games screen: The grid keeps two columns, each cell renders
the card at the full column width, and no cell overflows or clips its footer at the
device widths the app supports. The cell geometry is re-derived for the new card's
3:4 cover plus footer rather than left at the current `childAspectRatio`.
  Verify: widget test pumping the grid at a narrow and a wide surface, asserting no
  layout overflow exception and that title text is still found; plus a manual device
  check of the grid's appearance. No test asserts the aspect ratio or any cell
  dimension.
  Failure case: an overflow stripe, a clipped footer, or a stretched cover means the
  delegate was carried over unchanged — the grid geometry is part of this run.

[2.1-R3] Presentation — games screen: Tapping a grid card still pushes
`GameDetailRoute` with the same `(game id, RouteConstants.games, cover url)` payload
as before the swap.
  Verify: widget test — tapping a card triggers navigation with the unchanged
  payload.
  Failure case: a changed payload breaks the detail screen's hero side and its
  initial image.

[2.1-R4] Presentation — games screen → game detail: The shared-element transition
from a games grid card to the detail header still matches and animates, in both
directions, for a game with cover art and for one without.
  Verify: manual device check — this is the run's single highest-value manual check.
  There is no widget test on this screen pairing; C14 is the only automated part of
  the contract.
  Failure case: a cross-fade instead of a shared element, or a flash of the
  fallback, means the tags stopped matching — the swap is not done.

### Rewiring — shimmers

[2.1-R5] Presentation — `lib/widgets/game_item_grid_loading_shimmer.dart`: The grid
shimmer renders the new card in its dataless form, at the same size and cell geometry
as the loaded games grid, so the skeleton stays shaped like its content per §3.2. It
renders multiple cells without a duplicate-hero exception and without a layout
overflow.
  Verify: widget test — the shimmer renders its cells without throwing; manual
  device check that the skeleton matches the loaded grid's shape.
  Failure case: a skeleton whose cells differ in shape from the loaded grid produces
  a visible jump on load, which is the defect §3.2 names.

[2.1-R6] Presentation — `lib/widgets/game_item_loading_shimmer.dart`: This horizontal
shimmer is **rewired**, to the new card at `sm`, and stays callerless. It is not
deleted and not left pointing at the old card.
  Decision and reasoning — the human asked for this one to be stated. Rewire is
  chosen over the two alternatives: *delete* conflicts with the week-2 checklist's
  standing "reuse-before-rebuild with `@Deprecated` rather than deletion" rule, and
  retiring dead widgets belongs to whoever finally removes the old card, as one
  decision instead of two; *leave as-is* would keep the only remaining reference to
  the deprecated old card alive, which both re-emits deprecation diagnostics against
  the recorded analyzer baseline and strands a second card anatomy in `lib/widgets/`
  — exactly what this week exists to stop. The rewire itself is a few lines.
  Verify: widget test — it renders its cells without throwing. No manual device
  check is possible or required; nothing renders it.
  Failure case: if the rewire turns out to need more than a size swap, that is a
  signal the dataless contract in C15 is wrong — fix the card, not this file.

### Rewiring — retirement of the old card

[2.1-R7] Presentation — `lib/widgets/game_item.dart`: After R1, R5 and R6 there are no
remaining references to the old card anywhere in `lib/`. The old widget stays in the
tree marked deprecated rather than deleted, and its zero remaining call sites mean the
analyzer count does not move against the Phase 0 baseline.
  Verify: a repository search returns no references outside its own file; analyzer
  output compared to the recorded baseline.
  Failure case: a surviving reference means a caller was missed and two card
  anatomies ship together.

[2.1-R8] Documentation: The project's reusable-widget catalogue lists the new card and
marks the old card and its shimmer entries as deprecated, so the next run does not
adopt the retired anatomy. Which file carries that catalogue and whether it is in this
run's allowlist is the Tech Lead's call.
  Verify: catalogue entry present and accurate.
  Failure case: a stale catalogue is read as current intent and the old card gets a
  new caller.

## Out of scope

- `lib/features/featured/presentation/widgets/critics_grid.dart` — the inline
  duplicate of the card anatomy, with its own off-palette score ramp. Deferred by
  human decision on CRITICAL-1; it must be left unchanged by this run.
- `lib/widgets/saved_game_item.dart` and the tracker screen — the slidable row is not
  this anatomy and week 3 migrates tracker to library regardless. Left unchanged.
- §1.9 conformance for platform marks — converting the shared platform row from logo
  imagery plus `+N` to text abbreviations. Deferred by human decision on 2026-08-21
  (see C11 and `ambiguities.md`) and owed as its own follow-up covering both callers of
  the row, this card and `lib/widgets/saved_game_item.dart`, in one change.
- Any change to the shared platform row itself, including adding an error or loading
  builder to its `Image.network`. This run composes it unchanged.
- Add-to-library sheet, library membership and status data sources — week 3. This run
  only accepts them as caller-supplied inputs.
- Deletion of the old card widget and its shimmer files. Deprecation only (R7).
- Hover, press and focus treatments beyond the card's existing tap response. §1.8
  documents them as replaceable additions; nothing in item 2.1 requires them.
- Pixel conformance as a test target. The three widths, the 3:4 ratio, r16, overlay
  positions, and the desaturation and wash are manual device checks. No golden test,
  no dimension assertion, in any circumstance.
- Analyzer and test baselines are governed by
  `.claude/pipeline/rules/execution.md`, not restated as criteria here.

## Assumptions

ASSUMPTION: Card renders only what it is given. `GameEntity` carries `criticScore` but
no library-membership or status field, and no source of either exists outside
featured's local id set until week 3's Library feature. Library tick, status and
critic score are therefore caller-supplied inputs; the card never fetches or derives
them.

ASSUMPTION: Critic badge shows whenever a critic score is supplied, rounded to a whole
number, always green. §3.2 sets no threshold and §2 colour law rule 1 names the badge
a sanctioned green exception; featured's current 80/60 amber/red ramp is a local
invention and is not carried over.

ASSUMPTION: `sm`'s "one number" is the critic score when one is supplied, and the
footer carries no number otherwise. Principle 5 says personal data outranks global,
but no personal figure (completion, playtime) exists in the data model this week —
when Library lands, a personal number supersedes this slot.

ASSUMPTION: `md`'s inline add renders only when the caller supplies an add action. The
Add-to-library sheet is explicitly deferred to week 3, so an always-present add
affordance would be a dead control.

ASSUMPTION: Missing-art fallback uses the onyx surface token per §3.2, with the
hairline and a gamepad glyph, and never a title initial. Noted because the cover tile
primitive's own fallback uses the canvas token — §3.2's game-card wording wins for
this component.

ASSUMPTION: `md` 220px is a minimum, not a fixed width — the card fills the width it
is given at that size. `xs` and `sm` are fixed at 64 and 132.

ASSUMPTION: All three overlays are available at all three sizes; only the footer is
size-dependent (absent at `xs`). §3.2 does not qualify the overlays by size.

ASSUMPTION: Pixel conformance — the three widths, the 3:4 ratio, r16, overlay
positions and the 50% desaturation + wash treatment — is verified by manual device
check, not by test. Per `.claude/pipeline/rules/execution.md` and the 2026-08-20
convention change, widget tests never assert dimensions, gaps, radii or positions, and
golden tests are never used in this project.

RESOLVED BY HUMAN DECISION 2026-08-21 (was an assumption): `sm`'s "one platform" is
the first platform the entity carries, shown as a logo through the shared platform row
capped at one; `md` shows the row's normal set with its `+N` counter. §3.2 says
"platform" at `sm` and "platforms" at `md` without saying which one `sm` picks, so the
first-item rule stands — what changed is that it is a logo, not an abbreviation.

RESOLVED BY HUMAN DECISION 2026-08-21 (reverses the second-pass assumption): Platform
marks stay as today's logo images with the `+N` counter, composed from the shared
platform row. The earlier assumption — middot-separated text abbreviations per §1.9 —
is not applied in this run. The card is therefore knowingly off-spec against §1.9 on
this one detail, deliberately, and this is not a missed requirement. Reasoning, in
full, is recorded in `ambiguities.md`; §1.9 conformance for platform marks is a
follow-up covering both callers of the row at once.

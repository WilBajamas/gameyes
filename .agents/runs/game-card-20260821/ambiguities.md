# Ambiguities Report
Source: `.agents/week-2-task-briefs.md` Stage 2 item 2.1 — Game card (anatomy from
`.agents/references/system-foundation-specs.md` §3.2 "Game card", §3.3 primitives)
Date: 2026-08-21

## CRITICAL (pipeline blocked — requires human decision before proceeding)

NONE OPEN. CRITICAL-1 was resolved by the human on 2026-08-21; the record and the
decision are kept below rather than deleted. `tech-ac.md` is written.

CRITICAL-1 [RESOLVED 2026-08-21 — Option B]: 2.1 — Rewiring scope is undefined: does
this run also move existing surfaces onto the new card, or ship it unwired for a
later swap? The checklist (item 2.1 and its "Open decisions that could block"
section) deliberately defers this, and the answer changes which criteria are written,
what regresses, and what QA checks on device. Blast radius below.

**RESOLUTION (human, 2026-08-21) — Option B.** In scope: the new card plus its three
direct references — `games_screen.dart:133` (`GamesSliverGrid`, including the grid
delegate geometry at 126–131 and the hero-tag contract),
`lib/widgets/game_item_grid_loading_shimmer.dart`, and
`lib/widgets/game_item_loading_shimmer.dart`. Explicitly deferred, no criteria
written: `lib/features/featured/presentation/widgets/critics_grid.dart` (4) and
`lib/widgets/saved_game_item.dart` (5). The human additionally directed that the two
silent-failure risks be protected by explicit criteria — the hero-tag contract
(`tech-ac.md` [2.1-C14], [2.1-R4]) and the games grid's post-swap geometry
([2.1-R2]). The callerless shimmer (3) is **rewired**, with the reasoning recorded in
[2.1-R6]; delete was rejected against the checklist's deprecate-don't-delete rule,
leave-as-is was rejected because it would strand the last reference to the retired
anatomy.

**Direct `GameItem` references — three, all of them:**

1. `lib/features/games/presentation/screens/games_screen.dart:133` (`GamesSliverGrid`)
   — the only user-visible caller. Rewiring cost is not just a widget swap:
   - the grid delegate at lines 126–131 is `crossAxisCount: 2, childAspectRatio: 0.6`
     and stretches children to the column width; the new card's sizes are fixed
     widths (64 / 132 / 220+) with a 3:4 cover plus footer, so the delegate's
     geometry has to be re-derived or the card has to stretch — i.e. this run
     inherits a layout decision about the games grid, not only a component.
   - hero contract: `GameItem` builds `'${ConfigConstants.heroTag}/${game?.id}/$fromScreen'`
     and `lib/features/game_detail/presentation/screens/detail_top_header.dart:171`
     builds the matching tag. If the new card drops `fromScreen` or the `Hero`, the
     games → detail shared-element transition stops matching **silently** — no
     analyzer error, no test failure.
   - no widget test covers this screen, so the only safety net is a manual device check.

2. `lib/widgets/game_item_grid_loading_shimmer.dart:20` — renders `const GameItem(fromScreen: '')`
   with a null game inside `Skeletonizer`; consumed by `games_screen.dart:102`. If (1)
   is rewired this must follow, because §3.2 Async states requires the skeleton to stay
   shaped like its content. Requires the new card to be constructible with no game data.
   Small, but mandatory-if-(1).

3. `lib/widgets/game_item_loading_shimmer.dart:16` — same dataless construction, horizontal
   list. **No caller anywhere in `lib/`** — dead code. Cost near zero, but it is still a
   decision: rewire, leave as-is, or delete.

**Named in the brief as callers but are NOT — they never reference `GameItem`:**

4. `lib/features/featured/presentation/widgets/critics_grid.dart:167–288` — an inline
   duplicate of the card anatomy (2-column grid at aspect `0.72`, its own owned-tick using
   `Colors.green` + `Icons.check`, its own critic-score colour ramp with `#4CAF7D` / `#E6A430`
   / `#E05555`, all three outside the closed palette). Adopting the new card removes roughly
   100 lines and three off-palette literals, and it is the closest existing match to the `md`
   size (it already shows a library tick and a critic score). But it changes a shipped screen's
   appearance and sits inside `CriticsGridWidget`, which also owns the genre picker and carries
   a `// TODO: Refactor this` — the widget needs restructuring, not a line swap. Strongest
   candidate if any adoption beyond the direct callers is wanted.

5. `lib/widgets/saved_game_item.dart` (via `lib/features/tracker/presentation/screens/tracker_screen.dart:169`)
   — a 2:1 horizontal row with slide-to-remove/detail actions, task counts and a date-added
   column, built on `TrackerSavedGameEntity`, not `GameEntity`. This is not the game-card
   anatomy at any of the three sizes; it is closer to item 2.6 (Rows) plus a cover tile, and
   week 3 migrates tracker → library regardless. Recommend excluding it from every option.

  Options:
    A — Component only. Build the new card, touch no caller; `GameItem` stays as-is
        (deprecated rather than deleted, per the checklist's reuse-before-rebuild rule).
        Nothing in the app changes visually; two card anatomies coexist until a later run.
        Zero regression risk, zero manual device checks, and the spec conformance this
        item exists for is not visible to anyone yet.
    B — Component + its three direct references (1, 2, 3). Games grid renders the new card.
        Pulls the grid geometry and the hero-tag contract into this run; needs a manual
        device check of the games grid and the games → detail transition.
    C — B + featured's inline duplicate (4). Also removes the off-palette score ramp, but
        restructures `CriticsGridWidget` and changes a second shipped screen — a materially
        bigger run than the other Stage 2 items.
  Recommended: B, with (4) and (5) explicitly deferred — it matches the precedent set by
    items 1.8, 1.9 and 2.3 (rewire the first caller in the same run) and stops a second card
    anatomy outliving this week. Caveat the human should weigh: B is the option that drags two
    non-component concerns (grid delegate geometry, hero-tag contract) into a component run. If
    this run must stay purely a component build, A is the clean line and the rewire becomes its
    own follow-up run with its own manual checks.
  Decision needed from: Product Owner (with Tech Lead input on B's grid geometry)
  Decision taken: Option B — see RESOLUTION above.

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: Card renders only what it is given. `GameEntity` carries `criticScore` but no
library-membership or status field, and no source of either exists outside featured's local
id set until week 3's Library feature. Library tick, status and critic score are therefore
caller-supplied inputs; the card never fetches or derives them.

ASSUMPTION: Critic badge shows whenever a critic score is supplied, rounded to a whole number,
always green. §3.2 sets no threshold and §2 colour law rule 1 names the badge a sanctioned
green exception; featured's current 80/60 amber/red ramp is a local invention and is not
carried over.

ASSUMPTION: `sm`'s "one number" is the critic score when one is supplied, and the footer
carries no number otherwise. Principle 5 says personal data outranks global, but no personal
figure (completion, playtime) exists in the data model this week — when Library lands, a
personal number supersedes this slot.

ASSUMPTION: `md`'s inline add renders only when the caller supplies an add action. The
Add-to-library sheet is explicitly deferred to week 3, so an always-present add affordance
would be a dead control.

ASSUMPTION: Missing-art fallback uses the onyx surface token per §3.2, with the hairline and a
gamepad glyph, and never a title initial. Noted because the cover tile primitive's own fallback
uses the canvas token — §3.2's game-card wording wins for this component.

ASSUMPTION: `md` 220px is a minimum, not a fixed width — the card fills the width it is given
at that size. `xs` and `sm` are fixed at 64 and 132.

ASSUMPTION: All three overlays are available at all three sizes; only the footer is
size-dependent (absent at `xs`). §3.2 does not qualify the overlays by size.

ASSUMPTION: Pixel conformance — the three widths, the 3:4 ratio, r16, overlay positions and the
50% desaturation + wash treatment — is verified by manual device check, not by test. Per
`.claude/pipeline/rules/execution.md` and the 2026-08-20 convention change, widget tests never
assert dimensions, gaps, radii or positions, and golden tests are never used in this project.

ASSUMPTION (added 2026-08-21, second pass) [RESOLVED 2026-08-21, third pass — human
decision]: `sm`'s "one platform" is the first platform abbreviation the entity carries; `md`
shows all of them, truncated to the width. §3.2 says "platform" at `sm` and "platforms" at
`md` without saying which one `sm` picks.
  **Resolution.** The first-platform rule stands; the *form* does not. `sm` shows the first
  platform and `md` shows the row's normal set, both as logo images through the existing
  shared platform row (`lib/widgets/platform_row_list.dart`) — `sm` capped at one, `md` with
  the row's `+N` counter for the remainder. Recorded in `tech-ac.md` [2.1-C8], [2.1-C9],
  [2.1-C11].

ASSUMPTION (added 2026-08-21, second pass) [RESOLVED 2026-08-21, third pass — human decision,
REVERSED]: Platform metadata is middot-separated text that ellipsizes, per §4's metadata rule.
The current `+N more` counter and the platform logo imagery are not carried over — §1.9 makes
platform marks text abbreviations (`PS5`, `XSX`, `PC`, `NSW`) and forbids drawn or approximated
third-party marks.
  **Resolution — reversed. Keep today's logo images and the `+N` counter.** The card composes
  the existing shared platform row unchanged; no text-abbreviation conversion happens in this
  run.
  Reasoning, as given by the human:
  - The approved scope (CRITICAL-1, Option B) is a **card swap**. Dropping the shared row's
    `Image.network` logos and its `+N` counter is a visible change to the shipped games grid
    beyond that swap, so it is outside what was approved.
  - The shared row stays alive for `lib/widgets/saved_game_item.dart` regardless of this run.
    Converting only the card would leave **two platform treatments coexisting** — logos in
    tracker, text in the grid — until week 3's tracker → library migration, which is the exact
    duplication this week exists to remove.
  - §1.9 conformance for platform marks therefore becomes its own follow-up, converting both
    callers of the row in one change.
  **Consequence to record explicitly:** the card ships **knowingly off-spec against §1.9** on
  this one detail — platform marks are third-party logo imagery, not text abbreviations. This
  is deliberate and by human decision of 2026-08-21. A future session must not read it as a
  missed requirement, an oversight, or a defect to fix opportunistically inside this run.
  Every other §1.9 obligation is unaffected.

## FOLLOW-UPS (not this run)

FOLLOW-UP-1 [raised 2026-08-21, third pass]: §1.9 conformance for platform marks. Convert the
shared platform row (`lib/widgets/platform_row_list.dart`) from third-party logo imagery plus a
`+N` counter to §1.9 text abbreviations (`PS5`, `XSX`, `PC`, `NSW`), middot-separated and
ellipsizing per §4's metadata rule, across **both** callers in one change — the new game card
and `lib/widgets/saved_game_item.dart`. Carries a free rider: the row's bare `Image.network`
has no error or loading builder today, and the conversion removes that failure mode with it.
Sequence it against week 3's tracker → library migration, which may reduce the caller count to
one. Owner: Product Owner to schedule; sized as its own run, not a rider on 2.1.

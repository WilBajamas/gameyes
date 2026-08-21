# Technical Acceptance Criteria
Source: `.agents/week-2-task-briefs.md` Stage 2 item 2.3 — Countdown + Countdown tile
Supporting specs: `system-foundation-specs.md` §1.1 / §1.2 / §1.4 / §1.9 / §2 / §3.2 / §3.3 / §4 / §5;
`home-screen-design-conventions.md` §4.1 (precedence for the Featured/Home screen, per
`system-foundation-specs.md` lines 6–8); `onboarding-welcome-design-spec.md` §3c (tile form)
Date: 2026-08-21
BA Agent version: 1.0

## Feature summary

Build one countdown anatomy in two surface forms and rewire the only caller. The **card form**
(§3.2) is a raised card carrying a reason line, a title, three digit groups on 8% ink with colon
separators, and an optional Remind action; it replaces the inline countdown inside
`lib/features/featured/presentation/widgets/countdown_releases.dart`. The **tile form** (§3.3,
`onboarding-welcome-design-spec.md` §3c) is the same digit row on glass, for hero surfaces; it
ships with no caller. Both forms render a **snapshot** of a remaining duration supplied by the
caller — no unit smaller than a minute is shown, and the widget owns no timer. The existing
`CountdownReleasesCubit` already computes `durationRemaining` / `isReleaseDay` on a 60-second
`Timer.periodic` and cancels it in `close()`; it stays the sole owner of ticking, and its tick and
its `close()` cancellation are untouched. One data-path change is in scope: a genuine wishlist
boolean carried from the repository through the use case and state to the card, so the reason line
stops asserting a wishlist entry that may not exist (C20–C22). The rework also removes five §4
content-rule violations and the raw Material colours in the current card.

Forms are labelled per criterion: **[both]**, **[card]**, **[tile]**, **[rewire]**.

## Technical acceptance criteria

C1 [§3.2 · home §4.1 · welcome §3c] PRESENTATION [both]: from a supplied non-negative remaining
duration the countdown renders exactly three unit groups in the order days, hours, minutes,
labelled `DAYS`, `HRS`, `MIN` in caps. Values are whole days, whole hours modulo 24, whole minutes
modulo 60, each zero-padded to a minimum of two digits; a days value above 99 renders all its
digits and is never clamped or truncated. No seconds group is ever rendered, in either form.
  Failure case: a fourth group, a seconds group, a different unit order, an unpadded single digit,
  or a clamped day count is a fail.

C2 [§3.2 · §3.3] PRESENTATION [both]: exactly two colon glyphs are rendered as `:` text, one
between each adjacent pair of unit groups. Colons render only when the digit groups render.
  Failure case: a colon drawn as an icon or image, a colon count other than two, or a colon
  surviving into the released or unknown-date state is a fail.

C3 [item 2.3 · home §4.1] PRESENTATION [both]: the countdown renders a snapshot of the duration it
is given. It starts no `Timer`, `Ticker` or animation of its own; advancing time in a test without
rebuilding the widget leaves every rendered digit unchanged; after the widget is disposed no timer
is left pending.
  Failure case: the widget-test framework reporting a pending timer after disposal, or digits
  changing without a rebuild, is a fail.

C4 [§3.2 · §2 law 1] PRESENTATION [both]: when the remaining duration is exactly zero or negative,
the countdown renders its released state — no digit groups, no colons, no unit labels — and a
single caps label announcing the release has landed. That state uses ink and indigo tokens only;
it contains no green and no magenta.
  Failure case: rendering `00 : 00 : 00`, a negative digit, or a green/magenta released state is a
  fail.

C5 [item 2.3] PRESENTATION [both]: when no remaining duration is supplied, the countdown renders no
digit groups, no colons and no unit labels. It renders the caller-supplied release-date text if one
was given, and a single caps unknown-date label otherwise. It never throws and never substitutes
zeroes.
  Failure case: a null-dereference, an empty box with no fallback text, or `00` placeholders is a
  fail.

C6 [item 2.3 · §0 principle 1] PRESENTATION [both]: given the same inputs, the card form and the
tile form render identical digit strings, identical unit labels, identical colon count, and the
same released and unknown-date behaviour. The two forms differ only in surface treatment and type
scale, never in what the numbers say.
  Failure case: any difference in rendered text between the two forms for one set of inputs is a
  fail.

C7 [§5] PRESENTATION [both]: the digit row exposes one semantics label stating the remaining time in
words, so a screen reader announces a single readable string rather than three loose numbers. The
released and unknown-date states expose their own label.
  Failure case: no semantics label on the digit row, or three separately announced figures, is a
  fail.

C8 [§3.2 · home §4.1 · §1.1 · §1.5] PRESENTATION [card]: the card sits on the raised surface token
(`AppColorTokens.surfaceRaised`, `#2F333C`) at radius `lg`, with a flat fill — no gradient of any
kind, and no elevation shadow.
  Failure case: a `LinearGradient` fill (as at `countdown_releases.dart:91–100`), a `Card`
  elevation (as at line 79), or the indigo panel token used as the card fill is a fail.

C9 [§3.2 · home §4.1] PRESENTATION [card]: each digit group sits on `ink08` at radius `xs`; colon
glyphs use `ink12`; each unit label is caps at `ink55` directly beneath its own block.
  Failure case: a digit block on `surfaceContainerHighest` or any non-token fill (as at
  `countdown_releases.dart:299`), a colon at any other ink step, or an outlined digit block is a
  fail.

C10 [§3.2 · §2 law 3 · home §4.1] PRESENTATION [card]: when the caller marks the countdown game as
wishlisted, the card renders one reason line in link cyan (`accentLinkCyan`) with a 2px-stroke
outline bookmark glyph. When it does not, the card renders one neutral `ink55` reason line and no
cyan anywhere.
  Failure case: cyan in the non-wishlist branch, a filled glyph, more than one reason line, or a
  coloured badge chip in place of the line (as at `countdown_releases.dart:129–164`) is a fail.

C11 [§3.2 · home §4.1 · §2 law 1 · §5] PRESENTATION [card]: the Remind action renders only when the
caller supplies a handler, and invoking it calls that handler exactly once. It is neutral — `ink12`
fill at radius `xs`, label paired with a 2px-stroke outline bell glyph — and never green. Its hit
target is at least 44px.
  Failure case: a Remind control rendered with no handler (a dead affordance), a green Remind, or a
  hit target under 44px is a fail.

C12 [item 2.3] PRESENTATION [card]: tapping the card invokes the caller's open-game handler exactly
once per tap. Tapping the Remind action does not also invoke the open-game handler.
  Failure case: a tap that fires neither handler, or a Remind tap that also opens the game, is a
  fail.

C13 [§3.3 · welcome §3c · §1.6] PRESENTATION [tile]: each unit in the tile form sits on the glass
32% token (`glass32`) with the glass blur applied, at radius `xs`, with its caps micro label
beneath; colon glyphs use the 40% countdown-colon token.
  Failure case: a translucent-white fill instead of the glass token, a missing blur, or colons at
  `ink12` in the tile form is a fail.

C14 [§3.3] PRESENTATION [tile]: the tile form renders the digit row only — no card surface, no
title, no reason line and no Remind action.
  Failure case: any card chrome or card-only element appearing in the tile form is a fail.

C15 [§4 · §1.9] PRESENTATION [both, rewire]: no string rendered by either form or by the rewired
featured countdown section contains an emoji, a unicode dingbat, or an exclamation mark. This
retires all five current violations in `lib/features/featured/presentation/widgets/countdown_releases.dart`:
line 139 `'🔥 Global Hype'`, line 157 `'⭐ Wishlisted'`, line 256 `'Out today! 🥳'` (emoji and
exclamation mark), line 221 `'Add upcoming games to your wishlist to countdown here!'`, and line
265 `'The wait is over. Enjoy playing it now!'`. Replacement copy is second person, uses no
exclamation mark, and keeps headline-shaped labels in caps with no terminal period.
  Failure case: any emoji, dingbat or `!` in rendered copy is a fail. A middot `·` used as a
  separator is allowed — it is punctuation, not an icon.

C16 [§1.1 · §2 laws 1, 4, 7] PRESENTATION [both, rewire]: every colour used by either form comes
from `AppColorTokens` / `AppTypeTokens`. No raw Material palette colour and no inline hex appear in
the countdown code.
  Failure case: `Colors.amber` (`countdown_releases.dart:153, 161`), `Colors.green` (lines 248,
  250, 260) or any other literal colour surviving in the countdown card is a fail.

C17 [item 2.3] PRESENTATION [rewire]: `featured`'s countdown section renders the new card component
in the same run. The inline countdown anatomy it replaces is deleted, not deprecated in place —
`_buildCountdownCard`, `_buildCelebrationState`, `_buildTimerBlocks` and `_buildTimeBox` (with the
`// TODO: Refactor this` at line 7) no longer exist, and no parallel countdown implementation
remains in the repository.
  Failure case: the old private builders still present, or two countdown implementations coexisting,
  is a fail.

C18 [item 2.3] PRESENTATION [rewire]: everything around the countdown card behaves as it did before
the rewire — the out-this-week rail and its heading, the loading path that renders the section
inside `Skeletonizer` with placeholder data, the failure path, and the path where no countdown game
and no releases exist and the section collapses.
  Failure case: a changed rail, a crash or a blank section under the skeleton loading path, or the
  empty path no longer collapsing is a fail.

C19 [item 2.3] DOMAIN / PRESENTATION-STATE [rewire]: the countdown data path changes in exactly one
respect — it carries the wishlist flag of C20/C21. `FeaturedRepository.getCountdownGame` and
`GetCountdownGameUseCase` return the selected game together with that flag, and
`CountdownReleasesState` gains one boolean field for it. Nothing else is reshaped:
`GetOutThisWeekUseCase` is untouched; the cubit's release-date resolution, coming-soon-label logic,
failure branches and its `durationRemaining` / `isReleaseDay` computation are unchanged; the cubit
remains the sole owner of the 60-second `Timer.periodic` and still cancels it in `close()`; no
second timer is introduced anywhere; and no new local or remote read is added to serve the flag.
  Failure case: a change to `GetOutThisWeekUseCase`, an altered tick interval, a missing `close()`
  cancellation, a second or widget-owned timer, an extra datasource call, or any state / use-case
  change beyond the single wishlist flag is a fail.

C20 [item 2.3 · §3.2 · §2 law 3] DATA / DOMAIN [rewire]: countdown-game selection resolves a
wishlist flag alongside the selected game, computed where the wishlisted ids are already known
(`featured_repository_impl.dart:66`, `_localDatasource.getWishlistedGames()`). The flag is true only
when the selected game's id is in that wishlisted set; it is false when selection fell through to
the globally most-anticipated fallback, and false when no game is selected. `GetCountdownGameUseCase`
passes the flag through unchanged and derives nothing of its own. The failure branch keeps its
current shape.
  Failure case: a flag derived from saved/owned ids rather than wishlisted ids, a true flag on a
  fallback selection, a flag recomputed in the use case, cubit or widget, or an extra
  `getWishlistedGames()` call added per load, is a fail.

C21 [item 2.3] PRESENTATION-STATE [rewire]: `CountdownReleasesState` carries the wishlist flag,
defaulting to false. The cubit sets it from the use case result on every successful load and
re-sets it on every reload, including the reload triggered when a release date has passed, so a
newly selected game never inherits the previous game's flag. The 60-second tick emits duration and
release-day changes only and leaves the flag as it stands; a failed load does not raise it.
  Failure case: a stale true flag surviving a reload onto a different countdown game, the flag
  flipping on a tick, or a flag set on the failure path, is a fail.

C22 [§3.2 · home §4.1 · §2 law 3] PRESENTATION [card, rewire]: the card's reason line is determined
by the wishlist flag alone, and by nothing about local library membership. All three cases are
defined: (a) flag true — the cyan wishlist reason line of C10; (b) flag false and the game's id is
in the local library id set — the neutral `ink55` reason line, byte-identical to case (c), with no
cyan and no copy asserting a wishlist entry; (c) flag false and the game is not in the local library
— the same neutral reason line. Cases (b) and (c) are one rendered state, not two; the new
distinction is in the input, since library membership no longer selects the line. `featured` passes
the state's flag and never re-derives it from `localLibraryGameIds`, which survives only for the
out-this-week rail's owned marker (`countdown_releases.dart:357`).
  Failure case: the wishlist line appearing for a library game whose flag is false (today's
  behaviour at `countdown_releases.dart:76`), any wishlist-specific copy or cyan in cases (b) or (c),
  a third distinct reason line, or a card that still reads `localLibraryGameIds`, is a fail.

## Out of scope

- **Reminder scheduling.** No notification package exists in `pubspec.yaml`, and
  `roadmap-deferred.md` defers the notification centre. C11 covers the Remind affordance and its
  handler only — nothing in this item schedules, permissions, or persists a reminder.
- **Wishlisting from the countdown.** C20–C22 make the flag truthful; nothing in this item lets the
  user add or remove a wishlist entry, and no other consumer of the wishlisted set changes — the
  rail's wishlist-first ordering (`featured_repository_impl.dart:147–157`) stays as it is.
- **The out-this-week rail's own anatomy.** Its filled `Icons.videogame_asset` fallback (§1.9
  outline-only), its green owned marker (§2 law 1) and its 120px tiles stay as they are. That is
  Game card / Cover tile territory, already shipped as items 2.1 and 1.3 with the rail deliberately
  not adopted.
- **The countdown section's failure state** (`featured_screen.dart:170–182`, a `Colors.red.shade50`
  `Card`). That is item 2.7, Error states.
- **Wiring the tile form.** Its only spec'd host, the welcome screen 2 hero, was replaced by flat
  PNG art in item 6.1 — `onboarding-welcome-design-spec.md` §3c is marked superseded. The tile
  ships unwired, as the completion ring did in item 2.2.
- **Pixel verification.** Block min-widths (40px card / 52px tile), paddings, radii, the 22px vs
  30px figure sizes, the colon baseline offset and glass blur radius are manual device checks, not
  test assertions. No criterion above depends on measuring one.
- **`welcome_to_gameyes` (`intl_en.arb:144`, `intl_zh.arb:144`) carries a 🎮 emoji.** A genuine §4
  violation, but on the welcome surface, not this component. Flagged for a later item.

## Assumptions

ASSUMPTION-1: `system-foundation-specs.md` §3.2's "raised-indigo card" is read as the raised app
surface `#2F333C`, not the indigo panel `#2F3782`. `system-foundation-specs.md` lines 6–8 give
`home-screen-design-conventions.md` precedence for its own screen, and its §4.1 names
`--surface-raised`; §3.2's own rationale ("can't out-shout the primary zone") points at the quieter
step, and §1.1 reserves the indigo panel for the hero card and sheet header. Featured is the first
destination in the home shell, so §4.1 governs this card. Reviewed at the 2026-08-21 gate and left
standing.

ASSUMPTION-2 (HUMAN-CONFIRMED 2026-08-21): The card carries no cover thumbnail. Neither §3.2 nor
home §4.1 lists one; today's card has an 80×110 cover at `countdown_releases.dart:105–120`. This is
a visible change to a shipped screen, so it was put to the human at the gate and confirmed:
`home-screen-design-conventions.md` §4.1 has authority over §3.2 here, and the thumbnail is dropped.
It also retires the filled `Icons.videogame_asset` fallback at line 117.

ASSUMPTION-3: Figure sizes follow the screen specs — 22px in the card (home §4.1), 30px in the tile
(§3.3, welcome §3c). Both are even, so the standing even-number convention holds without the
collision items 1.9 and 2.2 hit. The existing `countdownFigure` (30) and `countdownColon` (22 at
40%) type tokens already match the tile form.

ASSUMPTION-4: Snapshot rather than live ticking (C3). home §4.1 states seconds are omitted
precisely so no live timer is needed, and the cubit already refreshes the duration every 60
seconds — a minute is the smallest unit shown, so that cadence is sufficient. A widget-owned timer
would duplicate it and risk a leak.

ASSUMPTION-5 (REVERSED BY HUMAN DECISION 2026-08-21 — the flag is now in scope): the original
assumption left wishlist provenance as today's inference and is withdrawn. `countdown_releases.dart:76`
computes `isFallback` from the local library id set, which is *every* saved game
(`featured_local_datasource.dart:31–35`), so the "Wishlisted" line renders for library games that
were never wishlisted — user-facing copy asserting something false about the user's own library. The
human confirmed the finding in the code and widened the run to thread a genuine boolean from the
repository (which already reads the wishlisted ids) through the use case and state to the card. See
C20, C21, C22, and the corrected C19; see `ambiguities.md` for the scope-widening rationale.

ASSUMPTION-6: No document specifies the copy. New strings are written to §4 (second person,
sentence case body ending in a period, caps labels with no terminal period, no exclamation mark, no
emoji) and added as l10n keys in both existing locales, matching how the section's other strings
are already localised. Existing keys `wishlist`, `wishlist_upcoming_game` and `reminder` are
available for reuse. This now also covers the neutral reason line shared by C22 cases (b) and (c),
which must not name the wishlist.

ASSUMPTION-7: Unit labels are `DAYS` / `HRS` / `MIN`, per home §4.1 and welcome §3c, replacing
today's `Days` / `Hrs` / `Mins`.

ASSUMPTION-8: The semantics label in C7 is not specified by any design document. It follows §5 and
the precedent set by item 2.2's completion ring, which added one.

ASSUMPTION-9: The released-state label is a short caps line (§4 headline shape). Its wording is not
specified anywhere; the constraint that binds is C4 — neutral ink, no green, no digits.

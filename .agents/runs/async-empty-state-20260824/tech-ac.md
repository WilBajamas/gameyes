# Technical Acceptance Criteria
Source: FRS `requirements.md` (run `async-empty-state-20260824`), FR-2.8.1–FR-2.8.5,
plus the human gate rulings in `gate-decisions.md` (2026-08-24)
Date: 2026-08-24
BA Agent version: 1.0

## Feature summary

Add one shared empty-state widget under `lib/widgets/` and route five existing
improvised empty branches through it. The widget renders a filled card on the
raised surface carrying an optional glyph, a caps headline, exactly one supporting
line and exactly one required action. Five call sites are rewired: the games grid's
empty branch (today an error component), the now-playing card (today a dashed
custom-painted border), the critics grid and countdown releases boxes (today
fixed-height containers with hardcoded English), and the featured screen's countdown
section (today `SizedBox.shrink()`). Every string the component renders comes from
`.arb`. Loading/shimmer and error branches are untouched, as are the two tracker
sites. The `flutter-widgets` skill's empty-state note and widget catalogue are
updated to name the new component.

Site numbering follows FR-2.8.3: 1 `games_screen`, 2 `library_stats` now-playing,
3 `critics_grid`, 4 `countdown_releases`, 5 `featured_screen` countdown section.

## Technical acceptance criteria

### The shared component

AC-01 [FR-2.8.1] WIDGET: A new stateless widget under `lib/widgets/` exposes a
required headline string, a required supporting-line string, a required action
label string, a required action callback, and an optional glyph. Constructing it
without a headline, supporting line, label or callback is a compile error.
  Failure case: if a caller supplies an empty string for headline, line or label,
  the widget still renders its slot — it performs no fallback substitution and
  never renders untranslated literal text.

AC-02 [FR-2.8.1 / gate CRITICAL-1] WIDGET: The card is filled with the app's raised
surface token (`surfaceRaised`, #2f333c). The widget file contains no `Colors.*`
literal, no `Color(0x…)` literal and no `colorScheme.*` surface lookup.
  Failure case: any hardcoded colour or `colorScheme` surface read in the file
  fails this criterion outright; no art-deep token is minted and no foundations
  file is edited by this run.

AC-03 [FR-2.8.1] WIDGET: The card's corners use the shared `lg` radius token; no
numeric radius literal appears in the file.
  Failure case: a literal `BorderRadius.circular(16)` fails, even though the value
  matches.

AC-04 [FR-2.8.1] WIDGET: The headline renders in capitals from a source string that
is authored in normal case, at the 22 / 700 display step, in the `ink` colour.
  Failure case: an `.arb` value authored in capitals fails; the capitalisation is a
  render-time treatment, and is a no-op for the Chinese locale.

AC-05 [FR-2.8.1] WIDGET: Exactly one supporting-line text is rendered, at the
16 / 1.45 / 400 body step in `ink70`, with no `maxLines` and no ellipsis, so long
translations wrap.
  Failure case: a second supporting text slot, or a truncation clamp, fails.

AC-06 [FR-2.8.1 / gate CRITICAL-2] WIDGET: Exactly one action control is rendered
and it is always present. Tapping it invokes the supplied callback exactly once per
tap. The control is built from an existing shared button widget; the file defines no
bespoke button styling.
  Failure case: no code path renders the component without an action; a second
  tappable control in the component fails.

AC-07 [FR-2.8.1] WIDGET: The component contributes no outer margin or spacing —
only its own internal padding inside the card. Callers own the surrounding layout.
  Failure case: any `Padding`/`SizedBox` wrapping the outermost card fails.

AC-08 [FR-2.8.1] WIDGET: The card carries no border and no custom painting. No
`CustomPainter`, no `BorderStyle.none`, no dashed stroke anywhere in the component.
  Failure case: a solid border added later is permissible under §0 item 6 only; a
  dashed one is never permissible.

AC-09 [FR-2.8.1] WIDGET: The component takes intrinsic height and expands to the
available width. It declares no fixed height.
  Failure case: a hardcoded height carried over from sites 3 or 4 fails.

AC-10 [FR-2.8.1] WIDGET: The widget file contains zero comments, including doc
comments on constructor parameters.
  Failure case: any `//` or `///` in the file fails.

### Call-site rewiring

AC-11 [FR-2.8.3 site 1 / gate CRITICAL-3] SCREEN — `games_screen.dart`: The
`GamesStatus.empty` branch renders the shared component instead of
`ErrorRetryWidget`. Its action dispatches `GamesFetched` on the existing bloc, the
same event it dispatches today.
  Failure case: the empty branch dispatching anything other than `GamesFetched`, or
  still rendering an error component, fails.

AC-12 [FR-2.8.3 site 1] SCREEN — `games_screen.dart`: After the change,
`ErrorRetryWidget` is referenced exactly twice in the file, in the
`GamesStatus.failed` and `GamesNextPageStatus.failed` branches, and
`lib/widgets/error_retry_widget.dart` is byte-identical to its pre-change state.
  Failure case: three or fewer/more references, or any edit to the error widget
  itself, fails.

AC-13 [FR-2.8.3 site 2] WIDGET — `library_stats.dart`: The empty now-playing branch
renders the shared component with the play glyph it uses today, keeps
`onMarkNowPlaying` as its action, and the dashed-border implementation is gone:
`_DashedBorderPainter` is deleted from the file, no reference to it remains, and no
`BorderStyle.none` remains.
  Failure case: leaving `_DashedBorderPainter` in place unreferenced fails — it
  would be dead code and a new analyzer `unused_element`.

AC-14 [FR-2.8.3 site 3 / gate CRITICAL-2] WIDGET — `critics_grid.dart`: The empty
grid branch renders the shared component. Its action clears the genre selection and
causes the section to reload without a genre filter. One tap results in exactly one
preference save and exactly one section reload, whatever number of genres was
selected; with no genre selected the tap still reloads the section unfiltered.
  Failure case: a tap that fires one save-and-reload per selected genre fails; so
  does an action that does nothing when the selection is already empty.

AC-15 [FR-2.8.3 site 4 / gate CRITICAL-2] WIDGET — `countdown_releases.dart`: The
empty weekly-releases branch renders the shared component, and its action switches
the home tabs router to the Browse tab (`setActiveIndex(3)`).
  Failure case: `context.router.push(BrowseRoute())` fails this criterion — it
  stacks Browse over Featured and leaves the tab bar's active cap on Featured.

AC-16 [FR-2.8.3 site 5 / gate CRITICAL-2] SCREEN — `featured_screen.dart`: The
countdown section's `state.countdownGame == null && state.outThisWeekGames.isEmpty`
branch renders the shared component in the exact slot `SizedBox.shrink()` occupies
today, with no section heading introduced above it. Its action switches the home
tabs router to the Browse tab (`setActiveIndex(3)`).
  Failure case: the section rendering nothing in this state fails; so does adding
  surrounding chrome that shifts the rest of the screen when the section is empty.

AC-17 [FR-2.8.3 sites 4–5] SCREEN/WIDGET: No `router.push` and no `BrowseRoute`
reference is introduced by this run at sites 4 or 5.
  Failure case: any navigation stack push added for the Browse destination fails.

AC-18 [FR-2.8.3 sites 4–5] SCREEN: For any single state of the countdown section,
exactly one empty state renders — site 5 when there is neither a countdown game nor
weekly releases, site 4 when a countdown game exists and the weekly list is empty.
  Failure case: both rendering together, or neither rendering while both lists are
  empty, fails.

AC-19 [FR-2.8.3] ALL SITES: After the change, no site renders a hardcoded English
string, an unlocalised label, or a `Container`-plus-`Text` improvised empty state.
Every empty branch at the five sites resolves to the shared component.
  Failure case: `'No critic reviews found'` or `'No releases in this period'`
  surviving anywhere in `lib/` fails.

### Scope boundaries enforced in code

AC-20 [FR-2.8.2] ALL SITES: No `Skeletonizer`, shimmer widget, loading branch or
`GameLoadingWidgetData` usage is modified. No error branch is modified —
`GamesStatus.failed`, `GamesNextPageStatus.failed`, `CriticsGridStatus.failed` and
`CountdownReleasesStatus.failed` render exactly what they render today.
  Failure case: any diff hunk inside a loading or failed branch fails, even if it
  only reformats.

AC-21 [FR-2.8.4] OUT-OF-SCOPE SITES: `tracker_tasks_section.dart` and
`tracker_game_detail_section.dart` are unchanged.
  Failure case: any edit to either file fails, including a "while I'm here"
  conversion to the new component.

### Localisation

AC-22 [FR-2.8.3] L10N: New keys exist in both `lib/l10n/intl_en.arb` and
`lib/l10n/intl_zh.arb` for every string the five sites need and do not already have:
supporting line and action label for site 1, supporting line for site 2, and
headline, supporting line and action label for sites 3, 4 and 5. The two files hold
identical key sets, and the generated localisation output is regenerated.
  Failure case: a key present in one locale only, or an English value left in the
  Chinese file, fails.

AC-23 [FR-2.8.1] L10N: Every new value invites the next step. No value contains an
apology, a "sorry", a "not found"/"nothing here" framing, an exclamation mark, an
emoji or a dingbat, in either locale.
  Failure case: reusing `S.current.retry` as site 1's action label fails — the
  re-dispatch behaviour is kept, the error wording is not.

AC-24 [FR-2.8.3] L10N: `no_results_found`, `no_game_in_progress` and
`mark_something_playing` are reused rather than duplicated under new keys, and the
trailing `→` is removed from `mark_something_playing` in both locales.
  Failure case: a near-duplicate key with the same meaning fails; so does a
  surviving arrow glyph in either locale's value.

### Documentation

AC-25 [FR-2.8.5] DOCS: `.claude/skills/flutter-widgets/SKILL.md:218-220`'s
empty-state note is replaced by one naming the new component and its required
anatomy, and the skill's widget catalogue gains an entry for it. The
`ErrorRetryWidget`-as-empty-state workaround no longer appears anywhere in the
skill.
  Failure case: editing `project-conventions.md` instead fails — line 11 there only
  points at the skill, per FR-2.8.5.

### Verification

AC-26 [FR-2.8.1] TEST: A widget test for the component asserts that the headline,
supporting line and action label render, that a tap invokes the callback exactly
once, and that the card fill is the raised surface token named as a token. It
asserts no dimension, gap, radius or position, and uses no `matchesGoldenFile`.
  Failure case: a pixel or layout assertion, or a golden, fails this criterion
  regardless of whether it passes at runtime.

AC-27 [FR-2.8.3] TEST: Existing tests that reference the replaced empty branches are
updated to the new component rather than deleted, and the suite result is no worse
than the recorded baseline (+343 -10, with the three known failing files).
  Failure case: a new in-scope failure, or a test weakened/removed to make the
  change pass, fails.

AC-28 [FR-2.8.2] ANALYZER: `flutter analyze` reports no new issue against the
baseline of 0 errors, 2 warnings, 31 info.
  Failure case: a new `unused_element` from a leftover `_DashedBorderPainter`, or a
  new unused-import warning at a rewired site, fails.

## Out of scope

- The loading/shimmer half of §3.2's Async states row, and its cover-art
  desaturation text (FR-2.8.2).
- Error states — shipped by item 2.7 (FR-2.8.2).
- `tracker_tasks_section.dart` and `tracker_game_detail_section.dart` (FR-2.8.4).
- Minting an art-deep colour token or any other foundations edit; the gate settled
  the fill as the existing raised surface. Recording that §2.2's "art-deep is the
  empty-state card fill" is unimplemented app-side is a follow-up, not this run's
  work (gate CRITICAL-1).
- The 15px type-step gap: neither the 22 headline nor the 16 supporting line lands
  on an odd value, so nothing here forces it open.
- `ErrorRetryWidget`'s own implementation, and its two genuine error call sites.
- The Stage 2 checklist's wrong doc path — already recorded in `requirements.md`
  FR-2.8.5; correcting the checklist itself is not part of this change.
- Tone of the reused existing strings beyond dropping the arrow: `no_results_found`,
  `no_game_in_progress` and `mark_something_playing` keep their current wording.

## Assumptions

ASSUMPTION-1 through ASSUMPTION-17 in `ambiguities.md` apply in full and are not
restated here. The load-bearing ones for these criteria: headline 22/700 caps (1),
supporting line 16/1.45/400 (2), sites 1 and 2 keep today's callbacks (4), existing
strings reused with the arrow dropped (5), caps applied at render (6), caller-supplied
glyph (7), one empty state per countdown section (8), no spacing of its own (9), no
border (10), new copy for sites 1 and 2 as well (11), one save and one reload per tap
at site 3 (12), `lg` radius (13), `ink`/`ink70` (14), 44 glyph (15), no line clamp
(16), intrinsic height (17).

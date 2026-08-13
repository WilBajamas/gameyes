# Ambiguities Report
Source: Week 2 task briefs items 1.5, 1.6, 1.7 (combined run) · `system-foundation-specs.md` §3.2, §3.3 (with §0.6, §1.2, §1.4, §1.6, §2, §5, §6) · `onboarding-welcome-design-spec.md` §3/§3b · `home-screen-design-conventions.md` §3.2/§5.1 · `game-detail-design-conventions.md` §5
Date: 2026-08-13

## CRITICAL (pipeline blocked — requires human decision before proceeding)
NONE

Six candidates were examined; all resolve from the requirement text, the specs, or an existing
in-repo precedent. The four worth reading:

1. **Two components have no surface to live on.** The context chip (1.6) and the stat pill's glass
   hero form (1.7) both existed only on the welcome heroes, whose composed content item 6.1
   replaced with flat PNG art on 2026-08-04 — `onboarding-welcome-design-spec.md` §3 marks both
   "removed entirely by item 6.1". No other hero is built. Resolved as in scope and unwired: the
   week-2 checklist was written 2026-08-07, after that removal, and still lists 1.6 as a Stage 1
   primitive; the same "ship it unwired, it's groundwork" call is already stated for item 2.2's
   completion ring and was taken for the placeholder slot's provider preset. Cheap for Tech Lead to
   reverse at Phase 2 if it judges either dead code — but they are the requirement as written.

2. **§3.3 vs. the surface docs on numbers.** Three collisions: chip padding/type (§3.3 `8px 14px`
   at 14px/500 vs Home §5.1 `9px 14px` at 13px/500); stat figure size (the app type ramp and §3.3
   both say 18px, Home §3.2 says 24px, game detail §5 says 20px); stat label (§3.2 says 11–12px at
   `ink55`, the welcome doc's glass stat bar says 10px at `ink70`). Resolved to §3.3/§3.2 as the
   designated anatomy source of truth, with the third collision resolved as two forms of one
   component rather than a contradiction — §3.2 explicitly cross-references §3.3 as "the hero-panel
   form". The Home and game-detail variances belong to those screens when they get built; both are
   noted under "Out of scope" so the next item does not read them as defects.

3. **Rewiring scope.** The checklist's "Open decisions that could block" delegates blast-radius
   sizing to each item's own BA/Tech Lead phase. Sized here: 1.5 touches 3 widget files and affects
   one screen (the filter bottom sheet's three chip groups, no counts anywhere); 1.7 touches 1 file
   and one screen section. Both are small and single-surface, so both rewire in-run — matching the
   call already recorded for item 2.3. Two visible consequences the human should expect at the QA
   gate: the filter sheet's chips change colour treatment (indigo active / 8% ink inactive), and
   the featured screen's three stat tiles lose their icons and their blue/orange/green tints, which
   §3.3's anatomy has no slot for and colour law forbids anyway.

4. **Two more off-spec filter chips exist that item 1.5 does not name.** `_SelectionChip` in
   `default_filter_list_app_bar.dart` and in `filter_list_app_bar.dart` both draw a filter chip with
   ad-hoc `ColorScheme` colours. Left out of scope: the brief names only `default_choice_chip.dart`,
   both are app-bar tab controls with a different API and an icon slot, and
   `test/widget/tracker/default_filter_list_app_bar_test.dart` covers one of them on a live surface.
   Flagged so Tech Lead can decide whether "one anatomy per concept" makes them part of this item or
   a follow-up; the BA position is follow-up.

## FINDING (not an ambiguity — reported for the human)

`lib/features/featured/presentation/widgets/library_stats.dart` contains a `_DashedBorderPainter`
that draws a dashed border around the empty now-playing card, with the comment
`style: BorderStyle.none, // We want dashed border`. This is a live violation of the standing
"outlines are always solid" rule (`system-foundation-specs.md` §0.6), and it contradicts item 1.4's
closing note that "nothing outside this widget is known to draw one". It is in a file this run
edits, but it belongs to the empty state (item 2.8), not the stat pill, so this run leaves it alone
([1.7-AC11]). Worth scheduling deliberately rather than discovering again.

## TESTING MODE (BA reasoning — Tech Lead decides)

Recommendation: `coverage`. The mechanical trigger list does not fire — no auth, payments,
persistence or sync, and no component here is a shared utility used by 3+ features (the filter chip
reaches exactly one feature, the stat pill one, the context chip none), so the first-match rule as
written lands on `smoke`, as it did for the zone label, status chip and placeholder slot. The
argument for overriding to `coverage` is the combined surface, not the criticality: three components
with roughly a dozen distinct visual states between them (chip active/inactive × count
present/absent/zero, stat pill tile vs glass × 2 vs 3 pairs), plus two live call sites being
rewired. `smoke`'s "happy-path test per primary criterion, one file per implementation file" would
leave most of that matrix unexercised. If Tech Lead prefers to follow the rule mechanically,
`smoke` with the full state matrix listed in [ALL-AC7] would also be acceptable — the matrix
matters more than the label.

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: All three are in-run reworks/additions with callers migrated in the same run; no
`@Deprecated` alias is retained, since nothing is left pointing at an old API.

ASSUMPTION: The reworked filter chip and the two new widgets are renamed categorically, without a
`default` prefix, and must not collide with Flutter's own `FilterChip`/`ChoiceChip`/`Chip` — a name
that forces an import alias at any call site is a defect ([1.5-AC2]). Exact names are Tech Lead's.

ASSUMPTION: The `.30–.34` glass range becomes one fixed value per component, not a caller
parameter. `glass30`, `glass32` and `glass34` are all already tokenised; `.32` is the midpoint and
any of the three satisfies the spec, so the pick is Tech Lead's.

ASSUMPTION: The active chip's count renders in white, mirroring the existing status chip's filled
state. Only the inactive count colour (`ink55`) is specified anywhere.

ASSUMPTION: The chip's tap target meets the project-wide 44px accessibility floor without changing
the drawn capsule, following the existing `ZoneLabel` link precedent. The Home doc's contrary note
("chips at 35px tall are text-adjacent, not primary actions") is recorded as the alternative; these
chips are tapped, so the accessibility rule was taken as the safer default.

ASSUMPTION: The context chip's leading icon is required (§3.3 gives it no iconless form) and its
gap to the label is 6px, matching the status chip's internal gap. No doc states the gap.

ASSUMPTION: The stat pill's tile form centres its figure and label and takes 13px interior padding
(the Home doc's stat triplet is the only padding any doc gives it), so the featured screen's rewire
is not also an alignment change.

ASSUMPTION: The glass form's 2–3 pair limit is enforced by the widget rather than left to callers,
since §3.3 states it as anatomy. A debug-time failure is the narrow reading; Tech Lead picks the
mechanism.

ASSUMPTION: Figures, labels, counts and captions are all caller-supplied strings — no component
formats, abbreviates or localises anything, so no new `.arb` key is needed and no user-facing
string lives in any of the three files.

ASSUMPTION: Hover, press (`scale(0.97)`), focus rings and any animated state transition are out of
scope. No press-state token exists, no component in this library implements one, and adding the
first is its own decision rather than a side effect of three primitives.

ASSUMPTION: No new third-party dependency and no new design token are required; `pubspec.yaml` is
read-only. The two type values with no exact token are Tech Lead's call to add or compose.

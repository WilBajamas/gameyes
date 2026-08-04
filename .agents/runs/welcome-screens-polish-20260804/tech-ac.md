# Technical Acceptance Criteria
Source: Ticket `W1-6.2R` — "Welcome screens polish + global system UI convention (item 6.2)"
(`.agents/runs/welcome-screens-polish-20260804/source-request.md`), refining
`.agents/runs/welcome-screens-header-rework-20260804/tech-ac.md` (ref `W1-6.1R`) and,
through it, item 6 (ref `W1-6`)
Date: 2026-08-04
BA Agent version: 1.0

## Feature summary

Four changes to the two welcome screens, plus one app-wide default. The hero panel gains
inset padding so its content art stops touching the panel edges, and both hero heights
drop from roughly half the reference frame to roughly a third. Both screens gain
`SafeArea`, which makes the copy block's existing manual bottom-inset addition redundant
and requires it to be removed so the inset is not counted twice. Separately, the app sets
its system UI overlay style once at startup — transparent status bar, system navigation
bar reading as the app canvas — as a standing default for every screen, recorded as a
convention rather than a one-off. Finally the two screens are placed in a horizontal
paging viewport so a drag moves between them; the existing Next, Skip and Get started
buttons and the onboarding-seen persistence rules are untouched by this, and the
progress-dot indicator continues to reflect only the settled step, never a live drag
offset. Two reference documents are updated: the design spec's hero height table, and the
conventions doc that gains the new system UI rule.

**Three things the Tech Lead must plan around:**

1. **This run reverses `[W1-6.31]`'s "no parallax, spring or scroll-jacking" rule for
   navigation.** A swipeable paging viewport is exactly what that criterion forbade. The
   reversal is a confirmed product-owner decision. Do not escalate it, and do not
   reinstate the ban for the rest of the flow — the rule still binds everything that is
   not this navigation gesture.
2. **`AnimatedSwitcher` and a paging viewport cannot both own the step transition.** The
   switcher goes; the tokens it used carry over to the paging animation, including the
   reduced-motion collapse. The existing widget test that asserts on `AnimatedSwitcher`
   must be rewritten, not deleted, so the reduced-motion coverage survives.
3. **A paging viewport can keep the offscreen page mounted.** Several existing widget
   tests count widgets across the whole tree (one green element, exactly one `Image`,
   `Skip` absent on step 2). Those counts must be re-scoped to the visible page or they
   will fail for a reason that is not a defect. See `[W1-6.2R.22]`.

## Technical acceptance criteria

### Hero content padding

[W1-6.2R.1] UI: The hero panel insets its content image by `24` on all four sides, so the
content image is laid out inside a `240 - 48` (screen 1) / `216 - 48` (screen 2) high,
`viewport width - 48` wide box. The inset applies to the content image only — the flat
fill (screen 1) and the background image (screen 2) still cover the panel's full area
edge to edge and are still clipped to the panel's directional bottom radius.
  Failure case: the content image touching any panel edge, the fill or background image
  inset with it (canvas visible in a border around the panel), or the inset applied on
  some axes only, fails the criterion.

[W1-6.2R.2] UI: The content image keeps every property `[W1-6.1R.4]` fixed — centred on
both axes, scaled to fit entirely inside its box with aspect ratio preserved, no crop.
Padding reduces the box; it does not change the fit or alignment.
  Failure case: the image cropped, stretched, or anchored anywhere other than centred
  within the padded box fails the criterion.

### Hero height

[W1-6.2R.3] UI: Screen 1's hero height is `240` and screen 2's is `216`, replacing `400`
and `356`. Both sit on the 8px spacing scale, both fall between 30% and 36% of the 714
reference height, and screen 1 is greater than or equal to screen 2. This supersedes the
height clause of `[W1-6.12]` and `[W1-6.1R.1]`; the directional bottom radius `0 0 88 88`
and the full-viewport width in those criteria are unchanged.
  Failure case: either height outside 30–36% of 714, either height off the 8px scale,
  screen 2 taller than screen 1, or a changed radius or width, fails the criterion. A
  design-gate-approved substitute pair that still satisfies all three conditions passes.

[W1-6.2R.4] UI: Neither screen overflows and the copy block stays bottom-anchored on a
`360 × 600` viewport at 1.5× text scale, on both pages. The short-screen give-back that
trades hero height for copy-block space is retained and continues to be the mechanism
that prevents overflow. Restates `[W1-6.41]` / `[W1-6.1R.17]` against the new heights.
  Failure case: any framework render-overflow on either page at that viewport and text
  scale, or a hero that renders at a negative or zero height, fails the criterion.

[W1-6.2R.5] DOCS: `.agents/references/onboarding-welcome-design-spec.md § 3`'s height
table states the heights actually implemented by this run instead of `400` / `356`, and
its "being reduced, see run notes" placeholder is gone. No other row of that table is
edited by this criterion.
  Failure case: the design spec still documenting `400` / `356` as the hero heights, or
  documenting a pair different from the one the code uses, fails the criterion.

### SafeArea

[W1-6.2R.6] UI: Both welcome pages render inside a `SafeArea` that insets all four edges,
following the existing `Scaffold(body: SafeArea(child: ...))` precedent in
`games_screen.dart`. No welcome content is laid out under the status bar, the system
navigation bar, or a display cutout.
  Failure case: content clipped by or drawn under a system inset on either page, or a
  `SafeArea` that disables one or more edges without a design-gate decision recorded,
  fails the criterion.

[W1-6.2R.7] UI: The bottom system inset is applied exactly once. The copy block's manual
addition of the raw `MediaQuery` bottom padding to its own bottom padding is removed,
since `SafeArea` now consumes that inset for everything beneath it. On a viewport with a
non-zero bottom inset, the gap between the action row and the safe-area edge equals the
copy block's own bottom padding, not that padding plus the inset again.
  Failure case: the action row sitting a full system-inset height further from the bottom
  than on a device with no inset, or any surviving direct read of the bottom inset inside
  the welcome widget tree, fails the criterion.

### Global system UI overlay style

[W1-6.2R.8] APP: The app sets its system UI overlay style once, in the shared startup
sequence that every flavour entrypoint runs, before the app widget is handed to
`runApp`. It is not set per screen, not set inside a route, and not set inside a `build`
method. Applying it once must not require any welcome-specific code.
  Failure case: the style set in more than one place, set inside a screen or widget, or a
  flavour entrypoint that reaches `runApp` without it, fails the criterion.

[W1-6.2R.9] APP: That style carries a fully transparent status bar colour, a system
navigation bar colour equal to `AppColorTokens.canvas` (`0xFF23272A` — the same value the
dark theme already uses as its scaffold background), a transparent navigation bar divider,
and light status-bar and navigation-bar icons. The colour is read from the existing token,
never written as a fresh literal, and no new token is added.
  Failure case: a hard-coded colour literal, a colour that is not the canvas token, an
  opaque status bar, a visible navigation bar divider, or dark system icons on the dark
  canvas, fails the criterion.

[W1-6.2R.10] APP: The resulting appearance is that the status bar area shows whatever the
screen paints behind it and the system navigation / gesture bar area reads as the app
canvas, on every screen, with no per-screen code. On Android API 35 and above the platform
ignores the two colour fields and draws the app edge to edge; the requirement is satisfied
there because the app's own scaffold background is already the canvas colour, so the
visible outcome matches. The app must therefore not introduce any opaque bar of its own in
either region to compensate.
  Failure case: a black or differently-coloured band behind the system navigation bar on
  any screen, an opaque overlay widget added to fake the effect, or an app that suppresses
  edge-to-edge drawing to work around the platform behaviour, fails the criterion.

[W1-6.2R.11] DOCS: `.agents/references/project-conventions.md` gains a section recording
this as a standing app-wide convention: every screen's body is wrapped in `SafeArea`, and
the system UI overlay style is a single global default (transparent status bar, navigation
bar area matching the app canvas) set once at startup and never overridden per screen. The
section states that a screen wanting a different treatment is a deviation requiring a
decision, not a free choice.
  Failure case: the convention recorded only in a run artifact, recorded as a description
  of the onboarding screens rather than as an app-wide rule, or absent, fails the
  criterion.

### Swipe navigation

[W1-6.2R.12] UI: The two welcome screens are the two pages of a horizontal paging viewport
with exactly two pages — index 0 is screen 1, index 1 is screen 2. There is no third page
and the viewport clamps at both ends.
  Failure case: a third page, a page order that puts screen 2 first, a vertical scroll
  axis, or a viewport that scrolls past either end onto empty space, fails the criterion.

[W1-6.2R.13] UI/STATE: A horizontal drag from screen 1 that settles on page 1 moves the
flow to step two, and a drag from screen 2 that settles on page 0 moves it back to step
one. A drag that does not settle onto a new page leaves the step unchanged.
  Failure case: a completed swipe that leaves the step unchanged, a partial drag that
  changes it, or a swipe in the wrong direction changing the step, fails the criterion.

[W1-6.2R.14] STATE: `WelcomeState.step` remains the single source of truth for which
screen is current. A settled page change updates it, and a step change caused by a button
moves the viewport to the matching page. The two directions must reconcile without
re-triggering each other: after any single swipe or button tap the widget tree settles,
and the settled page index matches the state's step.
  Failure case: a pump that never settles, a page and a step that disagree after settling,
  or a step held in widget-local state instead of the cubit, fails the criterion.

[W1-6.2R.15] UI: The progress-dot indicator's active dot is determined solely by the
settled step. It does not read the paging controller's live position, does not
interpolate, does not resize or fade progressively, and does not animate between states.
Held mid-drag, the indicator still shows the origin page as active.
  Failure case: an indicator whose dot widths change during a drag, an indicator built
  from a controller offset or a scroll notification, or any animated transition applied to
  the dots, fails the criterion.

[W1-6.2R.16] UI: Next, Skip and Get started keep the labels, placement, styling and
behaviour they have today. Next moves to page 1. Skip and Get started end the flow and
replace the route exactly as they do now. No button is removed, hidden on a page it
appears on today, or given a new behaviour.
  Failure case: any change to a button's label, position, availability, or the route or
  method it triggers, fails the criterion.

[W1-6.2R.17] UI/MOTION: `AnimatedSwitcher` no longer drives the step transition. A
button-driven page change animates using the existing `screenTransition` duration and
`screenTransitionCurve` tokens, and collapses to an instant page change when the platform
reports reduced motion. A user's own drag is direct manipulation and is not gated by the
reduced-motion setting. Supersedes `[W1-6.31]`'s ban on scroll-driven navigation for this
gesture only; `[W1-6.32]`'s reduced-motion collapse carries forward and is what the
instant page change satisfies.
  Failure case: a hard-coded duration or curve, a button-driven page change that still
  animates under reduced motion, a surviving `AnimatedSwitcher` around the two steps, or a
  drag disabled under reduced motion, fails the criterion.

[W1-6.2R.18] UI: System back on screen 2 moves to screen 1 and does not pop the route;
system back on screen 1 pops normally. This is `[W1-6.39]`'s existing behaviour and must
survive the move to a paging viewport, arriving at the same visible result as a backward
swipe.
  Failure case: back popping the onboarding route from screen 2, back doing nothing on
  screen 2, or back leaving the page and the step disagreeing, fails the criterion.

[W1-6.2R.19] STATE: Reaching screen 2 by swiping writes nothing to storage, and swiping
back to screen 1 writes nothing either. `[W1-6.36]`–`[W1-6.39]` are carried forward
unchanged: only an explicit Skip tap on screen 1 or Get started tap on screen 2 writes the
onboarding-seen flag. No page-change handler may touch persistence.
  Failure case: any storage write triggered by a page change, by a drag, or by reaching
  the last page, fails the criterion.

### Tests, build and baselines

[W1-6.2R.20] TEST: `test/widget/onboarding/welcome_screen_test.dart` covers, in addition
to the coverage `[W1-6.1R.18]` already requires: a forward swipe reaching screen 2 without
writing the flag; a backward swipe returning to screen 1; the progress-dot active state
staying on the origin page mid-drag; and the button-driven page change being instant under
reduced motion. No golden test, no `matchesGoldenFile`, no skipped or commented-out test.
  Failure case: a missing case from that list, a swipe test that asserts only on the
  cubit's state and never on what is visible, or a golden test, fails the criterion.

[W1-6.2R.21] TEST: The bottom-inset double-count is covered by a test that pumps the flow
with a non-zero `MediaQuery` bottom padding and asserts the action row's distance from the
safe-area edge does not grow by that inset.
  Failure case: no test exercising a non-zero bottom inset fails the criterion.

[W1-6.2R.22] TEST: Assertions that count widgets across the whole tree are scoped to the
visible page, because the paging viewport may keep the offscreen page mounted. This covers
at minimum the one-green-element count, the hero `Image` count, and the assertion that
`Skip` is absent on screen 2. `[W1-6.29]`'s "one green element per screen" is read as one
green element per visible page.
  Failure case: a test that fails only because the offscreen page is mounted, or a test
  weakened (an exact count relaxed to `findsWidgets`, an assertion deleted) instead of
  scoped, fails the criterion.

[W1-6.2R.23] BUILD: `flutter analyze` reports no new error or warning against this run's
recorded baseline (0 errors, 2 warnings, 36 info), `flutter test` shows no new failure
against the recorded baseline of +144 / -13, and the onboarding widget tests are green at
the end of the run. The 13 recorded pre-existing failures stay exempt and must not be
touched; the onboarding widget test file is in scope for this run, so a red test there is
not covered by the exemption.
  Failure case: a new analyser error or warning attributable to this run's files, a new
  test failure outside the recorded pre-existing set, or a red onboarding widget test at
  the end of the run, fails the criterion. If an onboarding failure traces to a cause
  outside this ticket, it is escalated with that root cause named, not silently carried.

### Carried forward, unchanged

Everything item 6 and item 6.1 fixed that this ticket does not name stays in force and is
referenced by its original ID, never re-derived. Specifically and non-exhaustively:

| ID | Subject | Note |
|---|---|---|
| `[W1-6.1]`–`[W1-6.7]` | Token layer; no raw colour/shadow/blur/type literals in widget files | Untouched. This run adds no token and changes no token value |
| `[W1-6.8]`–`[W1-6.11]` | Route resolution, guard, two-part frame with bottom-anchored copy block | Untouched |
| `[W1-6.12]` | Hero geometry | Height clause superseded by `[W1-6.2R.3]`; radius and width stand |
| `[W1-6.24]`–`[W1-6.26]` | Progress-dot geometry, headline type, body type | Untouched. `[W1-6.2R.15]` governs only what drives the active state |
| `[W1-6.27]`–`[W1-6.30]` | Screen 1 Next + text Skip, screen 2 Get started alone, one green element, press scale and focus ring | Untouched; `[W1-6.2R.16]` restates that they do not change, `[W1-6.2R.22]` re-scopes how the green count is asserted |
| `[W1-6.31]` | No parallax / spring / scroll-jacking | **Superseded for navigation only** by `[W1-6.2R.17]`. Still binds everywhere else |
| `[W1-6.32]` | Reduced-motion collapse | Untouched; satisfied by `[W1-6.2R.17]` |
| `[W1-6.33]`–`[W1-6.35]` | Text via `S.current`, both `.arb` files in sync, generated l10n never hand-edited | Untouched. This run adds and removes no localisation key |
| `[W1-6.36]`–`[W1-6.39]` | Onboarding-seen flag written on Skip and Get started only, never mid-flow; back moves screen 2 → screen 1 | **Carried forward verbatim.** `[W1-6.2R.19]` and `[W1-6.2R.18]` only confirm they survive the new gesture |
| `[W1-6.40]` | 44 minimum hit targets, WCAG AA for body and metadata | Untouched |
| `[W1-6.41]` | No overflow on short viewports or at large text scale | Restated against the new heights as `[W1-6.2R.4]` |
| `[W1-6.42]` | Widget tests under `test/widget/onboarding/`, no golden tests | Coverage extended by `[W1-6.2R.20]`–`[W1-6.2R.22]` |
| `[W1-6.43]` | Android debug build and analyser baseline | Baseline figures replaced by `[W1-6.2R.23]` |
| `[W1-6.44]` | No platform conditional, no iOS branch, no landscape layout | Untouched |
| `[W1-6.1R.1]` | Hero is a code-rendered container with the directional bottom radius | Height clause superseded by `[W1-6.2R.3]`; the rest stands |
| `[W1-6.1R.2]`–`[W1-6.1R.6]` | Screen 1 flat indigo fill, screen 2 background image, one centred content image per hero, no fallback art | Untouched; `[W1-6.2R.1]` only adds the inset |
| `[W1-6.1R.7]`–`[W1-6.1R.10]` | Ambient circles, chips, stat pill, cover fan, key art, countdown, social-proof row all absent | Untouched |
| `[W1-6.1R.11]`–`[W1-6.1R.16]` | Assets consumed from the registered directory, `pubspec.yaml` untouched, no token change, l10n untouched, images decorative | Untouched |

## Design-gate items

Flagged for the human design gate rather than decided here. Each has a provisional value
in the criteria above so the pipeline can proceed; a gate decision overrides it without
reopening any other criterion.

1. **Hero content padding value** — provisional `24` on all sides (`[W1-6.2R.1]`). The
   ticket delegates the number. Any 8px-scale value works mechanically; `24` was chosen so
   the art aligns with the copy block's gutter.
2. **Hero heights** — provisional `240` / `216` (`[W1-6.2R.3]`). The ticket calls this a
   design-review judgement explicitly.
3. **Whether the hero bleeds under the status bar** — provisional: no, `SafeArea` insets
   all four edges (`[W1-6.2R.6]`). Requirement 3 asks for both a `SafeArea` and a
   transparent status bar, and those two pull in opposite directions at the top edge: with
   a full `SafeArea` the visible result is a canvas band above the hero, not the hero
   itself showing through. The alternative is `SafeArea(top: false)` on these screens only,
   which would contradict `[W1-6.2R.11]`'s app-wide rule and needs to be an explicit
   exception if wanted.
4. **Progress-dot placement under swipe** — provisional: each page keeps its own indicator
   in its own copy block, exactly where the design spec § 4 puts it, so mid-drag both
   indicators slide with their pages. The alternative is one shared indicator hoisted out
   of the paging viewport and held still, which restructures the bottom-anchored copy
   block. Either satisfies `[W1-6.2R.15]`'s "never driven by the live drag position".
5. **Short-screen give-back tuning** — the existing mechanism trades hero height for
   copy-block space one-for-one. At the old `400` that cost a quarter of the hero on a 600
   high viewport; at `240` the same shortfall costs nearly half of it, and the hero may
   read as a sliver. `[W1-6.2R.4]` only requires that it still prevents overflow. Whether
   the give-back should be capped or floored now that the hero is smaller is a visual call.

## Out of scope

- Auditing existing screens against the new `SafeArea` / system UI default. Only the two
  welcome screens are fixed here; the global default is set, and other screens inherit it
  without being reviewed in this run.
- Any change to the hero's fill or background handling, its border radius, or the content
  image's fit and centring. Item 6.1 settled those; this run adds an inset and changes a
  height, nothing else.
- Any change to the three PNG assets, to `pubspec.yaml`, to the token layer, to the
  localisation keys, or to the generated localisation output.
- Any change to routing, the onboarding guard, or the persistence logic. `[W1-6.36]`–
  `[W1-6.39]` are carried forward, not re-derived and not re-implemented.
- Changing the copy block's internal spacing, its element order, or its bottom-anchoring —
  except for removing the double-counted bottom inset, which `[W1-6.2R.7]` requires.
- A light theme. The system UI colour is stated against the one theme the app has; a second
  theme would need the style re-resolved per theme and that is not in this run.
- iOS. Every criterion here is verified on Android only, per `project-conventions.md`.
- Pixel-level fidelity of the padded art inside the shorter hero, and how the swipe feels
  in the hand. Neither can be asserted in a widget test and no golden test is permitted on
  this project, so both are QA's manual visual check against the run's screenshots.

## Assumptions

The full list with its reasoning is in `ambiguities.md`. In brief:

ASSUMPTION: Hero content padding is `24` on all four sides.

ASSUMPTION: Hero heights become `240` and `216`.

ASSUMPTION: `SafeArea` insets all four edges, matching the `games_screen.dart` precedent;
the hero therefore does not bleed under the status bar.

ASSUMPTION: Each page keeps its own progress-dot indicator inside its own copy block.

ASSUMPTION: Status bar and navigation bar icons use the light treatment, and the
navigation bar divider is transparent.

ASSUMPTION: `AnimatedSwitcher` is removed; the existing motion tokens and the
reduced-motion collapse carry over to the paging animation.

ASSUMPTION: The paging viewport holds exactly two pages and clamps at both ends — swiping
past screen 2 does nothing and must never finish onboarding.

ASSUMPTION: The new convention is recorded in `project-conventions.md` rather than
`flutter-arch.md`.

## Constraints

- The `[W1-6.31]` reversal is confirmed by the product owner and is limited to the
  navigation gesture. An agent that escalates the swipe as a spec violation has misread
  this document.
- The onboarding-seen flag rules are frozen. No criterion in this run may be implemented in
  a way that adds a write path, and no test asserting them may be relaxed.
- No golden tests, whatever a criterion says about appearance.
- No new package, no `pubspec.yaml` change, no new token, no new localisation key.
- The prior run's `tech-ac.md` is not on disk (see `ambiguities.md`). Carried-forward IDs
  are cited by subject, sourced from item 6.1's `tech-ac.md` and the current code, not from
  the lost file.
- Android portrait only, unchanged.

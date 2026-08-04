# Ambiguities Report
Source: Ticket `W1-6.2R` — "Welcome screens polish + global system UI convention (item 6.2)"
(`.agents/runs/welcome-screens-polish-20260804/source-request.md`)
Date: 2026-08-04

## CRITICAL (pipeline blocked — requires human decision before proceeding)

NONE

Every open value in this ticket is a visual judgement the ticket itself routes to the
human design gate, not a business decision. Each is resolved below with a provisional
value and surfaced again in `tech-ac.md ## Design-gate items` so the gate reviewer sees
it explicitly rather than having to find it in a diff.

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: Hero content padding is `24` on all four sides. The ticket delegates the
number ("not pinned to an exact number, use judgement"). `24` is on the 8px scale
(`system-foundation-specs.md § 1.3`) and is the same value as the app frame's horizontal
gutter, so the content art's left and right edges line up with the headline and body
below it rather than sitting at an unrelated inset. Uniform on all sides because the
ticket asks for "breathing room on every side" and names no per-axis difference.

ASSUMPTION: Hero heights become `240` (screen 1) and `216` (screen 2). Both are on the
8px scale, both read as roughly a third of the 714 reference (33.6% and 30.3%), screen 1
stays taller than screen 2, and the ratio between them (0.90) is within a rounding step
of today's 400/356 (0.89).

ASSUMPTION: `SafeArea` wraps the whole screen body on all four edges, matching the
existing precedent in `games_screen.dart`. The consequence is that the hero panel no
longer sits at the physical top edge — a band of canvas shows between the status bar and
the hero's top. The alternative reading of requirement 3 (hero bleeding up under a
transparent status bar, i.e. `SafeArea(top: false)`) is a visible design difference, so
it goes to the design gate rather than being decided here.

ASSUMPTION: Each of the two pages keeps its own progress-dot indicator inside its own
copy block, exactly where the design spec § 4 puts it. That makes each indicator static
by construction — it is driven by a fixed step value per page, never by a controller
position. The consequence is that mid-drag both indicators are briefly on screen,
sliding with their pages. The alternative (one shared indicator hoisted above the paging
viewport, held still while the rest slides) is a layout change to the bottom-anchored
copy block, so it goes to the design gate.

ASSUMPTION: The status bar's icons and the system navigation bar's icons are set to the
light/white treatment appropriate to the app's dark canvas. The ticket specifies the
colours but not icon brightness, and the app has one theme (dark) so there is one correct
answer.

ASSUMPTION: The system navigation bar divider is transparent. The ticket asks for the nav
bar area to read as the screen's own canvas; a contrasting hairline above it would defeat
that, and no divider is specified.

ASSUMPTION: `AnimatedSwitcher` is removed from the welcome flow. It and a `PageView`
cannot both own the transition between the same two screens, and the ticket makes the
swipe the navigation mechanism. Item 6's motion tokens (`screenTransition` 420ms,
`screenTransitionCurve`) carry over to the button-driven page animation, and the
reduced-motion collapse carries over as an instant page jump.

ASSUMPTION: The paging viewport holds exactly two pages and clamps at both ends. Swiping
past screen 2 does nothing — it must not finish onboarding, because that would write the
persistence flag without an explicit Skip or Get started tap, which the ticket forbids.

ASSUMPTION: The new standing convention from requirement 3 is recorded in
`project-conventions.md`. The ticket leaves the file choice open; `flutter-arch.md` covers
layering, DI, routing and codegen, while `project-conventions.md` is where app-wide UI
patterns already live.

## Notes for the Product Owner (not blocking)

- The prior run's `tech-ac.md` (`.agents/runs/welcome-screens-20260802/`) is **not on
  disk** — that folder was lost in the 2026-08-04 incident recorded in
  `orchestrator-state.md ## Notes`. `[W1-6.12]`, `[W1-6.31]` and `[W1-6.36]`–`[W1-6.39]`
  are therefore carried forward and superseded by reference to their subjects as summarised
  in the ticket and in item 6.1's `tech-ac.md`, which quotes them. Nothing in this run
  depends on text only that lost file held, but a future run that needs the original
  wording will not find it.
- On Android 15 and above the platform ignores `statusBarColor` and
  `systemNavigationBarColor`; the app is drawn edge to edge and whatever the app paints
  shows through instead. Requirement 3's intended result still holds there, because the
  app's own scaffold background is already the canvas colour — but it holds by painting,
  not by the API call. `tech-ac.md` states the criterion as the visible outcome for that
  reason.

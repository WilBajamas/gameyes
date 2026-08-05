# Human decisions — run route-guard-session-20260805

Given by the Product Owner on 2026-08-05, at the Phase 1 gate, in answer to
`ambiguities.md` CRITICAL-1 and ASSUMPTION 7. **These are settled. Do not
re-litigate them, do not re-escalate them, and treat them as part of the
source request.**

## DECISION-1 — Guard scope: option B, *plus* deep-link resume

Answers CRITICAL-1.

- The auth guard protects `/` (the tab shell and its five children) **and** the
  four root-level content routes: `/game-detail`, `/tracker-detail`,
  `/task-detail`, `/image-view`.
- `/onboarding`, `/auth` and `/legal` are explicitly **unguarded**. `/legal`
  in particular must stay reachable while signed out — the sign-in screen's
  terms and privacy links open it, and gating it would make sign-in unusable.
- **The originally requested route is resumed after a successful sign-in.**
  A signed-out user who follows a deep link to a guarded content route lands on
  the auth screen (or welcome screen 1, if onboarding was never seen), and once
  they sign in they are taken to **the route they originally requested**, not to
  the tab shell root.

  This overrides `ambiguities.md` ASSUMPTION 3, which assumed the pending route
  was discarded in favour of the tab shell root. The Product Owner was shown the
  extra scope this carries and chose it deliberately.

  A signed-in emission with **no** pending requested route still goes to the tab
  shell root — that part of ASSUMPTION 3 stands.

## DECISION-2 — The signed-in direction is in scope for item 8

Confirms ASSUMPTION 7. A signed-in emission from the auth state stream must move
the user off the sign-in screen to their destination (the resumed deep link per
DECISION-1, else the tab shell root). This is item 8's work, not a later item's.

## Assumptions confirmed unchanged

ASSUMPTIONS 1, 2, 4, 5, 6 and 8 in `ambiguities.md` stand as written. ASSUMPTION
3 is superseded only in the respect described under DECISION-1 above.

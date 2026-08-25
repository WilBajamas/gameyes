# Human gate decisions — run async-empty-state-20260824

Both of `ambiguities.md`'s CRITICAL items were put to the human and resolved on
2026-08-24. These are settled: treat them as requirements, not open questions,
and do not re-raise them.

**Site numbering.** "Sites 1–5" here and in `requirements.md` FR-2.8.3 are the
five in-scope sites, where **site 5 is `featured_screen`'s silent section**.
`orchestrator-state.md`'s Phase 0 recon table numbers all *seven* sites found,
where 5 and 6 are the out-of-scope tracker ones and 7 is `featured_screen`. The
files named in each table are the unambiguous reference — go by those, not the
numbers.

## CRITICAL-1 resolved — card fill is `surfaceRaised` (#2f333c)

Option B. The empty-state card uses the **existing raised card surface**. No new
token is minted, no foundations file is touched, and the card matches every other
card in the app.

Follow-up to record (not this run's to fix): `system-foundation-specs.md` §2.2's
claim that "art-deep is the empty-state card fill" is **unimplemented app-side**,
because no art surface has a value and §2 rule 4 keeps violet out of the UI until
ratified. This joins the 15px token as a known foundations gap.

## CRITICAL-2 resolved — one action per site, destinations named

Option A. §3.2's "one action" is honoured at all five sites; the component's
action is **required**, not optional.

| Site | Action |
|---|---|
| 1 `games_screen` | unchanged — re-dispatches `GamesFetched` (see CRITICAL-3 below) |
| 2 `library_stats` now-playing | unchanged — `onMarkNowPlaying` |
| 3 `critics_grid` | clears the genre selection; its empty is filter-caused and `onGenreToggled` already exists |
| 4 `countdown_releases` | goes to Browse |
| 5 `featured_screen` countdown section | goes to Browse |

**Sites 4 and 5 are a tab switch, not a push.** Browse is a tab inside the home
tabs router (`lib/config/route/auto_route_config.dart:28` — note `route/`, singular, not
`router/`; index 3 of featured/games/tracker/browse/settings), so `context.router.push(BrowseRoute())` would stack a Browse
screen *over* the Featured tab and leave the tab bar's active cap on Featured.
The shipped pattern in this exact file is
`AutoTabsRouter.of(context).setActiveIndex(n)` — `featured_screen.dart:143-146`
and `library_stats.dart:375` both use it. Follow it.

## CRITICAL-3 (raised by BA as related) resolved — site 1 keeps its retry

The human ruled that a retry affordance on a no-results state does **not** read as
apologising here. Site 1 keeps the `GamesFetched` re-dispatch it runs today;
only its presentation and copy change. This confirms `ambiguities.md`'s
ASSUMPTION-4 rather than overriding it.

## Assumptions confirmed by silence

The human was shown the three decisions above and did not disturb the ten
assumptions in `ambiguities.md`. They stand as written — including the 22/1.2 caps
display headline and the 16 supporting line, both even, so this run does **not**
repeat the 15px collision of items 1.9, 2.2 and 2.5.

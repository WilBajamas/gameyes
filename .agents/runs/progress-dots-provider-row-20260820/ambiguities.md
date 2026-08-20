# Ambiguities Report
Source: Week 2 task briefs items 1.8, 1.9 (combined run) · `system-foundation-specs.md` §3.3
("Progress dots", "Provider / list row") · `onboarding-auth-design-spec.md` §5 · `flutter-arch.md`
promotion rule · `flutter-widgets` skill build rules
Date: 2026-08-20

## CRITICAL (pipeline blocked — requires human decision before proceeding)
NONE

Five candidates were examined; all resolve from the requirement text, the specs, or an in-repo
precedent. The three worth reading:

1. **The sign-in row does not match §3.3 on its label, contrary to the checklist's claim.** Item 1.9
   says `_ProviderActionButton` "matches spec exactly … centred 15px/500 label". It does not: it
   renders `tokens.typography.body` — Inter **16px, weight 400** — while both §3.3 and
   `onboarding-auth-design-spec.md` §5 specify **15px/500** in full ink. Everything else the item
   lists (52px, `sm` radius, 20px mark slot, 44px hit floor) does match. Resolved as *preserve what
   ships*: the promotion moves the row unchanged and the gap is recorded, because the brief
   explicitly frames the item as extraction "rather than having its own behaviour rewritten", and
   correcting it is a visible change to a live screen. Two reasons not to just fix it silently: the
   even-dimension convention makes 15px an odd font size in new code, and this project has twice
   reversed an agent that applied a spec value to a shipped screen without asking (1.3's crop, 1.4's
   dashed border). **If the human wants the label corrected to 15px/500 now, say so at this gate** —
   it is a one-line change plus a type-token decision, and `tech-ac.md` [1.9-AC5] and its "Out of
   scope" entry are the only places affected.

2. **The progress dots' 5px dimensions vs. "dimensions are even numbers".** §3.3 states `22×5` active
   and `5×5` inactive literally, the welcome screens already ship exactly that, and
   `welcome_screen_test.dart` asserts dot widths of 22 and 5. The standing even-dimension convention
   (established in the 1.5/1.6/1.7 run, *after* these dots were written) would round 5 to 4 or 6 in
   new code. Resolved as keep 5, recorded in `tech-ac.md` [1.8-AC4] as an explicit exception, on the
   convention's own carve-out ("odd values in already-shipped widgets are a follow-up to raise, not
   something to rewrite inside an unrelated run") — the file is new, the pixels are not. Recorded so
   QA does not read it as a skill-level violation and so Dev does not "helpfully" round it.

3. **How generic the promoted APIs should be.** `flutter-arch.md` allows promotion without a second
   caller but forbids speculative parameters, and §3.3 names the row primitive "Provider / **list**
   row" while only provider rows exist. Sized here: the dots take a count and an active index (the
   narrowest form covering the one caller); the row keeps exactly the parameters its two live callers
   exercise — label, mark, fill, enabled, busy + its accessible label, callback — and gains nothing
   for list rows, trailing chevrons or an absent mark. Both items rewire in-run and touch one screen
   each, so the blast radius the checklist's "Open decisions" section delegates to this phase is
   small in both cases.

## FINDING (not an ambiguity — reported for the human)

`lib/features/settings/presentation/widgets/sign_out_section.dart`'s `_SignOutButton` is a third
hand-rolled copy of the same row anatomy — same 52px height, same `sm` radius, same `surfaceRaised`
fill, same press-scale wrapper, same 16px busy indicator with a 10px gap — differing only in having
no leading mark. After 1.9 lands it becomes a duplicate of an app-wide widget. Item 1.9 names only
the auth screen, so this run leaves it alone, but it is the natural second caller and the only real
argument for an optional mark slot. Flagged so Tech Lead can decide whether to fold it in or schedule
it; the BA position is a follow-up item, since including it also changes [1.9-AC4].

## TESTING MODE (BA reasoning — Tech Lead decides)

Recommendation: `smoke`. Both items are UI-only with no new logic, matching the zone label, status
chip and placeholder slot precedents. The `coverage` trigger for "auth" is worth a second look —
item 1.9 rebuilds the control that starts sign-in — but the promotion adds no auth logic and the
existing `auth_screen_test.dart` already covers the screen-level behaviour that matters (spinner on
the active provider only, both rows locked while in flight, inline error and retry). The state matrix
that must be exercised either way is listed in `tech-ac.md` [ALL-AC8]; the matrix matters more than
the label. Test authorship sits with Dev this run — the 1.5/1.6/1.7 hand-off to the human was
recorded as a one-off, not a standing rule.

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: A promotion preserves what renders. Where shipped code and a spec value disagree, this
run keeps the shipped value and reports the gap. One rule resolves both known collisions (the row's
label type, the dots' odd dimensions) and matches the brief's framing of both items.

ASSUMPTION: The dots keep 22×5 / 5×5 / 6px gap as a recorded exception to the even-dimension
convention, per candidate 2 above.

ASSUMPTION: The dots' API is a count plus an active index — the narrowest generic form that covers
the single live caller. `WelcomeStep` stays in the onboarding feature and never appears in
`lib/widgets/`.

ASSUMPTION: The dots are display-only and unanimated, matching today. Neither §3.3 nor the welcome
design spec mentions interaction or a transition between steps.

ASSUMPTION: An invalid dot count or out-of-range active index fails loudly in debug rather than
rendering an undefined row, following the precedent set for `StatPill`'s 2–3 pair limit. The
mechanism is Tech Lead's.

ASSUMPTION: The row's fill stays a required caller-supplied colour — the two live rows need indigo
primary and `surfaceRaised` (the token for §3.3's `#2f333c`). Whether it also carries a default is
Tech Lead's.

ASSUMPTION: The row's leading mark stays required and its busy/enabled inputs stay in the promoted
API. All three are exercised by current callers, so none is speculative; an iconless variant has no
caller unless `_SignOutButton` is folded in.

ASSUMPTION: The label's colour becomes explicit at the `ink` token during the move. It resolves to
the same colour today via the theme's default text style, so this is robustness for an app-wide
widget, not a restyle.

ASSUMPTION: Both components are named categorically, without a `default` prefix, and neither name may
force an import alias at a call site. Exact names are Tech Lead's.

ASSUMPTION: Both call sites migrate in this run and the old private class and its `part` file are
deleted, so no `@Deprecated` alias is retained.

ASSUMPTION: The existing welcome and auth screen tests keep passing; the welcome test's dot-counting
helper may be retargeted at the new widget if the dots stop being plain `Container`s, provided its
assertions stay equivalent. No other test is touched.

ASSUMPTION: No new localisation key, no new dependency, no new design token required for the criteria
as written; `pubspec.yaml` is read-only.

# Ambiguities Report
Source: `.agents/week-3-task-briefs.md` — Stage 3, item 3.1 (with preamble "How to use this", "What week 3 does NOT touch", "Baselines"); rulings 2, 3 and 5 in `.agents/handover.md` "Stage 3 brief"
Date: 2026-08-26 (re-issued after the Phase 1 escalation was answered)

## CRITICAL (pipeline blocked — requires human decision before proceeding)

NONE — all three are resolved below. `tech-ac.md` is written.

## RESOLVED (were CRITICAL — answered by the human, 2026-08-26)

The four answers are recorded in `orchestrator-state.md`, "## Human decisions —
2026-08-26, Phase 1 escalation". They are decisions, not proposals.

RESOLVED-1 (was CRITICAL-1): no hex existed anywhere for `surfaceArt` /
`surfaceArtDeep`, and none could be derived.
  **Answered by D2 — reuse existing tokens, mint no new brand colour.**
  `surfaceArt` = `#2F3782` (`surfaceIndigoPanel`), `surfaceArtDeep` = `#7D4EE0`
  (`statusViolet`). This was option B; D1 is what makes it coherent.
  Carried into `tech-ac.md` as 3.1-AC1, 3.1-AC2, 3.1-AC6.

RESOLVED-2 (was CRITICAL-2): a violet `surfaceArtDeep` contradicted
`system-foundation-specs.md` §2 rule 4 ("not a UI colour until ratified") and §7.1
("never a surface").
  **Answered by D1 — violet IS ratified as a surface. §2.2 wins.** Both statements
  are amended in this same edit with the carve-out recorded, and the new surface is
  excluded from the `app_tokens_test.dart:97-111` violet assertion **with a
  documented reason**, that assertion staying meaningful for every other token.
  Carried into `tech-ac.md` as 3.1-AC7, 3.1-AC11, 3.1-AC12.

RESOLVED-3 (was CRITICAL-3): flat fill or gradient — the token's shape depended on
the answer.
  **Answered by D3 — FLAT FILL.** Recorded explicitly as *not* the BA's
  recommendation (this report preferred two stops) and not the orchestrator's. The
  human chose flat with the trade-off stated: §11's recruit card loses the gradient
  it was designed around, and `library-design-conventions.md` §11 is corrected to
  say fill. Side effect accepted: the two tokens are no longer a pair — `surfaceArt`
  serves §5's cover placeholder only, `surfaceArtDeep` serves §11's card only. Item
  4.5 must not reintroduce a ramp.
  Carried into `tech-ac.md` as 3.1-AC3, 3.1-AC10, 3.1-AC18.

RESOLVED-4 (was the RESIDUALS item): the rejected `saturate(.5) contrast(1.05)`
survived in further places this item did not name.
  **Answered by D4 — widen the doc allowlist to all 7 occurrences**, the veil
  surviving in every case and only the desaturation going. The verified list is
  `system-foundation-specs.md:236` and `:255`, `library-design-conventions.md:65`,
  `home-screen-design-conventions.md:51` and `:123` (the app-wide declaration, and
  the root of the recurrence), `game-detail-design-conventions.md:36`, and
  `onboarding-welcome-design-spec.md:85`. The stand-in-photography production notes
  are left alone.
  Correction to this report's earlier count: it listed **four** further sites and
  named `home-screen-design-conventions.md:83`. D4's list of seven is right and this
  report's was wrong — `:83` is a *back-reference* ("the same saturate/veil
  treatment"), not a literal occurrence, and `:51` is a literal occurrence this
  report missed. `:83` is now carried as an assumption below.
  Carried into `tech-ac.md` as 3.1-AC14, 3.1-AC15, 3.1-AC19 through 3.1-AC22.

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: The item's file reference `test/widget/components/app_tokens_test.dart`
does not exist. The file is `test/widget/theme/app_tokens_test.dart`. The violet
assertion is at `:97-111` (matches the item's "~97-110"). The cited `:496-500` is
**not** the distinctness `Set` — it is inside the `_allColors()` helper (`:493+`)
that feeds the lerp coverage test, and `surfaceToast` is *inside* that list at
`:500`. The distinctness `Set` that `surfaceToast` is kept outside of is at
`:44-49`. Both sites are in play for different reasons: the two new tokens join
`_allColors()` so lerp coverage holds (3.1-AC8), and the `:44-49` Set is a separate
deliberate call (3.1-AC9). Confirmed independently by the orchestrator.

ASSUMPTION: `system-foundation-specs.md` "§5" in the item text and in §2 rule 7
means **§6 Local additions register** (header line 308, the art-surfaces row line
320) — §5 is Accessibility. The doc carries the same stale cross-reference
internally, which is where the item text picked it up. 3.1-AC13 fills the row and
fixes the pointer.

ASSUMPTION: The stale desaturation text in §3.2 is the Game card row's "Covers
desaturated 50% + indigo→canvas scrim" (line 236) — the only occurrence inside
§3.2's bounds (230-248). The `indigo→canvas scrim` half survives: ruling 2 rejects
the desaturation filter, not the veil. Same for `library-design-conventions.md` §5,
where "plus an indigo→canvas veil" stays and `saturate(.5) contrast(1.05)` goes —
which also keeps §6's "the same veil" back-reference meaningful. D4 now states this
principle for all seven sites.

ASSUMPTION: `home-screen-design-conventions.md:83` ("the same saturate/veil
treatment") is an eighth site that D4's seven-item list does not name, because it
refers to the filter by word without the literal string and so survives a
literal-string sweep. Assuming D4's stated principle applies unchanged — the veil
survives, the saturate reference goes (3.1-AC20). This is not a new decision; a
back-reference to a treatment that no longer exists is a dangling pointer either
way.

ASSUMPTION: `onboarding-welcome-design-spec.md:67` (`saturate(.4) contrast(1.05)` on
the screen-2 key art) is **not** in D4's list and is not touched — a different value
on a different asset, not the rejected cover filter.

ASSUMPTION: Ruling 5's §3 correction records Playing's dot as `accentIndigo`
`#5865f2` and also carries the already-shipped carve-out rather than a bare colour
name, because §3's active filter chip is itself `#5865f2` and an indigo dot on an
indigo fill is invisible — `status_chip.dart:54-58` already resolves exactly this
("The filled pill already carries the status hue, so its dot reverts to ink").
Without the qualifier, item 4.3 inherits an invisible dot from the freshly corrected
doc, which is the failure mode this item exists to stop. This documents shipped
behaviour; it does not reopen ruling 5. Verified in source; carried as 3.1-AC16.

ASSUMPTION: §12's colour ration currently reads "Indigo `#5865f2` — active status
chip, active tab. Nothing else." The widening covers every place the corrected §3
puts indigo: the Playing status dot on the filter chip, the grid cover's status pill
(§5) and the list row's status line (§6). Carried as 3.1-AC17.

ASSUMPTION: "record the carve-out the way ruling 5 does for §12" (D1) means the
amended §2 rule 4 and §7.1 state the exception and its reason in the doc, dated,
rather than deleting the old sentence. No particular wording is mandated.

ASSUMPTION: Exact replacement copy for every doc edit is unspecified. Assuming the
smallest edit that removes the incorrect clause and preserves the surrounding
sentence's meaning, in each doc's existing table/prose style.

ASSUMPTION: The two new tokens sit in `AppColorTokens`'s existing `// ** Surfaces`
group rather than a new group, since D1 ratifies `surfaceArtDeep` as a surface.

## RESIDUALS (out of scope for this item — flagged, not actioned)

- `library-design-conventions.md` §13.5 ("status chip colours still flagged") is
  stale per Phase 0 — violet and cyan already exist and are wired through
  `AppStatusTokens`. The item names §3, §5, §11 and §12 only.
- `system-foundation-specs.md` §6 register line 327 still lists `#7d4ee0` /
  `#00b0f4` **as status dots** as an open decision. D1 ratifies violet as a
  *surface*, not as a status hue, so that row correctly stands — noted so a Dev does
  not over-edit it while amending §7.1 two sections above.
- `glass42` is missing from `_allColors()` in `app_tokens_test.dart` (the helper
  lists glass30/32/34 and stops), so it carries no lerp coverage. Pre-existing and
  unrelated; not this item's to fix, but the next run touching that helper should.
- `.agents/manual-check-backlog.md:191-192` describes the 50% desaturation clause as
  a spec requirement shipping deliberately unmet. Once the specs are corrected that
  framing is stale, but the entry records the `1.3-AC7` check and is not a spec.

## SCOPE NOTE

Nothing is blocked. All four answers landed, the escalation is cleared, and
`tech-ac.md` covers the token half and the doc half in one pass. The item changes
`app_color_tokens.dart`, `app_tokens_test.dart` and five reference docs — no screen,
no widget, no runtime behaviour.

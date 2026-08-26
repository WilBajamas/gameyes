# Technical Acceptance Criteria
Source: `.agents/week-3-task-briefs.md` — Stage 3, item 3.1; `.agents/handover.md` "Stage 3 brief" rulings 2, 3 and 5; human decisions D1–D4 in `orchestrator-state.md` ("Human decisions — 2026-08-26, Phase 1 escalation")
Date: 2026-08-26
BA Agent version: 1.0

## Feature summary

Add two flat colour tokens, `surfaceArt` and `surfaceArtDeep`, to `AppColorTokens`
and close the design-doc loops that keep re-seeding rejected criteria. Both tokens
reuse existing project hexes rather than minting brand colour (D2): `surfaceArt` is
`#2F3782`, `surfaceArtDeep` is `#7D4EE0`. `surfaceArtDeep` is violet, which is
ratified as a surface by D1 — so two standing colour-law statements and one token
test assertion are amended in the same change, each with the reason written down
rather than silently deleted. `surfaceArtDeep` is a single flat `Color`, not a
gradient (D3), which also corrects the Library spec's recruit card. Seven doc sites
carrying the three-times-rejected `saturate(.5) contrast(1.05)` cover filter are
corrected, plus one back-reference to it; the indigo→canvas veil survives at every
one. Token file, token test and five reference docs only — no screen, no widget, no
runtime behaviour change.

## Technical acceptance criteria

### Colour tokens

[3.1-AC1] THEME TOKENS: `AppColorTokens` exposes a `surfaceArt` field of type
`Color`, grouped with the existing surface fields, resolving to `Color(0xFF2F3782)`
in `AppColorTokens.dark` — the same value as `surfaceIndigoPanel`.
  Failure case: no value, or any value other than `#2F3782`, contradicts D2 and
  re-opens the hex gap that item 2.8 already papered over with `surfaceRaised`.

[3.1-AC2] THEME TOKENS: `AppColorTokens` exposes a `surfaceArtDeep` field of type
`Color`, grouped with the existing surface fields, resolving to `Color(0xFF7D4EE0)`
in `AppColorTokens.dark` — the same value as `statusViolet`.
  Failure case: a darkened or otherwise derived violet is a new brand colour, which
  D2 rules out.

[3.1-AC3] THEME TOKENS: `surfaceArtDeep` is a single `Color`. No `Gradient`,
`List<Color>`, stop list or gradient-shaped type is introduced on `AppColorTokens`;
every field on the class remains a `Color` or an existing token group.
  Failure case: a gradient-shaped member breaks the class's uniformity, contradicts
  D3 and violates `system-foundation-specs.md` §2 rule 6 ("no hard gradients").

[3.1-AC4] THEME TOKENS: both new fields are required constructor parameters and are
carried through `copyWith` and `lerp` exactly as every existing colour field is.
  Failure case: a field omitted from `lerp` silently drops to the `a`-side value on
  every theme transition; one omitted from `copyWith` cannot be overridden in tests.

[3.1-AC5] THEME TOKENS: no existing token's value, name or grouping changes.
`statusViolet`, `surfaceIndigoPanel` and every member of `AppStatusTokens` —
including `playing` — are untouched.
  Failure case: any existing hex change is out of this item's scope and breaks the
  assertions already covering it.

### Token tests

[3.1-AC6] TOKEN TEST: `test/widget/theme/app_tokens_test.dart` asserts
`colors.surfaceArt` is `Color(0xFF2F3782)` and `colors.surfaceArtDeep` is
`Color(0xFF7D4EE0)`.
  Failure case: without a pinned assertion a later edit can fork either token from
  the hex D2 fixed, with nothing catching it.

[3.1-AC7] TOKEN TEST: the violet-exclusion test at `:97-111` still asserts that
`statusViolet` appears in none of the surface and accent tokens it lists, with
`surfaceArtDeep` excluded from that list and the exclusion carrying a written reason
naming D1's ratification. `surfaceArt` is subject to no exclusion.
  Failure case: adding `surfaceArtDeep` to the list fails the test; deleting or
  weakening the whole assertion instead removes the guard for every other token,
  which D1 explicitly requires to stay meaningful.

[3.1-AC8] TOKEN TEST: both new tokens are present in the `_allColors()` helper at
`:493+`, so the lerp-coverage assertion at `:460-462` iterates them.
  Failure case: a token missing from `_allColors()` is excluded from lerp coverage
  and from the `#1e2353` scan, so a broken `lerp` entry for it goes undetected.

[3.1-AC9] TOKEN TEST: the raised-surface distinctness `Set` at `:44-49` keeps
exactly its three current members and its `expect(distinct.length, 3)`. Neither new
token is added, and the test carries a written reason that `surfaceArt` is a
deliberate alias of `surfaceIndigoPanel` rather than a fourth distinct surface —
the same shape as 2.7's `surfaceToast`.
  Failure case: adding an alias to the `Set` collapses it to three unique values
  from four members, so the assertion still passes while no longer asserting
  distinctness — a silently dead test.

### `system-foundation-specs.md`

[3.1-AC10] DESIGN DOC: §2.2 Art surfaces records the resolved values —
`--surface-art` `#2f3782` and `--surface-art-deep` `#7d4ee0` — states both are flat
fills, and states their roles separately: `--surface-art` stands in behind cover
imagery (the Library spec §5 placeholder), `--surface-art-deep` is the empty-state
card fill (the Library spec §11 recruit card). The prose must not describe the two
as a pair or a ramp.
  Failure case: leaving §2.2 at "indigo and violet fills" leaves the next BA with
  the same no-hex gap; describing them as a pair re-seeds the gradient reading that
  D3 closed and that item 4.5 is built on.

[3.1-AC11] DESIGN DOC: §2 rule 4 no longer states that violet `#7d4ee0` "is not a UI
colour until ratified". It records that violet is ratified as a surface in exactly
one place, `--surface-art-deep`, dated to this decision, while the rule's actual
subject — no fourth loud *accent* — still stands.
  Failure case: the unamended rule directly contradicts §2.2 and blocks a Tech Lead
  or QA from accepting the token that D1 ratified.

[3.1-AC12] DESIGN DOC: §7.1 no longer states that violet is "never a surface"; it
records the `--surface-art-deep` carve-out in the same explicit shape ruling 5 uses
for §12. §7.1's separate open status-hue decision (violet and cyan as status dots,
options `1a`/`1b`/`1c`) is left as it stands.
  Failure case: an unamended §7.1 is the second contradiction of the ratified token;
  over-editing it instead closes an open decision nobody made.

[3.1-AC13] DESIGN DOC: the §6 Local additions register row for
`--surface-art` / `--surface-art-deep` (line 320) carries both values, and §2 rule
7's cross-reference to the register points at §6, not §5.
  Failure case: that row is currently the only register row with no value — left
  blank it keeps reading as an unfilled gap; the stale "§5" points at Accessibility
  and is the source of the same misreference in the item text itself.

[3.1-AC14] DESIGN DOC: the §3.2 Game card row (line 236) no longer states covers are
desaturated 50%, and its indigo→canvas scrim survives. The §3.3 Cover tile row (line
255) no longer carries `saturate(.5) contrast(1.05)`, and its flat indigo wash
survives.
  Failure case: §3.2 alone has already produced a rejected criterion twice; fixing
  §3.2 without §3.3 leaves the identical filter one section below it.

### `library-design-conventions.md`

[3.1-AC15] DESIGN DOC: §5 (line 65) no longer carries `saturate(.5) contrast(1.05)`.
The indigo→canvas veil, the `--surface-art` cover fill and §6's "the same veil"
back-reference all remain valid.
  Failure case: `1.3-AC7` is a live check that the filter stays absent from the
  build; leaving it in the spec re-seeds it for a fourth time.

[3.1-AC16] DESIGN DOC: §3 (line 41) records Playing's status dot as `accentIndigo`
`#5865f2` rather than white, and carries the shipped carve-out that on the filled
Playing pill the dot reverts to ink because the pill already carries the hue.
  Failure case: a bare "Playing indigo" hands item 4.3 an indigo dot on the indigo
  active-chip fill — invisible, and exactly the doc-inherited defect this item
  exists to stop.

[3.1-AC17] DESIGN DOC: §12's colour ration (line 154) no longer reads "active status
chip, active tab. Nothing else." It admits every place corrected §3 puts indigo: the
Playing status dot, the grid cover's status pill (§5) and the list row's status line
(§6).
  Failure case: ruling 5 requires this edit in the same change; without it §12 and
  §3 contradict each other and the next reader picks whichever they hit first.

[3.1-AC18] DESIGN DOC: §11 (line 143) specifies the recruit card as a
`--surface-art-deep` **fill**, not a gradient, and the card's stated reason for
carrying no decorative oversized circle no longer credits a gradient.
  Failure case: D3 chose flat with the trade-off accepted; leaving "gradient" in §11
  lets item 4.5 reintroduce the ramp D3 removed.

### The remaining rejected-filter sites (D4)

[3.1-AC19] DESIGN DOC: `home-screen-design-conventions.md` no longer carries
`saturate(.5) contrast(1.05)` at line 51 or line 123, and line 123 no longer
declares that filter app-wide. The indigo→canvas gradient veil survives at both,
including line 51's exact stops and its 2026-07-30 recomputation note, and line 123
still declares the veil itself app-wide.
  Failure case: line 123 is the root of the recurrence — it is the sentence that
  makes the filter sound like system law, so correcting any other site while leaving
  it standing fixes nothing.

[3.1-AC20] DESIGN DOC: `home-screen-design-conventions.md` line 83's back-reference
no longer names a saturate treatment; it refers to the veil only.
  Failure case: a back-reference to a filter that no longer exists anywhere is both
  a dangling pointer and a way for the filter to survive a literal-string sweep.

[3.1-AC21] DESIGN DOC: `game-detail-design-conventions.md` line 36 and
`onboarding-welcome-design-spec.md` line 85 no longer carry
`saturate(.5) contrast(1.05)`. Game Detail keeps its "app-wide cover treatment"
reference and Onboarding keeps its top-to-bottom indigo→canvas tint.
  Failure case: Game Detail is a rebuild in a later week and Onboarding is already
  shipped — either doc left uncorrected re-seeds the filter into a run this item
  cannot reach.

### Cross-cutting

[3.1-AC22] DESIGN DOC: after the edits, a search for `saturate(.5) contrast(1.05)`
across `.agents/references/` returns zero results, and a search for `desaturat`
across `.agents/references/` returns only the stand-in-photography production notes
(`library-design-conventions.md:179`, `home-screen-design-conventions.md:154`,
`game-detail-design-conventions.md:162`) and `game-detail-design-conventions.md:41`,
which describes a rejected hero-ramp option rather than a cover treatment.
  Failure case: any other surviving hit means a site was missed and the loop is
  still open.

[3.1-AC23] REPO: no file under `lib/` other than
`lib/config/theme/tokens/app_color_tokens.dart` is modified, and no test other than
`test/widget/theme/app_tokens_test.dart` is modified. The analyzer stays at the
recorded baseline (30 issues / 0 errors / 2 warnings / 28 info) and the suite stays
at +361 -10 plus whatever new token assertions add.
  Failure case: 28 total issues means the deliberate `_TaskReminder` pair was
  "fixed"; any screen or widget diff means a criterion leaked out of this item's
  scope into Stage 4's.

## Out of scope

- **Every screen and every widget.** No `LibraryScreen`, no cover placeholder
  widget, no recruit card, no empty state. Nothing consumes `surfaceArt` or
  `surfaceArtDeep` in this item — they are minted unused on purpose.
- **`status_chip.dart`.** [3.1-AC16] writes down behaviour that already ships at
  `status_chip.dart:54-58`. The widget does not change and ruling 5 is not reopened.
- **`AppStatusTokens.playing`.** Ruling 5 settled that the token is right and the
  spec was wrong.
- **Golden tests.** Per `execution.md`, never, whatever a criterion says about
  appearance. The visual read of the two new fills is a manual check.
- **`onboarding-welcome-design-spec.md:67`.** `saturate(.4) contrast(1.05)` on the
  screen-2 key art is a different value on a different asset and is not in D4's list.
- **The stand-in-photography production notes.** D4 leaves them alone — they
  describe mockup assets, not app behaviour.
- **`.agents/manual-check-backlog.md:191-192`**, which records that the 50%
  desaturation clause ships deliberately unmet. It documents the `1.3-AC7` check;
  it is not a spec and is not corrected here.
- **`library-design-conventions.md` §13.5** ("status chip colours still flagged") is
  stale — violet and cyan exist and are wired through `AppStatusTokens` — but the
  item names §3, §5, §11 and §12 only.
- **`system-foundation-specs.md` §6 register line 327** (`#7d4ee0` / `#00b0f4` as
  status *dots*, still an open decision). D1 ratifies violet as a surface, not as a
  status hue; that register row stands.
- **`glass42` is absent from `_allColors()`** (`:517-519` list the .30/.32/.34 steps
  and stop), so it carries no lerp coverage. Pre-existing, unrelated to this item,
  flagged not fixed.
- **`.agents/handover.md`.** Recording this item's outcome there is the
  orchestrator's close-out, not a criterion.
- **Item 4.5's recruit card.** D3 forbids reintroducing a ramp there; that is a
  constraint on a later item, enforced by [3.1-AC18], not buildable here.

## Assumptions

ASSUMPTION: `system-foundation-specs.md` §2 rule 7's "(§5)" means §6 Local additions
register (line 308) — §5 is Accessibility. [3.1-AC13] corrects the cross-reference
because this item is already editing §2 and the same stale pointer is what put "§5"
into the item text.

ASSUMPTION: `home-screen-design-conventions.md:83` ("the same saturate/veil
treatment") is an eighth site — a back-reference that names the filter by word
without the literal string, so it survives D4's seven-site sweep. [3.1-AC20] applies
D4's stated principle (the veil survives, the desaturation goes) rather than
treating it as a new decision.

ASSUMPTION: "record the carve-out the way ruling 5 does for §12" (D1) means the
amended §2 rule 4 and §7.1 state the exception and its reason in the doc, dated,
rather than deleting the old sentence. Assuming no particular wording is mandated.

ASSUMPTION: exact replacement copy for every doc edit is unspecified. Assuming the
smallest edit that removes the incorrect clause and preserves the surrounding
sentence's meaning, matching each doc's existing table/prose style.

ASSUMPTION: the two new tokens sit in `AppColorTokens`'s existing `// ** Surfaces`
group rather than a new group, since D1 ratifies `surfaceArtDeep` as a surface.

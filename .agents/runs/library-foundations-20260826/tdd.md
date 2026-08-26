# Technical Design Document
Source: `tech-ac.md` — Week 3 item 3.1 (`.agents/week-3-task-briefs.md` Stage 3; handover rulings 2, 3, 5; decisions D1–D5 in `orchestrator-state.md`)
Date: 2026-08-26
Revised: 2026-08-26 — D5 at the Phase 3 design gate removes
`test/widget/theme/app_tokens_test.dart` from scope entirely. The `## Token test
design` section is withdrawn, testing mode is corrected, and two design decisions
this document made are recorded as withdrawn rather than deleted. The token values,
the flat-fill shape, violet's ratification and all eight doc corrections stand
unchanged.

## Feature summary

Two `Color` fields are added to the `AppColorTokens` theme extension and carried
through its five sites (constructor, field group, `dark`, `copyWith`, `lerp`).
Nothing consumes them. The rest of the item is prose: five reference docs under
`.agents/references/` are corrected so the colour law matches the ratified token
(D1), the token stays flat (D3), and the three-times-rejected cover filter is
removed from all eight sites (D4 + `3.1-AC20`). No test, no screen, no widget, no
runtime behaviour, no code generation, no new package.

**Scope guard.** Any design decision that would touch a screen or a widget belongs
to a later item, not this one. Three came up while designing and all three are
pushed out below in `## Out of scope` — the recruit card (item 4.5), the cover
placeholder (Library §5 build), and `status_chip.dart` (already ships the
behaviour `3.1-AC16` writes down).

## Layer map

- `3.1-AC1` – `3.1-AC5`: theme tokens (`lib/config/theme/tokens/`) — no other layer.
- `3.1-AC10` – `3.1-AC21`, `3.1-AC12a`: documentation (`.agents/references/`) — no layer.
- `3.1-AC22`, `3.1-AC23`: cross-cutting verification, no edit of its own.
- No test layer. `3.1-AC6` – `3.1-AC9` were retired by D5 and are not designed for.

## Data layer

None. No API, model, DTO, repository, datasource or storage is touched, so no
`api-contracts.md` input is required.

## Domain layer

None.

## State layer

None. `AppColorTokens` is a `ThemeExtension`, not state; adding fields to it
changes no notifier, cubit or bloc.

## UI layer

### Screens
None.

### Widgets
None. This is the item's defining constraint, not an omission — the two tokens are
minted unused on purpose so Stage 4 has a hex to build against.

## Theme-token design

`AppColorTokens` (modify) — `lib/config/theme/tokens/app_color_tokens.dart`

- `surfaceArt` and `surfaceArtDeep`, both `final Color`, declared in the existing
  `// ** Surfaces` group immediately after `surfaceToast`, in that order
  (`3.1-AC1`, `3.1-AC2`, assumption in `tech-ac.md`).
- Both are required constructor parameters and appear in the same relative
  position in all five sites, so a reader diffing the file sees one insertion
  point per site (`3.1-AC4`).
- `dark` resolves `surfaceArt` to `Color(0xFF2F3782)` and `surfaceArtDeep` to
  `Color(0xFF7D4EE0)` as **inline literals**, matching every other member of the
  Surfaces group (`3.1-AC1`, `3.1-AC2`).
- No `Gradient`, `List<Color>` or stop list is introduced anywhere on the class
  (`3.1-AC3`). Both new fields lerp with `Color.lerp(...)!` exactly like their
  neighbours.
- No existing field, value, name, group or ordering changes (`3.1-AC5`). In
  particular `surfaceIndigoPanel`'s literal is **not** refactored into a shared
  private const — see the reuse decision below.
- No comment is added to the token file. The two duplicated hexes are explained in
  `system-foundation-specs.md` §2.2 (`3.1-AC12a`), which is where a reader asking
  "why two identical values?" is sent, and which under D5 is the only place that
  explanation exists at all. This matches `surfaceToast`, which duplicates
  `surfaceTabChrome`'s literal uncommented.

### `3.1-AC4` has no runtime check behind it

Under D5 nothing asserts that the two fields are carried through `copyWith` and
`lerp`. The `_allColors()` lerp iteration that would have covered them is out of
scope, so the suite is green whether or not the entries exist. A field missing from
`lerp` silently drops to the `a`-side value on every theme transition; a field
missing from `copyWith` cannot be overridden.

The design's answer is a **source read carried as its own plan step**
(`task-brief.md` step 2), not a note. Dev reads both bodies back after the edit,
confirms each new field appears in the same form as its neighbours, and records the
confirmation in `diff-summary.md`. QA repeats the read against `tech-ac.md`
`3.1-AC4` and must not accept a green suite as evidence — the suite cannot see this.

### Reuse decisions

- Existing hexes are reused rather than derived, per D2 — `#2F3782` from
  `surfaceIndigoPanel`, `#7D4EE0` from `statusViolet`. No new brand colour.
- **`surfaceArtDeep` is written as a literal, not bound to the existing
  `_statusViolet` private const** (`app_color_tokens.dart:11`), even though the
  value is identical. Binding them would couple a ratified *surface* to an *open
  decision*: `system-foundation-specs.md` §7.1 and register line 327 still hold
  violet-as-a-status-dot open (options `1a`/`1b`/`1c`), so a later edit resolving
  that decision against violet would silently move a surface it never intended to
  touch. Under D5 this matters more, not less: with no test pinning either value,
  a shared const is a change vector with nothing watching it, whereas two
  independent literals can only drift one at a time and are checked against §2.2 by
  source read. The same reasoning applies to `surfaceArt` vs `surfaceIndigoPanel`.
- The alias shape itself is precedented: `surfaceToast` (`#2E3236`) already
  duplicates `surfaceTabChrome` from item 2.7.

## Token test design — WITHDRAWN (D5)

`test/widget/theme/app_tokens_test.dart` is out of this item's scope entirely. No
assertion is added, changed or removed; the file is not opened. The two new tokens
ship with zero test coverage, a trade-off stated and accepted at the Phase 3 gate.

The two design decisions this document previously made about that file are recorded
in `## Withdrawn design decisions` below, so nobody reinstates them from a stale
read of an earlier revision.

## Withdrawn design decisions

Both are **dissolved by D5, not overruled** — the situation each was reasoning
about no longer arises. Neither should be reinstated by a later item without
re-deciding it on its own facts.

1. **The distinctness-`Set` decision (was `3.1-AC9`).** This document argued at
   length that `surfaceArt` must be kept out of the `Set` at `:44-49`, because
   adding a value-identical alias would leave four members collapsing to three
   unique values — `expect(distinct.length, 3)` would still pass while asserting
   nothing, a dead test that looks alive. That reasoning is sound but now moot:
   nothing is added to the `Set`, so the silent-pass trap cannot occur. The `Set`
   keeps its three members and its assertion untouched, as it does today.
   *It becomes live again the moment some later item adds an alias token to that
   `Set` — that is when to re-read this.*
2. **The asymmetric violet-assertion handling (was `3.1-AC7`).** This document
   specified that `surfaceArt` be added to the `surfacesAndAccents` list at
   `:97-111` while `surfaceArtDeep` was excluded with a written reason naming D1.
   With no test edit the assertion's hardcoded list never sees either token, so
   there is nothing to add and nothing to exclude, and the assertion stays exactly
   as meaningful as it is today for every token it does list. D1's requirement that
   the carve-out carry a written reason does not disappear with it — it relocates
   wholly to the §2.2 amendment, which is `3.1-AC12a`.

Also withdrawn with them: the `_allColors()` membership design (was `3.1-AC8`) and
the two shell caveats that only concerned that helper.

## Documentation design

Five files. Every edit follows one principle from D4 — **the indigo→canvas veil
survives, only the desaturation goes** — and one from the BA's assumption set: the
smallest edit that removes the wrong clause and leaves the surrounding sentence
true, in each doc's existing style.

**Locate every edit by its quoted text, never by line number.** The line numbers in
`tech-ac.md` are pre-edit values, and `system-foundation-specs.md` §2.2 grows from
three prose lines to a table plus a paragraph, which shifts every later line in that
file.

`system-foundation-specs.md`
- §2.2 → a two-row table with both values, both stated as flat fills, and the two
  roles stated **separately**; explicit "not a pair, not a ramp" (`3.1-AC10`, D3).
  **Plus a short paragraph stating why violet is admissible as a surface here**
  (`3.1-AC12a`): rule 4 bars violet as a fourth loud *accent* — a hue competing for
  attention on small interactive parts — and `--surface-art-deep` is a single large,
  flat, non-interactive block on one empty state, carrying no status or action
  meaning. That is the reason D1 required to be written down. Under D5 there is no
  test carrying any part of it, so §2.2 is the sole place it exists in the repo, and
  the paragraph is load-bearing rather than decorative. It is also the one paragraph
  to change if the carve-out is ever withdrawn.
- §2 rule 4 → records violet ratified as a surface in exactly one place, dated, and
  keeps the rule's real subject (no fourth loud *accent*). It **points at §2.2 for
  the reason rather than restating it** (`3.1-AC12a`), and states that violet as a
  *status hue* is still §7.1's open decision, so the amendment cannot be read as
  closing it (`3.1-AC11`).
- §7.1 → the "never a surface" clause becomes the same dated carve-out, likewise
  cross-referencing §2.2; the options `1a`/`1b`/`1c` and the rest of §7.1 are
  untouched (`3.1-AC12`).
- §6 register row → carries both hexes; §2 rule 7's "(§5)" → "(§6)" (`3.1-AC13`).
  Register line 327 (violet/cyan as status *dots*) is left standing.
- §3.2 Game card row → the desaturation clause goes, the indigo→canvas scrim
  stays; §3.3 Cover tile row → the filter goes, the flat indigo wash stays
  (`3.1-AC14`).

`library-design-conventions.md`
- §5 → filter removed, veil + `--surface-art` retained so §6's "the same veil"
  back-reference still resolves (`3.1-AC15`).
- §3 → Playing's dot becomes `accentIndigo` `#5865f2` **with** the shipped
  carve-out that on the filled Playing pill the dot reverts to ink, which is what
  `status_chip.dart:56-57` and `:65` already do (`3.1-AC16`). Without the
  qualifier the corrected doc hands item 4.3 an invisible dot.
- §12 → the ration admits the Playing dot (§3), the grid cover's status pill (§5)
  and the list row's status line (§6) (`3.1-AC17`).
- §11 → "gradient" becomes a flat fill, **and the card's stated reason for
  carrying no decorative oversized circle is rewritten** (`3.1-AC18`). This is
  D3's second-order consequence: the sentence justified the omission with "the
  gradient carries the card on its own", so correcting only the token word leaves
  a reason that no longer holds. The replacement reason stands on the flat fill
  itself — on an otherwise empty screen the violet block is already the loud
  element — and states flat-not-gradient as a dated decision so item 4.5 cannot
  reintroduce the ramp.

`home-screen-design-conventions.md`
- Line 51 → filter removed; the veil, its exact stops, the purpose sentence and the
  2026-07-30 recomputation note all survive verbatim (`3.1-AC19`).
- Line 123 → the app-wide declaration keeps declaring the **veil** app-wide and
  stops declaring the filter. This is the root of the recurrence (`3.1-AC19`).
- Line 83 → the eighth site. It names the filter in words ("the same saturate/veil
  treatment"), so a literal-string sweep misses it and it would be left pointing at
  a treatment that no longer exists anywhere. It becomes a reference to the veil
  only (`3.1-AC20`, D4's stated principle applied unchanged — not a new decision).

`game-detail-design-conventions.md` — line 36: filter removed, the "app-wide cover
treatment" reference kept (`3.1-AC21`). Line 41 (a rejected hero-ramp option) and
line 162 (production notes) are untouched.

`onboarding-welcome-design-spec.md` — line 85: filter removed, the top-to-bottom
indigo→canvas tint kept (`3.1-AC21`). **Line 67 is not touched** —
`saturate(.4) contrast(1.05)` is a different value on a different asset and is
outside D4's list.

### Verification sweep (`3.1-AC22`)

Current state, confirmed by grep before any edit: nine hits for
`saturate(|desaturat` across `.agents/references/`. After the edits, the expected
state is `saturate(.5) contrast(1.05)` → zero hits, and `desaturat` → exactly four:
`library-design-conventions.md:179`, `home-screen-design-conventions.md:154`,
`game-detail-design-conventions.md:162` (all three stand-in-photography production
notes) and `game-detail-design-conventions.md:41` (a rejected hero-ramp option).
`onboarding-welcome-design-spec.md:67` keeps its `saturate(.4)` and does not match
the `.5` string.

## Testing mode

`none` — no test file is created or modified (D5).

The change is two unused colour constants plus prose. No widget or screen changes,
so per `flutter-widget-test` nothing qualifies for a dedicated test file.
`AppColorTokens` is an app-wide shared utility, which would ordinarily match the
`coverage` rule; D5 overrides that at the human's decision and accepts zero
coverage for both new tokens. `3.1-AC1` – `3.1-AC5` are verified by source read
(`task-brief.md` steps 1 and 2), and the suite is expected at exactly `+361 -10`,
unchanged (`3.1-AC23`).

The residual risk is stated rather than mitigated: nothing catches a later edit
forking either hex from D2's value. The hexes live in `app_color_tokens.dart` and
in §2.2, and §2.2 is what a future drift would be checked against. The next run
that opens `app_tokens_test.dart` should add both tokens to `_allColors()` at the
same time as the already-flagged missing `glass42`.

## Caveats — I have no shell

I cannot run `flutter analyze`, `flutter test`, or `build_runner`. One claim rests
on reading rather than executing; it has a fallback, and Dev records the outcome as
a self-correction either way.

1. **Adding two required constructor parameters breaks no call site.** Reasoned
   from grep: `AppColorTokens(` appears at four places, all inside
   `app_color_tokens.dart` itself (declaration, `dark`, `copyWith`, `lerp`); no
   test or screen constructs it directly. *Fallback:* if the analyzer reports a
   missing-argument error at a file outside the allowlist, that is a scope breach
   under `3.1-AC23` — escalate, do not edit the file. In particular, if the breach
   is in a test file, escalate; D5 forbids the edit that would fix it.

The two earlier caveats about `_allColors()` — that `expect(color, isNotNull)`
cannot fail, and that duplicate values break neither consumer — are withdrawn with
that helper's design. Neither is reachable from this item any more.

No scratch files were created by this agent.

## Out of scope

- **`test/widget/theme/app_tokens_test.dart` — the whole file (D5).** No test file
  changes at all. Both tokens ship uncovered by decision.
- **Every screen and every widget**, including `LibraryScreen`, the cover
  placeholder, the recruit card and the empty state. The tokens ship unused.
- **`status_chip.dart`** — `3.1-AC16` documents shipped behaviour
  (`status_chip.dart:56-57`, `:65`); the widget does not change and ruling 5 is
  not reopened.
- **`AppStatusTokens`**, including `playing`. Settled by ruling 5.
- **Item 4.5's recruit card build.** D3 constrains it; `3.1-AC18` records the
  constraint in the spec. Nothing is buildable here.
- **Golden tests** — never, per `execution.md`. The visual read of the two fills is
  a manual check.
- **`onboarding-welcome-design-spec.md:67`** (`saturate(.4)`), the
  stand-in-photography production notes, `library-design-conventions.md` §13.5,
  `system-foundation-specs.md` §6 register line 327, and
  `.agents/manual-check-backlog.md:191-192` — all explicitly left standing.
- **Strengthening the `_allColors()` lerp loop and adding the missing `glass42`** —
  pre-existing, flagged not fixed, and unreachable from this item under D5.
- **`.agents/handover.md`** — the orchestrator's close-out, not a criterion.

## Open questions

NONE.

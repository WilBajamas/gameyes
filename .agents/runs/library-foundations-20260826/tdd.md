# Technical Design Document
Source: `tech-ac.md` — Week 3 item 3.1 (`.agents/week-3-task-briefs.md` Stage 3; handover rulings 2, 3, 5; decisions D1–D4 in `orchestrator-state.md`)
Date: 2026-08-26

## Feature summary

Two `Color` fields are added to the `AppColorTokens` theme extension and carried
through its five sites (constructor, field group, `dark`, `copyWith`, `lerp`).
Nothing consumes them. The rest of the item is prose: five reference docs under
`.agents/references/` are corrected so the colour law matches the ratified token
(D1), the token stays flat (D3), and the three-times-rejected cover filter is
removed from all eight sites (D4 + `3.1-AC20`). No screen, no widget, no runtime
behaviour, no code generation, no new package.

**Scope guard.** Any design decision that would touch a screen or a widget belongs
to a later item, not this one. Three came up while designing and all three are
pushed out below in `## Out of scope` — the recruit card (item 4.5), the cover
placeholder (Library §5 build), and `status_chip.dart` (already ships the
behaviour `3.1-AC16` writes down).

## Layer map

- `3.1-AC1` – `3.1-AC5`: theme tokens (`lib/config/theme/tokens/`) — no other layer.
- `3.1-AC6` – `3.1-AC9`: token contract test (`test/widget/theme/`).
- `3.1-AC10` – `3.1-AC21`: documentation (`.agents/references/`) — no layer.
- `3.1-AC22`, `3.1-AC23`: cross-cutting verification, no edit of its own.

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
  the token test (`3.1-AC7`, `3.1-AC9`) and in `system-foundation-specs.md` §2.2,
  which is where a reader asking "why two identical values?" is sent. This matches
  `surfaceToast`, which duplicates `surfaceTabChrome`'s literal uncommented.

### Reuse decisions

- Existing hexes are reused rather than derived, per D2 — `#2F3782` from
  `surfaceIndigoPanel`, `#7D4EE0` from `statusViolet`. No new brand colour.
- **`surfaceArtDeep` is written as a literal, not bound to the existing
  `_statusViolet` private const** (`app_color_tokens.dart:11`), even though the
  value is identical. Binding them would couple a ratified *surface* to an *open
  decision*: `system-foundation-specs.md` §7.1 and register line 327 still hold
  violet-as-a-status-dot open (options `1a`/`1b`/`1c`), so a later edit resolving
  that decision against violet would silently move a surface it never intended to
  touch. Two independent literals, each pinned by `3.1-AC6`, fail loudly instead.
  The same reasoning applies to `surfaceArt` vs `surfaceIndigoPanel`.
- The alias shape itself is precedented: `surfaceToast` (`#2E3236`) already
  duplicates `surfaceTabChrome` from item 2.7.

## Token test design

`test/widget/theme/app_tokens_test.dart` (modify). Four separate sites, three
different purposes. The whole file is a **token-contract test**, not a widget
test — its exact-value assertions *are* the design system's contract, so the
`flutter-widget-test` rule against asserting token values (which governs widgets
rendering with a theme) does not apply here and its existing `setUpAll` token
resolution stays. Do not "simplify" this file.

### 1. The distinctness `Set` at `:44-49` — the decision, and why

**Decision: the `Set` keeps exactly its three current members
(`surfaceRaised`, `surfaceIndigoPanel`, `surfaceTabChrome`) and its
`expect(distinct.length, 3)`. Neither new token is added. A written reason is
added naming `surfaceArt` as a deliberate alias** (`3.1-AC9`).

Reasoning, recorded because getting this wrong produces a green suite:

- `surfaceArt` is value-identical to `surfaceIndigoPanel` (`#2F3782`, D2). Adding
  it gives the `Set` **four members that collapse to three unique values**, so
  `expect(distinct.length, 3)` still passes — while no longer asserting that
  anything is distinct from anything. The test would be dead and look alive.
  This is the same trap `surfaceToast` was kept out of at item 2.7.
- Adding `surfaceArtDeep` instead (four members, four unique values) would fail
  the assertion, and "fixing" it by bumping the literal to `4` changes what the
  test is about: it guards the three **raised onyx/indigo surfaces** that must
  stay visually separable, and a violet empty-state fill is not one of them.
- No extra `expect(colors.surfaceArt, colors.surfaceIndigoPanel)` identity
  assertion is added. Both values are pinned as literals — `surfaceIndigoPanel` at
  `:41` and `surfaceArt` by `3.1-AC6` — so a fork of either already fails one of
  those two assertions. An identity assertion would be a third way of saying the
  same thing.

The reason is written as a short comment inside that test, next to the `Set`, in
plain English: `surfaceArt` deliberately aliases `surfaceIndigoPanel`, so it is
kept out of this `Set` — adding it would leave four members with three unique
values and the assertion would pass without asserting anything.

### 2. The violet-exclusion assertion at `:97-111` — the other site, other purpose

Per `3.1-AC7` and D1: the assertion stays and stays meaningful for every other
token. `surfaceArtDeep` is **excluded from the `surfacesAndAccents` list** and the
exclusion carries a written reason naming D1's ratification (2026-08-26) and
pointing at `system-foundation-specs.md` §2.2. `surfaceArt` **is added** to the
list — it carries no exclusion (`3.1-AC7`), it is not violet, and adding it keeps
the assertion's coverage complete as the surface set grows.

Deleting or weakening the assertion is the failure mode D1 names explicitly. It is
not an option.

### 3. `_allColors()` at `:493+` — coverage, not distinctness

Both new tokens are appended in the same order they appear on the class
(`3.1-AC8`), so the `#1e2353` scan at `:63-67` and the lerp iteration at
`:460-462` see them. Duplicate values in this list are harmless: both consumers
use `contains` / element iteration, and nothing asserts its length or uniqueness
(verified by grep — `_allColors` has exactly two call sites).

**Caveat, recorded rather than glossed:** the lerp consumer is
`for (final color in _allColors(lerped.color)) expect(color, isNotNull);`. `Color`
is non-nullable, so that expectation cannot fail — membership of `_allColors()`
buys real coverage for the `#1e2353` scan but only nominal coverage for `lerp`.
`3.1-AC8` is still implemented exactly as written (it is the canonical criterion
and the `#1e2353` half is genuine), but **`3.1-AC4`'s lerp/`copyWith` carriage is
verified by reading the source, not by that loop** — QA should check the two
fields appear in `copyWith` and `lerp` directly. Strengthening the loop is a
pre-existing concern for whoever next owns that helper, alongside the already-
flagged missing `glass42`; it is not this item's to fix and would widen scope.

### 4. Value assertions

`3.1-AC6` adds the two pinned literals in the surfaces group, in the existing
`'should ...'` naming style.

## Documentation design

Five files. Every edit follows one principle from D4 — **the indigo→canvas veil
survives, only the desaturation goes** — and one from the BA's assumption set: the
smallest edit that removes the wrong clause and leaves the surrounding sentence
true, in each doc's existing style.

**Locate every edit by its quoted text, never by line number.** The line numbers in
`tech-ac.md` are pre-edit values, and `system-foundation-specs.md` §2.2 grows from
three prose lines to a table, which shifts every later line in that file.

`system-foundation-specs.md`
- §2.2 → a two-row table with both values, both stated as flat fills, and the two
  roles stated **separately**; explicit "not a pair, not a ramp" (`3.1-AC10`, D3).
- §2 rule 4 → records violet ratified as a surface in exactly one place, dated, and
  keeps the rule's real subject (no fourth loud *accent*). It also states that
  violet as a *status hue* is still §7.1's open decision, so the amendment cannot
  be read as closing it (`3.1-AC11`).
- §7.1 → the "never a surface" clause becomes the same dated carve-out; the
  options `1a`/`1b`/`1c` and the rest of §7.1 are untouched (`3.1-AC12`).
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

`coverage` — `AppColorTokens` is the app-wide theme extension consumed by far more
than three features. No new test file: no widget or screen changes, so per
`flutter-widget-test` no widget qualifies for a dedicated test, and the existing
token-contract test already owns this contract. The only test edits are the four
sites `3.1-AC6` – `3.1-AC9` name.

## Caveats — I have no shell

I cannot run `flutter analyze`, `flutter test`, or `build_runner`. Three claims
rest on reading rather than executing; each has a fallback, and Dev records the
outcome as a self-correction either way.

1. **Adding two required constructor parameters breaks no call site.** Reasoned
   from grep: `AppColorTokens(` appears at four places, all inside
   `app_color_tokens.dart` itself (declaration, `dark`, `copyWith`, `lerp`); no
   test or screen constructs it directly. *Fallback:* if the analyzer reports a
   missing-argument error at a file outside the allowlist, that is a scope breach
   under `3.1-AC23` — escalate, do not edit the file.
2. **`expect(color, isNotNull)` over `_allColors()` cannot fail.** Reasoned from
   Dart null safety on a non-nullable `Color`. *Fallback:* none needed — nothing
   in the plan depends on that loop catching anything; `3.1-AC4` is verified by
   source read. If Dev finds it can fail, say so and leave the loop alone.
3. **Duplicate values in `_allColors()` break neither consumer.** Reasoned from
   both consumers using `contains` / iteration and from grep finding no third
   consumer and no length or uniqueness assertion. *Fallback:* if a hidden
   consumer trips, keep `3.1-AC8` and report — do not solve it by removing a
   token from the helper.

No scratch files were created by this agent.

## Out of scope

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
  pre-existing, flagged not fixed.
- **`.agents/handover.md`** — the orchestrator's close-out, not a criterion.

## Open questions

NONE.

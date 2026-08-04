# Task Brief
Source: Ticket `W1-6.1R` — "Welcome screens header rework (item 6.1)"
(`.agents/runs/welcome-screens-header-rework-20260804/tech-ac.md`)
Date: 2026-08-04

## Context

Replace both welcome heroes' composed widget scenes with flat PNG art already on disk, delete
the screen-2 social-proof row and the ten localisation keys left without consumers, so the
onboarding presentation layer shrinks to a container plus two images.

## Testing mode

`smoke` — Rule applied: UI-only with no new logic, isolated with no shared dependencies —
Justification: this run adds no logic at all; it deletes widgets and swaps composed subtrees
for `Image.asset`. It touches no auth, payment, persistence or offline path. The existing
persistence assertions (`first_use` written on Skip and Get started, not on Next) are
carried forward from item 6 in the same file and must be preserved, not because this run
introduces persistence but because `[W1-6.1R.18]` requires item 6's remaining coverage to
survive the rewrite.

## File allowlist

### CREATE NEW
None. `_WelcomeHero` is a new private class inside an existing file, not a new file.

### DELETE
lib/features/onboarding/presentation/widgets/cover_tile.dart — cover-fan tile and its `Playing` status chip; no consumer survives
lib/features/onboarding/presentation/widgets/welcome_key_art.dart — screen 2 key art, wash, countdown title, countdown tiles and colons
lib/features/onboarding/presentation/widgets/welcome_stat_pill.dart — glass stat pill and its figure/label pairs

### MODIFY EXISTING
lib/core/res/const.dart — add three welcome header asset filenames to `AssetConstants`
lib/features/onboarding/presentation/widgets/welcome_container.dart — hero becomes fill + one centered image via a new private `_WelcomeHero`; ambient circles, context chip, `heroContent` and `socialProof` parameters and the social-proof gap are removed
lib/features/onboarding/presentation/screens/onboarding_screen.dart — both step widgets pass only `step` and `actions`; `_WelcomeSocialProof` and the three deleted-widget imports go
lib/l10n/intl_en.arb — remove the ten keys listed in `[W1-6.1R.14]`
lib/l10n/intl_zh.arb — remove the same ten keys

### ASSETS — already on disk, commit as-is, do not modify or regenerate
assets/images/welcome-1-header.png — screen 1 hero content
assets/images/welcome-2-header.png — screen 2 hero content
assets/images/welcome-2-header-bg.png — screen 2 hero background

### TEST FILES
test/widget/onboarding/welcome_screen_test.dart — rewrite: delete every assertion on a removed element, add one asset-key assertion per hero, keep item 6's surviving coverage

`test/widget/onboarding/welcome_screen_test.mocks.dart` is generated and stays as-is;
`@GenerateMocks` is unchanged. `lib/generated/l10n.dart` and `lib/generated/intl/*` are
generated localisation output — never edited, see `[W1-6.1R.15]`.

## Implementation plan

Step 1: `lib/core/res/const.dart` — add three `static const` filename entries to
`AssetConstants` for the welcome header art, alongside the existing `error404`. Filenames
only; the `assets/images/` prefix comes from `PathConstants.imagePath` at the call site.

Step 2: `lib/features/onboarding/presentation/widgets/welcome_container.dart` — add a
private `_WelcomeHero` stateless widget that paints the whole hero: the existing
`heroShape` clip over a stack whose fill is the indigo token colour on step one and the
cover-fitted background asset on step two, with the step's content asset over it,
contain-fitted across the full hero so it centres on both axes without cropping. Both
images are excluded from semantics and take no error or placeholder builder.

Step 3: same file — reduce `WelcomeContainer` to `{required step, required actions}`:
delete the `heroContent` and `socialProof` parameters, the two ambient circles, the glass
context chip and its `chip` string resolution, and the now-unused imports. The hero slot in
the `Column` becomes the sized `_WelcomeHero`; keep the `LayoutBuilder` shortfall clamp,
the heights, the radius and the copy-block scroll view exactly as they are.

Step 4: same file — remove the social-proof slot from the copy block together with the
18px gap that followed it. Do not adjust any other spacing value; every surviving gap keeps
its item-6 number.

Step 5: `lib/features/onboarding/presentation/screens/onboarding_screen.dart` — reduce
`_WelcomeStepOne` and `_WelcomeStepTwo` to `WelcomeContainer(step:, actions:)`, delete
`_WelcomeSocialProof`, and drop the `cover_tile.dart`, `welcome_key_art.dart` and
`welcome_stat_pill.dart` imports. Action rows, cubit calls and navigation are untouched.

Step 6: delete `lib/features/onboarding/presentation/widgets/cover_tile.dart`.

Step 7: delete `lib/features/onboarding/presentation/widgets/welcome_key_art.dart`.

Step 8: delete `lib/features/onboarding/presentation/widgets/welcome_stat_pill.dart`.

Step 9: `lib/l10n/intl_en.arb` — remove exactly the ten keys named in `[W1-6.1R.14]`
(currently contiguous, lines 10–19). Add nothing; touch no other key; leave `playing`,
`next`, `skip`, `get_started`, `welcome_headline_one/two` and `welcome_body_one/two` in
place.

Step 10: `lib/l10n/intl_zh.arb` — remove the same ten keys, same rules. The two files must
end up with identical key sets.

Step 11: `test/widget/onboarding/welcome_screen_test.dart` — rewrite the body: keep the
existing harness, mocks and the six behaviours item 6 covered (first-step copy, step-two
copy with no Skip and no flag write, Skip writes the flag and replaces the route, Get
started writes the flag and replaces the route, reduced motion collapses the switcher
duration, no overflow at 360x600 with 1.5 text scale), and add per-step assertions that the
hero renders its expected asset exactly once, matched on the `AssetImage` asset key built
from `PathConstants.imagePath` + `AssetConstants`. Screen 2 additionally asserts its
background asset renders once. Delete — do not `skip:` or comment out — every assertion
about cover tiles, the status chip, the stat pill, the context chip, key art, countdown or
social proof. No `matchesGoldenFile`.

Generation checkpoint: run `dart run build_runner build --delete-conflicting-outputs`
before running the tests. `@GenerateMocks` is unchanged, so this is expected to be a no-op
on `welcome_screen_test.mocks.dart`; it is here to guarantee the mocks match the source
tree. Do not run `flutter gen-l10n` and do not attempt any localisation regeneration —
this run adds no key, so none is needed (`[W1-6.1R.15]`).

Step 12: verify no reference to `CoverTile`, `WelcomeKeyArt`, `WelcomeStatPill`, the
deleted files, or any of the ten removed localisation keys survives anywhere in `lib/` or
`test/` (`lib/generated/` is excluded — its stale accessors are expected and must stay).

Final step: run `flutter analyze` and `flutter test` and compare against
`orchestrator-state.md`'s recorded baselines, quoted verbatim:
`Analyzer baseline: 0 errors, 2 warnings, 36 info — captured 2026-08-04T18:59:00+08:00`
`Test baseline: +142 -13 — captured 2026-08-04T19:02:00+08:00`
No new error or warning may be attributable to this run's files; a *drop* in the info count
is expected from the deletions and is not a regression (`[W1-6.1R.19]`). The two failures
recorded in `test/widget/onboarding/welcome_screen_test.dart` are in scope and must be
green at the end of this run (`[W1-6.1R.20]`); every other recorded pre-existing failure
stays exempt and must not be touched.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: `[W1-6.1R.1]` through `[W1-6.1R.20]`
Carried forward and still binding, referenced not re-derived: `[W1-6.7]`, `[W1-6.8]`–`[W1-6.11]`,
`[W1-6.12]` (height and radius clauses), `[W1-6.15]`, `[W1-6.24]`–`[W1-6.34]`,
`[W1-6.36]`–`[W1-6.44]` — see `tech-ac.md ## Carried forward from item 6, unchanged`.
No longer in force: `[W1-6.13]`, `[W1-6.14]`, `[W1-6.16]`–`[W1-6.23]`, `[W1-6.35]`.

## Constraints

- **This run is a net deletion.** The only things built are one private hero widget, two
  `Image.asset` placements and three constants. Anything larger has misread the criteria.
- `pubspec.yaml` is read-only. `assets/images/` is already registered; add no asset
  directory, no `2.0x`/`3.0x` variant folder, no dependency.
- Never edit `lib/generated/l10n.dart` or `lib/generated/intl/messages_*.dart`, including
  to remove the stale accessors for the ten deleted keys. Do not run `flutter gen-l10n` —
  it belongs to a removed system (`flutter-arch.md § Localisation`).
- No token file under `lib/config/theme/tokens/` may be edited; leave every now-unused token
  in place.
- Every visual value in the touched widgets resolves through `context.tokens` — no
  `Color(0x…)`, no literal `BoxShadow`, no literal blur sigma, no inline `TextStyle` with a
  font size (`[W1-6.1R.13]`, `[W1-6.7]`).
- Extracted UI is a widget class, never a function or getter returning `Widget`
  (`flutter-arch.md`). `_WelcomeHero` stays private in `welcome_container.dart` — do not
  create a new file for it.
- Constants go in `AssetConstants`; `dart-style.md` forbids bare top-level constants and
  inline asset-path duplication between widget and test.
- Do not add a placeholder, spinner, `errorBuilder` or fallback art for the images
  (`[W1-6.1R.6]`), and do not give them a semantic label, alt text or new copy
  (`[W1-6.1R.16]`) — use `excludeFromSemantics`.
- Do not delete `lib/widgets/glass_surface_widget.dart`. It loses its last caller here but
  is a design-system primitive the foundation spec requires for the Home hero and
  game-detail screens, and the design-system component library is out of scope for this run
  (see `tdd.md ## Out of scope`).
- Assert the hero art in tests by `AssetImage` asset key, not by decoded pixels, and never
  with `matchesGoldenFile` — this project has no golden tests, whatever a criterion says
  about appearance (`execution.md`).
- Keep unrelated pre-existing changes in the tree; the three untracked PNGs are this run's
  approved inputs and are committed with the work.
- Android portrait only. No platform conditional, no iOS branch, no landscape layout.
- Comments explain *why* in plain English; the hero's shortfall clamp is the one layout
  invariant worth a comment, and it already has one — do not add narration elsewhere.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make tests
pass. Do not add packages to `pubspec.yaml` or touch files outside the allowlist —
escalate instead.

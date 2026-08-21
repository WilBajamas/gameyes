# Task Brief
Source: Week 2 task briefs items 1.8, 1.9 (combined run) · `tech-ac.md` 2026-08-20
Date: 2026-08-20

## Context

Promote the welcome screen's inline progress dots and the sign-in screen's private provider row
into `lib/widgets/` as `ProgressDots` and `ActionRow`, and rewire both screens onto them. Nothing
visible changes on any screen.

## Testing mode

`smoke` — Rule applied: UI-only with no new logic, isolated, no shared dependencies.
Justification: the `coverage` trigger for "auth" was checked and does not fire — no auth logic,
cubit, use case or repository is touched; the control that starts sign-in moves file, and the
screen-level behaviour that matters (spinner on the active provider only, both rows locked while in
flight, inline error, retry) stays covered by the existing `auth_screen_test.dart`. Neither widget
is a shared utility used by 3+ features yet. Matches the `ZoneLabel` / `StatusChip` /
`PlaceholderSlot` precedent.

Per `flutter-widget-test`, both widgets warrant a dedicated test file — neither is a passive
wrapper:
- `ProgressDots` — content changes with both inputs (`count` → how many dots, `activeIndex` → which
  one is active) and it owns a debug-time range contract. **Dedicated file.**
- `ActionRow` — owns enabled/disabled tap behaviour, the busy state, and its accessibility node.
  **Dedicated file.**
No other widget in scope gets one. Dev writes both, guided by `flutter-widget-test`; the behaviours
to cover are fixed by [ALL-AC8] and the naming, setup and assertions are Dev's. No golden test, no
`matchesGoldenFile`, whatever the criteria say about appearance.

## File allowlist

### CREATE NEW
`lib/widgets/progress_dots.dart` — `ProgressDots` plus its file-private `_Dot`.
`lib/widgets/action_row.dart` — `ActionRow`, the promoted full-width 52px row.

### MODIFY EXISTING
`lib/features/onboarding/presentation/widgets/welcome_container.dart` — replace the inline dot `Row`
  with one `ProgressDots`; change nothing else in the file.
`lib/features/auth/presentation/screens/auth_screen.dart` — drop the `provider_action_button` `part`
  and the now-unused `button_press_scale` import, import `action_row.dart`, swap both call sites.
`lib/features/auth/presentation/widgets/provider_action_button.dart` — **delete the file.**
`.claude/skills/flutter-widgets/SKILL.md` — add one catalogue row per component; edit no existing
  row.

### TEST FILES
`test/widget/components/progress_dots_test.dart` — dot count, which dot is active, the §3.3
  dimensions and fills, the 6px gap, the row hugging its content, no text or tap handler, and the
  debug failure on an out-of-range index.
`test/widget/components/action_row_test.dart` — 52px height and full width, the `sm` radius and the
  caller's fill, the 20px mark and the centred mark+label pair, one callback per tap when enabled
  and none when disabled, the indicator present only while busy, and the label on one line with an
  ellipsis when narrow.
`test/widget/onboarding/welcome_screen_test.dart` — **conditional, expected untouched.** The design
  keeps each dot a `Container`, so the existing `_countDots` helper still works unmodified. Edit it
  only if it actually breaks, and only to retarget the helper at `ProgressDots`; the assertions must
  stay equivalent — one 22-wide dot and one 5-wide dot per page. Never delete, skip or weaken a test.

`test/widget/auth/auth_screen_test.dart` is deliberately **not** allowlisted: it never references
the private class, so the migration must leave it passing untouched. If it fails, that is a real
regression — fix the code, not the test.

## Implementation plan

Step 1: Create `lib/widgets/progress_dots.dart` — `ProgressDots` (`count`, `activeIndex`; both range
  rules as `assert`s in the const constructor's initialiser list) rendering a
  `Row(mainAxisSize: MainAxisSize.min, spacing: 6)` of `count` private `_Dot`s; `_Dot` is a
  `Container` 22×5 when active and 5×5 otherwise, filled `ink` / `ink12` at `radius.pill`.
Step 2: Modify `welcome_container.dart` — replace the inline two-`Container` dot `Row` with
  `ProgressDots(count: 2, activeIndex: isFirstStep ? 0 : 1)`. Touch nothing else: hero height and
  shortfall, scroll paddings, the 22/18px gap to the headline, headline, body and actions all stay.
Step 3: Create `lib/widgets/action_row.dart` — move the `_ProviderActionButton` tree verbatim,
  renaming `assetPath` to `markAsset`, keeping all seven parameters required, and applying only the
  two deltas below.
Step 4: Modify `auth_screen.dart` — remove the `part '../widgets/provider_action_button.dart';`
  directive and the `widgets/button_press_scale.dart` import (unused once the part is gone), add the
  `widgets/action_row.dart` import in alphabetical position, and swap both call sites to `ActionRow`
  with identical arguments and identical order (Discord/`accentIndigo` first, Google/`surfaceRaised`
  second). The 10px `SizedBox` between the rows stays in the screen's `Column`.
Step 5: Delete `lib/features/auth/presentation/widgets/provider_action_button.dart`.
Step 6: Add two rows to the `flutter-widgets` catalogue in `.claude/skills/flutter-widgets/SKILL.md`,
  each describing what the component is and noting that it adds no spacing of its own, matching the
  `ZoneLabel` / `StatusChip` / `StatPill` row style.
Step 7: Write `test/widget/components/progress_dots_test.dart`.
Step 8: Write `test/widget/components/action_row_test.dart`.
Step 9: Run `flutter analyze` and `flutter test` and compare against `orchestrator-state.md`'s
  recorded baselines, quoted verbatim: **Analyzer baseline: 0 errors, 2 warnings, 31 info** and
  **Test baseline: +259 -10**, with the pre-existing failures in
  `test/repository/tracker/tracker_repository_test.dart` (4),
  `test/cubit/game_detail/game_detail_cubit_test.dart` (3) and
  `test/cubit/games/games_bloc_test.dart` (3). Only a new, in-scope failure is yours.

No `build_runner` step: neither new file is annotated and neither new test declares `@GenerateMocks`.
If you find yourself needing a mock, stop and re-read the plan.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: 1.8-AC1..AC12, 1.9-AC1..AC12, ALL-AC1..AC8

Read [1.9-AC5] together with `tdd.md ## Decisions carried forward` item 3 — its "`ink` token" is a
factual error and the design pins `ink70`.

## Constraints

- **Nothing visible changes** ([ALL-AC4]). No "while I was in there" correction to type, colour or
  spacing at either call site. A visual difference is a defect.
- **Label colour** — pin the row label with `tokens.typography.body.style.copyWith(color:
  tokens.color.ink70)`. Not `ink`: `body` carries no colour, so the shipped label inherits the
  ambient `DefaultTextStyle`, which inside a `Scaffold`'s `Material` is `textTheme.bodyMedium` →
  the `meta` token → `ink70`. Pin the colour it actually resolves to today; if you establish it
  resolves to something else, pin that instead and say so in `diff-summary.md`.
- **Label overflow** — `maxLines: 1`, `overflow: TextOverflow.ellipsis`, and wrap the label `Text`
  in `Flexible` (not `Expanded`) so the pair stays optically centred per [1.9-AC4]. This is the
  `flutter-widgets` hug-content exception, taken deliberately.
- **The dots' 5px dimensions are a recorded exception** to the even-dimension rule. Do not round 5
  to 4 or 6, and do not flag it as a violation. Same for the row's 16/400 label vs §3.3's 15/500 —
  preserve what ships; no new type token in this run.
- **Tokens only** ([ALL-AC2]) — every colour, radius, type style and duration through
  `context.tokens`. Never `Theme.of(context)`, never `ColorScheme`, never a `Colors.*` or hex
  literal, never a local font family, weight or duration. The only literals allowed are the
  dimensions tech-ac states (22, 5, 6, 52, 20, 10, 16, stroke 2).
- **No spacing of their own** ([ALL-AC1]) — no outer padding or margin on either widget and no
  padding/margin/gap constructor parameter. Interior gaps are anatomy and stay.
- **No new parameters beyond those listed.** No optional mark, trailing chevron, alignment, size or
  animation knob — the promotion rule forbids speculative parameters.
- **No feature types in `lib/widgets/`** — no `WelcomeStep`, no `SignInProvider`, no `S.current`, no
  hardcoded asset path or provider name in either new file ([1.8-AC2], [1.9-AC2], [ALL-AC5]).
- **No new localisation key, no `.arb` edit, no regenerated `S`** ([ALL-AC5]).
- **`pubspec.yaml` is read-only.** No new dependency ([ALL-AC6]).
- **No `CustomPaint`, no dashed edge, no border** on either component ([ALL-AC3]).
- Dart style: 80-char lines, single quotes, trailing commas on multi-line argument lists, `const`
  wherever the linter allows, import groups alphabetised (flutter → third-party → project).
- Comments: few, plain English, explaining the why. No `///` doc comment restating a field's name.
- Extracted UI is a widget class — never a function or getter returning `Widget`.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make tests pass. Do not
add packages to `pubspec.yaml` or touch files outside the allowlist — escalate instead.

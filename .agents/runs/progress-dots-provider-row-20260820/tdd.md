# Technical Design Document
Source: Week 2 task briefs items 1.8, 1.9 (combined run) · `system-foundation-specs.md` §3.3 ·
`onboarding-auth-design-spec.md` §5 · `tech-ac.md` 2026-08-20
Date: 2026-08-20

## Feature summary

Presentation-layer only. Two primitives are promoted out of feature folders into `lib/widgets/`
with a generic API, and their existing screens become the first callers. No data, domain, state,
storage or localisation work; no generated output; no new package. The governing rule is
[ALL-AC4] — the two welcome pages and the sign-in screen render exactly as they do today. Where a
spec value and the shipped pixels disagree, the shipped pixels win and the gap is recorded.

## Layer map

[1.8-AC1..AC10]: UI (new global widget)
[1.8-AC11..AC12]: UI (onboarding feature widget, call-site migration)
[1.9-AC1..AC10]: UI (new global widget)
[1.9-AC11..AC12]: UI (auth screen, call-site migration + deletion of the feature-private `part`)
[ALL-AC1..AC6]: UI (both widgets)
[ALL-AC7]: docs (`flutter-widgets` skill catalogue)
[ALL-AC8]: tests (widget layer)

## Data layer
None. No API contract, model, DTO, repository or datasource is touched.

## Domain layer
None. No use case, entity or enum is added, moved or widened — `WelcomeStep` and `SignInProvider`
stay where they are.

## State layer
None. `WelcomeCubit` and `SignInCubit` are untouched; both new widgets are stateless and take
everything they render from their constructor. The reactive boundary on each screen stays exactly
where it is (`OnboardingScreen`'s `BlocBuilder`, `_AuthContent`'s `BlocBuilder`).

## UI layer

### Widgets

**`ProgressDots` (create) — `lib/widgets/progress_dots.dart` — stateless.**
Consumes: `int count`, `int activeIndex`. No callbacks, no user-facing string, no feature type.
Interactions: none — display only, no gesture detector, no ripple, no animation ([1.8-AC8],
[1.8-AC9]).
Structure: a `Row` with `mainAxisSize: MainAxisSize.min` and `spacing: 6`, whose children are
`count` instances of a file-private `_Dot`, one of them active. `mainAxisSize.min` is what makes the
row hug its content ([1.8-AC6]); `Row.spacing` is what makes the 6px gap interior-only, with no
leading or trailing gap ([1.8-AC4]) — the same construction `ContextChip` already uses.
`_Dot` (private, same file) draws a `Container` sized 22×5 when active and 5×5 otherwise, filled
`ink` / `ink12`, cornered with `radius.pill`. Both range rules are `assert`s in the `const`
constructor's initialiser list — `count >= 1` and `0 <= activeIndex < count` — which is the
`StatPill` precedent for a debug-only limit ([1.8-AC10]).
Naming: `ProgressDots` collides with nothing in `package:flutter/material.dart`, so no call site
needs an alias or `hide` ([1.8-AC1]).

**`ActionRow` (create) — `lib/widgets/action_row.dart` — stateless.**
Consumes: `String label`, `String markAsset`, `Color fill`, `bool enabled`, `bool loading`,
`String loadingLabel`, `VoidCallback onPressed` — all required, exactly the seven inputs the two
live callers exercise today, with no defaults invented ([1.9-AC2]).
Interactions: one tap → `onPressed`, suppressed while `enabled` is false; press-scale and focus ring
come from the existing `ButtonPressScale` ([1.9-AC7], [1.9-AC9]).
Structure: the shipped `_ProviderActionButton` tree, moved unchanged —
`Semantics(button, enabled)` → `IgnorePointer(!enabled)` → `ButtonPressScale` →
`SizedBox(height: 52, width: double.infinity)` → `DecoratedBox(fill, radius.sm)` → centred `Row`
of `Image.asset(markAsset, 20×20, semanticLabel: label)`, a 10px gap, the label, and — only while
`loading` — a 10px gap plus a 16px `CircularProgressIndicator` at stroke 2 carrying `loadingLabel`.
Two deliberate deltas, neither of which changes a pixel at either live call site:
- the label gets `maxLines: 1` and `overflow: TextOverflow.ellipsis`, and its `Text` is wrapped in
  `Flexible` so the ellipsis can actually engage ([1.9-AC5]). `Flexible`, not `Expanded`: the
  hug-content exception in the `flutter-widgets` skill applies, because `Expanded` would push the
  mark to the row's left edge and break the optically-centred mark+label pair that [1.9-AC4]
  requires. Loose `Flexible` leaves a label that fits at its natural size, so today's layout is
  unchanged. **Flagged for confirmation at the Phase 3 gate, per that skill's instruction.**
- the label's colour becomes explicit — see "Decisions carried forward", item 3.
Naming: `ActionRow` is categorical (a full-width tappable row with a leading mark and a centred
label), carries no `default` prefix, no auth vocabulary, and collides with nothing in Flutter or in
`lib/` ([1.9-AC1]). "Provider" is deliberately not in the name: the same anatomy is already
hand-rolled by settings' `_SignOutButton`, which is not a provider.

### Screens / call sites

**`WelcomeContainer` (modify) — `lib/features/onboarding/presentation/widgets/welcome_container.dart`.**
The inline two-`Container` `Row` (lines 57–81) is replaced by
`ProgressDots(count: 2, activeIndex: isFirstStep ? 0 : 1)`, reusing the `isFirstStep` local the file
already computes. Nothing else in the file changes ([1.8-AC11]). `WelcomeStep` stays in the feature
and never reaches `lib/widgets/`.

**`AuthScreen` (modify) — `lib/features/auth/presentation/screens/auth_screen.dart`.**
Drops `part '../widgets/provider_action_button.dart';`, imports `widgets/action_row.dart`, and swaps
both `_ProviderActionButton` call sites for `ActionRow` with identical arguments (`assetPath:` →
`markAsset:`). Discord first with `accentIndigo`, Google second with `surfaceRaised`; the 10px gap
between them stays in the screen's `Column` ([1.9-AC11], [ALL-AC1]). The
`widgets/button_press_scale.dart` import becomes unused once the `part` is gone — `_LegalFooter`
does not use it — and must be removed, or the run adds an analyzer warning against the recorded
baseline ([ALL-AC6]).

**`provider_action_button.dart` — deleted.** Both callers migrate in-run, so no `@Deprecated` shim
is kept ([1.9-AC1]).

## Reuse decisions

- `ButtonPressScale` (`lib/widgets/button_press_scale.dart`) — reused as-is by `ActionRow`. It
  already owns the press scale, its duration from `motion.stateChange` (which honours reduced
  motion) and the green focus ring, so [1.9-AC9] is met by moving the wrapper, not re-deriving it.
- `Container` for each dot, rather than `SizedBox` + `DecoratedBox` — deliberate. The existing
  `welcome_screen_test.dart` counts dots by filtering `Container`s on `constraints.maxWidth`; keeping
  `Container` means that test file needs no edit at all and its assertions stay literally the ones
  it ships with ([ALL-AC8]).
- `PrimaryButton` (`lib/widgets/primary_button.dart`) — considered and rejected as the base for
  `ActionRow`. It is the green CTA primitive: `meta` type at `inkDark`, a 44px minimum rather than a
  fixed 52, no mark slot and no busy state. Bending it to fit would restyle the welcome and settings
  screens that already call it, which [ALL-AC4] forbids.
- `PlaceholderSlot`'s `providerMark` preset — not used. Both live rows ship real marks; a fallback
  has no caller (tech-ac "Out of scope").
- Design tokens are read through `context.tokens` in both files — no `Theme.of(context)`, no colour
  or radius literal ([ALL-AC2]).

## Decisions carried forward

These three are recorded here so Dev and QA do not rediscover or "helpfully" correct them.

1. **The dots stay 22×5 / 5×5 with a 6px gap** — an explicit, recorded exception to the
   `flutter-widgets` "dimensions are even numbers" rule. That convention was written after these
   dots shipped, §3.3 states the odd values literally, and the welcome screens and their test
   already assert them. Rounding 5 to 4 or 6 would be a visual regression, not a compliance fix.
   Not a skill violation for QA to raise ([1.8-AC4], tech-ac "Assumptions").

2. **The row's label stays `typography.body` (Inter 16/400)**, not §3.3's 15px/500. Preserve what
   ships, per this run's governing rule. Relevant if the human reverses this at the Phase 3 gate:
   `lib/config/theme/tokens/app_type_tokens.dart` has no 15px style today, so correcting the label
   means adding a type token (and 15 is itself an odd font size under the even-dimension rule) —
   i.e. a token change plus a visible change to a live screen, not a one-line edit. Out of scope as
   written ([1.9-AC5]).

3. **The label's explicit colour is `ink70`, not `ink` — a correction to [1.9-AC5]'s wording.**
   The criterion, and the BA assumption behind it, assume the shipped label already renders at full
   `ink` and that pinning `ink` is a no-op robustness fix. It is not. The shipped code is
   `Text(label, style: tokens.typography.body.style)`; `body`'s style carries **no colour**, so
   `Text` merges it over the ambient `DefaultTextStyle`, which inside a `Scaffold`'s `Material` is
   `textTheme.bodyMedium` — mapped in `theme_data_dark.dart` to the `meta` token, whose colour is
   `ink70`. The sign-in labels therefore render at 70% ink today. Pinning `ink` would brighten both
   rows: a visible change, which [ALL-AC4] calls a defect "regardless of what §3.3 says", and which
   the assumption's own stated premise ("resolves to the same colour") does not survive.
   Design: pin `tokens.color.ink70` via `copyWith`, which delivers the robustness [1.9-AC5] actually
   wants — a row that renders the same wherever it is placed — with zero pixel change. The task
   brief carries a one-line fallback so the rule holds even if the resolved colour turns out to be
   something else. **QA should read [1.9-AC5]'s "`ink` token" as "`ink70` token"; the human can
   reverse this at the Phase 3 gate, at the cost of a visible change to the sign-in screen.**

## Out of scope

Everything listed under `tech-ac.md ## Out of scope` stands unchanged. Two Tech Lead confirmations:

- **`_SignOutButton` in `lib/features/settings/presentation/widgets/sign_out_section.dart` is not
  migrated in this run.** It is the natural second `ActionRow` caller, but it has no leading mark,
  so folding it in would make the mark slot optional and change [1.9-AC4] mid-run, and it would put
  a third screen's pixels at risk under a "nothing visible changes" rule. Scheduled as a follow-up
  item, not deferred silently.
- **No `.arb`, no `pubspec.yaml`, no `build_runner`.** Neither new file is annotated and neither new
  test needs a mock, so this run has no generation checkpoint at all.

## Open questions
NONE

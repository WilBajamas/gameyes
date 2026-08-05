# QA Report
Source: Ticket `W1-6.2R` — "Welcome screens polish + global system UI convention (item 6.2)"
Date: 2026-08-04

Overall result: PASS — pending manual checks

Commit verified: `dad05648212ea00119fe915bf666e2d7e36a546c` on
`claude/welcome-screens-polish-resume-una4wt`. Working tree clean.

## Manual verification required

[W1-6.2R.10] — Open any screen on an Android device (both an API 34 and an API 35+
device if available) — expect the system navigation / gesture bar area to read as the
app canvas `#23272A` with no black or off-colour band, and the status bar area to show
whatever the screen paints behind it. Code sets the style once and adds no compensating
opaque bar, but the rendered outcome is platform-dependent and cannot be asserted in a
widget test.

Advisory visual checks (declared out of scope for the criteria by
`tech-ac.md ## Out of scope`, but flagged by the design gate — not blocking):

- Welcome screens 1 and 2, normal phone viewport — expect the hero art inset 24 on all
  four sides with the fill / background image still reaching the panel edges, and the
  art reading as correctly proportioned at the new 240 / 216 heights.
- Welcome screen 1, top edge — design-gate decision 3 accepts a canvas band between the
  status bar and the hero's top radius. Confirm that band looks intentional.
- Welcome screens on a 360 × 600 viewport — hero renders at ~126 (screen 1) / ~102
  (screen 2) after the give-back. Confirm it does not read as a sliver.
- Swipe between the two pages by hand — expect it to clamp at both ends (no overscroll
  onto empty space) and to feel like direct manipulation, not a fought animation.

## Static analysis
Status: PASS
Errors: NONE

`dart run build_runner build --delete-conflicting-outputs` ran clean (2 outputs written,
`git status` clean afterwards) — generated code is current, so analysis is against fresh
output.

`flutter analyze` — 38 issues: 0 errors, 2 warnings, 36 info. Identical to
`orchestrator-state.md`'s `Analyzer baseline: 0 errors, 2 warnings, 36 info`. Both
warnings are pre-existing and in
`lib/features/tracker/presentation/screens/task_detail_screen.dart` (`_TaskReminder`
unused, unused optional parameter) — outside this run's allowlist. No issue of any
severity is attributed to an allowlisted file.

## Test results
Status: PASS
Testing mode: smoke
Tests run: 161  |  Passed: 148  |  Failed: 13

Allowlisted test file `test/widget/onboarding/welcome_screen_test.dart` — 12/12 green.

Full suite `+148 -13` against the recorded `Test baseline: +144 -13 (157 total)`. The
+4 delta is exactly this run's four new cases (8 → 12 in the onboarding widget file);
total 161 = 157 + 4. The 13 failures were enumerated from the JSON reporter and are
exactly the recorded pre-existing set, with no new file entering it:

- `test/api/game_detail/game_detail_test.dart` (1)
- `test/api/games/games_test.dart` (1)
- `test/cubit/game_detail/game_detail_cubit_test.dart` (3)
- `test/cubit/games/games_bloc_test.dart` (3)
- `test/repository/tracker/tracker_repository_test.dart` (4)
- `test/widget_test.dart` (1)

No regression. No pre-existing failing test was touched by this commit.

## Coverage gaps (coverage mode only)
N/A — testing mode is `smoke`.

## Acceptance criteria

[W1-6.2R.1]: PASS — `lib/features/onboarding/presentation/widgets/welcome_hero.dart:34-43`
— only the content `Image.asset` is wrapped in
`Padding(EdgeInsets.all(WelcomeLayoutConstants.heroContentPadding))`; the `ColoredBox`
fill (`:25`), the background `Image.asset` (`:26-31`) and the `ClipRRect` (`:20-21`) sit
outside it and still cover the panel edge to edge. Uniform inset on all four sides.

[W1-6.2R.2]: PASS — `welcome_hero.dart:38-42` — `fit: BoxFit.contain` retained, `Stack`
`fit: StackFit.expand` with default centre alignment unchanged (`:22-23`). The padding
shrinks the box only. Tests `shows the first hero art once and no background image` and
`shows the second hero art and its background once each` confirm exactly one content
image per visible page.

[W1-6.2R.3]: PASS — `lib/features/onboarding/const.dart:11-12` (`heroHeightOne = 240`,
`heroHeightTwo = 216`), consumed at
`lib/features/onboarding/presentation/screens/onboarding_screen.dart:123` and `:156`.
Both on the 8px scale (240 = 30×8, 216 = 27×8), 33.6% and 30.3% of 714 (both inside
30–36%), screen 1 ≥ screen 2. Radius and full-viewport width untouched in
`welcome_hero.dart` / `welcome_container.dart`.

[W1-6.2R.4]: PASS — test `does not overflow on a short viewport with larger text`
(360 × 600 at 1.5× text scale, asserted on both pages via `takeException()`); the
give-back mechanism is retained verbatim at
`lib/features/onboarding/presentation/widgets/welcome_container.dart:36-37`
(`shortfall = (714 - constraints.maxHeight).clamp(0.0, heroHeight)`), whose `clamp`
upper bound is `heroHeight`, so the resolved height cannot go negative.

[W1-6.2R.5]: PASS — `.agents/references/onboarding-welcome-design-spec.md` § 3 height
row now reads `240px` / `216px`; both "being reduced, see run notes" placeholders are
gone and no other row of that table changed (verified in the commit diff).

[W1-6.2R.6]: PASS — `onboarding_screen.dart:79-80` —
`Scaffold(body: SafeArea(child: ...))` with no edge disabled, matching the
`games_screen.dart` precedent. One `SafeArea` at screen level, outside the reactive
boundary.

[W1-6.2R.7]: PASS — `welcome_container.dart:44-51` — the copy block's bottom padding is
a flat `24`, the `+ context.bottomPadding` term is gone. A repo-wide grep for
`bottomPadding` in `lib/` returns only the extension definition
(`lib/core/utils/extensions.dart:12`) and `lib/widgets/scrolled_navigation_bar.dart` —
no surviving read anywhere in the welcome tree. Test
`keeps the action row off the bottom system inset` pumps a 40px bottom inset and asserts
the gap is exactly `24`, not `64`.

[W1-6.2R.8]: PASS — `lib/bootstrap.dart:16-24`, after
`WidgetsFlutterBinding.ensureInitialized()` (`:13`) and before `runApp` (`:30`). A
repo-wide grep for `setSystemUIOverlayStyle` in `lib/` returns exactly one hit, that
one. Both entrypoints funnel through it (`lib/main.dart:13`, `lib/main_prod.dart:6`),
and no welcome-specific code was needed.

[W1-6.2R.9]: PASS — `bootstrap.dart:17-23` — `statusBarColor: Colors.transparent`,
`systemNavigationBarColor: AppColorTokens.dark.canvas`,
`systemNavigationBarDividerColor: Colors.transparent`, both icon brightnesses `light`.
The token resolves to `0xFF23272A` at
`lib/config/theme/tokens/app_color_tokens.dart:103`. No literal, no new token. The
iOS-only `statusBarBrightness` is correctly absent.

[W1-6.2R.10]: MANUAL — see the checklist at the top. Code-side preconditions hold: the
style is global, the app adds no opaque bar in either region and nothing suppresses
edge-to-edge drawing. The rendered result is platform behaviour a human must confirm.

[W1-6.2R.11]: PASS — `.agents/references/project-conventions.md` gains a
"System bars and SafeArea" section stating the rule app-wide (not as a description of
onboarding), covering the `SafeArea` wrap, the single global overlay style set in
`bootstrap.dart`, the Android 15 edge-to-edge caveat, and explicitly that a different
treatment "is a deviation that needs a recorded decision, not a free choice".

[W1-6.2R.12]: PASS — `onboarding_screen.dart:102-106` — a `PageView` (default horizontal
axis) with exactly `children: const [_WelcomeStepOne(), _WelcomeStepTwo()]` in that
order, so index 0 is screen 1. No `physics` override, so Android's default
`PageScrollPhysics` over `ClampingScrollPhysics` clamps at both ends, per
`tdd.md ## UI layer`. On-device clamp feel is in the advisory manual list.

[W1-6.2R.13]: PASS — tests `moves to the second step when swiped forward without writing
the seen flag` and `returns to the first step when swiped backward` (both assert on the
visible page via the `_page(headline)` finder, not on cubit state). Test
`keeps the first page dot active while a drag is held` covers the unsettled drag.
Handler at `onboarding_screen.dart:48-55`.

[W1-6.2R.14]: PASS — `WelcomeState.step` remains the only source of truth; there is no
widget-local step field. Settled page → state at `onboarding_screen.dart:48-55`; state →
page at `:57-75`. The loop breaks in both directions: freezed value equality drops a
no-op `emit`, and `_followStep` returns early on
`if (_controller.page?.round() == target)` (`:62`). Every swipe/tap test ends in
`pumpAndSettle()` without timing out, which is the proof the tree settles.

[W1-6.2R.15]: PASS — `welcome_container.dart:57-81` — dot widths are driven solely by
`isFirstStep`, derived from the `step` constructor argument, which each page passes as a
fixed literal (`onboarding_screen.dart:122`, `:155`). No controller read, no scroll
notification, no animated widget around the dots. Test
`keeps the first page dot active while a drag is held` holds a 100px drag and asserts the
22/5 dot widths on the origin page are unchanged.

[W1-6.2R.16]: PASS — `onboarding_screen.dart:130-144` (screen 1: `Next` +
`SizedBox(width: 10)` + `SkipTextAction`) and `:163-166` (screen 2: `Get started`
alone), labels/callbacks/placement byte-identical to before. `Next` → `next()` → the
step listener moves the controller to page 1. Tests
`writes the seen flag when Skip exits the first step`,
`writes the seen flag when Get started exits the second step` (both also assert the
`AuthRoute` replace) and `moves to the second step without writing the seen flag`.

[W1-6.2R.17]: PASS — a repo-wide grep for `AnimatedSwitcher` in `lib/` returns nothing.
`onboarding_screen.dart:64-73` resolves
`motion.resolve(context, motion.screenTransition)` and uses `jumpToPage` when it is
`Duration.zero`, else `animateToPage` with `motion.screenTransitionCurve` — no literal
duration or curve. Test `changes page instantly when motion is reduced` taps `Next` with
`disableAnimations: true`, pumps one frame and finds screen 2. Drags go through
`PageView`'s own physics and are never checked against the reduced-motion flag.

[W1-6.2R.18]: PASS — `onboarding_screen.dart:95-101` — `PopScope` logic carried over
verbatim (`canPop: step == WelcomeStep.one`; on a blocked pop from step two,
`cubit.back()`). Because `back()` emits the step change, the same `_followStep` listener
that serves a button press moves the viewport to page 0, so back and a backward swipe
converge on the same visible result.

[W1-6.2R.19]: PASS — structural: `_onPageSettled` (`onboarding_screen.dart:48-55`) calls
only `cubit.back()` / `cubit.next()`, neither of which touches storage; `finish()` is
reached only from the `Skip` (`:141`) and `Get started` (`:165`) callbacks, and
`welcome_cubit.dart` is not in this commit at all. Asserted by
`verifyNever(preferences.setBool(...))` in both `moves to the second step without writing
the seen flag` and the forward-swipe test.

[W1-6.2R.20]: PASS — all four required cases exist and pass:
`moves to the second step when swiped forward without writing the seen flag`
(`welcome_screen_test.dart:170-181`, includes the `verifyNever`),
`returns to the first step when swiped backward` (`:183-190`),
`keeps the first page dot active while a drag is held` (`:192-209`),
`changes page instantly when motion is reduced` (`:211-218`). Every swipe test asserts
on the visible page, not on cubit state. No `matchesGoldenFile`, no `skip:`, no
commented-out test in the file.

[W1-6.2R.21]: PASS — `keeps the action row off the bottom system inset`
(`welcome_screen_test.dart:220-235`) pumps `bottomInset: 40` into `MediaQueryData.padding`
and asserts `safeAreaBottom - actionBottom == 24` — the copy block's own padding, with
the inset not re-added.

[W1-6.2R.22]: PASS — `_page(headline)` helper (`welcome_screen_test.dart:292-297`)
returns the `WelcomeContainer` ancestor of that page's headline, and every whole-tree
count is scoped through `find.descendant`: the green count (`:57`, `:96`), the dot counts
(`:55-56`, `:94-95`), the hero `Image` count (`:66-76`), and the `Skip`-absent assertion
(`:90-93`). All remain exact counts — nothing relaxed to `findsWidgets`, nothing deleted.

[W1-6.2R.23]: PASS — analyzer 0 errors / 2 warnings / 36 info, identical to baseline with
nothing attributed to a run file; full suite `+148 -13` with the 13 failures enumerated
above matching the recorded pre-existing set exactly; the onboarding widget file is
12/12 green.

## Architectural compliance
Status: PASS
FAILs: NONE
WARNINGs: NONE

Verified against `tdd.md`: `_WelcomeView` is stateful and creates/disposes the
`PageController` (`onboarding_screen.dart:37-44`); the composition is
`Scaffold → SafeArea → MultiBlocListener → BlocSelector<WelcomeCubit, WelcomeState,
WelcomeStep> → PopScope → PageView` exactly as designed (`:79-107`), with the static
shell outside the reactive boundary; `WelcomeLayoutConstants` lives in the feature's own
`lib/features/onboarding/const.dart`, not `lib/core/res/const.dart` and not inline;
`OnboardingScreen` stays stateless with `@RoutePage` and `getIt<WelcomeCubit>()`; no
`ValueKey` survives; no new file, no new package (`pubspec.yaml` untouched), no new token
or `.arb` key; `context.tokens` / `context.replaceRoute` used throughout, no
`Theme.of(context)` and no `Navigator`; no platform conditional and no iOS branch. The
`ContextExtensions.bottomPadding` getter is correctly left in place for
`ScrolledNavigationBar`.

The Phase 4B round-1 `listenWhen` removal (`onboarding_screen.dart:83-90`) is a
human-directed code-review change, not a `tdd.md` deviation — `tdd.md` never specified
`listenWhen`, and both listener bodies still self-guard (`:85` and `:58`/`:62`). Round 2
was doc-only. Both are reflected in the commit.

## Scope check
Status: PASS

`git show --stat dad0564` touches 9 files: the 7 allowlisted `MODIFY EXISTING` entries,
the allowlisted test file, and this run's `diff-summary.md` (a pipeline artifact, not
source). Nothing outside the allowlist. `git status --short` is empty — no uncommitted
change. No file appears in git that `diff-summary.md` failed to mention.

Note on method: `git diff --name-only 5bd84e8..dad0564` lists ~50 files, but every extra
one is a `.agents/` or `.claude/` artifact plus `.gitignore` — those paths were un-ignored
and first committed between the base SHA and the Dev commit (see the incident note in
`orchestrator-state.md`). None of them is in `dad0564` itself, which is the commit under
review. `orchestrator-state.md ## Deviation approvals` is `NONE` and `diff-summary.md`
declares no deviation — consistent.

## Documentation inconsistencies (non-blocking, not defects)

`orchestrator-state.md` contradicts itself in two places, harmless but worth correcting
before the next run reads it: line 52 records `Branch: feature/welcome-screens-header-rework`
while the commit actually sits on `claude/welcome-screens-polish-resume-una4wt`, and
line 57 still reads `Dev commit: NONE` where line 11 records `dad0564`. Both look like
stale lines left over from the reconstruction after the file-loss incident.

## Escalation required
NONE

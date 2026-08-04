# Task Brief
Source: Ticket `W1-6.2R` — "Welcome screens polish + global system UI convention (item 6.2)"
(`.agents/runs/welcome-screens-polish-20260804/tech-ac.md`)
Date: 2026-08-04

## Context

Pad and shorten the two welcome heroes, wrap them in `SafeArea` without double-counting the
bottom inset, make the two screens swipeable pages instead of an `AnimatedSwitcher`, and set
the app's system bar treatment once at startup as a standing convention.

## Testing mode

**smoke** — Rule applied: "UI-only with no new logic, isolated with no shared dependencies."

Justification: no API, model, repository, use case, cubit or state class is created or
modified. `WelcomeCubit.next()` / `back()` are reused as-is and `finish()` — the only
storage write — is not touched, so the `coverage` trigger for persistence does not fire;
this run changes no persistence path, it only has to prove the new gesture stays off it.
`test/cubit/onboarding/welcome_cubit_test.dart` already covers the cubit and is out of
scope.

**The mode does not shrink the required tests.** `[W1-6.2R.20]`–`[W1-6.2R.22]` name the
cases that must exist in `test/widget/onboarding/welcome_screen_test.dart`; deliver all of
them. No golden test, no `matchesGoldenFile`, no skipped or commented-out test.

## File allowlist

### CREATE NEW

None. Every change lands in an existing file.

### MODIFY EXISTING

`lib/bootstrap.dart` — set the global system UI overlay style before `runApp`.
`lib/features/onboarding/const.dart` — add `WelcomeLayoutConstants` (two hero heights, one content padding).
`lib/features/onboarding/presentation/widgets/welcome_hero.dart` — pad the content image only; fill and background stay full-bleed.
`lib/features/onboarding/presentation/widgets/welcome_container.dart` — stop adding the raw bottom system inset to the copy block's own bottom padding.
`lib/features/onboarding/presentation/screens/onboarding_screen.dart` — `SafeArea` shell; `_WelcomeView` becomes stateful and owns a `PageController`; `PageView` replaces `AnimatedSwitcher`; heights read from the new constants.
`.agents/references/onboarding-welcome-design-spec.md` — § 3 height row states the implemented heights.
`.agents/references/project-conventions.md` — new section recording the app-wide `SafeArea` + system-overlay-style rule.

### TEST FILES

`test/widget/onboarding/welcome_screen_test.dart` — re-scope whole-tree widget counts to the visible page, replace the `AnimatedSwitcher` assertion with an instant-page-change assertion, and add forward swipe, backward swipe, mid-drag indicator, and non-zero bottom-inset cases.

Do not edit `test/cubit/onboarding/welcome_cubit_test.dart` — the cubit is unchanged.

## Implementation plan

**Step 1** — `lib/features/onboarding/const.dart`: add a `WelcomeLayoutConstants` class next
to `WelcomeAssetConstants` with `static const double heroHeightOne = 240`,
`heroHeightTwo = 216`, `heroContentPadding = 24`.

**Step 2** — `lib/bootstrap.dart`: after `WidgetsFlutterBinding.ensureInitialized()` and
before `runApp`, call `SystemChrome.setSystemUIOverlayStyle` with a transparent status bar,
`AppColorTokens.dark.canvas` as the navigation bar colour, a transparent navigation bar
divider, and `Brightness.light` for both status-bar and navigation-bar icons. Import
`package:flutter/services.dart` (the codebase already pairs it with `material.dart`
elsewhere). Do not add an iOS-only `statusBarBrightness` field. Do not touch `main.dart` or
`main_prod.dart` — they already route through `bootstrap`.

**Step 3** — `lib/features/onboarding/presentation/widgets/welcome_hero.dart`: wrap the
content `Image.asset` — and only that one — in
`Padding(padding: EdgeInsets.all(WelcomeLayoutConstants.heroContentPadding))`. Leave the
`ClipRRect`, the `ColoredBox` fill, the background `Image.asset`, `BoxFit.contain` and the
`Stack`'s centring exactly as they are.

**Step 4** — `lib/features/onboarding/presentation/widgets/welcome_container.dart`: change
the copy block's `EdgeInsets.fromLTRB` bottom value from `24 + context.bottomPadding` to
`24`. Drop the now-unused `extensions.dart` import only if nothing else in the file uses it
(`context.tokens` does — so keep it). Change nothing else: the `LayoutBuilder` give-back,
the progress dots and all spacing stay as written.

**Step 5** — `lib/features/onboarding/presentation/screens/onboarding_screen.dart`: rework
`_WelcomeView` from `StatelessWidget` to `StatefulWidget`. The state creates a
`PageController` and disposes it. Build:
`Scaffold` → `SafeArea` → `MultiBlocListener` → `BlocSelector<WelcomeCubit, WelcomeState, WelcomeStep>`
→ `PopScope` → `PageView`.
- Listener 1 keeps the existing status listener verbatim (`finished` → `context.replaceRoute(const AuthRoute())`).
- Listener 2 fires on `previous.step != current.step` and moves the controller: target
  index `0` for `WelcomeStep.one`, `1` for `two`; return early if the controller has no
  clients or `controller.page?.round()` already equals the target; resolve the duration via
  `context.tokens.motion.resolve(context, context.tokens.motion.screenTransition)`; use
  `jumpToPage` when that duration is `Duration.zero`, otherwise `animateToPage` with
  `screenTransitionCurve`.
- `PopScope` keeps today's `canPop` / `onPopInvokedWithResult` logic unchanged.
- `PageView` takes the controller, `onPageChanged` calling
  `context.read<WelcomeCubit>().back()` for index `0` and `.next()` otherwise, and
  `children: const [_WelcomeStepOne(), _WelcomeStepTwo()]` in that order. Do not pass a
  `physics` argument — Android's default clamping already satisfies `[W1-6.2R.12]`.
- Remove `AnimatedSwitcher` and the two `ValueKey`s entirely. Do not add a page-change
  method to `WelcomeCubit`, and do not let any page-change path reach `finish()`.

**Step 6** — same file: replace the `heroHeight: 400` and `heroHeight: 356` literals in
`_WelcomeStepOne` / `_WelcomeStepTwo` with `WelcomeLayoutConstants.heroHeightOne` and
`heroHeightTwo`. Leave every button label, callback and placement untouched.

**Step 7** — `.agents/references/onboarding-welcome-design-spec.md`: in the § 3 table's
Height row, replace `flex: 0 0 400px` / `flex: 0 0 356px` and both
"(item 6.1/6.2: being reduced, see run notes)" placeholders with the heights the code
actually uses. Edit no other row.

**Step 8** — `.agents/references/project-conventions.md`: add a section stating, as an
app-wide rule and not as a description of onboarding, that every screen's body is wrapped in
`SafeArea` and that the system UI overlay style is one global default set once in
`bootstrap.dart` — transparent status bar, navigation bar area matching the app canvas —
never overridden per screen, and that a screen wanting different treatment is a deviation
requiring a decision.

**Step 9** — `test/widget/onboarding/welcome_screen_test.dart`:
- Add a helper that returns a page finder — the `WelcomeContainer` ancestor of that page's
  headline text — and re-scope `_countDots`, `_countGreen`, the hero `Image` count and the
  "`Skip` absent on screen 2" assertion to it with `find.descendant`. Scope them; do not
  relax an exact count to `findsWidgets` and do not delete an assertion.
- Give `_pumpWelcome` a bottom-inset parameter that feeds `MediaQueryData.padding`.
- Replace the `AnimatedSwitcher` duration test with a reduced-motion test that taps `Next`
  with `disableAnimations: true`, pumps a single frame, and asserts screen 2 is the visible
  page.
- Add: forward swipe reaches screen 2 and `verifyNever(preferences.setBool(...))`; backward
  swipe returns to screen 1; a held mid-drag leaves screen 1's active dot unchanged; a
  non-zero bottom inset does not increase the action row's distance from the safe-area edge.
- Keep every existing case that is not listed above.

**Generation checkpoint** — run `dart run build_runner build --delete-conflicting-outputs`
after step 9 and before running any test (`generation.md` § Build runner, item 4). The
`@GenerateMocks` targets are unchanged, so expect no diff in `welcome_screen_test.mocks.dart`;
run it anyway rather than assume.

**Final step** — run `flutter analyze` and `flutter test`, and compare against
`orchestrator-state.md`'s baselines quoted verbatim:
- `Analyzer baseline: 0 errors, 2 warnings, 36 info`
- `Test baseline: +144 -13 (157 total)`, the 13 failures confined to `test/api/games`,
  `test/api/game_detail`, `test/cubit/games`, `test/cubit/game_detail`,
  `test/repository/tracker`, `test/widget_test.dart`.

Neither suite is expected to be clean. Only a new error/warning attributable to this run's
files, or a new failure outside that recorded set, is yours. The 13 pre-existing failures
are exempt and must not be touched. `test/widget/onboarding/welcome_screen_test.dart` is
**not** exempt — it must be green at the end of the run.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: `[W1-6.2R.1]`–`[W1-6.2R.23]`

## Constraints

- **Allowlist is the write boundary.** `pubspec.yaml` is read-only. No new file.
- **No new package, no new token, no new localisation key, no `.arb` edit.** Nothing in
  this run needs one; if you think it does, escalate.
- **No golden test**, whatever a criterion says about appearance (`execution.md § Scope`).
- **The `[W1-6.31]` "no scroll-jacking" reversal is a confirmed product-owner decision**
  limited to this navigation gesture. Do not escalate the swipe as a spec violation and do
  not extend the reversal to anything else.
- **The onboarding-seen flag rules are frozen.** No new write path; no relaxing of any test
  that asserts them.
- Colours, durations and curves come from tokens via `context.tokens` — no literals in
  widget files (`dart-style.md`, `[W1-6.1]`–`[W1-6.7]`).
- Extracted UI is a widget class, never a function or getter returning `Widget`
  (`flutter-arch.md`).
- Reactive builders sit at the lowest state-consuming subtree; `Scaffold` and `SafeArea`
  stay outside them (`flutter-arch.md § Reactive boundary convention`).
- Feature-only constants live in `lib/features/onboarding/const.dart`, not in
  `lib/core/res/const.dart` and not inline in a widget (`execution.md § Code quality`).
- Comments: plain English, explain the why, few of them. No `///` line per constructor
  field that just restates its name (`project-conventions.md § Comments`).
- Style: single quotes, trailing commas on multi-line arg lists, 80-char lines,
  `context.tokens` not `Theme.of(context)`, `context.router` not `Navigator`
  (`dart-style.md`).
- Android portrait only. No platform conditional, no iOS branch, no landscape layout.
- `code-plan.md` is a shape sketch for the human gate. Where it and this brief disagree,
  **this brief wins** — unless `code-plan.md ## Approved feedback delta` exists, which
  overrides both.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make tests
pass. Do not add packages to `pubspec.yaml` or touch files outside the allowlist —
escalate instead.

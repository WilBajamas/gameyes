# QA Report
Source: Week-1 checklist item 6 — "Welcome screens" (ref `W1-6`), via `.agents/runs/welcome-screens-20260802/tech-ac.md`
Date: 2026-08-03
QA Agent version: 1.0

Overall result: FAIL

## Manual verification required
[W1-6.7] — Inspect both welcome steps in the running Android app — expect every visual value to resolve from tokens, with no raw colour, shadow, blur, or font-size literal in the approved extracted widget refactor.
[W1-6.11] — Open each welcome step — expect only a hero and bottom-anchored copy block, with no divider, border, or shadow between them.
[W1-6.12] — Open steps one and two at normal viewport height — expect flat indigo/magenta heroes, directional 88px bottom radii, and 400px/356px reference heights.
[W1-6.13] — Open each step — expect no more than two static, clipped ambient circles per hero.
[W1-6.14] — Open each step — expect one left-aligned blurred context chip at the specified top position and the specified copy.
[W1-6.15] — Open the route on a device — expect viewport-filling screens with no mock-device frame, hairline, or screen-label caption.
[W1-6.16] — Open step one — expect the three-cover fan at the specified geometry and a shadow only on its centre tile.
[W1-6.17] — Open cover tiles — expect flat drawn washes, not image assets or dashed placeholder slots.
[W1-6.18] — Open step one — expect the centre cover alone to show the Playing chip with a 5px dot.
[W1-6.19] — Open step one — expect the blurred three-pair stat pill with literal figures 312, 1,204, and 7.
[W1-6.20] — Open step two — expect flat key-art wash, not a gradient or image asset.
[W1-6.21] — Open step two — expect the fixed three-tile countdown, blurred tiles, and optically raised colons.
[W1-6.22] — Leave step two visible — expect fixed countdown values with no updates over time.
[W1-6.23] — Compare both steps — expect the mini-cover social-proof row only on step two.
[W1-6.24] — Advance from step one to two — expect the 22×5 active progress pill to move between the two 5×5 dots.
[W1-6.25] — Inspect both headlines — expect uppercase display styling and no terminal period.
[W1-6.26] — Inspect both bodies — expect one sentence, sentence case, terminal period, and 16/1.45 styling.
[W1-6.27] — Open step one — expect one green primary and a plain Skip text action with no fill, border, or elevation.
[W1-6.28] — Open step two — expect only the green Get started action.
[W1-6.29] — Inspect each step and keyboard focus — expect exactly one green element except the focus ring, black CTA label, and 44px minimum action height.
[W1-6.30] — Press and focus each action — expect 0.97 scale with no ripple/colour change and a 2px green outline at 2px offset.
[W1-6.31] — Tap Next with normal motion — expect the token-driven 420ms screen transition with no parallax, spring, or scroll-jacking.
[W1-6.32] — Enable reduced motion then tap Next — expect all transition motion to collapse.
[W1-6.40] — Exercise actions using touch and keyboard — expect every interactive target to be at least 44px and readable at AA contrast.
[W1-6.41] — Run at a 360×600 viewport and 1.5 text scale — expect no render overflow and bottom-anchored, scrollable copy.
[W1-6.43] — Run Flutter analysis and an Android debug build in an environment where Flutter commands complete — expect no new diagnostics over the recorded 0 errors, 2 warnings, 55 info baseline.
[W1-6.44] — Build Android portrait — expect no platform conditional, iOS branch, or landscape-specific behaviour.

## Static analysis
Status: FAIL
Errors: UNKNOWN — `flutter analyze` produced no diagnostics and timed out after 60 seconds.
Analyzer baseline: 0 errors, 2 warnings, 55 info. No comparison can be made because the command did not finish.
Build-runner freshness: NOT RUN — the required command can rewrite generated files; this QA run was explicitly constrained not to modify generated files or git state.

## Test results
Status: FAIL
Tests run: 0  |  Passed: 0  |  Failed: 0
Failing tests:
  `flutter test` for all four allowlisted tests produced no diagnostics and timed out after 60 seconds.
Test baseline: +121 -11, with six recorded pre-existing failures. No failing-set comparison can be made because the command did not finish.

## Coverage gaps
Runtime coverage was not collected: `--coverage` would rewrite the tracked coverage artifact, which this QA run was explicitly constrained not to modify. Static inspection finds tests for all stated success and failure/error cases: cubit transitions and persistence at `test/cubit/onboarding/welcome_cubit_test.dart:26`; widget rendering, both exits, no mid-flow write, reduced motion, and short/large layout at `test/widget/onboarding/welcome_screen_test.dart:41`.

## Acceptance criteria
[W1-6.1]: PASS — all nine welcome colours and the reuse of `surfaceIndigoPanel` are defined in `lib/config/theme/tokens/app_color_tokens.dart:102`.
[W1-6.2]: PASS — Electric Green is `Color(0xFF35ED7E)` in `lib/config/theme/tokens/app_color_tokens.dart:111` and asserted by `app_tokens_test.dart` “should pair a single green”.
[W1-6.3]: PASS — tokenised float shadow and blur are in `lib/config/theme/tokens/app_effect_tokens.dart:12`; their values are asserted at `test/widget/theme/app_tokens_test.dart:396`.
[W1-6.4]: PASS — all seven type tokens and corrected body height are in `lib/config/theme/tokens/app_type_tokens.dart:92` and `:129`.
[W1-6.5]: PASS — `mini: 5` and the corrected scale comment are in `lib/config/theme/tokens/app_radius_tokens.dart:5` and `:33`.
[W1-6.6]: PASS — each new token field is carried through token `copyWith`/`lerp`, e.g. effect at `lib/config/theme/tokens/app_tokens.dart:37` and `:57`.
[W1-6.7]: MANUAL — approved widget refactor moved visual implementation to files outside the original allowlist; inspect those widgets for the diff-level literal ban.
[W1-6.8]: PASS — `@RoutePage()` and the existing `OnboardingScreen` host remain at `lib/features/onboarding/presentation/screens/onboarding_screen.dart:18`.
[W1-6.9]: PASS — git diff confirms deletion of the three animation assets and `page_view_item.dart`; onboarding constants are absent from `lib/core/res/const.dart:26`.
[W1-6.10]: PASS — git diff from base to dev commit contains no guard change.
[W1-6.11]: MANUAL — verify running layout.
[W1-6.12]: MANUAL — verify running layout.
[W1-6.13]: MANUAL — verify running layout.
[W1-6.14]: MANUAL — verify running layout.
[W1-6.15]: MANUAL — verify running layout.
[W1-6.16]: MANUAL — verify running layout.
[W1-6.17]: MANUAL — verify running layout.
[W1-6.18]: MANUAL — verify running layout.
[W1-6.19]: MANUAL — verify running layout.
[W1-6.20]: MANUAL — verify running layout.
[W1-6.21]: MANUAL — verify running layout.
[W1-6.22]: MANUAL — verify running behaviour.
[W1-6.23]: MANUAL — verify running layout.
[W1-6.24]: MANUAL — verify running layout.
[W1-6.25]: MANUAL — verify running typography.
[W1-6.26]: MANUAL — verify running typography.
[W1-6.27]: MANUAL — verify running action appearance.
[W1-6.28]: MANUAL — verify running action appearance.
[W1-6.29]: MANUAL — verify running action and focus appearance.
[W1-6.30]: MANUAL — verify running press/focus interaction.
[W1-6.31]: MANUAL — verify running transition; token wiring is present at `lib/features/onboarding/presentation/screens/onboarding_screen.dart:54`.
[W1-6.32]: MANUAL — verify reduced-motion transition; the zero-duration assertion is present at `test/widget/onboarding/welcome_screen_test.dart:100`.
[W1-6.33]: PASS — both ARB files have 141 matching non-metadata keys, no retired onboarding-description keys, and all required welcome additions at `lib/l10n/intl_en.arb:6` and `lib/l10n/intl_zh.arb:6`.
[W1-6.34]: PASS — approved deviation: generated localisation files were directly updated after generator timeout, recorded in `orchestrator-state.md` deviation approval.
[W1-6.35]: PASS — approved generated accessors are present at `lib/generated/l10n.dart:1062` through `:1178`.
[W1-6.36]: PASS — `WelcomeCubit.finish()` writes the existing key at `lib/features/onboarding/presentation/blocs/welcome_cubit.dart:21`; both widget exits call it at `onboarding_screen.dart:134` and `:153`.
[W1-6.37]: PASS — `next()` changes only `step` at `welcome_cubit.dart:13`; `verifyNever` coverage is defined at `welcome_cubit_test.dart:30`.
[W1-6.38]: PASS — no guard change appears in the base-to-dev git diff, and the reused key remains `StorageConstants.firstUseKey` at `lib/core/res/const.dart:30`.
[W1-6.39]: PASS — finished status replaces the route with `HomeRoute` at `onboarding_screen.dart:36`; system back returns step two to one at `:47`.
[W1-6.40]: MANUAL — verify running accessibility.
[W1-6.41]: MANUAL — runtime test is defined at `welcome_screen_test.dart:112` but could not run.
[W1-6.42]: PASS — prescribed widget tests are located at `test/widget/onboarding/welcome_screen_test.dart:41` and cover each named scenario; no golden matcher is present.
[W1-6.43]: MANUAL — analyzer and Android debug build could not complete in this workspace.
[W1-6.44]: MANUAL — verify Android portrait build; allowed implementation files contain no platform branch.

## Architectural compliance
Status: PASS
FAILs:
  NONE
WARNINGs:
  Approved deviation: the human-approved widget refactor adds extracted welcome/widget files outside the original allowlist and contradicts the original co-location preference in `tdd.md`; approval is recorded at `orchestrator-state.md:36` and is not re-litigated.
  Approved deviation: generated localisation files were directly updated after Flutter Intl generation timed out; approval is recorded at `orchestrator-state.md:35`.
  Git scope verification found `.gitignore`, extracted widget files, and unrelated generated outputs outside the allowlist. The explicit 2026-08-03 approval for the full current working tree covers this deviation. Working tree is clean.

## Escalation required
Flutter analysis and all required tests time out without diagnostics → route to: Human. A functioning Flutter environment is required to complete the runtime/analyzer gate; no implementation defect is evidenced by the timed-out commands.

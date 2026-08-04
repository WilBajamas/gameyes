# Diff Summary
Source: Ticket `W1-6.2R` — "Welcome screens polish + global system UI convention (item 6.2)"
Date: 2026-08-04
Branch: claude/welcome-screens-polish-resume-una4wt
Commit: dad05648212ea00119fe915bf666e2d7e36a546c

## Revision round 1 (Phase 4B code review)

Human asked to remove the redundant `listenWhen` from both `BlocListener`s in
`_WelcomeViewState.build()`'s `MultiBlocListener` — each listener body already
guards itself correctly (the status listener via
`if (state.status == WelcomeStatus.finished)`, the step listener via
`_followStep`'s own `if (_controller.page?.round() == target) return;`), so
`listenWhen` was pure optimization, not required for correctness. Removed the
`listenWhen:` parameter from both `BlocListener` widgets in
`lib/features/onboarding/presentation/screens/onboarding_screen.dart`, keeping
them as two separate listeners inside the `MultiBlocListener` (not merged).
Ran `dart format` on the file. Updated the matching implementation-sketch
snippet in `code-plan.md` (~line 163–175) to drop the same two `listenWhen`
parameters — the only doc in the repo that embedded this now-stale detail;
`tdd.md`, `task-brief.md`, `project-conventions.md`, and
`onboarding-welcome-design-spec.md` were left untouched as none describe this
implementation-level detail.

Pure code-quality simplification, no behavior change. Re-verified:
- `flutter analyze` — 38 issues (2 warnings, 36 info), unchanged from baseline.
- `flutter test test/widget/onboarding/welcome_screen_test.dart` — 12/12 green,
  unchanged.
- `flutter test` (full suite) — `+148 -13` (161 total), identical to the first
  pass's recorded result; same pre-existing failing set, no regression.

## Revision round 2 (Phase 4B code review)

Doc-only, no code change. Human asked to codify round 1's `listenWhen` catch
as a standing convention: added a short paragraph to
`project-conventions.md`'s "BLoC / Cubit provisioning in screens" section
(the first section in the file) — don't add `listenWhen` to a `BlocListener`
when the listener body already guards the same condition itself; only add it
when it changes behavior (skips real work) or is the sole guard. No other
file touched.

Nothing executable changed, so the analyzer/test baseline from round 1 still
applies as-is — not re-run.

## Files created

None.

## Files modified

`lib/features/onboarding/const.dart` — added `WelcomeLayoutConstants` (`heroHeightOne = 240`, `heroHeightTwo = 216`, `heroContentPadding = 24`).
`lib/bootstrap.dart` — added one `SystemChrome.setSystemUIOverlayStyle` call before `runApp`, reading `AppColorTokens.dark.canvas` for the navigation bar colour.
`lib/features/onboarding/presentation/widgets/welcome_hero.dart` — wrapped only the content `Image.asset` in `Padding(EdgeInsets.all(WelcomeLayoutConstants.heroContentPadding))`; fill, background and clip untouched.
`lib/features/onboarding/presentation/widgets/welcome_container.dart` — copy block's bottom padding dropped `+ context.bottomPadding`, now a flat `24`.
`lib/features/onboarding/presentation/screens/onboarding_screen.dart` — `_WelcomeView` rewritten `StatelessWidget` → `StatefulWidget` owning a `PageController`; `Scaffold → SafeArea → MultiBlocListener → BlocSelector → PopScope → PageView` replaces the old `AnimatedSwitcher` structure; `_WelcomeStepOne`/`_WelcomeStepTwo` read hero heights from the new constants and lost their `ValueKey`s. Revision round 1: removed the redundant `listenWhen` from both `BlocListener`s (see below).
`.agents/references/onboarding-welcome-design-spec.md` — § 3 height row now states `240px` / `216px`, placeholders removed.
`.agents/references/project-conventions.md` — new "System bars and SafeArea" section recording the app-wide `SafeArea` + system-overlay-style convention. Revision round 2: added a short paragraph to the "BLoC / Cubit provisioning in screens" section on when `listenWhen` is/isn't warranted (doc-only).

## Test files

`test/widget/onboarding/welcome_screen_test.dart` — re-scoped `_countDots`/`_countGreen`/hero-image/`Skip`-absence assertions to the visible page via a new `_page(headline)` helper; replaced the `AnimatedSwitcher` duration test with a reduced-motion instant-page-change test; added forward-swipe, backward-swipe, mid-drag-dot, and non-zero-bottom-inset cases. 12 tests total (was 8), all green.

## Self-corrections

NONE — every check passed first attempt.

## Deviations from implementation plan

NONE — plan followed exactly, steps 1–9 in order.

## Verification against baseline

- `dart run build_runner build --delete-conflicting-outputs` — ran after test-file authoring per the generation checkpoint; no diff in `welcome_screen_test.mocks.dart` (Mockito targets unchanged), confirmed via `git status`.
- `flutter analyze` — 38 issues (2 warnings, 36 info), matching the recorded baseline (`0 errors, 2 warnings, 36 info`) exactly. No new error or warning; no issue in any file this run touched.
- `flutter test` — `+148 -13` (161 total). The 13 failures are exactly the recorded pre-existing set (`test/api/games`, `test/api/game_detail`, `test/cubit/games`, `test/cubit/game_detail`, `test/repository/tracker`, `test/widget_test.dart`), untouched. `test/widget/onboarding/welcome_screen_test.dart` is fully green (12/12).

## Acceptance criteria status

[W1-6.2R.1]: satisfied
[W1-6.2R.2]: satisfied
[W1-6.2R.3]: satisfied
[W1-6.2R.4]: satisfied
[W1-6.2R.5]: satisfied
[W1-6.2R.6]: satisfied
[W1-6.2R.7]: satisfied
[W1-6.2R.8]: satisfied
[W1-6.2R.9]: satisfied
[W1-6.2R.10]: satisfied
[W1-6.2R.11]: satisfied
[W1-6.2R.12]: satisfied
[W1-6.2R.13]: satisfied
[W1-6.2R.14]: satisfied
[W1-6.2R.15]: satisfied
[W1-6.2R.16]: satisfied
[W1-6.2R.17]: satisfied
[W1-6.2R.18]: satisfied
[W1-6.2R.19]: satisfied
[W1-6.2R.20]: satisfied
[W1-6.2R.21]: satisfied
[W1-6.2R.22]: satisfied
[W1-6.2R.23]: satisfied

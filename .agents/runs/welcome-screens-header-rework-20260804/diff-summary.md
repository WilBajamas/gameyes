# Diff Summary
Source: Ticket `W1-6.1R` — "Welcome screens header rework (item 6.1)"
Date: 2026-08-04
Branch: feature/welcome-screens-header-rework
Commit: 5bd84e8abb593208be32f2d50debdeee516b3d9a

## Files created
lib/features/onboarding/presentation/widgets/welcome_hero.dart — `WelcomeHero`, a public stateless widget painting the rounded hero panel (clip, optional flat/asset background, centred contain-fitted content image); `WelcomeAssetConstants` holds the three finished welcome-hero asset paths beside it. Per Phase 3 delta override.

## Files modified
lib/core/res/const.dart — added a doc comment above `AssetConstants` recording that it holds app-wide asset constants; no member added or removed (Phase 3 delta override of task-brief Step 1).
lib/features/onboarding/presentation/widgets/welcome_container.dart — dropped `heroContent`/`socialProof` and the internally resolved `heroHeight`/`headline`/`body`/`chip`; constructor now takes `step`, `heroHeight`, `hero`, `headline`, `body`, `actions`. Removed the `ClipRRect`+`Stack` hero paint (moved to `WelcomeHero`), both ambient circles, the `GlassSurface` context chip, the social-proof slot and its trailing 18px gap. `const.dart`, `l10n` and `glass_surface_widget.dart` imports dropped. Shortfall clamp, dots, type styles and every surviving spacing value unchanged.
lib/features/onboarding/presentation/screens/onboarding_screen.dart — `_WelcomeStepOne`/`_WelcomeStepTwo` now resolve their own `heroHeight`, `headline`, `body` and build a `WelcomeHero` (screen 1: `surfaceIndigoPanel` background colour; screen 2: `heroTwoBackground` asset), passed into `WelcomeContainer`. `_WelcomeSocialProof` deleted. Imports of `cover_tile.dart`, `welcome_key_art.dart`, `welcome_stat_pill.dart` removed; `welcome_hero.dart` added.
lib/l10n/intl_en.arb — removed the ten keys named in `[W1-6.1R.14]` (welcome_chip_one/two, welcome_stat_tracked/hours/playing, welcome_social_proof, welcome_countdown_title/days/hours/minutes). No key added; every other key, including `playing`, untouched.
lib/l10n/intl_zh.arb — same ten keys removed, same positions; both files end with identical key sets.

## Files deleted
lib/features/onboarding/presentation/widgets/cover_tile.dart — `CoverTile`, its wash panel and the `Playing` status chip; last callers went in this run.
lib/features/onboarding/presentation/widgets/welcome_key_art.dart — `WelcomeKeyArt` plus private `_CountdownLabel`, `_WelcomeCountdownTile`, `_WelcomeCountdownColon`.
lib/features/onboarding/presentation/widgets/welcome_stat_pill.dart — `WelcomeStatPill` plus private `_WelcomeLabel`, `_WelcomeStatPair`.

## Assets (already on disk, committed as-is)
assets/images/welcome-1-header.png
assets/images/welcome-2-header.png
assets/images/welcome-2-header-bg.png

## Test files
test/widget/onboarding/welcome_screen_test.dart — rewritten. Kept the harness, mocks and item 6's six surviving behaviours (first-step copy/dots/green count, step-two copy with no Skip and no flag write, Skip writes the flag and replaces the route, Get started writes the flag and replaces the route, reduced-motion collapses the switcher duration, no overflow at 360x600/1.5 text scale — extended to settle on step two as well). Added `_assetImage` helper matching on `AssetImage.assetName`, and two new tests: screen 1 renders `WelcomeAssetConstants.heroOne` exactly once and is the only `Image` on screen (no background), screen 2 renders `heroTwo` and `heroTwoBackground` once each and `heroOne` no longer renders. Deleted every assertion on cover tiles, the status chip, the stat pill, the context chip, key art, countdown or social proof. No `matchesGoldenFile`, no `skip:`, no commented-out test.
`test/widget/onboarding/welcome_screen_test.mocks.dart` — regenerated no-op (build_runner ran to confirm mocks match the source tree; `@GenerateMocks` unchanged, only line-ending noise in `git diff`).

## Self-corrections
Commit-pass fix (mechanical, not a content edit to human-authored changes): after the
human's approved move of `WelcomeAssetConstants` from `welcome_hero.dart` into the new
`lib/features/onboarding/const.dart`, `test/widget/onboarding/welcome_screen_test.dart`
no longer compiled — it referenced `WelcomeAssetConstants` without importing the new
file (4 `undefined_identifier` errors). Added the missing import
(`features/onboarding/const.dart`) and removed the now-unused `welcome_hero.dart`
import that the test no longer needs. `flutter analyze` and `flutter test` on the file
are clean/green after the fix; no assertion, comment or behaviour was altered.

## Deviations from implementation plan
Implementation followed `code-plan.md ## Approved feedback delta` in full, which is authoritative over `task-brief.md`'s original step list per this run's instructions. Concretely: `WelcomeHero` is a new public file/class (not a private `_WelcomeHero` in `welcome_container.dart`), `AssetConstants` gained no members (doc comment only), the three asset paths live in `WelcomeAssetConstants` in `welcome_hero.dart`, and `WelcomeContainer` takes resolved `heroHeight`/`hero`/`headline`/`body` inputs rather than deriving them from `step`. All of this matches the delta's skeletons and revised file lists verbatim; no further deviation from the delta itself.

`dart run build_runner build --delete-conflicting-outputs` regenerated a handful of unrelated pre-existing generated files (`lib/config/route/auto_route_config.gr.dart`, `lib/core/di/service_locator.config.dart`, `lib/features/auth/presentation/blocs/sign_in_state.freezed.dart`, `test/widget/auth/auth_screen_test.mocks.dart`) — confirmed via `git diff` to be line-ending normalization only (CRLF/LF), no content change, and outside this run's allowlist; left as the working tree produced them, untouched by hand.

## Verification against baseline
`flutter analyze` (full project): 38 issues (2 warnings, 36 info) — matches the recorded baseline (0 errors, 2 warnings, 36 info) exactly; no new error or warning, and none of the 38 issues is in a file this run touched.
`flutter test` (full suite): +146 -11, against baseline +142 -13. The two `test/widget/onboarding/welcome_screen_test.dart` failures recorded as pre-existing/in-scope are now green (net effect: +4 total tests from the file's 6→8 test count, -2 failures). The remaining 11 failures are exactly the other pre-existing failures recorded in `orchestrator-state.md` (games/game_detail API and cubit tests, tracker repository tests, `test/widget_test.dart`) — untouched, still exempt.
`dart run build_runner build --delete-conflicting-outputs` — ran once after the test file was written; `welcome_screen_test.mocks.dart` regenerated as a no-op (`@GenerateMocks` unchanged).

## Acceptance criteria status
[W1-6.1R.1]: satisfied — heroes stay a code-rendered `WelcomeHero` widget with `heroShape` radius and the unchanged 400/356 heights, full width via the `SizedBox` slot.
[W1-6.1R.2]: satisfied — screen 1 passes `backgroundColor: context.tokens.color.surfaceIndigoPanel`, no `backgroundAsset`.
[W1-6.1R.3]: satisfied — screen 2 passes `backgroundAsset: WelcomeAssetConstants.heroTwoBackground`, `BoxFit.cover`, clipped by the same `ClipRRect`.
[W1-6.1R.4]: satisfied — content image is `BoxFit.contain` inside `Stack(fit: StackFit.expand)`, default (centered) alignment, verified per-screen in the widget test by asset key.
[W1-6.1R.5]: satisfied — content image composites directly over the fill/background layer in the same `Stack`; no panel, card or scrim between them.
[W1-6.1R.6]: satisfied — neither `Image.asset` call takes an `errorBuilder`; no placeholder/spinner widget added.
[W1-6.1R.7]: satisfied — both ambient-circle `Positioned` blocks removed from `welcome_container.dart`, none reintroduced in `welcome_hero.dart`.
[W1-6.1R.8]: satisfied — context chip, status chip, stat pill, cover tiles, key art/wash, countdown title/tiles/colons all deleted with their source files; grep across `lib/` and `test/` (excluding `lib/generated/`) finds no reference.
[W1-6.1R.9]: satisfied — no `Ticker`, `Stream.periodic` or date arithmetic exists anywhere in the touched files; the countdown widget that owned it is deleted.
[W1-6.1R.10]: satisfied — `_WelcomeSocialProof` deleted, its 18px trailing gap removed, no replacement element; copy block now runs hero → dots → headline → body → actions with the dots row first.
[W1-6.1R.11]: satisfied — `pubspec.yaml` untouched; all three PNGs referenced via `assets/images/` through `PathConstants.imagePath` composed in `WelcomeAssetConstants`.
[W1-6.1R.12]: satisfied — no file under `lib/config/theme/tokens/` in the diff.
[W1-6.1R.13]: satisfied — every colour/radius in `welcome_hero.dart` and `welcome_container.dart` resolves through `context.tokens`; no raw `Color(0x…)`, literal shadow/blur or sized `TextStyle`.
[W1-6.1R.14]: satisfied — the same ten keys removed from both `.arb` files; `playing`, `next`, `skip`, `get_started`, `welcome_headline_one/two`, `welcome_body_one/two` all retained; no key added.
[W1-6.1R.15]: satisfied — `lib/generated/l10n.dart` and `lib/generated/intl/*` not touched; `flutter gen-l10n` not run; branch compiles (analyzer clean of new issues, tests run).
[W1-6.1R.16]: satisfied — both `Image.asset` calls in `WelcomeHero` set `excludeFromSemantics: true`; no semantic label or new copy added.
[W1-6.1R.17]: satisfied — `LayoutBuilder` shortfall clamp retained unchanged and now governs `hero`; widget test pumps 360x600 at 1.5 text scale across both steps with `tester.takeException()` asserted null.
[W1-6.1R.18]: satisfied — every removed-element assertion deleted (not skipped/commented); each screen's test asserts its hero content asset renders exactly once by asset key; no `matchesGoldenFile`.
[W1-6.1R.19]: satisfied — see Verification against baseline; analyzer issue count matches baseline exactly, no new error/warning attributable to this run's files.
[W1-6.1R.20]: satisfied — `test/widget/onboarding/welcome_screen_test.dart` is fully green (8/8); no longer appears in the failing-test list.

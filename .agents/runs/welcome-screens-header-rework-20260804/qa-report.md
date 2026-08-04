# QA Report
Source: Ticket `W1-6.1R` — "Welcome screens header rework (item 6.1)"
Date: 2026-08-04

Overall result: PASS — pending manual checks

## Manual verification required

[W1-6.1R.3] — Open the onboarding flow, tap Next to reach welcome screen 2 — expect
`welcome-2-header-bg.png` to fill the whole 356-high hero edge to edge with its aspect
ratio intact, overflow cropped, no magenta or background colour visible at any edge, and
the art trimmed cleanly by the 88px bottom-left/bottom-right corners. Code is correct
(`BoxFit.cover` inside `ClipRRect(heroShape)`); only the on-device framing needs an eye.

[W1-6.1R.4] — Open welcome screen 1, then screen 2 — expect each hero's content art
(`welcome-1-header.png`, `welcome-2-header.png`) to sit wholly inside the hero, centred
horizontally and vertically, undistorted and uncropped, with all baked-in English text
readable. `BoxFit.contain` with default alignment guarantees the geometry; the tech-ac
explicitly assigns the resulting framing and the legibility of the baked-in text to this
manual check (`tech-ac.md ## Out of scope`).

[W1-6.1R.5] — Same two screens — expect no rectangular edge, seam or lighter/darker box
around the content art, i.e. both PNGs' transparent regions really are transparent so the
art composites straight onto the indigo fill (screen 1) and onto the background image
(screen 2). The widget tree has nothing between the two layers; this check is about the
files themselves.

## Static analysis
Status: PASS
Errors: NONE

`dart run build_runner build --delete-conflicting-outputs` — succeeded, 66 outputs
written, no new content in any allowlisted file.
`flutter analyze` — 38 issues (0 errors, 2 warnings, 36 info), identical to the recorded
`Analyzer baseline: 0 errors, 2 warnings, 36 info`. No issue is attributed to a file this
run created, modified or deleted; the 2 warnings remain in
`lib/features/tracker/presentation/screens/task_detail_screen.dart`.
`flutter build apk --debug` — succeeded (`build/app/outputs/flutter-apk/app-debug.apk`).

## Test results
Status: PASS
Tests run: 8  |  Passed: 8  |  Failed: 0
Failing tests: NONE

Testing mode is `smoke`, so the allowlisted test file was run:
`test/widget/onboarding/welcome_screen_test.dart` — 8/8 green, clearing the two
pre-existing failures `orchestrator-state.md` records for that file.

A whole-suite run was also started to re-confirm the `+142 -13` test baseline, but it did
not finish inside QA's time budget (the suite's pre-existing API/network tests are
long-running). Smoke mode does not require it, and no allowlisted file is imported by any
test outside `test/widget/onboarding/`, so no regression path is left unexercised. The
Dev-reported whole-suite figure of `+146 -11` is therefore recorded here as reported, not
as independently reproduced.

## Coverage gaps (coverage mode only)
N/A — testing mode is `smoke`.

## Pre-QA checks
Reviewed commit `5bd84e8` is HEAD of `feature/welcome-screens-header-rework` and matches
`orchestrator-state.md`. `git diff --name-status 9c31eec..5bd84e8` returns 14 paths, all
inside the effective allowlist:

- Allowlist as written in `task-brief.md`, as revised by `code-plan.md ## Approved
  feedback delta` (which adds `lib/features/onboarding/presentation/widgets/welcome_hero.dart`
  as CREATE NEW), plus `lib/features/onboarding/const.dart` covered by the
  `orchestrator-state.md ## Deviation approvals` line dated 2026-08-04T20:15:00+08:00.
- Both deviations named in `diff-summary.md` have a matching approval line. No scope
  violation, and no file appears in git that `diff-summary.md` failed to declare.
- `pubspec.yaml`, `lib/config/theme/tokens/**` and `lib/generated/**` are absent from the
  diff, as required.

Uncommitted changes, reported not blocking: four generated files are dirty in the working
tree — `lib/config/route/auto_route_config.gr.dart`,
`lib/core/di/service_locator.config.dart`,
`lib/features/auth/presentation/blocs/sign_in_state.freezed.dart` and
`test/widget/auth/auth_screen_test.mocks.dart`. Git reports them as CRLF/LF line-ending
normalisation only, they are generated outputs of sources outside this run, and QA's own
`build_runner` invocation reproduces the same state. They belong to the repository's
line-ending configuration, not to this feature, and should be resolved separately.

## Acceptance criteria

[W1-6.1R.1]: PASS — `welcome_hero.dart:19-21` renders `ClipRRect(borderRadius:
context.tokens.radius.heroShape)` over a `Stack`, never a bare image;
`app_radius_tokens.dart:41-44` is `BorderRadius.only(bottomLeft: 88, bottomRight: 88)`.
Heights 400 and 356 survive as `onboarding_screen.dart:79` and `:112`, consumed by
`welcome_container.dart:40` (`SizedBox(height: resolvedHeroHeight, child: hero)`), which
imposes no width constraint so the hero spans the `Column`'s full width.

[W1-6.1R.2]: PASS — `onboarding_screen.dart:80-83` passes
`backgroundColor: context.tokens.color.surfaceIndigoPanel` and no `backgroundAsset`;
`app_color_tokens.dart:105` is `Color(0xFF2F3782)`. Test
`'shows the first hero art once and no background image'` asserts
`find.byType(Image)` is `findsOneWidget` on screen 1, proving no background image exists.

[W1-6.1R.3]: MANUAL — code verified: `onboarding_screen.dart:113-116` passes
`backgroundAsset: WelcomeAssetConstants.heroTwoBackground` with no colour, and
`welcome_hero.dart:25-30` paints it with `fit: BoxFit.cover` inside the `ClipRRect`. The
old `ColoredBox` magenta branch is gone from `welcome_container.dart`. Test
`'shows the second hero art and its background once each'` asserts it renders exactly
once. See the manual check above for the on-device framing.

[W1-6.1R.4]: MANUAL — code verified: `welcome_hero.dart:31-35` is a single
`Image.asset(contentAsset, fit: BoxFit.contain)` with default (centre) alignment inside
`Stack(fit: StackFit.expand)`. Tests
`'shows the first hero art once and no background image'` and
`'shows the second hero art and its background once each'` pin the per-screen asset key to
exactly one occurrence and assert `heroOne` is absent on screen 2. See the manual check
above for framing and baked-in text legibility.

[W1-6.1R.5]: PASS — `welcome_hero.dart:21-36`: the `Stack` holds only the conditional
background layer(s) and the content image; there is no `Container`, `Card`, `Padding`,
`DecoratedBox` or scrim between them. PNG transparency is covered by the manual check
above rather than by this criterion's widget-tree clause.

[W1-6.1R.6]: PASS — neither `Image.asset` call (`welcome_hero.dart:26-30` and `:31-35`)
takes `errorBuilder`, `frameBuilder` or a placeholder, and no fallback widget was added.
Hero size comes from `welcome_container.dart:40`'s `SizedBox`, which is independent of
image resolution, so a missing asset cannot collapse the layout or shift the copy block.

[W1-6.1R.7]: PASS — the two 180x180 ambient-circle `Positioned` blocks present at
`9c31eec:welcome_container.dart:73-74` are gone from the current file, and
`welcome_hero.dart` contains no circle, `BoxShape.circle` or decorative `Positioned`.

[W1-6.1R.8]: PASS — `git diff --name-status` shows `D` for `cover_tile.dart`,
`welcome_key_art.dart` and `welcome_stat_pill.dart`; `grep` across `lib/` and `test/`
(excluding `lib/generated/`) for `CoverTile`, `WelcomeKeyArt`, `WelcomeStatPill`,
`_WelcomeSocialProof` and the three filenames returns nothing. `GlassSurface` no longer
appears in `welcome_container.dart` (its import is dropped), and
`lib/widgets/glass_surface_widget.dart` is correctly retained per `tdd.md ## Out of scope`.

[W1-6.1R.9]: PASS — `grep` for `Ticker`, `Stream.periodic` and `Timer(` across
`lib/features/onboarding/` returns nothing; the countdown's owning file is deleted.

[W1-6.1R.10]: PASS — the `if (socialProof != null) ...[socialProof!, SizedBox(height: 18)]`
block at `9c31eec:welcome_container.dart:133-135` is gone with nothing in its place; the
dots `Row` is now the first child of the copy column (`welcome_container.dart:55`). Every
surviving spacing value is byte-identical to item 6: dots 22/5 with a 6 gap
(`:58,:67,:69`), `isFirstStep ? 22 : 18` (`:80`), `12` (`:85`), `isFirstStep ? 28 : 24`
(`:92`), and padding `24 / 28|24 / 24 / 24 + bottomPadding` (`:44-49`).

[W1-6.1R.11]: PASS — `pubspec.yaml` is not in the diff; `pubspec.yaml:146-149` already
registers `assets/images/`. All three paths are composed from `PathConstants.imagePath` in
`lib/features/onboarding/const.dart:4-7`; no density-variant folder and no dependency
change. The three PNGs exist on disk and are committed as `A` in `5bd84e8`.

[W1-6.1R.12]: PASS — no path under `lib/config/theme/tokens/` appears in
`git diff --name-only 9c31eec..5bd84e8`.

[W1-6.1R.13]: PASS — `grep` for `Color(0x`, `BoxShadow(`, `sigma`, `fontSize` and
`TextStyle(` across `welcome_hero.dart`, `welcome_container.dart`,
`features/onboarding/const.dart` and `onboarding_screen.dart` returns nothing. Colours,
radii and type all resolve through `context.tokens` (`welcome_hero.dart:20`;
`welcome_container.dart:26-27, 61, 63, 72, 83, 88-89`;
`onboarding_screen.dart:82`).

[W1-6.1R.14]: PASS — `git diff 9c31eec..5bd84e8 -- lib/l10n/*.arb` shows exactly the ten
named keys removed from both files and nothing else changed. `playing` survives at
`intl_en.arb:30` and `intl_zh.arb:30`; both files hold 174 keys. No key added, and no
reference to any removed key survives in `lib/` or `test/` outside `lib/generated/`.

[W1-6.1R.15]: PASS — no path under `lib/generated/` is in the diff, `flutter gen-l10n` was
not run, `flutter analyze` reports 0 errors and `flutter build apk --debug` succeeds, so
the branch compiles with the stale accessors in place. No halt was raised over them.

[W1-6.1R.16]: PASS — both `Image.asset` calls set `excludeFromSemantics: true`
(`welcome_hero.dart:29` and `:34`). No `Semantics`, `semanticLabel` or new string was
introduced; the `.arb` diff adds no key.

[W1-6.1R.17]: PASS — the shortfall clamp is retained verbatim
(`welcome_container.dart:36-37`, matching `9c31eec:welcome_container.dart:41`) and now
governs the hero slot that holds the image. Test
`'does not overflow on a short viewport with larger text'` pumps 360x600 at text scale 1.5
and asserts `tester.takeException()` is null on step one and again after advancing to
step two.

[W1-6.1R.18]: PASS — `test/widget/onboarding/welcome_screen_test.dart` holds no assertion
on any removed element; `grep` for `matchesGoldenFile` and `skip:` under
`test/widget/onboarding/` returns nothing, and no commented-out test remains. Per-screen
asset-key assertions are at `:62-63` and `:91-96` via the `_assetImage` predicate
(`:213-220`) matching on `AssetImage.assetName`. Item 6's surviving coverage is intact:
headline/body/dots/green (`:50-54`, `:74-79`), Next not writing the flag (`:80`), Skip
writing it and replacing the route (`:110-114`), Get started likewise (`:130-134`), and
reduced-motion collapse (`:146`).

[W1-6.1R.19]: PASS — `flutter analyze` returns 38 issues (0 errors, 2 warnings, 36 info),
matching the baseline exactly with no new error or warning in any file this run touched,
and `flutter build apk --debug` completes successfully. The info count did not drop as the
brief anticipated, because all 36 infos already sat in untouched files; that is neither a
regression nor a criterion breach.

[W1-6.1R.20]: PASS — `flutter test test/widget/onboarding/welcome_screen_test.dart` reports
`+8: All tests passed!`. The two failures `orchestrator-state.md` records for this file are
resolved; no other recorded pre-existing failure was touched.

## Architectural compliance
Status: PASS
FAILs: NONE
WARNINGs:
- `tdd.md ## UI layer` specifies `_WelcomeHero` as a private class inside
  `welcome_container.dart` and `AssetConstants` gaining three filename entries. The
  implementation instead has a public `WelcomeHero` in its own file and no new
  `AssetConstants` member. This is not a deviation to escalate: `code-plan.md ## Approved
  feedback delta` (Phase 3 human review) states it is authoritative over `tdd.md` and
  `task-brief.md` and that neither would be rewritten. `tdd.md` is therefore stale on this
  point and is worth correcting before it is cited by a later run.
- `tdd.md` also states `WelcomeContainer` consumes `S.current` and derives height, headline
  and body from `step`. The delta moved all four to constructor inputs; `step` survives
  and now drives only the dot state and the three spacing branches
  (`welcome_container.dart:17, 30`). Same staleness, same approved source.

Verified against `tdd.md` and the delta: file paths and class names match the delta's
revised file lists exactly (`WelcomeHero` in
`lib/features/onboarding/presentation/widgets/welcome_hero.dart`, `WelcomeAssetConstants`
relocated to `lib/features/onboarding/const.dart` under the approved deviation); no layer
below presentation is touched (`welcome_cubit.dart`, `welcome_state.dart`, routing, DI and
persistence are absent from the diff); no package added; UI is extracted as widget classes,
never `Widget`-returning functions; `lib/widgets/glass_surface_widget.dart` retained as
specified.

## Escalation required
NONE

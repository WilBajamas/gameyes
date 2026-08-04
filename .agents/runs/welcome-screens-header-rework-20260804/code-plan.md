# Code Plan
Source: Ticket `W1-6.1R` — "Welcome screens header rework (item 6.1)"
(`.agents/runs/welcome-screens-header-rework-20260804/tech-ac.md`)
Date: 2026-08-04

## CREATE NEW

No new file. The one new class, `_WelcomeHero`, is private to the existing
`welcome_container.dart` and is sketched under MODIFY EXISTING below.

## DELETE

### lib/features/onboarding/presentation/widgets/cover_tile.dart
Whole file. Removes `CoverTile` — the cover-fan tile, its inner wash panel and the
glass `Playing` status chip. Last callers (`_WelcomeStepOne`, `_WelcomeSocialProof`)
go in the same run.

### lib/features/onboarding/presentation/widgets/welcome_key_art.dart
Whole file. Removes `WelcomeKeyArt` plus its private `_CountdownLabel`,
`_WelcomeCountdownTile` and `_WelcomeCountdownColon` — key art, wash, countdown
title, tiles and colons all disappear with it.

### lib/features/onboarding/presentation/widgets/welcome_stat_pill.dart
Whole file. Removes `WelcomeStatPill` plus its private `_WelcomeLabel` and
`_WelcomeStatPair`.

## MODIFY EXISTING

### lib/core/res/const.dart

```dart
class AssetConstants {
  static const error404 = 'error_404.png';
  static const welcomeHeaderOne = 'welcome-1-header.png';
  static const welcomeHeaderTwo = 'welcome-2-header.png';
  static const welcomeHeaderTwoBackground = 'welcome-2-header-bg.png';
}
```

Filenames only, matching `error404`; the folder comes from the existing
`PathConstants.imagePath`. Nothing else in this file changes.

### lib/features/onboarding/presentation/widgets/welcome_container.dart

```dart
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/blocs/welcome_state.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
// glass_surface_widget import is removed — the context chip is gone.

class WelcomeContainer extends StatelessWidget {
  const WelcomeContainer({
    super.key,
    required this.step,
    required this.actions,
  });

  final WelcomeStep step;
  final Widget actions;
  // heroContent and socialProof parameters are deleted.

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.color;
    final isFirstStep = step == WelcomeStep.one;
    final heroHeight = isFirstStep ? 400.0 : 356.0;
    final headline = isFirstStep
        ? S.current.welcome_headline_one
        : S.current.welcome_headline_two;
    final body = isFirstStep
        ? S.current.welcome_body_one
        : S.current.welcome_body_two;
    // The `chip` string resolution is deleted with the context chip.

    return LayoutBuilder(
      builder: (context, constraints) {
        // Short screens give space back from the hero so the bottom copy stays
        // usable.
        final shortfall = (714 - constraints.maxHeight).clamp(0.0, heroHeight);
        final resolvedHeroHeight = heroHeight - shortfall;
        return Column(
          children: [
            SizedBox(
              height: resolvedHeroHeight,
              child: _WelcomeHero(step: step),
            ),
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                padding: EdgeInsets.fromLTRB(
                  24,
                  isFirstStep ? 28 : 24,
                  24,
                  24 + context.bottomPadding,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // The social-proof slot and the 18px gap after it are
                      // deleted; the dots row is now the first element.
                      Row(
                        children: [
                          // Progress dots unchanged — 22/5 widths, ink vs ink12.
                        ],
                      ),
                      SizedBox(height: isFirstStep ? 22 : 18),
                      Text(
                        tokens.typography.welcomeHeadline.format(headline),
                        style: tokens.typography.welcomeHeadline.style,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        body,
                        style: tokens.typography.body.style.copyWith(
                          color: colors.ink70,
                        ),
                      ),
                      SizedBox(height: isFirstStep ? 28 : 24),
                      actions,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WelcomeHero extends StatelessWidget {
  const _WelcomeHero({required this.step});

  final WelcomeStep step;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isFirstStep = step == WelcomeStep.one;
    final imageFolder = PathConstants.imagePath;
    final contentAsset = isFirstStep
        ? '$imageFolder${AssetConstants.welcomeHeaderOne}'
        : '$imageFolder${AssetConstants.welcomeHeaderTwo}';

    return ClipRRect(
      borderRadius: tokens.radius.heroShape,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (isFirstStep)
            ColoredBox(color: tokens.color.surfaceIndigoPanel)
          else
            // Screen 2's fill is art, not a colour: it covers the hero and the
            // ClipRRect above trims whatever spills past the rounded corners.
            Image.asset(
              '$imageFolder${AssetConstants.welcomeHeaderTwoBackground}',
              fit: BoxFit.cover,
              excludeFromSemantics: true,
            ),
          // Contain across the full hero box: scaled to fit, never cropped, and
          // centred on both axes by the default alignment. No errorBuilder and
          // no placeholder — a missing asset must leave the fill and the layout
          // untouched.
          Image.asset(
            contentAsset,
            fit: BoxFit.contain,
            excludeFromSemantics: true,
          ),
        ],
      ),
    );
  }
}
```

Deleted from this file, for the reviewer's eye: the `heroContent` and `socialProof`
fields and constructor parameters, the two ambient-circle `Positioned` blocks, the
`GlassSurface` context chip with its icon and `pill` text, the `Positioned.fill`
hero-content slot, the `ColoredBox` magenta branch, and the
`if (socialProof != null) ...[...]` copy-block block. Heights, the shortfall clamp,
`heroShape`, the dots, headline, body, spacing values and `actions` are all unchanged.

### lib/features/onboarding/presentation/screens/onboarding_screen.dart

```dart
// cover_tile.dart, welcome_key_art.dart and welcome_stat_pill.dart imports are
// removed; every other import stays.

class _WelcomeStepOne extends StatelessWidget {
  const _WelcomeStepOne({super.key});

  @override
  Widget build(BuildContext context) {
    return WelcomeContainer(
      step: WelcomeStep.one,
      actions: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              label: S.current.next,
              onPressed: context.read<WelcomeCubit>().next,
            ),
          ),
          const SizedBox(width: 10),
          SkipTextAction(
            label: S.current.skip,
            onPressed: context.read<WelcomeCubit>().finish,
          ),
        ],
      ),
    );
  }
}

class _WelcomeStepTwo extends StatelessWidget {
  const _WelcomeStepTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return WelcomeContainer(
      step: WelcomeStep.two,
      actions: PrimaryButton(
        label: S.current.get_started,
        onPressed: context.read<WelcomeCubit>().finish,
      ),
    );
  }
}

// class _WelcomeSocialProof — deleted entirely.
```

`OnboardingScreen` and `_WelcomeView` (the `BlocProvider`, `BlocListener`,
`PopScope` and `AnimatedSwitcher`) are untouched.

### lib/l10n/intl_en.arb

```jsonc
{
  "next": "Next",
  "skip": "Skip",
  "welcome_headline_one": "...",
  "welcome_body_one": "...",
  "welcome_headline_two": "...",
  "welcome_body_two": "...",
  // Removed, in place (currently lines 10-19, contiguous):
  //   welcome_chip_one, welcome_chip_two,
  //   welcome_stat_tracked, welcome_stat_hours, welcome_stat_playing,
  //   welcome_social_proof,
  //   welcome_countdown_title, welcome_countdown_days,
  //   welcome_countdown_hours, welcome_countdown_minutes
  "get_started": "Get started",
  // ... every remaining key untouched, including "playing"
}
```

### lib/l10n/intl_zh.arb

Identical removal — the same ten keys, same positions, nothing else touched. Both
files must end with matching key sets.

## TEST FILES

### test/widget/onboarding/welcome_screen_test.dart

Harness unchanged: `@GenerateMocks([SharedPreferences, StackRouter])`, `_pumpWelcome`,
`_countDots`, `_countGreen`, `S.load(const Locale('en'))` in `setUpAll`, GetIt
registration in `setUp` and reset in `tearDown`. `welcome_screen_test.mocks.dart` is
untouched.

Add one private helper matching on the asset key, used by the two new tests:

```dart
Finder _assetImage(String assetName) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is Image &&
        widget.image is AssetImage &&
        (widget.image as AssetImage).assetName == assetName,
  );
}
```

Tests:

- `'shows the first step with its copy and active first dot'` — headline one, body one,
  one 22-wide dot, one 5-wide dot, exactly one green element. (Existing test; passes
  once the cover tile's 5px status dot is gone.)
- `'shows the first hero art once and no background image'` — the
  `welcome-1-header.png` asset renders exactly once and it is the only `Image` on
  screen 1, proving screen 1 keeps its flat fill. `[W1-6.1R.2]`, `[W1-6.1R.4]`
- `'moves to the second step without writing the seen flag'` — headline two, body two,
  no Skip label, dot state flipped, one green element, `verifyNever` on the flag write.
  (Existing test.)
- `'shows the second hero art and its background once each'` — after tapping Next,
  `welcome-2-header.png` and `welcome-2-header-bg.png` each render exactly once, and
  `welcome-1-header.png` no longer renders. `[W1-6.1R.3]`, `[W1-6.1R.4]`
- `'writes the seen flag when Skip exits the first step'` — flag written once, router
  replaced once. (Existing test, unchanged.)
- `'writes the seen flag when Get started exits the second step'` — flag written once,
  router replaced once. (Existing test, unchanged.)
- `'collapses the switcher duration when motion is reduced'` — `AnimatedSwitcher.duration`
  is `Duration.zero` when `disableAnimations` is set. (Existing test, unchanged.)
- `'does not overflow on a short viewport with larger text'` — pumped at 360x600 with
  text scale 1.5 on both steps; `tester.takeException()` is null. (Existing test,
  extended to settle on step two as well.) `[W1-6.1R.17]`

Deleted outright, not skipped: every assertion touching cover tiles, the `Playing`
status chip, the stat pill figures or labels, the context chip, key art, the countdown
title/tiles/colons, the ambient circles and the social-proof row. No
`matchesGoldenFile`, no `skip:`, no commented-out test, and no reference to any of the
ten removed localisation keys.

## Approved feedback delta

Phase 3 human review, 2026-08-04. Authoritative over everything above and over
`task-brief.md` wherever they disagree. `tdd.md` and `task-brief.md` are not rewritten.

### Overrides

- **The hero gets its own file.** `lib/features/onboarding/presentation/widgets/welcome_hero.dart`,
  holding a public `WelcomeHero`, not a private class inside `welcome_container.dart`.
  Public because the two step widgets in `onboarding_screen.dart` now construct it, and
  because that matches its siblings in the same folder (`CoverTile`, `WelcomeKeyArt`,
  `WelcomeStatPill`, `SkipTextAction` were all public classes in their own files).
  This overrides `task-brief.md`'s "CREATE NEW: None" and its constraint
  "`_WelcomeHero` stays private in `welcome_container.dart` — do not create a new file".
- **`AssetConstants` gains no entries.** `lib/core/res/const.dart` is still modified, but
  only to add a doc comment above `AssetConstants` recording that it holds globally-used
  constants. This overrides `task-brief.md` Step 1 and its constraint "Constants go in
  `AssetConstants`".
- **The three filenames move to a feature-scoped holder.** `WelcomeAssetConstants`, a
  static-only class declared in `welcome_hero.dart` beside the widget it serves. Still a
  class, so `dart-style.md`'s ban on bare top-level constants holds. It exposes finished
  asset paths rather than bare filenames so `PathConstants.imagePath` is composed once
  instead of at five call sites (two step widgets, three test assertions).
- **`WelcomeHero` takes no `WelcomeStep` and contains no step branch.** Its inputs are a
  required `contentAsset` and two independent optional background inputs,
  `backgroundColor` and `backgroundAsset`. Each caller supplies only the one it needs.
  Adding welcome screens 3-5 later adds callers, not branches.
- **`WelcomeContainer` takes resolved values, not `step`-derived ones.** `heroHeight`,
  `hero`, `headline` and `body` are now constructor inputs supplied by
  `_WelcomeStepOne` / `_WelcomeStepTwo`. `WelcomeContainer` drops its `S.current`,
  `const.dart` and `glass_surface_widget.dart` imports as a result.
- **`step` survives on `WelcomeContainer`, narrowed.** It now drives only the progress-dot
  row and the three copy-block spacing values. Judgement call, flagged for the reviewer:
  those remaining branches are *first screen vs. the rest*, not *per screen* — a third
  screen would take the same 24 / 18 / 24 rhythm as screen 2 and grow nothing. Everything
  that genuinely varied per screen (height, headline, body, hero art) is now explicit.
  Say the word if `step` should go entirely and the dot state should be passed in too.
- **`WelcomeContainer` holds a plain `Widget hero` slot rather than forwarding hero args.**
  Forwarding `contentAsset` / `backgroundColor` / `backgroundAsset` through the container
  would make it an eight-parameter middle-man that re-welds the hero to it, which cuts
  against the reusability this feedback asked for. The step widgets build the
  `WelcomeHero` and hand it over.
- **`lib/widgets/glass_surface_widget.dart` is kept.** Confirmed, unchanged from the first
  pass — it stays out of the allowlist and is not deleted.
- **No `errorBuilder`, placeholder or fallback art on the three local assets.** Confirmed,
  unchanged from the first pass. `DefaultCachedNetworkImage`'s network-image error and
  placeholder pattern is a separate, established mechanism and is untouched by this run.

### Revised file lists

**CREATE NEW**
- `lib/features/onboarding/presentation/widgets/welcome_hero.dart` — the hero paint
  (clip, optional background, centred content image) plus the feature's three asset paths

**DELETE** — unchanged: `cover_tile.dart`, `welcome_key_art.dart`, `welcome_stat_pill.dart`

**MODIFY EXISTING**
- `lib/core/res/const.dart` — doc comment on `AssetConstants` only, no new members
- `lib/features/onboarding/presentation/widgets/welcome_container.dart` — hero becomes a
  passed-in slot; height, headline and body become parameters; ambient circles, context
  chip, `heroContent`, `socialProof` and the social-proof gap removed
- `lib/features/onboarding/presentation/screens/onboarding_screen.dart` — each step
  resolves its own height, copy and hero; `_WelcomeSocialProof` deleted
- `lib/l10n/intl_en.arb`, `lib/l10n/intl_zh.arb` — unchanged from the first pass

**TEST FILES** — `test/widget/onboarding/welcome_screen_test.dart`, unchanged in coverage;
only the asset-key source changes (see below)

### Revised skeletons

#### CREATE NEW — lib/features/onboarding/presentation/widgets/welcome_hero.dart

```dart
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

/// The rounded panel at the top of a welcome screen: one piece of art centred
/// over an optional background.
///
/// Nothing here knows which welcome screen it is on. The caller picks the art
/// and picks whether the layer beneath it is a flat colour or another image, so
/// a new welcome screen is a new caller rather than another branch in here.
class WelcomeHero extends StatelessWidget {
  const WelcomeHero({
    super.key,
    required this.contentAsset,
    this.backgroundColor,
    this.backgroundAsset,
  });

  /// Art shown whole and centred, scaled down to fit rather than cropped.
  final String contentAsset;

  /// Flat fill behind the content.
  final Color? backgroundColor;

  /// Art behind the content, cropped to cover the panel. Painted over
  /// [backgroundColor] if a caller ever supplies both.
  final String? backgroundAsset;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: context.tokens.radius.heroShape,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (backgroundColor != null) ColoredBox(color: backgroundColor!),
          if (backgroundAsset != null)
            Image.asset(
              backgroundAsset!,
              fit: BoxFit.cover,
              excludeFromSemantics: true,
            ),
          // Contain across the full panel: scaled to fit, never cropped, and
          // centred on both axes by the default alignment. No errorBuilder and
          // no placeholder — a missing asset must leave the background and the
          // layout untouched.
          Image.asset(
            contentAsset,
            fit: BoxFit.contain,
            excludeFromSemantics: true,
          ),
        ],
      ),
    );
  }
}

/// Art belonging to the welcome flow. Kept here rather than in the shared
/// `AssetConstants` because only this feature uses it.
class WelcomeAssetConstants {
  static const heroOne = '${PathConstants.imagePath}welcome-1-header.png';
  static const heroTwo = '${PathConstants.imagePath}welcome-2-header.png';
  static const heroTwoBackground =
      '${PathConstants.imagePath}welcome-2-header-bg.png';
}
```

#### MODIFY EXISTING — lib/core/res/const.dart

```dart
class PathConstants {
  static const lottieAnimationAssetPath = 'assets/animations/';
  static const imagePath = 'assets/images/';
}

/// Asset filenames used across the whole app.
///
/// Assets only one feature needs belong with that feature, so this class does
/// not grow every time a screen adds art.
class AssetConstants {
  static const error404 = 'error_404.png';
}
```

No member is added or removed. Every other class in the file is untouched.

#### MODIFY EXISTING — lib/features/onboarding/presentation/widgets/welcome_container.dart

```dart
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/blocs/welcome_state.dart';
// The const.dart, l10n and glass_surface_widget imports all go: the container
// no longer names an asset, resolves a string or draws a chip.

class WelcomeContainer extends StatelessWidget {
  const WelcomeContainer({
    super.key,
    required this.step,
    required this.heroHeight,
    required this.hero,
    required this.headline,
    required this.body,
    required this.actions,
  });

  /// Which progress dot reads as active.
  final WelcomeStep step;
  final double heroHeight;
  final Widget hero;
  final String headline;
  final String body;
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.color;
    // Only the first screen differs in rhythm; every later screen shares the
    // second screen's spacing.
    final isFirstStep = step == WelcomeStep.one;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Short screens give space back from the hero so the bottom copy stays
        // usable.
        final shortfall = (714 - constraints.maxHeight).clamp(0.0, heroHeight);
        final resolvedHeroHeight = heroHeight - shortfall;
        return Column(
          children: [
            SizedBox(height: resolvedHeroHeight, child: hero),
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                padding: EdgeInsets.fromLTRB(
                  24,
                  isFirstStep ? 28 : 24,
                  24,
                  24 + context.bottomPadding,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // The social-proof slot and the 18px gap after it are
                      // deleted; the dots row is now the first element.
                      Row(
                        children: [
                          // Progress dots unchanged — 22/5 widths, ink vs
                          // ink12, still resolved from `step`.
                        ],
                      ),
                      SizedBox(height: isFirstStep ? 22 : 18),
                      Text(
                        tokens.typography.welcomeHeadline.format(headline),
                        style: tokens.typography.welcomeHeadline.style,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        body,
                        style: tokens.typography.body.style.copyWith(
                          color: colors.ink70,
                        ),
                      ),
                      SizedBox(height: isFirstStep ? 28 : 24),
                      actions,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
```

Deleted from this file, for the reviewer's eye: the `heroContent` and `socialProof`
fields and constructor parameters, the internally resolved `heroHeight`, `headline`,
`body` and `chip` locals, the `ClipRRect` + `Stack` hero (moved to `WelcomeHero`), the
two ambient-circle `Positioned` blocks, the `GlassSurface` context chip, the
`Positioned.fill` hero slot, the `ColoredBox` fill branch, and the
`if (socialProof != null) ...[...]` block. The shortfall clamp, the dots, the type
styles and every spacing number are unchanged. There is no private class left in this
file.

#### MODIFY EXISTING — lib/features/onboarding/presentation/screens/onboarding_screen.dart

```dart
// cover_tile.dart, welcome_key_art.dart and welcome_stat_pill.dart imports are
// removed; welcome_hero.dart is added. Every other import stays.
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/widgets/welcome_hero.dart';

class _WelcomeStepOne extends StatelessWidget {
  const _WelcomeStepOne({super.key});

  @override
  Widget build(BuildContext context) {
    return WelcomeContainer(
      step: WelcomeStep.one,
      heroHeight: 400,
      hero: WelcomeHero(
        contentAsset: WelcomeAssetConstants.heroOne,
        backgroundColor: context.tokens.color.surfaceIndigoPanel,
      ),
      headline: S.current.welcome_headline_one,
      body: S.current.welcome_body_one,
      actions: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              label: S.current.next,
              onPressed: context.read<WelcomeCubit>().next,
            ),
          ),
          const SizedBox(width: 10),
          SkipTextAction(
            label: S.current.skip,
            onPressed: context.read<WelcomeCubit>().finish,
          ),
        ],
      ),
    );
  }
}

class _WelcomeStepTwo extends StatelessWidget {
  const _WelcomeStepTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return WelcomeContainer(
      step: WelcomeStep.two,
      heroHeight: 356,
      hero: const WelcomeHero(
        contentAsset: WelcomeAssetConstants.heroTwo,
        backgroundAsset: WelcomeAssetConstants.heroTwoBackground,
      ),
      headline: S.current.welcome_headline_two,
      body: S.current.welcome_body_two,
      actions: PrimaryButton(
        label: S.current.get_started,
        onPressed: context.read<WelcomeCubit>().finish,
      ),
    );
  }
}

// class _WelcomeSocialProof — deleted entirely.
```

Screen 1's hero cannot be `const` because its background colour is read from
`context.tokens`; screen 2's can and is. `OnboardingScreen` and `_WelcomeView` (the
`BlocProvider`, `BlocListener`, `PopScope` and `AnimatedSwitcher`) remain untouched.

#### TEST FILES — test/widget/onboarding/welcome_screen_test.dart

Coverage, harness, mocks and the eight test names are exactly as listed above. Two
changes only:

- Add `import '.../features/onboarding/presentation/widgets/welcome_hero.dart';`. The
  existing `core/res/const.dart` import stays — it is still needed for
  `StorageConstants.firstUseKey`.
- The asset-key assertions read the paths from `WelcomeAssetConstants` instead of
  composing `PathConstants.imagePath` with `AssetConstants`, so the test and the widgets
  still name the same key from one place:

```dart
Finder _assetImage(String assetName) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is Image &&
        widget.image is AssetImage &&
        (widget.image as AssetImage).assetName == assetName,
  );
}

// e.g. expect(_assetImage(WelcomeAssetConstants.heroOne), findsOneWidget);
```

### Implementation-plan impact

`task-brief.md`'s step list is not rewritten; it maps onto this delta as follows.

- Step 1 becomes: `lib/core/res/const.dart` — add the `AssetConstants` doc comment, no
  members.
- New step between 1 and 2: create `welcome_hero.dart` with `WelcomeHero` and
  `WelcomeAssetConstants`.
- Step 2 is absorbed by that new step — no private `_WelcomeHero` is created.
- Step 3 becomes: reduce `WelcomeContainer` to
  `{step, heroHeight, hero, headline, body, actions}` and drop the three now-unused
  imports.
- Step 4 is unchanged.
- Step 5 gains: each step widget passes its own height, copy and `WelcomeHero`, and
  `welcome_hero.dart` is imported.
- Steps 6-12 and the final analyze/test step are unchanged.

Still 12 non-generation steps, under the 20 ceiling. No new package, no `pubspec.yaml`
change, no token edit, no new localisation key, no new escalation.

# Code Plan
Source: Ticket `W1-6.2R` — "Welcome screens polish + global system UI convention (item 6.2)"
(`.agents/runs/welcome-screens-polish-20260804/tech-ac.md`)
Date: 2026-08-04

## CREATE NEW

None.

## MODIFY EXISTING

### lib/features/onboarding/const.dart

```dart
class WelcomeAssetConstants {
  // ...unchanged...
}

class WelcomeLayoutConstants {
  static const double heroHeightOne = 240;
  static const double heroHeightTwo = 216;
  static const double heroContentPadding = 24;
}
```

The three design-gate numbers, in one place. Retuning any of them at the gate touches
this file only.

### lib/bootstrap.dart

```dart
import 'package:flutter/services.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_color_tokens.dart';

/// Shared startup sequence for every flavour entrypoint.
Future<void> bootstrap({required Flavor flavor, required Widget app}) async {
  WidgetsFlutterBinding.ensureInitialized();
  // The status bar shows whatever the screen paints behind it, and the system
  // navigation bar reads as the app's own background.
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColorTokens.dark.canvas,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  FlavorConfig.initialise(flavor);
  await configureDependencies();
  unawaited(getIt<SupabaseConnectionChecker>().check());
  runApp(app);
}
```

Not `const`, because the colour comes from the token rather than a literal.

### lib/features/onboarding/presentation/widgets/welcome_hero.dart

```dart
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
          // Only the content art is inset; the fill and background still reach
          // the panel's edges.
          Padding(
            padding: const EdgeInsets.all(
              WelcomeLayoutConstants.heroContentPadding,
            ),
            child: Image.asset(
              contentAsset,
              fit: BoxFit.contain,
              excludeFromSemantics: true,
            ),
          ),
        ],
      ),
    );
```

### lib/features/onboarding/presentation/widgets/welcome_container.dart

```dart
              child: SingleChildScrollView(
                reverse: true,
                padding: EdgeInsets.fromLTRB(
                  24,
                  isFirstStep ? 28 : 24,
                  24,
                  24, // was: 24 + context.bottomPadding — SafeArea owns the
                      // system inset now, so adding it here counted it twice.
                ),
```

Nothing else in this file changes — the `LayoutBuilder` give-back and the two progress
dots stay exactly as they are.

### lib/features/onboarding/presentation/screens/onboarding_screen.dart

```dart
class _WelcomeView extends StatefulWidget {
  const _WelcomeView();

  @override
  State<_WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<_WelcomeView> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Only a settled page moves the step. A partial drag snaps back and never
  // reports a change, and neither call writes anything to storage.
  void _onPageSettled(int index) {
    final cubit = context.read<WelcomeCubit>();
    if (index == 0) {
      cubit.back();
    } else {
      cubit.next();
    }
  }

  void _followStep(BuildContext context, WelcomeState state) {
    if (!_controller.hasClients) return;
    final target = state.step == WelcomeStep.one ? 0 : 1;
    // A swipe moves the page first and the step second; animating again here
    // would fight the gesture that caused it.
    if (_controller.page?.round() == target) return;

    final motion = context.tokens.motion;
    final duration = motion.resolve(context, motion.screenTransition);
    if (duration == Duration.zero) {
      _controller.jumpToPage(target);
    } else {
      _controller.animateToPage(
        target,
        duration: duration,
        curve: motion.screenTransitionCurve,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<WelcomeCubit, WelcomeState>(
              listener: (context, state) {
                if (state.status == WelcomeStatus.finished) {
                  context.replaceRoute(const AuthRoute());
                }
              },
            ),
            BlocListener<WelcomeCubit, WelcomeState>(
              listener: _followStep,
            ),
          ],
          child: BlocSelector<WelcomeCubit, WelcomeState, WelcomeStep>(
            selector: (state) => state.step,
            builder: (context, step) {
              return PopScope(
                canPop: step == WelcomeStep.one,
                onPopInvokedWithResult: (didPop, _) {
                  if (!didPop && step == WelcomeStep.two) {
                    context.read<WelcomeCubit>().back();
                  }
                },
                child: PageView(
                  controller: _controller,
                  onPageChanged: _onPageSettled,
                  children: const [_WelcomeStepOne(), _WelcomeStepTwo()],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WelcomeStepOne extends StatelessWidget {
  const _WelcomeStepOne();

  @override
  Widget build(BuildContext context) {
    return WelcomeContainer(
      step: WelcomeStep.one,
      heroHeight: WelcomeLayoutConstants.heroHeightOne,
      hero: WelcomeHero(
        contentAsset: WelcomeAssetConstants.heroOne,
        backgroundColor: context.tokens.color.surfaceIndigoPanel,
      ),
      // headline / body / actions unchanged — Next + text Skip.
    );
  }
}

class _WelcomeStepTwo extends StatelessWidget {
  const _WelcomeStepTwo();

  @override
  Widget build(BuildContext context) {
    return WelcomeContainer(
      step: WelcomeStep.two,
      heroHeight: WelcomeLayoutConstants.heroHeightTwo,
      hero: const WelcomeHero(
        contentAsset: WelcomeAssetConstants.heroTwo,
        backgroundAsset: WelcomeAssetConstants.heroTwoBackground,
      ),
      // headline / body / actions unchanged — Get started alone.
    );
  }
}
```

`OnboardingScreen` itself is unchanged. `AnimatedSwitcher` and both `ValueKey`s are gone.
`welcome_cubit.dart` is deliberately not opened.

### .agents/references/onboarding-welcome-design-spec.md

§ 3, Height row only:

```markdown
| Height | `240px` | `216px` |
```

The "(item 6.1/6.2: being reduced, see run notes)" placeholders go with it. No other row
of that table is touched.

### .agents/references/project-conventions.md

New section, phrased as an app-wide rule:

```markdown
## System bars and SafeArea

Every screen's body is wrapped in `SafeArea` — `Scaffold(body: SafeArea(child: ...))`.
No screen lays content under the status bar, the system navigation bar, or a display
cutout.

The system UI overlay style is a single global default, set once in `bootstrap.dart`
before `runApp` and never overridden per screen or inside a `build` method:
transparent status bar, system navigation bar matching `AppColorTokens.canvas`,
transparent divider, light icons on both. The colour comes from the token, never a
literal.

On Android 15 and above the platform ignores the two colour fields and draws the app
edge to edge. The intended appearance still holds because the app's own scaffold
background is the canvas colour — so never add an opaque bar of your own to compensate,
and never suppress edge-to-edge drawing.

A screen that wants a different treatment (for example a hero bleeding under a
transparent status bar via `SafeArea(top: false)`) is a deviation that needs a recorded
decision, not a free choice.
```

## TEST FILES

### test/widget/onboarding/welcome_screen_test.dart

Helpers — changed or added:

- `Finder _page(String headline)` — the `WelcomeContainer` ancestor of that page's
  headline, used to scope every count to the visible page.
- `int _countDots(WidgetTester, Finder page, double width)` and
  `int _countGreen(WidgetTester, Finder page)` — same logic, but walking
  `find.descendant(of: page, matching: find.byType(Container))` instead of the whole tree.
- `_pumpWelcome(..., double bottomInset = 0)` — feeds
  `MediaQueryData(padding: EdgeInsets.only(bottom: bottomInset))`.
- `Future<void> _swipe(WidgetTester, {required bool forward})` — a drag on the `PageView`
  large enough to settle onto the next page, followed by `pumpAndSettle`.

Cases:

- `'shows the first step with its copy and active first dot'` — unchanged intent; dot and
  green counts now scoped to page one.
- `'shows the first hero art once and no background image'` — the `Image` count is scoped
  to page one, still exactly one.
- `'moves to the second step without writing the seen flag'` — unchanged intent; `Skip`
  absence is now asserted within page two rather than across the tree.
- `'shows the second hero art and its background once each'` — scoped to page two.
- `'writes the seen flag when Skip exits the first step'` — unchanged.
- `'writes the seen flag when Get started exits the second step'` — unchanged.
- `'moves to the second step when swiped forward without writing the seen flag'` — swipes
  left, asserts screen 2's headline is visible and `verifyNever` on `setBool`.
  (`[W1-6.2R.13]`, `[W1-6.2R.19]`, `[W1-6.2R.20]`)
- `'returns to the first step when swiped backward'` — swipes forward then back, asserts
  screen 1's headline is visible again and the step and page agree after settling.
  (`[W1-6.2R.13]`, `[W1-6.2R.14]`)
- `'keeps the first page dot active while a drag is held'` — starts a gesture, moves part
  of a page width, pumps without settling, asserts page one's `22`-wide active dot is
  still there and its `5`-wide inactive dot is unchanged, then releases.
  (`[W1-6.2R.15]`)
- `'changes page instantly when motion is reduced'` — replaces the `AnimatedSwitcher`
  duration test. Pumps with `disableAnimations: true`, taps `Next`, pumps a single frame,
  asserts screen 2 is the visible page. (`[W1-6.2R.17]`, carries `[W1-6.32]`)
- `'keeps the action row off the bottom system inset'` — pumps with a non-zero bottom
  inset and asserts the gap between the action row's bottom and the safe-area edge equals
  the copy block's own bottom padding, not that padding plus the inset.
  (`[W1-6.2R.7]`, `[W1-6.2R.21]`)
- `'does not overflow on a short viewport with larger text'` — unchanged, and still
  exercises both pages. (`[W1-6.2R.4]`)

No `matchesGoldenFile`, no `skip:`, no commented-out case.

# Code Plan
Source: Week-1 checklist item 6 — "Welcome screens" (ref `W1-6`), via
`.agents/runs/welcome-screens-20260802/tech-ac.md`
Date: 2026-08-03

A preview of the shape of the change, for the review gate. Not working code, and not
the Dev Agent's instruction set — `task-brief.md ## Implementation plan` is. Imports,
routine getters and boilerplate are omitted.

## CREATE NEW

### lib/config/theme/tokens/app_effect_tokens.dart

```dart
// The two surface-treatment values: the one shadow the app is allowed to use,
// and the blur that sits behind glass chips.
@immutable
class AppEffectTokens {
  const AppEffectTokens({
    required this.float,
    required this.glassBlur,
  });

  /// The single lift in the system. One focal element per screen, nothing else.
  final BoxShadow float;

  /// How soft the blur behind glass is. The design gives this as an 18-pixel
  /// blur; Flutter wants half that number, so 9 here means 18 there.
  final double glassBlur;

  static const AppEffectTokens dark = AppEffectTokens(
    float: BoxShadow(
      color: Color.fromRGBO(69, 42, 124, 0.1),
      offset: Offset(0, 3),
      blurRadius: 68,
    ),
    glassBlur: 9,
  );

  AppEffectTokens copyWith({BoxShadow? float, double? glassBlur}) { ... }

  static AppEffectTokens lerp(AppEffectTokens a, AppEffectTokens b, double t) {
    return AppEffectTokens(
      float: BoxShadow.lerp(a.float, b.float, t)!,
      glassBlur: lerpDouble(a.glassBlur, b.glassBlur, t)!,
    );
  }
}
```

### lib/features/onboarding/presentation/blocs/welcome_state.dart

```dart
part 'welcome_state.freezed.dart';

enum WelcomeStep { one, two }

enum WelcomeStatus { inProgress, finished }

@freezed
sealed class WelcomeState with _$WelcomeState {
  const factory WelcomeState({
    @Default(WelcomeStep.one) WelcomeStep step,
    @Default(WelcomeStatus.inProgress) WelcomeStatus status,
  }) = _WelcomeState;
}
```

### lib/features/onboarding/presentation/blocs/welcome_cubit.dart

```dart
@injectable
class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit(this._preferences) : super(const WelcomeState());

  final SharedPreferences _preferences;

  void next() => emit(state.copyWith(step: WelcomeStep.two));

  void back() => emit(state.copyWith(step: WelcomeStep.one));

  // Both ways out of the flow land here. Nothing is written before this point,
  // so someone who closes the app halfway through still sees the flow again.
  Future<void> finish() async {
    await _preferences.setBool(StorageConstants.firstUseKey, true);
    emit(state.copyWith(status: WelcomeStatus.finished));
  }
}
```

### assets/animations/.gitkeep

Empty file. `pubspec.yaml` declares `assets/animations/` and this run may not edit
`pubspec.yaml`, so the directory has to outlive the three Lottie files being deleted.

## MODIFY EXISTING

### lib/config/theme/tokens/app_color_tokens.dart

```dart
class AppColorTokens {
  const AppColorTokens({
    ...
    required this.green,
    // ** Onboarding surfaces and washes
    required this.surfaceMagentaPanel,
    required this.keyArtWash,
    required this.coverWash,
    required this.ambientNeutral,
    required this.ambientAccent,
    // ** Glass fills
    required this.glass30,
    required this.glass32,
    required this.glass34,
    required this.countdownColon,
    ...
  });

  final Color surfaceMagentaPanel;
  final Color keyArtWash;
  final Color coverWash;
  final Color ambientNeutral;
  final Color ambientAccent;
  final Color glass30;
  final Color glass32;
  final Color glass34;
  final Color countdownColon;

  static const AppColorTokens dark = AppColorTokens(
    ...
    surfaceIndigoPanel: Color(0xFF2F3782),   // unchanged — welcome 1 reuses this
    green: Color(0xFF35ED7E),                // was Color(0xFF4CAF50)
    surfaceMagentaPanel: Color(0xFF8A2F86),
    keyArtWash: Color.fromRGBO(30, 20, 64, 0.5),
    coverWash: Color.fromRGBO(10, 13, 58, 0.42),
    ambientNeutral: Color.fromRGBO(255, 255, 255, 0.09),
    ambientAccent: Color.fromRGBO(236, 72, 189, 0.2),
    glass30: Color.fromRGBO(0, 0, 0, 0.30),
    glass32: Color.fromRGBO(0, 0, 0, 0.32),
    glass34: Color.fromRGBO(0, 0, 0, 0.34),
    countdownColon: Color.fromRGBO(255, 255, 255, 0.4),
    ...
  );

  // copyWith gains all nine as nullable named params.
  // lerp gains all nine as Color.lerp(a.x, b.x, t)!.
}
```

### lib/config/theme/tokens/app_type_tokens.dart

```dart
class AppTypeTokens {
  const AppTypeTokens({
    ...
    required this.welcomeHeadline,
    required this.panelTitle,
    required this.countdownFigure,
    required this.countdownColon,
    required this.statFigure,
    required this.caption,
    required this.microLabel,
  });

  final AppTextToken welcomeHeadline;
  final AppTextToken panelTitle;
  final AppTextToken countdownFigure;
  final AppTextToken countdownColon;
  final AppTextToken statFigure;
  final AppTextToken caption;
  final AppTextToken microLabel;

  static final AppTypeTokens dark = AppTypeTokens(
    ...
    body: AppTextToken(
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.45,          // was 1.5
      ),
      uppercase: false,
    ),
    welcomeHeadline: AppTextToken(
      style: GoogleFonts.spaceGrotesk(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        height: 1.02,
        // 34 x -0.01em
        letterSpacing: -0.34,
        color: AppColorTokens.dark.ink,
      ),
      uppercase: true,
    ),
    panelTitle: AppTextToken(
      style: GoogleFonts.spaceGrotesk(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColorTokens.dark.ink,
      ),
      uppercase: false,
    ),
    countdownFigure: AppTextToken(
      style: GoogleFonts.spaceGrotesk(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: AppColorTokens.dark.ink,
      ),
      uppercase: false,
    ),
    countdownColon: AppTextToken(
      style: GoogleFonts.spaceGrotesk(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        color: AppColorTokens.dark.countdownColon,
      ),
      uppercase: false,
    ),
    statFigure: AppTextToken(
      style: GoogleFonts.spaceGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.1,
        color: AppColorTokens.dark.ink,
      ),
      uppercase: false,
    ),
    caption: AppTextToken(
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColorTokens.dark.ink55,
      ),
      uppercase: false,
    ),
    microLabel: AppTextToken(
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        // 10 x 0.1em
        letterSpacing: 1,
        color: AppColorTokens.dark.ink70,
      ),
      uppercase: true,
    ),
  );

  // copyWith and lerp gain all seven.
}
```

### lib/config/theme/tokens/app_radius_tokens.dart

```dart
// The seven rounded-corner sizes used across the app, plus one special shape
// for the hero image. A few odd corner sizes from early designs (20, 38, 44)
// are deliberately not included here.
class AppRadiusTokens {
  const AppRadiusTokens({
    required this.mini,
    required this.xs,
    ...
  });

  /// The smallest media in the system — the overlapping mini covers.
  final double mini;

  static const AppRadiusTokens dark = AppRadiusTokens(
    mini: 5,
    xs: 6,
    ...
  );

  // copyWith and lerp gain mini.
}
```

### lib/config/theme/tokens/app_tokens.dart

```dart
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.color,
    required this.typography,
    required this.radius,
    required this.motion,
    required this.effect,
  });

  final AppEffectTokens effect;

  static final AppTokens dark = AppTokens(
    ...
    effect: AppEffectTokens.dark,
  );

  @override
  AppTokens copyWith({..., AppEffectTokens? effect}) { ... }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    ...
    effect: AppEffectTokens.lerp(effect, other.effect, t),
  }
}
```

### lib/core/res/const.dart

```dart
class AssetConstants {
  static const error404 = 'error_404.png';
}
```

The three `onboardingAnimation*` entries are gone. `PathConstants` and
`StorageConstants` are untouched — `firstUseKey` is reused as-is.

### lib/l10n/intl_en.arb  ·  lib/l10n/intl_zh.arb

```jsonc
{
  "@@locale": "en",
  "app_title": "Gaming Library Assessment",
  // three onboarding_description_* keys removed from here
  "next": "Next",
  "skip": "Skip",
  ...
  // sixteen new keys, same set in both files:
  "welcome_headline_one": "...",
  "welcome_body_one": "...",
  "welcome_headline_two": "...",
  "welcome_body_two": "...",
  "welcome_chip_one": "...",
  "welcome_chip_two": "...",
  "welcome_stat_tracked": "...",
  "welcome_stat_hours": "...",
  "welcome_stat_playing": "...",
  "welcome_social_proof": "...",
  "welcome_countdown_title": "...",
  "welcome_countdown_days": "...",
  "welcome_countdown_hours": "...",
  "welcome_countdown_minutes": "...",
  "get_started": "...",
  "playing": "..."
}
```

Values are in `task-brief.md ## Acceptance criteria reference` `[W1-6.33]`. Nothing
under `lib/generated/` is touched — the `S` accessors arrive with the human's IDE
regeneration.

### lib/features/onboarding/presentation/screens/onboarding_screen.dart

Full rewrite at the existing route path. Every extracted UI composition is a private
widget class co-located in this file; no `presentation/widgets/` file is created and
no Widget-returning helper function or getter is introduced.

```dart
@RoutePage()
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt<WelcomeCubit>(),
        child: const _WelcomeFlow(),
      );
}

class _WelcomeFlow extends StatelessWidget {
  const _WelcomeFlow();

  @override
  Widget build(BuildContext context) {
    final motion = context.tokens.motion;
    return BlocListener<WelcomeCubit, WelcomeState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == WelcomeStatus.finished) {
          context.replaceRoute(HomeRoute());
        }
      },
      child: BlocBuilder<WelcomeCubit, WelcomeState>(
        builder: (context, state) => Scaffold(
          body: PopScope(
            canPop: state.step == WelcomeStep.one,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) context.read<WelcomeCubit>().back();
            },
            child: AnimatedSwitcher(
              duration: motion.resolve(context, motion.screenTransition),
              switchInCurve: motion.screenTransitionCurve,
              switchOutCurve: motion.screenTransitionCurve,
              child: switch (state.step) {
                WelcomeStep.one => const _WelcomeStepOne(
                    key: ValueKey(WelcomeStep.one),
                  ),
                WelcomeStep.two => const _WelcomeStepTwo(
                    key: ValueKey(WelcomeStep.two),
                  ),
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeFrame extends StatelessWidget {
  const _WelcomeFrame({
    required this.step,
    required this.heroContent,
    required this.actions,
    this.socialProof,
    super.key,
  });

  final WelcomeStep step;
  final Widget heroContent;
  final Widget actions;
  final Widget? socialProof;

  @override
  Widget build(BuildContext context) {
    final referenceHeroHeight = switch (step) {
      WelcomeStep.one => 400.0,
      WelcomeStep.two => 356.0,
    };
    return LayoutBuilder(
      builder: (context, constraints) {
        // The hero absorbs shortfall from the 714px reference while the
        // reversed scroller keeps enlarged copy bottom-anchored and safe.
        final shortfall = math.max(0.0, 714.0 - constraints.maxHeight);
        final heroHeight = math.max(0.0, referenceHeroHeight - shortfall);
        return Column(
          children: [
            SizedBox(
              height: heroHeight,
              child: ClipRRect(
                borderRadius: context.tokens.radius.heroShape,
                child: Stack(
                  children: [
                    Positioned.fill(...step-derived flat hero fill...),
                    Positioned(...inline neutral ambient circle...),
                    Positioned(...inline accent ambient circle...),
                    heroContent,
                    Positioned(
                      top: 54,
                      left: 24,
                      child: _GlassSurface(
                        fill: ...step-derived glass fill...,
                        borderRadius: BorderRadius.circular(
                          context.tokens.radius.pill,
                        ),
                        child: Row(...one icon and step-derived chip label...),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, copyConstraints) => SingleChildScrollView(
                  reverse: true,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: copyConstraints.maxHeight,
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (socialProof != null) socialProof!,
                          Row(...inline progress dots derived from step...),
                          Text(...step-derived localised headline...),
                          Text(...step-derived localised body...),
                          actions,
                        ],
                      ),
                    ),
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

class _WelcomeStepOne extends StatelessWidget {
  const _WelcomeStepOne({super.key});

  @override
  Widget build(BuildContext context) => _WelcomeFrame(
        step: WelcomeStep.one,
        heroContent: Stack(
          children: [
            Positioned(
              ...100 x 134, -9 degrees, bottom 96...,
              child: _CoverTile(...),
            ),
            Positioned(
              ...100 x 134, 10 degrees, bottom 88...,
              child: _CoverTile(...),
            ),
            Positioned(
              bottom: 112,
              child: DecoratedBox(
                // The focal centre cover owns the run's only shadow.
                decoration: BoxDecoration(
                  boxShadow: [context.tokens.effect.float],
                ),
                child: Stack(
                  children: [
                    _CoverTile(width: 124, height: 166, ...),
                    Positioned(
                      ...inline glass Playing chip and 5px dot...,
                    ),
                  ],
                ),
              ),
            ),
            const Positioned(
              left: 24,
              right: 24,
              bottom: 34,
              child: _WelcomeStatPill(),
            ),
          ],
        ),
        actions: Row(
          spacing: 10,
          children: [
            Expanded(
              child: _WelcomePrimaryButton(
                label: S.current.next,
                onPressed: context.read<WelcomeCubit>().next,
              ),
            ),
            _WelcomeSkipTextAction(
              label: S.current.skip,
              onPressed: context.read<WelcomeCubit>().finish,
            ),
          ],
        ),
      );
}

class _WelcomeStatPill extends StatelessWidget {
  const _WelcomeStatPill();

  @override
  Widget build(BuildContext context) => _GlassSurface(
        ...glass30, pill radius, 10 x 14 padding...,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _WelcomeStatPair(
              figure: '312',
              label: S.current.welcome_stat_tracked,
            ),
            _WelcomeStatPair(
              figure: '1,204',
              label: S.current.welcome_stat_hours,
            ),
            _WelcomeStatPair(
              figure: '7',
              label: S.current.welcome_stat_playing,
            ),
          ],
        ),
      );
}

class _WelcomeStatPair extends StatelessWidget {
  const _WelcomeStatPair({
    required this.figure,
    required this.label,
  });

  final String figure;
  final String label;

  @override
  Widget build(BuildContext context) => ...figure above label...;
}

class _WelcomeStepTwo extends StatelessWidget {
  const _WelcomeStepTwo({super.key});

  @override
  Widget build(BuildContext context) => _WelcomeFrame(
        step: WelcomeStep.two,
        heroContent: const _WelcomeKeyArt(),
        socialProof: const _WelcomeSocialProof(),
        actions: _WelcomePrimaryButton(
          label: S.current.get_started,
          onPressed: context.read<WelcomeCubit>().finish,
        ),
      );
}

class _WelcomeKeyArt extends StatelessWidget {
  const _WelcomeKeyArt();

  @override
  Widget build(BuildContext context) {
    // The fixed 12 : 06 : 41 is illustrative; no clock drives this screen.
    return Stack(
      children: [
        Positioned.fill(...flat keyArtWash placeholder...),
        Text(S.current.welcome_countdown_title, ...),
        Row(
          children: [
            _WelcomeCountdownTile(
              figure: '12',
              label: S.current.welcome_countdown_days,
            ),
            const _WelcomeCountdownColon(),
            _WelcomeCountdownTile(
              figure: '06',
              label: S.current.welcome_countdown_hours,
            ),
            const _WelcomeCountdownColon(),
            _WelcomeCountdownTile(
              figure: '41',
              label: S.current.welcome_countdown_minutes,
            ),
          ],
        ),
      ],
    );
  }
}

class _WelcomeCountdownTile extends StatelessWidget {
  const _WelcomeCountdownTile({
    required this.figure,
    required this.label,
  });

  final String figure;
  final String label;

  @override
  Widget build(BuildContext context) => ...minimum width 52, radius.xs,
      glass32, 8 x 12 padding, figure above label...;
}

class _WelcomeCountdownColon extends StatelessWidget {
  const _WelcomeCountdownColon();

  @override
  Widget build(BuildContext context) {
    // Raising the colon aligns it with the figures rather than the full tiles.
    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Text(
        ':',
        style: context.tokens.typography.countdownColon.style,
      ),
    );
  }
}

class _WelcomeSocialProof extends StatelessWidget {
  const _WelcomeSocialProof();

  @override
  Widget build(BuildContext context) => ...three overlapping
      26 x 34 _CoverTile instances at radius.mini with a 1.5 canvas border
      and -8 overlap, then S.current.welcome_social_proof...;
}

class _GlassSurface extends StatelessWidget {
  const _GlassSurface({
    required this.fill,
    required this.borderRadius,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  final Color fill;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final blur = context.tokens.effect.glassBlur;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: ...clipped fill, radius, padding, and child...,
    );
  }
}

class _CoverTile extends StatelessWidget {
  const _CoverTile({
    required this.width,
    required this.height,
    required this.borderRadius,
    this.border,
  });

  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Border? border;

  @override
  Widget build(BuildContext context) => ...flat coverWash block...;
}

class _WelcomePrimaryButton extends StatelessWidget {
  const _WelcomePrimaryButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => _PressScale(
        onPressed: onPressed,
        child: ...full-width green, 44 minimum height, black meta label...,
      );
}

class _WelcomeSkipTextAction extends StatelessWidget {
  const _WelcomeSkipTextAction({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => _PressScale(
        onPressed: onPressed,
        child: ...plain ink70 text with 0 x 8 padding and 44 hit target...,
      );
}

class _PressScale extends StatefulWidget {
  const _PressScale({required this.onPressed, required this.child});

  final VoidCallback onPressed;
  final Widget child;

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale> {
  bool _isPressed = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) => FocusableActionDetector(
        onShowFocusHighlight: (value) => setState(() => _isFocused = value),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapCancel: () => setState(() => _isPressed = false),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTap: widget.onPressed,
          child: AnimatedScale(
            scale: _isPressed ? 0.97 : 1,
            duration: context.tokens.motion.resolve(
              context,
              context.tokens.motion.stateChange,
            ),
            child: ...2px-offset green focus outline around widget.child...,
          ),
        ),
      );
}
```

The frame builds its two ambient circles, context chip, and progress dots inline.
The three fan cards are direct children of `_WelcomeStepOne.heroContent`; extracted
stat, key-art, countdown, and social-proof compositions are private
`StatelessWidget` classes. There is no Widget-returning helper function or getter,
generic art placeholder, nullable image slot, one-use figure constant, public
action/chip API, or rendered 330 x 714 mockup frame.

## DELETE

### lib/features/onboarding/presentation/screens/page_view_item.dart

Delete the retired Lottie page item; no replacement file is created.

### assets/animations/onboarding_anim_1.json

Delete the retired first Lottie asset.

### assets/animations/onboarding_anim_2.json

Delete the retired second Lottie asset.

### assets/animations/onboarding_anim_3.json

Delete the retired third Lottie asset.

## TEST FILES

### test/widget/theme/app_tokens_test.dart (modify)

Existing assertions that the authorised token corrections invalidate:

- `'should pair a single green with the black label ink when reading the dark set'`
  — `colors.green` becomes `Color(0xFF35ED7E)`.
- `'should expose the five primary steps when reading their metrics'` —
  `type.body.style.height` becomes `1.45`.
- `'should not add the pending one-off radii when reading the scale'` — `5` leaves the
  pending list, which becomes `[20, 38, 44]`.
- `'should expose the six scale steps when reading the scale'` — becomes seven, with
  `radius.mini` asserted at `5`.
- `_allColors(...)` — gains the nine new colours, so the lerp-completeness test
  actually covers them. This is the assertion `[W1-6.6]` turns on.

New assertions:

- `'should expose the corrected Electric Green when reading the dark set'` — the value
  is `#35ed7e` and `Color(0xFF4CAF50)` appears nowhere in `_allColors`.
- `'should expose the nine onboarding colours when reading the dark set'` — each value,
  and that `surfaceMagentaPanel` is not equal to `surfaceIndigoPanel`.
- `'should expose the seven new app-scale steps when reading their metrics'` — size,
  weight, line height, tracking and colour for each of the seven.
- `'should carry uppercase intent on the welcome headline and micro label when reading
  the scale'` — both true; the other five new steps false.
- `'should expose one float shadow and one glass blur when reading the effect group'` —
  `effect.float` colour, offset and blur radius; `effect.glassBlur` is `9`.
- `'should carry every new field through copyWith when one is replaced'` — a `copyWith`
  on each touched group returns the replacement and leaves siblings alone.
- `'should return a fully populated AppTokens when lerping between two instances'` —
  extended to include the `effect` group, asserting the lerped shadow and blur are
  non-null and mid-way.

### test/widget/theme/theme_data_dark_test.dart (modify)

- `'should expose all five token groups when the extension resolves'` — renamed from
  "four", with `tokens.effect` asserted non-null alongside the existing four. Nothing
  else in the file changes.

### test/cubit/onboarding/welcome_cubit_test.dart (create)

`@GenerateMocks([SharedPreferences])`.

- `'initial state is WelcomeState with step one and inProgress status'` — plain `test`.
- `'emits [step two] when next is called'` — `blocTest`; the state carries
  `WelcomeStep.two` and `WelcomeStatus.inProgress`.
- `'emits [step one] when back is called from step two'` — `blocTest`.
- `'emits [finished] when finish is called'` — `blocTest`; asserts the emitted status
  and `verify(preferences.setBool('first_use', true))`.
- `'should not write the seen flag when next is called'` —
  `verifyNever(preferences.setBool(any, any))` after `next()`. This is `[W1-6.37]`.
- `'should not write the seen flag when back is called'` — same, after `back()`.

### test/widget/onboarding/welcome_screen_test.dart (create)

`@GenerateMocks([SharedPreferences])`. `setUpAll` calls
`await S.load(const Locale('en'))` and sets
`GoogleFonts.config.allowRuntimeFetching = false`. Each step is pumped inside a
`MaterialApp` on `buildDarkTheme()`, over a real `WelcomeCubit` built on the mocked
preferences — the only way the flag assertions can live at the widget layer as
`[W1-6.42]` requires.

- `'should render the first headline, body and a first-step dot when step one
  renders'` — the uppercased headline, the body sentence, and one `22 × 5` active
  pill in first position.
- `'should render the second headline, body and a second-step dot when step two
  renders'` — same, active in second position.
- `'should render the stat figures as fixed strings when step one renders'` — `312`,
  `1,204` and `7` are on screen and exactly three pairs exist.
- `'should write the seen flag when Skip is tapped'` — tap, then
  `verify(preferences.setBool('first_use', true))`.
- `'should write the seen flag when Get started is tapped'` — same on step two.
- `'should not write the seen flag when Next is tapped'` —
  `verifyNever(preferences.setBool(any, any))`.
- `'should render exactly one green element when step one renders'` — walks the
  rendered decorations and counts fills equal to `tokens.color.green`; expects one.
- `'should render exactly one green element when step two renders'` — same.
- `'should render no skip action when step two renders'` —
  `find.text(S.current.skip)` finds nothing. This is `[W1-6.28]`.
- `'should collapse the step transition to zero duration when animations are
  disabled'` — pumps `OnboardingScreen` under
  `MediaQuery(data: MediaQueryData(disableAnimations: true))` and asserts the
  `AnimatedSwitcher`'s duration is `Duration.zero`. This is `[W1-6.32]`.
- `'should not overflow when the viewport is shorter than the reference'` — pumps at a
  reduced surface size and asserts `tester.takeException()` is null. This is
  `[W1-6.41]`.

- `'should not overflow at increased text scale'` — pumps enlarged text and asserts `tester.takeException()` is null.

No golden test, no `matchesGoldenFile`, and nothing under `test/features/`.

# Task Brief
Source: Week-1 checklist item 6 — "Welcome screens" (ref `W1-6`), via
`.agents/runs/welcome-screens-20260802/tech-ac.md`
Date: 2026-08-03
Tech Lead Agent version: 1.0

## Context

Replace the three-page Lottie onboarding with the two-screen welcome flow from
`onboarding-welcome-design-spec.md`, extending the shared design-token layer with
the onboarding values it needs, so a new user meets the product's real visual
language and the flow records itself as seen on either exit.

## Testing mode

`coverage`

Rule applied: "feature touches ... local storage/persistence" — the flow writes
`StorageConstants.firstUseKey` to `SharedPreferences`, and `[W1-6.36]`–`[W1-6.38]`
turn on that write happening on both exits and not mid-flow. The token layer is also
a shared utility read by every feature, which triggers the same rule independently.

Justification: the flag write is the one piece of this feature that is not visual.
If it silently stops happening, a user sees onboarding forever and nothing else
fails. It gets direct assertions at both the cubit and the widget layer.

## File allowlist

### CREATE NEW

lib/config/theme/tokens/app_effect_tokens.dart — the float shadow and the glass blur sigma as one token group
lib/features/onboarding/presentation/blocs/welcome_state.dart — freezed state plus the `WelcomeStep` and `WelcomeStatus` enums
lib/features/onboarding/presentation/blocs/welcome_cubit.dart — step position and the single "onboarding seen" write
assets/animations/.gitkeep — keeps the pubspec-declared asset directory present after the three Lottie files are deleted

### MODIFY EXISTING

lib/config/theme/tokens/app_color_tokens.dart — correct `green`; add the nine onboarding colours to the constructor, `dark`, `copyWith` and `lerp`
lib/config/theme/tokens/app_type_tokens.dart — correct `body` line height; add the seven app-scale steps to the constructor, `dark`, `copyWith` and `lerp`
lib/config/theme/tokens/app_radius_tokens.dart — add the `mini` 5 step; correct the class comment that still calls 5 excluded
lib/config/theme/tokens/app_tokens.dart — wire the new `effect` group into the constructor, `dark`, `copyWith` and `lerp`
lib/core/res/const.dart — remove the three `AssetConstants.onboardingAnimation*` entries
lib/l10n/intl_en.arb — add the sixteen welcome keys; remove the three `onboarding_description_*` keys
lib/l10n/intl_zh.arb — the same sixteen additions and three removals, identical key set
lib/features/onboarding/presentation/screens/onboarding_screen.dart — full rewrite; same route host, with its complete private two-step view hierarchy co-located in this file

### DELETE

lib/features/onboarding/presentation/screens/page_view_item.dart
assets/animations/onboarding_anim_1.json
assets/animations/onboarding_anim_2.json
assets/animations/onboarding_anim_3.json

### TEST FILES

test/widget/theme/app_tokens_test.dart — MODIFY: the corrected `green` and `body` height, the freed 5 radius, the new colour and effect fields in the lerp-completeness helper
test/widget/theme/theme_data_dark_test.dart — MODIFY: the token-group test now covers five groups, not four
test/cubit/onboarding/welcome_cubit_test.dart — CREATE: step transitions, and that only `finish()` writes the seen flag
test/widget/onboarding/welcome_screen_test.dart — CREATE: both steps' headline, body and dot state; both exits writing the flag; Next not writing it; one green element per screen; the reduced-motion collapse

## Implementation plan

**Step 1 — `lib/config/theme/tokens/app_color_tokens.dart`.** Change `green` in the
`dark` instance from `Color(0xFF4CAF50)` to `Color(0xFF35ED7E)`. Add nine fields —
`surfaceMagentaPanel` `#8A2F86`, `keyArtWash` white-free `rgba(30,20,64,.5)`,
`coverWash` `rgba(10,13,58,.42)`, `ambientNeutral` `rgba(255,255,255,.09)`,
`ambientAccent` `rgba(236,72,189,.2)`, `glass30` `rgba(0,0,0,.30)`, `glass32`
`rgba(0,0,0,.32)`, `glass34` `rgba(0,0,0,.34)`, `countdownColon`
`rgba(255,255,255,.4)`. Every one of the nine must appear in the constructor, in the
`dark` instance, in `copyWith` and in `lerp`. Do not add a second name for `#2f3782`
— the welcome-1 hero reuses `surfaceIndigoPanel`.

**Step 2 — `lib/config/theme/tokens/app_type_tokens.dart`.** Change `body`'s line
height from `1.5` to `1.45`. Add seven `AppTextToken` fields, each baking its colour
by referencing `AppColorTokens.dark` the way `zoneLabel` and `meta` already do:
`welcomeHeadline` Space Grotesk 700 at 34 with line height 1.02, letter spacing
`-0.34` and uppercase true, in `ink`; `countdownFigure` Space Grotesk 700 at 30 in
`ink`; `panelTitle` Space Grotesk 700 at 26 in `ink`; `countdownColon` Space Grotesk
400 at 22 in the new `countdownColon` colour; `statFigure` Space Grotesk 700 at 18
with line height 1.1 in `ink`; `caption` Inter 400 at 13 in `ink55`; `microLabel`
Inter 500 at 10 with letter spacing `1.0` and uppercase true, in `ink70`. All seven
go into the constructor, `dark`, `copyWith` and `lerp`.

**Step 3 — `lib/config/theme/tokens/app_radius_tokens.dart`.** Add a `mini` field
valued `5` to the constructor, `dark`, `copyWith` and `lerp`. Correct the class
comment so it lists `20, 38, 44` as the deliberately excluded sizes — 5 is now part
of the scale and the comment must stop saying otherwise.

**Step 4 — `lib/config/theme/tokens/app_effect_tokens.dart`.** New immutable class
`AppEffectTokens` in the shape of its siblings: a `float` field of type `BoxShadow`
holding colour `rgba(69,42,124,0.1)`, offset `(0, 3)` and blur radius `68`; and a
`glassBlur` field of type `double` valued `9`, the Gaussian sigma equivalent of CSS
`blur(18px)`. Give it a `const dark` instance, a `copyWith`, and a static `lerp`
using `BoxShadow.lerp` and `lerpDouble`. Comment why 9 rather than 18, in plain
words.

**Step 5 — `lib/config/theme/tokens/app_tokens.dart`.** Add an `effect` field of
type `AppEffectTokens` to the constructor, to the `dark` instance, to `copyWith` and
to `lerp`, following the existing four groups exactly.

**Step 6 — `lib/l10n/intl_en.arb` and `lib/l10n/intl_zh.arb`.** In *both* files:
delete `onboarding_description_one`, `onboarding_description_two` and
`onboarding_description_three`, and add the sixteen keys from the table in
`## Acceptance criteria reference` `[W1-6.33]` with the English and Chinese values
given there. Leave `next` and `skip` alone — they are reused. The two files must end
with an identical key set; a key in one and not the other fails `[W1-6.33]`. Do not
touch anything under `lib/generated/`.

**Step 7 — `lib/core/res/const.dart`.** Delete the `onboardingAnimation1`,
`onboardingAnimation2` and `onboardingAnimation3` entries from `AssetConstants`.
Leave `error404`, `PathConstants` and `StorageConstants` exactly as they are — the
`firstUseKey` is reused and no new key is added.

**Step 8 — deletions and the asset directory.** Delete
`lib/features/onboarding/presentation/screens/page_view_item.dart` and the three
files `assets/animations/onboarding_anim_1.json`, `_2.json` and `_3.json`. Then
create an empty `assets/animations/.gitkeep`. That last part is not optional:
`pubspec.yaml` declares `assets/animations/` and this run may not edit `pubspec.yaml`
at all, so the directory has to survive the deletion or a fresh clone fails at build
with "unable to find directory entry in pubspec.yaml". A `.gitkeep` is not an image
file and does not breach `[W1-6.17]`.

**Step 9 — `lib/features/onboarding/presentation/blocs/welcome_state.dart`.** Declare
`enum WelcomeStep { one, two }` and `enum WelcomeStatus { inProgress, finished }`,
then a `@freezed sealed class WelcomeState` with a `step` field defaulting to
`WelcomeStep.one` and a `status` field defaulting to `WelcomeStatus.inProgress`. Add
the freezed `part` directive. No error field and no boolean.

**Step 10 — `lib/features/onboarding/presentation/blocs/welcome_cubit.dart`.**
`@injectable class WelcomeCubit extends Cubit<WelcomeState>`, constructor-injected
with `SharedPreferences`, initial state `const WelcomeState()`. Three methods:
`next()` emits `step: WelcomeStep.two`; `back()` emits `step: WelcomeStep.one`; and
an async `finish()` that awaits
`setBool(StorageConstants.firstUseKey, true)` and then emits
`status: WelcomeStatus.finished`. `next()` and `back()` must not touch
`SharedPreferences` — `[W1-6.37]` is the whole point. Do not call `getIt` anywhere in
this file. Do not introduce a `Timer`, `Ticker`, `Stream.periodic` or any `DateTime`
call.

**Generation step — run `dart run build_runner build --delete-conflicting-outputs`.**
The freezed state and the `@injectable` cubit both need generating before anything
imports them, and the DI graph needs rewiring for `WelcomeCubit`.

**Step 11 —
`lib/features/onboarding/presentation/screens/onboarding_screen.dart`.** Replace the
file's contents entirely, keeping the path, the class name `OnboardingScreen` and the
`@RoutePage()` annotation so `OnboardingRoute`, its `/onboarding` path and its
`AppRouter` registration are all reused — do not edit `auto_route_config.dart` and do
not introduce a second onboarding route. The class becomes a `StatelessWidget` whose
`build` returns `BlocProvider(create: (_) => getIt<WelcomeCubit>())` over a private
`_WelcomeFlow`. `_WelcomeFlow` is a stateless widget holding a `BlocListener` that
calls `context.replaceRoute(HomeRoute())` when `status` becomes
`WelcomeStatus.finished`, over a `BlocBuilder` that returns a `Scaffold` wrapping a
`PopScope`: `canPop` is true only on step one, and when a pop is intercepted it calls
`back()`. Inside sits an `AnimatedSwitcher` whose duration is
`context.tokens.motion.resolve(context, context.tokens.motion.screenTransition)` and
whose curve is `context.tokens.motion.screenTransitionCurve`, switching between
private `_WelcomeStepOne` and `_WelcomeStepTwo` on a `ValueKey` of the step.

Keep the complete one-route view hierarchy as private sub-widgets in this same file;
do not create `presentation/widgets/` files. A private `_WelcomeFrame` takes only the
current step, hero content, actions, and optional screen-2 social proof. It derives
the fill, chip, 400/356 reference hero height, copy insets/gap, dot state, headline
and body from the step. In its `LayoutBuilder`, subtract any shortfall from the
714px design reference from the hero height (clamped at zero); the 714 value drives
responsive arithmetic only and must never become a rendered device container. Keep
the copy block in a reversed `SingleChildScrollView`, bottom-anchored and scrollable
at larger text scales. The frame remains exactly hero plus copy, with no separator,
two inline ambient circles, one inline glass context chip and inline progress dots.

Outside the required `Widget.build` override, do not declare a function or getter
whose return type is `Widget` or `List<Widget>`. Use private `StatelessWidget`
classes for reusable or pure UI composition and a private `StatefulWidget` only
when the composition owns local ephemeral state. In
`_WelcomeStepOne`, inject all three positioned cover fan cards directly into the
`heroContent` `Stack`, including the centre card's Playing chip and sole float
shadow; do not hide the fan behind a helper method or wrapper widget. Add private
stateless `_WelcomeStatPill` and `_WelcomeStatPair` classes, with the pill composing
exactly three pairs.

Private `_GlassSurface` owns the only `ImageFilter.blur` and reads both sigmas from
`effect.glassBlur`. Private `_CoverTile` is the concrete flat-wash cover anatomy used
by the fan and mini-cover row; it has only parameters exercised by those current
callers. Compose key art separately. Do not add a nullable image slot or a generic
art-placeholder API. Private `_WelcomePrimaryButton` and `_WelcomeSkipTextAction`
keep their distinct visuals and share only a private stateful `_PressScale` for the
0.97 press transform and 2px-offset green focus outline. Do not reuse the existing
default button/chip widgets: their Material press, fill and focus semantics do not
match `[W1-6.27]`–`[W1-6.30]`.

Step one renders the specified cover fan, focal Playing chip, one float shadow,
three-pair stat pill, and Next/Skip row. Step two renders the separate key-art wash,
fixed `12 : 06 : 41` countdown, optical colon padding, social proof, and lone Get
started action. Implement step two's extracted composition as private stateless
`_WelcomeKeyArt`, `_WelcomeCountdownTile`, `_WelcomeCountdownColon`, and
`_WelcomeSocialProof` classes; `_WelcomeKeyArt` composes the tile and colon widgets,
and `_WelcomeStepTwo` passes `_WelcomeSocialProof` to the frame. Put the six fixed
figures directly at their single constructor call sites; do not create one-use
constants. Keep comments only for the responsive hero/copy relationship, the
one-shadow invariant, the optical colon alignment and the static countdown
rationale. Delete every trace of `PageView`, Lottie and asset lookups.

**Step 12 — `test/widget/theme/app_tokens_test.dart`.** Update the assertions the
token corrections invalidate. This is an authorised specification change, not a test
bent to fit code: `[W1-6.2]` and `[W1-6.4]` change the values these tests were
written against. Change the green assertion to `Color(0xFF35ED7E)`; change
`type.body.style.height` to `1.45`; remove `5` from the "pending one-off radii" list
and assert `radius.mini` is `5` instead; add the nine new colours to the `_allColors`
helper so the lerp-completeness test actually covers them; and extend the lerp test
to exercise the new `effect` group. Add assertions for the seven new type steps'
sizes, weights, line heights, tracking and uppercase intent, and for
`effect.float` and `effect.glassBlur`.

**Step 13 — `test/widget/theme/theme_data_dark_test.dart`.** The test named "should
expose all four token groups when the extension resolves" now under-counts. Rename it
to five and assert `tokens.effect` is not null alongside the existing four. Change
nothing else in this file.

**Step 14 — `test/cubit/onboarding/welcome_cubit_test.dart` and
`test/widget/onboarding/welcome_screen_test.dart`.** Both follow
`testing-conventions.md`: `@GenerateMocks([SharedPreferences])` immediately before
`void main()`, mocks imported from the generated `.mocks.dart`, `GetIt.instance.reset()`
and `reset(mock)` in `tearDown`. The cubit test uses `blocTest` for the state
sequences and plain `test` for the initial state, and asserts with `verify` and
`verifyNever` that only `finish()` writes `first_use`. The widget test registers a
real `WelcomeCubit` constructed on the mocked `SharedPreferences`, pumps the public
`OnboardingScreen` through an `AppRouter`, and advances by tapping localised actions;
private view widgets are not exposed for tests. This is how `[W1-6.42]`'s
"Skip and Get started each writing the flag" can be asserted at the widget layer. Call
`await S.load(const Locale('en'))` in `setUpAll` or the screens will read a null `S`,
and set `GoogleFonts.config.allowRuntimeFetching = false` the way the existing token
test does. Cover: both steps' headline, body and progress-dot state; Skip writing the
flag; Get started writing the flag; Next not writing it; exactly one green element per
screen; no Skip text on step two; the `AnimatedSwitcher` resolving to
`Duration.zero` when `MediaQuery.disableAnimations` is true; and no overflow on a
short viewport or increased text scale. No golden test, no
`matchesGoldenFile`, and no test placed under `test/features/`.

**Generation step — run `dart run build_runner build --delete-conflicting-outputs`.**
Generate the mockito mocks for both new test files before running anything.

**Final step — run `flutter analyze` and `flutter test`, and compare both against the
baselines below.**

From `orchestrator-state.md`, quoted verbatim:

```
Analyzer baseline: 0 errors, 2 warnings, 55 info — captured 2026-08-02T17:15:00
Test baseline: +121 -11 — captured 2026-08-02T17:20:00
```

The test baseline is +121 -11; the failure count must not rise and the failing set
must not change. The six pre-existing failures recorded in `orchestrator-state.md`
are not yours and must not be chased.

**Expect this branch not to compile, and do not try to fix it.** `[W1-6.35]`: the
sixteen new localisation keys have no `S` accessor until a human opens the IDE and
lets the Flutter Intl plugin regenerate `lib/generated/l10n.dart`. There is no CLI
for it on this project — `build_runner` does not do it and `flutter gen-l10n` was
removed. So `flutter analyze` will report undefined-getter errors on
`S.current.welcome_*`, `S.current.get_started` and `S.current.playing`, and
`flutter test` cannot run the new onboarding tests. **That is the expected end state
of this task, not a failure.** Do not hand-write accessors, do not edit anything under
`lib/generated/`, and do not spend a single self-correction attempt on it.

What you must still verify before halting: that every analyzer finding is either in
the baseline or is one of those missing-`S`-accessor errors, and that
`test/widget/theme/app_tokens_test.dart` and
`test/widget/theme/theme_data_dark_test.dart` — neither of which touches `S` — both
pass. Report the exact analyzer counts, name the manual IDE regeneration as the
remaining step, and halt.

## Acceptance criteria reference

### Token layer (authorised extension of week-1 item 4)

[W1-6.1] THEME: `AppColorTokens` gains the onboarding colour values the spec requires
and which no existing token carries: the welcome-2 hero fill `#8a2f86`; the key-art
wash `rgba(30,20,64,.5)`; the cover-tile wash `rgba(10,13,58,.42)`; the neutral
ambient circle `rgba(255,255,255,.09)`; the accent ambient circle
`rgba(236,72,189,.2)`; the glass fills at `rgba(0,0,0,.30)`, `.32` and `.34`; and the
countdown colon at `rgba(255,255,255,.4)`. The welcome-1 hero fill reuses the existing
`surfaceIndigoPanel` (`#2f3782`) rather than adding a duplicate.
  Failure case: if any of these values appears as a literal inside a widget rather
  than as a token, or if `surfaceIndigoPanel` is duplicated under a second name, the
  criterion fails.

[W1-6.2] THEME: The `green` token is corrected from `Color(0xFF4CAF50)` to `#35ed7e`,
the Electric Green given in `system-foundation-specs.md` §1.1. The existing value is a
Material default that predates the authoritative source.
  Failure case: if the CTA renders in Material green, or the old value survives
  anywhere in the token files, the criterion fails.

[W1-6.3] THEME: An elevation token carries `--shadow-float`
(`0 3px 68px rgba(69,42,124,0.1)`, §1.5) and a blur token carries `--blur-glass`
(sigma equivalent to `blur(18px)`, §1.6). Neither exists in the layer today.
  Failure case: if a `BoxShadow` or `ImageFilter.blur` is constructed inline in any
  widget with literal numbers, the criterion fails.

[W1-6.4] THEME: `AppTypeTokens` gains the app-scale steps the spec needs and the
current set lacks: the welcome headline at 34 / 1.02 line-height / `-0.01em` tracking /
display 700 / uppercase; the countdown figure at display 700 30; the panel title at
display 700 26; the countdown colon at display 22; the stat figure at display 700 18 /
1.1; a 13px `ink55` body style; and a 10px `.1em` uppercase micro-label. The `body`
style's line height is corrected from 1.5 to 1.45 per §1.2's Lead row and welcome spec
§4.4.
  Failure case: if the headline renders without uppercase, without the tight leading,
  or without negative tracking; or if any of the listed sizes is applied via an inline
  `TextStyle`, the criterion fails.

[W1-6.5] THEME: `AppRadiusTokens` gains the `5` mini-cover radius, now a sanctioned
local addition (`system-foundation-specs.md` §1.4, §3.3, §6). The file's existing
comment naming 5 among the deliberately-excluded sizes is updated so it no longer
contradicts the code.
  Failure case: if the mini covers render at radius 6, or the stale comment still
  claims 5 is excluded, the criterion fails.

[W1-6.6] THEME: Every token class touched keeps its `copyWith` and `lerp` complete —
each new field appears in both, and `AppTokens` remains constructible as a second
instance for a future light theme without restructuring.
  Failure case: if any new field is missing from `copyWith` or `lerp`, the criterion
  fails. A silently un-lerped field is the exact defect that makes a later light theme
  a rewrite.

[W1-6.7] UI: No widget file added or modified by this run contains a `Color(0x…)`,
`Color.fromRGBO(…)`, a literal `BoxShadow`, a literal blur sigma, or an inline
`TextStyle` with a font size. Every visual value resolves through `context.tokens`.
Verified by inspecting the diff.
  Failure case: any raw colour, shadow, blur or type literal outside
  `lib/config/theme/tokens/` fails the criterion.

### Replacing the existing flow

[W1-6.8] ROUTING: `OnboardingRoute` resolves to the new two-screen welcome flow. The
route name, its `/onboarding` path and its registration in `AppRouter` are reused
rather than replaced with new names.
  Failure case: if a second onboarding route is introduced, or `OnboardingRoute` still
  resolves to the deleted screen, the criterion fails.

[W1-6.9] CLEANUP: `lib/features/onboarding/presentation/screens/onboarding_screen.dart`
(in its three-page Lottie form), `page_view_item.dart`, and
`assets/animations/onboarding_anim_1.json`, `_2.json` and `_3.json` are deleted, along
with their `AssetConstants.onboardingAnimation1/2/3` entries. No reference to any of
them survives anywhere in `lib/`.
  Failure case: if any deleted file is still referenced, or a constant points at a
  missing asset, the criterion fails.

[W1-6.10] ROUTING: `OnboardingGuard` keeps its current behaviour unchanged — it reads
`StorageConstants.firstUseKey` and redirects to `OnboardingRoute` when the flag is
absent or false. No auth awareness is added; that is item 8.
  Failure case: if the guard gains an auth dependency, or its redirect logic changes,
  the criterion fails.

### Shared frame

[W1-6.11] UI: Both screens render a column of exactly two parts — a fixed-height hero
panel, then a copy block that takes the remaining height with its content anchored to
the bottom. There is no border, divider or shadow between the two.
  Failure case: if a separator of any kind appears between hero and copy block, or the
  copy block is top-anchored, the criterion fails.

[W1-6.12] UI: The hero panel is a flat fill with the directional bottom radius
`0 0 88 88`, resolved from the existing `heroShape` radius token. Screen 1 is 400 high
on `surfaceIndigoPanel`; screen 2 is 356 high on the welcome-2 magenta.
  Failure case: any gradient fill, any clipped decorative shape inside the hero, or a
  uniform border radius fails the criterion.

[W1-6.13] UI: Each hero carries one or two ambient circles at the full radius, bled off
the panel edge, using the neutral and accent ambient tokens. Never more than two per
hero, and they are not animated.
  Failure case: a third circle on either hero, or any animation driving them, fails the
  criterion.

[W1-6.14] UI: Each hero carries exactly one glass context chip at 54 from the hero top,
left-aligned, with pill radius, the `.30–.34` black glass fill, `--blur-glass` behind
it, an 11px/500 `.08em` uppercase label and a 13px leading icon. Screen 1 reads
`Your library`; screen 2 reads `Wishlisted · PS5`.
  Failure case: two chips on one hero, a chip with no backdrop blur, or a chip rendered
  as a flat opaque fill fails the criterion.

[W1-6.15] UI: The `330 × 714` device frame, its 38 radius, its hairline outline and the
uppercase screen label are **not** built. The screens fill the device viewport.
  Failure case: if a fixed-size rounded container or a screen-label caption is rendered
  in the app, the criterion fails — that is mockup chrome, and
  `system-foundation-specs.md` §6 records 38 as "hardware geometry, not a UI radius".

### Screen 1 hero

[W1-6.16] UI: Three cover tiles form a fan at `--radius-lg`: left `100 × 134` rotated
-9°, bottom 96; right `100 × 134` rotated 10°, bottom 88; centre `124 × 166` rotated 2°,
bottom 112. Only the centre tile carries the float shadow.
  Failure case: a shadow on any tile other than the centre, or more than one shadow on
  the screen, fails the criterion — §6 states the shadow "appears exactly once".

[W1-6.17] UI: Each cover tile renders a drawn placeholder, not an image asset, carrying
the cover-tile wash so the tile reads as a brand block. No file is added to `assets/`
and no `pubspec.yaml` asset entry changes. Each placeholder is structured so a real
image swaps in without reshaping the widget.
  Failure case: if the run adds an image file, edits `pubspec.yaml`, or renders the
  covers as dashed placeholder slots (a pattern reserved for un-licensable brand marks
  per §1.9), the criterion fails.

[W1-6.18] UI: The centre tile carries a status chip reading `Playing` with a 5px dot,
per welcome spec §3a — not the 6px on-media dot from `system-foundation-specs.md` §3.3.
The welcome spec takes precedence for its own screen.
  Failure case: a 6px dot, or a status chip on a tile other than the centre, fails the
  criterion.

[W1-6.19] UI: A glass stat pill is inset 24 from each side at 34 from the hero bottom,
with pill radius, `10 × 14` padding, the `.3` black glass fill and `--blur-glass`. It
holds three figure/label pairs spaced apart, each figure in display 700 18 and each
label at 10. The figures read `312`, `1,204` and `7` as literal strings.
  Failure case: figures rendered from computed data, a fourth pair, or a flat opaque
  pill fails the criterion.

### Screen 2 hero

[W1-6.20] UI: The key art renders as a drawn placeholder under the flat key-art wash
`rgba(30,20,64,.5)`. The wash is a solid colour, never a scrim gradient. No image file
is added.
  Failure case: any gradient wash, or an added asset file, fails the criterion.

[W1-6.21] UI: A countdown renders as three glass tiles in `DAYS : HRS : MIN` order, each
at `--radius-xs`, minimum width 52, padding `8 × 12`, the `.32` black glass fill with
blur, a display 700 30 figure and a 10px `.1em` uppercase label beneath. Separator
colons render in display 22 at the 40% ink value, optically raised by 26 of bottom
padding. A display 700 26 title sits above.
  Failure case: a colon aligned to the tile centre rather than optically, or a missing
  blur, fails the criterion.

[W1-6.22] UI/STATE: The countdown values are fixed illustrative numbers. No timer,
ticker, `Stream.periodic`, date arithmetic or data source drives them.
  Failure case: any timer or clock dependency in the widget tree fails the criterion —
  §7 states the welcome screens are static by default.

[W1-6.23] UI: A social-proof row appears on screen 2 only, above the progress dots:
three overlapping `26 × 34` mini covers at radius 5, each with a 1.5 border in the onyx
canvas colour and an -8 overlap, beside a 13px `ink55` line.
  Failure case: the row appearing on screen 1, or mini covers at any radius other than
  5, fails the criterion.

### Copy block

[W1-6.24] UI: Progress dots render with the active step as a `22 × 5` pill in full ink
and the inactive step as a `5 × 5` dot at `ink12`, with a 6 gap. Screen 1 has the first
active, screen 2 the second.
  Failure case: numbers, a progress bar, or an equal-width active dot fails the
  criterion.

[W1-6.25] UI: The headline renders in the display face at 700, size 34, line height
1.02, tracking `-0.01em`, in full ink, uppercase, with no terminal period.
  Failure case: a headline with a trailing period, sentence case, or default leading
  fails the criterion.

[W1-6.26] UI: The body renders at 16 / 1.45 in `ink70`, one sentence, sentence case,
ending in a period.
  Failure case: multi-sentence body copy, or body at 1.5 leading, fails the criterion.

[W1-6.27] UI: Screen 1's action row pairs the full-width green primary with a
plain-text `Skip` at 14/500 in `ink70` with `0 × 8` padding, in a row with a 10 gap.
Skip is text, never a second button — it has no fill, no border and no elevation.
  Failure case: Skip rendered as an outlined or filled button fails the criterion.

[W1-6.28] UI: Screen 2's action row holds the green primary alone, with no secondary
action and no skip.
  Failure case: any secondary action on screen 2 fails the criterion.

[W1-6.29] UI: Each screen shows exactly one green element — the primary action — with
black label text, at a minimum height of 44 and full width. No other element on either
screen uses the green token, except the focus ring.
  Failure case: green appearing twice on one screen, or a green CTA with non-black
  label text, fails the criterion. Green is rationed by
  `system-foundation-specs.md` §0.2 and §2.1.

[W1-6.30] UI: Press on any interactive element scales it to 0.97 with no colour change.
Focus renders a 2px green outline at 2px offset.
  Failure case: a press ripple, colour shift, or bounce fails the criterion.

### Motion

[W1-6.31] UI: Advancing screen 1 → screen 2 uses the existing `screenTransition`
duration (420ms) and `screenTransitionCurve`. No parallax, no spring, no scroll-jacking.
  Failure case: a hardcoded duration or curve, or any spring physics, fails the
  criterion.

[W1-6.32] UI: All motion collapses when the platform reports reduced motion, via the
existing `AppMotionTokens.resolve`. A widget test asserts zero duration when
`MediaQuery.disableAnimations` is true.
  Failure case: any animation that still runs under reduced motion fails the criterion.

### Localisation

[W1-6.33] L10N: Sixteen keys are added to **both** `lib/l10n/intl_en.arb` and
`lib/l10n/intl_zh.arb`, and the three `onboarding_description_one/two/three` keys are
removed from both. `next` and `skip` are reused. All user-facing text resolves through
`S.current` — no string literal is rendered directly by any widget.

| Key | English | Chinese |
|---|---|---|
| `welcome_headline_one` | TRACK EVERY GAME YOU'VE EVER TOUCHED | 追踪你玩过的每一款游戏 |
| `welcome_body_one` | Every game you have played, beaten, dropped or shelved, in one place — 312 or 3. | 你打通的、弃坑的、积灰的游戏，全都在一处 —— 312 款还是 3 款都一样。 |
| `welcome_headline_two` | AND KNOW WHAT DROPS NEXT | 抢先知道下一款大作 |
| `welcome_body_two` | Track what you are waiting on and see the countdown to every release you care about. | 追踪你在等的游戏，看着倒计时一天天逼近每一个发售日。 |
| `welcome_chip_one` | Your library | 你的游戏库 |
| `welcome_chip_two` | Wishlisted · PS5 | 已心愿 · PS5 |
| `welcome_stat_tracked` | Tracked | 已追踪 |
| `welcome_stat_hours` | Hours | 小时 |
| `welcome_stat_playing` | Playing | 在玩 |
| `welcome_social_proof` | 2.4M games tracked so far. | 已追踪 240 万款游戏。 |
| `welcome_countdown_title` | NEON VESPER | NEON VESPER |
| `welcome_countdown_days` | Days | 天 |
| `welcome_countdown_hours` | Hrs | 时 |
| `welcome_countdown_minutes` | Min | 分 |
| `get_started` | Get started | 开始使用 |
| `playing` | Playing | 在玩 |

  Failure case: a key present in one `.arb` but not the other, a widget rendering a
  hardcoded string, or a surviving `onboarding_description_*` key fails the criterion.

[W1-6.34] L10N: `lib/generated/l10n.dart`, `lib/generated/intl/messages_en.dart` and
`messages_zh.dart` are **not** hand-edited, and no accessor is hand-written. No bulk
rename touches them.
  Failure case: any manual edit to a generated localisation file fails the criterion.
  This is the exact mistake recorded in `handover.md` gotcha #2, where a `sed` pass
  produced a duplicate map key that compiled fine and silently rendered the wrong
  string.

[W1-6.35] BUILD: The branch is **expected not to compile** until a human opens the IDE
and lets the Flutter Intl plugin regenerate the `S` class. This is a known constraint
of the project's localisation setup (`handover.md` gotcha #1, week-1 item 1a), not a
defect of this run and not a Dev Agent failure. The Dev Agent adds the keys, uses
`S.current.<key>`, and flags the regeneration as a manual step. Analyzer and test
criteria below are assessed **after** that regeneration.
  Failure case: if the Dev Agent hand-writes accessors to force a green build, or QA
  records the pre-regeneration state as a failure, the criterion fails.

### Persistence

[W1-6.36] STORAGE: Exiting the flow by either route — `Skip` on screen 1 or
`Get started` on screen 2 — writes `true` to `StorageConstants.firstUseKey`
(`'first_use'`) via the injected `SharedPreferences`. No new key is introduced and no
wrapper class is written.
  Failure case: if Skip leaves the flag unwritten, or a second key is added, the
  criterion fails.

[W1-6.37] STORAGE: The flag is not written while the flow is in progress. Advancing
from screen 1 to screen 2 writes nothing.
  Failure case: if the flag is set on screen 1's `Next`, the criterion fails — a user
  who kills the app mid-flow would then never see the flow again.

[W1-6.38] STORAGE: With the flag set, a subsequent launch does not show the welcome
flow. With the flag absent or false, it does. Verified against `OnboardingGuard`'s
existing behaviour.
  Failure case: onboarding reappearing after a completed flow fails the criterion.

[W1-6.39] NAVIGATION: Both exits route to the app's existing post-onboarding
destination (`HomeRoute`) and replace the flow in the stack, so back does not re-enter
it. Within the flow, back moves screen 2 → screen 1.
  Failure case: if the welcome flow remains on the back stack after exit, or either
  exit routes somewhere other than the current post-onboarding destination, the
  criterion fails.

### Accessibility, tests, platform

[W1-6.40] UI/A11Y: Every interactive element meets a 44 minimum hit target. Body copy
and metadata meet WCAG AA against their own surface, including text over the hero
fills and over the cover placeholders.
  Failure case: a tap target below 44, or overlay text failing AA against its surface,
  fails the criterion.

[W1-6.41] UI: Neither screen overflows on a viewport shorter than the 714 reference or
at increased platform text scale. The hero panel absorbs the difference; the copy block
stays bottom-anchored.
  Failure case: any render overflow reported by the framework on a shorter viewport
  fails the criterion.

[W1-6.42] TEST: Widget tests live under `test/widget/onboarding/` and cover: both
screens rendering their headline, body and progress-dot state; Skip and Get started
each writing the flag; `Next` not writing it; the single-green-element rule per screen;
and the reduced-motion collapse. No golden tests.
  Failure case: a golden test, a test mirroring `lib/`'s folder shape, or an untested
  flag-writing path fails the criterion.

[W1-6.43] BUILD: After the manual localisation regeneration, the Android debug build
compiles and the analyser reports no new errors or warnings against the run's recorded
baseline (0 errors, 2 warnings, 55 info).
  Failure case: any new analyser error or warning attributable to this run's files
  fails the criterion.

[W1-6.44] PLATFORM: No file added or modified contains a platform conditional, an
iOS-specific branch or a landscape layout.
  Failure case: any platform check in this run's files fails the criterion.

## Constraints

**The token-layer reopening is authorised.** `lib/config/theme/tokens/` is in the
allowlist on purpose. Do not escalate it as scope creep — `tech-ac.md § Constraints`
says an agent that does has misread the document.

**The branch will not compile, and that is the expected end state.** Localisation
regeneration is a human IDE step. Never run `flutter gen-l10n` — that system was
removed from this project on 2026-07-29 and must not be reintroduced. Never edit
anything under `lib/generated/`. Never hand-write an `S` accessor.

**Every new token field must appear in both `copyWith` and `lerp`.** A field added to
a constructor and skipped in `lerp` breaks nothing today and makes the deferred light
theme a rewrite.

**No visual literal outside `lib/config/theme/tokens/`.** No `Color(0x…)`, no
`Color.fromRGBO(…)`, no literal `BoxShadow`, no literal blur sigma, no inline
`TextStyle` carrying a font size. Everything resolves through `context.tokens`.
Geometry — widths, heights, offsets, rotations, icon sizes — is not a visual literal
and stays inline.

**Flat fills only.** No gradient anywhere in this run, including behind the
placeholder art. No scrim gradient for the key-art wash.

**Green is rationed to one element per screen**, always the primary action, always
with black label text. The focus ring is the one sanctioned exception.

**One shadow in the whole run** — `effect.float` on the focal centre cover tile, and
nowhere else.

**Do not touch `pubspec.yaml`.** Not for assets, not to remove the now-unused `lottie`
dependency, not for anything. This is why step 8 adds `assets/animations/.gitkeep`.

**Do not touch `auto_route_config.dart` or `OnboardingGuard`.** The route and the
guard are reused unchanged; keeping the screen's file path, class name and
`@RoutePage()` annotation is what makes that work.

**Use `context.tokens` and `context.themeData`** from `lib/core/utils/extensions.dart`
— never `Theme.of(context)` directly, and do not create a new extension file.

**Never call `getIt<T>()` inside a feature class.** The single sanctioned use is
`BlocProvider(create: (_) => getIt<WelcomeCubit>())` at the screen, per
`project-conventions.md`.

**`SharedPreferences` is injected directly.** There is no wrapper class in this
project and none is to be written. All keys stay in `StorageConstants`.

**Run `dart run build_runner build --delete-conflicting-outputs`** at every generation
step marked above — after the freezed state and `@injectable` cubit, and after the
test files carrying `@GenerateMocks`. Never edit a `.freezed.dart`,
`.g.dart`, `.gr.dart`, `.config.dart` or `.mocks.dart` by hand.

**Tests are grouped by layer, not by feature folder.** `test/cubit/onboarding/` and
`test/widget/onboarding/`. Never `test/features/...`. No golden tests, ever.

**Android portrait only.** No platform conditional, no iOS branch, no landscape
layout.

**Comments in plain English**, explaining why and not what, per
`project-conventions.md`. Keep the widget-tree rationale for responsive hero sizing,
the sole shadow, optical colon alignment and static countdown; do not narrate obvious
classes, token reads or child order.

**Keep the one-route view hierarchy co-located.** Do not create
`presentation/widgets/` files for these one-caller fragments, public generic
press/action/chip widgets, nullable future asset hooks, or constants used once.
Never use a function or getter that returns `Widget` or `List<Widget>` to split a
widget tree. Use a private `StatelessWidget` for pure UI and a private
`StatefulWidget` when local ephemeral state is required.

## Self-correction budget

Max attempts per failure: 3
On budget exhaustion: write escalation.md, halt.
Do not modify test files to make tests pass. The two theme test files in the allowlist
are the one exception, and only for the specific assertions listed in steps 12 and 13 —
those assertions encode token values that `[W1-6.2]`, `[W1-6.4]` and `[W1-6.5]`
deliberately change.
Do not add packages to pubspec.yaml — escalate instead.
Do not touch files outside the allowlist — escalate instead.
Do not spend attempts on the missing `S` accessors — they are the expected end state,
not a failure.

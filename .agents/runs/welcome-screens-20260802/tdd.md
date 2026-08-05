# Technical Design Document
Source: Week-1 checklist item 6 — "Welcome screens" (ref `W1-6`), via
`.agents/runs/welcome-screens-20260802/tech-ac.md`
Date: 2026-08-03
Tech Lead Agent version: 1.0

## Feature summary

A presentation-only feature with an authorised extension of the shared design-token
layer. The existing three-page Lottie onboarding is replaced in place: the
`OnboardingScreen` file, class name, `/onboarding` path and `AppRouter` registration
are all retained, so `auto_route_config.dart` and its generated companion are
untouched and `OnboardingRoute` resolves to the new flow by construction. The screen
becomes a stateless host that provides a screen-scoped `WelcomeCubit` holding the
step position and the "onboarding seen" write, and swaps between two step widgets
through an `AnimatedSwitcher` driven by the existing `screenTransition` motion
tokens. There is no API, repository, entity or use case in this run — the only
persistence is a single `setBool` on the injected `SharedPreferences`, which
`[W1-6.36]` requires be written without a wrapper class. Below the screen sits a
co-located private view hierarchy in the existing screen file. The frame, steps,
glass treatment, cover anatomy and actions are implementation details of this one
route, not public reusable widgets. Every visual value resolves through
`context.tokens`; the token layer gains nine colours, seven text
styles, one radius step, and one new effect group carrying the float shadow and the
glass blur sigma, plus two corrections to values merged in week-1 item 4.

## Layer map

| Criterion | Layers touched |
|---|---|
| `[W1-6.1]`–`[W1-6.6]` | theme tokens (shared config) |
| `[W1-6.7]` | UI (diff-level constraint, all files) |
| `[W1-6.8]`, `[W1-6.10]` | routing (no change required — satisfied by reuse) |
| `[W1-6.9]` | UI (delete), constants (delete), assets (delete) |
| `[W1-6.11]`–`[W1-6.15]` | UI |
| `[W1-6.16]`–`[W1-6.19]` | UI |
| `[W1-6.20]`, `[W1-6.21]`, `[W1-6.23]` | UI |
| `[W1-6.22]` | UI/state (negative criterion — no timer anywhere) |
| `[W1-6.24]`–`[W1-6.30]` | UI |
| `[W1-6.31]`, `[W1-6.32]` | UI + motion tokens |
| `[W1-6.33]`–`[W1-6.35]` | localisation (`.arb` only) |
| `[W1-6.36]`–`[W1-6.38]` | state → local storage (SharedPreferences) |
| `[W1-6.39]` | state → UI (route replacement) |
| `[W1-6.40]`, `[W1-6.41]`, `[W1-6.44]` | UI |
| `[W1-6.42]` | tests |
| `[W1-6.43]` | build |

No criterion maps to the API layer. No API contract or sample input is required.

## Data layer

### API contracts

None. This feature makes no network call.

### Models

None. No DTO, no entity, no serialisation. The three stat figures and the three
countdown figures are fixed literals at their single render sites, per `[W1-6.19]`
and `[W1-6.22]` — they are copy, not data, and modelling or naming one-use constants
them would invite a later data source that `[W1-6.22]` forbids.

### Repositories

None. `[W1-6.36]` requires the seen-flag write to go through the injected
`SharedPreferences` with no wrapper class; `flutter-arch.md § Local storage` records
the same rule for the project as a whole. A repository interface, implementation and
use case wrapping one `setBool` would be exactly the pass-through wrapper both
documents rule out. The write lives in `WelcomeCubit`, which receives
`SharedPreferences` by constructor injection — so no feature class calls `getIt<T>()`
and the write remains mockable at the layer that owns it.

## Domain layer

### Use cases

None. `tech-ac.md § Out of scope` states this run consumes no use cases.

## Theme layer (authorised extension — week-1 item 4 reopened)

### AppColorTokens (modify) — lib/config/theme/tokens/app_color_tokens.dart

Corrected field:
- `green` — from `Color(0xFF4CAF50)` to `Color(0xFF35ED7E)`, the Electric Green in
  `system-foundation-specs.md` §1.1. `[W1-6.2]`

New fields, all carried through `copyWith` and `lerp`:

| Field | Value | Used by |
|---|---|---|
| `surfaceMagentaPanel` | `#8A2F86` | welcome-2 hero fill `[W1-6.12]` |
| `keyArtWash` | `rgba(30,20,64,.5)` | key-art wash `[W1-6.20]` |
| `coverWash` | `rgba(10,13,58,.42)` | cover and mini-cover wash `[W1-6.17]`, `[W1-6.23]` |
| `ambientNeutral` | `rgba(255,255,255,.09)` | neutral ambient circle `[W1-6.13]` |
| `ambientAccent` | `rgba(236,72,189,.2)` | accent ambient circle `[W1-6.13]` |
| `glass30` | `rgba(0,0,0,.30)` | stat pill `[W1-6.19]` |
| `glass32` | `rgba(0,0,0,.32)` | countdown tiles `[W1-6.21]` |
| `glass34` | `rgba(0,0,0,.34)` | context chip `[W1-6.14]` |
| `countdownColon` | `rgba(255,255,255,.4)` | countdown separator `[W1-6.21]` |

The welcome-1 hero reuses the existing `surfaceIndigoPanel` (`#2f3782`) — no second
name for the same value, per `[W1-6.1]`'s failure case. Numeric suffixes on the
glass ramp match the file's own established convention (`ink70`, `ink55`, `ink12`).

### AppTypeTokens (modify) — lib/config/theme/tokens/app_type_tokens.dart

Corrected field:
- `body` — line height `1.5` → `1.45`, per §1.2's Lead row and welcome spec §4.4.
  `[W1-6.4]`

New fields, all carried through `copyWith` and `lerp`. Colours are baked into the
style exactly as the existing `zoneLabel`, `meta` and `zoneLink` tokens bake theirs,
by referencing `AppColorTokens.dark` — so no widget needs a colour override and no
literal is restated:

| Field | Face / weight / size / lh / tracking | Colour | Uppercase |
|---|---|---|---|---|
| `welcomeHeadline` | Space Grotesk 700, 34, 1.02, `-0.34` | `ink` | yes |
| `countdownFigure` | Space Grotesk 700, 30 | `ink` | no |
| `panelTitle` | Space Grotesk 700, 26 | `ink` | no |
| `countdownColon` | Space Grotesk 400, 22 | `countdownColon` | no |
| `statFigure` | Space Grotesk 700, 18, 1.1 | `ink` | no |
| `caption` | Inter 400, 13 | `ink55` | no |
| `microLabel` | Inter 500, 10, tracking `1.0` | `ink70` | yes |

Tracking is the em value resolved against the size: `34 × -0.01em = -0.34`,
`10 × .1em = 1.0`. `countdownColon` is the one display step the criteria list
without a weight — `[W1-6.4]` writes "display 700" for the figure, the title and the
stat figure, and plain "display 22" for the colon, so it takes the body-adjacent 400
that `system-foundation-specs.md` §1.2 pairs with the display face.

### AppRadiusTokens (modify) — lib/config/theme/tokens/app_radius_tokens.dart

- New field `mini` = `5`, carried through `copyWith` and `lerp`. `[W1-6.5]`
- The class comment listing `20, 5, 38, 44` as deliberately excluded is corrected to
  `20, 38, 44` so it no longer contradicts the code.

### AppEffectTokens (create) — lib/config/theme/tokens/app_effect_tokens.dart

| Field | Type | Value |
|---|---|---|
| `float` | `BoxShadow` | colour `rgba(69,42,124,0.1)`, offset `(0, 3)`, blur radius `68` |
| `glassBlur` | `double` | `9` — the Gaussian sigma equivalent of CSS `blur(18px)` |

Shadow and blur ship as one group rather than two classes. They are the two
surface-treatment values of the same spec pair (`system-foundation-specs.md` §1.5
elevation and §1.6 transparency & blur), they change together when the elevation
language changes, and a one-field class in this codebase would add a `copyWith` and
`lerp` surface for no separation benefit. `float` is used exactly once in the app —
the focal cover tile `[W1-6.16]`. `glassBlur` is read in exactly one place,
`GlassSurface`, which is the only widget that constructs an `ImageFilter`. `[W1-6.3]`

`lerp` uses `BoxShadow.lerp` for `float` and `lerpDouble` for `glassBlur`.

### AppTokens (modify) — lib/config/theme/tokens/app_tokens.dart

Gains a fifth group, `effect`, wired into the constructor, the `dark` instance,
`copyWith` and `lerp`. `AppTokens` remains constructible as a second instance for a
future light theme with no restructuring. `[W1-6.6]`

## State layer

### WelcomeState (create) — lib/features/onboarding/presentation/blocs/welcome_state.dart

`@freezed sealed class WelcomeState`, with two feature-scoped enums declared in the
same file:

- `enum WelcomeStep { one, two }`
- `enum WelcomeStatus { inProgress, finished }`

State variants: `WelcomeState(step: WelcomeStep, status: WelcomeStatus)`, defaulting
to `(one, inProgress)`.

Two enums rather than one, and no boolean: step position and flow completion are
independent facts, and collapsing them would make "finished from step one" and
"finished from step two" indistinguishable to the progress dots. No `ErrorType?`
field — the only I/O is `SharedPreferences.setBool`, which has no failure the user
can act on and no error surface in the design.

### WelcomeCubit (create) — lib/features/onboarding/presentation/blocs/welcome_cubit.dart

  Scope: screen — provided by `BlocProvider` inside `OnboardingScreen`
  Registration: `@injectable`, constructor-injected with `SharedPreferences`
  State variants: as above

  `next()` → emits `step: two`. Writes nothing. `[W1-6.37]`
  `back()` → emits `step: one`. Writes nothing. `[W1-6.39]`
  `finish()` → awaits `setBool(StorageConstants.firstUseKey, true)`, then emits
  `status: finished`. Called by both Skip and Get started. `[W1-6.36]`

SRP: one cubit, one feature boundary — the welcome flow's position and its single
exit. Skip and Get started share one `finish()` method because `[W1-6.36]` makes
them identical; two methods with the same body would be duplication, not clarity.
DIP: the cubit depends on `SharedPreferences`, resolved by DI, and never reaches for
`getIt`. Provision through `BlocProvider(create: (_) => getIt<WelcomeCubit>())` at
the screen is the sanctioned use of the locator per `project-conventions.md`.

No `Timer`, `Ticker`, `Stream.periodic` or `DateTime` appears in this cubit or
anywhere else in the run. `[W1-6.22]`

## UI layer

### Screens

OnboardingScreen (modify — full rewrite) — lib/features/onboarding/presentation/screens/onboarding_screen.dart
  Type: stateless
  Consumes: `WelcomeCubit`
  Handles: provides the cubit; navigates on `status == finished`; intercepts system
  back so step two returns to step one; swaps the two steps through an
  `AnimatedSwitcher` at `motion.resolve(context, motion.screenTransition)` with
  `motion.screenTransitionCurve`
  Navigates to: `HomeRoute` via `context.replaceRoute` — the flow leaves the stack
  `[W1-6.39]`

The file path, the class name and the `@RoutePage()` annotation are unchanged, so
`OnboardingRoute`, its `/onboarding` path and its `AppRouter` registration are
reused rather than replaced. `auto_route_config.dart` needs no edit. `[W1-6.8]`

`OnboardingGuard` is not touched. `[W1-6.10]`, `[W1-6.38]`

### Widgets

All are private sub-widgets in
`lib/features/onboarding/presentation/screens/onboarding_screen.dart`; no
`presentation/widgets/` files are created for a view hierarchy owned by one route.

`_WelcomeFrame`
  Type: stateless
  Consumes: none — pure composition
  Handles: none
  Takes only the current `WelcomeStep`, hero content, actions, and the optional
  screen-2 social-proof row. It derives the step's hero fill, chip, reference hero
  height, copy spacing, progress state, headline and body internally, avoiding the
  previous parameter bag. The 714px mockup height is a sizing reference, never a
  rendered device frame: viewport shortfall is subtracted from the step's 400/356
  reference hero height, while the reversed scrollable copy block stays anchored at
  the bottom and absorbs larger text without overflow. It renders exactly two
  vertical parts, no separator, exactly two ambient circles and one context chip.

`_WelcomeStepOne`, `_WelcomeStepTwo`
  Type: stateless
  Consume: `WelcomeCubit` through callbacks
  Handle: Next → `next()`; Skip/Get started → `finish()`
  Each owns only its distinct hero and action composition. Step one owns the cover
  fan, focal Playing chip, stat pill and Next/Skip row. Step two owns the key-art
  field, fixed countdown, social proof and lone Get started action.

`_WelcomeStatPill`, `_WelcomeStatPair`, `_WelcomeKeyArt`,
`_WelcomeCountdownTile`, `_WelcomeCountdownColon`, `_WelcomeSocialProof`,
`_GlassSurface`, `_CoverTile`, `_WelcomePrimaryButton`,
`_WelcomeSkipTextAction`, `_PressScale`
  Private implementation widgets in the same screen file. Every reusable or pure UI
  composition is a `StatelessWidget`; `_PressScale` alone is stateful because it owns
  local press and focus state. `_WelcomeStepOne.heroContent` receives the three
  positioned fan cards directly, including the focal Playing chip and sole float
  shadow, plus a `_WelcomeStatPill`; the fan is not hidden behind a helper method or
  wrapper widget. `_WelcomeStatPill` composes three `_WelcomeStatPair` instances.
  `_WelcomeKeyArt` owns the fixed countdown and composes three
  `_WelcomeCountdownTile` instances with two `_WelcomeCountdownColon` instances.
  `_WelcomeSocialProof` owns the mini-cover row. `_GlassSurface` is the single
  token-backed blur construction. `_CoverTile` is the concrete cover anatomy shared
  by the fan and mini-cover row. The two action widgets keep their distinct semantics
  and share only `_PressScale`'s press and focus behaviour. There is no
  Widget-returning helper function, public generic action/chip/placeholder API,
  always-null image slot, future-only variant, or one-use display constant.

Ambient circles, progress dots and the context chip remain inline because they are
single-use declarative children. Extracted composition never uses a method or getter
returning `Widget`: pure UI uses a private `StatelessWidget`, and UI requiring local
state uses a private `StatefulWidget`. Comments are limited to the non-obvious
hero-shrink/bottom-anchor rule, the single-shadow rule, the optical colon alignment,
and the fact that countdown values are intentionally static.

## Reuse decisions

`OnboardingScreen` file, class, route and registration at
`lib/features/onboarding/presentation/screens/onboarding_screen.dart` and
`lib/config/route/auto_route_config.dart` — reused unchanged so `OnboardingRoute`
keeps its name and `/onboarding` path, and the generated router needs no edit.
`[W1-6.8]`

`OnboardingGuard` at `lib/config/route/guards/onboarding_guard.dart` — reused
unchanged. Its `StorageConstants.firstUseKey` read already produces `[W1-6.38]`'s
behaviour. `[W1-6.10]`

`StorageConstants.firstUseKey` at `lib/core/res/const.dart` — reused. No new key.
`[W1-6.36]`

`SharedPreferences` via `StorageModule` at `lib/core/di/storage_module.dart` —
injected directly, no wrapper, per `flutter-arch.md § Local storage`.

`AppColorTokens.surfaceIndigoPanel` — reused for the welcome-1 hero rather than
adding a duplicate `#2f3782`. `[W1-6.1]`

`AppRadiusTokens.heroShape` — the existing `0 0 88 88` directional radius carries
both heroes. `[W1-6.12]`

`AppRadiusTokens.pill` / `.xs` / `.lg` — reused for the chips, countdown tiles and
cover tiles. Only `mini` is new.

`AppTypeTokens.pill` (11/500 `.08em` caps) — reused for the context-chip label
`[W1-6.14]` and the focal status-chip label `[W1-6.18]`. No new 11px token.

`AppTypeTokens.meta` (14/500 `ink70`) — reused for the Skip label `[W1-6.27]` and,
with a colour override to `inkDark`, for the primary action label `[W1-6.29]`. No
new 14px token.

`AppMotionTokens.screenTransition`, `.screenTransitionCurve`, `.stateChange` and
`.resolve` — reused for the step transition and the press scale. Nothing hardcodes a
duration or a curve. `[W1-6.31]`, `[W1-6.32]`

`ContextExtensions.tokens` and `.bottomPadding` at `lib/core/utils/extensions.dart`
— reused. No new extension file, per `dart-style.md`.

`context.replaceRoute(HomeRoute())` — the same exit the deleted screen used, so the
post-onboarding destination is unchanged. `[W1-6.39]`

## Out of scope

- Any repository, use case, entity or model. `[W1-6.36]` forbids a wrapper class and
  the BA scoped this run to no use cases; one `setBool` does not earn three layers.
- Any `pubspec.yaml` change, including asset registration and removing the now-unused
  `lottie` dependency. See Constraints for how the emptied asset directory is kept
  valid without one.
- Any auth wiring, splash screen or auth screen — items 7 and 8.
- The design-system `Button`, `Badge` and `Icon` — week 2. The green action is local
  to this feature.
- A light `AppTokens` instance. The layer stays structurally ready for one; none is
  built.
- Real cover art, key art and the app mark. All stay drawn placeholders.
- `--surface-art` / `--surface-art-deep`. Still numerically undefined and confirmed
  not needed.
- The `ql-breathe` ambient animation. The circles are static. `[W1-6.13]`
- Golden tests, integration tests, iOS layout and any platform conditional.
  `[W1-6.42]`, `[W1-6.44]`

## Open questions

None.

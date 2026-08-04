# Technical Design Document
Source: Ticket `W1-6.2R` — "Welcome screens polish + global system UI convention (item 6.2)"
(`.agents/runs/welcome-screens-polish-20260804/tech-ac.md`)
Date: 2026-08-04

## Feature summary

A presentation-layer-only change plus one app-startup line. No data, domain or state
class is created or modified: `WelcomeCubit`, `WelcomeState` and the onboarding-seen
persistence path are untouched, and `WelcomeState.step` stays the single source of truth.
The welcome screen's existing `_WelcomeView` becomes a `StatefulWidget` so it can own a
`PageController` — local ephemeral UI state that cannot live in a Cubit — and replaces
`AnimatedSwitcher` with a two-page `PageView` wrapped in the standard
`Scaffold(body: SafeArea(...))` shell. Step and page reconcile in two directions through
the existing `WelcomeCubit.next()` / `back()` methods, which is also what structurally
guarantees no page change can reach persistence. Three tuned layout numbers move into the
feature's own `const.dart`. The system UI overlay style is set once in `bootstrap.dart`,
the shared startup sequence both flavour entrypoints already run.

## Layer map

| ID | Layers touched |
|---|---|
| `[W1-6.2R.1]`, `[W1-6.2R.2]` | UI (`WelcomeHero`), feature constants |
| `[W1-6.2R.3]` | UI (`OnboardingScreen` step widgets), feature constants |
| `[W1-6.2R.4]` | UI (`WelcomeContainer` — existing give-back retained, no change) |
| `[W1-6.2R.5]` | Docs |
| `[W1-6.2R.6]` | UI (`OnboardingScreen` shell) |
| `[W1-6.2R.7]` | UI (`WelcomeContainer`) |
| `[W1-6.2R.8]`, `[W1-6.2R.9]`, `[W1-6.2R.10]` | App startup (`bootstrap.dart`) |
| `[W1-6.2R.11]` | Docs |
| `[W1-6.2R.12]`, `[W1-6.2R.13]` | UI (`OnboardingScreen` paging viewport) |
| `[W1-6.2R.14]` | UI ↔ State (no state class change; existing cubit methods drive it) |
| `[W1-6.2R.15]` | UI (`WelcomeContainer` — unchanged by design, see decision 4) |
| `[W1-6.2R.16]` | UI (no change to the action row) |
| `[W1-6.2R.17]` | UI (`OnboardingScreen` page sync, motion tokens) |
| `[W1-6.2R.18]` | UI (`PopScope` retained, now feeding the viewport) |
| `[W1-6.2R.19]` | State (guaranteed by reusing `next()` / `back()`, which never write) |
| `[W1-6.2R.20]`–`[W1-6.2R.22]` | Test |
| `[W1-6.2R.23]` | Build |

## Data layer

No API, no model, no repository, no local-storage change. `SharedPreferences` access stays
exactly where it is, inside `WelcomeCubit.finish()`.

## Domain layer

No use case created or modified. The onboarding feature has none and this run adds none.

## State layer

`WelcomeCubit` (unchanged) — `lib/features/onboarding/presentation/blocs/welcome_cubit.dart`
— scope: screen (existing `BlocProvider` in `OnboardingScreen`). `next()` and `back()` are
reused verbatim as the page-change handlers; `finish()` remains the only method that writes
storage, so `[W1-6.2R.19]` holds by construction rather than by convention. `WelcomeState`
is unchanged, so no freezed regeneration is required for it.

Loop safety: `Cubit.emit` drops an emission when the new state equals the current one, and
`WelcomeState` gets value equality from freezed. A settled page therefore calls
`next()`/`back()` and, when the step already matches, emits nothing — the controller→state
direction self-terminates. The state→controller direction terminates on an explicit guard
(`controller.page.round() == target` returns early). This is what `[W1-6.2R.14]`'s "must
reconcile without re-triggering each other" resolves to.

## UI layer

### Screens

`OnboardingScreen` (modify) — `lib/features/onboarding/presentation/screens/onboarding_screen.dart`
— stateless, `@RoutePage`, unchanged: provides `WelcomeCubit` via `getIt` and renders
`_WelcomeView`.

`_WelcomeView` (modify: stateless → **stateful**) — same file — owns and disposes a
`PageController`. Consumes `WelcomeState`. Composition, outermost first:

- `Scaffold` → `SafeArea` (all four edges) — static shell, deliberately **outside** the
  reactive boundary per `flutter-arch.md § Reactive boundary convention`. One `SafeArea`
  at the screen level, not one per page.
- `MultiBlocListener` with two listeners: status → `context.replaceRoute(AuthRoute())`
  (existing behaviour, moved verbatim); step → move the controller to the matching page.
- `BlocSelector<WelcomeCubit, WelcomeState, WelcomeStep>` — the lowest boundary that
  actually consumes state, because `PopScope.canPop` is the only shell property that
  depends on it.
- `PopScope(canPop: step == one, onPopInvokedWithResult: → cubit.back())` — `[W1-6.2R.18]`,
  existing logic unchanged.
- `PageView` — horizontal (default axis), `controller`, `onPageChanged`, two const
  children in order `[_WelcomeStepOne, _WelcomeStepTwo]`. Default physics is used: on
  Android `PageScrollPhysics` over `ClampingScrollPhysics` already clamps at both ends,
  which is `[W1-6.2R.12]`'s requirement — no explicit `physics` argument is added.

Page-change animation (`[W1-6.2R.17]`): the step listener resolves
`tokens.motion.screenTransition` through `tokens.motion.resolve(context, ...)`. A zero
result (reduced motion) uses `jumpToPage`; otherwise `animateToPage` with
`tokens.motion.screenTransitionCurve`. `jumpToPage` rather than a zero-duration
`animateToPage` because only the former is genuinely instant within a single frame, which
is what makes the criterion assertable in a widget test. A user's own drag runs through
`PageView`'s own physics and is never gated on the reduced-motion flag.

`_WelcomeStepOne` / `_WelcomeStepTwo` (modify) — same file — lose their `ValueKey`s (they
existed only for `AnimatedSwitcher`) and read their hero height from the new constants.
Otherwise unchanged: same labels, same callbacks, same placement (`[W1-6.2R.16]`).

### Widgets

`WelcomeHero` (modify) — `lib/features/onboarding/presentation/widgets/welcome_hero.dart`
— stateless. The content `Image.asset` gains a `Padding` of
`WelcomeLayoutConstants.heroContentPadding` on all four sides. The `ColoredBox` fill, the
background `Image.asset` and the `ClipRRect` radius stay outside that padding, so they
still cover the panel edge to edge (`[W1-6.2R.1]`). `BoxFit.contain` and the `Stack`'s
default centre alignment are untouched, so `[W1-6.2R.2]` holds — the padding shrinks the
box, nothing else.

`WelcomeContainer` (modify) — `lib/features/onboarding/presentation/widgets/welcome_container.dart`
— stateless. One change: the copy block's bottom padding drops `+ context.bottomPadding`
(`[W1-6.2R.7]`). Everything else — the `LayoutBuilder` short-screen give-back, the two
progress dots, the type and spacing — is untouched. The dots stay per-page and are driven
by the `step` constructor argument, which each page passes as a fixed literal, so the
indicator cannot read a controller position (`[W1-6.2R.15]`).

The `ContextExtensions.bottomPadding` getter itself is **not** removed —
`ScrolledNavigationBar` still uses it. `[W1-6.2R.7]` bans the read inside the welcome tree,
not the extension.

### App startup

`bootstrap.dart` (modify) — `lib/bootstrap.dart` — a single
`SystemChrome.setSystemUIOverlayStyle(...)` call after
`WidgetsFlutterBinding.ensureInitialized()` and before `runApp`. Both `main.dart` and
`main_prod.dart` already funnel through it, so `[W1-6.2R.8]`'s "every flavour entrypoint"
is satisfied without touching either. The navigation bar colour reads
`AppColorTokens.dark.canvas` — the existing static token, not a literal (`[W1-6.2R.9]`).
Status bar transparent, divider transparent, both icon brightnesses `light`. No new token,
no new file. `statusBarBrightness` (iOS-only) is deliberately omitted per `[W1-6.44]`.

### Constants

`WelcomeLayoutConstants` (create, inside the existing feature `const.dart`) —
`lib/features/onboarding/const.dart` — `heroHeightOne = 240`, `heroHeightTwo = 216`,
`heroContentPadding = 24`. Placed here per `execution.md § Code quality` — only the
onboarding feature needs them, so they belong in the feature's own `const.dart`, not in
`lib/core/res/const.dart` and not inline in a widget file. A practical consequence worth
the move: all three design-gate numbers become a one-file edit.

## Design-gate decisions

`tech-ac.md ## Design-gate items` lists five open visual calls. Each is resolved here with
a concrete design and a provisional value, so nothing downstream is blocked. A gate
decision that changes a number changes only `const.dart`; a decision that changes
2 or 4 changes `onboarding_screen.dart` structure and is called out as such.

1. **Hero content padding — `24` on all four sides.** Implemented as a single
   `EdgeInsets.all(WelcomeLayoutConstants.heroContentPadding)` inside `WelcomeHero`, around
   the content image only. Retuning is a one-line constant change; the uniform-all-sides
   shape is what `[W1-6.2R.1]` requires, so a per-axis alternative would reopen that
   criterion.
2. **Hero heights — `240` (screen 1) and `216` (screen 2).** Held in
   `WelcomeLayoutConstants` and passed to `WelcomeContainer.heroHeight` from each step
   widget, exactly as the current `400` / `356` literals are. Both are on the 8px scale,
   33.6% and 30.3% of the 714 reference, screen 1 ≥ screen 2. Retuning is a one-line
   constant change.
3. **Status-bar bleed — no bleed; `SafeArea` insets all four edges.** One `SafeArea` at the
   screen level directly inside `Scaffold.body`, matching the `games_screen.dart`
   precedent and the app-wide rule this run writes into `project-conventions.md`. Visible
   consequence, provisionally accepted: a canvas band sits between the status bar and the
   hero's top radius. The alternative (`SafeArea(top: false)` on these two screens) is an
   explicit documented exception to `[W1-6.2R.11]`, not a free choice, and would be a
   one-argument change to the same line.
4. **Progress-dot placement — per page, inside each page's own copy block.** No structural
   change to `WelcomeContainer`; each page passes a fixed `step` literal, so each
   indicator is static by construction and cannot read the drag offset. Mid-drag both
   indicators are briefly on screen, sliding with their pages. The alternative (one
   indicator hoisted above the `PageView`) would move the dots out of the bottom-anchored
   copy block and change its layout, so it is a larger change than it looks — flagged, not
   taken.
5. **Short-screen give-back — unchanged and uncapped.** `WelcomeContainer` keeps
   `shortfall = (714 - maxHeight).clamp(0, heroHeight)` exactly as written. Concrete
   provisional outcome at the criterion's own test viewport (`360 × 600`, no system
   insets): shortfall `114`, hero renders at `240 - 114 = 126` on screen 1 and
   `216 - 114 = 102` on screen 2 — roughly half each hero, not a sliver, and the copy block
   still clears 1.5× text without overflow. No floor or cap is added, because a floor
   re-introduces the overflow risk `[W1-6.2R.4]` exists to prevent and nothing in the
   criteria asks for one. If the gate wants a floor, it is a one-expression change in
   `WelcomeContainer` and needs `[W1-6.2R.4]`'s overflow case re-verified.

## Reuse decisions

- `WelcomeCubit.next()` / `back()` at `lib/features/onboarding/presentation/blocs/welcome_cubit.dart`
  — reused as the settled-page handlers instead of adding a `goTo(step)` method. They
  already mean exactly "go to step two" / "go to step one", they never touch storage, and
  reusing them keeps the cubit out of the allowlist entirely, which is the cleanest
  possible guarantee for `[W1-6.2R.19]`.
- `WelcomeState` + freezed value equality — reused as the loop breaker described in
  `## State layer`. No new flag, no `isAnimating` bookkeeping.
- `AppMotionTokens.resolve` / `screenTransition` / `screenTransitionCurve` at
  `lib/config/theme/tokens/app_motion_tokens.dart` — reused verbatim from the
  `AnimatedSwitcher` they replace, which is what carries `[W1-6.32]` forward.
- `AppColorTokens.dark.canvas` at `lib/config/theme/tokens/app_color_tokens.dart` — reused
  as the navigation-bar colour. No new token (`[W1-6.2R.9]`).
- `Scaffold(body: SafeArea(child: ...))` precedent from `games_screen.dart` (and six other
  screens) — reused as-is rather than inventing a wrapper widget.
- `ContextExtensions.bottomPadding` — kept in place for `ScrolledNavigationBar`; only the
  welcome-tree call site is removed.
- `WelcomeContainer`, `WelcomeHero`, `PrimaryButton`, `SkipTextAction` — all reused
  unchanged in role; no new presentation component is created by this run.

## Out of scope

- Any new file. Every change lands in a file that already exists.
- `welcome_cubit.dart`, `welcome_state.dart`, `test/cubit/onboarding/welcome_cubit_test.dart`
  — the cubit's behaviour is unchanged, so its unit test is untouched.
- Auditing other screens against the new `SafeArea` / overlay-style convention — excluded
  by `tech-ac.md ## Out of scope`. Related known behaviour, recorded so it is not mistaken
  for a defect later: Material's `AppBar` publishes its own `systemOverlayStyle` through an
  `AnnotatedRegion`, so a screen with an app bar can locally override the global default.
  No welcome screen has one, and reviewing the screens that do is explicitly a later run.
- Golden tests, in any form (`execution.md § Scope`). Pixel fidelity of the padded art and
  the feel of the swipe are QA's manual visual checks.
- `pubspec.yaml`, the token layer, the `.arb` files and `lib/generated/l10n.dart` — no new
  package, token, or localisation key, so none are opened.
- Landscape, iOS, and a light theme.

## Open questions

NONE.

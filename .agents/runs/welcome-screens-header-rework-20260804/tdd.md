# Technical Design Document
Source: Ticket `W1-6.1R` — "Welcome screens header rework (item 6.1)"
(`.agents/runs/welcome-screens-header-rework-20260804/tech-ac.md`), amending
`.agents/runs/welcome-screens-20260802/tech-ac.md` (ref `W1-6`)
Date: 2026-08-04

## Feature summary

Presentation-only net deletion inside `features/onboarding`. `WelcomeContainer` keeps its
two-part frame (fixed-height hero, then bottom-anchored copy block) but its hero subtree
collapses from a five-layer composed `Stack` to at most two layers: a fill (flat token
colour on step one, a cover-fitted asset image on step two) and one contain-fitted,
centered asset image. The three composed hero widgets (`CoverTile`, `WelcomeKeyArt`,
`WelcomeStatPill`) and the screen-local `_WelcomeSocialProof` are deleted outright, along
with `WelcomeContainer`'s `heroContent` and `socialProof` constructor parameters — the
container now derives everything it renders from the `WelcomeStep` it already receives.
No layer below presentation is touched: no model, repository, use case, Cubit, state,
route, DI registration or persistence change. Ten localisation keys whose only consumers
disappear are removed from both `.arb` sources. Three PNGs already on disk under the
already-registered `assets/images/` directory become the only new inputs, addressed
through `PathConstants.imagePath` plus three new `AssetConstants` entries so the asset
keys are declared once and shared with the widget test.

## Layer map

`[W1-6.1R.1]`: UI (widget)
`[W1-6.1R.2]`: UI (widget), theme token read only
`[W1-6.1R.3]`: UI (widget), asset bundle
`[W1-6.1R.4]`: UI (widget), asset bundle, constants (`core/res`)
`[W1-6.1R.5]`: UI (widget)
`[W1-6.1R.6]`: UI (widget)
`[W1-6.1R.7]`: UI (widget)
`[W1-6.1R.8]`: UI (widget + screen), file deletions
`[W1-6.1R.9]`: UI/STATE — verification only; no timer exists after the deletions
`[W1-6.1R.10]`: UI (widget + screen)
`[W1-6.1R.11]`: BUILD — no `pubspec.yaml` edit; asset addressed from the bundle
`[W1-6.1R.12]`: THEME — read-only; no token file is in the allowlist
`[W1-6.1R.13]`: UI (widget)
`[W1-6.1R.14]`: L10N (`lib/l10n/*.arb` only)
`[W1-6.1R.15]`: BUILD — `lib/generated/` deliberately untouched
`[W1-6.1R.16]`: UI (widget), semantics
`[W1-6.1R.17]`: UI (widget layout)
`[W1-6.1R.18]`: TEST (widget)
`[W1-6.1R.19]`: BUILD
`[W1-6.1R.20]`: TEST (widget)

Carried-forward criteria touching these layers but requiring no change:
`[W1-6.7]`, `[W1-6.11]`, `[W1-6.12]` (height/radius clauses), `[W1-6.24]`–`[W1-6.32]`,
`[W1-6.33]` (surviving keys), `[W1-6.36]`–`[W1-6.39]`, `[W1-6.40]`, `[W1-6.41]`,
`[W1-6.42]`, `[W1-6.44]`.

## Data layer

No API contract, model, repository or datasource is created or modified. No criterion in
this run maps to the data layer, so no `api-contracts.md` input is required.

## Domain layer

No use case is created or modified.

## State layer

`WelcomeCubit` (`lib/features/onboarding/presentation/blocs/welcome_cubit.dart`) and
`WelcomeState` (`welcome_state.dart`, including the `WelcomeStep` and `WelcomeStatus`
enums) are unchanged. `WelcomeStep` continues to be the only input the hero varies on,
which is why the container can drop its widget-slot parameters rather than gain new ones.
The reactive boundary stays where item 6 put it: `BlocListener` + `BlocBuilder` inside
`OnboardingScreen`'s `_WelcomeView`, above the `AnimatedSwitcher`. Nothing in this run
lowers or raises it.

## UI layer

### Screens

`OnboardingScreen` (modify) — `lib/features/onboarding/presentation/screens/onboarding_screen.dart`
— stateless — consumes `WelcomeCubit` / `WelcomeState` — interactions unchanged (`next`,
`finish`, system back via `PopScope`) — navigates by replacing the flow, unchanged.
Changes are confined to its two private step widgets and the deletion of one private
widget:
- `_WelcomeStepOne` — drops the `heroContent` `Stack` of three `CoverTile`s and the
  `WelcomeStatPill`; passes `step` and `actions` only. Action row (`PrimaryButton` Next +
  `SkipTextAction` Skip) unchanged.
- `_WelcomeStepTwo` — drops `heroContent: WelcomeKeyArt()` and `socialProof:`; passes
  `step` and `actions` only. Action (`PrimaryButton` Get started) unchanged.
- `_WelcomeSocialProof` — deleted with the class, satisfying `[W1-6.1R.10]`.
- Imports of `cover_tile.dart`, `welcome_key_art.dart` and `welcome_stat_pill.dart` are
  removed; `welcome_skip_text.dart`, `primary_button.dart`, routing, DI and `l10n`
  imports stay.

### Widgets

`WelcomeContainer` (modify) — `lib/features/onboarding/presentation/widgets/welcome_container.dart`
— stateless — consumes `context.tokens` — no interactions. **Superseded, see
`code-plan.md ## Approved feedback delta`:** constructor becomes
`{required WelcomeStep step, required double heroHeight, required Widget hero, required
String headline, required String body, required Widget actions}` — height, hero and copy
are now resolved by the caller and passed in, not derived from `step` internally. `step`
survives only to drive the progress-dot row and the first-screen-vs-rest spacing values.
`heroContent` and `socialProof` are removed as before.
Removed from the hero subtree: both ambient circles, the `GlassSurface` context chip and
its `chip` string resolution (`[W1-6.1R.7]`, `[W1-6.1R.8]`), and the `Positioned.fill`
hero-content slot. Removed from the copy block: the `socialProof` element and the 18px
gap that followed it (`[W1-6.1R.10]`) — every other gap keeps its item-6 value. The
`LayoutBuilder` shortfall clamp that shrinks the hero on short viewports is retained
unchanged and now also governs the image, which is what keeps `[W1-6.1R.17]` true.

`WelcomeHero` (create) — **superseded, see `code-plan.md ## Approved feedback delta`** —
public class in its own file, `lib/features/onboarding/presentation/widgets/welcome_hero.dart`
— stateless — consumes `context.tokens` — no interactions. Takes explicit inputs from its
caller (`contentAsset`, optional `backgroundColor`, optional `backgroundAsset`) rather than
a `WelcomeStep` and an internal branch, so a future welcome screen is a new caller, not a
new branch here. Owns the whole hero paint: `ClipRRect(borderRadius: tokens.radius.heroShape)`
over a `Stack(fit: StackFit.expand)` layering the optional background (colour and/or asset)
under the contain-fitted content image, centred on both axes without cropping. Both images
set `excludeFromSemantics: true` and neither takes an `errorBuilder`, satisfying
`[W1-6.1R.16]` and `[W1-6.1R.6]`. It is a widget class, not a helper method, per
`flutter-arch.md`'s ban on `Widget`-returning functions. Public rather than private, since
both step widgets construct it from different libraries.

`CoverTile` (delete) — `.../widgets/cover_tile.dart` — sole consumers were
`_WelcomeStepOne` and `_WelcomeSocialProof`.
`WelcomeKeyArt` (delete) — `.../widgets/welcome_key_art.dart` — includes the private
`_WelcomeCountdownTile`, `_WelcomeCountdownColon` and `_CountdownLabel`, so the countdown
disappears with the file (`[W1-6.1R.8]`, `[W1-6.1R.9]`).
`WelcomeStatPill` (delete) — `.../widgets/welcome_stat_pill.dart` — includes the private
`_WelcomeStatPair` and `_WelcomeLabel`.

`SkipTextAction`, `PrimaryButton` and `ButtonPressScale` are untouched — their criteria
(`[W1-6.27]`–`[W1-6.30]`) carry forward.

### Assets and constants

`AssetConstants` (modify) — **superseded, see `code-plan.md ## Approved feedback delta`
and `orchestrator-state.md ## Deviation approvals`** — `lib/core/res/const.dart` gains only
a doc comment recording that it holds app-wide constants, no new members. The three
welcome-header filenames instead live in `WelcomeAssetConstants`, a new class in
`lib/features/onboarding/const.dart` (a feature-root constants file, per the pattern now
documented in `flutter-arch.md`) — feature-only constants don't belong in the shared class.
`dart-style.md`'s ban on bare top-level constants is still satisfied; they're just scoped to
the feature instead of the app.

The three PNGs already exist on disk and are untracked run inputs; nothing generates or
edits them. `pubspec.yaml` is read-only for this run (`[W1-6.1R.11]`).

## Reuse decisions

`WelcomeContainer` at `.../widgets/welcome_container.dart` — reused rather than rewritten.
It already owns the frame, the shortfall clamp, the progress dots, the copy block and the
`SafeArea` bottom padding that `[W1-6.11]`, `[W1-6.24]`–`[W1-6.26]` and `[W1-6.41]` depend
on. Only its hero subtree and two constructor parameters change.

`AppRadiusTokens.heroShape` / `AppColorTokens.surfaceIndigoPanel` at
`lib/config/theme/tokens/` — reused as-is; the container already resolves both, so
`[W1-6.1R.1]` and `[W1-6.1R.2]` need no token work and no token file is writable this run.

`PathConstants.imagePath` and `AssetConstants` at `lib/core/res/const.dart` — reused as the
home for asset keys, following `AssetConstants.error404` and `game_item.dart`'s
`'assets/images/${AssetConstants.error404}'` composition.

`WelcomeStep` at `.../blocs/welcome_state.dart` — reused as the container's only variance
input, which is what makes dropping the two widget-slot parameters safe.

Existing `test/widget/onboarding/welcome_screen_test.dart` harness — `_pumpWelcome`, the
`MockSharedPreferences` / `MockStackRouter` pair and the `@GenerateMocks` annotation are
reused verbatim, so `welcome_screen_test.mocks.dart` does not change.

`Image.asset` is used directly rather than `DefaultCachedNetworkImage`; the latter is the
convention for *remote* images only (`project-conventions.md § Network image pattern`),
and that same section directs art-led UI to developer-procured assets rather than large
widget stacks — which is precisely this ticket.

## Out of scope

- `lib/widgets/glass_surface_widget.dart` — **deliberately retained**, and therefore
  absent from the allowlist. After this run it has no caller, but it is a generic
  design-system primitive rather than a welcome-only helper:
  `system-foundation-specs.md` specifies the same glass surface for the Home hero status
  pill (§ Status system, § Status chip), the game-detail glass icon buttons
  (`game-detail-design-conventions.md`) and the context chip pattern generally. The
  tech-ac's own out-of-scope list puts "the design-system component library" outside this
  run, and its constraints accept unused leftovers (tokens) rather than pruning them, so
  `[W1-6.1R.8]`'s "helper used only by them" clause is read as scoped to the welcome-only
  widget files. Deleting it is one `git rm` if the Phase 3 reviewer disagrees.
- Token pruning — `ambientNeutral`, `ambientAccent`, `glass30/32/34`, `coverWash`,
  `keyArtWash`, `surfaceMagentaPanel`, `countdownColon`, `countdownFigure`, `statFigure`,
  `panelTitle`, `microLabel`, `effect.float`, `radius.mini` become unused or less used.
  `[W1-6.1R.12]` forbids touching them.
- The `playing` localisation key — stays, per the tech-ac's assumption, even though its
  only consumer (`CoverTile`'s status chip) is deleted here.
- `lib/generated/l10n.dart`, `lib/generated/intl/messages_en.dart`,
  `messages_zh.dart` — stale accessors for the ten removed keys are expected and must not
  be hand-edited (`[W1-6.1R.15]`, `[W1-6.34]`). No IDE regeneration is required for this
  branch to compile because no key is added.
- `pubspec.yaml`, routing, `OnboardingGuard`, `WelcomeCubit`, `WelcomeState`, persistence,
  the token layer, screen 1's background, locale-specific artwork, and the visual fidelity
  of the baked-in art (QA's manual check — no golden tests exist on this project).
- Other recorded pre-existing test failures outside `test/widget/onboarding/` stay exempt
  per the run's baseline.

## Open questions

NONE

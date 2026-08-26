---
name: flutter-widgets
description: "Conventions for building or modifying a Flutter widget or screen in
  the QuestLoggd app — placement, naming, style, and the UI patterns (loading,
  error, empty state, network image, snackbar, hero transition) every screen
  reuses. Triggers on: widget, screen, reusable widget, component library, UI
  pattern, shimmer, empty state, snackbar, hero transition, SafeArea."
---

# Flutter widgets — QuestLoggd conventions

Everything here is presentation-layer, non-reusable-across-features unless
explicitly said. For state management (BLoC/Cubit) see the `flutter-state`
skill instead — that's a separate concern from the widget itself.

---

## Where a widget lives

- **`lib/widgets/`** — global, app-wide widgets. Promote something here only
  when its API is generic and fully exercised by current needs — don't wait
  for a second caller if global ownership is already required, but don't
  promote speculatively either.
- **`lib/features/[feature]/presentation/widgets/`** — feature-owned,
  cohesive sections. Keep trivial one-off fragments beside their screen; give
  a cohesive section its own file when that clarifies the screen's
  composition, even with a single caller. A private component may live as a
  `part` file here.
- **Never split composition into a function or getter** returning `Widget`
  or `List<Widget>`. Extracted UI is always `StatelessWidget` or
  `StatefulWidget`.
- **Route directly to a reusable page** that owns its full route contract —
  don't add a passthrough screen whose `build` only returns another page.

## File and class naming

- Global widget file: `[descriptor]_widget.dart` or plain `[descriptor].dart`
  (e.g. `status_chip.dart`, `default_snackbar.dart`).
- Screen file: `[feature]_screen.dart`, class `[Feature]Screen`, annotated
  `@RoutePage()`. Extend `StatelessWidget` by default — `StatefulWidget` only
  for local ephemeral state that genuinely can't live in a Cubit/BLoC.
  File-private sub-widgets use a leading underscore: `_ClassName`.
- `const` wherever the linter allows — widget constructors with no mutable
  data must be `const`. `EdgeInsets`/`TextStyle`/`Color`/`Duration` literals
  are always `const`.

## Building a new reusable widget

Written for the component-library push, permanent, not tied to any one week.

- **One file per widget family.** A small helper widget only its parent uses
  lives as a private class in the same file. It only gets its own file once
  something else also needs it.
- **Match the hand-written `default_*` widgets' style.** Plain, common
  Flutter widgets (`Container`, `Row`, `Column`, `Text`, `InkWell`, and the
  like), no cleverness, easy to read top to bottom. Match that style — not
  the name prefix. New widgets do **not** get a `default` prefix; name them
  categorically for what they are: `PrimaryButton`, `SecondaryButton`,
  `StatusChip`. A third-party package is fine when the widget genuinely
  needs one (an animation or effect nothing in Flutter's own toolkit does
  cleanly) — prefer the built-in first, reach for a package only on a real
  gap.
- **Keep them simple.** Build for what the current screens actually need.
  No parameter, variant, or branch for a case nothing calls yet.
- **No comments.** Widget files carry none — not a header, not a `///` doc
  comment, not a note above a `Stack` or a token lookup. A widget is
  structure and naming; if a line needs explaining, the fix is a clearer
  name or a smaller widget, never a sentence above it. This is stricter
  than the project-wide "few comments" rule and it overrides it inside
  `lib/widgets/` and any feature `presentation/widgets/` file.
- **Stateful widgets — think before defaulting to `StatefulWidget`.** Small,
  purely visual state (an animation, a toggle, a drag position) is a normal
  `StatefulWidget`. If the state is doing anything closer to real logic,
  stop and consider whether it needs its own Cubit instead. No formal
  escalation needed each time — just think it through.
- **Configurable, not hardcoded.** Whatever changes between callers — text,
  colors, callbacks, sizes — comes in as a constructor parameter. A widget
  that only works for one screen's exact copy isn't reusable, it's just
  misplaced.
- **No spacing of its own.** A reusable widget renders flush inside the bounds
  its parent gives it — no outer padding, margin, or spacer around its content,
  and no `EdgeInsets`/`padding`/gap constructor parameter reintroducing the same
  concern through its API. Separation between components belongs to the layout
  that places them: a `Column`'s spacing, a gap widget, the screen's own
  gutters — per §1.3's "stacks use flex `gap`, never margins between siblings".
  Padding *inside* a surface the widget itself draws (a card, chip or button's
  interior) is that widget's own anatomy and is fine; the rule is about space
  *around* the widget. One that bakes in its outer spacing only fits one layout.
- **Outlines are always solid.** Borders, outlines and hairlines are continuous strokes.
  No dashed or dotted edge anywhere, and nothing custom-painted to draw one — a `Border` in
  a `BoxDecoration` covers every case in this system. That includes reserved placeholder
  boxes: an empty slot reads as pending because it is empty, not because its edge is
  broken. Full rule: `system-foundation-specs.md` §0.
- **Dimensions are even numbers.** Every dimension a widget writes itself — width,
  height, icon size, interior padding, a `Row`/`Column` gap, a font size declared in
  code — is an even number. The system already runs on 6 / 8 / 10 / 12 / 14 / 16 / 20;
  an odd value like 13 buys nothing and lands on a half-pixel at odd device ratios.
  When a spec hands you an odd number, round to whichever neighbour reads better
  against the values already around it and say why in one line. This binds new code:
  odd values in already-shipped widgets and in the theme tokens are a follow-up to
  raise, not something to rewrite inside an unrelated run.
- **Prefer `Expanded` over `Flexible`, unless the widget hugs its content.** In a row
  or column that fills its parent, a child meant to take the leftover space is
  `Expanded`; `Flexible` there only loosens the child's constraint and is usually not
  what was meant. The real exception is a widget that deliberately sizes to its own
  content — a chip, pill, badge or tag using `mainAxisSize: MainAxisSize.min` so it
  stays at its label's width inside a `Wrap` or a `Stack`. An `Expanded` in that row
  makes it swell to the full width it was offered, which is a visible shape change,
  not a refactor. So: reach for `Expanded` first, and when you meet the hug-content
  pattern, flag it and get the trade-off confirmed rather than swapping it blind.
  `StatusChip` is the live example.
- **Reuse before rebuilding.** If an existing widget is close — wrong size,
  wrong color, a couple of parameters short — adjust it rather than writing
  a new one next to it. If a full rebuild really is the right call, mark the
  old widget `@Deprecated` with one line saying what replaced it, rather
  than deleting it outright (same pattern used for `NetworkModule` and
  `TwitchAuthInterceptor` elsewhere in this project).
  **Deprecation is a staging post, not a permanent state.** Once a
  `@Deprecated` widget has no callers left, delete it — keeping a dead
  implementation beside its replacement is the thing that makes this folder
  hard to read. `game_item.dart` was deprecated at item 2.1 and deleted on
  2026-08-25 once `GameCard` had taken all of its callers. Retire a *live*
  legacy widget in the run that adopts its replacement, so the screen is
  touched once — never as a standalone cleanup sweep.

## Existing reusable widgets catalogue

All global widgets live in `lib/widgets/`. Check this list before creating a
new one — it's not a target, reuse an entry only when its existing semantics
actually match the requirement.

### Three tiers live in this one folder — know which you are touching

The table below mixes them, and the filename alone will not tell you apart. As of
2026-08-25:

**1. Design-system components** (week 2, built against `system-foundation-specs.md`
§3). Prefer these. `ZoneLabel`, `StatusChip`, `CoverTile`, `PlaceholderSlot`,
`FilterCountChip`, `ContextChip`, `StatTile`/`StatPill`, `ProgressDots`,
`ActionRow`, `GameCard`, `CompletionRing`, `CountdownCard`/`CountdownTile`,
`BottomTabBar`, `LabeledTextField`, `LabelValueRow`, `HairlineGroup`,
the `error_states/` module, `EmptyStateCard`, plus `LibraryTick` and `CriticBadge`.

**2. Legacy, still load-bearing.** Predate the design system and have live callers,
so they are not deletable without changing a shipped screen: `ErrorRetryWidget`
(3 callers, all genuine error states), `DefaultSnackbar` (pushes success *and*
failure, so §3.4's error-only toast cannot replace it), `HorizontalSeparator`
(hardcoded `Colors.grey`, sizes to screen width — superseded by `HairlineGroup`
but its main caller is a Game Detail screen), `SavedGameItem`, `TaskItem`,
`GroupTaskItem`, `AddContentDialog`, `MetacriticIndicator`, `LegendIndicator`,
`MultiTypeValuesSelection`, `TypeValuesSelection`, the `Default*` buttons and
filter app bars, and the shimmers. **Retire each one in the run that adopts its
replacement**, not in a sweep — that way the screen is touched once and the new
component's manual checks get done on a real layout.

**3. Not yet proven anywhere.** Built and merged, but with **no caller outside
`lib/widgets/`**, so they have never rendered in the app: `CompletionRing`,
`LabelValueRow`, `HairlineGroup`, `ErrorNotice`, `FailedItem`,
`DestructiveActionPair`, `ContextChip`, `StatPill`, `CountdownTile`, `ZoneLabel`,
`CoverTile`. `StatusChip` and `FilterCountChip` are composed by other widgets but
never placed by a feature. **Treat the first use of any of these as first use** —
expect to find something, and perform that component's entries in
`.agents/manual-check-backlog.md` on the screen that adopts it. Precedent: item
2.8's `EmptyStateCard` shipped wired to five call sites, and one of them turned out
never to have been reachable in the app's history.

| Widget | File | Purpose |
|---|---|---|
| `DefaultCachedNetworkImage` | `default_cached_network_image.dart` | Remote image with cache, loader, error fallback; optional builders override the loaded/loading/error rendering |
| `CoverTile` | `cover_tile.dart` | Game cover at one of four fixed sizes: cropped art in its original colours, indigo wash, optional bottom-left status chip, onyx+glyph fallback; adds no spacing of its own |
| `ErrorRetryWidget` | `error_retry_widget.dart` | Error + retry button for any error state |
| `DefaultSnackbar` | `default_snackbar.dart` | Themed snackbar |
| `DefaultAlertDialog` | `default_alert_dialog.dart` | Confirmation dialog with positive/negative actions |
| `DefaultSliverAppBar` | `default_sliver_app_bar.dart` | Standard sliver app bar with title, subtitle, action buttons |
| `DefaultFilterListAppBar` | `default_filter_list_app_bar.dart` | Generic sliver filter chip list (typed) |
| `FilterListAppBar` | `filter_list_app_bar.dart` | Alternative filter list app bar |
| `LabeledTextField` | `labeled_text_field.dart` | Text input with the label always above the box and the helper or character counter on that same label row: raised fill at r16 with no stroke at rest, 2px green focus ring drawn outside the box, error tint plus a 1px error hairline when invalid and the message below in error ink. Optional placeholder, prefix icon, multi-line and required validation; `readOnly` + `onClicked` makes it a tap target. Adds no spacing of its own |
| `DefaultFilledButtonFullWidth` | `default_filled_button_full_width.dart` | Full-width filled button |
| `DefaultOutlinedButton` | `default_outlined_button.dart` | Outlined button |
| `DefaultPopUpButton` | `default_pop_up_button.dart` | Pop-up menu button |
| `GameCard` | `game_card/game_card.dart` | Game card in three sizes (`xs` 64 no footer, `sm` 132, `md` fills its parent): 3:4 cover at r16 with an indigo wash and an onyx missing-art fallback, optional library tick / status chip / critic badge overlays, optional shared-element hero, constructible with no data for shimmers. Multi-file module — only `GameCard` and `GameCardSize` are public surface; the footer classes beside them are internal and are not imported from outside the folder. Adds no spacing of its own |
| `LibraryTick` | `library_tick.dart` | 20px indigo circle with a check, marking a cover as already in the library; no parameters, display-only; adds no spacing of its own |
| `CriticBadge` | `critic_badge.dart` | Green pill showing a critic score rounded to a whole number. `score` is the only parameter — no colour, threshold, variant or score ramp. Its green is one of §2 rule 1's two sanctioned exceptions (with the focus ring) because it is data, not an affordance: do not copy the green out of this widget and do not reuse it for a badge that is not a critic score |
| `GameItemLoadingShimmer` | `game_item_loading_shimmer.dart` | Horizontal shimmer of dataless `GameCard`s at `sm` |
| `GameItemGridLoadingShimmer` | `game_item_grid_loading_shimmer.dart` | Grid shimmer of dataless `GameCard`s at `md`, matching the games grid's cell geometry |
| `GameDetailTopContentShimmer` | `game_detail_top_content_shimmer.dart` | Shimmer for game detail top section |
| `GameDetailMidContentShimmer` | `game_detail_mid_content_shimmer.dart` | Shimmer for game detail mid section |
| `GameScreenshot` | `game_screenshot.dart` | Single screenshot viewer |
| `GameDetailSectionPoint` | `game_detail_section_point.dart` | Bullet-point row for detail sections |
| `PlatformRowList` | `platform_row_list.dart` | Horizontal row of platform icons |
| `SavedGameItem` | `saved_game_item.dart` | Saved game list row with swipe actions |
| `SavedGameStatusTag` | `saved_game_status_tag.dart` | Status tag chip for saved games |
| `GroupTaskItem` | `group_task_item.dart` | Task group row in tracker |
| `TaskItem` | `task_item.dart` | Individual task row |
| `MetacriticIndicator` | `metacritic_indicator.dart` | Critic score badge |
| `LegendIndicator` | `legend_indicator.dart` | Colour legend dot + label |
| `HorizontalSeparator` | `horizontal_separator.dart` | Thin horizontal divider |
| `MultiTypeValuesSelection` | `multi_type_values_selection.dart` | Multi-select chip group |
| `TypeValuesSelection` | `type_values_selection.dart` | Single-select chip group |
| `AddContentDialog` | `add_content_dialog.dart` | Dialog for adding tracker content |
| `ZoneLabel` | `zone_label.dart` | Caps section heading with optional trailing link; adds no spacing of its own |
| `StatusChip` | `status_chip.dart` | Six-status pill: dot + label + optional count, list or on-media variant; adds no spacing of its own |
| `PlaceholderSlot` | `placeholder_slot.dart` | Reserved empty box signalling art is still owed: ink-12 fill, solid 1px ink-24 border, two presets (app mark 88 r20 with a `LOGO` marker, provider mark 20 r-xs, no label); adds no spacing of its own |
| `FilterCountChip` | `filter_count_chip.dart` | Filter chip: pill capsule, indigo fill + white label when active, 8% ink + full-ink label when inactive, optional count after the label; adds no spacing of its own |
| `ContextChip` | `context_chip.dart` | Glass pill naming where the user is inside a hero: required 12px leading icon + 11px caps label, display-only; adds no spacing of its own |
| `StatTile` / `StatPill` | `stat_pill.dart` | Stat pill in two forms sharing one figure-over-label pair: `StatTile` on 8% ink at r16 (laid out in threes by its caller), `StatPill` as a glass capsule of 2-3 pairs; adds no spacing of its own |
| `ProgressDots` | `progress_dots.dart` | Step dots for a paged flow: caller supplies the dot count and which index is active; 22x5 ink pill for the active dot, 5x5 ink-12 for the rest, 6px apart, display-only and unanimated; hugs its content and adds no spacing of its own |
| `ActionRow` | `action_row.dart` | Full-width 52px r-sm row on a caller-supplied flat fill: required 20px leading mark and label centred together as a pair, optional trailing 16px busy indicator, press-scale and focus ring, disabled without dimming; adds no spacing of its own |
| `BottomTabBar` | `bottom_tab_bar/bottom_tab_bar.dart` | Static bottom tab chrome: onyx `surfaceTabChrome` fill, five fixed destinations at equal width, each an outline 20px glyph over an always-visible 10/500 label, plus an 18x3 fully-rounded cap above the glyph — indigo glyph, label and cap on the selected destination, ink-55 and a transparent cap on the other four. Reserves the live bottom safe-area inset with a 22 fallback and consumes it. Caller-driven: takes a selected index, reports the tapped index, holds no selection of its own and reads no scroll state. Multi-file module — `BottomTabBar` is the only public surface; the cell, focus ring, cap, content and the destination enum beside it are internal and are not imported from outside the folder. Adds no spacing of its own |
| `CompletionRing` | `completion_ring/completion_ring.dart` | Circular completion ring at three fixed sizes (60 inline, 80 specimen, 88 detail): ink-12 track with a proportional arc over it and the truncated percentage centred inside, plus an optional caption at the two larger sizes. Indigo below 100, a closed magenta ring at exactly 100; value clamps to 0–100 and never throws. Display-only, unanimated, not a hit target; adds no spacing of its own |
| `LabelValueRow` | `label_value_row.dart` | Dense-list row: required label at full ink taking the leftover width, required value at ink-70 beside it, optional trailing chevron. Draws no fill, radius or edge of its own — surface and hairlines belong to `HairlineGroup`. Display-only, not a tap target; adds no spacing of its own |
| `HairlineGroup` | `hairline_group.dart` | Raised card wrapping any list of children: `surfaceRaised` fill at r16, clipped, with a 1px hairline between each adjacent pair — exactly N−1 for N children, never on an outer edge. `children` is the only parameter, so hairline placement cannot be added, removed or moved by a caller. Renders nothing when given no children; adds no spacing of its own |
| `EmptyStateCard` | `empty_state_card.dart` | Empty-state card on `surfaceRaised` at r16: optional 44px glyph, a caps headline rendered from a normal-case string, one supporting line at `ink70` that wraps rather than truncating, and one required action built from `PrimaryButton`. No border, no fixed height, no actionless variant; adds no spacing of its own |

## UI patterns every screen reuses

**Loading shimmer** — use the `skeletonizer` package via feature-specific
shimmer widgets, living alongside their real counterparts in `lib/widgets/`
(see catalogue above). Never `CircularProgressIndicator` for full-screen
loading — that's only for inline next-page loading, centred.

**Error + retry** — use `ErrorRetryWidget` (`lib/widgets/error_retry_widget.dart`)
for any error state that supports retry:
```dart
ErrorRetryWidget(
  onRetryClicked: () => context.read<GamesBloc>().add(const GamesFetched()),
  padding: const EdgeInsets.all(16), // optional
)
```
`onRetryClicked` always re-dispatches the original fetch event. Wrap in
`SliverFillRemaining` + `Center` inside a `CustomScrollView`.

**Network image** — always `DefaultCachedNetworkImage`
(`lib/widgets/default_cached_network_image.dart`), never `Image.network`
directly. Pass `null` safely — it renders an error icon. For local/asset
fallback when a cover is null, use `Image.asset` with `AssetConstants.error404`.
For art-led/showcase UI, use developer-procured assets under `assets/` — don't
recreate supplied artwork with widget stacks, shapes, or `CustomPainter`.

**Hero transition** — for game covers navigating to game detail. Tag format
`'${ConfigConstants.heroTag}/${game.id}/$fromScreen'`, where `fromScreen`
disambiguates the same game appearing in multiple lists — use
`RouteConstants.[screen]` values (`games`, `tracker`, `featured`).
```dart
Hero(
  tag: '${ConfigConstants.heroTag}/${game?.id}/$fromScreen',
  child: DefaultCachedNetworkImage(imageUrl: game!.cover.url!),
)
```

**Snackbar** — `DefaultSnackbar` (`lib/widgets/default_snackbar.dart`) for
every in-app snack message:
```dart
ScaffoldMessenger.of(context).showSnackBar(
  DefaultSnackbar(text: S.current.some_message),
);
```

**Empty state** — use `EmptyStateCard` (`lib/widgets/empty_state_card.dart`) for
every empty branch. Its anatomy is fixed: a raised-surface card at r-lg carrying
an optional glyph, a headline the component renders in caps from a normal-case
`.arb` value, exactly one supporting line, and exactly one action. All four text
and callback slots are required — there is no actionless variant, and the card
adds no spacing of its own, so the caller owns the surrounding layout.

## System bars and SafeArea

Every screen's body is wrapped in `SafeArea` — `Scaffold(body: SafeArea(child: ...))`.
No screen lays content under the status bar, nav bar, or a display cutout. The
system UI overlay style is a single global default set once in `bootstrap.dart`
(transparent bars, colour from `AppColorTokens.canvas`, light icons) — never
overridden per screen. A screen wanting different treatment (e.g. a hero
bleeding under a transparent status bar) is a deviation needing a recorded
decision, not a free choice.

## Import ordering and const

Dart SDK imports, then package imports (flutter → third-party → project),
then relative imports (only for `part`/`part of` and `generated/l10n.dart`),
each group blank-line-separated and alphabetised. Prefer package imports
over relative ones outside that exception.

## Localisation

All user-facing strings use `S.current.[key]` — never hardcode. Add new keys
to both `lib/l10n/intl_en.arb` and `lib/l10n/intl_zh.arb`; the `S` class
normally regenerates via the Flutter Intl IDE plugin, not `build_runner`, not
`flutter gen-l10n`. An agent can instead run the CLI generator the plugin
wraps (`dart pub global run intl_utils:generate`, see
`.claude/pipeline/rules/generation.md`) so the tree compiles immediately
rather than waiting on a human IDE pass — sanctioned path, record which one
was taken as a deviation either way.

## Theme access

Use `context.themeData` (from `ContextExtensions`) — never call
`Theme.of(context)` directly.

## What NOT to do

- Do not use `Navigator.push/pop` — always `context.router`
- Do not write a Widget-returning function or getter — extracted UI is a
  widget class
- Do not hardcode a user-facing string
- Do not call `Theme.of(context)` directly
- Do not write golden tests or `matchesGoldenFile` for any of this
- Do not add a `default` prefix to a newly built widget
- Do not introduce an odd-numbered dimension

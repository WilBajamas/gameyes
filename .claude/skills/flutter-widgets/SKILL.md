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
  (e.g. `game_item.dart`, `default_snackbar.dart`).
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

## Existing reusable widgets catalogue

All global widgets live in `lib/widgets/`. Check this list before creating a
new one — it's not a target, reuse an entry only when its existing semantics
actually match the requirement.

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
| `DefaultBorderTextField` | `default_border_text_field.dart` | Outlined text input field |
| `DefaultFilledButtonFullWidth` | `default_filled_button_full_width.dart` | Full-width filled button |
| `DefaultOutlinedButton` | `default_outlined_button.dart` | Outlined button |
| `DefaultPopUpButton` | `default_pop_up_button.dart` | Pop-up menu button |
| `GameItem` | `game_item.dart` | Game card (cover image, name, platforms/date) |
| `GameItemLoadingShimmer` | `game_item_loading_shimmer.dart` | Shimmer placeholder for GameItem |
| `GameItemGridLoadingShimmer` | `game_item_grid_loading_shimmer.dart` | Shimmer for full grid load |
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
| `NavigationDestination` | `navigation_destination.dart` | Bottom nav destination item |
| `ScrolledNavigationBar` | `scrolled_navigation_bar.dart` | Navigation bar that hides on scroll |
| `AddContentDialog` | `add_content_dialog.dart` | Dialog for adding tracker content |
| `ZoneLabel` | `zone_label.dart` | Caps section heading with optional trailing link; adds no spacing of its own |
| `StatusChip` | `status_chip.dart` | Six-status pill: dot + label + optional count, list or on-media variant; adds no spacing of its own |
| `PlaceholderSlot` | `placeholder_slot.dart` | Reserved empty box signalling art is still owed: ink-12 fill, solid 1px ink-24 border, two presets (app mark 88 r20 with a `LOGO` marker, provider mark 20 r-xs, no label); adds no spacing of its own |
| `FilterCountChip` | `filter_count_chip.dart` | Filter chip: pill capsule, indigo fill + white label when active, 8% ink + full-ink label when inactive, optional count after the label; adds no spacing of its own |
| `ContextChip` | `context_chip.dart` | Glass pill naming where the user is inside a hero: required 12px leading icon + 11px caps label, display-only; adds no spacing of its own |
| `StatTile` / `StatPill` | `stat_pill.dart` | Stat pill in two forms sharing one figure-over-label pair: `StatTile` on 8% ink at r16 (laid out in threes by its caller), `StatPill` as a glass capsule of 2-3 pairs; adds no spacing of its own |
| `ProgressDots` | `progress_dots.dart` | Step dots for a paged flow: caller supplies the dot count and which index is active; 22x5 ink pill for the active dot, 5x5 ink-12 for the rest, 6px apart, display-only and unanimated; hugs its content and adds no spacing of its own |
| `ActionRow` | `action_row.dart` | Full-width 52px r-sm row on a caller-supplied flat fill: required 20px leading mark and label centred together as a pair, optional trailing 16px busy indicator, press-scale and focus ring, disabled without dimming; adds no spacing of its own |

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
  text: S.current.no_results_found, // optional — omit for generic error text
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

**Empty state** — no dedicated `EmptyStateWidget` today. Use
`ErrorRetryWidget` with custom `text` when retry is meaningful; otherwise a
plain centred `Text`, localised, `textAlign: TextAlign.center`.

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

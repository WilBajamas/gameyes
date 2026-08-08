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
- **Few comments.** The widget's structure and naming should make its
  purpose obvious without narration — same project-wide rule as everywhere
  else.
- **Stateful widgets — think before defaulting to `StatefulWidget`.** Small,
  purely visual state (an animation, a toggle, a drag position) is a normal
  `StatefulWidget`. If the state is doing anything closer to real logic,
  stop and consider whether it needs its own Cubit instead. No formal
  escalation needed each time — just think it through.
- **Configurable, not hardcoded.** Whatever changes between callers — text,
  colors, callbacks, sizes — comes in as a constructor parameter. A widget
  that only works for one screen's exact copy isn't reusable, it's just
  misplaced.
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
| `DefaultCachedNetworkImage` | `default_cached_network_image.dart` | Remote image with cache, loader, error fallback |
| `ErrorRetryWidget` | `error_retry_widget.dart` | Error + retry button for any error state |
| `DefaultSnackbar` | `default_snackbar.dart` | Themed snackbar |
| `DefaultAlertDialog` | `default_alert_dialog.dart` | Confirmation dialog with positive/negative actions |
| `DefaultSliverAppBar` | `default_sliver_app_bar.dart` | Standard sliver app bar with title, subtitle, action buttons |
| `DefaultFilterListAppBar` | `default_filter_list_app_bar.dart` | Generic sliver filter chip list (typed) |
| `FilterListAppBar` | `filter_list_app_bar.dart` | Alternative filter list app bar |
| `DefaultBorderTextField` | `default_border_text_field.dart` | Outlined text input field |
| `DefaultFilledButtonFullWidth` | `default_filled_button_full_width.dart` | Full-width filled button |
| `DefaultOutlinedButton` | `default_outlined_button.dart` | Outlined button |
| `DefaultChoiceChip` | `default_choice_chip.dart` | Single choice chip |
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
regenerates via the Flutter Intl IDE plugin, not `build_runner`, not
`flutter gen-l10n`. Code using a brand-new key won't compile until that
regen happens — that's expected, not a failure to self-correct.

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

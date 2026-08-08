# project-conventions.md — Gameyes Project Conventions Reference
Project: gaming_library_assessment_flutter
Last updated: 2026-08-04

---

## BLoC / Cubit provisioning in screens

Provide BLoC/Cubit at the screen level using `BlocProvider` + `getIt`.
Never provide above the screen — scope to the smallest possible subtree.

```dart
BlocProvider(
  create: (context) => getIt<GamesBloc>(),
  child: Scaffold(...),
)
```

- `BlocBuilder<B, S>` — rebuilds on state changes
- `context.read<T>()` — inside callbacks; does not subscribe
- `context.watch<T>()` — inside `build` for full rebuild on every state
- Never pass BLoC/Cubit down the widget tree as constructor parameters

Reactive-boundary placement (lowest subtree, no passthrough views) lives in
`flutter-arch.md § Reactive boundary convention` — not restated here.

Don't add `listenWhen` to a `BlocListener` just as a reflex. If the listener
body already guards the condition itself (e.g. `if (state.someField == X)`
before the side effect), a matching `listenWhen` is redundant — skip it. Only
add `listenWhen` when it changes behavior: it skips real work (e.g. an
imperative call that isn't otherwise idempotent), or it's the sole guard
against the unwanted call.

---

## Status-driven UI rendering pattern

Use `if`-guarded slivers/widgets driven by the state's status enum.
Never use `switch` in the `build` method for top-level layout selection —
use `if` conditions on `state.status` so multiple states can coexist
(e.g. content + next-page loader visible at the same time).

```dart
CustomScrollView(
  slivers: [
    if (state.status == GamesStatus.loading)
      const SliverFillRemaining(child: GameItemGridLoadingShimmer()),

    if (state.status == GamesStatus.success)
      const GamesSliverGrid(),

    if (state.nextPageStatus == GamesNextPageStatus.loading)
      const SliverToBoxAdapter(child: CircularProgressIndicator()),

    if (state.nextPageStatus == GamesNextPageStatus.failed)
      SliverToBoxAdapter(child: ErrorRetryWidget(...)),

    if (state.status == GamesStatus.failed)
      SliverFillRemaining(child: Center(child: ErrorRetryWidget(...))),
  ],
)
```

`SliverFillRemaining` for full-screen states; `SliverToBoxAdapter` for inline states.

---

## Pagination pattern

Trigger next page when scroll reaches **90% of maxScrollExtent** via `NotificationListener<ScrollUpdateNotification>`.

State tracks two separate statuses:
- `status` — initial load (`loading`, `success`, `failed`, `empty`)
- `nextPageStatus` — subsequent pages (`initial`, `loading`, `failed`)

On next-page success, append to existing list: `games: List.of(state.games)..addAll(response.items)`.
Page tracked as `currentPage` (starts at 1). BLoC checks `state.response?.nextUrl` before triggering.
Use `droppable()` transformer on both fetch and next-page events.

---

## Pull-to-refresh pattern

Use `CupertinoSliverRefreshControl` (shows only when status is `success`):

```dart
if (state.status == GamesStatus.success)
  CupertinoSliverRefreshControl(
    onRefresh: () async => context.read<GamesBloc>().add(const GamesFetched()),
  ),
```

---

## Loading shimmer pattern

Use `skeletonizer` package via feature-specific shimmer widgets.
Shimmer widgets live alongside their real counterparts in `lib/widgets/`.

Existing shimmer widgets:
- `GameItemGridLoadingShimmer` — `lib/widgets/game_item_grid_loading_shimmer.dart`
- `GameItemLoadingShimmer` — `lib/widgets/game_item_loading_shimmer.dart`
- `GameDetailTopContentShimmer` — `lib/widgets/game_detail_top_content_shimmer.dart`
- `GameDetailMidContentShimmer` — `lib/widgets/game_detail_mid_content_shimmer.dart`

Do not use `CircularProgressIndicator` for full-screen loading — use shimmer.
`CircularProgressIndicator` is only used for next-page loading (inline, centred).

---

## Error + retry pattern

Use `ErrorRetryWidget` for all error states that support retry.
Located at: `lib/widgets/error_retry_widget.dart`

```dart
ErrorRetryWidget(
  onRetryClicked: () => context.read<GamesBloc>().add(const GamesFetched()),
  text: S.current.no_results_found, // optional — defaults to generic error text
  padding: const EdgeInsets.all(16), // optional
)
```

- `onRetryClicked` is required — always re-dispatch the original fetch event
- `text` is optional — omit for generic error; provide for specific states (e.g. empty results)
- Use `SliverFillRemaining` + `Center` wrapper when rendering in a `CustomScrollView`

---

## Network image pattern

Always use `DefaultCachedNetworkImage` for remote images.
Located at: `lib/widgets/default_cached_network_image.dart`
Handles: caching, loading indicator (centred `CircularProgressIndicator`), error fallback (error icon).

```dart
DefaultCachedNetworkImage(imageUrl: game.cover.url)
```

- Pass `null` safely — the widget handles it (renders error icon)
- Never use `Image.network` directly in feature code
- For local/asset fallback when cover is null, use `Image.asset` with `AssetConstants.error404`

For art-led or showcase UI, prefer developer-procured image assets under `assets/`
and render them with the appropriate asset widget. Do not recreate supplied artwork
with large widget stacks, geometric shapes, or `CustomPainter`; that approach is
costly to build and maintain and bloats presentation code.

---

## Hero transition pattern

Used for game cover images navigating to game detail.
Tag format: `'${ConfigConstants.heroTag}/${game.id}/$fromScreen'`

The `fromScreen` string disambiguates the same game appearing in multiple lists.
Use `RouteConstants.[screen]` values for `fromScreen`:
- `RouteConstants.games` — from games list
- `RouteConstants.tracker` — from tracker
- `RouteConstants.featured` — from featured

```dart
Hero(
  tag: '${ConfigConstants.heroTag}/${game?.id}/$fromScreen',
  child: DefaultCachedNetworkImage(imageUrl: game!.cover.url!),
)
```

---

## IGDB query building

Query construction (`IGDBQueryBuilder`, the search/sort constraint, the standard
field set) is documented once in `api-contracts.md § Query building` — read
that, not a restatement here.

---

## Isar local storage patterns

All Isar access goes through `GameLocalStorageService`
(extends `IsarLocalStorageService` at `lib/core/services/storage/`).

**Pattern: get the db instance first, then operate**
```dart
final isar = await db; // inherited from IsarLocalStorageService
await isar.writeTxn(() async => isar.savedGames.put(game));
```

**Reads — use queries directly (no transaction needed):**
```dart
final isar = await db;
return await isar.savedGames.filter().gameIdEqualTo(gameId).findFirst();
```

**Real-time streams — use `.watch(fireImmediately: true)`:**
```dart
yield* isar.savedGames.watchObject(savedGameId, fireImmediately: true);
```
Stream-based reads do not need a write transaction.
Use `async*` + `yield*` for stream methods in storage services.

**Linked objects (IsarLinks) — call `.save()` after adding:**
```dart
game.groupTasks.add(groupTaskToSave);
game.groupTasks.save(); // must be called inside writeTxn
```

New Isar collections must be:
1. Annotated with `@collection`
2. Registered in `IsarLocalStorageService.openDb()` schema list
3. Code-generated: run `dart run build_runner build --delete-conflicting-outputs`

---

## SharedPreferences

Pattern (no wrapper class, `StorageModule` injection, `StorageConstants` keys)
is documented once in `flutter-arch.md`, under local storage — read that, not
a restatement here.

---

## Snackbar pattern

Use `DefaultSnackbar` for all in-app snack messages.
Located at: `lib/widgets/default_snackbar.dart`

```dart
ScaffoldMessenger.of(context).showSnackBar(
  DefaultSnackbar(text: S.current.some_message),
);
```

---

## Empty state pattern

There is no dedicated `EmptyStateWidget`. Use `ErrorRetryWidget` with a custom
`text` for empty states where retry is meaningful. For empty states with no
retry action, use a plain `Text` with `textAlign: TextAlign.center` wrapped in
a `Center` widget, with localised copy from `S.current`.

---

## Existing reusable widgets catalogue

All global widgets live in `lib/widgets/`. Check this list before creating a new widget.

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

### Widget ownership, extraction, and route composition

The catalogue above is not a target — reuse an entry only when its existing
semantics match the requirement.

Rules for fragment placement (`presentation/widgets/` vs. `lib/widgets/`), the
ban on Widget-returning helpers, and routing directly to a reusable page instead
of a passthrough screen all live in `flutter-arch.md` — not restated here.

### Building a new reusable widget (2026-08-07)

Rules for anything going in `lib/widgets/`, written for the component-library
push but permanent, not tied to any one week.

- **Location.** `lib/widgets/`. Nothing else — this is already `flutter-arch.md`'s
  rule, restated here because it matters most for this kind of work.

- **One file per widget family.** A small helper widget that only its parent
  uses lives as a private class in the same file. It only gets promoted to its
  own file once something else also needs it. Don't split a widget into
  multiple files just because it has parts.

- **Match the hand-written `default_*` widgets' style.** They're the house
  style: plain, common Flutter widgets (`Container`, `Row`, `Column`, `Text`,
  `InkWell`, and the like), no cleverness, easy to read top to bottom. Match
  that — not their name prefix. New widgets do **not** get a `default` prefix;
  name them for what they are, categorically: `PrimaryButton`,
  `SecondaryButton`, `StatusChip`, not `DefaultButton` or `ButtonWidget`. A
  third-party package is fine when the widget genuinely needs one (an
  animation, an effect nothing in Flutter's own toolkit does cleanly) — prefer
  the common built-in first, reach for a package only when there's a real gap.

- **Keep them simple.** Build for what the current screens actually need.
  Don't add a parameter, a variant, or a branch for a case nothing calls yet.

- **Few comments.** Same project-wide rule as everywhere else (see "Comments —
  plain English only" above) — the widget's structure and naming should make
  its purpose obvious without narration.

- **Stateful widgets — think before defaulting to `StatefulWidget`.** Small,
  purely visual state (an animation, a toggle, a drag position) is a normal
  `StatefulWidget`. If the state is doing anything more than that — something
  closer to real logic — stop and consider whether it actually needs its own
  Cubit instead. Doesn't need a formal pipeline escalation each time; just
  think it through rather than reaching for `StatefulWidget` by habit.

- **Configurable, not hardcoded.** Whatever changes between callers — text,
  colors, callbacks, sizes — comes in as a constructor parameter. A widget
  that only works for one screen's exact copy and behaviour isn't reusable,
  it's just misplaced.

- **Reuse before rebuilding.** If an existing widget is close — wrong size,
  wrong color, a couple of parameters short — adjust it rather than writing a
  new one next to it. If a full rebuild really is the right call, mark the old
  widget `@Deprecated` with one line saying what replaced it, rather than
  deleting it outright. Same pattern already used for `NetworkModule` and
  `TwitchAuthInterceptor` elsewhere in this project.

---

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

---

## Comments — plain English only

Comments explain the *why*, in plain words a non-technical person could follow.
No jargon, no restating what the code already says, no framework/pattern names
unless truly unavoidable.

Bad:  "Performs one PostgREST round-trip through the injected SupabaseClient."
Good: "Send one small request to Supabase just to check if it answers."

Only comment where the reason isn't obvious from reading the code. If a comment
just repeats the method or variable name in sentence form, delete it instead.

Refrain from obvious comments. An enum with self-explanatory values, or a class
whose method names already say what it does, needs no comment at all —
developers can read the implementation just fine. Comment the *why* behind a
non-obvious decision, not a running narration of *what* the code does.

Widget-tree comments are useful when they preserve a layout invariant that the
types do not reveal — for example, why the hero shrinks before the bottom-anchored
copy, or why one element alone owns a shadow. Keep that rationale once, next to the
owning composition. Do not repeat it above the class, constructor, and build method.

This includes dartdoc on constructor fields. A `///` line on every parameter that
just restates its name is still a repeated-name comment, one per field instead of
one for the whole class — delete those too.

Bad:
```dart
/// Art shown whole and centred, scaled down to fit rather than cropped.
final String contentAsset;

/// Flat fill behind the content.
final Color? backgroundColor;
```
Good — the names already say this; a one-line class comment covers anything that
isn't obvious, if anything is:
```dart
/// Rounded panel at the top of a welcome screen.
class WelcomeHero extends StatelessWidget {
  final String contentAsset;
  final Color? backgroundColor;
```

## Naming — simple English only

Class, variable, constant and string names must read as plain English words a
non-technical person would use — no jargon, no invented compound terms, no
placeholder-looking values.

Bad:  `__gameyes_connectivity_probe__`, `ISupabaseHealthProbe`
Good: `connectionPath`, `SupabasePing`

---

## Platform target — Android only (as of 2026-07-30)

**v1 ships Android only. iOS is deferred.** The developer works on Windows and has
no Mac and no iPhone, so iOS builds cannot be produced, run, or verified — Flutter's
iOS toolchain requires Xcode, which is macOS-only.

**Consequences for agents:**

- **Never write an acceptance criterion that requires iOS verification.** "Behaves
  identically on iOS and Android" and similar cannot be checked by anyone on this
  project and will sit unverified on a manual checklist forever. Write the criterion
  against Android alone.
- Do not propose iOS-only packages, capabilities, or platform channels.
- iOS project files may still be configured where it is free to do so (bundle IDs,
  flavour scaffolding) so the work is not repeated later — but **never claim it is
  verified**, and never gate a criterion on it.
- Sign in with Apple is **not** required. App Store Review Guideline 4.8 is an
  App Store rule with no Play Store equivalent. It returns when iOS does.

This is a resourcing constraint, not a product decision. It reverses the moment a
Mac is available — see `roadmap-deferred.md`.

---

## Key constraints for all agents

- Always check the widget catalogue above before creating a new widget
- Extract presentation components according to ownership and cohesion, not caller
  count alone
- Keep reactive state boundaries as low as possible in the widget tree
- Avoid passthrough screen, view, and route classes
- Use `lib/widgets/` for explicitly app-wide primitives with required generic inputs
- Never use Widget-returning helper functions or getters; extracted UI composition
  is a `StatelessWidget` or `StatefulWidget`
- Do not add generic wrappers, nullable future hooks, or one-use constants without
  a current requirement
- Always use `IGDBQueryBuilder` for IGDB API queries — never build query strings manually
- Always use `GameLocalStorageService` for Isar operations — never access `Isar` directly
- Inject `SharedPreferences` directly — there is no wrapper, and `StorageModule`
  is the only place `getInstance()` is called
- Always use `DefaultCachedNetworkImage` for remote images — never `Image.network`
- Pagination state uses two enums — never collapse them into one status
- Pull-to-refresh only shown when `status == success`


## Provisional UI — the Settings sign-out control (2026-08-05)

`lib/features/settings/presentation/widgets/sign_out_section.dart` is **test
scaffolding that stayed**. It exists because four of week 1 item 8's manual
checks could not be run without a sign-out trigger, and the app needs a sign-out
before beta regardless — so it was built properly rather than hacked in.

**Its visual design is not official.** It borrows the sign-in provider row's
anatomy for want of any Settings design spec. Do not treat it as the pattern for
future Settings rows, and do not cite it as precedent. Placement, wording, a
possible confirmation step, and grouping under an account section are all open —
see `roadmap-deferred.md`.

The behaviour, by contrast, is settled and should be preserved: the tap performs
no navigation. The auth guard and `AuthStatusListener` from item 8 move the user;
adding navigation here would race that mechanism.

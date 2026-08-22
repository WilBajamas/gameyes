# Technical Design Document
Source: `.agents/week-2-task-briefs.md` Stage 2 item 2.4 — Tab bar; `system-foundation-specs.md` §3.2 "Tab bar" row (with §1.7, §1.8, §1.9, §2, §5, §6); `home-screen-design-conventions.md` §6
Date: 2026-08-22

## Feature summary

Presentation-only rework. The stock Material `NavigationBar` chrome and its
scroll-collapsing wrapper are replaced by one hand-composed component,
`BottomTabBar`, which owns the app's five fixed destinations, paints them with
the existing dark-theme tokens, and reports a zero-based index to its single
caller. Nothing below the UI layer moves: no model, repository, use case,
notifier or route changes. The Home shell keeps its `AutoTabsRouter` and its
tab bodies and only stops constructing Material destinations, handing the bar
its selected index and selection callback instead. The scroll-hide behaviour is
dropped per the resolved CRITICAL-1 — the bar becomes static chrome — and the
now-orphaned `ScrollNotifier` and its writers are deliberately left untouched
(FOLLOW-UP-1).

## Layer map

2.4-C1 … 2.4-C5, 2.4-C7 … 2.4-C22: UI
2.4-C6: UI (Home shell wiring only)

No criterion touches API, repository, use case, state or storage. No API
contract is required.

## Data layer

None. No API call, model, DTO or repository is created or modified.

## Domain layer

None.

## State layer

None. Selection is not state this component owns — 2.4-C3 requires the caller's
index to be the only source of truth, so the bar is stateless with respect to
selection and no Cubit/BLoC is introduced. The router (`AutoTabsRouter`)
remains the holder of active-tab state, exactly as today.

## UI layer

### Widgets

**`BottomTabBar`** (create) — `lib/widgets/bottom_tab_bar.dart` — stateless.
Consumes `selectedIndex` (`int`) and `onDestinationSelected`
(`ValueChanged<int>`). Renders a `Material` filled with
`tokens.color.surfaceTabChrome` at zero elevation with a transparent surface
tint (C14 — flat fill, no border, no shadow, no elevation overlay), a bottom
`SafeArea` (C19), the literal `8` top / `6` horizontal padding (C19), and a
`Row` of five `Expanded` destination cells (C20 — equal fifths).
Interactions: none of its own; each cell calls `onDestinationSelected` with its
own index. It accepts no scroll, visibility, duration or collapse parameter and
performs no service-locator lookup (C5).

**`_TabDestinationCell`** (create, private, same file) — stateful only for
ephemeral press and focus flags (C13, C12). Consumes its destination, its
index, whether it is selected, and the selection callback. Composition, outside
in:

- `MergeSemantics` → `Semantics(selected:, label: MaterialLocalizations.of(context).tabLabel(...))`
  — one accessibility node per destination carrying the selected state (C8) and
  the platform's localized "Tab N of 5" phrasing (C9). The visible `Text` supplies
  the destination name; the `Icon` is constructed with no `semanticLabel`, and the
  merge makes the whole cell a single focusable node, so the name is spoken once
  (C10).
- `Tooltip(message: label, excludeFromSemantics: true)` — the long-press tooltip
  (C11). `excludeFromSemantics` is load-bearing for C10: left at its default the
  tooltip message enters the same merged node and the destination name is spoken
  twice.
- `InkWell` with `splashFactory: NoSplash.splashFactory` and a transparent
  `overlayColor` — kept for the tap gesture, the full-cell hit area, focus
  traversal and keyboard activation (C2, C12); every painted ink effect
  suppressed (C13). `onHighlightChanged` and `onFocusChange` feed the two flags.
- `ConstrainedBox(minHeight: 44)` inside the ink well, so the hit target is the
  whole fifth including its padding, not the glyph and label bounds (C20, C2).
- `AnimatedScale` at `0.97` while pressed (C13), and a `Container` whose solid
  2px border is `tokens.color.green` when focused and transparent otherwise, with
  a permanent 2px inner padding (C12 / §1.8's 2px green outline at 2px offset).
  The border and padding are always present so focus does not reflow the cell,
  and because the ring is drawn inside the cell's own bounds it cannot be clipped
  by the bar's edges.
- A `Column` of: the cap, then the glyph and label.

**Destinations** (create, private enum, same file) — the five in fixed
declaration order Featured · Games · Tracker · Browse · Settings, each carrying
its outline `IconData` and a `label` getter returning the existing
`S.current.*` string (C1, ASSUMPTION-8). The enum's `index` is the zero-based
index reported to the caller (C2) and its length is the tab count announced by
`tabLabel` (C9). Glyphs are the outline twin of each current filled icon, same
concept (C18, ASSUMPTION-5): `featured_play_list_outlined`, `gamepad_outlined`,
`format_list_numbered_rtl`, `search_outlined`, `settings_outlined`.

**`HomeScreen`** (modify) — `lib/features/home/presentation/screens/home_screen.dart`
— stateless, unchanged in every other respect. Its `bottomNavigationBar`
becomes `BottomTabBar(selectedIndex: context.tabsRouter.activeIndex,
onDestinationSelected: context.tabsRouter.setActiveIndex)` (C6). The five
`CustomNavigationDestination` constructions and the `NavigationBar` go away with
their imports.

**Deliberately unchanged in this file:** the `NotificationListener<UserScrollNotification>`
wrapping the tab bodies at line 61, its `getIt.get<ScrollNotifier>()` write and
the `ScrollNotifier` import stay exactly as they are. C6 states this split
explicitly — "the bar stops listening" is this run, "the screen stops notifying"
is FOLLOW-UP-1. The tab bodies, routes and their scrolling are untouched.

### Screens

None created. The Home shell above is the only screen touched, and only at its
wiring to the bar.

## Design decisions

**Placement and name.** The component stays in `lib/widgets/` and lands as one
flat file, `bottom_tab_bar.dart`, replacing `scrolled_navigation_bar.dart` and
`navigation_destination.dart`.

- *`lib/widgets/` over a feature folder* — §3.2 lists "Tab bar" as a named
  component of the design system alongside Game card, Status chip, Completion
  ring and Stat pill, all of which live in `lib/widgets/`. This item is a
  component-library item, the component is already there, and no criterion asks
  for a move.
- *`BottomTabBar`* — `ScrolledNavigationBar` names behaviour that no longer
  exists, and `TabBar` alone would collide with Material's top tab strip in
  every file that imports `material.dart`. Both design sources call it the tab
  bar and §6 opens with "fixed to the bottom of the frame", so `BottomTabBar`
  says what it is and where it sits without inventing a compound.
- *Flat file, not a module folder with `enum/`* — 2.1, 2.2 and 2.3 each got a
  folder because their enum is **public API**: a caller must pass
  `GameCardSize`, `CompletionRingSize` or `CountdownForm`. Here the caller passes
  an `int` and gets an `int` back (C2, C3, C6), so the destination enum is
  internal, the cell widget is internal, and the module has exactly one public
  class. `flutter-widgets` puts a helper only its parent uses in its parent's
  file; splitting one public widget across three files would copy the folder
  shape without the reason for it. If the human prefers the folder for
  consistency, it is a one-line delta at the gate.

**How much Material is kept.** Rebuilt, because the spec's anatomy has no
Material equivalent: the active-state visuals (cap, colours), the press
feedback, the focus ring, and the safe-area treatment (Material has no
zero-inset fallback). Kept by composition, because rebuilding them by hand
would be strictly worse: `MaterialLocalizations.tabLabel` for the localized tab
position (C9 — never string-interpolated), `Semantics(selected:)` for the
selected node (C8), Material's `Tooltip` for the long press (C11), and `InkWell`
for focus traversal, keyboard activation and the hit region (C2, C12) with its
ink painting suppressed rather than its behaviour rewritten (C13). The one
Material behaviour dropped outright is the ink ripple, and §1.8's press scale
replaces it rather than leaving the control with no affordance (ASSUMPTION-6).

**The cap.** A fixed `18 × 3` box with a fully-rounded radius
(`tokens.radius.full`), drawn as the first child of the cell's `Column` — above
the glyph, inside the cell, so it tracks the glyph rather than the bar. It is
present on all five cells at all times and only its colour changes,
`accentIndigo` when selected and `Colors.transparent` otherwise, so nothing
enters or leaves the layout and the row cannot jump on a tab change (C16). Its
`AnimatedContainer` and the glyph/label colour tween both run at
`tokens.motion.stateChange` (140ms) with `tokens.motion.standard`, resolved
through `tokens.motion.resolve` so they collapse to zero under reduced motion
(C22). Because the cap sits in a `Column` with `MainAxisSize.min` and no fixed
cell height, a wrapping-free label at any text scale pushes the column taller
rather than displacing the cap or overflowing (C21).

*Cap versus the 44 minimum:* at default text scale the column measures
3 (cap) + 4 + 20 (glyph) + 4 + ~12 (10px label line) = ~43, under the cell's
44 `minHeight`, so the cap costs nothing against the target — the cell is held
open at 44 by its own constraint and the ink well fills it. The 3px value ships
as the logged exception to the even-number convention (ASSUMPTION-2 / C16); the
4px gaps and the 20px glyph either side of it are even.

**Safe area.** `SafeArea(top: false, left: false, right: false, minimum:
EdgeInsets.only(bottom: 22))` wrapping the padded row, inside the `Material` so
the chrome colour still paints to the screen edge. One widget does both halves
of C19: it reserves the live inset **and** wraps its child in
`MediaQuery.removePadding(removeBottom: true)`, so a descendant sees a zero
bottom inset and nothing can apply it twice. The 22 fallback is `minimum`, so
the reserved space is `max(inset, 22)`.

*Reading recorded for QA:* C19 phrases the fallback as "where that inset is
zero", which taken literally would mean `inset > 0 ? inset : 22`. `max()` differs
only for a device reporting a small non-zero inset, and there it does what the
criterion's failure line asks for ("never sits flush to the screen edge") rather
than the opposite. Devices with gesture navigation report well above 22, so in
practice the two readings coincide.

## Note for FOLLOW-UP-1 — C5's test expires with the cleanup

C5 is verified by pumping the bar with **no scroll state registered at all**,
which proves the listener is genuinely gone rather than merely inert: today a
bar still calling `getIt.get<ScrollNotifier>()` would throw in that harness.
That discrimination only holds while the `ScrollNotifier` class and its
`@injectable` registration survive in the app's real DI, which FOLLOW-UP-1
leaves in place for now. **Once FOLLOW-UP-1 deletes the notifier, the test stops
proving anything** — the compiler, not the test, becomes what makes the lookup
unwritable, and the test passes for every possible implementation. Whoever picks
up FOLLOW-UP-1 should revisit or retire that test in the same change rather than
leaving it as evidence it no longer supplies.

## Reuse decisions

- `AppColorTokens.surfaceTabChrome`, `accentIndigo`, `ink55`, `green` and
  `AppTypeTokens.tabLabel` at `lib/config/theme/tokens/` — already defined in the
  dark theme and currently unwired; the component consumes them through
  `context.tokens` and adds no token (C14, C15, C16, C17).
- `AppMotionTokens.stateChange` / `standard` / `resolve` — the 140ms + standard
  ease pair and the reduced-motion switch already exist; no new duration or
  curve (C22).
- `AppRadiusTokens.full` for the cap and `sm` for the focus ring — no literal
  radius.
- `context.tokens` from `ContextExtensions` — theme access, never
  `Theme.of(context)` directly.
- `S.current.featured|games|tracker|browse|settings` — the five existing keys
  move from the shell into the destination enum unchanged. No `.arb` edit and no
  localisation regeneration is needed.
- **`ButtonPressScale` (`lib/widgets/button_press_scale.dart`) is deliberately
  not reused.** It supplies the press scale and the green focus ring, but its
  `FocusableActionDetector` registers no `ActivateIntent` action, so a focused
  child cannot be activated from the keyboard — C12 requires exactly that — and
  its focus ring adds its border and padding only while focused, which would
  reflow a tab cell the moment it takes focus. Making it fit means changing a
  shared widget the auth screen's `ActionRow` depends on, which this item is not
  scoped to touch. The cell gets keyboard activation from `InkWell` instead and
  reproduces the two visual treatments locally. Raising `ButtonPressScale`'s
  missing keyboard activation as its own item is worth doing; it is not this
  item.
- `ScrolledNavigationBar` and `CustomNavigationDestination` are **deleted, not
  deprecated.** `flutter-widgets` prefers `@Deprecated` over deletion to protect
  other callers mid-migration; the Phase 0 caller survey confirms these two have
  exactly one caller between them and it is rewired in this same item.
  `CustomNavigationDestination` returns a Material `NavigationDestination`, which
  is unusable outside a `NavigationBar` and so has nothing left to serve. More
  importantly, keeping `ScrolledNavigationBar` alive as deprecated would leave
  the codebase's only remaining **reader** of `ScrollNotifier` in the tree, which
  contradicts C5's "the bar stops listening" and would blur what FOLLOW-UP-1 has
  left to remove.

## Out of scope

- **The orphaned scroll notifier and its writers** — `scroll_notifier.dart`, its
  DI registration, `home_screen.dart`'s own `NotificationListener` at line 61,
  `browse_screen.dart:19`, `settings_screen.dart:26` and
  `settings_screen_test.dart:38` all stay. FOLLOW-UP-1 owns them; none is in the
  allowlist.
- **`theme_data_dark.dart`'s `navigationBarTheme`** — becomes unused once nothing
  builds a Material `NavigationBar`. It is a theme registration, harmless, no
  criterion touches it, and removing it would widen the item into the theme
  layer. Leave it.
- **`.claude/skills/flutter-widgets/SKILL.md`'s widget catalogue** — its
  `NavigationDestination` and `ScrolledNavigationBar` rows go stale with this
  change. That file is pipeline configuration rather than project source, so it
  is not in Dev's allowlist; flagged for the human at the gate.
- Destination count, order, labels, glyph-to-route mapping, routing behaviour,
  tab state preservation and deep links — unchanged (ASSUMPTION-8).
- Light theme (ASSUMPTION-7), the §6 mockup's different five destination names,
  and the Home screen's own content.
- Golden tests and any test asserting a pixel dimension, gap, radius, offset or
  painted position — those are the manual device checks named in C12, C13, C16,
  C17, C18, C20, C21 and C22, and go to `.agents/manual-check-backlog.md` at QA.

## Open questions

None.

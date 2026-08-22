# Task Brief
Source: `.agents/week-2-task-briefs.md` Stage 2 item 2.4 — Tab bar; `system-foundation-specs.md` §3.2 "Tab bar" row (with §1.7, §1.8, §1.9, §2, §5, §6); `home-screen-design-conventions.md` §6
Date: 2026-08-22

## Context

Replace the app's stock Material tab-bar chrome and its scroll-collapsing
wrapper with one token-driven `BottomTabBar` that is permanently visible, and
rewire its single caller — so the bottom chrome matches §3.2 and the shipped
colour inversion (indigo on the *inactive* destinations) is corrected.

## Testing mode

`smoke` — Rule applied: UI-only with no new logic, isolated with no shared
dependencies. Justification: nothing below the UI layer changes — no auth,
persistence, payment, offline path or shared utility is touched, and the
component takes no dependency beyond the theme. `smoke` is the mode, not the
size: the component owns real behaviour (selection driven by the caller's index,
tap and keyboard routing, screen-reader state and position, safe-area
consumption, no-scroll-state build), so it gets a dedicated test file with a
proportionate number of tests.

**Widgets getting a dedicated test file:**
- `BottomTabBar` — yes. It owns the behaviour listed above and a public
  contract (index in, index out) that can meaningfully regress.

**Widgets deliberately not getting one:**
- `_TabDestinationCell` and the destination enum — private, no public contract,
  and every behaviour they own is observable through `BottomTabBar`. Testing them
  separately would mean reaching for private types.
- `HomeScreen` — no dedicated test file, and none exists today. C6's contract is
  that the shell hands the bar only an index and a callback; after this change
  the bar's constructor exposes nothing else, so passing scroll state to it is
  not expressible and the analyzer, not a test, enforces it. Standing up
  `AutoTabsRouter` plus the DI and BLoCs of all five tab screens to assert one
  wiring line is out of proportion to what it would protect; the tab bodies are
  untouched and are already covered by their own screens' tests. **Flagged for
  the human at the gate — C6's verification line says "widget test".**

## File allowlist

### CREATE NEW
`lib/widgets/bottom_tab_bar.dart` — the static bottom tab bar: five fixed
destinations, token-driven chrome, cap, semantics, press/focus treatment, and
safe-area handling. Contains the public `BottomTabBar`, the private destination
cell and the private destination enum.

### MODIFY EXISTING
`lib/features/home/presentation/screens/home_screen.dart` — swap the
`ScrolledNavigationBar` + `NavigationBar` + five `CustomNavigationDestination`
construction for a single `BottomTabBar(selectedIndex:, onDestinationSelected:)`
and drop the imports that go with it. **Leave the
`NotificationListener<UserScrollNotification>` body wrapper, its `ScrollNotifier`
write and its `getIt`/`ScrollNotifier` imports exactly as they are.**

`lib/widgets/scrolled_navigation_bar.dart` — **DELETE.** Replaced by
`bottom_tab_bar.dart`; sole caller rewired above.

`lib/widgets/navigation_destination.dart` — **DELETE.** Replaced by
`bottom_tab_bar.dart`; sole caller rewired above.

### TEST FILES
`test/widget/components/bottom_tab_bar_test.dart` — the bar's behaviour:
destinations and labels, tap and keyboard index reporting, caller-driven
selection, screen-reader state and localized tab position, tooltip, building and
staying put with no scroll state registered, chrome and state colours, safe-area
consumption, `zh` and raised-text-scale rendering, reduced-motion settling.

Nothing else is in scope. In particular `scroll_notifier.dart`,
`service_locator*`, `browse_screen.dart`, `settings_screen.dart`,
`settings_screen_test.dart`, `theme_data_dark.dart` and the token files are
**not** in the allowlist — see `tdd.md ## Out of scope`.

## Implementation plan

Step 1: Create `lib/widgets/bottom_tab_bar.dart` — the private destination enum
(five values in order, each with its outline `IconData` and its `S.current`
label getter), the private stateful destination cell, and the public
`BottomTabBar`. No comments anywhere in the file.

Step 2: Rewire `lib/features/home/presentation/screens/home_screen.dart` to
`BottomTabBar(selectedIndex: context.tabsRouter.activeIndex,
onDestinationSelected: context.tabsRouter.setActiveIndex)`; remove the now-unused
`navigation_destination.dart`, `scrolled_navigation_bar.dart` and
`generated/l10n.dart` imports. Change nothing else in the file — the
`NotificationListener` body wrapper and its `ScrollNotifier` write stay.

Step 3: Delete `lib/widgets/scrolled_navigation_bar.dart`.

Step 4: Delete `lib/widgets/navigation_destination.dart`.

Step 5: Create `test/widget/components/bottom_tab_bar_test.dart` with the tests
named in `code-plan.md`, following the `flutter-widget-test` skill — no
dimension, gap, radius, offset or position assertions, colour assertions only
where they carry meaning and only via a named token, and never a golden test.

No `dart run build_runner build` step is required: this item adds no annotated
source, no `freezed`/`json_serializable` model, no injectable registration and no
mock — the bar has no dependency to mock. No `.arb` edit and no localisation
regeneration either; all five destination labels already exist in both `.arb`
files and only move file.

Final step: run `flutter analyze` and `flutter test` and compare against
`orchestrator-state.md`'s recorded baselines, quoted verbatim:
`Analyzer baseline: 0 errors, 2 warnings, 30 info (32 issues) — captured 2026-08-22`
and `Test baseline: +304 -10 — captured 2026-08-22`, with
`Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart (4),
test/cubit/game_detail/game_detail_cubit_test.dart (3), test/cubit/games/games_bloc_test.dart (3)`.
Only a new, in-scope failure is yours to fix. Note that deleting two files and
their imports may legitimately *lower* the info/warning count — a drop below
baseline is fine and should be reported, not "fixed".

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: 2.4-C1 … 2.4-C22 (all twenty-two).

## Constraints

- **Widgets carry no comments at all** — not a header, not a `///`, not a note
  above a `Stack` or a token lookup (`flutter-widgets`, and `execution.md`
  §Code quality). This overrides anything the design docs explain in prose.
- **Never `Theme.of(context)` directly** — use `context.themeData` /
  `context.tokens` from `ContextExtensions`.
- **Never a hardcoded user-facing string** — `S.current.[key]`.
- **No literal hex, no literal duration, no literal radius.** Every colour,
  duration, curve and radius comes from `context.tokens`.
- **Dimensions are even numbers.** The cap's `3` is the single logged exception
  (ASSUMPTION-2 / C16) and ships at 3; if it ever changes it rounds **up** to 4,
  never down to 2. Everything else the widget writes — 18, 20, 44, 22, 8, 6, 4,
  2 — is even.
- **Outlines are always solid.** The focus ring is a continuous `Border`; no
  dashed or dotted stroke, no `CustomPainter` for an edge.
- **Prefer `Expanded` over `Flexible`.** The five destination cells are
  `Expanded` — that is what makes them equal fifths (C20).
- **No spacing of its own** in the ordinary sense does not apply to the bar's
  own interior: the 8/6 padding and the safe-area inset are the chrome's own
  anatomy (C19), not spacing around a component. It still adds no margin outside
  itself.
- **Anatomy numbers live in the widget**, not in a shared `const.dart` — they
  describe this one component, matching `progress_dots.dart`, `action_row.dart`
  and `completion_ring/`.
- **No new package.** Everything needed is in `flutter/material.dart` and the
  existing theme extension.
- **Icons carry no `semanticLabel`** (C10) and `Tooltip` is constructed with
  `excludeFromSemantics: true` — both are required for the destination name to be
  announced exactly once.
- **Never a golden test**, and no test asserting a dimension, gap, radius, offset
  or painted position, whatever a criterion says about pixel appearance
  (`execution.md` §Scope, `testing-conventions.md`, `flutter-widget-test`).
- Widget tests live at `test/widget/components/`, layer-based, never mirrored
  from `lib/`.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to
make tests pass. Do not add packages to `pubspec.yaml` or touch files outside
the allowlist — escalate instead.

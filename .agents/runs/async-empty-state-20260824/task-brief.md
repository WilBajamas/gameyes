# Task Brief
Source: `tech-ac.md` (run `async-empty-state-20260824`), AC-01–AC-28
Date: 2026-08-24

## Context

Ship one shared `EmptyStateCard` in `lib/widgets/` and route five improvised
empty branches through it, so empty states stop wearing an error component, a
dashed border, or hardcoded English.

## Testing mode

`smoke` — Rule applied: "UI-only with no new logic". Justification: no domain,
data or state layer changes; every call site reuses the callback or cubit method
it already owns. Not `coverage`: nothing touches auth, payments, persistence or
an offline queue, and the component serves two features, not three-plus.

## File allowlist

### CREATE NEW
`lib/widgets/empty_state_card.dart` — the shared empty-state card: optional
glyph, caps headline, one supporting line, one required action.

### MODIFY EXISTING
`lib/l10n/intl_en.arb` — add 11 keys; drop the trailing `→` from `mark_something_playing`.
`lib/l10n/intl_zh.arb` — the identical 11 keys with Chinese values; drop the same `→`.
`lib/features/games/presentation/screens/games_screen.dart` — site 1: `GamesStatus.empty` renders `EmptyStateCard`; the two failed branches are untouched.
`lib/features/featured/presentation/widgets/library_stats.dart` — site 2: empty now-playing renders `EmptyStateCard`; delete `_DashedBorderPainter` and its `CustomPaint`/`BorderStyle.none` recipe.
`lib/features/featured/presentation/widgets/critics_grid.dart` — site 3: empty grid renders `EmptyStateCard`, action `onSkipPressed`.
`lib/features/featured/presentation/widgets/countdown_releases.dart` — site 4: empty weekly list renders `EmptyStateCard`, action switches to the Browse tab.
`lib/features/featured/presentation/screens/featured_screen.dart` — site 5: the silent countdown branch renders `EmptyStateCard` in the exact slot `SizedBox.shrink()` occupies, action switches to the Browse tab.
`.claude/skills/flutter-widgets/SKILL.md` — replace the empty-state note at lines 218-220 and add a catalogue entry.

### TEST FILES
`test/widget/components/empty_state_card_test.dart` — the card's content, its caps headline, its single action's callback, its optional glyph, and its raised-surface fill.

## Implementation plan

Step 1: `lib/l10n/intl_en.arb` — add the 11 new keys with the English values in
`tdd.md`'s table, and change `mark_something_playing` to `"Mark something as
playing"` (arrow removed).

Step 2: `lib/l10n/intl_zh.arb` — add the same 11 keys with Chinese values, and
change `mark_something_playing` to `"标记一些游戏为正在玩"` (arrow removed). The two
files must hold identical key sets and no English value may survive in the
Chinese file.

Generation checkpoint: regenerate `S` with `dart pub global activate intl_utils`
then `dart pub global run intl_utils:generate`, per
`.claude/pipeline/rules/generation.md`. Never `flutter gen-l10n`; `build_runner`
is not involved. Record which path was taken under `diff-summary.md ##
Deviations from implementation plan`.

Step 3: create `lib/widgets/empty_state_card.dart` per `code-plan.md`. Zero
comments in the file. No `Colors.*`, no `Color(0x…)`, no `colorScheme.*`, no
numeric radius literal, no `height:`, no `Border`, no `CustomPainter`, and no
`Padding`/`SizedBox` wrapping the outermost `ClipRRect`.

Step 4: `games_screen.dart` — replace the `GamesStatus.empty` branch's
`ErrorRetryWidget` with `EmptyStateCard`, keeping `context.read<GamesBloc>()
.add(const GamesFetched())` as the action. Do not touch the
`GamesStatus.failed` or `GamesNextPageStatus.failed` branches, and do not edit
`lib/widgets/error_retry_widget.dart`. After this step `ErrorRetryWidget` must
appear exactly twice in the file.

Step 5: `library_stats.dart` — replace `_buildNowPlayingCard`'s
`playingGames.isEmpty` branch with `EmptyStateCard`, then delete the
`_DashedBorderPainter` class entirely. Leave the non-empty branch and every
other method alone. Check for imports left unused by the deletion.

Step 6: `critics_grid.dart` — replace `_buildGrid`'s `criticsGames.isEmpty`
branch with `EmptyStateCard`, action `onSkipPressed`. Add the `generated/l10n.dart`
import. Do not add, rename or remove any constructor parameter on
`CriticsGridWidget`.

Step 7: `countdown_releases.dart` — replace `_buildReleasesList`'s
`outThisWeekGames.isEmpty` branch with `EmptyStateCard`, action
`AutoTabsRouter.of(context).setActiveIndex(3)` using the `BuildContext` the
method already receives. Add the `auto_route` and `generated/l10n.dart` imports.
Do not add, rename or remove any constructor parameter on
`CountdownReleasesWidget`.

Step 8: `featured_screen.dart` — replace `const SizedBox.shrink()` in
`_RightNowSection`'s `state.countdownGame == null &&
state.outThisWeekGames.isEmpty` branch with `EmptyStateCard`, action
`AutoTabsRouter.of(context).setActiveIndex(3)`. Keep the same `if`, the same
early `return` and the same position above the `CountdownReleasesWidget`
construction. Add no heading and no surrounding chrome. Do not touch the
`failed` branch or the `Skeletonizer` branch above it.

Step 9: create `test/widget/components/empty_state_card_test.dart` per
`code-plan.md`'s test list, following `test/widget/components/context_chip_test.dart`
and `stat_pill_test.dart` for shape and length.

Step 10: `.claude/skills/flutter-widgets/SKILL.md` — replace the empty-state note
at lines 218-220 with one naming `EmptyStateCard` and its required anatomy, and
add a catalogue row for it beside `HairlineGroup`. The
`ErrorRetryWidget`-as-empty-state workaround must not survive anywhere in the
file — check the "Error + retry" section at lines 180-187 as well, whose sample
passes `text: S.current.no_results_found`. Do not edit `project-conventions.md`.

Step 11: run `flutter analyze` and `flutter test` and compare against
`orchestrator-state.md`'s recorded baselines, quoted verbatim: **Analyzer
baseline: 0 errors, 2 warnings, 31 info** and **Test baseline: +343 -10**, with
the pre-existing failures in `test/repository/tracker/tracker_repository_test.dart`
(4), `test/cubit/game_detail/game_detail_cubit_test.dart` (3) and
`test/cubit/games/games_bloc_test.dart` (3). Only a new, in-scope regression is
yours to fix. Expect `+347` after step 9's four new tests.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: AC-01 through AC-28.

## Constraints

- **No constructor parameter may be added to `CriticsGridWidget`,
  `CountdownReleasesWidget` or `LibraryStatsWidget`.** Each is constructed twice
  in `featured_screen.dart`, once inside a `Skeletonizer` loading branch; a
  required parameter would force a diff hunk there, which AC-20 fails outright.
  This is why sites 4 and 5 act on their own `BuildContext` and site 3 reuses
  `onSkipPressed`.
- **Widgets carry no comments at all** — not a header, not a `///` on a
  constructor parameter (`flutter-widgets`; AC-10 makes it a criterion here).
- **Tokens only.** `context.tokens` via `ContextExtensions`; never
  `Theme.of(context)` directly, never a `Colors.*` or hex literal, never a
  numeric radius.
- **Dimensions are even numbers** for anything the new widget writes itself.
- **The component adds no spacing of its own** — no outer padding or margin, and
  no padding/gap constructor parameter. Callers own the surrounding layout.
- **Outlines are always solid**; no dashed stroke may survive at site 2.
- **Never a golden test**, and no widget test asserts a dimension, gap, radius or
  position. Colour assertions name a design token.
- **Tabs, not pushes:** `AutoTabsRouter.of(context).setActiveIndex(3)` for
  Browse. No `context.router.push`, no `BrowseRoute` reference (AC-17).
- All user-facing strings via `S.current.[key]`, keys in both `.arb` files.
- Import order: Dart, then package (flutter → third-party → project), then
  relative (`generated/l10n.dart` only), alphabetised within each group.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to
make tests pass. Do not add packages to `pubspec.yaml` or touch files outside the
allowlist — escalate instead.

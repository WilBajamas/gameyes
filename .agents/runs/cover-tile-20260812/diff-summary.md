# Diff Summary
Source: Week 2 task brief item 1.3 · `system-foundation-specs.md` §3.3 "Cover tile"
Date: 2026-08-13
Branch: claude/questloggd-week-2-components-ha43qm
Commit: c2ab32fbdd49bf7d4216e0c75dc9f624e3806040

## Files created
lib/widgets/cover_tile.dart — `CoverTileSize` enum (mini/row/fan/focal, each
carrying width/height and an `isMini` getter) and `CoverTile`, a stateless
`SizedBox` → `ClipRRect` → `Stack` with private `_CoverArtwork`,
`_CoverFallback` and `_CoverLoading` branch widgets. No colour filter on
loaded art; `coverWash` sits above the artwork only.

## Files modified
lib/widgets/default_cached_network_image.dart — added optional `imageBuilder`,
`placeholder`, `errorWidget` params typed with `cached_network_image`'s own
builder typedefs; `placeholder`/`errorWidget` fall back to today's spinner and
`Icons.error` widgets via `??`, `imageBuilder` passes straight through as
`null` by default. No existing call site touched.
.claude/skills/flutter-widgets/SKILL.md — added a `CoverTile` catalogue row
and noted the new optional builder overrides on the
`DefaultCachedNetworkImage` row.

## Test files
test/widget/components/cover_tile_test.dart — the four sizes' dimensions;
mini-vs-lg radius; the wash rendering above the artwork with no colour filter
at any size; the status chip rendering bottom-left in the on-media variant
(and its omission with no status, and at mini); the shared onyx/hairline/
glyph fallback for both a null/empty URL and a load failure, with the glyph
omitted at mini; the loading state rendering a Skeletonizer and no
`CircularProgressIndicator`; no outer spacing.
test/widget/components/default_cached_network_image_test.dart — the spinner
placeholder and error icon still render when no override is supplied, and no
`imageBuilder` is passed to the underlying `CachedNetworkImage` by default
([1.3-AC15]).

## Self-corrections
File: test/widget/components/cover_tile_test.dart — Error: the loading-state
test's `find.byType(Skeletonizer)` found nothing because `Skeletonizer`'s
public constructor is a factory returning a private `_Skeletonizer` subclass,
so exact-type matching never hits it — Fix: match with
`find.byWidgetPredicate((widget) => widget is Skeletonizer)` instead —
Attempts: 1

## Deviations from implementation plan
NONE — plan followed exactly, including the Approved feedback delta (no
colour-filter code or comment, and no comments on `_CoverArtwork` or the
three new `DefaultCachedNetworkImage` fields).

## Verification against baseline
`flutter analyze` — 0 errors, 2 warnings, 32 info: identical to the recorded
baseline, no new issues.
`flutter test test/widget/components/cover_tile_test.dart
test/widget/components/default_cached_network_image_test.dart` — 16/16 passed.
`flutter test` (full suite) — 257 passed, 11 failed. Baseline was 241 passed,
11 failed; the 11 failures are the same recorded pre-existing ones, in the
same four files (`tracker_repository_test.dart`,
`game_detail_cubit_test.dart`, `games_bloc_test.dart`, `widget_test.dart`).
The 16-test increase is exactly this run's two new test files (13 + 3
`testWidgets` blocks). No regression.

## Acceptance criteria status
[1.3-AC1]: satisfied
[1.3-AC2]: satisfied
[1.3-AC3]: satisfied
[1.3-AC4]: satisfied
[1.3-AC5]: satisfied
[1.3-AC6]: satisfied
[1.3-AC7]: satisfied
[1.3-AC8]: satisfied
[1.3-AC9]: satisfied
[1.3-AC10]: satisfied
[1.3-AC11]: satisfied
[1.3-AC12]: satisfied
[1.3-AC13]: satisfied
[1.3-AC14]: satisfied
[1.3-AC15]: satisfied
[1.3-AC16]: satisfied
[1.3-AC17]: satisfied
[1.3-AC18]: satisfied
[1.3-AC19]: satisfied
[1.3-AC20]: satisfied
[1.3-AC21]: satisfied

# QA Report
Source: Week 2 task brief item 1.3 · `system-foundation-specs.md` §3.3 "Cover tile"
Date: 2026-08-13

Overall result: PASS — pending manual checks

## Manual verification required
[1.3-AC6] — Render a `CoverTile` at each size with a real cover whose aspect ratio
is not 3:4 — expect the art centred and cropped to fill, no letterbox bars, no
distortion, no tile fill showing through.
[1.3-AC7] — Render a loaded cover at `row`/`fan`/`focal` beside the same source
image — expect identical hue and saturation, the wash being the only difference.
The saturate/contrast treatment must be visibly absent.
[1.3-AC8] — Same screen — expect one flat uniform indigo wash across the whole
artwork area, no gradient ramp, no per-size opacity difference.
[1.3-AC10] — `row` tile with a status supplied — expect the on-media chip inset
from the bottom-left corner, fully inside the tile's rounded bounds, not clipped.
[1.3-AC12] — Tile with a null URL and a tile with an unreachable URL — expect the
same onyx block, hairline outline and centred gamepad glyph; at `mini` (26×34)
expect fill + hairline only, and confirm the glyph's default 24px size still reads
correctly inside `fan` (100×134) and `row` (112×150).
[1.3-AC13] — Tile on a slow connection — expect a shimmer block at the tile's exact
box and radius, never a spinner, and no layout shift when the image arrives.
[1.3-AC15] — Home/featured screens (`library_stats`, `countdown_releases` ×2,
`critics_grid`) and `game_item`/`saved_game_item` — expect the spinner while loading
and the error icon on failure, exactly as before this change.

## Static analysis
Status: PASS
Errors: NONE
`flutter analyze`: 0 errors, 2 warnings, 32 info — identical to the recorded
`Analyzer baseline` (0 errors, 2 warnings, 32 info). No issue is attributed to any
allowlisted file. `dart run build_runner build --delete-conflicting-outputs` ran
clean and produced no git diff, so generated output is current — no annotated
source is in the allowlist, so none was expected.

## Test results
Status: PASS
Tests run: 16 (allowlisted) | Passed: 16 | Failed: 0
Full suite: 257 passed, 11 failed. Baseline `+241 -11`; the 11 failures are the
same pre-existing ones in `test/repository/tracker/tracker_repository_test.dart`,
`test/cubit/game_detail/game_detail_cubit_test.dart`,
`test/cubit/games/games_bloc_test.dart` and `test/widget_test.dart`, verified by
name. The +16 delta is exactly this run's two new files. No regression.
Failing tests: NONE new.

## Coverage gaps (coverage mode only)
NONE. Success and failure/error paths are both exercised: loaded artwork
(`should render the wash at coverWash above the artwork when art loads`), load
failure (`should render the same fallback when the image fails to load`), absent
data (`should render the onyx fallback ... when the url is null or empty`),
in-flight (`should render no CircularProgressIndicator while the image loads`), and
`DefaultCachedNetworkImage`'s three default-path regression tests.
Note: [1.3-AC15]'s regression is pinned at the widget's own defaults, not by
re-testing the six call sites — sound, since none of them passes a builder
(verified by grep, see AC15 below), but the visual confirmation stays MANUAL.

## Acceptance criteria
[1.3-AC1]: PASS — `lib/widgets/cover_tile.dart:22` `CoverTile`, `const`
constructor at :23, no `default` prefix, under `lib/widgets/`; `_CoverArtwork`
(:73), `_CoverFallback` (:90), `_CoverLoading` (:115) are private classes in the
same file, no Widget-returning function or getter, no new package.
[1.3-AC2]: PASS — `cover_tile.dart:8-20` closed enum with the four literal pairs
26×34 / 112×150 / 100×134 / 124×166; no width/height parameter on the constructor
(:23-27). Test `should render its stated dimensions when each of the four sizes
renders`.
[1.3-AC3]: PASS — `cover_tile.dart:38-40` outer `SizedBox` fixes both axes; nothing
reads parent constraints. `tester.getSize` assertions confirm the box.
[1.3-AC4]: PASS — one `Stack` at `cover_tile.dart:43`; the only per-size branches
are the radius (:32-34), the mini chip omission (:57) and the mini glyph omission
(:106) — the two documented ones.
[1.3-AC5]: PASS — `cover_tile.dart:32-34` reads `radius.mini`/`radius.lg` from
`context.tokens`; `ClipRRect` at :41 wraps the whole `Stack`. Test `should clip to
the mini radius at mini and the lg radius at the other three sizes` asserts
`BorderRadius.circular(5)` / `(16)` against the tokens.
[1.3-AC6]: MANUAL — `cover_tile.dart:83` `Image(image: image, fit: BoxFit.cover)`.
Code is correct; visual crop/no-letterbox is a human check.
[1.3-AC7]: PASS — `_CoverArtwork` (`cover_tile.dart:73-88`) composes the `Image`
directly: no `ColorFiltered`, no `ColorFilter`, no `color`/`colorBlendMode`, no
`Opacity`, no blend mode anywhere in the file; grep for `ColorFilter|colorBlendMode|
artworkFilter|saturat|contrast` across `lib/widgets/cover_tile.dart` and
`lib/widgets/default_cached_network_image.dart` returns nothing. The Phase 3
reversal is fully carried through — no leftover `artworkFilter` constant in code,
tests or docs. Test `should render the artwork with no colour filter when art
loads` asserts this across all four sizes. Correctly absent per revised
[1.3-AC7]; §3.3's `saturate(.5) contrast(1.05)` is intentionally not implemented
and is NOT flagged as a spec violation.
[1.3-AC8]: PASS — the wash survives the filter removal intact:
`cover_tile.dart:84` `ColoredBox(color: context.tokens.color.coverWash)` sits above
the `Image` in `_CoverArtwork`'s `Stack` with `StackFit.expand`, so it covers the
full artwork area at one uniform opacity. `coverWash` is
`Color.fromRGBO(10, 13, 58, 0.42)` (`app_color_tokens.dart:123`) — matches the
criterion's `rgba(10,13,58,.42)`. No gradient, no per-size opacity, no colour
literal in the widget file. Test `should render the wash at coverWash above the
artwork when art loads` asserts child order (`Image` at index 0, `ColoredBox` at 1)
and the colour.
[1.3-AC9]: PASS — the wash lives inside `_CoverArtwork` only; `_CoverFallback`
(:90) and `_CoverLoading` (:115) never see it. Test `should render no wash over the
fallback when no url is supplied`.
[1.3-AC10]: MANUAL — `cover_tile.dart:57-65` `Positioned(left: 8, bottom: 8)` with
`StatusChipVariant.onMedia`, guarded by `status != null && !size.isMini`; nothing
renders otherwise. Tests cover the variant, the 8/8 inset, the empty slot not
changing the tile's size, and the mini omission. Human check: the chip sits inside
the rounded bounds and is not clipped.
[1.3-AC11]: PASS — the constructor exposes only `size`, `imageUrl`, `status`
(`cover_tile.dart:23`); the `Stack` has no other overlay slot.
[1.3-AC12]: MANUAL — one `_CoverFallback` serves both the null/empty branch
(`cover_tile.dart:46-47`) and the load-failure branch (:54-55): `colors.canvas`
fill, `Border.all(color: colors.hairline)`, centred `Icons.videogame_asset_outlined`
in `colors.ink24`, glyph omitted at mini (:106). No `error_404.png`, no
`Icons.error`, no initial — tests assert all three absences. Human check: glyph
legibility and the outline weight at each size.
[1.3-AC13]: MANUAL — `_CoverLoading` (`cover_tile.dart:115-131`) is a `Skeletonizer`
over a `DecoratedBox` at the tile's radius, inside the fixed `SizedBox`. Test
`should render no CircularProgressIndicator while the image loads` confirms the
`Skeletonizer` and the spinner's absence. Human check: shimmer appearance and no
layout shift on arrival.
[1.3-AC14]: PASS — `cover_tile.dart:49` routes through `DefaultCachedNetworkImage`;
no `Image.network` in the file.
[1.3-AC15]: PASS — the three new params are genuinely additive, verified three ways.
(a) Signature: all three are nullable with no default and sit after the existing
required `imageUrl` (`default_cached_network_image.dart:6-16`); the constructor is
still `const`, nothing removed, nothing deprecated. (b) Behaviour: `placeholder ??`
and `errorWidget ??` (:24-35) fall back to byte-identical widgets — the same
40×40 `CircularProgressIndicator` and the same `Center(child: Icon(Icons.error))` —
and `imageBuilder` passes through as `null`, which is exactly what
`CachedNetworkImage` received before, since it was previously not passed at all.
`fit: BoxFit.cover` and `imageUrl ?? ''` are untouched. (c) Callers: all six
pre-existing call sites pass `imageUrl` only and none was edited —
`lib/widgets/game_item.dart:118`, `lib/widgets/saved_game_item.dart:152`,
`lib/features/featured/presentation/widgets/library_stats.dart:437`,
`.../countdown_releases.dart:111`, `.../countdown_releases.dart:377`,
`.../critics_grid.dart:205`; git confirms none of those files is in the commit.
No parallel duplicate wrapper was added. Regression pinned by
`default_cached_network_image_test.dart` (spinner default, error-icon default, and
`imageBuilder` is `null` when unsupplied). Rendering equivalence is a code-level
PASS; on-screen confirmation is listed under MANUAL.
[1.3-AC16]: PASS — no `onTap`, `InkWell`, `GestureDetector`, `Hero` or press/hover
treatment anywhere in `cover_tile.dart`.
[1.3-AC17]: PASS — checked independently of `tdd.md` against the `flutter-widgets`
"No spacing of its own" rule. The outermost widget is `SizedBox` →
`ClipRRect` → `Stack` (`cover_tile.dart:38-43`): no `Padding`, `Margin`,
`SizedBox` spacer or `EdgeInsets` anywhere in the file, and the constructor
(:23) exposes no `padding`/`margin`/`gap`/`spacing` parameter. The only inset is
the chip's `Positioned(left: 8, bottom: 8)` inside the tile's own bounds — the
widget's anatomy, permitted by the rule. `_CoverFallback` and `_CoverLoading` add
none either. Test `should add no spacing of its own when rendering` asserts no
`Padding` ancestor and the exact 112×150 box.
[1.3-AC18]: PASS — every colour and radius comes from `context.tokens`
(`cover_tile.dart:31, 84, 98, 125`); no `Theme.of(context)`, no `Color(0x…)`, no
`Colors.*`, no hardcoded radius. Literal numbers are the four dimension pairs
(:9-12) and the 8/8 chip inset (:59-60) — nothing else.
[1.3-AC19]: PASS — no `Text`, no `S.current`, no `label`/`title` parameter. Test
asserts `find.byType(Text)` finds nothing in the fallback.
[1.3-AC20]: PASS — `test/widget/components/cover_tile_test.dart` covers all
enumerated cases: dimensions, mini-vs-lg radius, wash above artwork, no colour
filter at any size, chip variant/position/omission/mini-omission, fallback for
null and empty URL and for load failure, no `error_404.png` or initial, no
`CircularProgressIndicator`. No `matchesGoldenFile` and no golden test in either
new file. 16/16 pass, no new failure against baseline.
[1.3-AC21]: PASS — `.claude/skills/flutter-widgets/SKILL.md` gains a `CoverTile`
catalogue row ending "adds no spacing of its own", and the
`DefaultCachedNetworkImage` row notes the optional builders.

## Architectural compliance
Status: PASS
FAILs: NONE
- Against `tdd.md`: class names, file paths and constructor shape all match —
  `CoverTile`/`CoverTileSize`/`_CoverFallback`/`_CoverLoading` in
  `lib/widgets/cover_tile.dart`, `imageUrl`/`size`/`status` constructor, three
  optional builders on `DefaultCachedNetworkImage`. Composition order
  artwork → wash → chip is as designed, with the wash inside the loaded branch
  only. No package added — `skeletonizer` and `cached_network_image` were already
  in `pubspec.yaml`. `StatelessWidget` as specified.
- Against the `flutter-widgets` skill: placement in `lib/widgets/`, no `default`
  prefix, `const` constructor, private helpers as classes in the same file (never
  Widget-returning functions), no spacing of its own, `context.tokens` rather than
  `Theme.of(context)`, no `Image.network`, no golden tests, catalogue updated. No
  skill-level violation found.

WARNINGs:
1. `_CoverArtwork` is not named in `tdd.md`'s widget list — `tdd.md` names
   `_CoverFallback` and `_CoverLoading` but folds the artwork into the composition
   prose. It is in `task-brief.md` step 4 and in `code-plan.md`, so this is a
   `tdd.md` omission rather than an implementation deviation. Additive, harmless.
2. `_CoverLoading` reads `context.tokens.color.surfaceRaised`
   (`cover_tile.dart:125`), a token `tdd.md`'s consumed-token list does not
   mention. It is an existing token read through `context.tokens`, so [1.3-AC18]
   still holds. Additive, harmless.
3. Uncommitted working-tree state at QA time: `orchestrator-state.md` modified and
   `diff-summary.md` untracked. Both are pipeline artifacts in the run folder, not
   source, and neither affects the reviewed commit — noted for the record.

Scope check (git, not `diff-summary.md`'s self-report): `git show --name-only
c2ab32fb` lists exactly five files — `lib/widgets/cover_tile.dart`,
`lib/widgets/default_cached_network_image.dart`,
`.claude/skills/flutter-widgets/SKILL.md`,
`test/widget/components/cover_tile_test.dart`,
`test/widget/components/default_cached_network_image_test.dart` — every one on the
allowlist, and nothing on the allowlist missing. The wider
`8c9c38b..c2ab32fb` range also touches `.agents/runs/cover-tile-20260812/*`, which
belongs to the two earlier Phase 3 pipeline-doc commits (`3b0063c`, `174a599`), not
to the Dev commit. No source file outside the allowlist was touched. No file
appears in git that `diff-summary.md` failed to mention. `## Deviation approvals`
is NONE and `diff-summary.md` declares no deviation — consistent.

## Escalation required
NONE

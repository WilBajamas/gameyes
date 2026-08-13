# Diff Summary
Source: Week 2 task brief item 1.4 · `system-foundation-specs.md` §0, §1.9, §3.3 ·
`onboarding-auth-design-spec.md` §3, §5, §9, §10 · `flutter-widgets` skill
Date: 2026-08-13
Branch: claude/questloggd-week-2-components-ha43qm
Commit: 482a31958d858dd2ebca7a058fd50b7a64bc6d12

## Files created
lib/widgets/placeholder_slot.dart — `PlaceholderSlotSize` enum (`appMark` 88,
`providerMark` 20) and `PlaceholderSlot`, a const `StatelessWidget` rendering a
`SizedBox.square` → `DecoratedBox` with `ink12` fill, resolved radius (literal 20 for
the app mark, `xs` token for the provider mark), and a solid `Border.all(color: ink24)`
outline. `LOGO` marker text (display-face `zoneLabel` token resized to 14px /
`2.24` letter spacing) centred at the app-mark preset only. Produced by `git mv` from
`lib/widgets/logo_placeholder.dart` — no file remains at the old path.

## Files modified
lib/features/auth/presentation/screens/auth_screen.dart — swapped the
`logo_placeholder.dart` import for `placeholder_slot.dart` and changed the header
`Center` child from `LogoPlaceholder(width: 88, height: 88)` to
`PlaceholderSlot(size: PlaceholderSlotSize.appMark)`; nothing else in the file changed.

.agents/references/onboarding-auth-design-spec.md — §3's anatomy line and rationale
paragraph, §5's anatomy line and rationale paragraph (dashed → solid, rationale rests on
the slot being empty rather than on the edge being broken), §9's checklist bullet and
§10's composition bullet (both renamed to `PlaceholderSlot`'s two-preset API).

.agents/references/system-foundation-specs.md — §0 Principles gained item 6 ("Outlines
are always solid"), appended rather than inserted so items 1–5 keep their numbers;
§1.9's iconography sentence lost the word "dashed"; §3.3's "Placeholder slot" row now
reads "Reserved empty box" with a solid 1px border.

.claude/skills/flutter-widgets/SKILL.md — added an "Outlines are always solid"
convention bullet under "Building a new reusable widget" (beside "No spacing of its
own"), and a `PlaceholderSlot` catalogue row after the `StatusChip` row.

## Test files
test/widget/components/placeholder_slot_test.dart — box size and radius per preset,
`ink12` fill, a solid 1px `ink24` `Border` on both presets with no `CustomPaint`
anywhere in the subtree, the `LOGO` marker rendering only at the app-mark preset in the
display-face 700 style, self-sizing inside a fixed-size and an unbounded parent, and no
spacing of its own. Follows `cover_tile_test.dart`'s pumping and font warm-up shape.

## Self-corrections
NONE

## Deviations from implementation plan
NONE — the plan was followed exactly, including the Phase 3 comment-removal delta (no
inline comments in `placeholder_slot.dart`).

## Verification against baseline
`flutter analyze` — 0 errors, 2 warnings, 32 info. Matches the recorded baseline
exactly (`Analyzer baseline: 0 errors, 2 warnings, 32 info`); none of the issues are in
this run's files.

`flutter test test/widget/components/placeholder_slot_test.dart` — 8/8 passed.

`flutter test test/widget/auth/auth_screen_test.dart` — 4/4 passed, including the
`find.text('LOGO')` assertion unchanged.

`flutter test` (full suite) — +265 -11. 257 baseline passes + 8 new tests = 265; the 11
failures are exactly the recorded pre-existing set (`tracker_repository_test.dart` (4),
`game_detail_cubit_test.dart` (3), `games_bloc_test.dart` (3), `widget_test.dart` (1)).
No new, in-scope failure.

## Acceptance criteria status
1.4-AC1: satisfied
1.4-AC2: satisfied
1.4-AC3: satisfied
1.4-AC4: satisfied
1.4-AC5: satisfied
1.4-AC6: satisfied
1.4-AC7: satisfied
1.4-AC8: satisfied
1.4-AC9: satisfied
1.4-AC10: satisfied
1.4-AC11: satisfied
1.4-AC12: satisfied
1.4-AC13: satisfied
1.4-AC14: satisfied
1.4-AC15: satisfied
1.4-AC16: satisfied
1.4-AC17: satisfied
1.4-AC18: satisfied

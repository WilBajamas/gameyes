# Task Brief
Source: Week 2 task brief item 1.2 · `system-foundation-specs.md` §3.2/§3.3 · `tech-ac.md`
Date: 2026-08-12

## Context

Ship the app-wide status-chip primitive — one pill, six statuses, two variants, an
optional load-bearing count — so the cover tile, game card and library screen all draw
status from one component instead of three.

## Testing mode

smoke — Rule applied: "UI-only with no new logic, isolated with no shared
dependencies" — Justification: presentation only; no persistence, no auth, no shared
utility, no state layer. The test scope is still the full list [1.2-AC20] enumerates,
plus one flush-render check for [1.2-AC15]. No golden test, no `matchesGoldenFile`.

## File allowlist

### CREATE NEW
lib/core/enums/library_status.dart — the closed six-value status set, no fields, no imports
lib/widgets/status_chip.dart — `StatusChip`, `StatusChipVariant`, private `_StatusDot`

### MODIFY EXISTING
lib/config/theme/tokens/app_color_tokens.dart — add `glass42` (constructor param, field, `dark` value, `copyWith`, `lerp`) beside the existing glass ramp
lib/l10n/intl_en.arb — add `backlog` and `dropped` keys
lib/l10n/intl_zh.arb — add the same two keys
.claude/skills/flutter-widgets/SKILL.md — one catalogue row for `StatusChip`
.agents/references/system-foundation-specs.md — one §6 local-additions row for `rgba(0,0,0,.42)`

### TEST FILES
test/widget/theme/app_tokens_test.dart — one assertion for the new `glass42` value
test/widget/components/status_chip_test.dart — the [1.2-AC20] behaviours

## Implementation plan

Step 1: `lib/config/theme/tokens/app_color_tokens.dart` — add `glass42` as
`Color.fromRGBO(0, 0, 0, 0.42)` next to `glass34`, wiring it through the constructor,
the field list, `AppColorTokens.dark`, `copyWith` and `lerp`. Touch nothing else.

Step 2: `lib/l10n/intl_en.arb` — add `"backlog": "Backlog"` and `"dropped": "Dropped"`
directly after the existing `"onHold"` key so the status keys sit together.

Step 3: `lib/l10n/intl_zh.arb` — add the same two keys at the same position:
`"backlog": "待玩"`, `"dropped": "弃坑"`. The `S` accessors do **not** exist until a
human runs the Flutter Intl IDE regeneration — never run `flutter gen-l10n`, never
hand-write `lib/generated/l10n.dart`, and record this in
`diff-summary.md ## Deviations from implementation plan`.

Step 4: `lib/core/enums/library_status.dart` — create the bare enum
`LibraryStatus { playing, backlog, completed, onHold, wishlist, dropped }`. No
constructor fields, no methods, no imports.

Step 5: `lib/widgets/status_chip.dart` — create `StatusChipVariant`, `StatusChip` and
private `_StatusDot` per `code-plan.md`. Everything colour, radius and type comes from
`context.tokens`; the file declares no colour, font or radius literal. The dot reverts
to `colors.ink` on the filled treatment — that is the invisible-dot trap, and it gets
the one explanatory comment in the file.

Step 6: `test/widget/theme/app_tokens_test.dart` — add a single
`expect(colors.glass42, const Color.fromRGBO(0, 0, 0, 0.42));` beside the existing
glass assertions in the "welcome surface and glass colours" test. Change nothing else
in that file.

Step 7: `test/widget/components/status_chip_test.dart` — write the widget tests listed
in `code-plan.md ## TEST FILES`. Follow `test/widget/components/zone_label_test.dart`:
`MaterialApp(theme: buildDarkTheme())`, `GoogleFonts.config.allowRuntimeFetching =
false`, a local `buildSubject` helper. No mocks, no `@GenerateMocks`, no build_runner.

Step 8: `.claude/skills/flutter-widgets/SKILL.md` — append one row to the reusable
widget catalogue table for `StatusChip`, noting it adds no spacing of its own.

Step 9: `.agents/references/system-foundation-specs.md` — add one row to the §6 local
additions register for `rgba(0,0,0,.42)`, scoped to the status chip's on-media capsule
and noting it is now the `glass42` token.

Step 10 (final): run `flutter analyze` and `flutter test`, and compare against
`orchestrator-state.md` verbatim — `Analyzer baseline: 0 errors, 2 warnings, 32 info —
captured 2026-08-12T13:41:00Z` and `Test baseline: +228 -11 — captured
2026-08-12T13:44:00Z`, with `Pre-existing test failures:
test/repository/tracker/tracker_repository_test.dart (4),
test/cubit/game_detail/game_detail_cubit_test.dart (3),
test/cubit/games/games_bloc_test.dart (3), test/widget_test.dart (1)`. **Expected
additional state until the l10n regen runs:** undefined-getter errors for
`S.current.backlog` / `S.current.dropped` in `lib/widgets/status_chip.dart` and a
compile failure in `test/widget/components/status_chip_test.dart`. Report them, do not
fix them, and do not spend self-correction attempts on them.

No `dart run build_runner build --delete-conflicting-outputs` step is needed — this run
adds no annotated source and no mocks.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: 1.2-AC1 – 1.2-AC21 (all)

## Constraints

- `lib/widgets/` placement, categorical name, no `default` prefix, `const` constructor,
  private helper in the same file, plain Flutter widgets — `flutter-widgets` skill.
- **No spacing of its own** (standing convention, item 1.1): no outer padding, margin or
  spacer, and no `EdgeInsets`/`padding`/gap constructor parameter. The capsule's own
  interior padding is anatomy and is expected.
- One interior padding for **both** variants —
  `EdgeInsets.symmetric(horizontal: 8, vertical: 4)`. The variants differ only in dot
  diameter (6 on-media / 7 list) and capsule fill, per [1.2-AC5].
- Theme only through `context.tokens` — never `Theme.of(context)`
  (`ContextExtensions`, `lib/core/utils/extensions.dart`).
- Reuse `GlassSurface` (`lib/widgets/glass_surface_widget.dart`) for the on-media blur;
  do not write a second `BackdropFilter`.
- Gaps between the dot, label and count use `Row(spacing: 6)` — flex gap, never a
  margin or a `SizedBox` between siblings (§1.3).
- No Widget-returning function or getter; extracted UI is a widget class.
- Lints that bite here: `prefer_single_quotes`, `require_trailing_commas`,
  `lines_longer_than_80_chars`, `no_default_cases` (both status switches must be
  exhaustive, no `default:`), `avoid_unnecessary_containers`.
- No bare top-level constants — the per-variant dot size lives on the
  `StatusChipVariant` enum as a constructor field.
- Import order: dart → package (flutter, third-party, project) → relative, and
  `generated/l10n.dart` stays a relative import, matching `lib/widgets/`'s existing files.
- Android only. No iOS verification, no golden test.
- `lib/widgets/saved_game_status_tag.dart` and
  `lib/features/tracker/presentation/screens/tracker_game_detail_screen.dart` are out of
  scope — no edit, no `@Deprecated`.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make tests
pass. Do not add packages to `pubspec.yaml` or touch files outside the allowlist —
escalate instead. The missing `S.current.backlog` / `S.current.dropped` accessors are
not a failure point and consume no attempts.

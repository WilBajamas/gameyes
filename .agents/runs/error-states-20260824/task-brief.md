# Task Brief
Source: `tech-ac.md` (week 2 Stage 2 item 2.7 — Error states)
Date: 2026-08-24

## Context

Build §3.4's Action, Screen and Item error levels as three new components in one module beside
the existing error surfaces, add the one colour token the toast needs, and delete one dead file —
all unwired, so no shipped screen changes appearance.

## Testing mode

**smoke** — Rule applied: UI-only with no new logic, isolated with no shared dependencies.
Justification: three display components with caller-supplied inputs, no state layer, no
persistence, no shared utility. Three new widget test files plus two assertions added to the
existing token unit test. Never a golden test; never an assertion on a dimension, gap, radius,
offset or position.

## File allowlist

### CREATE NEW
lib/widgets/error_states/error_dot.dart — circle filled with the `error` token at a caller-given size, optional centred glyph; shared by the toast and the item badge
lib/widgets/error_states/enum/error_notice_variant.dart — two-value enum, `strip` and `toast`
lib/widgets/error_states/error_notice.dart — screen-level notice; renders exactly one of the strip or toast surfaces, plus both private surface classes
lib/widgets/error_states/destructive_action_pair.dart — destructive action beside a safe one, each with its own label and callback
lib/widgets/error_states/failed_item.dart — wraps a child in the failed treatment: 55% dim, error hairline, wordless corner badge

### MODIFY EXISTING
lib/config/theme/tokens/app_color_tokens.dart — add the `surfaceToast` field (`Color(0xFF2E3236)`) and wire it through the constructor, `dark`, `copyWith` and `lerp`
lib/features/game_detail/presentation/screens/game_detail_screen.dart — remove lines 71–73 only: the blank line, the `/// TODO: fetch screenshots - from game detail` comment and the commented-out `DetailScreenshotsSection` call

### DELETE
lib/features/game_detail/presentation/screens/detail_screenshot_section.dart — deleted in full, not emptied or stubbed

### TEST FILES
test/widget/components/destructive_action_pair_test.dart — the destructive fill and safe fill resolve to their tokens, no green anywhere, each callback fires once and only its own
test/widget/components/error_notice_test.dart — per variant: the selected surface and its token are present and the other's marks are absent; strip fill/hairline/message tokens; strip dismiss invokes the callback once and the caller can re-show it; toast surface token, dot present with no icon, message constrained to one line
test/widget/components/failed_item_test.dart — the child sits under an opacity of 0.55, the hairline resolves to `errorLine`, the badge fills with `error` and carries the supplied semantics label, and the component renders no `Text`
test/widget/theme/app_tokens_test.dart — MODIFY: assert `surfaceToast` is `0xFF2E3236` and, separately, that `surfaceTabChrome` still is; add `surfaceToast` to the `_allColors` helper list

## Implementation plan

Step 1: `lib/config/theme/tokens/app_color_tokens.dart` — add `final Color surfaceToast;` in the Surfaces group directly after `surfaceTabChrome`, with no doc comment, and wire it through the constructor, the `dark` instance (`Color(0xFF2E3236)`), `copyWith` and `lerp` in the same order as its neighbours. Do not rename, move or re-value `surfaceTabChrome`.

Step 2: `test/widget/theme/app_tokens_test.dart` — add `colors.surfaceToast` to the `_allColors` helper, and add two independent assertions naming their own tokens: `surfaceToast` is `const Color(0xFF2E3236)` and `surfaceTabChrome` is `const Color(0xFF2E3236)`. Do **not** add `surfaceToast` to the existing "three distinct raised surfaces" `Set` at lines 38–50 and do not assert the two tokens equal each other — they are independent names that happen to share a value today.

Step 3: `lib/widgets/error_states/error_dot.dart` — `ErrorDot`, stateless, `const` constructor, parameters `required double size` and `IconData? glyph`. `SizedBox.square` over `ClipOval` over `ColoredBox` filled `context.tokens.color.error`, with the glyph centred at 12px in `ink` when given. No `BoxDecoration` anywhere in this file. No comments.

Step 4: `lib/widgets/error_states/enum/error_notice_variant.dart` — `enum ErrorNoticeVariant { strip, toast }`. No fields, no methods.

Step 5: `lib/widgets/error_states/error_notice.dart` — `ErrorNotice`, stateless, `const` constructor with `required this.variant`, `required this.message`, `required this.onDismiss` and nothing else. `build` switches on `variant` and returns `_ErrorStrip` or `_ErrorToast`, both private to this file. Strip: `DecoratedBox` with `BoxDecoration(color: errorTint, border: Border.all(color: errorLine), borderRadius: circular(radius.lg))`, interior padding of its own, a row of the message (`typography.meta` in `errorInk`) and a 44px `InkWell` around `Icons.close` in `errorInk`, wrapped in `Semantics(container: true, button: true, label: MaterialLocalizations.of(context).closeButtonTooltip)` and calling `onDismiss`. Toast: `ClipRRect` at `radius.sm` over `ColoredBox` filled `surfaceToast`, containing `ErrorDot(size: 8)` and the message (`typography.meta` in `ink`) with `maxLines: 1` and `TextOverflow.ellipsis`. No `Icon`, no `Duration`, no timer, no state, no `child`/`content`/`visible` parameter. No comments.

Step 6: `lib/widgets/error_states/destructive_action_pair.dart` — `DestructiveActionPair`, stateless, `const` constructor with `required this.destructiveLabel`, `required this.safeLabel`, `required this.onDestructive`, `required this.onSafe`, no defaults and no variant selector of any kind. A `Row` with `spacing: 12` holding two `Expanded` children: safe first — `PrimaryButton(label: safeLabel, onPressed: onSafe, backgroundColor: tokens.color.ink08, labelColor: tokens.color.ink)` — then destructive — `PrimaryButton(label: destructiveLabel, onPressed: onDestructive, backgroundColor: tokens.color.errorStrong, labelColor: tokens.color.ink)`. Pass both colours explicitly on both buttons so `PrimaryButton`'s green default never resolves. No comments.

Step 7: `lib/widgets/error_states/failed_item.dart` — `FailedItem`, stateless, `const` constructor with `required this.semanticsLabel` and `required this.child`. A `Stack` whose first child is a `DecoratedBox` at `DecorationPosition.foreground` (1px `errorLine` border at `radius.lg`) wrapping `Opacity(opacity: 0.55, child: child)`, and whose second child is `Positioned(top: 8, right: 8, child: Semantics(container: true, label: semanticsLabel, child: const ErrorDot(size: 20, glyph: Icons.priority_high)))`. No `Text`, no badge label parameter, no `isFailed` toggle. No comments.

Step 8: delete `lib/features/game_detail/presentation/screens/detail_screenshot_section.dart` in full.

Step 9: `lib/features/game_detail/presentation/screens/game_detail_screen.dart` — remove the blank line, the `/// TODO: fetch screenshots - from game detail` comment and the `// DetailScreenshotsSection(id: gameExtra!.$1);` line (currently 71–73). Change nothing else: the `S.current.screenshots` heading, its `Padding`, and every other live widget stay. There is no import of the deleted file to remove — verify before assuming one.

Step 10: `test/widget/components/destructive_action_pair_test.dart` — new file, `context_chip_test.dart` / `stat_pill_test.dart` shape: `buildSubject` helper, `buildDarkTheme()`, the four localisation delegates, `GoogleFonts.config.allowRuntimeFetching = false`.

Step 11: `test/widget/components/error_notice_test.dart` — new file, same shape. Scope every finder with `find.descendant(of: find.byType(ErrorNotice), ...)`; never an unscoped `find.byType(ColoredBox)`, `DecoratedBox`, `Icon` or `Text`. The dismiss-and-re-show behaviour needs a harness that owns the visibility flag (the component holds no dismissal state).

Step 12: `test/widget/components/failed_item_test.dart` — new file, same shape. Give `FailedItem` a non-`Text` child so the "renders no `Text`" assertion means something.

Step 13: run `flutter analyze` and `flutter test`, and compare against `orchestrator-state.md`'s baselines quoted verbatim: `Analyzer baseline: 0 errors, 2 warnings, 31 info (33 total)` and `Test baseline: +325 -10`. `Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart (4), test/cubit/game_detail/game_detail_cubit_test.dart (3), test/cubit/games/games_bloc_test.dart (3)` — those ten are not yours; the suite is not green and is not expected to be. Expect the pass count to rise by the number of new tests and the analyzer counts to be unchanged; a new warning or info arising from the deletion is in scope to fix inside the allowlist, a pre-existing one is not.

No code generation is required in this run: no annotated source, no `.arb` edit, no route change. Do not run `build_runner` or any l10n generator.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: [2.7-AC1] through [2.7-AC35]

## Constraints

- **Widget files carry no comments at all** — not a header, not a `///`, not a note above a
  `Stack` or a token lookup. Stricter than the project-wide rule and it overrides it here.
- **Every colour resolves through a token** via `context.tokens.color` — no literal hex, no
  `Colors.*`, no `withOpacity` faking a token [2.7-AC33]. Theme access is `context.tokens` /
  `context.themeData`, never `Theme.of(context)` directly.
- **The 55% dim is an `Opacity`, not a colour** [2.7-AC21] — a token cannot dim cover artwork.
- **Every dimension the new widgets write is an even number** (8, 12, 20, 44 here). No odd value,
  no new radius token, no new type step — 14/500 is the existing `typography.meta`.
- **No spacing of its own**: no outer padding, margin or gap parameter on any of the three
  components. Interior padding of a surface a component draws itself is fine.
- **Outlines are solid.** Both hairlines are a plain `Border` in a `BoxDecoration`.
- **No hardcoded user-facing English and no new localisation key.** Every visible string is
  caller-supplied; the one string a component owns (the dismiss affordance's accessibility label)
  comes from `MaterialLocalizations`. Do not touch `intl_en.arb` / `intl_zh.arb`.
- **No parameter, variant or branch nothing calls** — no outline-in-error-ink variant
  [2.7-AC9], no `isFailed` toggle [2.7-AC27], no `child`/`content`/`visible` on `ErrorNotice`
  [2.7-AC20], and no way to express "strip and toast together" [2.7-AC11].
- **Do not touch, in any way, including tidying imports:** `lib/widgets/error_retry_widget.dart`,
  `lib/widgets/default_snackbar.dart`, `lib/widgets/game_screenshot.dart` (**live** —
  `image_page_view.dart:32` uses it), `GameScreenshotCubit` and its state/DI registration,
  `game_screenshot_entity.dart`, `screenshot.dart`, `screenshot_response_model.dart`, and
  `ImageRouteView`'s route registration in `auto_route_config.dart` [2.7-AC30].
- **The run ships unwired** [2.7-AC32]. No existing file gains a reference to any new component.
  Do not add a call site to `games_screen.dart`, `task_detail_screen.dart`,
  `detail_top_header.dart` or `detail_mid_section.dart`.
- **Imports**: SDK, then package (flutter → third-party → project), then relative only for
  `part`/`generated/l10n.dart`; each group blank-line separated and alphabetised. Prefer package
  imports over relative ones.
- **Ten criteria are verified by inspection, not by a test** — [2.7-AC9], [2.7-AC10],
  [2.7-AC11], [2.7-AC18], [2.7-AC20], [2.7-AC26], [2.7-AC27], [2.7-AC29], [2.7-AC32],
  [2.7-AC34]. Do not write a test for any of them; satisfying them is a property of the code.
- **Test discipline**: `test/widget/components/` paths, `context_chip_test.dart` and
  `stat_pill_test.dart` as the shape, no comments inside tests, no `Completer`, no fake image
  bytes, no arbitrary delays, no golden test, no dimension/position assertion. Every colour
  assertion names a token via `AppColorTokens.dark.<token>`. Every finder is scoped with
  `find.descendant` under the component under test — see `tdd.md`'s "Finder discipline" for the
  exact finder per assertion.
- Do not edit `.claude/skills/flutter-widgets/SKILL.md`'s catalogue or rule text; it is outside
  the allowlist and has been a gate decision every time.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make tests pass. Do
not add packages to `pubspec.yaml` or touch files outside the allowlist — escalate instead.

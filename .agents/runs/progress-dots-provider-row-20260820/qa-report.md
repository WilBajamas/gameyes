# QA Report
Source: Week 2 task briefs items 1.8, 1.9 (combined run)
Date: 2026-08-21

Overall result: PASS — pending manual checks

QA cycle 2 of 2. Verified the cumulative state of `cf6d4d8` + `29a516d` + `495a27f`
on `claude/questloggd-stage-2-resume-ikpjd6`. The cycle 1 defect is fixed and no
other dimension assertion survives in either test file.

## Manual verification required

1.8-AC12 — Open the welcome flow, both pages — expect page one to show a 22-wide
active dot then a 5-wide inactive dot, page two the reverse, at the same left
alignment, same 6px gap, and same gap to the headline as before the run. Swipe
forward and back, including a partial drag held mid-swipe, and confirm the dots
track the page exactly as they do today.

1.9-AC12 — Open the sign-in screen — expect tapping either row to start that
provider's sign-in; while in flight both rows ignore taps and only the tapped
provider's row shows the busy indicator; on failure the inline error still renders
below the rows and both rows remain tappable for a retry.

ALL-AC4 — Compare the two welcome pages and the sign-in screen against the
pre-run build — expect no visible difference in size, colour, position, spacing
or state anywhere. Pay particular attention to the sign-in row labels, which must
still render at 70% ink, and to the 10px gap between the two rows.

## Static analysis
Status: PASS
Errors: NONE

`flutter analyze`: 33 issues — 0 errors, 2 warnings, 31 info. Identical to the
recorded baseline (0 errors, 2 warnings, 31 info). Both warnings are the
pre-existing `unused_element` / `unused_element_parameter` pair in
`lib/features/tracker/presentation/screens/task_detail_screen.dart`, outside this
run. No issue of any severity is attributed to an allowlisted file.

No `build_runner` step: neither new file is annotated and neither new test
declares `@GenerateMocks`, per `task-brief.md` and `tdd.md ## Out of scope`. No
generation checkpoint exists in this run, so no staleness risk.

## Test results
Status: PASS
Tests run: 277  |  Passed: 267  |  Failed: 10

Testing mode: `smoke`. Result `+267 -10` against the Phase 0 baseline of
`+259 -10`, plus the 8 net new tests this run kept after the Phase 4B trim.

The 10 failures are exactly the recorded pre-existing set, in the three recorded
files and no others:
- `test/repository/tracker/tracker_repository_test.dart` — 4
- `test/cubit/game_detail/game_detail_cubit_test.dart` — 3
- `test/cubit/games/games_bloc_test.dart` — 3

No new failure. Both non-allowlisted guard files pass untouched:
`test/widget/onboarding/welcome_screen_test.dart` (including
`keeps the first page dot active while a drag is held`) and
`test/widget/auth/auth_screen_test.dart`.

## Scope check
Status: PASS

`git diff --name-only edee15f..495a27f` across the three Dev commits touches only
allowlisted paths:
- `lib/widgets/progress_dots.dart` (new)
- `lib/widgets/action_row.dart` (new, recorded by git as a rename from
  `lib/features/auth/presentation/widgets/provider_action_button.dart`, which
  confirms the required deletion)
- `lib/features/onboarding/presentation/widgets/welcome_container.dart`
- `lib/features/auth/presentation/screens/auth_screen.dart`
- `.claude/skills/flutter-widgets/SKILL.md`
- `test/widget/components/progress_dots_test.dart`
- `test/widget/components/action_row_test.dart`

Nothing outside the allowlist. `git status --short` is clean — no uncommitted
change. The `.claude/pipeline/rules/execution.md`,
`.claude/skills/flutter-widget-test/SKILL.md`, `.agents/handover.md` and run-folder
edits present on the branch belong to orchestrator/human pipeline commits, not to
any Dev commit, and are not a Dev scope violation.

## Cycle 1 defect — verified fixed
`test/widget/components/action_row_test.dart`, inside
`'shows the busy indicator only while loading'`: the line
`expect(tester.getSize(find.byType(ActionRow)).height, 52);` is deleted in
`495a27f` and nothing else in that commit. A scan of both test files for
`getSize`, `getTopLeft`, `getRect`, `getCenter`, `BorderRadius`, `constraints`,
`width`, `height` and `matchesGoldenFile` returns only the two harness setup
widths (`width: 80` and `width: 400` in `_buildSubject` and the narrow-parent
test), which are pumped constraints, not assertions. No dimension, gap, radius or
position is measured anywhere. No golden test exists.

## Acceptance criteria

### 1.8 — Progress dots
1.8-AC1: PASS — `lib/widgets/progress_dots.dart:4` `class ProgressDots` with a
`const` constructor at :5, file and class names agree, private `_Dot` helper in
the same file at :31, no alias or `hide` at the call site
(`welcome_container.dart:4`).
1.8-AC2: PASS — `progress_dots.dart:15-16` `final int count; final int
activeIndex;`, both required at :7-8 with no default. The file imports only
`material.dart` and `core/utils/extensions.dart` (:1-2) — no onboarding import,
no `WelcomeStep`, no 2 anywhere.
1.8-AC3: PASS — `progress_dots.dart:23-26` `List.generate(count, (index) =>
_Dot(active: index == activeIndex))`; exactly one index matches. Test
`renders the requested number of dots` and
`fills the active dot with ink and inactive dots with ink12`.
1.8-AC4: PASS — `progress_dots.dart:40-41` `width: active ? 22 : 5, height: 5`;
:44 `BorderRadius.circular(tokens.radius.pill)`; :22 `spacing: 6` on the `Row`,
which is interior-only with no leading or trailing gap. None is a constructor
parameter (:5-13). The 5px odd dimension is the recorded exception in
`tdd.md ## Decisions carried forward` item 1 — not flagged.
1.8-AC5: PASS — `progress_dots.dart:43` `active ? tokens.color.ink :
tokens.color.ink12`. Test `fills the active dot with ink and inactive dots with
ink12` asserts both against the resolved tokens, not literals.
1.8-AC6: PASS — `progress_dots.dart:21` `mainAxisSize: MainAxisSize.min`; no
`Expanded`, no `double.infinity`, no `Center`/`Align`/`Padding`/`Transform` in
the file. Every dot is `height: 5` (:41), so the row is 5px tall.
1.8-AC7: PASS — the tree is `Row` → `Container`s only; no `Text`, bar, track or
string in the file. Test `shows no text and no tap handler`.
1.8-AC8: PASS — no `onTap`/`onDotPressed` parameter (:5-13), no
`GestureDetector`/`InkWell`/`InkResponse` in the file. Test
`shows no text and no tap handler`.
1.8-AC9: PASS — plain `Container` at :39, not `AnimatedContainer`; no
`AnimatedSwitcher`, `TweenAnimationBuilder`, `Duration` or curve anywhere in the
file.
1.8-AC10: PASS — `progress_dots.dart:9-13`, two `assert`s in the `const`
constructor's initialiser list: `count >= 1` and `activeIndex >= 0 && activeIndex
< count`. Test `fails in debug when the active index is out of range`.
1.8-AC11: PASS — `welcome_container.dart:58` is the single
`ProgressDots(count: 2, activeIndex: isFirstStep ? 0 : 1)`, mapping first step →
0 correctly via the existing `isFirstStep` local at :31. The inline two-`Container`
`Row` is gone and no second dot row remains. `git show cf6d4d8` touches only that
`Row` in this file — hero height and shortfall (:37-41), scroll paddings (:45-52),
the 22/18px gap (:59), headline, body and actions (:60-72) are unchanged.
`WelcomeStep` still lives in the onboarding feature and `WelcomeContainer` still
takes it (:18).
1.8-AC12: MANUAL — see the manual checklist above. Code-level evidence is
consistent (the mapping at `welcome_container.dart:58` and the untouched, passing
`welcome_screen_test.dart`, whose `_countDots` helper still asserts one 22-wide
and one 5-wide dot per page and whose
`keeps the first page dot active while a drag is held` covers partial drags), but
the "renders exactly as before" comparison needs a device.

### 1.9 — Provider / list row
1.9-AC1: PASS — `lib/widgets/action_row.dart:5` `class ActionRow`, `const`
constructor at :6, file and class names agree, no alias needed at
`auth_screen.dart:11`. `lib/features/auth/presentation/widgets/provider_action_button.dart`
no longer exists (directory listing shows only `legal_footer.dart`), git records
the file as renamed into `lib/widgets/action_row.dart`, and `auth_screen.dart:14`
declares only `part '../widgets/legal_footer.dart';` — no orphaned part, no
`@Deprecated` shim.
1.9-AC2: PASS — `action_row.dart:17-23`, all seven inputs are constructor
parameters: `label`, `markAsset`, `fill`, `enabled`, `loading`, `loadingLabel`,
`onPressed`, all required (:8-14). The file imports only `material.dart`,
`extensions.dart` and `button_press_scale.dart` (:1-3) — no `SignInProvider`, no
cubit or state type, no `S.current`, no hardcoded provider name or asset path.
1.9-AC3: PASS — `action_row.dart:35-37` `SizedBox(height: 52, width:
double.infinity)`; :38-42 a single `DecoratedBox` with `color: fill` and
`borderRadius: BorderRadius.circular(tokens.radius.sm)` — no gradient, border,
outline, boxShadow or elevation anywhere in the file.
1.9-AC4: PASS — `action_row.dart:46-51` `Image.asset(markAsset, width: 20,
height: 20, ...)`, required and unconditional; :52 `const SizedBox(width: 10)`;
:44 `mainAxisAlignment: MainAxisAlignment.center` centres the mark+label pair as
a group, and the label sits in a loose `Flexible` (:53) rather than `Expanded`,
so the mark is not pushed to the row's edge. Neither 20 nor 10 is a constructor
parameter.
1.9-AC5: PASS — `action_row.dart:56-58`
`tokens.typography.body.style.copyWith(color: tokens.color.ink70)`: the `body`
token (16/400) with its colour resolved explicitly rather than inherited from the
ambient `DefaultTextStyle`. :59-60 `maxLines: 1, overflow:
TextOverflow.ellipsis`. Read per `tdd.md ## Decisions carried forward` item 3 and
the Phase 3 deviation approval recorded in
`orchestrator-state.md ## Deviation approvals` — `ink70`, not the criterion's
literal `ink`, because `ink` would visibly brighten both shipped rows and breach
[ALL-AC4]. No locally declared `TextStyle`, family or weight. Test
`shows the label on one line ellipsised in a narrow parent`, which also asserts
`tester.takeException()` is null at an 80px width.
1.9-AC6: PASS — the drawn row is exactly `height: 52` (:36) and the
`GestureDetector` inside `ButtonPressScale` uses `HitTestBehavior.opaque`
(`button_press_scale.dart:28`) over that same 52px box, so the hit region equals
the drawn row and clears 44px. No padding grows the row: the only padding in
`ButtonPressScale` (:44) applies solely while focused.
1.9-AC7: PASS — `action_row.dart:31-34`, `IgnorePointer(ignoring: !enabled)`
wraps the tappable subtree, and the opaque hit behaviour means the fill between
the mark and the label is tappable too. Disabled changes no colour or opacity —
`fill` (:40) and the label style (:56-58) are unconditional, and there is no
`Opacity` or ternary on any visual property. Tests
`calls onPressed once per tap when enabled` (asserts exactly 1) and
`calls nothing when disabled`.
1.9-AC8: PASS — `action_row.dart:63-72`, the `if (loading) ...[]` collection-if
adds a `const SizedBox(width: 10)` and a `SizedBox.square(dimension: 16)` holding
a `CircularProgressIndicator(strokeWidth: 2, semanticsLabel: loadingLabel)` after
the label; when not loading neither node is built at all. The row's height (:36)
and fill (:40) are outside the conditional, and the label (:53-61) renders in both
states. `loadingLabel` is caller-supplied — no hardcoded string. Test
`shows the busy indicator only while loading`, which pumps both states and asserts
the label is still found while busy.
1.9-AC9: PASS — preserved by reusing `ButtonPressScale` (`action_row.dart:33`)
rather than re-deriving it: `button_press_scale.dart:33-36` scales to 0.97 on
press with `tokens.motion.resolve(context, tokens.motion.stateChange)`, which is
the token path that honours reduced motion, and :30-32 releases on both tap-up
and tap-cancel; :38-42 draws the `tokens.color.green` focus ring. No scale value
or duration is declared inside `ActionRow`.
1.9-AC10: PASS — `action_row.dart:28-30` `Semantics(button: true, enabled:
enabled, ...)` is the outermost node and the only semantics node added; the mark's
`semanticLabel` (:50) merges into it rather than competing. Nothing new is
announced by the promotion.
1.9-AC11: PASS — `auth_screen.dart:67-76` Discord first with
`tokens.color.accentIndigo` and `assets/icons/discord-logo.png`, :78-87 Google
second with `tokens.color.surfaceRaised` and `assets/icons/google-logo.png`; both
marks are 20px via `action_row.dart:48-49`; labels remain
`S.current.continue_with_discord` / `S.current.continue_with_google` unchanged;
the 10px gap between the rows stays in the screen's `Column`
(`auth_screen.dart:77`), not in the widget. Arguments and order are identical to
the pre-run call sites — the only rename is `assetPath:` → `markAsset:`.
1.9-AC12: MANUAL — see the manual checklist above. Code-level evidence is
consistent (`auth_screen.dart:71` `enabled: !loading` locks both rows while any
sign-in is in flight; :72 and :83 scope `loading:` to
`state.activeProvider`, so only the tapped row spins; :88-91 still renders
`_InlineSignInError` on `SignInStatus.failed`, after which `loading` returns false
and both rows re-enable), and `auth_screen_test.dart` passes untouched, but the
end-to-end flow needs a device.

### ALL — standing rules
ALL-AC1: PASS — neither file has an outer `Padding`, `Margin`, `Container`
margin or `Spacer` around its content, and neither constructor takes an
`EdgeInsets`, `padding`, `margin`, `gap` or spacing parameter
(`progress_dots.dart:5-13`, `action_row.dart:6-15`). The 6px inter-dot gap
(`progress_dots.dart:22`) and the row's interior 10px gaps
(`action_row.dart:52`, :64) are the components' own anatomy, which the criterion
exempts. The 10px between the two auth rows stays in the caller's column
(`auth_screen.dart:77`).
ALL-AC2: PASS — every visual value in both files reads through `context.tokens`:
`tokens.color.ink` / `ink12` / `radius.pill` (`progress_dots.dart:43-44`),
`tokens.radius.sm` / `typography.body.style` / `color.ink70`
(`action_row.dart:41`, :56-57). No `Theme.of(context)`, no `ColorScheme`, no
`Colors.*` or hex literal, no local font family, weight or `Duration` in either
file. The only literals are the dimensions tech-ac states explicitly (22, 5, 6,
52, 20, 10, 16, stroke 2).
ALL-AC3: PASS — no `CustomPaint`, `CustomPainter`, dash constant or `Border` in
either file. Every surface is a fill: `BoxDecoration(color: ...)` at
`progress_dots.dart:42-45` and `action_row.dart:39-42`.
ALL-AC4: MANUAL — see the manual checklist above. Everything checkable
statically holds: `welcome_container.dart` changed only its dot `Row`,
`auth_screen.dart` changed only the two class names and the `assetPath:` →
`markAsset:` rename, the label colour is deliberately pinned to the `ink70` it
already resolves to, and `Flexible` is loose so a label that fits keeps its
natural size. The visual comparison itself still requires a device.
ALL-AC5: PASS — no user-facing string in either widget file; `label` and
`loadingLabel` arrive from the caller (`action_row.dart:17`, :22) and
`ProgressDots` holds no string at all. `git diff --name-only` over the three Dev
commits shows no `lib/l10n/intl_en.arb`, no `intl_zh.arb` and no
`generated/l10n.dart`.
ALL-AC6: PASS — `pubspec.yaml` is absent from the Dev diff, so no dependency was
added. `flutter analyze` reports 0 errors / 2 warnings / 31 info, identical to the
recorded baseline, with nothing attributed to an allowlisted file — including the
`button_press_scale.dart` import removal from `auth_screen.dart` that would
otherwise have added an `unused_import`.
ALL-AC7: PASS — `.claude/skills/flutter-widgets/SKILL.md` gains exactly two rows
in the reusable-widget catalogue, one per component, each describing what the
component actually is and each ending in "adds no spacing of its own", matching
the `ZoneLabel` / `StatusChip` / `StatPill` style. `git diff` on that file shows
two pure additions and no deletion or modification of an existing row.
ALL-AC8: PASS — both components have a dedicated test file and every behaviour
the criterion names is covered at a level the `flutter-widget-test` skill allows.
The dimension, gap, radius and position clauses (1.8's "22×5 and 5×5", "6px gap",
"row hugging its content"; 1.9's "52px height and full width", "sm radius", "20px
mark", "centred as a pair") were deliberately dropped at the Phase 4B review and
in `495a27f`, per that skill's "do not test dimensions — the criterion is the
contract, the test is not where it gets enforced". They are carried as the manual
checks above instead, which is the sanctioned route, not a coverage gap.
`test/widget/onboarding/welcome_screen_test.dart` and
`test/widget/auth/auth_screen_test.dart` both still pass untouched — no existing
test was deleted, skipped or weakened. No golden test and no `matchesGoldenFile`
anywhere in the run.

## Architectural compliance
Status: PASS

Checked against `tdd.md`, the `flutter-widgets` skill and the
`flutter-widget-test` skill.

FAILs: NONE
- `tdd.md` — class names, file paths and structure match the design exactly:
  `ProgressDots` + private `_Dot` in `lib/widgets/progress_dots.dart`, `ActionRow`
  in `lib/widgets/action_row.dart`, both stateless, both `const`. The
  `Semantics` → `IgnorePointer` → `ButtonPressScale` → `SizedBox` → `DecoratedBox`
  → `Row` tree is the one the design specifies, moved intact. No unlisted package;
  both new files import only `material.dart`, the project extensions and (for
  `ActionRow`) the existing `ButtonPressScale`. Presentation layer only — no data,
  domain, state or localisation file is touched.
- `flutter-widgets` — no comments in either widget file (the Phase 4B fix holds);
  categorical names with no `default` prefix; `const` constructors; extracted UI
  is a widget class, never a function or getter; no `Theme.of(context)`; no
  dashed or custom-painted edge; no outer spacing. The two apparent deviations are
  both recorded and approved, so neither is a violation here: the odd 5px dot
  dimension against the even-dimension rule
  (`tdd.md ## Decisions carried forward` item 1, and tech-ac's "Assumptions"), and
  `Flexible` over `Expanded` (the skill's own hug-content exception, flagged in
  `tdd.md` and approved at Phase 3 per
  `orchestrator-state.md ## Deviation approvals`).
- `flutter-widget-test` — each test in both files was checked independently
  against the review checklist. All eight are behaviour-named, have setup
  proportional to the behaviour, and assert observable outcomes. No assertion
  measures a dimension, gap, radius or position after `495a27f`. The one styling
  assertion (`fills the active dot with ink and inactive dots with ink12`) carries
  meaning — it distinguishes the active state from the inactive one — and names
  design tokens rather than hex literals, which is exactly the case the skill
  permits. Neither file contains a completer, fake image bytes, a manual builder
  invocation, an arbitrary delay, a zone or a swallowed error. Both are at or
  below the length of the `context_chip_test.dart` / `stat_pill_test.dart`
  reference files.
- `'shows no text and no tap handler'` in `progress_dots_test.dart` is retained
  per the human's ruling at the cycle 1 gate: [ALL-AC8] names it explicitly and
  the criterion wins over the skill's general discouragement of negative
  structural assertions. Not a defect and not a warning.

WARNINGs: NONE outstanding for this run. The three raised in cycle 1 were noted
by the human and closed without action: `progress_dots_test.dart` counting raw
`Container`s (`_Dot` is private and `tdd.md ## Reuse decisions` pins `Container`
deliberately so `welcome_screen_test.dart` needs no edit), the duplicated `Text`
constructor arguments in `action_row_test.dart`, and the four pre-existing
comments in `welcome_container.dart` (that file is allowlisted only for the dot
`Row` swap, so the comments are a later run's item, not this one's).

## Escalation required
NONE

Three manual checks (1.8-AC12, 1.9-AC12, ALL-AC4) remain open and need a device.
No agent can close them; they are a human gate, not a defect.

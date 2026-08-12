# QA Report
Source: Week 2 task brief item 1.2 · `system-foundation-specs.md` §3.2/§3.3 · `tech-ac.md`
Date: 2026-08-12

Overall result: PASS — pending manual checks

## Manual verification required

[1.2-AC6] — Render `StatusChip(status: LibraryStatus.backlog, variant: StatusChipVariant.onMedia)`
as a `Stack` overlay on a cover image (any screen, or a scratch harness) — expect the
blur to stop exactly at the pill outline with no soft halo bleeding past the capsule's
rounded edge onto the surrounding art. Structure is proven correct
(`lib/widgets/glass_surface_widget.dart:21-25` clips the `BackdropFilter` inside a
`ClipRRect` at the same `borderRadius`), but `BackdropFilter` edge-clipping is a render
behaviour a widget test cannot observe, and this is the criterion's own named failure
case. The chip ships unplaced, so nothing in the app exercises this yet.

[1.2-AC18] — Place the chip in a `Row`/`SizedBox` narrower than its intrinsic width
(e.g. 60px, status `wishlist`, count `12`) — expect the label to stay on one line and
ellipsise, the dot to stay a perfect 7px circle (not an ellipse), and the count to render
in full. No test covers the constrained-width case; [1.2-AC20] did not require one.

## Static analysis

Status: PASS
Errors: NONE

`dart run build_runner build --delete-conflicting-outputs` — wrote 52 outputs, `git status`
clean afterwards, so no generated file is stale and no generated output drifted from its
source.

`flutter analyze` — 34 issues: 0 errors, 2 warnings, 32 info. Identical to the recorded
`Analyzer baseline: 0 errors, 2 warnings, 32 info`. Zero issues of any severity are
attributed to an allowlisted file — `status_chip.dart`, `library_status.dart`,
`app_color_tokens.dart`, `status_chip_test.dart` and `app_tokens_test.dart` produce no
diagnostic at all. Both warnings are pre-existing, in
`lib/features/tracker/presentation/screens/task_detail_screen.dart` (out of scope).

## Test results

Status: PASS
Testing mode: smoke
Tests run: 252  |  Passed: 241  |  Failed: 11

Allowlisted test files, run in isolation:
`flutter test test/widget/components/status_chip_test.dart test/widget/theme/app_tokens_test.dart`
— 49/49 passed.

Full suite: +241 -11 against a `Test baseline` of +228 -11. All 11 failures are exactly
the recorded pre-existing set, name for name — `tracker_repository_test.dart` (4),
`game_detail_cubit_test.dart` (3), `games_bloc_test.dart` (3), `widget_test.dart` (1).
No new failure, no regression. No golden test and no `matchesGoldenFile` anywhere in the
new test file.

## Acceptance criteria

[1.2-AC1]: PASS — `lib/widgets/status_chip.dart:18` `class StatusChip extends StatelessWidget`,
global placement, categorical name, no `default` prefix, `const` constructor at :19, private
`_StatusDot` in the same file at :107, plain `Padding`/`Row`/`Text`/`Container`/`DecoratedBox`,
no new package in `pubspec.yaml`. No Widget-returning function or getter — `content` at :58 is
a local variable inside `build`, the same shape `zone_label.dart` uses.

[1.2-AC2]: PASS — `lib/core/enums/library_status.dart:1`, a bare six-value enum with no
fields, methods or imports. `StatusChip.status` is typed `LibraryStatus`
(`status_chip.dart:26`), so no string and no seventh value is representable. Both switches
(:36, :45) are exhaustive with no `default:`.

[1.2-AC3]: PASS — one `Row` at `status_chip.dart:60` with a fixed child order: `_StatusDot`,
`Flexible(Text label)`, conditional count `Text`. Order is not branched on status anywhere;
status only selects a token. Test `'should render each status dot in its token colour when
rendering the six statuses'` loops all six through the same tree.

[1.2-AC4]: PASS — `status_chip.dart:87` `BorderRadius.circular(context.tokens.radius.pill)`,
the single radius value, applied to both the `GlassSurface` path (:92) and the `DecoratedBox`
path (:100). Test `'should render the pill radius on the capsule in both variants'`.

[1.2-AC5]: PASS — `StatusChipVariant` carries `dotSize` only (`status_chip.dart:9-16`,
`onMedia(dotSize: 6)` / `list(dotSize: 7)`). The widget body branches on `variant` in exactly
one place, :89, and that branch selects a fill. Interior padding (:59), gap (:62), label style
(:71) and count style (:79) are variant-independent. Test `'should render a 6px dot on media
and a 7px dot in a list'`.

[1.2-AC6]: MANUAL (structure PASS) — list + tinted takes `statusToken.fill`, which is `_ink08`
for all five tinted statuses (`app_color_tokens.dart:145,150,155,160,165`), flat, with no
`GlassSurface`; on-media + tinted takes `colors.glass42` inside `GlassSurface`
(`status_chip.dart:89-95`). Tests `'should fill the capsule with 8% ink when a tinted status
renders in the list variant'`, `'should render no blur when a tinted status renders in the
list variant'` and `'should fill the capsule with 42% black behind a blur in the on-media
variant'`. Visual blur confinement — see the manual checklist above.

[1.2-AC7]: PASS — **the flagged trap is correctly avoided.** `status_chip.dart:65` reads
`color: filled ? colors.ink : statusToken.color` — the filled case never reads the status
token's own `color`, which for `playing` is `_accentIndigo` on an `_accentIndigo` fill
(`app_color_tokens.dart:138-142`), i.e. the invisible indigo-on-indigo dot. The label is
unconditionally `colors.ink` (:71). Capsule takes `statusToken.fill` = indigo via the flat
branch (:99). `filled` derives from `StatusTreatment.filled` (:54), which only `playing`
carries, so no second status can render filled. Test `'should fill the capsule with indigo
when the status is playing'` asserts the dot is `colors.ink`, and the six-status loop test
asserts `colors.ink` (not `tokenColorFor(playing)`) for `playing` specifically — the
regression is pinned in two places.

[1.2-AC8]: PASS — the widget file contains no `Color(0x…)`, no `Colors.*` and no
`Color.fromRGBO`; every colour arrives via `context.tokens.color` (:32). Token mapping
verified against `app_color_tokens.dart:143-167`: backlog `_ink55`, completed
`_accentMagenta`, on hold `_statusViolet`, wishlist `_accentLinkCyan`, dropped
`Color.fromRGBO(255,255,255,0.28)`. No status token was added or duplicated.

[1.2-AC9]: PASS — `status_chip.dart:70-71` `pill.format(label)` with
`pill.style.copyWith(color: colors.ink)`. `format` uppercases when the token says so
(`app_type_tokens.dart:14`), and `pill` is `uppercase: true` (:123) with `fontSize: 11`,
`FontWeight.w500`, `letterSpacing: 0.88` (= 11 × .08em) at :116-124. No literal font value
in the widget. Test `'should render the label uppercase in the pill token style when
rendering'` finds `'BACKLOG'` and asserts size, weight, letter-spacing and `colors.ink`.

[1.2-AC10]: PASS — `status_chip.dart:45-52`, all six labels resolved from `S.current.*`
inside the widget. No string literal in the file other than the count's `'$count'`
interpolation (:78), which is a number, not copy. No `label`/`text` constructor parameter
exists (:26-28).

[1.2-AC11]: PASS — `"backlog"` and `"dropped"` added to both `lib/l10n/intl_en.arb:87-88`
and `lib/l10n/intl_zh.arb:87-88`, positioned next to `onHold`. `playing`, `completed`,
`onHold`, `wishlist` already existed (en/zh line 32 and 153) and are reused, not duplicated.
The generated accessors are present and derived cleanly — `lib/generated/l10n.dart` gained
exactly the two getters, `messages_en.dart`/`messages_zh.dart` exactly one lookup entry
each, 14 inserted lines total across the three files with zero incidental churn, confirming
regeneration from source rather than hand-editing.

[1.2-AC12]: PASS — `count` is `final int?` (`status_chip.dart:28`), guarded by
`if (count != null)` (:76) — a null check, not a truthiness or `> 0` check, so `0` renders.
It sits inside the same capsule, after the label, and is emitted verbatim as `'$count'`
(:78) with no formatting, rounding or abbreviation. Tests `'should render the count after
the label when a count is supplied'` and `'should render the count when the count is zero'`.

[1.2-AC13]: PASS — `status_chip.dart:79-81` `filled ? colors.ink : colors.ink55`. Contrast
computed against each capsule's own fill over `canvas` `#23272A` at 11px, WCAG AA floor 4.5:1:
tinted count `ink55` on `ink08` = **4.80:1** (pass); filled count full ink on indigo `#5865F2`
= **4.61:1** (pass); label full ink on `ink08` = 11.77:1. The criterion's named failure case,
55% ink over indigo, would be **2.48:1** and is exactly what the `filled` branch prevents.
Tests `'should render the count after the label when a count is supplied'` (`ink55`) and
`'should render full ink on the count when the status is playing'` (`ink`).

[1.2-AC14]: PASS — the collection-`if` at `status_chip.dart:76` emits no widget at all when
`count` is null; there is no placeholder, no `SizedBox`, no separator. `Row(spacing: 6)`
gaps only between rendered children, so no trailing gap survives. `mainAxisSize: MainAxisSize.min`
(:61) shrinks the capsule to dot + label. Test `'should render no count when none is
supplied'` asserts exactly one `Text` descendant.

[1.2-AC15]: PASS — **checked independently of `tdd.md`, against the `flutter-widgets` skill's
standing "No spacing of its own" convention.** The widget's outermost node on both paths is
the capsule itself (`GlassSurface` at :90 or `DecoratedBox` at :97) — no `Padding`, `Margin`,
`SizedBox`, `Center` or spacer wraps it. The one `EdgeInsets` in the file (:59) is the child
of the capsule, so it is interior anatomy, which the convention explicitly permits. The
constructor exposes `status`, `variant`, `count` only (:19-24) — no `padding`, `margin`,
`EdgeInsets` or gap parameter reintroduces spacing through the API. Inter-child separation
uses `Row(spacing: 6)` (:62), the flex gap §1.3 requires, not margins between siblings. Test
`'should add no spacing around the capsule when rendering'` asserts `chipSize == capsuleSize`
and that no `Padding` ancestor sits between the chip and its capsule.

[1.2-AC16]: PASS — `MainAxisSize.min` (:61) with no `Expanded`, no `width`/`height`, no
`SizedBox` and no `ConstrainedBox` on the chip. `Flexible` (:68) is `FlexFit.loose` by
default, so it caps the label rather than forcing expansion; `DecoratedBox` and
`GlassSurface`'s `ColoredBox` both size to their child. The chip therefore shrink-wraps in
both axes under the loose constraints a `Row` or `Stack` overlay gives it.

[1.2-AC17]: PASS — the file contains no `onTap`, `InkWell`, `GestureDetector`,
`InkResponse`, `MouseRegion` or callback parameter of any kind, and no minimum-size
constraint padding it toward a 44px hit target (contrast `zone_label.dart:54-55`, which does
use one for its genuinely tappable link).

[1.2-AC18]: MANUAL (code correct) — label is `Flexible` + `maxLines: 1` +
`TextOverflow.ellipsis` (:68-74), so it is the only child that yields under pressure; the dot
is a non-flexible `Container` with equal `width`/`height` (:115-118), so it cannot be squeezed
into an ellipse; the count is a plain non-flexible `Text` (:77) and keeps its intrinsic width.
No test exercises the constrained-width path — see the manual checklist above.

[1.2-AC19]: PASS — `status_chip.dart:32,33,87` all read `context.tokens`
(`lib/core/utils/extensions.dart:9`). No `Theme.of(context)` appears in the file, and no
`themeData` call either.

[1.2-AC20]: PASS — `test/widget/components/status_chip_test.dart` covers every enumerated
behaviour: six-status dot colour (:81), Playing indigo fill with white dot (:106), 8% ink
fill across the five tinted statuses in list (:132), no blur in list (:149), 42% black +
blur on media (:163), 6px/7px dot sizing (:181), pill radius both variants (:215), uppercase
pill-token label (:239), count rendering (:257) including `0` (:274) and full ink when filled
(:286), absent count widget (:302), and no outer spacing (:316). 49/49 pass. No golden test,
no `matchesGoldenFile`.

[1.2-AC21]: PASS — `.claude/skills/flutter-widgets/SKILL.md:134` adds
`| StatusChip | status_chip.dart | Six-status pill: dot + label + optional count, list or
on-media variant; adds no spacing of its own |`, and the row carries the required
"adds no spacing of its own" note.

## Architectural compliance

Status: PASS

FAILs: NONE

Checked against `tdd.md` — class names (`StatusChip`, `StatusChipVariant`, `_StatusDot`),
file paths, the `LibraryStatus` enum's zero-import purity so week 3's domain model can adopt
it, the `glass42` token wired through constructor / field / `dark` / `copyWith` / `lerp`
(`app_color_tokens.dart:45,86,129,196,231,277`), `GlassSurface` reused rather than a second
`BackdropFilter` written, no package added, no global scope introduced. `tdd.md` design
decision 2 (one interior padding `8/4` for both variants, flagged for the Phase 3 gate) is
implemented as designed. No deviation from `tdd.md` found.

Checked independently against the `flutter-widgets` skill — placement in `lib/widgets/`,
categorical name with no `default` prefix, `const` constructor, private helper in the same
file, plain Flutter widgets, no Widget-returning function or getter, "configurable not
hardcoded", "few comments" (one comment in the widget, and it explains the non-obvious
thing), `const` on the `EdgeInsets` literal, `S.current.*` for every user-facing string,
catalogue row added, no golden test, and the standing **"No spacing of its own"** rule —
all satisfied. Import order is correct: package (flutter → project, alphabetised) then the
relative `../generated/l10n.dart`, matching the documented exception.

Scope verified against git, not against the self-report:
`git diff --name-only 17b5395..dd940a5` less the separate `7f73a31` planning-docs commit
leaves 12 files in commit `dd940a5`, every one of them allowlisted — the three
`lib/generated/` files being generated outputs of the allowlisted `.arb` sources, which the
standing exception permits. Nothing outside the allowlist. No file appears in git that
`diff-summary.md` failed to declare.

WARNINGs:

1. **Bookkeeping gap, orchestrator's to close.** `orchestrator-state.md ## Deviation
   approvals` reads `NONE`, but `diff-summary.md` declares three deviations (the Flutter Intl
   CLI regen, plus the two test-file additions for `S.delegate` and the font warm-up). Human
   approval for this exact SHA is recorded under `## Code review outcomes`, so these are
   approved in substance — the `## Deviation approvals` section simply was not backfilled.
   Not treated as an unapproved deviation and not escalated; the section should be filled in
   so a later reader is not misled.

2. **Doc drift created by the approved regen deviation.**
   `.claude/pipeline/rules/generation.md:41-43` and the `flutter-widgets` skill's
   Localisation section both still state the `S` class comes from the Flutter Intl **IDE
   plugin**, "no CLI". `.agents/handover.md` gotcha #1 and this run's approved practice say
   otherwise. Two sources of truth now contradict each other, and the next Dev Agent will
   read the rule file, not this run folder. Worth one line of correction in a future run —
   out of scope here, and QA does not edit.

3. **Uncommitted pipeline artifacts.** `git status` shows
   `.agents/runs/status-chip-20260812/orchestrator-state.md` modified and `diff-summary.md`
   untracked. Both are pipeline artifacts, not source, so this is not a scope violation — but
   per `CLAUDE.md` these paths are git-tracked like any other file and should be committed.

4. **Comment placement, cosmetic.** The dot-colour explanation sits at
   `status_chip.dart:56-57`, directly above `final content = ...`, while the line it explains
   is :65. It reads as though it annotates the whole `content` block. Content is correct and
   it is the file's only comment; noted, not actionable.

5. **Carried forward from `tdd.md ## Notes`, still open.** `GlassSurface` remains absent
   from the `flutter-widgets` catalogue even though it is a global widget and this run now
   depends on it. No criterion covered it, so it was correctly left alone — the next run that
   edits that table should add the row, or a third agent will rebuild the blur by hand.

## Escalation required

NONE

# QA Report
Source: `tech-ac.md` (run `async-empty-state-20260824`), AC-01–AC-28
Date: 2026-08-25
Commit verified: `61991141ffd10c01a0ddcdb20744bdda13599dfb`

Overall result: PASS — pending manual checks

## Manual verification required

AC-15 — Open Featured, in the state where a countdown game exists but the weekly
releases list is empty (site 4, the card headed "LOOK FURTHER AHEAD" below the
countdown card) — tap **Browse games** — expect the home tab bar to move its
active cap to Browse and the Browse tab's own content to appear, with the back
gesture returning to the previous tab rather than to Featured underneath a pushed
page.

AC-16 — Open Featured with no countdown game and no weekly releases (site 5, the
card headed "START A COUNTDOWN") — expect the Right Now section to render the card
in the slot that rendered nothing before, with no section heading above it, and
expect the sections below it to be pushed down but not visually broken. Tap
**Browse games** and expect the same tab switch as AC-15.

AC-14 side effect (human-approved, `orchestrator-state.md ## Deviation approvals`)
— Open Featured with genre preferences selected and the critics grid empty (site 3,
"OPEN UP YOUR GENRES") — tap **Show every pick** — expect exactly one reload and
expect the genre-picker row above the grid to disappear, because
`skipGenrePreferences()` also sets `isSkipped: true`. Confirm the section does not
look broken with the picker gone.

Visual appearance of `EmptyStateCard` at all five sites — expect one raised-surface
card (#2F333C) at r16 with, top to bottom, an optional 44px glyph at ink55, a
capitalised headline at 22/700 in full ink, one wrapping supporting line at
16/1.45/400 in ink70, and one full-width green primary button. Sites 3 and 4 lost
their old fixed heights (160 / 170) and sites 3–5 lost their old surface; check
none of them now overflows or collapses. Site 2's card must have a solid-edged,
undashed appearance.

Site 1 wording — Open the Games grid and apply filters that return nothing — expect
the headline to read "NO RESULTS FOUND". This is the reused `no_results_found` key
that AC-24 mandates, so it is correct as shipped, but it is the one empty state in
the set that still reads as an apology rather than an invitation. Worth a human
eye on whether to raise a follow-up to reword that key.

## Static analysis
Status: PASS
Errors: NONE

`flutter analyze` (Flutter 3.41.4 / Dart 3.11.1): **30 issues — 0 errors, 2 warnings,
28 info**. Recorded `Analyzer baseline` is 33 (0 errors, 2 warnings, 31 info), so the
commit is 3 info issues better, matching what `diff-summary.md` claimed. Both warnings
are the pre-existing `_TaskReminder` / `unused_element_parameter` pair in
`lib/features/tracker/presentation/screens/task_detail_screen.dart:201,204`.

No issue is attributed to any allowlisted file. `lib/widgets/empty_state_card.dart`,
`test/widget/components/empty_state_card_test.dart`, `critics_grid.dart`,
`countdown_releases.dart`, `library_stats.dart` and `games_screen.dart` are all clean.
The four `unnecessary_underscores` infos in `featured_screen.dart:195,270` are
pre-existing — confirmed as `(_, __, ___)` at the same builders in the base SHA
(`2784c02:featured_screen.dart:194`); the line number moved by one only because of
the added import.

Generation: `build_runner` is not involved in this allowlist (no annotated sources).
Localisation currency was verified without mutating the tree: `intl_en.arb` and
`intl_zh.arb` hold identical 167-key sets, all 11 new keys plus the edited
`mark_something_playing` resolve to a getter in `lib/generated/l10n.dart` and to a
message in both `messages_en.dart` and `messages_zh.dart`, and no `→` survives in
either `.arb` or in any generated file.

## Test results
Status: PASS
Tests run: 357  |  Passed: 347  |  Failed: 10

`flutter test`: **+347 -10**, against the recorded `Test baseline` of +343 -10. The 4
new tests land, and the 10 failures are exactly the recorded pre-existing set, file
for file and name for name:
- `test/repository/tracker/tracker_repository_test.dart` (4)
- `test/cubit/game_detail/game_detail_cubit_test.dart` (3)
- `test/cubit/games/games_bloc_test.dart` (3)

No new failure, no regression, nothing weakened or deleted.

**Falsifiability independently re-verified, not inherited.** The project was copied to
a scratch tree and `empty_state_card.dart` mutated there, one mutation at a time, with
`empty_state_card_test.dart` re-run after each; the repository under QA was never
modified. Results:

| Mutation | Caught |
|---|---|
| fill `surfaceRaised` → `ink55` | yes — "fills the card with the surfaceRaised token" |
| `onPressed: onActionPressed` → `() {}` | yes — "calls the action callback once when the action is tapped" |
| `headline.toUpperCase()` → `headline` | yes — the content test |
| glyph rendered unconditionally | yes — "hides the glyph when none is supplied" |
| supporting line replaced with `""` | yes — the content test |
| **glyph never rendered at all** | **no — suite still passes** (see WARNINGs) |

The tests assert on what the component actually draws; item 2.7's pass-by-construction
failure is not repeated here. `tdd.md`'s caveated single-match `ColoredBox` finder also
holds in reality, not just in the claim: `tester.widget<ColoredBox>(...)` resolves
without a "found multiple widgets" throw, so `PrimaryButton`'s `Container`/
`ButtonPressScale` chain contributes none, exactly as `tdd.md` predicted from the SDK
source. Both finders in the file are scoped with `find.descendant(of:
find.byType(EmptyStateCard))`, so neither can drift onto something else.

## Coverage gaps (coverage mode only)
N/A — testing mode is `smoke`.

## Acceptance criteria

AC-01: PASS — `lib/widgets/empty_state_card.dart:6-19`; `headline`, `supportingLine`,
`actionLabel`, `onActionPressed` all `required`, `glyph` the only optional. No fallback
substitution anywhere in `build`.
AC-02: PASS — `empty_state_card.dart:30` (`color: colors.surfaceRaised`); no `Colors.*`,
no `Color(0x…)`, no `colorScheme.*` in the file (grepped). Asserted by
`empty_state_card_test.dart:77-88` against `AppColorTokens.dark.surfaceRaised`
(#2F333C, `app_color_tokens.dart:108`), and the mutation test above confirms the
assertion bites.
AC-03: PASS — `empty_state_card.dart:28` `BorderRadius.circular(tokens.radius.lg)`; the
only numeric-looking match in the file is the token lookup itself. `lg` = 16
(`app_radius_tokens.dart:37`).
AC-04: PASS — `empty_state_card.dart:39-43`: `headline.toUpperCase()` at render, over
`typography.cardHeading` (22 / w700, `app_type_tokens.dart:75-81`) in `colors.ink`.
`.arb` values are authored normal case (`intl_en.arb`, e.g. `"open_up_your_genres":
"Open up your genres"`). Asserted by `empty_state_card_test.dart:47`
(`find.text('HEADLINE COPY')`). No-op for `intl_zh.arb` as required.
AC-05: PASS — `empty_state_card.dart:45-51`: one `Text`, `typography.body`
(16 / w400 / height 1.45, `app_type_tokens.dart:92-99`) in `colors.ink70`, no `maxLines`
and no `overflow` on it.
AC-06: PASS — `empty_state_card.dart:52`, one `PrimaryButton`, unconditional (not inside
an `if`). The file defines no button styling — `PrimaryButton` owns the fill, radius and
press behaviour (`lib/widgets/primary_button.dart:20-38`). The only other tappable in the
subtree is that button. One tap → one call, asserted at
`empty_state_card_test.dart:53-63`.
AC-07: PASS — `empty_state_card.dart:27` the outermost widget is the `ClipRRect`, with
nothing wrapping it. The only `Padding` (`:31`) is inside the `ColoredBox`, which is the
card's own interior. No padding/margin/gap constructor parameter (`:15-19`).
AC-08: PASS — no `Border`, `BorderStyle`, `CustomPaint` or `CustomPainter` anywhere in
the file (grepped; the only `Border` substring hit is `borderRadius`).
AC-09: PASS — no `height:` in the file. `Column(mainAxisSize: MainAxisSize.min)`
(`:33-34`) gives intrinsic height; full width comes from `PrimaryButton`'s
`width: double.infinity` (`primary_button.dart:26`) forcing the `Column` to the offered
maxWidth. Rendered result is in the manual list.
AC-10: PASS — zero `//` or `///` in `empty_state_card.dart` (grepped; the file is 59
lines, all code).
AC-11: PASS — `games_screen.dart:86-102`; the `GamesStatus.empty` branch now builds
`EmptyStateCard` and its `onActionPressed` dispatches `context.read<GamesBloc>().add(const
GamesFetched())` — the same event and the same const instance the branch dispatched
before the change (see the diff of `6199114`).
AC-12: PASS — `ErrorRetryWidget` appears exactly twice in `games_screen.dart`, at `:69`
and `:79`, both the `failed` branches, both untouched by the commit. `git diff --stat
2784c02..6199114 -- lib/widgets/error_retry_widget.dart` is empty, so the widget is
byte-identical.
AC-13: PASS — `library_stats.dart:271-278` renders `EmptyStateCard` with
`Icons.play_circle_outline_rounded` (the glyph it used before) and `onMarkNowPlaying`
unchanged. `grep -rn "_DashedBorderPainter\|BorderStyle.none" lib/` returns nothing —
the class and all 122 of its lines are gone, no dangling reference, and the analyzer
reports no `unused_element` for the file.
AC-14: PASS — `critics_grid.dart:156` wires the action to `onSkipPressed`, which
`featured_screen.dart:282-284` binds to `CriticsGridCubit.skipGenrePreferences()`.
That method (`critics_grid_cubit.dart:98-114`) calls `_saveGenrePreferencesUseCase([],
isSkipped: true)` exactly once and `loadCriticsGrid()` exactly once on success, with no
loop over the selection and no early return when the selection is empty — so one tap is
one save and one reload at any selection size, including zero. The additional
`isSkipped: true` effect is the approved deviation recorded in `orchestrator-state.md
## Deviation approvals` (2026-08-24T22:20), not a defect; it is on the manual list for
visual confirmation only.
AC-15: MANUAL — code is correct: `countdown_releases.dart:92`
`onActionPressed: () => AutoTabsRouter.of(context).setActiveIndex(3)`, evaluated inside
the callback, on the `BuildContext` `_buildReleasesList` already receives; Browse is
child index 3 of the home tabs router. The criterion's failure case is stated in
observable terms (where the tab bar's active cap ends up), which no test in this project
can assert — see the manual checklist.
AC-16: MANUAL — code is correct: `featured_screen.dart:200-208`; the same `if`, the same
early `return`, `EmptyStateCard` in the exact slot `const SizedBox.shrink()` occupied,
with no heading and no wrapper added, and `setActiveIndex(3)` as the action. Whether the
now non-zero-height section reads correctly against the sections below it is a visual
call — see the manual checklist.
AC-17: PASS — no `+` line in the commit introduces `router.push` or `BrowseRoute`
(`git show 6199114 | grep '^+.*\(router.push\|BrowseRoute\)'` returns nothing). The
pre-existing `context.router.push(GameDetailRoute(...))` at `featured_screen.dart:286`
is untouched and is not a Browse destination.
AC-18: PASS — structurally guaranteed and re-verified on disk.
`featured_screen.dart` `_RightNowSection` early-returns site 5 at `:200-208` **above**
the `CountdownReleasesWidget` construction at `:211`, so site 4 is only reachable when
site 5's condition was false, i.e. `countdownGame != null`. `EmptyStateCard(` appears
exactly once in `countdown_releases.dart` and exactly once in `featured_screen.dart`
(`tdd.md`'s own checkable form). The `Skeletonizer` construction passes
`GameLoadingWidgetData.weeklyReleases`, a `List.generate(5, …)`
(`game_loading_data.dart:25`), so the loading path cannot reach site 4's branch either.
AC-19: PASS — `grep -rn "No critic reviews found\|No releases in this period" lib/`
returns nothing. All five branches now build `EmptyStateCard` from `S.current.*`
(`games_screen.dart:90-96`, `library_stats.dart:271-277`, `critics_grid.dart:151-157`,
`countdown_releases.dart:88-93`, `featured_screen.dart:201-207`). No `Container`+`Text`
improvisation survives at any of the five.
AC-20: PASS — no `+`/`-` line in the whole commit touches `Skeletonizer`, `shimmer`,
`GameLoadingWidgetData` or `isLoading` (grepped across `git show 6199114 -- lib`). The
only `ErrorRetryWidget` line touched is its removal from the *empty* branch, which
AC-11 requires; `GamesStatus.failed`, `GamesNextPageStatus.failed` and the critics /
countdown `failed` branches have no diff hunk. See WARNING 2 for the unrelated
formatting churn in `critics_grid.dart`, which lands outside every loading and failed
branch.
AC-21: PASS — `git diff --stat 2784c02..6199114 -- "*tracker_tasks_section.dart"
"*tracker_game_detail_section.dart"` is empty. Neither file appears in
`git diff --name-only` for the commit. Both tracker empty states are genuinely
untouched.
AC-22: PASS — parsed both `.arb` files: identical 167-key sets, zero en-only and zero
zh-only keys. The 11 new keys cover site 1 line + label, site 2 line, and headline +
line + label for sites 3, 4 and 5 (`browse_games` shared by 4 and 5 per `tdd.md`). No
English value survives in `intl_zh.arb` — every new Chinese value is translated. All 11
plus the edited key are present in `l10n.dart`, `messages_en.dart` and `messages_zh.dart`.
AC-23: PASS — all 11 new values in both locales inspected: no "sorry", no apology, no
"not found" / "nothing here" framing, no `!`, no emoji, no dingbat. Site 1's action is
`search_again` ("Search again"), not `retry`, as the criterion demands. (The reused
`no_results_found` headline at site 1 is mandated by AC-24 and excluded from AC-23 by
`tech-ac.md ## Out of scope`'s tone note — flagged in the manual section as a possible
follow-up, not as a defect here.)
AC-24: PASS — `no_results_found`, `no_game_in_progress` and `mark_something_playing` are
reused (`games_screen.dart:91`, `library_stats.dart:272`, `library_stats.dart:275`),
with no near-duplicate key added for any of the three. The trailing `→` is removed from
`mark_something_playing` in both locales, and no `→` survives in either `.arb` file or
in any generated file.
AC-25: PASS — `.claude/skills/flutter-widgets/SKILL.md:218-223`, the empty-state note
now names `EmptyStateCard` and states its fixed anatomy; `:172` adds the catalogue row
beside `HairlineGroup`; the `text: S.current.no_results_found` sample is removed from
the "Error + retry" block at `:181-187`. The three surviving `ErrorRetryWidget` mentions
(`:129`, `:181`, `:184`) are all genuine error-state guidance, so the
empty-state workaround no longer appears anywhere in the skill.
`project-conventions.md` is not in the commit.
AC-26: PASS — `empty_state_card_test.dart`: headline / line / label at `:42-51`, the
single-tap callback at `:53-63`, the fill at `:77-88` naming
`AppColorTokens.dark.surfaceRaised`, never a hex. No `matchesGoldenFile`, no
`tester.getSize`, no `getTopLeft`, no assertion on any dimension, gap, radius or
position anywhere in the file.
AC-27: PASS — `tdd.md` grepped and found no existing test referencing the replaced
branches, and I re-confirmed: no test file mentions `ErrorRetryWidget`,
`LibraryStatsWidget`, `CriticsGridWidget`, `CountdownReleasesWidget` or
`GamesStatus.empty`, so there was nothing to update. Nothing was deleted or weakened —
the suite gained 4 tests and lost none (+343 → +347, failures unchanged at 10).
AC-28: PASS — 30 issues vs. the baseline 33, 0 errors both sides, no new issue in any
file this run touched, and no `unused_element` from the deleted `_DashedBorderPainter`.

## Architectural compliance
Status: PASS

Checked against `tdd.md`, `flutter-widgets`, and `flutter-widget-test`.

`tdd.md`: no deviation. Class name, file path, parameter list, structure
(`ClipRRect` → `ColoredBox` → `Padding` → `Column`), every token choice, all five call
sites, the eleven key names and English values, and the shared `browse_games` key all
match the design exactly. No new package. No state, domain or data layer touched, as
designed. No constructor parameter was added to `CriticsGridWidget`,
`CountdownReleasesWidget` or `LibraryStatsWidget` — verified in the diff — so the
AC-20 constraint that drove the whole design holds.

`flutter-widgets`: compliant. Global widget in `lib/widgets/`, categorical name, no
`default` prefix, `StatelessWidget` with a `const` constructor, zero comments, no
spacing of its own (interior padding inside its own surface is explicitly allowed), no
dashed or custom-painted edge, all self-written dimensions even (24 padding, 12 column
gap, 44 glyph), sibling separation via `Column`'s flex `spacing` rather than
`SizedBox`es, tokens read through `context.tokens` with no `Theme.of` and no literal.
The hand-rolled `headline.toUpperCase()` rather than `AppTextToken.format()` is not a
convention breach: `cardHeading.uppercase` is `false` and flipping it would change
`countdown_card.dart`'s game title, so `tdd.md` settled this route deliberately and a
caps sibling token stays a recorded foundations follow-up.

`flutter-widget-test`: compliant on every checklist item — behaviour-named tests,
proportional setup matching `context_chip_test.dart` / `stat_pill_test.dart` (same
`MaterialApp` + `buildDarkTheme()` + `S.delegate` harness, no completers, no fake image
bytes, no delays, no manual builder invocation), assertions on visible text and on a
callback rather than on structure, no dimension or position assertion, and the one
colour assertion names a design token. Importing `app_color_tokens.dart` is not a reach
into internals — it is the established harness import in nine other component tests
(`hairline_group_test.dart`, `error_notice_test.dart`, `status_chip_test.dart` and
others). Both finders are scoped to `find.byType(EmptyStateCard)`, so neither can match
something else. The colour assertion sits slightly against the skill's default
preference for not asserting styling, but AC-26 makes it a stated contract and it names
the token, which is the form the skill prescribes when one is warranted.

FAILs: NONE

WARNINGs:
1. **The glyph's positive case is untested.** `hides the glyph when none is supplied`
   asserts only absence, and `buildSubject`'s `glyph` parameter is never passed a
   non-null value anywhere in the file. Mutating the widget so the glyph is *never*
   rendered leaves the whole suite green (verified). The named behaviour itself is
   protected — rendering the glyph unconditionally does fail the test — and the shape
   is the one `flutter-widget-test` itself gives as a good example, so this is not a
   skill violation, and no criterion requires the positive case. But sites 2–5 all pass
   a glyph, and nothing would catch it disappearing. One extra
   `expect(find.byIcon(...), findsOneWidget)` test would close it. Not blocking.
2. **Unplanned formatting churn in `critics_grid.dart`.** Five hunks in the commit are
   pure `dart format` rewrapping of code the plan never asked Dev to touch — the
   'Personalize Your Discover Feed' header at `:86`, the genre-chip padding and border
   at `:113-127`, and the `Card`/`Container` chain in the non-empty grid item builder
   at `:176-206`. None lands inside a loading or a failed branch, so AC-20 is not
   breached and no behaviour changes, but it enlarges the review surface of an
   otherwise tightly-scoped diff.
3. **Full width is inherited, not declared.** `EmptyStateCard` sets no width; it fills
   its parent only because `PrimaryButton` sets `width: double.infinity`. Correct
   today and AC-09-compliant, but if the action control is ever swapped the card will
   silently start shrink-wrapping. Worth a line in the catalogue entry rather than a
   change now.

## Scope check
Status: PASS

`git diff --name-only 2784c02..61991141` matches the `task-brief.md` allowlist exactly.
Every source and test path in the commit is allowlisted; `lib/generated/l10n.dart`,
`lib/generated/intl/messages_en.dart` and `messages_zh.dart` are generated outputs whose
annotated sources (the two `.arb` files) are allowlisted, which the execution rules
permit. Nothing outside the allowlist was touched — in particular
`lib/widgets/error_retry_widget.dart`, the two tracker sections, `project-conventions.md`
and `pubspec.yaml` are all absent from the diff. `diff-summary.md`'s file list is
accurate: git shows no file it failed to declare.

The only non-source paths in the base-to-commit range are this run's own planning
artifacts under `.agents/runs/async-empty-state-20260824/`, carried in by the ancestor
`docs:` commit `5284489`; `04f46ef` and `c076ea4` add only `diff-summary.md` and the
`orchestrator-state.md` phase update. None is implementation. The working tree is clean
as of this report — no uncommitted change.

## Escalation required
NONE

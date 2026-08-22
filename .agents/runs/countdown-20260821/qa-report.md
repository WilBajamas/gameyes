# QA Report
Source: `.agents/week-2-task-briefs.md` Stage 2 item 2.3 — Countdown + Countdown tile
Date: 2026-08-22

Overall result: PASS — pending manual checks

Verified at `d44666a` (working tree clean). Source code is identical to the approved
Dev commit `5c2266b`; the two commits after it (`d44666a`, `07b2431`) touch run
documents only.

## Manual verification required

C1/C9 — Featured screen, countdown game with a future release date — three digit blocks
on 8% ink at radius `xs`, min width 40, `DAYS`/`HRS`/`MIN` caps at ink55 directly under
each block, no seconds group.

C1 — Featured screen, countdown game more than 99 days out — the day block shows all
digits (e.g. `120`) and grows past its 40px minimum rather than clipping or wrapping.

C2 — Featured screen, counting state — the two colons sit on the digit baseline, not the
caption baseline, at both figure sizes.

C4 — Featured screen, countdown game whose release date is today — the released label
only: no digits, no colons, no unit labels, neutral ink, no green and no magenta.

C5 — Featured screen, countdown game with no resolvable release date — the caller's
release-date text if IGDB supplied one, otherwise the caps unannounced-date label; no
`00` placeholders, no empty box.

C6 — Same duration rendered through `CountdownCard` and `CountdownTile` side by side —
identical digits, labels and colon count; only surface treatment and type scale differ
(22px figure on the card, 30px on the tile).

C7 — Featured screen with a screen reader (TalkBack / VoiceOver) on the countdown —
one announcement reading the remaining time as a sentence, not three loose numbers.
Released and unannounced states announce their own single label.

C8 — Featured screen countdown card — flat `#2F333C` fill at radius `lg`, no gradient,
no elevation shadow, and no cover thumbnail (the 80×110 art is deliberately gone).

C10 — Featured screen, countdown game that IS on the user's wishlist vs. one that is
not — cyan reason line with an outline bookmark glyph in the first case; one neutral
ink55 line with no glyph and no cyan in the second. Requires a real wishlist entry for
the selected game to reach the true branch.

C11 — Not reachable in the app this run: `featured` passes no `onRemind`, so the Remind
control renders nowhere. When a caller is wired, check the ink12 `radius.xs` control,
its outline bell glyph, that it is never green, and that its hit target measures at
least 44px.

C13 — `CountdownTile` in a harness over a photographic background — glass 32% fill with
the blur visibly applied at radius `xs`, colons at the 40% countdown-colon token rather
than ink12, caps micro labels beneath. The tile ships unwired, so this needs a scratch
host or a device preview.

C15 — Featured screen, every countdown state — no emoji, no dingbat and no exclamation
mark in any rendered string, in both `en` and `zh`.

C17/C18 — Featured screen, all four section paths: (a) success with a countdown game and
releases; (b) the `Skeletonizer` loading path with placeholder data; (c) the countdown
failure path; (d) no countdown game and no releases, where the section must still
collapse. Expect the out-this-week rail, its heading and its "n games" count to look and
behave exactly as before the rewire.

Phase 4B (outside C1–C22) — Featured screen, out-this-week rail with a game already in
the local library — the owned marker is now `LibraryTick`'s 20×20 indigo circle with a
12px ink check, replacing the old green circle with a white check. The green→indigo
change is the intent; confirm it reads correctly over cover art.

l10n — Featured screen with the device set to Chinese — the nine new keys render at their
token sizes without clipping (`发售日期待公布` and `距发售还有 … 分钟` are the longest), and
the caps type tokens degrade harmlessly on CJK, which has no uppercase form.

## Static analysis
Status: PASS
Errors: NONE

32 issues (0 errors, 2 warnings, 30 info) against a baseline of 33 (0 errors, 2 warnings,
31 info). Both warnings are the pre-existing `_TaskReminder` pair at
`lib/features/tracker/presentation/screens/task_detail_screen.dart:201` and `:204`;
neither is in an allowlisted file. The net drop of one info is the deprecated
`withOpacity` usage that left with the deleted inline builders.

Three info diagnostics are new, all `lines_longer_than_80_chars` in the two new test
files, all from long behaviour-statement test names:
`test/repository/featured/featured_repository_test.dart:35` and `:53`,
`test/widget/components/countdown_test.dart:147`. Info-level, in test files, and the
total still sits below baseline — advisory, not a finding.

Generated output is current, not stale. `dart run build_runner build
--delete-conflicting-outputs` and `dart pub global run intl_utils:generate` were both
re-run at HEAD and left the working tree clean, so the freezed entity, the freezed state
field and the nine new `.arb` keys are all reflected in committed generated code.

## Test results
Status: PASS
Tests run: 314  |  Passed: 304  |  Failed: 10

Baseline was +288 -10; the run adds 16 passing tests and no failures. All ten failures are
the recorded pre-existing set, confirmed by name:
`test/repository/tracker/tracker_repository_test.dart` (4),
`test/cubit/game_detail/game_detail_cubit_test.dart` (3),
`test/cubit/games/games_bloc_test.dart` (3). None is in an allowlisted file.

The four allowlisted test files run green in isolation: 23 tests, all passing.

## Acceptance criteria

C1: PASS — `countdown_digit_row.dart:53-55` computes `inDays`, `inHours % 24`,
`inMinutes % 60`, each `padLeft(2, '0')`, which pads but never truncates, so a day count
above 99 renders in full; `:67-83` renders exactly three units in days/hours/minutes
order; the `microLabel` token carries `uppercase: true`
(`app_type_tokens.dart:180-188`), producing `DAYS`/`HRS`/`MIN`. No seconds group exists
anywhere in the module. Test: `shows three padded unit groups and two colons for a
supplied duration`. Pixel layout routed to manual.

C2: PASS — the colon is a sibling `Text(':')` in the row
(`countdown_digit_row.dart:72, 78, 147-163`), never a member of a block and never an
icon; the row is only built in the counting branch, so the released and unknown-date
returns at `:38-51` carry no colon. Tests: the same test asserts `findsNWidgets(2)`;
three further tests assert `findsNothing` in the other states.

C3: PASS — no `StatefulWidget`, `initState`, `Timer`, `Ticker`, `AnimationController` or
implicitly-animated widget appears anywhere under `lib/widgets/countdown/` (verified by
grep across all four files); every class in the module is a `StatelessWidget`
(`countdown_digit_row.dart:7, 90, 147`, `countdown_card.dart:7, 66, 108`,
`countdown_tile.dart:5`). Test: `leaves the digits unchanged after time elapses without a
rebuild` pumps five minutes and would also fail the harness on a pending timer at
teardown.

C4: PASS — `countdown_digit_row.dart:45-51` returns a single `pill` label at
`tokens.color.ink` when `time <= Duration.zero`, with no digits, colons or unit labels.
Released is derived from the input duration, never from a caller flag, so the two forms
cannot disagree. Test: `shows the released label and no digits when the duration has run
out`. Colour rendering routed to manual.

C5: PASS — `countdown_digit_row.dart:24-43` returns the caller's `releaseDateText` when
one was given and the caps unannounced label otherwise; the null check is on a local, so
there is no dereference and no zero substitution. Tests: `shows the caller release-date
text when no duration is given` and `shows the unannounced-date label when neither
duration nor date is given`.

C6: PASS — both forms delegate to the same `CountdownDigitRow`
(`countdown_card.dart:52-56`, `countdown_tile.dart:17-21`); no time-state logic exists in
either form, so neither can drift. The form enum carries only `figureSize`,
`blockMinWidth`, `blockPadding` and `isGlass` (`enum/countdown_form.dart:24-27`) —
nothing that could change what the numbers say. Test: `shows the same three unit groups in
the tile form` asserts the tile's output against the card's.

C7: PASS — `countdown_digit_row.dart:57-60` wraps the counting row in
`Semantics(container: true, excludeSemantics: true, label:
S.current.countdown_time_remaining(days, hours, minutes))`, so the three figures are
announced as one string. The released and unannounced states are each a single `Text`
whose content is its own label. Screen-reader confirmation routed to manual.

C8: PASS — `countdown_card.dart:33-37` draws a `DecoratedBox` with a flat
`tokens.color.surfaceRaised` fill at `BorderRadius.circular(tokens.radius.lg)`.
`surfaceRaised` is `Color(0xFF2F333C)` at `app_color_tokens.dart:106`. No `Card`, no
`elevation`, no gradient of any kind anywhere in the module (grep for `Gradient` and
`elevation` returns nothing).

C9: PASS — `countdown_digit_row.dart:127-133` fills the card block with
`tokens.color.ink08` at `radius.xs`; `:158-159` gives the colon `tokens.color.ink12` in
the non-glass form; `:135-139` puts the caps `microLabel` at `tokens.color.ink55`
directly beneath its own block inside the same `Column`. No border is drawn on the block.
Exact steps routed to manual.

C10: PASS — `countdown_card.dart:75-84` returns one neutral line at
`tokens.color.ink55` when the flag is false; `:86-103` returns the cyan branch, whose
`zoneLink` token already carries `accentLinkCyan` (`app_type_tokens.dart:108-115`), paired
with the outline `Icons.bookmark_outline` glyph. Exactly one reason line renders in
either branch, and there is no badge chip. Tests: `shows the cyan wishlist reason line
when the game is wishlisted` (asserting the token, not a hex) and `shows the neutral
reason line, and no cyan, when it is not wishlisted`.

C11: PASS — `countdown_card.dart:57` renders `_RemindAction` only under
`if (remind != null)`, so no dead affordance is possible; `:120-126` gives it
`BoxConstraints(minHeight: 44)`, an `ink12` fill at `radius.xs` and no green; `:131` pairs
the label with the outline `Icons.notifications_none` glyph; `:119` invokes the handler
once per tap. Tests: `hides the remind action when no handler is supplied` and `calls
onRemind and does not open the game when the remind action is tapped`. Appearance and hit
target routed to manual, and note the control is unreachable in the app this run because
`featured` supplies no handler.

C12: PASS — `countdown_card.dart:30-32` puts a
`GestureDetector(behavior: HitTestBehavior.opaque)` around the whole card calling
`onOpen`; the Remind action's own inner detector (`:117-119`) wins the gesture arena, so a
Remind tap does not reach the outer one. Tests: `calls onOpen once when the card is
tapped` asserts a count of exactly 1, and `calls onRemind and does not open the game when
the remind action is tapped` asserts remind 1 / open 0.

C13: PASS — `countdown_digit_row.dart:121-126` routes the glass form through
`GlassSurface(fill: tokens.color.glass32, ...)`, and `GlassSurface`
(`lib/widgets/glass_surface_widget.dart:21-27`) applies the `glassBlur` effect token
through a `BackdropFilter` — no second blur implementation and no translucent-white
substitute. `:159` gives the tile's colons `tokens.color.countdownColon`, the 40% token
(`app_color_tokens.dart:130`), not `ink12`. Visual confirmation routed to manual.

C14: PASS — `countdown_tile.dart:17-21` returns `CountdownDigitRow` and nothing else, and
its constructor (`:6-10`) exposes only `remaining` and `releaseDateText`. There is no
parameter through which a title, reason line, surface or handler could arrive, so the
criterion holds by construction rather than by branch.

C15: PASS — a scripted scan of all four module files and the reworked
`countdown_releases.dart` found no character above U+2000 and no exclamation mark other
than Dart's null-assertion operator at `countdown_releases.dart:133`. The same scan over
the nine new keys in both `.arb` files found none. All five named violations are gone:
`countdown_releases.dart` no longer contains `_buildCountdownCard`,
`_buildCelebrationState`, `_buildTimerBlocks` or `_buildTimeBox`, and the file is 176
lines with no emoji, dingbat or `!` copy.

C16: PASS — grep for `Colors.`, `0xFF`, `Gradient`, `elevation` and `Theme.of` across
`lib/widgets/countdown/` and `countdown_releases.dart` returns nothing; every colour comes
through `context.tokens`. The `Colors.amber` and `Colors.green` occurrences the criterion
named are gone with the deleted builders, and the Phase 4B revision removed the last
`Colors.green`/`Colors.white` pair (the rail's hand-rolled owned marker) in favour of
`LibraryTick` at `countdown_releases.dart:151`.

C17: PASS — `countdown_releases.dart:45-51` renders `CountdownCard` in the countdown slot.
All four inline builders and the line-7 `// TODO: Refactor this` are deleted, not
deprecated: the file contains no `//` comment at all and no `_build` method other than
`_buildReleasesList`, which C18 requires to stay. No parallel countdown implementation
exists — `CountdownDigitRow` is the only digit-rendering code in the repository.

C18: PASS by code — the diff against the base SHA shows the out-this-week heading, the
"n games" count, `_buildReleasesList`, the empty "No releases in this period" box and the
section's collapse condition (`if (game != null)`) unchanged apart from the owned-marker
swap; `featured_screen.dart` changed only the two `isReleaseDay` → `isWishlisted`
argument lines, leaving the `Skeletonizer`, failure and empty paths untouched. Behaviour
on screen routed to manual.

C19: PASS — the data path changed in exactly one respect. `GetOutThisWeekUseCase` is
untouched (not in the diff at all). In `countdown_releases_cubit.dart`, `_startTimer`
(`:88-93`), `_updateCountdown` (`:95-131`), `_getReleaseDate` (`:133-150`), both
`Failure` branches (`:70-84`) and `close()` (`:152-156`) are semantically unchanged; the
single `Timer.periodic(const Duration(seconds: 60), ...)` at `:90` is still the only timer
in the feature and is still cancelled in `close()`. No second timer exists anywhere. No
datasource call was added — `getWishlistedGames()` is still called once per load at
`featured_repository_impl.dart:62`. `CountdownReleasesState` gained one field and nothing
else.

C20: PASS — `featured_repository_impl.dart:63-68` turns the already-fetched wishlisted
ids into a `Set<int>`; both selection branches return through the one private helper
`_countdownFrom` (`:83` and `:99`), which computes `wishlistIds.contains(game.id)` at
`:114-119`. A fallback selection therefore cannot hardcode `true` without deleting the
helper call. The no-selection path returns
`const CountdownGameEntity(game: null, isWishlisted: false)` (`:101-103`), and the `catch`
branch keeps its previous shape (`:104-109`). `GetCountdownGameUseCase`
(`get_countdown_game_use_case.dart:11-12`) is a single delegation and derives nothing.
Tests: `should return isWishlisted true when the selected game id is in the wishlisted
set`, `should return isWishlisted false when selection falls through to the global
fallback`, `should pass the repository wishlist flag through unchanged`.

C21: PASS — `countdown_releases_state.dart:16` declares `@Default(false) bool
isWishlisted`. The cubit has exactly one success `emit`
(`countdown_releases_cubit.dart:58-66`) and it sets `countdownGame: countdown.game` and
`isWishlisted: countdown.isWishlisted` in the same `copyWith`; every load reaches it,
including the reload `_updateCountdown` triggers at `:129` when the release date has
passed — so a reselected game always arrives with its own flag and cannot inherit the
previous one. The tick's three `copyWith` calls (`:98, 104, 118, 122, 127`) name only
`durationRemaining` and `isReleaseDay`, so the flag is untouched by construction. Neither
`Failure` branch names it. The stale-flag guarantee is additionally structural at the
entity: `CountdownGameEntity` declares both fields `required`
(`countdown_game_entity.dart:9-10`), so no construction site can omit the flag. Tests:
`sets isWishlisted from the use case result on a successful load`, `leaves isWishlisted
false when the load fails`, and `initial state is correct` covers the default.

C22: PASS — `CountdownCard`'s constructor (`countdown_card.dart:8-16`) takes no
library-membership parameter of any kind, so a card that reads `localLibraryGameIds` is
unrepresentable rather than merely absent. `_ReasonLine` branches on `isWishlisted` alone
(`:75`) and owns both strings, so cases (b) and (c) resolve to the identical
`S.current.most_anticipated` line — one rendered state, byte-identical, with no cyan and
no wishlist-asserting copy. `countdown_releases.dart:47` forwards the state's flag
verbatim, and `localLibraryGameIds` survives only inside `_buildReleasesList` at `:112`
for the rail's owned marker, exactly as the criterion allows. There is no third reason
line.

## Coverage gaps (coverage mode only)
N/A — testing mode is `smoke`.

## Architectural compliance
Status: PASS

FAILs: NONE

WARNINGs:
- Formatter churn beyond the stated edit scope, in allowlisted files.
  `featured_repository_impl.dart`, `countdown_releases_cubit.dart` and
  `featured_repository.dart` carry `dart format` reflows on lines the plan said to leave
  alone (`saveGenrePreferences`'s signature, three `debugPrint` calls, `queryWindow`'s
  arithmetic, `_updateCountdown`'s two-field `copyWith` calls). The task brief asked for
  `_updateCountdown`'s `copyWith` calls "byte-identical"; they are semantically identical
  but reflowed onto single lines. No field was added, removed or reordered in any of
  them, and no behaviour changes. Reported so the intent of that constraint is not
  quietly eroded next run.
- `_ReasonLine` uses `Flexible` inside a `Row(mainAxisSize: MainAxisSize.min)`
  (`countdown_card.dart:86-102`). This is the `flutter-widgets` hug-content exception, and
  `Expanded` would be wrong here — but `tdd.md` flagged only the digit row's use of that
  pattern, not this one. Correct as written; noting it because the skill asks the
  trade-off to be flagged rather than taken silently.
- `getCountdownGame` still hand-rolls try/catch and constructs
  `Failure(const ErrorType.unknown())` directly rather than going through
  `BaseRepositoryMixin.fetchData`, and `CountdownReleasesCubit` unwraps `Result` with
  nested `switch` statements rather than the exhaustive `switch` expression the
  `flutter-state` skill specifies. Both are pre-existing shapes this run deliberately
  preserved (`tdd.md`: "the `catch` branch keeps its current shape"), not something Dev
  introduced. Raise separately.
- `test/features/featured/**` holds two unit test files off the project's layer-based
  convention (`test/use_case/`, `test/cubit/`). Tech Lead updated them in place rather
  than relocating, called out in `tdd.md ## Out of scope` as deliberate churn avoidance.
  Advisory only.
- `Colors.green` survives in `lib/features/featured/presentation/widgets/critics_grid.dart`
  and `library_stats.dart`, both on the same screen as this card. Both files are outside
  this run's allowlist and deferred to item 2.1's follow-up and item 2.8 respectively.
  Advisory only, not a defect of this run.

Checked and clean: file paths and class names match `tdd.md` exactly
(`CountdownForm`, `CountdownDigitRow`, `_CountdownUnit`, `_CountdownColon`,
`CountdownCard`, `_ReasonLine`, `_RemindAction`, `CountdownTile`,
`CountdownGameEntity`); no package was added to `pubspec.yaml`; the module's public
surface is only `CountdownCard` and `CountdownTile`, with `CountdownDigitRow` and
`CountdownForm` imported nowhere outside the folder; `ButtonPressScale` is correctly not
reused; the entity depends only on `freezed` and `GameEntity` and carries no JSON; the use
case has one public method returning `Future<Result<T>>` and takes the repository
interface; the cubit stays screen-scoped in `FeaturedScreen`'s provider; every dimension
the module writes is even (6, 8, 12, 14, 16, 22, 30, 40, 44, 52); icons are outline-only;
no widget file in the module or `countdown_releases.dart` contains a single comment; all
user-facing strings go through `S.current` and exist in both `.arb` files.

Widget tests were checked file-by-file against `flutter-widget-test`'s review checklist.
All eleven are behaviour-named, understandable without comments, act through the public
UI, and assert observable outcomes. No assertion measures a dimension, gap, radius, offset
or position. The single styling assertion names its token
(`AppColorTokens.dark.accentLinkCyan`, `countdown_test.dart:114`) and carries the wishlist
meaning that justifies it. No `matchesGoldenFile`, no completers, no fake image bytes, no
manual builder invocation, no arbitrary delays. The one `pump(Duration)` at `:170` is the
elapsed-time case the skill sanctions, because C3's snapshot contract is exactly what it
protects. At eleven tests the file is longer than `stat_pill_test.dart`, which the skill
allows with a reason — the reason is recorded in `task-brief.md ## Testing mode` and the
count was reached by clustering behaviours, not by enumerating criteria.

Scope was verified against git, not against `diff-summary.md`'s self-report:
`git diff --name-only 17294fb..5c2266b` lists 25 source and test paths, every one either
on the allowlist or a generated output of an allowlisted source
(`countdown_game_entity.freezed.dart`, `countdown_releases_state.freezed.dart`,
`featured_repository_test.mocks.dart`, `lib/generated/**`). Nothing outside it. The
working tree is clean. Both listed deviations — dropping `isReleaseDay` from the widget
API, and the `intl_utils` l10n regeneration path — have matching lines in
`orchestrator-state.md ## Deviation approvals` and the plan's own step 10.

## Escalation required
NONE

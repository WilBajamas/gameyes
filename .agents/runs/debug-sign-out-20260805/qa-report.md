# QA Report
Source: W1-8.1 — `source-request.md` (Product Owner ticket, 2026-08-05)
Date: 2026-08-05

Overall result: PASS

Verified against base SHA `cd7be4c` through the reviewed tip `0bf661e`
(feature `1ed6c7e` + revision round 1 `0bf661e`, with the pre-authorised
localisation regeneration `914ab26` in between).

## Static analysis

Status: PASS
Errors: NONE

`dart run build_runner build --delete-conflicting-outputs` succeeded and left
the working tree clean (`git status --short` empty), so generated output is
current and the analysis below is not against stale code.

`flutter analyze`: 38 issues — 0 errors, 2 warnings, 36 info. Identical to the
`orchestrator-state.md` baseline (0 / 2 / 36, 38 issues). Zero issues of any
severity are attributable to an allowlisted file; the 2 warnings are the
pre-existing `unused_element` pair in `task_detail_screen.dart` and all 36 info
items sit in files this run did not touch.

The `undefined_getter` errors `diff-summary.md` predicted are gone — the
localisation regeneration resolved them, as recorded below.

## Test results

Status: PASS
Tests run: 201  |  Passed: 188  |  Failed: 13

Allowlisted test files, run in isolation: 12/12 passed.
- `test/cubit/auth/sign_out_cubit_test.dart` — 6/6
- `test/widget/settings/settings_screen_test.dart` — 6/6

Full suite: 188 passed / 13 failed. All 13 failures are the long-documented
pre-existing set, in exactly the 6 baseline files and no others:
`test/repository/tracker/tracker_repository_test.dart` (4),
`test/cubit/game_detail/game_detail_cubit_test.dart` (3),
`test/cubit/games/games_bloc_test.dart` (3),
`test/api/game_detail/game_detail_test.dart` (1),
`test/api/games/games_test.dart` (1), `test/widget_test.dart` (1).

**No new failure, in scope or out.** Passing count is 188 rather than the
expected 186 — two more than forecast, no fewer; the forecast was an estimate
made before the full suite was re-run post-regeneration. Nothing regressed.

## Coverage gaps (coverage mode only)

NONE. Every criterion has both a success and a failure/error path exercised.
Success: cubit `emits [loading, idle] when sign-out succeeds`, widget `shows
nothing and returns to rest when sign-out succeeds`. Failure: cubit `emits
[loading, failed] when sign-out fails`, widget `shows the inline error in the
section when sign-out fails`. Edge cases also covered — in-flight repeat tap,
error-clearing retry, and cubit closed mid-flight.

**On the offline manual-check nuance:** manual check 8 does not reach
`SignOutStatus.failed`, because Supabase discards the local session with no
network and the sign-out genuinely succeeds. That is correct product
behaviour, not a coverage hole. The failure-handling criteria (AC08–AC11) are
covered at both layers by automated tests that inject a `Failure` directly,
which exercises the exact same code path a real backend failure would take —
the cubit switches on `Result<void>` and cannot distinguish the source of a
`Failure`. **I consider this adequate coverage.** Widget-level tests assert the
rendered inline error, the absence of any snackbar or dialog, the survival of
existing screen content, and the error clearing on retry — everything a device
check of that path would have shown. The one thing no test can prove is what
the failure state physically looks like on a real screen; given the inline
error is a byte-for-byte mirror of the already-shipped and already-seen
`_InlineSignInError`, that residual risk is negligible.

## Acceptance criteria

W1-8.1-AC01: PASS — `settings_screen.dart:57-62`, the sliver is built
unconditionally in the slivers list; `sign_out_section.dart:3-24` has no
`kDebugMode`, flavour, `assert` or environment check anywhere in the
construction path (grep-verified across all four feature files). Test: `renders
the sign-out control alongside the existing settings content`.

W1-8.1-AC02: PASS — `sign_out_section.dart:15`,
`onPressed: () => context.read<SignOutCubit>().signOut()` calls straight
through with no intermediate step. Test: `starts one sign-out and shows the
pending state on a single tap` asserts `findsNothing` for both `Dialog` and
`BottomSheet`.

W1-8.1-AC03: PASS — `sign_out_cubit.dart:15`,
`if (state.status == SignOutStatus.loading) return;`, reinforced at the UI by
`IgnorePointer(ignoring: loading)` at `sign_out_section.dart:39`. Tests:
`ignores additional taps while sign-out is in flight` (asserts `callCount == 1`
after two taps) and the widget-level `callCount == 1` assertion.

W1-8.1-AC04: PASS — `sign_out_section.dart:61-67` renders a 16px
`CircularProgressIndicator` beside the label while `loading`;
`sign_out_cubit.dart:26,28` returns to `idle` or `failed` on either outcome, so
the indicator disappears both ways. Test: `starts one sign-out and shows the
pending state on a single tap` (indicator present) and `shows nothing and
returns to rest when sign-out succeeds` (gone). Also confirmed on device by the
human's manual pass.

W1-8.1-AC05: PASS — verified by inspection as requested. Grep across
`sign_out_cubit.dart`, `sign_out_state.dart`, `sign_out_section.dart` and
`settings_screen.dart` for `auto_route|config/route|Navigator|context.router|
AutoRouter|BlocListener` returns exactly one hit: `settings_screen.dart:1`,
`import 'package:auto_route/annotations.dart';` — pre-existing (unchanged in
`git diff`), an annotations-only library carrying `@RoutePage()`, and it
exposes no navigation API. There is no `BlocListener` anywhere in the feature,
so there is no imperative hook through which a route action could occur. Test:
`never performs a route action on success or on failure` asserts `verifyNever`
on the mocked `StackRouter`'s `push`, `replace` and `pop` after both outcomes.

W1-8.1-AC06: PASS — `sign_out_cubit.dart:10,12`, the cubit's sole constructor
dependency is `SignOutUseCase`. No import of `ObserveAuthStatusUseCase`,
`AuthStatusListener`, `AuthRepository` or `authStatusChanges` in any of the
four feature files (grep-verified). DI registration confirms the single
dependency: `service_locator.config.dart:277-279`,
`SignOutCubit(gh<SignOutUseCase>())`.

W1-8.1-AC07: PASS — no `BlocListener`, `ScaffoldMessenger`, `SnackBar`,
`AlertDialog`, `showDialog`, `DefaultSnackbar` or `DefaultAlertDialog` anywhere
in the feature (grep-verified). On success `sign_out_cubit.dart:26` emits the
default idle state, and `sign_out_section.dart:17` renders the error only when
`status == failed`, so success renders nothing extra. Test: `shows nothing and
returns to rest when sign-out succeeds`.

W1-8.1-AC08: PASS — `sign_out_section.dart:17-20`, `_InlineSignOutError` is a
plain child of the section's own `Column`, inside the section's padding,
beneath the button. Test: `shows the inline error in the section when sign-out
fails` asserts the error is present *and* that the pre-existing placeholder
still renders.

W1-8.1-AC09: PASS — same widget tree; the error is a `Row` with an icon and a
`Text` (`sign_out_section.dart:84-98`), not a snackbar, dialog or banner. Test:
the failure test asserts `SnackBar` and `Dialog` both `findsNothing`, and the
`verifyNever` router test covers the no-route-change half.

W1-8.1-AC10: PASS — `sign_out_cubit.dart:24-29` switches exhaustively on
`Result<void>` with explicit `Success` and `Failure` cases and no default, so
every non-success outcome reaches `SignOutStatus.failed`. No `try`/`catch` is
needed because `AuthRepositoryImpl.signOut` is the error boundary and converts
every throw into a `Failure`. The `isClosed` guard at line 22 prevents the one
unhandled exception this path could otherwise raise (emit after close) — test
`emits nothing when the screen is gone before the result arrives`. Failure
path: `emits [loading, failed] when sign-out fails`. See the coverage note
above regarding the offline device check.

W1-8.1-AC11: PASS — `sign_out_cubit.dart:17` emits
`SignOutState(status: loading)` with `error` defaulting to `null`, which clears
any prior failure at the start of every new attempt; the control is re-enabled
because `IgnorePointer` only ignores while `loading`. Tests: `clears the
previous error when a new attempt starts` (cubit) and `clears the inline error
and retries when the control is tapped again` (widget, asserts `callCount ==
2`).

W1-8.1-AC12: PASS — both keys present in both locale files
(`intl_en.arb:24-25`, `intl_zh.arb:24-25`) and both accessors now generated
(`l10n.dart:174,179`, `messages_en.dart:73-74`, `messages_zh.dart:63-64`). Both
user-facing strings resolve through `S.current` (`sign_out_section.dart:58,91`)
— no hard-coded literal in the feature. This criterion was `not fully
verifiable` in `diff-summary.md`; the regeneration resolved it.

W1-8.1-AC13: PASS — `git diff cd7be4c..0bf661e -- settings_screen.dart` shows
only the added imports, the `part` directive, the one new `SliverToBoxAdapter`,
and the two `dart format` line collapses. The app bar (`DefaultSliverAppBar`),
the `ScrollController` wiring, `BouncingScrollPhysics` and the placeholder
sliver are unchanged in content and behaviour. Test: `find.widgetWithText(
Center, 'Settings')` still `findsOneWidget` both at rest and after a failure.

## Architectural compliance

Status: PASS
FAILs: NONE
WARNINGs: NONE

Every class name, file path and layer placement matches `tdd.md`:
`SignOutStatus`/`SignOutState` and `SignOutCubit` at
`lib/features/auth/presentation/blocs/`, `_SignOutSection`/`_SignOutButton`/
`_InlineSignOutError` as a `part` of `settings_screen.dart`. State is
`@freezed sealed` with a status enum and `ErrorType?` — not a bool, not a
`String`. `BlocProvider` + `getIt<SignOutCubit>()` sit at the new sliver, not
the screen root; `BlocBuilder` is inside the section, with `Scaffold`,
`CustomScrollView` and the app bar outside it. All extracted UI is a widget
class, never a `Widget`-returning function. All colour, radius and type values
come from `context.tokens`; no literal colour and no `Theme.of(context)`. The
52px row clears the 44px minimum hit target, and the neutral `surfaceRaised`
fill correctly avoids the destructive `errorStrong` treatment reserved for
removal and deletion. `_InlineSignOutError` mirrors `_InlineSignInError`
exactly, including `color.error` for the icon and `color.errorInk` for the
text. No package added — `pubspec.yaml` is untouched.

## Scope check

Clean. `git diff --name-only cd7be4c..0bf661e` lists 23 paths: 9 are `.agents/`
pipeline docs; the remainder are allowlisted source, allowlisted tests, or
generated output whose annotated source is allowlisted
(`sign_out_state.freezed.dart`, `service_locator.config.dart`,
`settings_screen_test.mocks.dart`, `lib/generated/**`). Nothing outside the
allowlist. `git status --short` is empty — no uncommitted change, before or
after my `build_runner` run. Two commits sit after the reviewed tip
(`495f37b`, `492a710`); both touch only `.agents/` docs, no code.

`orchestrator-state.md ## Deviation approvals` reads NONE, and no deviation in
`diff-summary.md` now requires one: deviation 1 (the pending localisation
regeneration) was resolved rather than accepted, and deviation 2 is a
formatting side effect within an allowlisted file.

## Notes for the record

**Localisation was regenerated from the CLI, not the IDE** (`914ab26`).
`task-brief.md ## Localisation — required manual step` and `handover.md` gotcha
#1 both assumed no CLI existed; `intl_utils` is the same generator the IDE
plugin wraps and `pubspec.yaml` already carries the `flutter_intl:` config it
reads. I verified the output independently: both new accessors generated in
both locales, and the only other change is the removal of 10 dead getters
(`welcome_chip_*`, `welcome_stat_*`, `welcome_countdown_*`,
`welcome_social_proof`) whose `.arb` keys were deleted in item 6.1 — I
re-checked each against `lib/` and `test/` and found zero references. Not a
defect. Worth acting on the standing flag that gotcha #1 is factually wrong.

**Revision round 1** (`0bf661e`) is test-only and scoped rather than weakened:
`find.text('Settings')` matched both the app bar title and the placeholder, so
it became `find.widgetWithText(Center, 'Settings')` — a narrower finder
asserting the same fact. No production file touched; AC13 intact.

**`dart format` collapsed two pre-existing lines** in `settings_screen.dart`
(the `DefaultSliverAppBar` and placeholder sliver constructors). Whitespace
only, behaviour identical — confirmed in the diff. Recorded as deviation 2.

**Manual verification is complete.** The human ran all 8 on-device checks and
all 8 passed, including the four item-8 checks this run existed to unblock.
Carried forward as satisfied; no manual checks remain outstanding.

## Escalation required

NONE

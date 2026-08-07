# Ambiguities Report
Source: `.agents/week-1-task-briefs.md` § "11 — Cleanup [PIPELINE]" (lines 385–429),
checklist items 1–3. Background: `.agents/handover.md` gotcha #2 (line-ending churn).
Source (items 4–5, added 2026-08-07): human instruction expanding this run's scope —
unused-code scan and docs "done"/"completed" cull. No written brief exists for either.
Date: 2026-08-06 (items 1–3), 2026-08-07 (items 4–5)

## CRITICAL (pipeline blocked — requires human decision before proceeding)

CRITICAL-1: REQ-11.4 — `_TaskReminder` is a whole unused widget class, which the
instruction for this item says to flag rather than decide. It is declared at
`lib/features/tracker/presentation/screens/task_detail_screen.dart:201` with its
constructor at `:204`, and its only reference anywhere in the repository is a
commented-out call site at `:88` (`// _TaskReminder(task: task),`). It is also the
whole of the project's 2-warning analyzer baseline: those two warnings sit on exactly
lines 201 and 204 of that file in every recorded QA report, which is what
`unused_element` on an unreferenced private class and its constructor produces. So the
analyzer half of REQ-11.4 has exactly one finding, and it is a decision this item was
explicitly told not to make.
  It also collides with REQ-11.C. AC-4.2 pins the analyzer result to the recorded
  baseline; deleting `_TaskReminder` would take it from 2 warnings to 0, so the two
  criteria cannot both hold and one of them has to give.
  Options:
    (A) Leave `_TaskReminder` and its commented-out call site alone. The 2-warning
        baseline is unchanged, AC-4.2 holds, and the Reminder feature stays parked.
        REQ-11.4 then delivers the constants half only.
    (B) Delete the class and the commented-out call site in this run, and re-record
        the analyzer baseline as 0 warnings in `orchestrator-state.md`. Recovers the
        code from git history if Reminder is ever built.
    (C) Neither now — keep it, but delete the commented-out line at :88 and replace it
        with a note saying Reminder is planned, so the intent is recorded in the file
        rather than inferred from dead code. Baseline unchanged.
  Recommended: (A). It is the option the human's own scoping rule points at ("that's a
    bigger call than this item is meant to authorise"), it is the only one that leaves
    every existing criterion in this run intact, and "is the task-reminder feature
    still planned?" is a product question with no answer available in the repository.
    `tech-ac.md` is written to (A): AC-5.10 makes `_TaskReminder` report-only and Out
    of scope names it, so REQ-11.1–11.3 and REQ-11.5 are unaffected either way, and
    REQ-11.4's constants half can proceed under (A) with no further input.
  Decision needed from: Product Owner

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: The brief says "Create a `.gitattributes` at the repository root", but a
root `.gitattributes` already exists (7 lines, pinning Flutter's generated
plugin-registrant files to LF for the same reason). Assuming "create" means "ensure
the five generated-Dart patterns are present", i.e. append them to the existing file
and leave every existing entry byte-identical. Overwriting would delete a working fix
for the same class of problem and is read as unintended.

ASSUMPTION: Pattern text is taken verbatim from the brief's code block
(`*.g.dart`, `*.freezed.dart`, `*.gr.dart`, `*.config.dart`, `*.mocks.dart`, each
`text eol=lf`). Column alignment of the `text eol=lf` token is cosmetic and not
asserted. Bare `*.x` rather than `**/*.x` is correct — a leading-slash-free git
pattern already matches at any depth.

ASSUMPTION: `.gitattributes` itself is committed with the repository's normal line
endings; the brief specifies endings for the files it names, not for itself.

ASSUMPTION: "Untrack `coverage/lcov.info`" means remove it from the git index only,
leaving the working-tree file on disk (`git rm --cached`). Deleting local coverage
output is not requested and would break nothing but is unnecessary.

ASSUMPTION: The `.gitignore` entry is exactly `coverage/` as stated, appended under a
new comment heading in keeping with the file's existing sectioned style. `coverage/`
is the only coverage path in the tree today (`coverage/lcov.info`).

ASSUMPTION: "Remove the incorrect `envied` TODO" means deleting only the trailing
comment `# TODO: To deprecate this package and use flutter_secure_storage` from the
`envied: ^1.3.4` line in `pubspec.yaml`. The dependency, its version, its section
comment (`# Envied - Privatise file`) and the `envied_generator` dev dependency all
stay. The brief's own reasoning — the two packages solve different problems — is the
justification for deleting the note rather than acting on it.

ASSUMPTION: No replacement comment is written in place of the removed TODO. The brief
asks for removal, not for the rationale to be recorded in `pubspec.yaml`; the
reasoning lives in this run's artifacts.

ASSUMPTION: `git add --renormalize .` is run repo-wide as instructed, but is expected
to alter content only in files matching a `.gitattributes` pattern. Because the brief
forbids a blanket `* text=auto` / `*.dart eol=lf`, any hand-written source file
appearing in the resulting diff is treated as a symptom of an over-broad pattern, not
as an accepted cost. Criterion AC-1.4 makes this verifiable.

ASSUMPTION: Verification of the churn fix uses the brief's own procedure — `git
status` before and after `dart run build_runner build --delete-conflicting-outputs` —
on the run's own machine. The "roughly seventeen files" figure is descriptive; the
criterion is zero generated files reported modified, whatever the file count.

ASSUMPTION: The three fixes are independent and may land in any order within the one
commit. The brief calls them "three unrelated repository-hygiene fixes" and states no
sequencing between them.

--- Added 2026-08-07 with REQ-11.4 and REQ-11.5 ---

ASSUMPTION: "Unused const, variables, and strings" means unused *declarations*, not
unused *values*. A one-off string literal inside a widget is not a candidate; a
declared constant nothing reads is. The inverse job — extracting repeated literals
into new constants — is not requested and is not done.

ASSUMPTION: REQ-11.4's mandatory sweep is the two constants files under `lib/`
(`lib/core/res/const.dart` and `lib/features/onboarding/const.dart`). The instruction
scopes the item to "`lib/` (and constants files specifically)", and every `static const`
in `lib/` outside generated code lives in one of those two. Public declarations
elsewhere in `lib/` are report-only.

ASSUMPTION: `analysis_options.yaml` was checked, as asked. Its `linter.rules` list has
17 entries and names no unused-* rule; unused declarations are nevertheless reported
because they are built-in analyzer diagnostics rather than lints. So the answer to
"may or may not have them enabled at all" is: not enabled by name, and enabled anyway
by default. Assuming this needs no configuration change — the file is out of scope.

ASSUMPTION: The split between what the analyzer catches and what it does not is: it
catches unused **private** declarations and unused imports (`unused_import`,
`unused_field`, `unused_local_variable`, `unused_element`), and it catches nothing at
all about unused **public** declarations, which is every `static const` on every
`*Constants` class in this project. Assuming the grep cross-reference is therefore the
only available method for the constants half, with the limits AC-5.8 names.

ASSUMPTION: The 32 info-level baseline issues are lint infos from the project's own
`linter.rules` (`lines_longer_than_80_chars`, `avoid_redundant_argument_values` and
similar, both cited by name in earlier runs' QA reports), not unused-* diagnostics —
unused-* are warning severity, and the baseline has exactly 2 warnings, both accounted
for by CRITICAL-1. This could not be confirmed by running `flutter analyze` in the BA
session (no shell available to this agent), so AC-5.1 requires Dev to capture and
classify the real output rather than inherit this assumption.

ASSUMPTION: A reference from `test/` counts as a reference. Constants are shared
between production code and its tests, so a test-only use is a real use.

ASSUMPTION: A reference from a file annotated `@Deprecated` counts as a reference. The
two such files (`network_module.dart`, `twitch_auth_interceptor.dart`) are
intentionally-kept reference code and must keep compiling, so the one constant only
they read — `ConfigConstants.igdbBaseUrl` — stays. This reads the instruction's
"excluding anything explicitly `@Deprecated`" as "do not clean up inside those files",
not "treat their contents as invisible when counting references".

ASSUMPTION: A constant named by a `.agents/references/` convention document counts as
referenced even with no code use. `RouteConstants.featured` is the only case:
`project-conventions.md` § "Hero transition pattern" lists it beside `games` and
`tracker` as the `fromScreen` value to use from Featured. Deleting it would either
break a documented convention or require editing a reference doc, and reference docs
are outside this run's write boundary.

ASSUMPTION: The human's `RouteConstants` lead is confirmed. `auto_route_config.dart`
declares every route as a hardcoded literal and reads no constant; only `games`,
`tracker` and `openPaths` are read anywhere (5 call sites total across
`games_screen.dart`, `tracker_screen.dart` and `session_navigator.dart`), and the first
two are read as hero-tag discriminators rather than as routes. Several constants have
additionally drifted from the real paths (`gameDetail` is `'/game_detail'`, the router
uses `'/game-detail'`), so they are wrong as well as unread. Assuming this makes them
safe to delete but does not make the class deletable — six members survive.

ASSUMPTION: The BA-identified removal set is a starting point that Dev re-verifies, not
a specification. Fourteen members were found with zero references outside their own
declaration; they are listed in `tech-ac.md`'s assumptions. AC-5.4's per-member
evidence is the criterion, and Dev may land a different set on that evidence.

ASSUMPTION: REQ-11.5's search terms ("done", "complete"/"completed", "shipped", `✅`,
`- [x]`, strikethrough) are entry points for a human-judgement filter, not removal
triggers. A scan of `.agents/` outside run folders returned 84 hits across 26 files,
and the `.agents/references/` ones are almost entirely the library's own `Completed`
status value or ordinary prose. Assuming the correct outcome for most files is
"nothing removed".

ASSUMPTION: `README.md` was checked, as asked, and contains no finished-task content
at all — it is setup, flavours and build commands. Assuming it ends the run unchanged.

ASSUMPTION: REQ-11.5 removes; it does not rewrite, re-tick or correct. Several docs
statements are now factually stale — `handover.md` still says item 10.1 is "written up
but not started" and its whole `## Next-session prompt` tells the reader to do it,
while `week-1-task-briefs.md` still has `- [ ] Done` unticked for items 10 and 10.1 —
but stale is not the same as finished-task noise, and correcting them is separate work
for whoever owns those documents. Assuming they are left exactly as they are.

ASSUMPTION: `week-1-task-briefs.md`'s `- [x] Done` entries stay. They carry dates, PR
numbers, commit SHAs and deviation notes, and `handover.md` explicitly points future
readers at this file for that history. The file's own banner asks for its wholesale
deletion once week 1 ships, which is a decision this item does not trigger, does not
pre-empt, and does not duplicate.

ASSUMPTION: The three complete run folders under `.agents/runs/`
(`igdb-client-repoint-20260805`, `sentry-20260806`, `igdb-transport-20260807`) stay.
There is a genuine conflict here and the conservative side is taken: `handover.md` says
run folders are "removed once a run is complete with no open escalations", and
`week-1-task-briefs.md` records two earlier folders already removed on that basis, but
the instruction for REQ-11.5 explicitly names old run folders' `## Code review outcomes`
logs as memory to keep. Assuming "leave them" and raising the conflict separately
rather than resolving a documented convention inside a quick filter. Not classified
CRITICAL because the safe default is unambiguous — deleting is the irreversible
direction, and nothing downstream is blocked by keeping them.

ASSUMPTION: `CLAUDE.md`, `.claude/**` and `.codex/**` are out of REQ-11.5's scope.
They are pipeline definitions rather than project documentation, and `.codex/` is
recorded in `handover.md` as deliberately disagreeing with `.claude/`.

ASSUMPTION: AC-4.2's inline baseline figures (199 passing, 11 failing of 210) are stale
— they predate item 10.1 merging on 2026-08-07, and `orchestrator-state.md` now records
`+218 -11`. Assuming execution binds to `orchestrator-state.md` read at the time, not
to the numbers quoted in the criterion; AC-4.4 states this rather than editing AC-4.2,
because AC-4.2 is part of the already-drafted, not-yet-approved item 1–3 set.

ASSUMPTION: REQ-11.4 and REQ-11.5 are independent of each other and of REQ-11.1–11.3,
and of the three items' single-commit framing. Assuming they may land in the same
commit; if the human prefers them split, that is a task-brief decision, not a criteria
change.

# QA Report
Source: `.agents/week-1-task-briefs.md` § "11 — Cleanup [PIPELINE]", via
`.agents/runs/cleanup-20260806/tech-ac.md`
Date: 2026-08-07

Overall result: PASS

Covers both commits: `37f82ee` (Dev) + `12d08d9` (QA cycle 1 fix). Cycle 1's
single defect — the dangling `; see` in `week-1-task-briefs.md`'s item 9 record —
is fixed and reads correctly in context. Everything else re-confirmed unchanged.

QA cycles used: 2. Cycle 1 verified the whole run from scratch (all 14 constant
deletions independently re-derived, the three retired run folders, every AC);
cycle 2 re-verified the fix plus a full scope/analyzer/test regression sweep,
and carries cycle 1's findings forward where nothing has touched them since.

## Scope check (git, not diff-summary.md)

`git diff --name-only 871652d..12d08d9` = exactly the allowlisted set:
`.gitattributes`, `.gitignore`, `pubspec.yaml`, `lib/core/res/const.dart`,
`.agents/week-1-task-briefs.md`, `.agents/handover.md`, the index deletion of
`coverage/lcov.info`, this run's own artifacts, and 25 deletions across the
three retired run folders (9 + 8 + 8). No file git shows that `diff-summary.md`
did not mention. No path outside the allowlist.

`12d08d9` touches one file, `.agents/week-1-task-briefs.md`, one line — squarely
inside the allowlist and exactly the fix asked for, nothing bundled in.

`git status --short` is empty — no uncommitted change, before or after this
pass's analyzer and test runs. Commits after the fix (`adfbc91`, `5356a44`)
touch only this run's `diff-summary.md`, `escalation.md` and
`orchestrator-state.md`; `adfbc91` adds the `## QA cycle 1 fix` addendum naming
`12d08d9`, so the artifacts and git agree.

Both deviations listed in `diff-summary.md` have matching lines under
`orchestrator-state.md ## Deviation approvals`, and both are implemented as
described — see AC-7.4. The Dev-commit line in `orchestrator-state.md` records
the fix commit (`Dev commit: 37f82ee (QA cycle 1 fix: 12d08d9)`), matching git.

## Static analysis
Status: PASS
Errors: NONE

`flutter analyze`: 34 issues — 0 errors, 2 warnings, 32 info. Matches
`orchestrator-state.md`'s `Analyzer baseline: 0 errors, 2 warnings, 32 info`
exactly, and matches cycle 1's result exactly. Both warnings are the pre-existing
`_TaskReminder` pair in `task_detail_screen.dart:201`/`:204`, out of scope per
AC-5.10. Nothing attributable to an allowlisted file.

This is also the strongest available check on the constant deletions: a deleted
`static const` that anything still read would be a compile error, and there are
zero errors.

Generated code: `dart run build_runner build --delete-conflicting-outputs` was
run in cycle 1 — clean, 76 outputs, `git status` left completely empty,
independently confirming AC-1.6. Not re-run this pass: `12d08d9` touches one
Markdown file, no annotated source, and `git status` is still empty.

## Test results
Status: SKIPPED (testing-mode: none) — run anyway for baseline confirmation.
Tests run: 229 | Passed: 218 | Failed: 11
`flutter test`: **+218 -11**, matching `orchestrator-state.md`'s
`Test baseline: +218 -11` exactly, and matching cycle 1. The 11 failures are the
recorded pre-existing set (`tracker_repository_test.dart` 4,
`game_detail_cubit_test.dart` 3, `games_bloc_test.dart` 3, `widget_test.dart` 1)
and are not regressions. No file under `test/` is in the diff (AC-5.12).

## Coverage gaps (coverage mode only)
N/A — testing mode `none`.

## Acceptance criteria

AC-1.1: PASS — `.gitattributes:16-20`, all five patterns present, each
`text eol=lf`.
AC-1.2: PASS — diff for `.gitattributes` is additions only; lines 1–12 (comment
+ seven registrant entries) byte-identical.
AC-1.3: PASS — no `* text=auto`, no `*.dart eol=lf`, no `* eol=…`; every rule
targets a named generated pattern. Verified against the full file, not the diff.
AC-1.4: PASS — no hand-written `.dart`, doc, asset or config file in the
renormalisation diff. Vacuously so in this checkout (nothing to renormalise).
AC-1.5: PASS — nothing reverted, stashed or split.
AC-1.6: PASS — independently re-run. `build_runner` completed and `git status`
reported zero modified generated Dart files (empty output).
AC-1.7: PASS — `diff-summary.md:9-17` states it explicitly, and the commit
message names the renormalisation as an intended one-time consequence.
AC-2.1: PASS — `.gitignore:52-53`; `git check-ignore -v coverage/lcov.info`
returns `.gitignore:53:coverage/`.
AC-2.2: PASS — `git ls-files coverage/` returns empty; commit records the index
deletion.
AC-2.3: PASS — `coverage/lcov.info` present on disk (57593 bytes); `git status`
reports it in no category.
AC-3.1: PASS — `pubspec.yaml:102` now reads `  envied: ^1.3.4`;
`flutter_secure_storage` returns no match anywhere in the file.
AC-3.2: PASS — `envied: ^1.3.4` (line 102), `envied_generator: ^1.3.4` (line
136), `# Envied - Privatise file` comment (line 101) all intact.
AC-5.1: PASS — `analyzer-baseline.txt` holds the verbatim output;
`diff-summary.md:72-87` classifies by diagnostic code with a total per group.
AC-5.2: PASS — `diff-summary.md:89-98`, all three observations recorded;
`analysis_options.yaml` not in the diff.
AC-5.3: PASS — `diff-summary.md:100-104` states the public-declaration blind
spot explicitly and does not present the analyzer result as sweep evidence.
AC-5.4: PASS — 58 members (52 + 6), each with a count. **Independently
re-derived** in cycle 1, not accepted: the qualified form was run for all 38
retained members of `lib/core/res/const.dart` and all 6 of
`lib/features/onboarding/const.dart`, plus bare and qualified forms for the 14
deleted. Every count matched `diff-summary.md`'s table exactly. Untouched since.
AC-5.5: PASS — the 14 deleted members return **zero** qualified references
across `lib/` and `test/` (single combined regex, no hits). The four retained
members at zero qualified refs are each legitimately retained: `featured` under
AC-5.7, and `onboarding`/`auth`/`legal` by bare self-reference inside
`RouteConstants.openPaths` (`lib/core/res/const.dart:69`). No single-reference
member was deleted.
AC-5.6: PASS — `lib/core/di/network_module.dart:16-19` reads `igdbBaseUrl` and
the three timeouts; `lib/core/services/api/twitch_auth_interceptor.dart:21-23`
reads the three timeouts. All retained.
AC-5.7: PASS — `RouteConstants.featured` is named at
`.agents/references/project-conventions.md:160` and retained despite 0 code
refs.
AC-5.8: PASS — value search independently re-run across `lib/`, `test/`,
`supabase/`, `android/`, `pubspec.yaml` and the `*.env.example` files. The only
literal hit is `assets/animations/` at `pubspec.yaml:154`, which is pubspec's
own asset-folder declaration and reads no Dart constant — correctly not a block.
No hit for `api.rawg.io`, `Unsupported type for shared preferences`, or any of
the quoted route literals. Remaining hits are file paths and identifiers
(`game_detail`, `tracker_detail`, `task_detail`, `image_page_view`), not values.
AC-5.9: PASS — the `const.dart` diff contains deleted lines and nothing else. No
class deleted, no rename, move, re-order, or changed value/type. No class was
left empty.
AC-5.10: PASS — `diff-summary.md:201-208` records `_TaskReminder` as a finding
and leaves it; it is still present and still both analyzer warnings.
AC-5.11: PASS — 0 errors, 2 warnings, 32 info, unchanged in all three
severities, re-confirmed this pass.
AC-5.12: PASS — `+218 -11`; no `test/` path in the diff.
AC-6.1: PASS — all 15 files (README.md, handover.md, week-1-task-briefs.md, 12
files in `.agents/references/`) recorded at `diff-summary.md:221-252`, each with
an outcome. One inaccuracy, immaterial: `onboarding-auth-design-spec.md` is
listed among files whose hits are prose, but it has zero done-family hits, i.e.
it belongs in the "zero hits" group. Outcome ("nothing removed") is right
either way.
AC-6.2: PASS — the empty removal set is correct, verified rather than accepted.
`roadmap-deferred.md`'s three genuine finished-task notes each fail condition
(c): `:91` carries a date plus the retained original reasoning, `:446` carries a
date, a file name and a documented rough edge, `:459` carries a date, the run
folder `debug-sign-out-20260805`, and open design questions ("revisit when
Settings gets a real spec"). Retaining all three is the right call, not a missed
opportunity. No other file carries a cull candidate.
AC-6.3: PASS — none of the named protected items appear in the diff.
AC-6.4: PASS — no file deleted under REQ-11.5, empty removal set recorded as a
valid outcome. The one stale statement left alone —
`handover.md`'s "Item 11 … parked at the Phase 3 human design gate — never
approved" — is correctly left, being outside both deviation approvals; see
Notes.
AC-6.5: PASS — REQ-11.5 contributed no diff at all.
AC-7.1: PASS — `diff-summary.md:256-263` records all four conditions per folder,
covering all four folders including this run's.
AC-7.2: PASS — exactly three folders removed; `cleanup-20260806` intact and
complete.
AC-7.3: PASS — items 10 and 10.1 now carry full shipped entries with date,
retired folder name, commit SHA, QA outcome, cycle count and every approved
deviation (`.agents/week-1-task-briefs.md:390-410`, `:459-478`), both ticked
`- [x] Done`. Item 9's pointer was replaced with the substance it pointed at
(`.agents/week-1-task-briefs.md:359-375`), and after `12d08d9` that replacement
reads as clean prose — see AC-7.6.
AC-7.4: PASS — both items migrated into `handover.md ## Known non-blocking
gaps`: the `FunctionException` dead-code follow-up and all four manual checks
(`10.1-AC-16`, `10.1-AC-17`, `10.1-AC-2`, `10.1-AC-10`), each carrying enough of
its own text to be executable with the folder gone. Neither was filed in
`week-1-task-briefs.md`. Both approved deviations verified implemented as
described: `## Next-session prompt` drops the "Do item 10.1 next" instruction
and the "item 11 parked at the gate" paragraph and now points the reader at
`orchestrator-state.md`'s `Current phase` line rather than asserting a status;
`§ "Where things stand"` now reads "shipped 2026-08-07" in place of "written up
but not started".
AC-7.5: PASS — `diff-summary.md:265-271` records the re-read result for both
folders, matching the expected outcome; nothing further migrated.
AC-7.6: PASS (was PARTIAL in cycle 1, fixed by `12d08d9`) — see below.
AC-7.7: PASS — `.agents/runs/` contains exactly one entry,
`cleanup-20260806`. `git status --short --ignored .agents/runs/` returns empty:
no empty directory, no untracked residue. All 25 deletions recorded in the
commit.
AC-7.8: PASS — the folder deletions and the checkbox ticks are applied under
this supersession, correctly, and are not read as AC-6.3/AC-6.4 violations here.
AC-4.1: PASS — `git diff 871652d..12d08d9 -- pubspec.lock` is empty; the only
`pubspec.yaml` change is the comment deletion.
AC-4.2: superseded by AC-4.4.
AC-4.3: superseded by AC-4.4.
AC-4.4: PASS — baselines read from `orchestrator-state.md` both hold exactly,
re-confirmed this pass across both commits; changed-file set is within the
amended allowance; no path under `.agents/runs/` outside the three deletions and
this run's folder was touched.

### AC-7.6 — cycle 1 defect and its fix

Cycle 1 returned PARTIAL: the item 9 pointer was removed but its `; see` lead-in
was not, leaving `.agents/week-1-task-briefs.md:367` running mid-instruction into
an unrelated new sentence, and leaving the approved
`TwitchAuthInterceptor`/`NetworkModule` carve-out record visibly truncated.

`12d08d9` changes exactly that one line, `; see` → `.`, nothing else.
`.agents/week-1-task-briefs.md:359-375` now reads as continuous prose: the
carve-out sentence closes at "`tech-ac.md`'s criteria were amended with an
explicit carve-out for this."; "A second approval from the same run, recorded
nowhere else: …" then stands as its own complete sentence and runs correctly
through to the closing "Run folder `igdb-client-repoint-20260805` retired
2026-08-07 — run complete, evidence retired." Read as a whole paragraph, not as a
diff: no dangling clause, no orphaned pointer, no truncated record. The dropped
pointer target is the right outcome rather than a loss — it pointed into the
deleted folder, and the substance it pointed at is now inline immediately above.

The substantive half of AC-7.6 also still holds, re-verified this pass: a
repo-wide search for the three retired folder names
(`igdb-client-repoint-20260805`, `igdb-transport-20260807`, `sentry-20260806`)
returns only this run's own artifacts and `week-1-task-briefs.md`'s
retired-folder records — all correct as history, none an instruction to open a
path that no longer exists.

## Architectural compliance
Status: PASS
FAILs: NONE
WARNINGs: NONE

`tdd.md` prescribes no classes, paths or signatures for this run — it is a
config/docs/deletion change. No package added, removed or re-constrained; no
global scope introduced; no layer boundary touched. Both commit messages follow
`git.md` (conventional `chore:` / `fix:`, no AI signature; `37f82ee` identifies
the renormalisation, `12d08d9` names the QA cycle it answers).

## Notes (non-blocking, no action required of Dev)

1. `.agents/references/api-contracts.md:166` still says "`ConfigConstants.baseUrl`
   still points at RAWG" — that constant is now deleted, so the line is stale.
   Dev correctly reported this and correctly did not fix it: AC-6.4 bars it and
   the file is outside this run's write set. It is a real follow-up for whoever
   owns that doc.
2. `handover.md § "Where things stand"` still says item 11 is "parked at the
   Phase 3 human design gate — never approved", which is stale (Phase 3 was
   approved 2026-08-07 and the run is at QA). Correctly left alone: neither
   deviation approval covers it and AC-6.4 bars rewriting merely-stale prose.
   The rewritten `## Next-session prompt` in the same file now says the opposite,
   so the file briefly disagrees with itself until item 11 closes out.
3. The renormalisation was a genuine no-op in this checkout (no `core.autocrlf`,
   generated files already LF). The `.gitattributes` fix is still correct and
   still lands; a full `build_runner` run leaves the tree clean.

## Escalation required
NONE

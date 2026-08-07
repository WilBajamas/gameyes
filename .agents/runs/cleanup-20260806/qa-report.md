# QA Report
Source: `.agents/week-1-task-briefs.md` § "11 — Cleanup [PIPELINE]", via
`.agents/runs/cleanup-20260806/tech-ac.md`
Date: 2026-08-07

Overall result: FAIL

One defect, one line, in `.agents/week-1-task-briefs.md`. Everything else in the
run verified clean, including all 14 constant deletions re-checked independently.

## Scope check (git, not diff-summary.md)

`git diff --name-status 871652d..37f82ee` = exactly the allowlisted set:
`.gitattributes`, `.gitignore`, `pubspec.yaml`, `lib/core/res/const.dart`,
`.agents/week-1-task-briefs.md`, `.agents/handover.md`, the index deletion of
`coverage/lcov.info`, this run's own artifacts, and 25 deletions across the
three retired run folders (9 + 8 + 8). No file git shows that `diff-summary.md`
did not mention. No path outside the allowlist. `git status` clean — no
uncommitted change. Two commits sit after the Dev commit (`5cc9edf`, `d11b89f`);
both touch only this run's `diff-summary.md`/`orchestrator-state.md`.

Both deviations listed in `diff-summary.md` have matching lines under
`orchestrator-state.md ## Deviation approvals`, and both are implemented as
described — see AC-7.4 below.

## Static analysis
Status: PASS
Errors: NONE

`dart run build_runner build --delete-conflicting-outputs` ran clean (76
outputs) and left `git status` completely empty — independently confirming
AC-1.6.

`flutter analyze`: 34 issues — 0 errors, 2 warnings, 32 info. Matches
`orchestrator-state.md`'s `Analyzer baseline: 0 errors, 2 warnings, 32 info`
exactly. Both warnings are the pre-existing `_TaskReminder` pair in
`task_detail_screen.dart:201`/`:204`, out of scope per AC-5.10. Nothing
attributable to an allowlisted file.

This is also the strongest available check on the constant deletions: a deleted
`static const` that anything still read would be a compile error, and there are
zero errors.

## Test results
Status: SKIPPED (testing-mode: none) — run anyway, as instructed, for baseline
confirmation.
`flutter test`: **+218 -11**, matching `orchestrator-state.md`'s
`Test baseline: +218 -11` exactly. The 11 failures are the recorded pre-existing
set and are not flagged. No file under `test/` is in the diff (AC-5.12).

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
AC-1.5: PASS — nothing reverted, stashed or split; one commit.
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
re-derived**, not accepted: I ran the qualified form for all 38 retained members
of `lib/core/res/const.dart` and all 6 of `lib/features/onboarding/const.dart`,
plus bare and qualified forms for the 14 deleted. Every count matches
`diff-summary.md`'s table exactly.
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
severities.
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
(`:368-375`) — see AC-7.6 for the defect in how that replacement was made.
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
AC-7.6: **PARTIAL** — see below.
AC-7.7: PASS — `.agents/runs/` contains exactly one entry,
`cleanup-20260806`. `git status --short --ignored .agents/runs/` returns empty:
no empty directory, no untracked residue. All 25 deletions recorded in the
commit.
AC-7.8: PASS — the folder deletions and the checkbox ticks are applied under
this supersession, correctly, and are not read as AC-6.3/AC-6.4 violations here.
AC-4.1: PASS — `git diff 871652d..37f82ee -- pubspec.lock` is empty; the only
`pubspec.yaml` change is the comment deletion.
AC-4.2: superseded by AC-4.4.
AC-4.3: superseded by AC-4.4.
AC-4.4: PASS — baselines read from `orchestrator-state.md` both hold exactly;
changed-file set is within the amended allowance; no path under `.agents/runs/`
outside the three deletions and this run's folder was touched.

### AC-7.6 — PARTIAL

The item 9 pointer was removed but its lead-in was not. `.agents/week-1-task-briefs.md:366-368`
now reads:

```
      human wants the old shape available to consult. `tech-ac.md`'s
      criteria were amended with an explicit carve-out for this; see
      A second approval from the same run, recorded nowhere else:
```

The old text was `… for this; see \`orchestrator-state.md ## Deviation
approvals\` in the run folder.` The replacement dropped the pointer target and
the closing full stop but left the trailing `; see`, which now runs straight
into an unrelated new sentence.

The substantive half of AC-7.6 holds — no surviving file directs a reader into a
deleted folder, and a repo-wide search for the three folder names (run
independently) returns only this run's own artifacts and
`week-1-task-briefs.md`'s retired-folder records, all correct as history. But
AC-7.6's failure case is "leaving an instruction that points at a path which no
longer exists", and this `see` is an instruction pointing at nothing. It also
leaves the carve-out record — the approved `TwitchAuthInterceptor`/`NetworkModule`
deviation — visibly truncated mid-sentence, in the one file `handover.md`
nominates as the record of what each run shipped.

Fix is one line: end the sentence at `… carve-out for this.` (or restore a
substantive continuation), leaving the new second-approval paragraph as its own
sentence. No other change needed.

## Architectural compliance
Status: PASS
FAILs: NONE
WARNINGs: NONE

`tdd.md` prescribes no classes, paths or signatures for this run — it is a
config/docs/deletion change. No package added, removed or re-constrained; no
global scope introduced; no layer boundary touched. The commit message follows
`git.md` (conventional `chore:`, no AI signature, identifies the renormalisation).

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
   still lands; I confirmed independently that a full `build_runner` run leaves
   the tree clean.

## Escalation required
AC-7.6 PARTIAL — dangling `; see` at `.agents/week-1-task-briefs.md:367` →
route to: Dev Agent

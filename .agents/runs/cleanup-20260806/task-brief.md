# Task Brief
Source: `.agents/week-1-task-briefs.md` § "11 — Cleanup [PIPELINE]" (now lines
435–479), plus the human instructions of 2026-08-07 adding items 4, 5 and 6 — all
via `.agents/runs/cleanup-20260806/tech-ac.md`
Date: 2026-08-07 (supersedes the 2026-08-06 version, which covered items 1–3 only)

## Context

Six repository-hygiene fixes in one commit: stop generated Dart churning in
`git status`, stop QA's coverage report dirtying the tree, delete a wrong TODO on
the `envied` dependency, delete `static const` members nothing reads, record a
docs cull that is expected to remove nothing, and retire three completed run
folders after writing their record into the checklist and their open work into
`handover.md`. No runtime change.

## Testing mode

`none` — Rule applied: cosmetic/config-only. Justification: no behaviour exists to
test. The only Dart edit deletes declarations with zero references, which is why
AC-5.11 expects the analyzer not to move and AC-5.12 forbids touching `test/` at
all — a constant a test reads is retained under AC-5.5, so no test can need
changing. Verification is the AC-1.6 before/after `git status` capture, the
per-member and per-file records, and the AC-4.4 baseline comparison. Write no test
file; add no golden test under any circumstances.

## File allowlist

### CREATE NEW
.agents/runs/cleanup-20260806/analyzer-baseline.txt — verbatim `flutter analyze` output, captured before any Dart edit (AC-5.1)
.agents/runs/cleanup-20260806/diff-summary.md — the run's evidence record; sections listed under `## Implementation plan` step 19

### MODIFY EXISTING
.gitattributes — append the five generated-Dart `text eol=lf` patterns under a new comment; change no existing line
.gitignore — append a `# Coverage` section with a single `coverage/` entry; change no existing line
pubspec.yaml — delete the trailing TODO comment on the `envied` line (line 102); change nothing else
lib/core/res/const.dart — delete only `static const` members verified at zero references; no other edit of any kind
lib/features/onboarding/const.dart — swept for the same reason; expected to end byte-identical, edited only if a member verifies at zero references
.agents/week-1-task-briefs.md — amend item 9's entry, write items 10 and 10.1's entries and tick their boxes (AC-7.3, AC-7.8)
.agents/handover.md — migrate item 10.1's open work into `## Known non-blocking gaps` (AC-7.4); rewrite the `## Next-session prompt` block (human-approved addition, see `## Constraints`)
README.md — in the REQ-11.5 scan set; expected outcome "nothing removed"
.agents/references/*.md (12 files) — in the REQ-11.5 scan set; expected outcome "nothing removed" for each

### DELETE
.agents/runs/igdb-client-repoint-20260805/ — every tracked file (expected 9)
.agents/runs/sentry-20260806/ — every tracked file (expected 8)
.agents/runs/igdb-transport-20260807/ — every tracked file (expected 8)
Confirm the real file list with `git ls-files` before removing; remove whatever it lists, not what this brief expects.

### INDEX ONLY (no file content authored by hand)
coverage/lcov.info — removed from the git index with `git rm --cached`; the file stays on disk
`*.g.dart` / `*.freezed.dart` / `*.gr.dart` / `*.config.dart` / `*.mocks.dart` — stored blobs rewritten by one `git add --renormalize .` pass; expected in the commit, never hand-edited

### TEST FILES
(none — testing mode is `none`; no file under `test/` may be edited, AC-5.12)

Never list generated files (`*.freezed.dart`, `*.g.dart`, `*.gr.dart`,
`*.config.dart`, `*.mocks.dart`) as sources to author — here they appear only as
blobs renormalisation rewrites, which is a git operation, not an edit.

## Implementation plan

Step 1: `.gitattributes` — append one blank line after the existing line 12, then
a short comment naming `build_runner` as the LF writer, then the five patterns
from the brief's code block verbatim: `*.g.dart`, `*.freezed.dart`, `*.gr.dart`,
`*.config.dart`, `*.mocks.dart`, each with `text eol=lf`. Lines 1–12 stay
byte-identical — the diff must show additions only. No `* text=auto`, no
`*.dart eol=lf`, no rule that can match a hand-written file.

Step 2: `.gitignore` — append a `# Coverage` heading and a single `coverage/`
entry after the existing `# FVM Version Cache` block, matching the file's
sectioned style. Ensure the current last line (`.fvm/flutter_sdk`) is
newline-terminated before appending. Touch no existing line, including the
commented-out `#.vscode/`.

Step 3: `pubspec.yaml` — on line 102, delete the trailing
`# TODO: To deprecate this package and use flutter_secure_storage` so the line
reads `  envied: ^1.3.4`. Leave line 101's `# Envied - Privatise file`, the
`^1.3.4` constraint and `envied_generator` untouched. Do not write a replacement
comment. Do not run `flutter pub get`; `pubspec.lock` must not change.

Step 4: `git rm --cached coverage/lcov.info` — index removal only. Confirm
afterwards that the file still exists on disk and that `git status` reports it in
no category (neither modified, deleted, nor untracked). Run this *after* step 2 so
the new ignore rule prevents any later `git add` restaging it.

Step 5: `git add --renormalize .` — one repo-wide pass, run only after step 1 is
saved and before any other edit in this plan, so the scope gate reads a small
tree. Then check with `git status --short` and `git diff --cached --stat` that
every path whose stored content changed matches one of the five new patterns or
one of the seven pre-existing registrant patterns. If a hand-written `.dart` file,
or any doc, asset or config file appears: stop, re-check the patterns for
over-breadth, and if they are correct, escalate — do not commit the wider diff and
do not narrow the pass to a file list to route around it. Do not hand-edit line
endings and do not run any scripted bulk rewrite (gotcha #2).

Step 6: capture `git status` output verbatim as the "before" half of the AC-1.6
evidence, for `diff-summary.md`.

Generation checkpoint: `dart run build_runner build --delete-conflicting-outputs`
— the AC-1.6 verification and the only generator run in this task. (Per
`generation.md`; does not count toward the 20-step ceiling.)

Step 7: capture `git status` again as the "after" half, plus `git diff --stat`.
AC-1.6 passes only if zero generated Dart files are reported modified. If any
generated file shows a *real* insertion/deletion diff rather than a pure
line-ending difference, treat it as gotcha #2's corruption symptom: revert those
files with `git checkout -- <path>`, re-verify, and escalate. Do not hand-repair
and do not proceed.

Step 8: run `flutter analyze` and save the full output verbatim to
`.agents/runs/cleanup-20260806/analyzer-baseline.txt`. No Dart file has been
edited yet, so this is the base-commit result — say so in the record. Classify
every issue by diagnostic code into the unused-declaration family
(`unused_import`, `unused_field`, `unused_local_variable`, `unused_element`,
`unused_shown_name`, `unused_catch_clause`, `dead_code`) or not, with a total per
group, and record the AC-5.2 and AC-5.3 observations about
`analysis_options.yaml` — read it, never edit it.

Step 9: the constants sweep evidence. For every `static const` in
`lib/core/res/const.dart` (52 members) and `lib/features/onboarding/const.dart`
(6 members), run both the bare member name and the `Class.member` form over all of
`lib/` and all of `test/`, and record the searches, the match locations and the
reference count excluding the declaration line. Read the bare-name results
alongside the qualified ones — `gamesEndpoint` exists on two classes and one of
them is heavily used. Then, for each candidate at zero, search its literal value
across `lib/`, `test/`, `supabase/`, `android/`, `pubspec.yaml` and the three
`*.env.example` files and record the result; a value found anywhere outside its
own declaration blocks the deletion and is reported instead. Apply AC-5.6
(`@Deprecated` readers count) and AC-5.7 (a `.agents/references/` convention doc
naming the member counts) before concluding.

Step 10: `lib/core/res/const.dart` — delete only the members step 9 verified at
zero, and nothing else. No class deleted, no member renamed, moved or re-ordered,
no surviving value or type changed, no comment added to explain a retention: the
diff for this file must contain deleted lines and nothing else. Confirm
`lib/features/onboarding/const.dart` needs no edit (or apply the same rule to it
if a member verified at zero). Record every AC-5.10 finding — anything unused
larger than a single declaration, `_TaskReminder` included — as a finding only;
delete none of them.

Step 11: the docs cull. Scan `README.md`, `.agents/handover.md`,
`.agents/week-1-task-briefs.md` and all twelve files in `.agents/references/` for
finished-task notes that carry no forward information, and record each file with
one of exactly two outcomes: "nothing removed", with a one-line reason, or the
exact lines removed. Remove a line only when all three AC-6.2 conditions hold, and
argue condition (c) per removal. When a candidate is arguable, leave it and record
why. Do not rewrite, re-tick or correct anything that is merely stale, and delete
no file. An empty removal set across all fifteen files is a valid, passing outcome
— record it as one.

Step 12: qualification and open-work check. For every folder under `.agents/runs/`
— including any not named in the criteria — record AC-7.1's four conditions
individually: `Current phase:` reads exactly `COMPLETE`, no `escalation.md`, every
`## Escalation history` entry resolved or `NONE`, and not this run's folder. Then
re-read `sentry-20260806` and `igdb-client-repoint-20260805` for still-open
forward-looking content and record the result; anything found still open is
migrated to `handover.md` under AC-7.4's rule before any deletion. A folder failing
any condition stays and is reported.

Step 13: `.agents/week-1-task-briefs.md` — write the shipped record (AC-7.3), in
the shape items 4, 5, 6 and 8 already use. Amend item 9's entry: replace the
closing pointer into the run folder with the substance of what it pointed at, and
add the second approval recorded only in that folder. Replace items 10 and 10.1's
bare `- [ ] Done` with full entries written from those folders'
`orchestrator-state.md` and `qa-report.md` — date, run-folder name marked retired,
commit SHA, QA outcome and cycle count, each approved deviation in one line — and
tick both boxes; the entry and the tick are the record (AC-7.8). See
`code-plan.md` for the proposed text.

Step 14: `.agents/handover.md` — add the two AC-7.4 items to `## Known
non-blocking gaps (carried forward)`: item 10.1's deferred `FunctionException`
dead-code follow-up, and its four never-performed manual checks, each carrying
enough of its own text to be executable without the deleted folder. Add nothing
to `week-1-task-briefs.md` for either; open work does not go in an ephemeral file.

Step 15 — CONDITIONAL, only if the human approved it at the Phase 3 gate:
`.agents/handover.md` § "Where things stand" — correct the paragraph that says
item 10.1 "is written up but not started". If it was not approved, skip this step
entirely and note the residual inconsistency in `diff-summary.md`. See
`tdd.md ## Open questions`.

Step 16: `git rm -r` the three qualified folders. Every tracked file leaves both
the index and the working tree; confirm no empty directory and no untracked file
is left behind under those paths, and that `.agents/runs/` afterwards contains
exactly one entry, `cleanup-20260806`.

Step 17: repository-wide search for the three folder names and record every hit.
Any surviving instruction that directs a reader *into* a deleted folder must be
fixed; a hit that merely names one as past history reads correctly with the folder
gone and is left alone. The one known live pointer is item 9's, already handled in
step 13 — confirm it is gone.

Step 18: `.agents/handover.md` § "Next-session prompt" — rewrite the block last,
so it reflects the run's true end state (human-approved addition of 2026-08-07;
see `## Constraints`). Remove the "Do item 10.1 next" instruction and the "item 11
… parked at the Phase 3 gate" paragraph. Word it so it is still correct whenever
it is read: point the reader at `.agents/runs/cleanup-20260806/orchestrator-state.md`'s
`Current phase` line for item 11's status rather than asserting one. Proposed text
is in `code-plan.md`; check the state file before writing and adjust if the
proposed wording no longer matches reality.

Step 19: write `.agents/runs/cleanup-20260806/diff-summary.md`, with a section per
item: (1) the before/after `git status` captures and an explicit statement that the
renormalised generated files are the intended one-time content change from the
`.gitattributes` fix, naming them as such (AC-1.7); (2) the `coverage/lcov.info`
index removal and its on-disk survival; (3) the TODO removal; (4) the analyzer
classification, the per-member sweep with counts, the value-search results, the
members deleted and the AC-5.10 findings not deleted; (5) the per-file docs
outcome for all fifteen files; (6) the per-folder AC-7.1 record, the AC-7.5
open-work result, what was migrated where, the deleted file count, and the AC-7.6
search hits. Record the commit SHA from `git rev-parse HEAD`. Lead with the
diffstat's two large numbers — the renormalised generated files and the deleted
run-folder `.md` files — so the file count does not read as scope creep.

Final step: run `flutter analyze` and `flutter test` and compare against
`orchestrator-state.md`'s baselines, quoted verbatim:
`Analyzer baseline: 0 errors, 2 warnings, 32 info — captured 2026-08-07T15:48:33Z`
and `Test baseline: +218 -11 — captured 2026-08-07T15:48:33Z`.
Pre-existing failures are recorded there as
`test/repository/tracker/tracker_repository_test.dart (4),
test/cubit/game_detail/game_detail_cubit_test.dart (3),
test/cubit/games/games_bloc_test.dart (3), test/widget_test.dart (1)`.
AC-4.4 binds to these figures as read from the state file, not to the older
numbers quoted inside AC-4.2. Deleting a genuinely unused public constant produces
no analyzer delta, because the analyzer never reported it — any movement in the
counts means either the deletion was wrong or it created a new diagnostic;
investigate, do not accept. Then commit once, per `git.md`, with a message that
identifies the renormalised generated files as an intended one-time consequence of
the `.gitattributes` fix.

(The generation checkpoint after step 6 does not count toward the ceiling. That
leaves 19 substantive steps plus the final step — inside the limit of 20.)

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: REQ-11.1, REQ-11.2, REQ-11.3, REQ-11.4, REQ-11.5, REQ-11.6, REQ-11.C

Never paste the criteria text here — Dev and QA read the canonical section
directly. Note AC-4.4 supersedes AC-4.2/AC-4.3 on three points and AC-7.8
supersedes parts of AC-6.3/AC-6.4 for the three deleted folders only.

## Constraints

- **Only two Dart files are in the allowlist, for deletions only.** If a step
  seems to need any other Dart file, that is an escalation, not an improvised
  edit. `test/` is searched as a source of references and never edited (AC-5.12).
- **No dependency change of any kind.** No package added, removed, upgraded,
  downgraded or re-constrained; `pubspec.lock` must be byte-identical (AC-4.1).
  Do not run `flutter pub get` — it is not needed for a comment deletion.
  `pubspec.yaml` is writable *for the single comment deletion only*, overriding
  `execution.md`'s standing read-only exception; every other line is out of
  bounds. `retrofit` / `retrofit_generator` stay as-is.
- **`.gitattributes` is extended, never replaced.** Any deletion or modification
  of one of the seven existing entries or their comment fails AC-1.2.
- **No blanket line-ending rule.** No `* text=auto`, no `*.dart eol=lf`, no
  `* eol=…`, no pattern that can match hand-written Dart (AC-1.3) — an automatic
  fail regardless of how clean the resulting diff looks.
- **The renormalisation is exactly one `git add --renormalize .` pass**, run after
  `.gitattributes` is written and before the other items' edits. Hand-editing line
  endings, or any scripted bulk rewrite across generated files, is prohibited.
- **The renormalised files belong in this commit** (AC-1.5). Do not revert, stash
  or split them out; the whole brief is one commit.
- **`coverage/lcov.info` is untracked, not deleted.** Index removal only; the
  working-tree file must still exist afterwards (AC-2.3), and the local
  `coverage/` directory is not removed.
- **Do not change `core.autocrlf`**, any other git config, or any
  editor/EditorConfig setting.
- **No replacement comment** for the deleted TODO.
- **`analysis_options.yaml` is read-only** in every sense: no lint rule added, no
  `analyzer.exclude` narrowed. It is not in the allowlist.
- **The grep sweep is not a completeness proof and must not be described as one.**
  It establishes zero references for the members it names by showing the searches
  and their results; it says nothing about members it did not search, and its
  blind spots — dynamic construction, name-based DI and generator lookups,
  analyzer-excluded generated code — are why AC-5.8's value search is a separate
  recorded step.
- **REQ-11.5 defaults to leaving content alone.** When a candidate is arguable,
  leave it and record why. It removes; it does not rewrite, re-tick or correct.
- **REQ-11.6's records and deletions land together.** No intermediate state where
  a folder is gone and its record unwritten. If an AC-7.3 or AC-7.4 record cannot
  be written for a folder, that folder is not deleted and the reason is reported.
- **Authorised scope addition, 2026-08-07 (not in `tech-ac.md`):** rewriting
  `handover.md`'s `## Next-session prompt` block (step 18). `tech-ac.md ## Out of
  scope` currently bars it — that bar is overridden by the human's instruction to
  this Tech Lead phase, and the orchestrator should record it under
  `orchestrator-state.md ## Deviation approvals` so QA does not read step 18 as
  out-of-scope work. Step 15 is a *further* proposed correction to the same file
  and is conditional on the Phase 3 gate.
- **Changed-file set is closed** (AC-4.3 as amended by AC-4.4): `.gitattributes`,
  `.gitignore`, `pubspec.yaml`, the index deletion of `coverage/lcov.info`, the
  renormalised generated files, `lib/core/res/const.dart`,
  `lib/features/onboarding/const.dart`, the `.md` docs paths AC-6.5 permits, the
  three deleted run folders, `.agents/week-1-task-briefs.md`, `.agents/handover.md`,
  and this run's own artifacts. Nothing else — no opportunistic formatting, import
  sorting, or unrelated `.gitignore` tidying. No path under `.agents/runs/` other
  than the three deletions and this run's folder may be added, modified or deleted.
- **Commit per `git.md`:** one commit for the whole brief, conventional-commit
  message (`chore:` fits), no AI signature or `Co-Authored-By` trailer ever, never
  `--no-verify`, never push. The message must identify the renormalised generated
  files as the intended one-time consequence of the `.gitattributes` fix (AC-1.7).
- **Baselines, not absolutes:** this project carries 2 pre-existing analyzer
  warnings and 11 pre-existing test failures. "All tests pass" and "the analyzer is
  clean" are both false here — compare against the recorded baseline only.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make
tests pass. Do not add packages to `pubspec.yaml` or touch files outside the
allowlist — escalate instead.

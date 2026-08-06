# Task Brief
Source: `.agents/week-1-task-briefs.md` § "11 — Cleanup [PIPELINE]" (lines 385–429),
checklist items 1–3, via `.agents/runs/cleanup-20260806/tech-ac.md`
Date: 2026-08-06

## Context

Stop generated Dart files churning in `git status`, stop QA's coverage report
dirtying the tree, and delete a wrong TODO on the `envied` dependency — three
repository-hygiene fixes, no runtime change.

## Testing mode

`none` — Rule applied: cosmetic/config-only. Justification: no Dart source, no
test and no build configuration changes, and the compiled app is byte-identical
before and after. Verification is the AC-1.6 before/after `git status` capture
and the AC-4.2 baseline comparison, not new test files. Write no test file; add
no golden test under any circumstances.

## File allowlist

### CREATE NEW
(none — all three target files already exist)

### MODIFY EXISTING
.gitattributes — append the five generated-Dart `text eol=lf` patterns under a new comment; change no existing line
.gitignore — append a `# Coverage` section with a single `coverage/` entry; change no existing line
pubspec.yaml — delete the trailing TODO comment on the `envied` line (line 102); change nothing else

### INDEX ONLY (no file content authored by hand)
coverage/lcov.info — removed from the git index with `git rm --cached`; the file stays on disk
`*.g.dart` / `*.freezed.dart` / `*.gr.dart` / `*.config.dart` / `*.mocks.dart` — stored blobs rewritten by one `git add --renormalize .` pass; expected in the commit, never hand-edited

### RUN ARTIFACTS
.agents/runs/cleanup-20260806/diff-summary.md — must name the renormalised generated files as the intended one-time consequence of the `.gitattributes` fix (AC-1.7), and record the commit SHA

### TEST FILES
(none — testing mode is `none`)

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
sectioned style. Ensure the current last line (`.fvm/flutter_sdk`) is newline-
terminated before appending. Touch no existing line, including the commented-out
`#.vscode/`.

Step 3: `pubspec.yaml` — on line 102, delete the trailing
`# TODO: To deprecate this package and use flutter_secure_storage` so the line
reads `  envied: ^1.3.4`. Leave line 101's `# Envied - Privatise file`, the
`^1.3.4` constraint and `envied_generator` untouched. Do not write a replacement
comment. Do not run `flutter pub get`; `pubspec.lock` must not change.

Step 4: `git rm --cached coverage/lcov.info` — index removal only. Confirm
afterwards that the file still exists on disk and that `git status` reports it in
no category (neither modified, deleted, nor untracked). Run this *after* step 2
so the new ignore rule prevents any later `git add` restaging it.

Step 5: `git add --renormalize .` — one repo-wide pass, run only after step 1 is
saved. Do not hand-edit line endings and do not run any scripted bulk rewrite
across generated files (gotcha #2).

Step 6: verify the renormalisation scope with `git status --short` and
`git diff --cached --stat`. Every path whose stored content changed must match
one of the five new patterns or one of the seven pre-existing registrant
patterns. If a hand-written `.dart` file, or any doc, asset or config file,
appears: stop. Do not commit the wider diff — re-check the patterns for
over-breadth first, and if the patterns are correct, escalate rather than
proceeding.

Step 7: capture `git status` output verbatim into the run folder as the "before"
half of the AC-1.6 evidence.

Step 8: run `dart run build_runner build --delete-conflicting-outputs` — the
AC-1.6 verification, and the only generator run in this task. (Generation
checkpoint per `generation.md`; does not count toward the 20-step ceiling.)

Step 9: capture `git status` again as the "after" half, plus
`git diff --stat`. AC-1.6 passes only if zero generated Dart files are reported
modified. If any generated file shows a *real* insertion/deletion diff rather
than a pure line-ending difference, treat it as gotcha #2's corruption symptom:
revert those files to the last known-good commit with `git checkout -- <path>`,
re-verify, and escalate. Do not hand-repair and do not proceed.

Step 10: write `.agents/runs/cleanup-20260806/diff-summary.md`, stating
explicitly that the renormalised generated files are the intended one-time
content change from the `.gitattributes` fix and naming them as such (AC-1.7),
and recording the before/after `git status` captures from steps 7 and 9.

Final step: run `flutter analyze` and `flutter test` and compare against
`orchestrator-state.md`'s baselines, quoted verbatim:
`Analyzer baseline: 0 errors, 2 warnings, 32 info — captured 2026-08-06T00:00:00Z`
and
`Test baseline: +11 -11 counted as failures (199 passing, 11 failing out of 210) — captured 2026-08-06T00:00:00Z`.
Pre-existing failures are recorded there as
`test/repository/tracker/tracker_repository_test.dart (4),
test/cubit/game_detail/game_detail_cubit_test.dart (3),
test/cubit/games/games_bloc_test.dart (3), test/widget_test.dart (1)`.
This run touches no code, so any new analyzer diagnostic or any new test failure
is a defect by definition (AC-4.2) — investigate it, do not accept it. Then
commit once, per `git.md`, with a message that identifies the renormalised
generated files as an intended one-time consequence of the `.gitattributes` fix.

(Step 8 is the only build_runner checkpoint and does not count toward the 20-step
ceiling. That leaves 10 substantive steps plus the final step — well inside the
limit.)

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: REQ-11.1, REQ-11.2, REQ-11.3, REQ-11.C

Never paste the criteria text here — Dev and QA read the canonical section
directly.

## Constraints

- **No Dart file is in the allowlist.** If a step seems to need one, that is an
  escalation, not an improvised edit. `lib/` and `test/` are untouched.
- **No dependency change of any kind.** No package added, removed, upgraded,
  downgraded or re-constrained; `pubspec.lock` must be byte-identical (AC-4.1).
  Do not run `flutter pub get` — it is not needed for a comment deletion.
  `pubspec.yaml` is writable in this run *for the single comment deletion only*,
  overriding `execution.md`'s standing read-only exception; every other line of
  it is out of bounds. `retrofit` / `retrofit_generator` stay as-is.
- **`.gitattributes` is extended, never replaced.** Any deletion or modification
  of one of the seven existing entries or their comment fails AC-1.2 and
  reintroduces the `flutter pub get` churn they already fix.
- **No blanket line-ending rule.** No `* text=auto`, no `*.dart eol=lf`, no
  `* eol=…`, no pattern that can match hand-written Dart (AC-1.3). This is an
  automatic fail regardless of how clean the resulting diff looks.
- **The renormalisation is exactly one `git add --renormalize .` pass**, run
  after `.gitattributes` is written. Hand-editing line endings in generated
  files, or any scripted bulk rewrite across them, is prohibited — gotcha #2
  records such a pass silently corrupting content.
- **The renormalised files belong in this commit** (AC-1.5). Do not revert,
  stash, or split them into a second commit; history is one commit for the whole
  brief.
- **Escalation trigger:** if a hand-written source file appears in the
  renormalisation diff and the five patterns are demonstrably correct, halt and
  escalate per `escalation.md`. Do not commit the wider diff, and do not narrow
  the pass to a file list to route around it.
- **Escalation trigger:** if `git diff --stat` after step 8 shows real insertions
  or deletions in a generated file, revert those files and escalate — that is
  gotcha #2's corruption symptom, not an expected regeneration.
- **`coverage/lcov.info` is untracked, not deleted.** Index removal only; the
  working-tree file must still exist afterwards (AC-2.3), and the local
  `coverage/` directory is not removed.
- **Do not change `core.autocrlf`**, any other local or global git config, or any
  editor/EditorConfig setting. The fix is per-path attributes, not a config flip.
- **No replacement comment** for the deleted TODO. The reasoning lives in this
  run's artifacts, not in `pubspec.yaml`.
- **Changed-file set is closed** (AC-4.3): `.gitattributes`, `.gitignore`,
  `pubspec.yaml`, the index deletion of `coverage/lcov.info`, the renormalised
  generated files, and this run's artifacts under
  `.agents/runs/cleanup-20260806/`. Nothing else — no opportunistic formatting,
  import sorting, or unrelated `.gitignore` tidying.
- **Commit per `git.md`:** one commit for the whole brief, conventional-commit
  message (`chore:` fits), no AI signature or `Co-Authored-By` trailer ever,
  never `--no-verify`, never push. The message must identify the renormalised
  generated files as the intended one-time consequence of the `.gitattributes`
  fix, consistent with AC-1.7.
- **Baselines, not absolutes:** this project carries pre-existing analyzer
  warnings and 11 pre-existing test failures. "All tests pass" and "the analyzer
  is clean" are both false here — compare against the recorded baseline only.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to
make tests pass. Do not add packages to `pubspec.yaml` or touch files outside
the allowlist — escalate instead.

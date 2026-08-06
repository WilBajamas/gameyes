# Technical Acceptance Criteria
Source: `.agents/week-1-task-briefs.md` § "11 — Cleanup [PIPELINE]" (lines 385–429),
checklist items 1–3. Background: `.agents/handover.md` gotcha #2 (line-ending churn).
Date: 2026-08-06
BA Agent version: 1.0

## Feature summary

Repository hygiene only. No Dart source, no test, no build config and no runtime
behaviour changes; the app is byte-identical at runtime before and after.

Three independent fixes. (1) The repository runs `core.autocrlf=true`, so git expects
CRLF in the working tree, while `build_runner` writes its output with LF; every
generator run therefore leaves the tracked generated Dart files reported as modified
with an empty content diff. Five generated-Dart glob patterns are pinned to
`text eol=lf` in the root `.gitattributes` — the same mechanism already applied there
to Flutter's plugin-registrant files — and the index is renormalised in one pass so
the recorded blobs match the new rules. The renormalisation rewrites the affected
tracked files' stored content once; that is the fix landing, not churn, and it is in
scope. (2) `coverage/` is added to `.gitignore` and `coverage/lcov.info` is removed
from the index, so QA's `--coverage` runs stop dirtying the tree. (3) A factually
wrong TODO comment on the `envied` dependency line in `pubspec.yaml` is deleted.

Source IDs used below:
- `REQ-11.1` — `.gitattributes` created and index renormalised
- `REQ-11.2` — `coverage/` ignored and untracked
- `REQ-11.3` — `envied` TODO removed
- `REQ-11.C` — run-wide constraints stated in the brief's preamble

## Technical acceptance criteria

[REQ-11.1] REPO CONFIG (AC-1.1): The root `.gitattributes` contains all five
generated-Dart patterns, each assigned `text eol=lf`: `*.g.dart`, `*.freezed.dart`,
`*.gr.dart`, `*.config.dart`, `*.mocks.dart`.
  Failure case: any of the five missing, or assigned an attribute other than
  `text eol=lf`, leaves that generator's output still churning and is a fail.

[REQ-11.1] REPO CONFIG (AC-1.2): The seven pre-existing plugin-registrant entries in
the root `.gitattributes` (`generated_plugin_registrant.cc/.h`,
`generated_plugins.cmake`, `GeneratedPluginRegistrant.swift/.java/.h/.m`) and their
explanatory comment survive unchanged. The file is extended, not replaced.
  Failure case: the file's diff shows any deletion or modification of an existing
  line. That would reintroduce the `flutter pub get` churn those entries already fix.

[REQ-11.1] REPO CONFIG (AC-1.3): `.gitattributes` contains no blanket rule — no
`* text=auto`, no `*.dart eol=lf`, no `* eol=…`, and no pattern matching
hand-written Dart. Every rule targets a specific generated-file pattern.
  Failure case: any blanket or `*.dart`-wide rule is an automatic fail regardless of
  how clean the resulting diff looks, because it renormalises the whole repository.

[REQ-11.1] REPO INDEX (AC-1.4): After `git add --renormalize .`, every path whose
stored content changed matches one of the `.gitattributes` patterns. No hand-written
`.dart` file, and no non-Dart source, doc, asset or config file, appears in the
renormalisation diff.
  Failure case: a hand-written source file in the diff means a pattern is too broad
  (see AC-1.3) — stop, correct the pattern, and re-run rather than committing the
  wider diff.

[REQ-11.1] REPO INDEX (AC-1.5): The renormalisation is committed in this run. The
generated files whose stored line endings changed are expected in the commit even
though they are not otherwise part of this task.
  Failure case: renormalised files reverted, stashed, or split into a separate
  commit leaves the index disagreeing with `.gitattributes` and the churn unfixed.

[REQ-11.1] VERIFICATION (AC-1.6): With the working tree clean, running
`dart run build_runner build --delete-conflicting-outputs` leaves `git status`
reporting zero modified generated Dart files. `git status` is captured before and
after that command and both are recorded.
  Failure case: any generated Dart file still reported modified with an empty content
  diff means the fix did not take. A generated file modified with a *real* content
  diff is a different matter — that is either an expected regeneration or gotcha #2's
  corruption symptom, and must be distinguished with `git diff --stat` and reported,
  not silently accepted.

[REQ-11.1] DOCUMENTATION (AC-1.7): `diff-summary.md` states explicitly that the
renormalised generated files are the intended one-time content change from the
`.gitattributes` fix, and names them as such.
  Failure case: an unexplained file count in the diffstat reads to the human gate and
  to QA as scope creep or as the build_runner blow-up that gate is watching for.

[REQ-11.2] REPO CONFIG (AC-2.1): `.gitignore` contains a `coverage/` entry.
  Failure case: absent, or written so it does not match `coverage/lcov.info`, and the
  file reappears as untracked on the next QA `--coverage` run.

[REQ-11.2] REPO INDEX (AC-2.2): `coverage/lcov.info` is no longer tracked — it does
not appear in `git ls-files`, and the commit records its deletion from the index.
  Failure case: still tracked, so `.gitignore` has no effect on it and every QA run
  keeps producing a modified-file entry.

[REQ-11.2] WORKING TREE (AC-2.3): `coverage/lcov.info` still exists on disk after the
change, and `git status` reports it neither as modified, deleted, nor untracked.
  Failure case: the file shows in `git status` in any form — ignoring did not take —
  or the local coverage output was deleted, which was not requested.

[REQ-11.3] DEPENDENCY MANIFEST (AC-3.1): In `pubspec.yaml`, the `envied` dependency
line carries no TODO comment; the string `flutter_secure_storage` appears nowhere in
the file.
  Failure case: comment left in place, reworded, or moved elsewhere in the file. The
  claim is wrong, not merely stale — the two packages are not substitutes.

[REQ-11.3] DEPENDENCY MANIFEST (AC-3.2): `envied` remains declared at its current
version, `envied_generator` remains declared in dev dependencies at its current
version, and the `# Envied - Privatise file` section comment remains.
  Failure case: the dependency removed, downgraded, upgraded, or moved between
  sections. Only the comment text was in scope.

[REQ-11.C] BUILD (AC-4.1): `pubspec.yaml`'s dependency graph is unchanged — every
dependency and dev dependency, and every version constraint, is byte-identical to
the base commit. `pubspec.lock` is unchanged.
  Failure case: any added, removed or re-constrained dependency, or a modified lock
  file, in this run.

[REQ-11.C] BUILD (AC-4.2): The analyzer result matches the Phase 0 baseline recorded
in `orchestrator-state.md` (0 errors, 2 warnings, 32 info), and the test suite result
matches its baseline (199 passing, 11 failing of 210).
  Failure case: any new analyzer diagnostic or any new test failure. This run touches
  no code, so either is a defect by definition.

[REQ-11.C] SCOPE (AC-4.3): The commit's changed-file set is exactly:
`.gitattributes`, `.gitignore`, `pubspec.yaml`, the deletion of `coverage/lcov.info`
from the index, the generated files touched by renormalisation, and this run's
artifacts under `.agents/runs/cleanup-20260806/`.
  Failure case: any file outside that set, including opportunistic formatting, import
  sorting, or unrelated `.gitignore` tidying.

## Out of scope

- Any change to Dart source, tests, assets, or Flutter/Gradle build configuration.
- Regenerating code for its own sake. `build_runner` is run only as the AC-1.6
  verification step; its output is expected to be identical apart from line endings.
- Changing `core.autocrlf`, any other local or global git config, or editor/EditorConfig
  settings. The fix is per-path attributes, not a global setting flip.
- Pinning line endings for any file class beyond the five generated-Dart patterns and
  the seven plugin-registrant entries already present — no `.arb`, no `.json`, no
  shell script, no `.md`.
- Acting on the removed TODO. `envied` is not being replaced by
  `flutter_secure_storage`, and no secure-storage work starts here.
- Any other stale comment or TODO elsewhere in `pubspec.yaml` or the codebase. Only
  the one named comment is in scope.
- Pruning unused dependencies (e.g. `retrofit` / `retrofit_generator`, raised as
  leftovers by the preceding run). Explicitly barred by the no-dependency-change
  constraint.
- The 11 pre-existing test failures, and the discrepancy between them and gotcha #3's
  count of 13. Recorded in `orchestrator-state.md`; not this run's work.
- Deleting `.agents/week-1-task-briefs.md`. Its own banner asks for deletion once
  every item is ticked, but item 11 does not request it and other items remain open.
- Removing the local `coverage/` directory from disk, or changing how QA invokes
  `flutter test --coverage`.
- Any CI or workflow configuration change.

## Constraints

Not independently testable, but binding on execution:

- The renormalisation must be a single `git add --renormalize .` pass applied after
  `.gitattributes` is written. Hand-editing line endings in generated files, or
  running a scripted bulk rewrite across them, is prohibited — gotcha #2 records a
  bulk pass across generated files silently corrupting content.
- If `git diff --stat` after the build_runner verification shows real insertions or
  deletions in generated files rather than pure line-ending changes, treat it as
  gotcha #2's corruption symptom: revert the affected files to the last known-good
  commit, re-verify, and escalate. Do not hand-edit and do not proceed.
- The commit message must identify the renormalised generated files as an intended
  one-time consequence of the `.gitattributes` fix, consistent with AC-1.7.

## Assumptions

ASSUMPTION: A root `.gitattributes` already exists, pinning Flutter's generated
plugin-registrant files to LF for the same reason. "Create a `.gitattributes`" is
read as "ensure the five generated-Dart patterns are present" — append to the
existing file, preserving every existing line (AC-1.2).

ASSUMPTION: Pattern text is taken verbatim from the brief's code block. Column
alignment of `text eol=lf` is cosmetic and not asserted. Bare `*.g.dart` rather than
`**/*.g.dart` is correct — a git pattern with no leading slash already matches at any
depth.

ASSUMPTION: "Untrack `coverage/lcov.info`" means index removal only, leaving the
working-tree file in place (AC-2.3).

ASSUMPTION: The `.gitignore` entry is exactly `coverage/`, appended under its own
comment heading in keeping with the file's existing sectioned style. `coverage/` is
the only coverage path in the tree today.

ASSUMPTION: Only the trailing TODO comment is deleted from the `envied` line; the
dependency, its version, its section comment and `envied_generator` all remain
(AC-3.1, AC-3.2).

ASSUMPTION: No replacement comment records why the TODO was wrong. The reasoning
lives in this run's artifacts, not in `pubspec.yaml`.

ASSUMPTION: `git add --renormalize .` is run repo-wide as instructed, but content
changes are expected only in files matching a `.gitattributes` pattern; a
hand-written source file in that diff indicates an over-broad pattern rather than an
accepted cost (AC-1.4).

ASSUMPTION: The "roughly seventeen files" figure in the brief is descriptive. AC-1.6
asserts zero generated files reported modified, whatever the actual count.

ASSUMPTION: Editing `pubspec.yaml` is authorised here. The preceding run treated it
as read-only under that run's allowlist; item 11 names it as a target, so it is in
scope for comment removal only (AC-3.1, AC-3.2, AC-4.1).

ASSUMPTION: The three fixes are independent and may land in any order within one
commit. The brief calls them unrelated and states no sequencing.

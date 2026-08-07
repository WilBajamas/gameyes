# Technical Acceptance Criteria
Source: `.agents/week-1-task-briefs.md` § "11 — Cleanup [PIPELINE]" (lines 385–429),
checklist items 1–3. Background: `.agents/handover.md` gotcha #2 (line-ending churn).
Source (items 4–5, added 2026-08-07): human instruction to the orchestrator expanding
this run's scope — unused-code scan and docs "done"/"completed" cull. Not written up in
`week-1-task-briefs.md`; the instruction text is the only source.
Source (item 6, added 2026-08-07, third BA pass): human instruction authorising removal
of the completed run folders under `.agents/runs/`, acting on the convention already
stated in `.agents/handover.md` § "Where things live".
Date: 2026-08-06 (items 1–3), 2026-08-07 (items 4–5, item 6)
BA Agent version: 1.0

## Feature summary

Repository and codebase hygiene. Six independent fixes, no feature work, no
architectural change, no dependency change. Items 1–3 and 6 touch no Dart source at
all; items 4 and 5 do, but only by deleting declarations and documentation lines that
nothing reads. Runtime behaviour is identical before and after all six.

Three repository fixes. (1) The repository runs `core.autocrlf=true`, so git expects
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

Two scans, added to this run's scope on 2026-08-07. (4) An unused-declaration sweep
over `lib/`. Two halves with different verification methods: the analyzer already
reports unused imports, fields, local variables and private elements by default, so
that half is a matter of reading and classifying the existing baseline output rather
than finding anything new; unused *public* `static const` values have no lint at all
and need a per-member grep cross-reference over `lib/` and `test/`, with the reference
count shown for each one removed. Only individual declarations are removed — never a
class, never a file. (5) A light-touch pass over `README.md` and `.agents/` for
finished-task notes that carry no forward information. Conservative by construction:
anything that records a date, a PR number, a deviation or a reason stays, and an empty
removal set is a valid outcome.

One deletion, added 2026-08-07. (6) The three completed run folders under
`.agents/runs/` are removed, applying a convention `handover.md` already states but
that has not been followed. It is the one item in the run whose output cannot be
re-derived, so it is gated on the record surviving elsewhere first. `handover.md`
nominates `week-1-task-briefs.md` as the answer to "which runs shipped what"; that file
covers item 9 in detail but records items 10 and 10.1 as an unticked `- [ ] Done` with
no date, no SHA and no deviation note, so two of the three folders are the only account
of what their run shipped, and one also holds still-open forward work. The shipped
record is written into the checklist and the open work into `handover.md`, in the same
commit as the deletion.

Source IDs used below:
- `REQ-11.1` — `.gitattributes` created and index renormalised
- `REQ-11.2` — `coverage/` ignored and untracked
- `REQ-11.3` — `envied` TODO removed
- `REQ-11.4` — unused const/variable/string sweep over `lib/`
- `REQ-11.5` — docs "done"/"completed" cull
- `REQ-11.6` — completed run folders removed from `.agents/runs/`
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

[REQ-11.4] ANALYZER BASELINE (AC-5.1): The full `flutter analyze` output at the base
commit is captured verbatim into this run's folder, and every one of its 34 issues is
recorded with its diagnostic code. The record classifies each issue as either in the
unused-declaration family (`unused_import`, `unused_field`, `unused_local_variable`,
`unused_element`, `unused_shown_name`, `unused_catch_clause`, `dead_code`) or not, and
gives the total in each group.
  Failure case: reporting only the counts "0 errors, 2 warnings, 32 info". A count
  does not say which of the baseline issues this item is already covering, which is
  the whole question AC-5.1 exists to answer.

[REQ-11.4] ANALYZER CONFIG (AC-5.2): The record states, as observed facts rather than
assertions, (a) that `analysis_options.yaml`'s `linter.rules` list names none of the
unused-declaration rules, (b) whether unused-declaration diagnostics nevertheless
appear in the baseline output, and (c) that `analysis_options.yaml`'s `analyzer.exclude`
list — the five generated-Dart globs plus `lib/generated/**` — removes generated and
localisation output from analysis entirely, so nothing unused inside generated code is
reported by the analyzer or in scope for this item.
  Failure case: adding a lint rule to `analysis_options.yaml` to "enable" this check.
  Changing analyzer configuration is out of scope (see Out of scope) and would move
  the baseline that AC-4.2 pins.

[REQ-11.4] ANALYZER COVERAGE (AC-5.3): The record states explicitly what the analyzer
does *not* catch and therefore what the grep sweep below exists to cover: unused
**public** declarations of any kind, including every `static const` on a public class,
are never reported by any Dart diagnostic or `flutter_lints` rule.
  Failure case: presenting a clean-or-baseline analyzer result as evidence that no
  unused constants exist. It is evidence of nothing about public members.

[REQ-11.4] CONSTANTS SWEEP (AC-5.4): Every `static const` member declared in
`lib/core/res/const.dart` and `lib/features/onboarding/const.dart` is cross-referenced
individually. For each member the record shows the searches run — the bare member name
and the `Class.member` form — the paths searched (all of `lib/` and all of `test/`),
and the resulting reference count with the member's own declaration line excluded.
  Failure case: a verdict of "confirmed unused" with no count behind it, or a count
  taken from a tool's summary rather than from listed match locations. The method's
  limits are why the count has to be visible.

[REQ-11.4] CONSTANTS SWEEP (AC-5.5): A member is deleted only when its reference count
excluding its own declaration is exactly zero across `lib/` and `test/`. Every member
with one or more references stays, including members referenced exactly once, and
including members referenced only from a test.
  Failure case: deleting a single-reference member because the reference "looks
  trivial". Consolidating or inlining a used constant is refactoring, not this item.

[REQ-11.4] CONSTANTS SWEEP (AC-5.6): A member referenced only from a file carrying an
`@Deprecated` annotation counts as referenced and is retained. The two such files today
are `lib/core/di/network_module.dart` and
`lib/core/services/api/twitch_auth_interceptor.dart`.
  Failure case: deleting a member those files read. They are intentionally-kept
  credential-free reference code and must keep compiling; breaking them silently
  reverses a deviation the human approved during item 9.

[REQ-11.4] CONSTANTS SWEEP (AC-5.7): A member named by a document in
`.agents/references/` as the value to use for a stated convention counts as referenced
and is retained even when no code reads it yet.
  Failure case: deleting a constant a convention doc tells the next developer to use.
  That either breaks the documented convention or forces an edit to a reference doc,
  and reference docs are outside this run's write boundary.

[REQ-11.4] FALSE-POSITIVE GUARD (AC-5.8): Before deletion, each zero-reference
candidate's literal **value** is also searched across `lib/`, `test/`, `supabase/`,
`android/`, `pubspec.yaml` and the `*.env.example` files, and the result is recorded.
A value found anywhere outside its own declaration blocks the deletion and is reported
instead.
  Failure case: deleting a constant whose value is reconstructed at runtime by string
  interpolation or concatenation, read by name through a DI or generator lookup (the
  `@Envied(varName:)` shape, where the constant's value is an environment-variable
  name, not a Dart identifier), or referenced from generated output that the analyzer
  excludes. A name-only search cannot see any of these, which is why the value search
  is a separate, recorded step.

[REQ-11.4] SCOPE (AC-5.9): Only individual declarations are deleted. No class is
deleted, no file is deleted, no member is renamed, moved between classes, or
re-ordered, and no surviving member's value or type changes. If deletions leave a class
with no members, the empty class is left in place and reported.
  Failure case: any structural edit. The diff for this item should contain deleted
  lines and nothing else.

[REQ-11.4] SCOPE (AC-5.10): Anything unused that is larger than a single declaration —
a whole class, a whole file, an unused private member the analyzer already reports, or
an unused top-level declaration outside the two constants files — is recorded in
`diff-summary.md` as a finding and is **not** deleted. `_TaskReminder` in
`lib/features/tracker/presentation/screens/task_detail_screen.dart` is such a finding
and is out of scope: CRITICAL-1 was resolved on 2026-08-07 by the human choosing option
A, leave it alone.
  Failure case: deleting one. That is a product call about whether a feature is still
  planned, not a hygiene call, and this item does not authorise it.

[REQ-11.4] BUILD (AC-5.11): After the deletions, `flutter analyze` reports exactly the
baseline recorded in `orchestrator-state.md`, unchanged in all three severities.
  Failure case: any movement in the counts. Deleting a genuinely unused public constant
  produces no analyzer delta because the analyzer never reported it; a delta means
  either something in scope *was* reported (contradicting "unused") or the deletion
  created a new diagnostic — most likely an import in a constants file left
  unreferenced, which is removed in the same change rather than left.

[REQ-11.4] BUILD (AC-5.12): `flutter test` matches the recorded test baseline, and no
file under `test/` is edited by this item.
  Failure case: any test edit. A constant referenced from a test is retained under
  AC-5.5, so no test can need changing; editing one means AC-5.5 was breached.

[REQ-11.5] DOCS SCAN (AC-6.1): The scan covers `README.md`, `.agents/handover.md`,
`.agents/week-1-task-briefs.md`, and every file in `.agents/references/`. Each file is
recorded with one of exactly two outcomes: "nothing removed", with a one-line reason,
or the exact lines removed.
  Failure case: a file in that set with no recorded outcome. "Quick filter" describes
  the depth of judgement, not whether a file was looked at.

[REQ-11.5] DOCS REMOVAL (AC-6.2): A line or block is removed only when all three hold:
(a) it records a task, item or decision as finished; (b) no other file points a future
reader at it; (c) removing it loses no fact — no date, PR number, commit SHA, run-folder
name, approved deviation, gotcha, constraint, or stated reason for a choice. Anything
failing any one of the three stays.
  Failure case: removing a finished-task note that was the only place a PR number, a
  deviation approval, or a "why it was done this way" was written down. Condition (c)
  is the one that decides most cases and must be argued per removal, not assumed.

[REQ-11.5] DOCS PRESERVATION (AC-6.3): The following are untouched, by name:
`handover.md`'s "Items 1 through 10 are now all done and merged" framing and its
per-item status paragraphs; `week-1-task-briefs.md`'s `- [x] Done` entries and its
ephemeral top banner; every `## Code review outcomes`, `## Deviation approvals` and
`## Escalation history` block under `.agents/runs/`; and every occurrence in
`.agents/references/` where "complete"/"completed"/"done" names a library status value,
a design behaviour, or prose rather than a finished task. Superseded in one respect by
AC-7.8.
  Failure case: any of these in the diff. They are project memory, and the last group
  are false positives of the search term rather than cull candidates at all.

[REQ-11.5] DOCS SCOPE (AC-6.4): No file is deleted. No directory under `.agents/runs/`
is deleted. No checkbox is ticked, re-dated or corrected, and no statement that is
merely stale — as opposed to a finished-task note — is rewritten. An empty removal set
is a valid, passing outcome and is recorded as one. Superseded in two respects by
AC-7.8.
  Failure case: a docs edit that changes meaning rather than removing noise, or a
  correctness fix smuggled in under a cull. Correcting stale status is separate work
  and belongs to whoever owns the document.

[REQ-11.5] SCOPE (AC-6.5): This item's diff contains only `.md` files, and only files
under `.agents/` or `README.md` at the repository root.
  Failure case: any other path. Docs work cannot touch source, config, or the pipeline
  definitions under `.claude/` and `.codex/`.

[REQ-11.6] QUALIFICATION (AC-7.1): A folder under `.agents/runs/` qualifies for removal
only when all four conditions hold, each checked and recorded per folder: (a) it
contains an `orchestrator-state.md` whose `Current phase:` line reads exactly
`COMPLETE`; (b) it contains no `escalation.md`; (c) every entry under its
`## Escalation history` is marked resolved, or the section reads `NONE`; (d) it is not
this run's own folder.
  Failure case: removing a folder because its run "looks finished". A `Current phase`
  reading anything other than `COMPLETE`, a present `escalation.md`, or an escalation
  entry with no recorded resolution all mean the folder is live state, not evidence.

[REQ-11.6] REMOVAL SET (AC-7.2): The removal set is exactly three folders —
`igdb-client-repoint-20260805` (item 9), `sentry-20260806` (item 10) and
`igdb-transport-20260807` (item 10.1) — each re-checked against AC-7.1 at execution
time rather than trusted from this list. `cleanup-20260806` is retained in full: it is
this run, and it is in progress. Any folder failing an AC-7.1 condition is left in
place and reported.
  Failure case: deleting `cleanup-20260806`, which destroys the run's own artifacts
  mid-run; or deleting a fourth folder created since these criteria were written,
  without checking it against AC-7.1.

[REQ-11.6] RECORD PRECONDITION (AC-7.3): The commit that deletes the folders also
contains, in `.agents/week-1-task-briefs.md`, a per-item shipped record for each of the
three runs, in the style the file already uses for items 4, 5, 6 and 8: date,
run-folder name marked retired, merge or commit SHA (or PR number), QA outcome and
cycle count, and each approved deviation in one line. Item 9's existing entry (lines
348–368) is amended; items 10 and 10.1 have no detail at all today — an unticked
`- [ ] Done` and nothing else — so their entries are written from those folders'
`orchestrator-state.md` before the folders go.
  Failure case: deleting `sentry-20260806` or `igdb-transport-20260807` while the
  checklist still says only `- [ ] Done` for items 10 and 10.1. `handover.md` nominates
  `week-1-task-briefs.md` as the record of which runs shipped what; for those two items
  that record does not exist yet, so deleting first destroys the only account of what
  they shipped — deviations, SHAs, QA outcome and all.

[REQ-11.6] OPEN-WORK PRECONDITION (AC-7.4): Two pieces of still-open, forward-looking
content exist only inside `igdb-transport-20260807` and are moved into
`.agents/handover.md` — not into `week-1-task-briefs.md` — in the same commit: (a) its
`orchestrator-state.md` § "Follow-up (not this run)", recording that
`BaseRepositoryMixin`'s `on FunctionException` branch, `ErrorType.supabaseIgdbError`,
`mockFunctionException` and `games_repository_test.dart`'s "throws FunctionException"
test all became unreachable when item 10.1 landed, deferred by the human on 2026-08-07
to a separate run; and (b) its `qa-report.md` § "Manual verification required" — the
four checks `10.1-AC-2`, `10.1-AC-10`, `10.1-AC-16` and `10.1-AC-17`, which no document
anywhere records as performed.
  Failure case: filing either as history in the checklist. (a) is scheduled work and
  (b) is verification the app has never had; `week-1-task-briefs.md` is ephemeral by
  its own banner, so open work recorded only there is scheduled to be deleted.

[REQ-11.6] OPEN-WORK CHECK (AC-7.5): `sentry-20260806` and
`igdb-client-repoint-20260805` are each re-read for that same class of content before
deletion, and the result recorded. Expected outcome, to be confirmed rather than
assumed: `sentry-20260806`'s pending manual checks `[10.12]` and `[10.18]` are recorded
confirmed in its own `## Follow-up actions` (2026-08-07) and the `--flavor dev`
discovery from `[10.12]` is already `handover.md` gotcha #8;
`igdb-client-repoint-20260805`'s manual device testing is recorded complete in
`week-1-task-briefs.md` lines 357–358.
  Failure case: migrating nothing from either folder without checking. Anything found
  still open is migrated under AC-7.4's rule instead, and the deletion waits on it.

[REQ-11.6] CROSS-REFERENCES (AC-7.6): After deletion, no surviving file directs a
reader into a deleted folder. A repository-wide search for the three folder names is
run and its hits recorded. The one known live pointer is `week-1-task-briefs.md`'s item
9 line "see `orchestrator-state.md ## Deviation approvals` in the run folder", replaced
by the substance of that record under AC-7.3.
  Failure case: leaving an instruction that points at a path which no longer exists. A
  hit that merely mentions a folder as past history — this run's own artifacts, and
  `handover.md`'s general "one folder per pipeline run" convention line — reads
  correctly with the folder gone and is left alone.

[REQ-11.6] MECHANICS (AC-7.7): Every tracked file in the three folders is removed from
both the index and the working tree, recorded as deletions in the commit, and
`.agents/runs/` afterwards contains exactly one entry, `cleanup-20260806`. No empty
directory and no untracked file is left behind under the deleted paths.
  Failure case: a working-tree deletion that leaves the files tracked, or untracked
  residue that reappears in the next run's `git status` — the same class of problem
  REQ-11.2 exists to fix.

[REQ-11.6] SUPERSESSION (AC-7.8): For these three folders only, REQ-11.6 overrides two
REQ-11.5 statements: AC-6.3's preservation of every `## Code review outcomes`,
`## Deviation approvals` and `## Escalation history` block under `.agents/runs/`, and
AC-6.4's "no directory under `.agents/runs/` is deleted". Both still bind for
`cleanup-20260806` and for any folder failing AC-7.1. AC-6.4's ban on ticking or
re-dating a checkbox likewise does not apply to the record edits AC-7.3 and AC-7.4
require: writing items 10 and 10.1's entries includes ticking their `- [x] Done` boxes,
because the entry and the tick are the record.
  Failure case: QA failing the deletion by reading AC-6.3/AC-6.4 as still absolute, or
  Dev applying REQ-11.5's leave-it-alone default to the record edits and deleting the
  folders with nothing written in their place.

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

[REQ-11.C] SCOPE (AC-4.4): AC-4.2 and AC-4.3 were written for items 1–3 only and are
superseded on three points now that items 4, 5 and 6 are in scope. First, the baseline
figures that bind are the ones currently in `orchestrator-state.md`, read at execution
time, not the figures quoted inline in AC-4.2. Second, the allowed changed-file set is
AC-4.3's set plus `lib/core/res/const.dart`, `lib/features/onboarding/const.dart` and
the docs paths AC-6.5 permits. Third, it also allows REQ-11.6's changes: deletion of
every tracked file under `.agents/runs/igdb-client-repoint-20260805/`,
`.agents/runs/sentry-20260806/` and `.agents/runs/igdb-transport-20260807/`, and edits
to `.agents/week-1-task-briefs.md` and `.agents/handover.md` for the records AC-7.3 and
AC-7.4 require. No other path under `.agents/runs/` may be added, modified or deleted.
  Failure case: enforcing AC-4.2's quoted test numbers, which were captured before item
  10.1 merged; rejecting the two constants files as out-of-allowlist; or rejecting the
  run-folder deletions, which are the whole of REQ-11.6.

## Out of scope

- Any change to Dart source, tests, assets, or Flutter/Gradle build configuration.
  (Narrowed by REQ-11.4: deleting unused `static const` declarations from the two
  constants files is in scope. Nothing else in Dart source is.)
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
- Deleting `.agents/week-1-task-briefs.md`. Its own banner asks for deletion once every
  item is ticked, but item 11 does not request it and other items remain open. REQ-11.6
  writes *into* that file; it does not bring its deletion forward.
- Removing the local `coverage/` directory from disk, or changing how QA invokes
  `flutter test --coverage`.
- Any CI or workflow configuration change.
- Editing `analysis_options.yaml` in any way, including enabling an unused-* lint rule
  or narrowing the `analyzer.exclude` list. REQ-11.4 reads the analyzer's current
  output; it does not change what the analyzer looks at.
- Unused declarations inside generated output (`*.g.dart`, `*.freezed.dart`,
  `*.gr.dart`, `*.config.dart`, `*.mocks.dart`, `lib/generated/**`). They are excluded
  from analysis, they are rewritten by the generator on every run, and editing them by
  hand is barred by handover gotcha #2.
- Deleting, merging or emptying any class or file under `lib/`, and deleting the
  `_TaskReminder` widget and its commented-out call site. Reported under AC-5.10, not
  actioned — CRITICAL-1 resolved as option A.
- Unused declarations under `test/`, `supabase/`, `android/` and `ios/`. REQ-11.4 is
  scoped to `lib/`, and `test/` is searched only as a *source of references*, never as
  a target for deletion.
- Unused *dependencies*, unused assets under `assets/`, unused `.arb` localisation
  keys, and unused Supabase Edge Function code. Each is a different kind of sweep with
  a different verification method; none is what REQ-11.4 asks for.
- Renaming, re-grouping or relocating constants — including moving a
  single-feature constant out of `lib/core/res/const.dart` into a feature `const.dart`
  as the code-quality rules would otherwise prefer. Deletion only.
- Doing the deferred `FunctionException` dead-code removal, and performing item 10.1's
  four outstanding manual checks. AC-7.4 preserves both so they survive the folder
  deletion; neither is executed here — the first is a separate run by the human's
  2026-08-07 decision, the second needs a device.
- Deleting or rewriting any run folder other than the three AC-7.2 names, and any edit
  to a file inside those three. They are deleted whole, not tidied first.
- Correcting stale-but-not-"done" statements beyond the records REQ-11.6 requires:
  `handover.md`'s "Item 10.1 … is written up but not started" and its whole
  `## Next-session prompt` are now wrong, and neither is this run's to fix. (Items 10
  and 10.1's unticked boxes *are* fixed, but as a consequence of AC-7.3, not as a
  correctness pass.)
- `CLAUDE.md`, `.claude/**` and `.codex/**`. Pipeline definitions, not project docs.

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
- REQ-11.4's grep sweep is not a completeness proof and must not be described as one.
  It establishes zero references for the specific members it names, by showing the
  searches and their results. It says nothing about members it did not search, and its
  blind spots — dynamic construction, name-based DI and generator lookups, and
  analyzer-excluded generated code — are the reason AC-5.8 exists.
- REQ-11.5 defaults to leaving content alone. When a candidate is arguable, the correct
  outcome is to leave it and record why, not to remove it and record why.
- REQ-11.6 is the only item whose output cannot be re-derived from the working tree.
  The folders stay recoverable from git history, but only by someone who knows they
  existed — which is what AC-7.3's records are for. If an AC-7.3 or AC-7.4 record
  cannot be written for a folder, that folder is not deleted and the reason is reported.
- The record edits and the deletions must land together, so no intermediate state
  exists where a folder is gone and its record unwritten.
- REQ-11.4, REQ-11.5 and REQ-11.6 are independent of REQ-11.1–11.3 and of each other.

## Assumptions

Short form; the reasoning behind each is in this run's `ambiguities.md`.

- A root `.gitattributes` already exists (7 plugin-registrant lines). "Create" is read
  as "ensure the five generated-Dart patterns are present" — append, preserving every
  existing line (AC-1.2).
- Pattern text is verbatim from the brief. Column alignment is cosmetic. Bare
  `*.g.dart` is correct — a git pattern with no leading slash matches at any depth.
- "Untrack `coverage/lcov.info`" means index removal only; the working-tree file stays
  (AC-2.3). The `.gitignore` entry is exactly `coverage/`, appended under its own
  comment heading; `coverage/` is the only coverage path in the tree today.
- Only the trailing TODO comment leaves the `envied` line — dependency, version,
  section comment and `envied_generator` all stay (AC-3.1, AC-3.2) — and no replacement
  comment records why it was wrong; that reasoning lives in this run's artifacts.
- `git add --renormalize .` is run repo-wide, but content changes are expected only in
  files matching a pattern; a hand-written source file in that diff means an over-broad
  pattern, not an accepted cost (AC-1.4).
- The brief's "roughly seventeen files" is descriptive; AC-1.6 asserts zero generated
  files reported modified, whatever the count.
- Editing `pubspec.yaml` is authorised here (comment removal only), even though the
  preceding run treated it as read-only under its own allowlist.
- Items 1–3 are independent and may land in any order within one commit.
- "Unused const, variables, and strings" means unused *declarations*, not unused
  *values*. Extracting repeated literals into new constants is the opposite job and is
  not done.
- REQ-11.4's mandatory sweep is the two constants files, because every `static const`
  in `lib/` outside generated code lives in one of them. Public declarations elsewhere
  in `lib/` are report-only (AC-5.10); private ones are the analyzer's half (AC-5.1).
- `RouteConstants` is confirmed as the human described: every route is a hardcoded
  literal in `lib/config/route/auto_route_config.dart` and none reads the class, and
  several members have drifted from the real paths (`gameDetail` is `'/game_detail'`,
  the router uses `'/game-detail'`) — stale as well as unread.
- `RouteConstants` is not deleted as a class. `games`, `tracker` and `openPaths` are
  read by code (`games`/`tracker` as hero-tag `fromScreen` discriminators, not routes),
  and `openPaths` itself reads `onboarding`, `auth` and `legal`, so six members stay.
- `RouteConstants.featured` is retained under AC-5.7 despite zero code references:
  `project-conventions.md` § "Hero transition pattern" names it as the `fromScreen`
  value to pass from Featured.
- `ConfigConstants.igdbBaseUrl` is retained under AC-5.6 — its only reader is the
  `@Deprecated` `network_module.dart`, which must keep compiling.
- A reference from a test counts as a reference.
- Expected removal set, found with zero references during BA analysis and subject to
  Dev re-verifying every count under AC-5.4 and the value search under AC-5.8:
  `RouteConstants.root`, `.home`, `.trackerDetail`, `.taskDetail`, `.imagePageView`,
  `.gameDetail`, `.browse`, `.news`, `.settings`; `ConfigConstants.baseUrl`,
  `.gamesEndpoint`, `.screenshotsEndpoint`; `PathConstants.lottieAnimationAssetPath`;
  `StringConstants.sharedPrefTypeError`. A starting point, not the criterion.
- `ConfigConstants.baseUrl`/`.gamesEndpoint`/`.screenshotsEndpoint` are RAWG-era
  leftovers; `ConfigConstants.apiKey` is not — `config_envied.dart` still reads it as
  the name of a `.env` variable, so it stays.
- REQ-11.4 produces no runtime change, so it needs no manual QA check.
- REQ-11.5's search terms ("done", "complete"/"completed", "shipped", `✅`, `- [x]`,
  strikethrough) are entry points, not removal triggers; most `.agents/references/`
  hits are prose or the library's own `Completed` status value.
- `README.md` has no finished-task content and is expected to end the run unchanged.
- REQ-11.5 removes, it does not rewrite. Where a finished-task note sits in a sentence
  that also carries live information, the whole sentence stays.

Added 2026-08-07 with REQ-11.6:

- WITHDRAWN — the previous pass's assumption that the three complete run folders stay.
  It recorded a real conflict (`handover.md`'s removal convention against REQ-11.5's
  instruction to keep old run folders' review logs as memory) and deferred it. The
  human has now decided: the folders go, and AC-7.3/AC-7.4 move the memory out first.
  REQ-11.5 is otherwise unchanged; AC-7.8 records where REQ-11.6 overrides it.
- "Complete with no open escalations" is read as AC-7.1's checkable conditions. All
  three folders pass today: `igdb-client-repoint-20260805` and `sentry-20260806` each
  carry one escalation, both recorded resolved; `igdb-transport-20260807` records
  `NONE`; no `escalation.md` exists anywhere under `.agents/runs/`.
- `week-1-task-briefs.md` is the right home for the shipped record — `handover.md`
  points there, and items 4, 6 and 8 already use exactly that shape ("since removed —
  run complete, evidence retired"). AC-7.3 follows the precedent rather than inventing
  a location.
- That file being ephemeral is accounted for, not ignored: its banner already obliges
  whoever deletes it to promote anything worth keeping into `.agents/references/` or
  the roadmap, so a *historical* record placed there carries the same accepted risk as
  items 1–9's entries and no more. Anything still *open* goes to `handover.md` instead
  (AC-7.4), which is not ephemeral. Flagged rather than assumed silently, since item 11
  is the last-but-one week-1 item and that deletion may follow soon.
- Item 9's record needs completing, not reconstructing. Lines 348–368 already carry the
  date, folder name, merge SHA `9b5e303`, QA outcome and the substance of the
  `TwitchAuthInterceptor`/`NetworkModule` deviation. Two gaps: the closing pointer into
  the folder, and the second approval recorded only there (`IgdbProxyConstants` →
  `SupabaseIgdbProxyConstants`, `ErrorType.functionError` → `ErrorType.supabaseIgdbError`
  by direct human commits `8f9f9bf`/`5cd8a4f`, with the instruction not to update
  `task-brief.md`/`code-plan.md` for it).
- Items 10 and 10.1 have no record outside their folders at all, so their entries are
  written from scratch. `handover.md` says only that item 10 is done and merged, and
  still describes item 10.1 as "written up but not started" — `igdb-transport-20260807`
  is currently the only evidence in the repository that item 10.1 shipped.
- Removal is `git rm -r` of tracked content. `.agents/` is git-tracked, so the folders
  stay recoverable from history for anyone who reads the retired-folder names.
- AC-4.2's inline figures are stale — they predate item 10.1 merging on 2026-08-07,
  after which `orchestrator-state.md` records `+218 -11`. AC-4.4 binds execution to the
  file rather than to the quoted numbers.

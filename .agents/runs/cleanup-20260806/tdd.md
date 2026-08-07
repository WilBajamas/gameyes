# Technical Design Document
Source: `.agents/week-1-task-briefs.md` § "11 — Cleanup [PIPELINE]" (now lines
435–479; `tech-ac.md` cites 385–429, which drifted when item 10.1's section grew),
plus the human instructions of 2026-08-07 that added items 4, 5 and 6 — all via
`.agents/runs/cleanup-20260806/tech-ac.md`
Date: 2026-08-07 (supersedes the 2026-08-06 version, which covered items 1–3 only)

## Feature summary

Repository and codebase hygiene. No application layer changes behaviour. Six
independent changes land in one commit: (1) the root `.gitattributes` gains five
generated-Dart patterns pinned to `text eol=lf`, followed by one repo-wide
`git add --renormalize .` so the recorded blobs agree with the new rules; (2)
`.gitignore` gains a `coverage/` entry and `coverage/lcov.info` leaves the index
while staying on disk; (3) one factually wrong trailing TODO is deleted from the
`envied` dependency line in `pubspec.yaml`; (4) a recorded unused-declaration
sweep over `lib/`, whose only edit is deleting zero-reference `static const`
members from `lib/core/res/const.dart`; (5) a recorded finished-task-note cull
over `README.md` and `.agents/`, expected to remove nothing; (6) three completed
run folders are deleted from `.agents/runs/`, after their shipped record is
written into `.agents/week-1-task-briefs.md` and their still-open work into
`.agents/handover.md` in the same commit. The dependency graph, `pubspec.lock`
and the compiled app are unchanged.

## Layer map

The Dart layer taxonomy (API / repository / use case / state / UI / storage /
service) applies to nothing here — no layer is created, wired or re-shaped. The
equivalent map:

REQ-11.1 (AC-1.1–1.3): VCS attribute config — `.gitattributes`
REQ-11.1 (AC-1.4, AC-1.5): git index — renormalised generated-Dart blobs
REQ-11.1 (AC-1.6): verification only — `build_runner` run, no file authored
REQ-11.1 (AC-1.7): run artifact — `diff-summary.md`
REQ-11.2 (AC-2.1): VCS ignore config — `.gitignore`
REQ-11.2 (AC-2.2, AC-2.3): git index — `coverage/lcov.info` removed, disk intact
REQ-11.3 (AC-3.1, AC-3.2): dependency manifest comment — `pubspec.yaml`
REQ-11.4 (AC-5.1–5.3): evidence only — analyzer output captured and classified
REQ-11.4 (AC-5.4–5.9): shared constants — `lib/core/res/const.dart` (declaration
  deletions only); `lib/features/onboarding/const.dart` swept, expected unchanged
REQ-11.4 (AC-5.10): report only — findings into `diff-summary.md`, no edit
REQ-11.4 (AC-5.11, AC-5.12): baseline comparison, no test file touched
REQ-11.5 (AC-6.1–6.5): project docs — `README.md`, `.agents/handover.md`,
  `.agents/week-1-task-briefs.md`, `.agents/references/*` (12 files)
REQ-11.6 (AC-7.1, AC-7.2, AC-7.5): evidence only — per-folder qualification record
REQ-11.6 (AC-7.3): `.agents/week-1-task-briefs.md` — shipped records for items 9,
  10, 10.1
REQ-11.6 (AC-7.4): `.agents/handover.md` — open work migrated out of
  `igdb-transport-20260807`
REQ-11.6 (AC-7.6, AC-7.7): git index + working tree — three folders removed
REQ-11.C (AC-4.1–4.4): whole-run guards — manifest, baselines, changed-file set

## Data layer

No change. No API contract, model, DTO, datasource or repository is created,
modified or deleted. No `api-contracts.md` / `api-samples/` input is required
because no criterion maps to the API layer.

## Domain layer

No change. No use case is created or modified.

## State layer

No change. No Bloc, Cubit or notifier is created or modified.

## UI layer

No change. No screen or widget is created or modified. No string, `.arb` entry or
route is added, so no Flutter Intl IDE regeneration is implied. The nine deleted
`RouteConstants` members are not routes in any live sense — every route in
`lib/config/route/auto_route_config.dart` is a hardcoded literal and reads no
constant, which is what makes them deletable.

## Repository configuration (REQ-11.1, REQ-11.2, REQ-11.3)

### `.gitattributes` (modify) — repository root

Extended, never replaced (AC-1.2). Lines 1–12 — the comment block and the seven
`**/generated_plugin_registrant*` / `**/GeneratedPluginRegistrant*` /
`**/generated_plugins.cmake` entries — stay byte-identical. Appended after them:
one blank line, a short comment naming `build_runner` as the writer, then the
five patterns from the brief's code block verbatim, each `text eol=lf`:
`*.g.dart`, `*.freezed.dart`, `*.gr.dart`, `*.config.dart`, `*.mocks.dart`
(AC-1.1). Bare patterns with no leading slash, matching at any depth. No
`* text=auto`, no `*.dart eol=lf`, no rule reaching a hand-written file (AC-1.3).

Attribute choice: `text eol=lf` — not `-text`, not `binary`, not `eol=lf` alone.
`text` marks the file for normalisation; `eol=lf` fixes the checkout ending
regardless of `core.autocrlf`. That pairing is what the seven existing lines
already use, so the file stays internally consistent.

### `.gitignore` (modify) — repository root

One new section appended after the existing `# FVM Version Cache` block, in the
file's established `# Heading` + entries style: `# Coverage` then `coverage/`
(AC-2.1). Directory form, so it covers `lcov.info` and any future report in that
folder. No existing line is touched — AC-4.3 bars opportunistic tidying.

### `pubspec.yaml` (modify) — repository root

Line 102 only. `  envied: ^1.3.4 # TODO: To deprecate this package and use
flutter_secure_storage` becomes `  envied: ^1.3.4`. The comment is deleted, not
reworded or relocated, and no replacement note is written (AC-3.1). Line 101's
`# Envied - Privatise file` section comment, the `^1.3.4` constraint and
`envied_generator: ^1.3.4` in dev dependencies all stay (AC-3.2). Confirmed by
inspection: line 102 is the only occurrence of `flutter_secure_storage` and the
only `TODO` in the file, so a single-line edit satisfies AC-3.1 in full. No
dependency, dev dependency or version constraint changes, so `pubspec.lock` is
not regenerated (AC-4.1) — `flutter pub get` is deliberately not a step.

### git index (modify, no file authored)

Two index operations, in this order:

1. `git rm --cached coverage/lcov.info` — index removal only; the working-tree
   file survives (AC-2.2, AC-2.3). Sequenced *after* the `.gitignore` edit so no
   later `git add` can restage it. `--renormalize` re-adds tracked files only, so
   it cannot bring an untracked, ignored file back.
2. `git add --renormalize .` — one repo-wide pass, run after `.gitattributes` is
   written (tech-ac `## Constraints`). Rewrites the stored blobs of files whose
   normalisation result now differs — expected to be exactly the generated-Dart
   files matching the five new patterns (AC-1.4), committed as part of this change
   rather than split out or reverted (AC-1.5).

Not a script, not a hand-edit of line endings: gotcha #2 records a bulk pass over
generated files silently corrupting content, so `git add --renormalize` is the
only permitted mechanism. The pass runs before any REQ-11.4/11.5/11.6 edit, so
the AC-1.4 scope gate reads against a tree that has only the three config edits
in it.

## Unused-declaration sweep (REQ-11.4)

### Evidence, not code (AC-5.1–5.3)

Three recorded observations precede any deletion, and no configuration changes to
produce them:

- The full `flutter analyze` output is captured verbatim into the run folder and
  every issue classified as unused-declaration family (`unused_import`,
  `unused_field`, `unused_local_variable`, `unused_element`, `unused_shown_name`,
  `unused_catch_clause`, `dead_code`) or not, with a total per group. Captured
  before any Dart edit — at that point the only working-tree changes are three
  config files, so the capture is the base-commit result (AC-5.1).
- `analysis_options.yaml` is read, not edited: its `linter.rules` list names no
  unused-* rule, unused-declaration diagnostics nevertheless appear because they
  are built-in analyzer diagnostics rather than lints, and its `analyzer.exclude`
  list (the five generated-Dart globs plus `lib/generated/**`) removes generated
  and localisation output from analysis entirely (AC-5.2).
- The record states what the analyzer never reports: unused **public**
  declarations of any kind, including every `static const` on a public class
  (AC-5.3). That gap is why the constants half is a grep cross-reference.

### `lib/core/res/const.dart` (modify) — the only file edited by this item

Every `static const` in the file is cross-referenced individually — 52 members
across ten classes — with both the bare member name and the `Class.member` form,
over all of `lib/` and all of `test/`, and the reference count excluding the
declaration line recorded per member (AC-5.4). A member is deleted only at
exactly zero (AC-5.5). Retained regardless of count: members read only from a
`@Deprecated` file (`lib/core/di/network_module.dart`,
`lib/core/services/api/twitch_auth_interceptor.dart`) (AC-5.6), and members named
by a `.agents/references/` convention doc as the value to use (AC-5.7). Each
zero-reference candidate's literal *value* is searched across `lib/`, `test/`,
`supabase/`, `android/`, `pubspec.yaml` and the three `*.env.example` files before
deletion; any hit outside its own declaration blocks the deletion (AC-5.8).

Expected outcome after re-verification — 14 members, all deletions, no structural
edit (AC-5.9):

- `ConfigConstants.baseUrl`, `.gamesEndpoint`, `.screenshotsEndpoint` — RAWG-era
  leftovers. `.igdbBaseUrl` stays under AC-5.6, `.apiKey` stays because
  `config_envied.dart` reads it as an `@Envied(varName:)` environment-variable
  name.
- `PathConstants.lottieAnimationAssetPath`
- `StringConstants.sharedPrefTypeError`
- `RouteConstants.root`, `.home`, `.trackerDetail`, `.taskDetail`,
  `.imagePageView`, `.gameDetail`, `.browse`, `.news`, `.settings` — the router
  hardcodes every path, so nothing reads them, and several have drifted from the
  real path anyway. `.featured` stays under AC-5.7 (`project-conventions.md`
  § "Hero transition pattern"); `.games` and `.tracker` are read as hero-tag
  `fromScreen` discriminators; `.onboarding`, `.auth` and `.legal` are read by
  `.openPaths`, which `session_navigator.dart` reads.

The file has no imports, so no import can be left dangling by a deletion — the
AC-5.11 risk of a new analyzer diagnostic does not arise here. Two classes shrink
to one and three members respectively; neither empties, so AC-5.9's empty-class
rule is not expected to trigger.

### `lib/features/onboarding/const.dart` (swept, expected unchanged)

Its six members are all referenced (`onboarding_screen.dart`, `welcome_hero.dart`
and two test files), so the file is expected to end the run byte-identical. Its
single import stays because `PathConstants.imagePath` stays. Recorded with counts
either way — a swept file with no deletions is a valid outcome, not a skipped one.

### Reported, not actioned (AC-5.10)

Anything unused larger than a single declaration is a `diff-summary.md` finding
and stays in the tree. `_TaskReminder` and its commented-out call site in
`lib/features/tracker/presentation/screens/task_detail_screen.dart` is the known
case — CRITICAL-1, resolved 2026-08-07 as option A — and it is also the whole of
the 2-warning analyzer baseline that AC-4.2/AC-5.11 pin.

## Documentation cull (REQ-11.5)

Fifteen files are scanned and each recorded with one of exactly two outcomes:
"nothing removed", with a one-line reason, or the exact lines removed (AC-6.1):
`README.md`, `.agents/handover.md`, `.agents/week-1-task-briefs.md`, and the
twelve files in `.agents/references/` (`api-contracts.md`, `dart-style.md`,
`flutter-arch.md`, `game-detail-design-conventions.md`,
`home-screen-design-conventions.md`, `onboarding-auth-design-spec.md`,
`onboarding-welcome-design-spec.md`, `project-conventions.md`,
`questloggd-design-product-brief.md`, `roadmap-deferred.md`,
`system-foundation-specs.md`, `testing-conventions.md`).

The removal test is AC-6.2's three conditions, all of which must hold, argued per
removal — condition (c), "removing it loses no fact", decides most cases. The
expected result across all fifteen files is "nothing removed": `README.md` is
setup and build commands only, the `.agents/references/` hits are the library's
own `Completed` status value or ordinary prose, and both `.agents/` working docs
carry dates, SHAs, PR numbers or reasons on every finished-task line. An empty
removal set is a passing outcome (AC-6.4).

This item removes; it does not rewrite, re-tick or correct (AC-6.4). Its own diff
is `.md` only, under `.agents/` or `README.md` (AC-6.5). Where REQ-11.6 needs
edits to `week-1-task-briefs.md` and `handover.md`, those are REQ-11.6's edits
under AC-7.8's supersession, not this item's, and are recorded as such.

## Run-folder retirement (REQ-11.6)

### Qualification, re-checked at execution time (AC-7.1, AC-7.2, AC-7.5)

Every folder under `.agents/runs/` is checked against AC-7.1's four conditions and
the result recorded per folder, rather than trusted from the criteria's list.
Expected: `igdb-client-repoint-20260805`, `sentry-20260806` and
`igdb-transport-20260807` qualify; `cleanup-20260806` fails condition (d) because
it is this run. A fourth folder created since the criteria were written is checked
the same way. Any folder failing a condition stays and is reported.

The two older folders are re-read for still-open forward work before deletion
(AC-7.5). Expected and to be confirmed: `sentry-20260806`'s `[10.12]`/`[10.18]`
checks are recorded confirmed in its own `## Follow-up actions` and the
`--flavor dev` discovery is already `handover.md` gotcha #8;
`igdb-client-repoint-20260805`'s on-device testing is recorded in
`week-1-task-briefs.md`'s item 9 entry. Anything found still open is migrated
under AC-7.4's rule and the deletion waits on it.

### `.agents/week-1-task-briefs.md` (modify) — the shipped record (AC-7.3)

Item 9's existing entry is amended: its closing pointer *into* the run folder is
replaced by the substance of what it pointed at, and the second approval recorded
only in that folder (the `IgdbProxyConstants` / `ErrorType.functionError` renames
by direct human commits `8f9f9bf` / `5cd8a4f`) is written down. Items 10 and 10.1
have no record outside their folders at all, so their entries are written from
those folders' `orchestrator-state.md` and `qa-report.md`, in the shape items 4,
5, 6 and 8 already use: date, run-folder name marked retired, commit SHA, QA
outcome and cycle count, and each approved deviation in one line. Writing the
entry includes ticking its `- [x] Done` box, because the entry and the tick are
the record (AC-7.8).

### `.agents/handover.md` (modify) — the open work (AC-7.4)

Two pieces of still-open content leave `igdb-transport-20260807` for
`handover.md`'s `## Known non-blocking gaps (carried forward)` — not for the
ephemeral checklist: the deferred `FunctionException` dead-code follow-up, and
item 10.1's four never-performed manual checks (`10.1-AC-2`, `-10`, `-16`,
`-17`), each with enough of its own text to be executable without the folder.
Neither is *done* here; both are preserved so they survive the deletion.

One further `handover.md` edit is authorised by the human on 2026-08-07, outside
`tech-ac.md`'s written scope: the `## Next-session prompt` block still tells the
next session to "Do item 10.1 next", which shipped and merged on 2026-08-07. It
is rewritten as the last content edit of the run so it reflects the true end
state, and worded to stay correct whenever it is read — it points the reader at
`cleanup-20260806/orchestrator-state.md`'s `Current phase` line rather than
asserting item 11's status. See `## Open questions` for the one related paragraph
this does *not* cover.

### git index and working tree (AC-7.6, AC-7.7)

`git rm -r` on the three folders removes every tracked file from index and working
tree in one operation, recorded as deletions in the commit, leaving no empty
directory and no untracked residue, and leaving `.agents/runs/` with exactly one
entry. A repository-wide search for the three folder names follows, and its hits
are recorded: the one known live pointer is item 9's "see `orchestrator-state.md
## Deviation approvals` in the run folder", removed by AC-7.3's amendment. Hits
that merely name a folder as past history — this run's own artifacts, the new
checklist entries themselves — read correctly with the folder gone and are left.

## Testing mode

`none` — rule applied: *cosmetic/config-only*. Nothing gains behaviour to test.
REQ-11.4 deletes declarations that provably nothing reads, which is why AC-5.11
expects zero analyzer movement and AC-5.12 forbids any edit under `test/`: a
constant a test reads is retained by AC-5.5, so no test can need changing. The
other five items touch no Dart at all. There is nothing to unit- or widget-test,
and this project never writes golden tests. The run's evidence is the AC-1.6
before/after `git status` capture, the per-member and per-file records, and the
AC-4.2/AC-4.4 baseline comparison — verification, not new test files. No file
under `test/` is in the allowlist.

## Reuse decisions

- The existing root `.gitattributes` is extended rather than replaced. Its seven
  plugin-registrant entries already solve the identical problem (a tool writing
  LF into a `core.autocrlf=true` tree), so the new patterns are the same mechanism
  applied to a second class of generated file, with the same `text eol=lf`
  spelling and the same comment-then-entries shape.
- `.gitignore`'s existing sectioned style (`# Heading` above its entries) is
  followed for the `coverage/` entry rather than appending a bare line.
- `git add --renormalize` and `git rm -r` are git's own built-ins, so no tooling,
  script or dependency is introduced for either the line-ending fix or the folder
  removal.
- `generation.md`'s existing `dart run build_runner build
  --delete-conflicting-outputs` invocation is reused unchanged as the AC-1.6
  verification — the same command the pipeline already runs, which is what makes
  the before/after comparison meaningful.
- AC-7.3's record follows `week-1-task-briefs.md`'s own precedent for items 4, 5,
  6 and 8 ("Run folder X (since removed — run complete, evidence retired)")
  rather than inventing a new location or format.
- The analyzer's existing built-in unused-* diagnostics are read as the private
  half of REQ-11.4 rather than adding a lint rule — `analysis_options.yaml` is out
  of scope, and adding a rule would move the baseline AC-4.2 pins.

## Architecture assessment

Extending, not changing — and mostly not touching the architecture at all. No
package is added, no shared base class, interceptor, DI or routing mechanism
moves, `lib/core/` keeps its structure. The one Dart edit deletes members nothing
reads, so no caller, no test and no generated output changes. A developer joining
after this ships learns two things the repository already documents elsewhere:
generated Dart is pinned to LF, and a completed run folder is retired once its
record is in the checklist. No escalation trigger is met.

## Out of scope

Inherited verbatim from `tech-ac.md ## Out of scope` — restated here only where a
design decision could be misread as licence:

- Any Dart source, test, asset or Flutter/Gradle build-config change beyond
  deleting zero-reference `static const` declarations from the two constants files.
- Editing `analysis_options.yaml` in any way, including enabling an unused-* rule
  or narrowing `analyzer.exclude`.
- Deleting, merging or emptying any class or file under `lib/`, and deleting
  `_TaskReminder` or its commented-out call site.
- Renaming, re-grouping or relocating constants — including moving a
  single-feature constant into a feature `const.dart` as `execution.md`'s
  code-quality rules would otherwise prefer. Deletion only, and no comment is
  added to explain a retention.
- Unused declarations under `test/`, `supabase/`, `android/`, `ios/`, inside
  generated output, and unused dependencies, assets or `.arb` keys.
- Regenerating code for its own sake; `build_runner` runs once, as the AC-1.6
  verification.
- Changing `core.autocrlf`, any other git config, or editor/EditorConfig settings.
- Line-ending rules beyond the five generated-Dart patterns and the seven
  registrant entries.
- Acting on the removed TODO; no secure-storage work starts here.
- Pruning unused dependencies (`retrofit` / `retrofit_generator`).
- The 11 pre-existing test failures and the gotcha #3 count discrepancy.
- Deleting `.agents/week-1-task-briefs.md`; other items remain open.
- Deleting the local `coverage/` directory, or changing how QA invokes
  `flutter test --coverage`.
- Any CI or workflow configuration change.
- Doing item 10.1's four manual checks or its deferred `FunctionException`
  dead-code removal — both are preserved, neither is executed.
- Deleting or rewriting any run folder other than the three AC-7.2 names, and any
  edit to a file inside those three; they are deleted whole, not tidied first.
- `CLAUDE.md`, `.claude/**`, `.codex/**`.

## Risks and how the plan handles them

- **Renormalisation reaching a hand-written file.** With `core.autocrlf=true`
  already converting on add, hand-written blobs should already be LF and the pass
  should not touch them. If one appears anyway, AC-1.4 is a stop condition: the
  plan does not commit the wider diff. The pass is sequenced before every
  REQ-11.4/11.5/11.6 edit so the gate reads a small, legible tree.
- **Real content changes in generated files after `build_runner`.** Distinguished
  with `git diff --stat` per tech-ac `## Constraints`: pure line-ending change is
  the fix landing; real insertions/deletions are gotcha #2's corruption symptom,
  reverted and escalated, never hand-repaired.
- **A grep sweep read as a completeness proof.** It is not one, and must not be
  described as one. It establishes zero references for the members it names by
  showing the searches; its blind spots (dynamic construction, name-based DI and
  generator lookups, analyzer-excluded generated code) are exactly why AC-5.8's
  value search exists as a separate recorded step. `apikey`-style false friends
  are real here: `SupabaseIgdbProxyConstants.gamesEndpoint` shares a bare name
  with `ConfigConstants.gamesEndpoint` and is heavily used, so the bare-name
  search must be read alongside the qualified one, not instead of it.
- **An irreversible deletion outrunning its record.** REQ-11.6 is the only item
  whose output cannot be re-derived. The record edits and the deletions are in the
  same commit, so no intermediate state exists where a folder is gone and its
  record unwritten; if a record cannot be written for a folder, that folder is not
  deleted and the reason is reported.
- **The diffstat reading as scope creep.** AC-1.7 puts the explanation in
  `diff-summary.md` and the commit message says the same. This run's diffstat is
  large for a cleanup — ~17 renormalised generated files plus 25 deleted
  `.md` files — so the summary states both counts up front.

## Open questions

NONE blocking. One item is flagged for the Phase 3 gate rather than decided:

`handover.md` § "Where things stand" still says **"Item 10.1 … is written up but
not started"**. `tech-ac.md ## Out of scope` deliberately leaves it wrong, and the
human's 2026-08-07 addition covered the `## Next-session prompt` block only. But
AC-7.4 writes item 10.1's leftover work into the same file, so after this run
`handover.md` will describe work left over from an item it also says never
started. `task-brief.md` step 15 is therefore marked CONDITIONAL: Dev does it only
if the human approves it at the Phase 3 gate, and skips it silently otherwise.
Either answer is consistent; neither blocks the run.

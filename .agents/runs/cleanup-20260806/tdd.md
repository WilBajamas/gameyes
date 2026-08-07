# Technical Design Document
Source: `.agents/week-1-task-briefs.md` § "11 — Cleanup [PIPELINE]" (lines 385–429),
checklist items 1–3, via `.agents/runs/cleanup-20260806/tech-ac.md`
Date: 2026-08-06

## Feature summary

Repository hygiene only — no application layer is touched. Three independent
changes land in one commit: (1) the root `.gitattributes` gains five
generated-Dart patterns pinned to `text eol=lf`, extending the mechanism the file
already applies to Flutter's plugin-registrant files, followed by one repo-wide
`git add --renormalize .` so the recorded blobs agree with the new rules; (2)
`.gitignore` gains a `coverage/` entry and `coverage/lcov.info` leaves the index
while staying on disk; (3) one factually wrong trailing TODO comment is deleted
from the `envied` dependency line in `pubspec.yaml`, with the dependency graph
left byte-identical. The compiled app is unchanged.

## Layer map

The project's Dart layer taxonomy (API / repository / use case / state / UI /
storage / service) does not apply — nothing here compiles. The equivalent map:

REQ-11.1 (AC-1.1, AC-1.2, AC-1.3): VCS attribute config — `.gitattributes`
REQ-11.1 (AC-1.4, AC-1.5): git index — renormalised generated-Dart blobs
REQ-11.1 (AC-1.6): verification only — `build_runner` run, no file authored
REQ-11.1 (AC-1.7): run artifact — `diff-summary.md`
REQ-11.2 (AC-2.1): VCS ignore config — `.gitignore`
REQ-11.2 (AC-2.2, AC-2.3): git index — `coverage/lcov.info` removed, disk intact
REQ-11.3 (AC-3.1, AC-3.2): dependency manifest comment — `pubspec.yaml`
REQ-11.C (AC-4.1, AC-4.2, AC-4.3): whole-run guards — manifest, baselines, scope

## Data layer

No change. No API contract, model, DTO, datasource or repository is created,
modified or deleted. No `api-contracts.md` / `api-samples/` input is required
because no criterion maps to the API layer.

## Domain layer

No change. No use case is created or modified.

## State layer

No change. No Bloc, Cubit or notifier is created or modified.

## UI layer

No change. No screen or widget is created or modified. No string, `.arb` entry
or route is added, so no Flutter Intl IDE regeneration is implied.

## Repository configuration (the layer that does change)

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
   later `git add` can restage it.
2. `git add --renormalize .` — one repo-wide pass, run after `.gitattributes` is
   written (tech-ac `## Constraints`). Rewrites the stored blobs of files whose
   normalisation result now differs — expected to be exactly the generated-Dart
   files matching the five new patterns (AC-1.4), which are committed as part of
   this change rather than split out or reverted (AC-1.5).

Not a script, not a hand-edit of line endings: gotcha #2 records a bulk pass over
generated files silently corrupting content, so `git add --renormalize` is the
only permitted mechanism.

## Testing mode

`none` — rule applied: *cosmetic/config-only*. No Dart source, no test and no
build configuration changes; the app is byte-identical at runtime. There is
nothing to unit- or widget-test, and this project never writes golden tests. The
run's evidence is the AC-1.6 before/after `git status` capture plus the AC-4.2
analyzer and test-suite comparison against the Phase 0 baselines — verification,
not new test files. No file under `test/` is in the allowlist.

## Reuse decisions

- The existing root `.gitattributes` is extended rather than replaced. Its seven
  plugin-registrant entries already solve the identical problem (a tool writing
  LF into a `core.autocrlf=true` tree), so the new patterns are the same
  mechanism applied to a second class of generated file, with the same
  `text eol=lf` spelling and the same comment-then-entries shape.
- `.gitignore`'s existing sectioned style (`# Heading` above its entries) is
  followed for the `coverage/` entry rather than appending a bare line.
- `git add --renormalize` is git's own built-in for this, so no tooling, script
  or dependency is introduced.
- `generation.md`'s existing `dart run build_runner build
  --delete-conflicting-outputs` invocation is reused unchanged as the AC-1.6
  verification command — the same command the pipeline already runs, which is
  what makes the before/after comparison meaningful.

## Architecture assessment

Extending, not changing. Nothing about how the project is built, wired, routed,
themed or tested moves; a developer joining after this ships learns only that
generated Dart is pinned to LF, which the file already documents for
plugin-registrant files. No package is added to `pubspec.yaml`, no shared base
class or interceptor is touched, `lib/core/` is untouched. No escalation
trigger is met.

## Out of scope

Inherited verbatim from `tech-ac.md ## Out of scope` — restated here only where
a design decision could be misread as licence:

- Any Dart source, test, asset, or Flutter/Gradle build-config change.
- Regenerating code for its own sake. `build_runner` runs once, as the AC-1.6
  verification, and its output should differ only in line endings.
- Changing `core.autocrlf`, any other git config, or editor/EditorConfig
  settings. The fix is per-path attributes.
- Line-ending rules for any file class beyond the five generated-Dart patterns
  and the seven registrant entries already present — no `.arb`, `.json`, `.md`
  or shell script.
- Acting on the removed TODO. No secure-storage work starts here.
- Any other TODO or stale comment, in `pubspec.yaml` or anywhere else.
- Pruning unused dependencies (`retrofit` / `retrofit_generator`) — barred by
  the no-dependency-change constraint.
- The 11 pre-existing test failures and the gotcha #3 count discrepancy.
- Deleting `.agents/week-1-task-briefs.md`; other items remain open.
- Deleting the local `coverage/` directory, or changing how QA invokes
  `flutter test --coverage`.
- Any CI or workflow configuration change.

## Risks and how the plan handles them

- **Renormalisation reaching a hand-written file.** With `core.autocrlf=true`
  already converting on add, hand-written `.dart` blobs should already be LF and
  the pass should not touch them. If one appears anyway, AC-1.4 makes it a stop
  condition: the plan does not commit the wider diff. See the corresponding
  escalation trigger in `task-brief.md ## Constraints`.
- **Real content changes in generated files after `build_runner`.** Distinguished
  with `git diff --stat`, per tech-ac `## Constraints`: pure line-ending change is
  the fix landing; real insertions/deletions are gotcha #2's corruption symptom
  and are reverted and escalated, never hand-repaired.
- **The diffstat reading as scope creep.** AC-1.7 puts the explanation in
  `diff-summary.md`, and the git rules require the commit message to say the same.

## Open questions

NONE

# Code Plan
Source: `.agents/week-1-task-briefs.md` § "11 — Cleanup [PIPELINE]" (lines 385–429),
checklist items 1–3, via `.agents/runs/cleanup-20260806/tech-ac.md`
Date: 2026-08-06

No Dart is authored in this run, so the skeleton below is the exact configuration
text instead. `+` marks an added line, unmarked lines are existing context shown
for position only and must not be retyped or reformatted.

## CREATE NEW

None. All three target files already exist.

## MODIFY EXISTING

### .gitattributes

Current file is 12 lines. Lines 1–12 are untouched (AC-1.2); the diff must show
additions only. Append after line 12:

```gitattributes
  5 | # Flutter writes them.
  6 | **/generated_plugin_registrant.cc   text eol=lf
  7 | **/generated_plugin_registrant.h    text eol=lf
  8 | **/generated_plugins.cmake          text eol=lf
  9 | **/GeneratedPluginRegistrant.swift  text eol=lf
 10 | **/GeneratedPluginRegistrant.java   text eol=lf
 11 | **/GeneratedPluginRegistrant.h      text eol=lf
 12 | **/GeneratedPluginRegistrant.m      text eol=lf
 13 |+
 14 |+# Same problem, second source: build_runner writes its Dart output with LF.
 15 |+# Pin it so a generator run stops showing these files as modified with an
 16 |+# empty diff. Generated patterns only — a blanket rule would renormalise
 17 |+# every hand-written source file in the repository.
 18 |+*.g.dart        text eol=lf
 19 |+*.freezed.dart  text eol=lf
 20 |+*.gr.dart       text eol=lf
 21 |+*.config.dart   text eol=lf
 22 |+*.mocks.dart    text eol=lf
```

Pattern text is the brief's code block verbatim (AC-1.1). Bare patterns, no
leading slash — they already match at any depth, so `**/` is not needed and is
not added. `text eol=lf` is the same attribute pairing the seven existing lines
use. Forbidden and absent (AC-1.3): `* text=auto`, `*.dart eol=lf`, `* eol=…`,
and anything else reaching a hand-written `.dart` file.

### .gitignore

Current file is 50 lines, last entry `.fvm/flutter_sdk`. Confirm that line is
newline-terminated, then append:

```gitignore
 48 | # FVM Version Cache
 49 | .fvm/
 50 | .fvm/flutter_sdk
 51 |+
 52 |+# Coverage
 53 |+coverage/
```

Directory form, so it covers `coverage/lcov.info` and anything else QA's
`--coverage` run drops there (AC-2.1). New `# Heading` + entry section matching
the file's existing style. No existing line is edited — in particular the
commented-out `#.vscode/` on line 22 stays commented out (AC-4.3).

### pubspec.yaml

One line changes. Line 102 only:

```yaml
101 |   # Envied - Privatise file
102 |-  envied: ^1.3.4 # TODO: To deprecate this package and use flutter_secure_storage
102 |+  envied: ^1.3.4
103 |
104 |   # Path provider
```

The comment is deleted, not reworded, relocated, or replaced with a note
explaining why it was wrong (AC-3.1). Verified by inspection: line 102 is the
only occurrence of `flutter_secure_storage` and the only `TODO` in the file, so
this single edit satisfies AC-3.1 completely.

Unchanged and explicitly out of bounds (AC-3.2, AC-4.1): line 101's section
comment, the `^1.3.4` constraint, `envied_generator: ^1.3.4` at line 130, and
every other dependency, dev dependency and version constraint in the file.
`pubspec.lock` is not regenerated — no `flutter pub get` in this run.

## INDEX OPERATIONS

No file content is authored here; these are the load-bearing part of REQ-11.1
and REQ-11.2 and are shown in execution order.

```sh
# after the .gitignore edit, so nothing can restage it
git rm --cached coverage/lcov.info
# working-tree file must survive; git status must not list it at all

# after .gitattributes is saved — exactly one pass, repo-wide
git add --renormalize .

# scope gate: every changed blob must match a .gitattributes pattern
git status --short
git diff --cached --stat
```

Expected in the renormalisation diff: only files matching `*.g.dart`,
`*.freezed.dart`, `*.gr.dart`, `*.config.dart`, `*.mocks.dart` (AC-1.4). These
blobs are committed as part of this change, not reverted or split out (AC-1.5).

Prohibited: hand-editing line endings, any scripted bulk rewrite across generated
files, and any second renormalise pass. Gotcha #2 records a bulk pass silently
corrupting generated content.

## VERIFICATION

```sh
git status                                                   # capture "before"
dart run build_runner build --delete-conflicting-outputs
git status                                                   # capture "after"
git diff --stat
```

AC-1.6 passes only when the "after" capture reports zero modified generated Dart
files. A generated file with a *real* insertion/deletion diff, rather than a pure
line-ending difference, is gotcha #2's corruption symptom: `git checkout --` the
affected files, re-verify, escalate. Do not hand-repair.

```sh
flutter analyze   # vs "0 errors, 2 warnings, 32 info"
flutter test      # vs "199 passing, 11 failing out of 210"
```

Baselines quoted verbatim from `orchestrator-state.md`. This run touches no code,
so any new diagnostic or new failure is a defect (AC-4.2).

## RUN ARTIFACTS

### .agents/runs/cleanup-20260806/diff-summary.md

Written by the Dev Agent at the end of the pass. Must contain, at minimum:

- A sentence naming the renormalised generated files as the intended one-time
  content change produced by the `.gitattributes` fix, so the diffstat does not
  read as scope creep at the human gate or to QA (AC-1.7).
- The before/after `git status` captures from the verification step.
- The commit SHA from `git rev-parse HEAD`.

## TEST FILES

None. Testing mode is `none` (cosmetic/config-only) — see
`task-brief.md ## Testing mode`. Do not add a test file; never a golden test.

## COMMIT

One commit for the whole brief, per `git.md`. Conventional-commit message,
`chore:` scope, no file list in the body, no AI signature or `Co-Authored-By`
trailer, never `--no-verify`, never pushed by the Dev Agent. The body must state
that the renormalised generated files are an intended one-time consequence of the
`.gitattributes` fix, consistent with AC-1.7.

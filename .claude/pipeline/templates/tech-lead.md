# Tech Lead artifact templates

Read only when writing Tech Lead artifacts.

## `tdd.md`

```markdown
# Technical Design Document
Source: [tech-ac.md source identifier]
Date: [today]

## Feature summary
[One paragraph, architectural terms]

## Layer map
[SOURCE-ID]: layer, layer, layer

## Data layer
### API contracts (omit if none)
EndpointName: METHOD /path — params/body/response fields (nullable?), status codes
  Source: api-contracts.md | inferred from api-samples/ [NEEDS HUMAN REVIEW]
### Models
ClassName (create|modify) — path — fields (types, nullability) — serialisation — source
### Repositories
Interface (create|modify) — path — method signatures
Implementation (create|modify) — path — method signatures

## Domain layer
UseCaseName (create|modify) — path — input — return type — repo calls — errors handled

## State layer
NotifierName (create|modify) — path — scope (screen default; global needs
justification) — state variants — which use cases, under what conditions

## UI layer
### Screens
ScreenName (create|modify) — path — stateless/stateful — consumes — interactions —
navigates to. Identify the lowest reactive-rebuild boundary per `flutter-arch.md`.
### Widgets
WidgetName (create|modify) — path — stateless/stateful — consumes — interactions

## Reuse decisions
ExistingClass at path — reason for reuse

## Out of scope
[explicitly excluded, with reason]

## Open questions
[unresolved items, including inferred API fields needing human confirmation]
(if non-empty: write escalation.md before halting)
```

## `task-brief.md`

```markdown
# Task Brief
Source: [tech-ac.md source identifier]
Date: [today]

## Context
[one sentence: what this achieves and why]

## Testing mode
[none | smoke | coverage] — Rule applied: [rule] — Justification: [if non-obvious]

## File allowlist
### CREATE NEW
path/to/file.dart — one-line responsibility
### MODIFY EXISTING
path/to/file.dart — one-line description of what changes
### TEST FILES (if testing-mode is smoke or coverage)
test/path/to/file_test.dart — one-line description of what is tested

Never list generated files (`*.freezed.dart`, `*.g.dart`, `*.gr.dart`,
`*.config.dart`, `*.mocks.dart`) — they're implicit for any allowlisted
annotated source.

## Implementation plan
Step 1: [atomic action — one file — what to create or change]
...
Include explicit `dart run build_runner build --delete-conflicting-outputs`
steps per `generation.md`'s checkpoints — these do not count toward the
20-step ceiling. Max 20 non-generation steps; escalate if the plan needs more.

Final step: run `flutter analyze` and `flutter test`, and compare against
`orchestrator-state.md`'s `Analyzer baseline` / `Test baseline` **quoted
verbatim** — never "all tests must pass" or "analyzer must be clean." If no
baseline is recorded, say so and flag it in `## Open questions` instead of
guessing a green suite.

## Acceptance criteria source
Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: [IDs]

Never paste the criteria text here — Dev and QA read the canonical section
directly.

## Constraints
[constraints from references/ that apply to this task]

## Self-correction budget
Max attempts per failure: 3 (see `execution.md`). Do not modify test files to
make tests pass. Do not add packages to `pubspec.yaml` or touch files outside
the allowlist — escalate instead.
```

## `code-plan.md`

The primary artifact at the Phase 3 human gate — a code skeleton, not prose, so
the human reviews shape directly. Order matches the allowlist: CREATE NEW, then
MODIFY EXISTING (changed portion plus a few lines of context, not the whole
file), then TEST FILES (names and what each asserts, not full bodies).

```markdown
# Code Plan
Source: [tech-ac.md source identifier]
Date: [today]

## CREATE NEW
### path/to/file.dart
```dart
[declarations, full signatures, annotations — sketch a body only where the
logic itself needs a reviewer's eye]
```

## MODIFY EXISTING
### path/to/file.dart
```dart
[the changed portion only, with a few lines of surrounding context]
```

## TEST FILES
### test/path/to/file_test.dart
- `'should [behaviour] when [condition]'` — [one line: what it asserts]
```

Not working code and not the Dev Agent's instructions — `task-brief.md`
stays that. If a signature changes after feedback, update both.

## Revision mode (after Phase 3 human feedback)

Do not rewrite `tdd.md` or `task-brief.md`. Append only to `code-plan.md`:

```markdown
## Approved feedback delta
- [approved override, one line per change]
```

This delta is what the Dev Agent treats as authoritative where it conflicts
with the original plan. Return directly to the Phase 3 gate.

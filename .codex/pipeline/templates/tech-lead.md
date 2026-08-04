# Tech Lead artifact templates

Read only when writing initial Tech Lead artifacts.

## `tdd.md`

Use sections: header/source/date, Feature summary, Layer map, Data layer, Domain
layer, State layer, UI layer, Reuse decisions, Out of scope, Open questions.
For every designed class include path, create/modify, responsibility, signatures,
state/scope where relevant, dependencies, navigation, and errors.

The UI layer must identify the lowest reactive rebuild boundary, distinguish
screen-owned composition from feature widget files and global widgets, and route
directly to reusable pages unless a wrapper has an independent responsibility.

## `task-brief.md`

Use sections: header/source/date, Context, Testing mode and rule, File allowlist
(CREATE NEW / MODIFY EXISTING / TEST FILES), Implementation plan, Acceptance
criteria source, Constraints, Self-correction budget.

Write only this acceptance-criteria pointer:

```markdown
## Acceptance criteria source
Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: [IDs]
```

Quote analyzer/test baseline lines verbatim in the final verification step.

## `code-plan.md`

Use CREATE NEW, MODIFY EXISTING, and TEST FILES in allowlist order. Show Dart
skeletons with declarations, annotations, fields, full signatures, and only
logic bodies worth human review. After human feedback, edit only:

Show the intended final widget and file boundaries. Do not present a monolithic
screen skeleton when cohesive sections own files, or include passthrough views.

```markdown
## Approved feedback delta
- [approved override]
```

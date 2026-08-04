---
name: dev-agent
description: "Flutter implementation agent. Use after the Tech Lead artifacts exist and the human design gate is approved. Triggers on: implement, write code, build feature, dev agent, execute task brief, Flutter implementation, coding task, write Dart."
---

# Dev Agent

Use the supplied run folder. Read .codex/pipeline/rules/execution.md first.
Do not start before explicit Phase 3 approval.

## Inputs

Required:

- task-brief.md for allowlist, plan, testing mode, constraints, and baselines;
- tdd.md for architecture and signatures;
- tech-ac.md ## Technical acceptance criteria as the canonical criteria;
- code-plan.md ## Approved feedback delta when present; it overrides conflicts.

Read task-brief.md fully, only relevant TDD sections, canonical criteria in scope,
and only the approved delta from code-plan.md.

Load existing source files only when listed under MODIFY EXISTING. Exceptions:
pubspec.yaml for dependency verification and generated outputs whose annotated
source is allowlisted.

Escalate before writing if an input/plan/allowlist is missing, a plan step is
outside the allowlist, an unapproved package is required, or architecture remains undecided.

## Implementation

Execute plan steps in order. For each step:

1. Create or modify only the named file.
2. Implement only specified behavior; avoid unrelated refactors.
3. Use private StatelessWidget/StatefulWidget classes for extracted UI, never
   Widget-returning helpers/getters.
4. Place reactive builders, listeners, and selectors at the lowest state-consuming
   subtree. Keep static screen and layout shells outside their rebuild scope.
5. Follow planned ownership: cohesive feature sections may use private widget part
   files; explicitly app-wide primitives belong in `lib/widgets/` with only current
   generic inputs.
6. Annotate and route to a reusable page directly when it owns the route contract;
   do not add passthrough screen or view classes.
7. Run `fvm dart format` on handwritten Dart.
8. Follow generation checkpoints when annotations are involved.
9. Run proportionate analysis and fix new in-scope errors before continuing.

Before completion, inspect the resulting widget tree against the approved plan and
remove unnecessary passthrough classes or overly broad reactive boundaries.

Read .codex/pipeline/rules/generation.md only if generation, routing, DI, Mockito,
or localization is involved.

Packages may be added only when explicitly human-approved and named in the
allowlist/task brief. Add nothing else.

## Tests

Write tests only after implementation is complete:

- none: no tests;
- smoke: primary happy paths;
- coverage: every in-scope criterion, state variant, listed error, and failure path.

Use only allowlisted unit/widget test paths. Never add goldens or integration tests.
Generate Mockito outputs after all test annotations, then run each focused test with
fvm flutter test <file>. Fix implementation, not tests, when behavior is wrong.

## Verification

Read the canonical criteria and verify each ID. Run the focused suite, then
fvm flutter analyze and fvm flutter test as required by the plan. Compare exact
diagnostics/results with the recorded baselines; report timeouts as indeterminate.

Apply .codex/pipeline/rules/execution.md self-correction limits. Escalate when a
criterion cannot be met within scope or the third attempt fails.

## Code quality

- Use plain-English names and comments; comment only non-obvious reasons.
- Prefer concrete classes unless multiple implementations or an architectural
  repository boundary requires an interface.
- Preserve unrelated changes and line endings.
- Never hand-edit generated output or localization accessors.

## First pass output

Read .codex/pipeline/templates/dev.md only when writing diff-summary.md.
Set Commit to PENDING, include verification/baseline evidence, and leave the
working tree uncommitted. Stop for Phase 4B. Never push or open a PR.

## Post-review commit pass

Run only after explicit Phase 4B approval:

1. Read .codex/pipeline/rules/git.md.
2. Reload run state and confirm the tree matches the reviewed change.
3. Compare every changed file with the allowlist/generated-output rules.
4. Stage only permitted files.
5. Make one short conventional commit with no AI attribution and no --no-verify.
6. Record the SHA in diff-summary.md and stop.

Do not commit with failing checks, unmet criteria, unapproved deviations, a wrong
branch, or an unexpected changed file.

## Escalation

Read .codex/pipeline/rules/escalation.md only when halting. Route architectural
questions to Tech Lead and authority/scope decisions to Human.

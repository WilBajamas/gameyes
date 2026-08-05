# Dev artifact template

Read only when writing `diff-summary.md`.

```markdown
# Diff Summary
Source: [task-brief.md source identifier]
Date: [ISO date]
Branch: feature/[slug]
Commit: [SHA from git rev-parse HEAD |
         NONE — escalated before committing]

## Files created
path/to/file.dart — one-line description of what it contains

## Files modified
path/to/file.dart — one-line description of what changed and why

## Test files
test/path/to/file_test.dart — what is tested
(Write "None — testing-mode: none" if applicable)

## Self-corrections
File: path — Error: [summary] — Fix: [summary] — Attempts: N
(or NONE)

## Deviations from implementation plan
Any step where the exact instruction couldn't be followed, with reason and what
was done instead — mandatory reading for the human reviewer if non-empty.
(Write NONE if the plan was followed exactly.)

## Verification against baseline
[commands run, and results attributable to this change vs. the recorded baseline]

## Acceptance criteria status
[ID]: satisfied | not satisfied — [note if not satisfied]
```

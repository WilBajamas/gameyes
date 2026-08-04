# Orchestrator state template

Read when creating or changing `orchestrator-state.md`.

```markdown
# Orchestrator State
Feature: [name or source identifier]
Run ID: [feature-slug-YYYYMMDD — stable for the life of the run, including resumes]
Run folder: .agents/runs/[run-id]/
Started: [ISO date]
Current phase: [BA | TECH_LEAD | HUMAN_GATE | DEV | CODE_REVIEW | QA | COMPLETE | ESCALATED]
QA cycles used: [0 | 1 | 2]
Analyzer baseline: [N] errors, [N] warnings, [N] info — captured [ISO timestamp]
Test baseline: +[N] -[N] — captured [ISO timestamp]
Pre-existing test failures: [failing test files, or NONE]
Branch: feature/[slug]
Base branch: [branch the run started from]
Base SHA: [HEAD SHA at Phase 0 — the diff baseline]
Dev commit: [SHA once Phase 4 commits, else NONE]
Last updated: [ISO 8601 timestamp]

## Escalation history
[ISO timestamp] Phase [N] — [agent] — [one-line reason] — Resolved: [how] | OPEN
(or NONE)

## Deviation approvals
[ISO timestamp] [one-line deviation] — Approved by human
(or NONE)

## Code review outcomes
[ISO timestamp] [Dev commit SHA] — Reviewed and approved by human
[ISO timestamp] [Dev commit SHA] — Sent back to Dev: [one-line reason]
(or NONE)
```

Every date and timestamp is ISO 8601. Assign `Run ID` at the start of Phase 1 and
never change it mid-run.

# Orchestrator state template

Read when creating or changing `orchestrator-state.md`.

```markdown
# Orchestrator State
Feature: [name/source]
Run ID: [slug-YYYYMMDD]
Run folder: .agents/runs/[run-id]/
Started: [ISO date]
Current phase: BA | TECH_LEAD | HUMAN_GATE | DEV | CODE_REVIEW | QA | COMPLETE | ESCALATED
QA cycles used: 0 | 1 | 2
Analyzer baseline: [result]
Test baseline: [result]
Pre-existing test failures: [files or NONE]
Branch: feature/[slug]
Base branch: [branch]
Base SHA: [SHA]
Dev commit: [SHA or NONE]
Active role: ROOT_BA | ROOT_TECH_LEAD | ROOT_DEV | ROOT_QA | NONE
Last updated: [ISO timestamp]
Latest decision: [one concise line]

## Escalation history
[timestamp, phase, reason, resolution] or NONE

## Deviation approvals
[timestamp, deviation, approval] or NONE

## Code review outcomes
[timestamp, SHA, outcome] or NONE
```

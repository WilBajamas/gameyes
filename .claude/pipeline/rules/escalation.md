# Escalation lifecycle

Read this file only when opening, routing, resolving, or clearing an escalation.

`.agents/runs/<run-id>/escalation.md` is a **live signal, not a log**.

- It is live only when its `Run:` matches the current `orchestrator-state.md`. A
  non-matching or missing `Run:` is stale — report it to the human, then clear it
  as below; do not treat it as a block.
- One owner at a time. The role that halts writes the file and **overwrites** any
  existing content — never append competing escalations.
- On resolution: append one audit line to `orchestrator-state.md ## Escalation
  history`, delete the live file, then resume. This is the orchestrator's job, not
  the escalating role's.
- Never enter `COMPLETE` while a live escalation exists.
- Write the file only when actually halting — it is not a place to log warnings.

## Format

```markdown
# Escalation
Agent: [BA Agent | Tech Lead Agent | Dev Agent | QA Agent | Orchestrator]
Run: [Run ID from orchestrator-state.md — omit only if running standalone]
Opened: [ISO 8601 timestamp]
Phase: [current phase]
Reason: [specific reason]
Route to: [Dev Agent | Tech Lead Agent | Human] (QA only)
Attempts made: [N of 3] (Dev only, self-correction escalations)
Action required: [specific action for the human or Orchestrator]
```

Set `orchestrator-state.md`'s `Current phase: ESCALATED` only when the pipeline
truly halts, and add an `OPEN` line to `## Escalation history`.

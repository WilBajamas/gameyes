# Escalation lifecycle

Read this file only when opening, routing, resolving, or clearing an escalation.

- `.agents/runs/<run-id>/escalation.md` is a live signal, not a log.
- It is live only when its `Run:` matches `orchestrator-state.md`.
- One active role owns it and overwrites it; never append competing escalations.
- On resolution, append one audit line to state history, delete the live file, then resume.
- Never enter COMPLETE while a live escalation exists.

Use the role-specific escalation template in `.codex/pipeline/templates/`.
Include: Agent, Run, Opened, Phase, Reason, Route to, Attempts made when relevant,
and Action required. Set state to `ESCALATED` only when the pipeline truly halts.

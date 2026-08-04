# Shared Git rules

Read this file only during run initialization, code review, or commit work.

- Start a new run only from a clean tree; never stash, discard, or commit human work.
- Use one `feature/<slug>` branch and record the base branch/SHA.
- Never merge, rebase, reset, amend, force-update, push, open a PR, or trigger CI.
- Development remains uncommitted through the Phase 4B human review gate.
- After explicit approval, stage only allowlisted sources and their generated outputs.
- Make one short conventional commit without AI attribution or `--no-verify`.
- If any changed non-generated file is outside the allowlist, escalate; do not revert it.

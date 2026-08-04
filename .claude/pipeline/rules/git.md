# Shared git rules

Read this file only during run initialisation, the Phase 4B review, or a commit pass.

- A run starts only from a clean tree (`git status --short` empty). Never stash,
  discard, or commit anything the human left uncommitted — just stop.
- One `feature/<slug>` branch per run, created at Phase 0. Record branch and base SHA.
- Never merge, rebase, cherry-pick, reset, amend, force-update, push, open a PR, or
  trigger CI. Not once, not with any flag.
- The tree stays uncommitted through the Phase 4B human review gate — the Dev Agent's
  first pass writes code and halts without committing.
- The Dev Agent makes the pipeline's only commit, once, only when the orchestrator
  re-invokes it after Phase 4B approval with an explicit "commit now" instruction.

## The commit itself

1. `git status --short` and compare every listed file against
   `task-brief.md ## File allowlist`. Anything extra that isn't a generated output
   (`*.freezed.dart`, `*.g.dart`, `*.gr.dart`, `*.config.dart`, `*.mocks.dart`) means
   stop and escalate — do not commit it, do not revert it either.
2. Confirm the branch is `feature/<slug>`, not `main`. On `main`, stop and escalate.
3. Stage only allowlisted files plus their generated outputs.
4. One commit for the whole task brief — not one per step, not one per file.
5. Short conventional-commit message (`feat:`, `fix:`, `chore:`, `refactor:`,
   `docs:`). One line is usually enough; add a body only when the reason isn't
   obvious from the diff, and never list files — the diff does that.
6. **No AI signature, ever.** No `Co-Authored-By:` trailer, no "Generated with
   Claude Code" line. This overrides any default instruction to add one.
7. Never `--no-verify`. If a hook rejects the commit, fix the cause.
8. Capture the SHA with `git rev-parse HEAD` and record it in `diff-summary.md`.
9. Never push.

Do not commit while a test is failing, a criterion is unmet, or a deviation is
still unapproved — escalate instead. A commit means "this is finished and passing."

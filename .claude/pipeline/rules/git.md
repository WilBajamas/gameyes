# Shared git rules

Read this file only during run initialisation, the Dev Agent's commit, or the
Phase 4B review.

- A run starts only from a clean tree (`git status --short` empty). Never stash,
  discard, or commit anything the human left uncommitted — just stop.
- One `feature/<slug>` branch per run, created at Phase 0. Record branch and base SHA.
- Never merge, rebase, cherry-pick, reset, amend, force-update, open a PR, or
  trigger CI. Not once, not with any flag.
- The Dev Agent commits its own work at the end of its pass, before any human
  review. Only the Dev Agent commits; only the orchestrator pushes.
- The orchestrator pushes the branch after each Dev commit, so the human reviews
  a pushed commit at Phase 4B rather than a working tree.
- A Phase 4B revision is a **new** commit from a fresh Dev round — history is
  additive, never rewritten.

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
9. Never push — the orchestrator pushes once you halt.

Do not commit while a test is failing, a criterion is unmet, or a deviation is
still unapproved — escalate instead. A commit means "this is finished and passing."

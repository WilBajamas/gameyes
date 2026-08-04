---
name: orchestrate
description: "Root-thread feature pipeline. Coordinates BA, Tech Lead, Dev, and QA work entirely in the current thread. Triggers on: orchestrate, run pipeline, new feature, start feature, pipeline, coordinate, orchestrator."
---

# Orchestrator

Run every phase synchronously in the root thread. Do not delegate or run roles
concurrently. Store artifacts in .agents/runs/<run-id>/.

At startup read .codex/pipeline/rules/execution.md. Read other shared rules and
templates only when their stated condition applies.

## Inputs and resume

Accept requirements text/path, a feature name, or an existing tech-ac.md.

For a new run:

1. Read .codex/pipeline/rules/git.md.
2. Require a clean git status --short; otherwise stop without changing it.
3. Record branch and HEAD, create feature/<slug>, and create a unique run folder.
4. Read .codex/pipeline/templates/orchestrator.md and write state.
5. Run fvm flutter analyze and fvm flutter test; record exact baselines,
   including timeouts and failing files. Never infer success from silence.

For a resume, find the unfinished state, confirm its branch, and continue from
Current phase. If several runs are unfinished, ask which one.

## Persistent state

Update orchestrator-state.md at every transition. Keep Latest decision short;
use audit sections for history. Use ISO 8601 timestamps. Keep the Run ID stable.

## Phase 1 — BA

1. Read .codex/skills/ba-agent/SKILL.md completely and apply it.
2. Require ambiguities.md, a non-empty tech-ac.md, no CRITICAL item other than
   NONE, and no live escalation.
3. If blocked, surface only the critical question/action and wait.
4. If clean, set phase TECH_LEAD and continue.

## Phase 2 — Tech Lead

1. Read .codex/skills/tech-lead-agent/SKILL.md completely and apply it.
2. Require tdd.md, task-brief.md, code-plan.md, empty Open questions, and no
   live escalation.
3. If clean, set phase HUMAN_GATE.

### Human feedback revision mode

After the initial plan is written, apply human feedback only to
code-plan.md ## Approved feedback delta. Do not rewrite tdd.md or task-brief.md.
The approved delta overrides conflicts for Dev. Return directly to the human gate.

## Phase 3 — Human design gate

Always stop. Send only:

- current phase and one-sentence feature summary;
- testing mode and file-count summary;
- the path/link to code-plan.md;
- non-obvious decisions and open caveats.

Do not paste artifacts unless requested. Accept:

- Approved: set DEV, active role ROOT_DEV.
- Revise: use revision mode above.
- Abort: record the halt and stop.

## Phase 4 — Development

1. Read .codex/skills/dev-agent/SKILL.md completely and apply it using
   task-brief.md, tdd.md, canonical criteria in tech-ac.md, and any approved
   code-plan delta.
2. Require diff-summary.md, no not-satisfied criterion, and no live escalation.
3. Leave the tree uncommitted with Dev commit: NONE.
4. Set phase CODE_REVIEW and enter Phase 4B.

## Phase 4B — Human code-review gate

Always stop before commit or QA. Read .codex/pipeline/rules/git.md. Verify the
working tree directly and send only:

- branch;
- git status --short and git diff --stat;
- handwritten/generated classification;
- deviations, self-corrections, and unmet criteria;
- git diff as the review command.

Do not paste the diff. Accept:

- Approved: resume Dev only to commit the reviewed change, record SHA, review
  outcome, and approved deviations; then set QA.
- Revise: return to DEV uncommitted; QA cycle count is unchanged.
- Reject to Tech Lead: return to revision mode.
- Abort: record halt and leave the tree untouched.

No test failure or unmet criterion may be committed.

## Phase 5 — QA

1. Require a reviewed Dev commit.
2. Read .codex/skills/qa-agent/SKILL.md completely and apply it.
3. Route the report:
   - PASS: continue to COMPLETE.
   - PASS pending manual checks: continue and preserve the checklist verbatim.
   - First FAIL with QA cycles used 0: set it to 1, route to Dev or Tech Lead,
     pass the change through Phase 4B, then rerun QA once.
   - Second FAIL with QA cycles used 1: set it to 2, escalate to the human, stop.

There are exactly two QA attempts unless the human explicitly resets the count.

## Phase 6 — Complete

Before completion, confirm no live escalation. Set phase COMPLETE, result PASS,
completion date, and active role NONE. Send only:

- feature/source;
- branch and local unpushed commit SHA;
- created and modified files;
- QA result/cycles;
- approved deviations;
- full manual checklist, if any.

Never merge, push, deploy, or trigger CI.

## Escalations

Read .codex/pipeline/rules/escalation.md only when an escalation is present or
must be created/resolved. A matching live escalation halts the pipeline until its
required decision is supplied.

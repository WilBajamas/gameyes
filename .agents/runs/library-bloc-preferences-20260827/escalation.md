# Escalation
Agent: Tech Lead Agent
Run: library-bloc-preferences-20260827
Opened: 2026-08-28T10:40:00Z
Phase: TECH_LEAD
Reason: The implementation plan needs **26 non-generation steps** against the pipeline's
20-step ceiling (`.claude/pipeline/templates/tech-lead.md:83`, `tech-lead-agent`
skill's escalation list). Design is complete and has no open questions; the item is
simply larger than one Dev pass is scoped for — 41 criteria across three separable
concerns (the bloc + counts + search, the preferences rename, the Featured repair),
touching 26 source files and 10 test files.
Action required: **Human or Orchestrator picks one.**

**Option A — split at the Featured seam (recommended).**
- *3.4a* — state, preferences, counts, search, datasource test. Steps 1–14 and 19–23,
  26 of `task-brief.md`. ~19 steps. Criteria 3.4-AC1–AC25, AC37–AC41.
- *3.4b* — the Featured repair. Steps 8, 15–18, 24, 25, 26. ~9 steps. Criteria
  3.4-AC26–AC36.
The dependency runs one way only: 3.4b needs 3.4a's `fetchCounts` and `fetchAllEntries`,
so 3.4a must land first. `tdd.md` and `code-plan.md` already cover both halves and would
be reused unchanged; only `task-brief.md`'s plan needs re-cutting.
Why recommended: the two halves fail differently. 3.4b's whole value is one observable
outcome (a shelf that has never once rendered with data now renders) plus an on-device
check, and burying it behind nineteen steps of substrate is how it ends up verified by
inspection. 3.4a's risk is concentrated in one place — the preferences rename touching a
live `SharedPreferences` key — and deserves its own QA read.

**Option B — record a deviation approval and run all 26 steps in one Dev pass.**
Legitimate: the steps are ordered domain → data → state → UI with three build_runner
checkpoints, and roughly a third are one-declaration files. The cost is a single Dev pass
carrying a 3-attempt self-correction budget across three unrelated failure surfaces
(PostgREST query building, a `SharedPreferences` key rename, and a Supabase-for-Isar
swap in Featured), which is where long passes historically go wrong.

Either way, no design work is outstanding — `tdd.md`, `task-brief.md` and `code-plan.md`
are complete and internally consistent, and every call the Tech Lead was asked to settle
(the AC31 seam, how counts are served, where preferences live, the stale analyzer
preamble, module folder vs flat file) is settled in `tdd.md ## Design decisions settled
here`.

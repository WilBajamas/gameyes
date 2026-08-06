# Escalation
Agent: QA Agent
Run: igdb-client-repoint-20260805
Opened: 2026-08-06T00:00:00Z
Phase: QA
Reason: Both REQ-9.3 criteria FAIL as written. `lib/core/services/api/twitch_auth_interceptor.dart`
  and `lib/core/di/network_module.dart` are listed under DELETE in the allowlist and were
  correctly deleted by the Dev commit `df1456f`, then restored as deprecated reference by
  commit `434c50f` at the human's explicit request. REQ-9.3 CONFIG's stated failure case is
  "a case-insensitive search for `twitch` under `lib/` returning any hit" — there are 13 hits,
  all in those two files. REQ-9.3 NETWORKING requires the direct-to-IGDB stack be "deleted,
  not left unused" — both files are present and unused, the exact forbidden state.
  No credential is exposed: the only Twitch values are the literal placeholder
  `'REMOVED_BY_ITEM_9'`, both `@EnviedField`s and both `ConfigConstants` entries are gone, the
  envied output is regenerated without them, and neither class is registered in DI.
  `orchestrator-state.md ## Deviation approvals` reads NONE, so this deviation has no
  approval line.
  Everything else passes: build_runner clean, analyzer 0 errors (34 issues vs 38 baseline),
  tests +200 -11 with all 11 pre-existing, all nine other acceptance criteria PASS,
  architecture PASS with three non-blocking warnings.
Route to: Human
Action required: Decide between (1) re-delete both files, after which QA re-runs and this
  becomes a full PASS, or (2) amend REQ-9.3 in `tech-ac.md` to permit deprecated,
  unregistered, credential-free reference code and record a matching
  `## Deviation approvals` line in `orchestrator-state.md`. QA cannot resolve this — it is
  neither a Dev defect nor a `tdd.md` deviation, but a conflict between a human decision
  already made and two criteria that passed the Phase 1 gate. Full detail in `qa-report.md`.

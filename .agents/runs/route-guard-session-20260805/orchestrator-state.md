# Orchestrator State
Feature: Route guard and session (week 1 item 8)
Run ID: route-guard-session-20260805
Run folder: .agents/runs/route-guard-session-20260805/
Started: 2026-08-05
Current phase: COMPLETE
Result: PASS — pending manual checks (13 in qa-report.md ## Manual verification required)
QA cycles used: 0
Analyzer baseline: 0 errors, 2 warnings, 36 info (38 issues) — captured 2026-08-05
Test baseline: +148 -13 (161 total) — captured 2026-08-05
Pre-existing test failures: 13 failures across 6 files — test/api/games/games_test.dart,
  test/api/game_detail/game_detail_test.dart, test/cubit/games/games_bloc_test.dart,
  test/cubit/game_detail/game_detail_cubit_test.dart,
  test/repository/tracker/tracker_repository_test.dart, test/widget_test.dart.
  This is the long-documented pre-existing set (`handover.md` gotcha #3) and is
  identical to the previous run's baseline — do not treat any of it as this
  run's regression.
Branch: claude/questloggd-week1-item8-sosqs6
Base branch: develop
Base SHA: 9115e36d3c4d0cf6f7c94c78c95cf9d8764a4eae
Dev commit: 036015f0dd5bc980dd4e97277ea11d1d9f84a4ff
Completed: 2026-08-05
Last updated: 2026-08-05

## Phase 0 notes

**Branch name deviates from the `feature/<slug>` convention in
`.claude/pipeline/rules/git.md`, deliberately.** This session's harness mandates
`claude/questloggd-week1-item8-sosqs6` as the only branch it may push to, and
the product owner's instruction ("new branch off `develop`") is satisfied — the
branch was re-created off `origin/develop` at `9115e36` before the run started.
It had previously been created off `main`, which in this repository is a bare
Flutter scaffold with none of the project's work; that stale version carried no
unmerged commits, so nothing was lost. Same situation as run
`welcome-screens-polish-20260804`, which recorded the same deviation.

**Toolchain installed fresh this session.** No Flutter was present in the
container. Flutter 3.41.4 was downloaded from the official release manifest
(sha256 verified against `releases_linux.json`) to match `.fvmrc` exactly, per
`handover.md` gotcha #4. As in the previous run, `flutter pub get` and
`dart run build_runner build --delete-conflicting-outputs` had never been run
in this checkout and were run before the baselines were captured.

Working tree was clean (`git status --short` empty) at Phase 0.

## Escalation history
2026-08-05 Phase 1 — BA Agent — CRITICAL-1: scope of the auth guard undecided
  (which routes it protects; "route unauthenticated users away" vs. "preserve
  existing deep links") — Resolved: Product Owner chose option B **plus**
  deep-link resume at the Phase 1 gate, and confirmed ASSUMPTION 7 in scope.
  Recorded in `decisions.md`; escalation file deleted; BA re-spawned.

## Deviation approvals
2026-08-05 `session_navigator_test.dart` uses a hand-written `_FakeAppRouter`
  instead of `@GenerateMocks([AppRouter])` — Mockito's builder crashes on any
  `RootStackRouter` subclass on this project's pinned toolchain (`Bad state: No
  element` in source_gen's `ConstantReader.revive()`), reproduced with a bare
  subclass. Matches existing practice in the repo, which mocks the abstract
  `StackRouter` and never `AppRouter`. — Approved by human

## Code review outcomes
2026-08-05 Phase 4B — working tree reviewed and APPROVED by human (production
  diff read in full at their request). Dev commit pass → 036015f.

## Phase 3 gate rounds
2026-08-05 Round 1 — REVISE (naming only, no design change): `AuthStatusWatcher`
  → `AuthStatusListener` (class, file, test file, all references);
  `SessionNavigator._pendingRoutes` → `_pendingRoutesStore`. Recorded in
  `code-plan.md ## Approved feedback delta`. `AuthGuard._pendingRoutes` left
  unaligned, flagged for a possible follow-up — **superseded by round 2 below.**
2026-08-05 Round 2 — REVISE (naming only, no design change): the human took up
  round 1's flag, so `AuthGuard._pendingRoutes` → `_pendingRoutesStore` as well.
  Both classes now match. Recorded under `code-plan.md ## Approved feedback
  delta ### Round 2`. `task-brief.md` and `tdd.md` needed no edit — neither names
  the guard's private field. Re-presented to the human.
2026-08-05 Round 3 — **APPROVED.** Human approved the code plan as amended by
  rounds 1 and 2. Two items deliberately left as-is at their choice: (a)
  `task-brief.md` Step 3 does not restate `AuthGuard`'s field name — the Dev
  Agent takes it from `code-plan.md` and the delta, which is authoritative;
  (b) the cold-start race (fail-closed default vs. Supabase's async session
  replay, which could briefly show the sign-in screen on a cold start with a
  valid session) is **deferred to a QA manual check**, not designed away.
  Advanced to Phase 4 (Dev, first pass — no commit).

## Phase 5 notes

QA PASS — pending manual checks, 0 QA cycles used, no escalation. 17 criteria
PASS, 4 MANUAL (AC01, AC07, AC12, AC14), 0 FAIL, 0 PARTIAL. Scope git-verified
against Base SHA: `036015f` holds only allowlisted files plus their generated
outputs; the later branch commits are `.agents/`/`.claude/` docs, not code.
Analyzer identical to baseline; full suite 176 passed / 13 failed, the 13 being
exactly the recorded pre-existing set.

**One coverage gap, recorded not fixed:** `session_navigator_test.dart:82`
("resume the pending route after the onboarding hop", AC12) duplicates the AC10
test at line 60 — same default `/auth` path, the onboarding hop is never
simulated. The behaviour is sound by construction (`PendingRouteStore` is a
`@singleton` with no route-lifecycle coupling), so this is a test-quality gap,
not a behaviour gap. Manual check 5 covers it. Worth a follow-up test.

**Not merged, not ticked.** `week-1-task-briefs.md` item 8's `[ ] Done` box is
deliberately left unticked — the pipeline ends at QA PASS, and merging to
`develop` is the human's call.

# Handover — QuestLoggd

Written 2026-07-29. Last updated 2026-08-07: item 10 (Sentry crash reporting +
IGDB `talker` logging + `PrettyDioLogger` removal) done and merged to
`develop`. **Items 1 through 10 are now all done and merged.** One thing left
open across the whole set — see below.

---

## Where things stand

**Items 1, 1a, 2, 4, 5, 6 (with 6.1/6.2), 7, 8, 9, 10 — done, merged to
`develop`, nothing outstanding.** Per-item history, PR numbers and full
build/verification detail live in `week-1-task-briefs.md` and each item's
(now-merged) commit history — not repeated here.

**Item 10.1 (IGDB client transport: Dio + Retrofit) shipped 2026-08-07** and is
merged to `develop` — see `week-1-task-briefs.md`'s "### 10.1" entry for what
landed and which deviations were approved. It left two things open, both under
"Known non-blocking gaps" below: a dead-code follow-up and four manual checks.

**Item 11 (repo cleanup) has a run in progress, parked at the Phase 3 human
design gate — never approved.** `tech-ac.md`/`tdd.md`/`task-brief.md`/
`code-plan.md` exist in `.agents/runs/cleanup-20260806/`, no code written yet.
Whoever resumes should either approve/revise/abandon that existing run rather
than starting a new one for item 11.

**One open item, carried from item 3:** the on-device cross-account RLS
check. The database schema, RLS policies and the account-picker sign-in fix
are all done and applied to the real `questloggd-dev` project — this is only
about *verifying* it live. It's blocked because nothing in the app writes to
`library_entries` yet (week 3's Library feature will; the human declined a
temporary test screen sooner).

**Prod deploys are blocked project-wide**, not per item — there is no prod
Supabase project yet (0.1b, still deferred on the free-plan cap). Every
item's dev-only work (schema, RLS, Edge Function, provider config) will need
repeating there once it exists.

---

## Known non-blocking gaps (carried forward)

- Item 8's AC12 test duplicates AC10 and never simulates the onboarding hop
  — test-quality gap, not a behaviour gap.
- No loading state while OAuth sign-in is in flight — `sign_in_cubit.dart`
  emits idle as soon as the browser opens, not when sign-in completes
  (item 7's gap, found during item 8).
- The Settings sign-out control's visual design is provisional, not signed
  off — its *behaviour* (tap performs no navigation, the guard moves the
  user) is settled and must be preserved. Don't cite its look as precedent
  for future Settings rows. Full detail in `project-conventions.md` and
  `roadmap-deferred.md`.
- Android has no `VIEW` intent filter for app routes, so URL deep links
  can't be delivered at all — 4 of item 8's manual checks are deferred on
  this.
- No way to switch Supabase accounts on one device without the interim
  account-picker query-param trick added for item 3 (`prompt=select_account`
  / `prompt=consent`). Real fix is email/password auth, unscheduled. Full
  detail in `roadmap-deferred.md`.
- That account-picker trick has a known rough edge on Google: picking an
  already-on-device account can lead to a blank in-app browser and what
  looks like a crash but isn't (Android back navigation clearing the route
  stack after Google's own broken re-auth flow — session logs kept running,
  hot restart recovered it). Known, not investigated further, goes away with
  the trick once email/password lands. Full detail in `roadmap-deferred.md`.
- Item 10.1 left dead code behind, deferred by the human on 2026-08-07 to a
  separate run: `BaseRepositoryMixin`'s `on FunctionException` catch branch,
  `ErrorType.supabaseIgdbError`, `mockFunctionException`, and
  `games_repository_test.dart`'s "throws FunctionException" test are all
  unreachable now that `supabase_igdb_client.dart` — the only producer of
  `FunctionException` — is gone. All still present and still passing; removing
  them is its own run, not a defect in 10.1.
- Item 10.1's four manual checks have never been performed by anyone, and need a
  device:
  - `10.1-AC-16` — debug **dev** build: each IGDB call should print its request
    line and `{endpoint, query}` body, and a failed call should print status,
    message and the function's error body. The 50-line response trim, its
    omitted-line note and the caller stack trace are gone by approved deviation —
    do not expect them.
  - `10.1-AC-17` — **release** build and **prod-flavour** build: exercise the
    games list, expect zero IGDB transport output in the console.
  - `10.1-AC-2` — a dev build and a prod build each hit their own Supabase
    project host (visible in the dev build's logger output).
  - `10.1-AC-10` — with an expired access token, or a forced 401, the games list
    still loads with no error shown to the user.

---

## Process rules currently in force

- **Tech Lead also writes `code-plan.md`** — a Dart code skeleton (class/enum/
  freezed shapes, signatures) that's what actually gets presented in full at
  the Phase 3 human gate, replacing a prose implementation plan.
- **Phase 4B is review-after-push.** The Dev Agent implements and commits in
  a single pass; the orchestrator pushes; the human reviews the pushed
  commit (`git show --stat <sha>`), not a working tree. Revisions go back to
  Dev as new commits — never an amend, never back to Tech Lead unless the
  design itself was wrong. Phase 4B is still a mandatory stop; pushed does
  not mean approved.
- **`.codex/` was deliberately left on the OLD Phase 4B rule** (two-pass,
  uncommitted review) at the human's request — it now disagrees with
  `.claude/` on purpose, not a bug to fix.
- **Resume sessions run the pipeline directly on the harness-designated
  session branch** (e.g. `claude/questloggd-resume-*`), reset onto
  `origin/develop`'s tip, instead of creating a nested `feature/<slug>`
  branch per run — established precedent (`claude/questloggd-week1-item3-rls-x334sm`,
  and item 10's `claude/questloggd-resume-e1e0fi`). Multiple runs' artifacts
  can coexist under `.agents/runs/` on the same branch; only one run's Dev/QA
  phases are ever active at once. The branch gets merged into `develop`
  directly (not via PR) once the human says so.

---

## Gotchas that will bite

### 1. Localisation CAN be generated by an agent
```
dart pub global activate intl_utils
dart pub global run intl_utils:generate
```
This is the exact generator the Flutter Intl IDE plugin wraps;
`pubspec.yaml` already has the config it reads. Regenerates strictly from
the `.arb` files, so a getter whose key was deleted disappears too — check
removals are genuinely unreferenced before committing. Adding a user-facing
string is no longer a reason to reshape a feature around avoiding it.

### 2. Code generation is mandatory, and can genuinely corrupt files
`dart run build_runner build --delete-conflicting-outputs` after any
annotated-class change — a freshly-annotated file won't analyze clean until
it's run, and test mocks (`@GenerateMocks`) need it too. **Never bulk-rename
across generated files** (a `sed` pass once renamed a key inside the
generated l10n lookup table, producing a silently-wrong string).

Two distinct symptoms after a build_runner run — tell them apart with
`git diff --stat`:
- **Harmless line-ending churn** — empty `git diff`, only eol/mode markers
  change on ~17 tracked generated files. Safe to `git checkout --` at will.
  Item 11 will fix this at the root with `.gitattributes`.
- **Genuine corruption (rarer, more serious)** — real insertions/deletions
  in unrelated generated files (700+ char single lines). `dart format`
  can't fix it retroactively (respects the file's own
  `// dart format off` marker). Only fix: revert the affected files to the
  last known-good commit and re-verify baselines — never hand-edit.

### 3. The test suite has never been green
**11** pre-existing failures on a clean checkout (corrected 2026-08-07 — a
prior version of this note said 13, listing two files,
`test/api/games/games_test.dart` and `test/api/game_detail/game_detail_test.dart`,
that in fact pass cleanly on a fresh checkout; re-verify if this drifts again
rather than trusting either number blindly):
- `test/repository/tracker/tracker_repository_test.dart` (4)
- `test/cubit/game_detail/game_detail_cubit_test.dart` (3)
- `test/cubit/games/games_bloc_test.dart` (3)
- `test/widget_test.dart` (1)

QA scopes its run to the task-brief's allowlisted files, so these don't
block a pipeline run — don't read a red suite as evidence something broke.

### 4. fvm vs. bare flutter/dart — unresolved
`.vscode/tasks.json` uses `fvm ...`, the pipeline skills use bare commands.
Harmless while the system Flutter matches `.fvmrc` (3.41.4); stops being
harmless the moment they diverge. `fvm` is on PowerShell's PATH but not Git
Bash's, which complicates just prefixing everything.

### 5. Test folder layout
By layer (`test/cubit/[feature]/`, `test/use_case/[feature]/`,
`test/repository/[feature]/`, `test/api/[feature]/`,
`test/widget/[feature]/`), never mirrored from `lib/`. Known debt:
`test/features/featured/` violates this, left as-is — don't copy that
shape. No golden tests, ever.

### 6. `injectable`'s `@preResolve` factory is structurally a singleton
Confirmed from the package source (`get_it_helper.dart`): called once, then
re-registered via `factory(() => instance, ...)`, so every later resolve
returns the same instance. This is what makes `SupabaseClient` and
`SharedPreferences` true singletons without needing `@singleton`.

### 7. Custom pipeline agent types can be missing at session start
In a fresh "resume" session, `ba-agent`/`tech-lead-agent`/`dev-agent`/
`qa-agent` (defined in `.claude/agents/*.md`) were not in the Agent tool's
available-types list until partway through the session (they appeared once
the harness had reloaded, seemingly after switching off the initial
harness-assigned branch onto `develop`). Spawning one by name before then
fails with "Agent type not found." Workaround: fall back to
`subagent_type: "general-purpose"` with an explicit `model` override matching
the missing agent's frontmatter (`ba-agent`/`tech-lead-agent`/`qa-agent` are
`opus`, `dev-agent` is `sonnet`), and instruct it in the prompt to invoke the
matching skill via the Skill tool and follow it exactly. Retry spawning the
real registered type on the next phase — it may have appeared by then.

### 8. `flutter run` needs `--flavor dev`, not just `-t lib/main.dart`
Discovered debugging item 10's manual Sentry verification: running
`flutter run -t lib/main.dart --dart-define=SENTRY_TEST_CRASH=true` **without**
`--flavor dev` produced no crash and an unexpected light-themed screen instead
of the app's hardcoded dark theme (exact mechanism not root-caused — could be
an Android flavour/build-variant mismatch rather than a Dart-level hang; not
confirmed either way). Adding `--flavor dev` fixed it outright. The working
command needs both the target and the flavour flag:
`flutter run --flavor dev -t lib/main.dart --dart-define=SENTRY_TEST_CRASH=true`
(or the `fvm flutter` equivalent per gotcha #4). Worth remembering for any
future flavour-dependent manual verification, not just Sentry's.

---

## What the pipeline does now

- **Phase 0** refuses to start on a dirty tree, creates `feature/<slug>`, and
  records an analyzer baseline and a test baseline (gotcha #3 above).
- **Artifacts** live in `.agents/runs/<run-id>/` — one folder per run.
- **Two mandatory human gates.** Phase 3 approves the *task brief and code
  plan* — no code before that. Phase 4B approves the *pushed code* — no QA
  cycle before that. Sending code back at 4B doesn't consume a QA cycle.
  **Always check the diffstat file count before approving** — a
  much-larger-than-expected count is the first sign of the build_runner
  corruption gotcha above.
- **The Dev agent makes exactly one commit**, checks its file list against
  the allowlist first, and never pushes (the orchestrator does, per the
  Phase 4B process rule above). Commit messages are short, no AI signature.
- **QA checks scope against `git diff`**, not the Dev agent's self-report.
  Four verdicts: PASS (must cite file/line or test), FAIL, PARTIAL, and
  MANUAL for anything needing the app running. MANUAL doesn't fail the run
  but produces a checklist.
- **Escalations** carry a `Run:` stamp, cleared by the orchestrator when
  resolved, recorded under `## Escalation history` in `orchestrator-state.md`.
- Two QA cycles maximum, then it halts and asks the human.
- `orchestrator-state.md` needs hand-updating if you make any commit or
  approval outside the pipeline's own flow — it does not update itself
  retroactively.

---

## What this project is

The app is being rebuilt as **QuestLoggd**, a game library and backlog
tracker. Product brief, design conventions and per-screen specs live in
`.agents/references/` — read `questloggd-design-product-brief.md` first,
then `roadmap-deferred.md` (every decision consciously put aside, and the
fastest way to understand why the plan looks the way it does).

**Current phase: week 1 foundations.** Checklist is
`.agents/week-1-task-briefs.md`, which is **ephemeral — delete it when week 1
is done.** Target is a TestFlight-equivalent Android beta around week 4.

**Hard constraints** (both in `project-conventions.md`):
- **Android only.** No Mac, no iPhone. iOS cannot be built or verified here.
- **Account required, one-tap social.** Discord and Google only. No Apple
  (iOS-gated), no Twitch (deferred).

---

## Where things live

- `.claude/skills/` — the pipeline skills, invocable as slash commands.
- `.agents/references/` — product brief, design conventions, per-screen
  specs, project conventions, deferred roadmap.
- `.agents/runs/<run-id>/` — one folder per pipeline run; removed once a run
  is complete with no open escalations (see week-1-task-briefs.md for which
  runs shipped what).
- `.agents/`, `.claude/`, and `.codex/` are all **git-tracked**, not ignored.

---

## What is NOT in week 1

Guarding against scope creep, since several of these feel adjacent:

- The component library — week 2. Only the token layer lands now.
- Library, Home, Search, Game Detail — weeks 3 and 4.
- Custom lists beyond the schema stub — deferred Pro feature.
- Light theme — deferred. Structure for it, do not build it.
- Subscriptions and RevenueCat — month 2–3. Only the nullable `tier` column now.
- Moderation and reporting — gated on user-generated content.
- The `tracker` → `library` migration — week 3, and it needs the Library
  design spec first.

---

## Open decisions that could block

- [ ] **Game Detail hero ramp hue** — flagged inline in
      `game-detail-design-conventions.md` §2. Blocks the Game Detail hero in
      week 3, not week 1.
- [ ] **Library design spec** — needed before week 3. The biggest screen, no
      spec, and the brief flags the hard part: it must work at 3 games and
      at 300.
- [ ] **Search design spec** — needed before week 4.

---

## Next-session prompt

```text
Resume QuestLoggd. Checkout develop first. Read .agents/handover.md in full
(it's short).

Before anything else:
- Check `git status` is clean. `.agents/`, `.claude/` and `.codex/` are tracked.
- No Flutter in a fresh container. Install 3.41.4 to match `.fvmrc`, then
  `flutter pub get` and
  `dart run build_runner build --delete-conflicting-outputs` before trusting
  any baseline. Expect 11 pre-existing test failures (gotcha #3 in
  handover.md) -- the suite is not green and never has been.

Current state: items 1-10 and 10.1 (with 6.1/6.2) are all done and merged to
develop. Item 11 (repo cleanup) is the last week-1 checklist item, and its run
folder is .agents/runs/cleanup-20260806/ -- read that folder's
orchestrator-state.md `Current phase` line before assuming anything: COMPLETE
means item 11 shipped too and week 1 is done; anything else means the run is
still live, so resume it rather than starting a new one for item 11. Gotcha #7
in handover.md if the custom ba-agent/tech-lead-agent/dev-agent/qa-agent types
aren't available yet when you try to spawn one.

Still open regardless: item 3's on-device cross-account RLS check, blocked
until something writes to library_entries (week 3's Library feature) --
nothing to do there right now unless asked to build a temporary test screen
sooner. Item 10.1 also left a dead-code follow-up and four never-performed
manual checks behind; both are in handover.md's "Known non-blocking gaps".

Once week 1 is done, delete week-1-task-briefs.md per its own top note, and
check with the human on what's next (week 2 component library, or week 3
Library/tracker migration).
```

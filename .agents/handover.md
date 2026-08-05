# Handover — QuestLoggd

Written 2026-07-29. Last updated 2026-08-05 (fifth update that day): item 9's
Edge Function half is **deployed to dev and confirmed working** — the app
successfully called it and got real game data back. Items 1 and 1a were
already shipped, just never ticked. Item 3 (database schema and RLS) has its
migration files written and locally proven, but **still not yet applied to the
real dev project or verified on-device** — that part hasn't moved since the
third update. Items 2, 4, 5, 6 (with 6.1 and 6.2, both now manually
confirmed), 7 and 8 are all complete and merged.

---

## Current update — 2026-08-05 (fifth update: item 9's Edge Function deployed and confirmed)

Deployed through the Supabase dashboard (no CLI — the human didn't want to
install one), and confirmed working from the real app, not just curl (curl
didn't work for the human; cause not chased down since the app-side test
worked and answered the question that mattered).

- Secrets (`TWITCH_CLIENT_ID`, `TWITCH_CLIENT_SECRET`) set via **Project
  Settings → Edge Functions → Secrets**.
- Function created via **Edge Functions → Deploy a new function → via
  Editor**, pasting in `supabase/functions/igdb-proxy/index.ts` verbatim,
  `verify_jwt` left at its default (on).
- Confirmed working with a temporary debug button added to the Settings
  screen: `getIt<SupabaseClient>().functions.invoke('igdb-proxy', body:
  {'endpoint': 'games', 'query': 'fields name; limit 5;'})`, result shown in
  a dialog. Returned real game names on-device. **That button has been
  removed again** — `git diff` against the commit before it was added is
  empty, so `settings_screen.dart` is back to exactly what it was.

Item 9's remaining boxes are unchanged from the fourth update: repointing the
Flutter client is explicitly `[PIPELINE]` in `week-1-task-briefs.md`, run it
through `/orchestrate` as its own run; removing the IGDB credentials from the
client build and deploying to prod both follow from that run.

---

## Older update — 2026-08-05 (fourth update: item 9 written, not yet deployed)

**Not a pipeline run** — item 9's Edge Function half is `[MANUAL-CODE]`,
written and committed directly to `claude/questloggd-week1-item3-rls-x334sm`
(same branch as item 3 — no new branch was cut for this).

### What's done
- **`supabase/functions/igdb-proxy/index.ts`.** Proxies the app's two real
  IGDB endpoints (`games`, `release_dates` — confirmed by grepping
  `igdb_api_service.dart` and `game_detail_service.dart`, nothing else exists
  today) behind a Supabase Edge Function, so `TWITCH_CLIENT_ID`/
  `TWITCH_CLIENT_SECRET` become function secrets instead of shipping in the
  client build. Mirrors `twitch_auth_interceptor.dart`'s existing behaviour
  server-side: fetch a Twitch app token via `client_credentials`, cache it
  for as long as the function instance stays warm, retry once on a 401.
  Endpoint name is checked against an allow-list (`games`/`release_dates`
  only) rather than proxying any IGDB path. Takes zero external imports on
  purpose — nothing for Supabase's own deploy step to fetch, and it sidesteps
  `jsr.io` being unreachable from this sandbox (see below).
- **Relies on Supabase's own `verify_jwt`** (the platform default) to reject
  callers without a valid Supabase auth token, rather than reimplementing
  that check in the function — do not deploy this with `--no-verify-jwt`.
- **Proved it locally**: installed Deno 2.9.4 from GitHub releases directly
  (`deno.land`'s own install script is blocked by this sandbox's egress
  policy, same as `fvm.app` was for Flutter — GitHub itself isn't). 5 tests
  in `index.test.ts` mock `fetch` for both Twitch and IGDB and cover: a
  request is forwarded with the right headers/body and IGDB's response comes
  back untouched, an endpoint outside the allow-list is rejected, a missing
  query is rejected, non-POST is rejected, and a 401 triggers exactly one
  token refresh and retry. `deno fmt --check`, `deno lint` and
  `deno check` are all clean.

### What's NOT done — needs the human
1. **Set the function secrets and deploy to the real `questloggd-dev`
   project.** No Supabase CLI or project credentials exist in this sandbox.
   From the repo root, with the Supabase CLI installed and logged in:
   ```
   supabase link --project-ref <dev-project-ref>
   supabase secrets set TWITCH_CLIENT_ID=<value> TWITCH_CLIENT_SECRET=<value>
   supabase functions deploy igdb-proxy
   ```
   (Same `TWITCH_CLIENT_ID`/`TWITCH_CLIENT_SECRET` values already in
   `secret.env` from item 0.5 — just pasted into Supabase instead of the app.)
2. **Smoke-test it once deployed**, using a real Supabase anon or user JWT
   (the anon key from `dev.env` works since `verify_jwt` just checks the
   token is valid, not who it belongs to):
   ```
   curl -X POST https://<project-ref>.supabase.co/functions/v1/igdb-proxy \
     -H "Authorization: Bearer <anon-or-user-jwt>" \
     -H "Content-Type: application/json" \
     -d '{"endpoint":"games","query":"fields name; limit 5;"}'
   ```
   Expect a JSON array of games back. A 401 means the JWT wasn't accepted; a
   502 means the Twitch/IGDB leg itself failed (check the secrets).
3. **The rest of item 9 is out of scope for this session on purpose**:
   repointing the Flutter client to call this function instead of IGDB
   directly is explicitly marked `[PIPELINE]` in `week-1-task-briefs.md` —
   run it through `/orchestrate` as its own run once step 1 above is done.
   Removing the IGDB credentials from the client build and deploying to prod
   both follow from that pipeline run.

---

## Older update — 2026-08-05 (third update: item 3 in progress)

**Not a pipeline run** — item 3 is `[MANUAL-CODE]`, written and committed
directly to `claude/questloggd-week1-item3-rls-x334sm`.

### What's done
- **The account-picker fix.** `auth_datasource.dart`'s `signInWithOAuth` now
  passes `prompt=select_account` (Google) / `prompt=consent` (Discord) as
  `queryParams`, so the provider always shows its account chooser instead of
  silently reusing whatever account is already active on the device. This is
  what unblocks two-account testing at all — chosen over email/password auth
  (too big for this) and over manual OS-level sign-out (too fiddly to redo
  every test). Analyzer clean, `test/repository/auth/` 13/13 green, no other
  test touched.
- **The schema**, in `supabase/migrations/`:
  - `20260805200001_profiles.sql` — `profiles` (`id`, nullable `tier`,
    `created_at`), plus a trigger on `auth.users` insert that creates the row
    automatically (the standard Supabase pattern — no app code needed to
    populate it).
  - `20260805200002_library_entries.sql` — `user_id`, `igdb_id` + the
    denormalised `title`/`cover_url`/`release_date`, `status` (six values,
    checked), one row per user+game (`unique (user_id, igdb_id)`).
  - `20260805200003_lists.sql` — stub only: `user_id`, `name`.
  - All three enable RLS in the same file that creates the table (never a
    moment where the table exists without it), with an explicit policy per
    operation. `profiles` deliberately has no insert/delete policy — insert
    only ever happens via the trigger (security definer, bypasses RLS),
    delete only ever happens via the `on delete cascade` from `auth.users`.
- **Proved the logic locally**, not just read and agreed with: spun up a
  disposable local Postgres, stubbed just enough of Supabase's `auth` schema
  (`auth.users`, `auth.uid()`) to apply all three migration files for real,
  created two fake users, and as the second one tried to read/update/delete
  the first's rows under RLS. All correctly blocked (0 rows visible, 0 rows
  affected, forged insert rejected); deleting a fake `auth.users` row cascaded
  away its profile/entries/lists; the duplicate-game and bad-status
  constraints both fired. Full transcript is in this session, not saved as a
  file.

### What's NOT done — needs the human
1. **Apply the three migration files to the real `questloggd-dev` project.**
   No Supabase CLI or project credentials exist in this sandbox (correctly —
   `dev.env` is git-ignored and was never populated here). Open the
   `questloggd-dev` project's SQL editor in the Supabase dashboard and run
   the three files in `supabase/migrations/`, in filename order (`profiles`
   → `library_entries` → `lists`), each as its own statement batch. If you'd
   rather use the CLI: `supabase link --project-ref <dev-project-ref>` then
   `supabase db push`.
2. **Verify cross-account denial on the real app, on-device**, now that the
   account picker works: sign in as account A, add a library entry, sign out,
   sign in as account B (picking a different real account), confirm B's
   library is empty and B has no way to see or edit A's row. The local
   Postgres proof above is a strong signal the *rules* are right, but the
   brief's own bar — "verify by trying to read another user's row with a real
   second account" — is about the real deployed project and the real app,
   not a simulation.
3. **Apply to prod** — blocked, not on this run. There is no prod Supabase
   project yet (0.1b, still deferred on the free-plan project cap). Revisit
   once that project exists.

Once 1 and 2 are done, tick the remaining boxes in
`week-1-task-briefs.md` item 3 and update this file again.

---

## Older update — 2026-08-05 (second update that day)

The 2026-08-03 update below is superseded by this one for status; its
process notes still apply.

- **`.agents/`, `.claude/`, and `.codex/` are no longer git-ignored.** They
  were un-ignored and pushed straight to `develop` (commit `e9740b9`) on
  2026-08-04, then a parallel branch reconstructed the same paths from
  session memory before that push was known about. The two histories
  diverged and were reconciled in the PR #23 merge (below) — `develop`'s
  originals won for `handover.md` (this file), `roadmap-deferred.md`, and
  this checklist; the actively-maintained welcome-screen docs
  (`project-conventions.md`, `onboarding-welcome-design-spec.md`) kept the
  branch's newer versions. **Any older note in this file claiming these
  folders are git-ignored is now wrong** — see "Where things live" below,
  also corrected.
- **Item 7 (auth screen) was done all along** — merged via PR #21 before this
  update's session even started. `week-1-task-briefs.md`'s checkbox just
  never got ticked. See that file for the one shipped deviation (PNG marks,
  not SVG).
- **Items 6.1 and 6.2** (welcome-screen header rework, then padding/height/
  `SafeArea`/swipe polish) are both done, riding the same branch, merged to
  `develop` together via **PR #23** on 2026-08-05. All manual checks now
  **PASS**, confirmed on-device 2026-08-05: the 6.1 hero-art checks (screen 2
  background framing, both screens' content art placement and baked-in text
  legibility, no seam/box around the art) and the 6.2 nav-bar colour check
  (canvas `#23272A`, no black band). Nothing outstanding on item 6.
- **New standing convention, recorded in `project-conventions.md`:** every
  screen wraps its body in `SafeArea`, and the app sets one global
  `SystemUiOverlayStyle` at bootstrap (transparent status bar, nav bar
  matching `AppColorTokens.canvas`) rather than per-screen. Also recorded:
  don't add a `BlocListener`'s `listenWhen` when the listener body already
  guards the same condition itself.
- **Next: item 8, route guard and session** (`.agents/week-1-task-briefs.md`
  item 8) — auth-state-driven `auto_route` guard, no pipeline run started yet.

### Item 8 shipped, plus an unplanned follow-up (2026-08-05)

Both **merged to `develop` at `129443c`** on 2026-08-05, as a fast-forward from
`claude/questloggd-week1-item8-sosqs6`. QA PASS on both, 0 QA cycles either.

- **Item 8 — route guard and session.** Run `route-guard-session-20260805`.
  `AuthGuard` on `/` and the four content routes, fed by an `AuthStatusListener`
  that is also auto_route's `reevaluateListenable`; `PendingRouteStore` +
  `SessionNavigator` resume a blocked route after sign-in. `OnboardingGuard` was
  deleted, its decision folded in. 13 of 13 attempted device checks passed.
  URL deep-link entry checks are **deferred** — Android has no `VIEW` intent
  filter for app routes, so links cannot be delivered at all yet.
- **Sign-out control on Settings.** Run `debug-sign-out-20260805`. Existed
  because four of item 8's checks needed a sign-out trigger and none existed.
  QA PASS, 8 of 8 device checks. **Its UI/UX is provisional — see below.**

**Three known gaps, none blocking, none fixed:**

1. **Item 8's AC12 test is a duplicate** of the AC10 test and never simulates
   the onboarding hop. Test-quality gap, not a behaviour gap.
2. **No loading state during OAuth sign-in.** `sign_in_cubit.dart` emits idle as
   soon as the browser opens, not when sign-in completes, so the user returns to
   a blank sign-in screen until `SessionNavigator` moves them. Item 7's gap,
   found during item 8's checks.
3. **A mid-session sign-out resumes to the tab shell, not the screen you were
   on.** Within spec — resume was only ever promised for the blocked-navigation
   case — but worth knowing. Cause and a possible enhancement are in item 8's
   `qa-report.md`.

### The sign-out control's design is NOT signed off

Recorded in `project-conventions.md` and `roadmap-deferred.md`, repeated here
because it is the thing most likely to be mistaken for settled: the Settings
sign-out row is **test scaffolding that was built properly and kept**. It
borrows the sign-in provider row's anatomy purely because Settings has no design
spec. Placement, wording, a possible confirmation step, and grouping under an
account section are all open. **Do not cite it as precedent for future Settings
rows.** Its *behaviour* — the tap performs no navigation, the guard moves the
user — is settled and should be preserved.

### No way to sign in as a different account

Raised by the Product Owner 2026-08-05. Discord and Google both sign you
straight back into the provider's active account without prompting, so
sign-out → sign-in returns the same user. This blocks any test needing two real
accounts — **including week 1 item 3's cross-account RLS denial check**. Email +
password auth is the likely fix and is not scheduled; a cheaper interim is
passing a re-prompt query parameter to the provider. Written up in
`roadmap-deferred.md`.

### Phase 4B is now review-after-push (decided 2026-08-05, during item 8)

**This reverses process change 2 from 2026-08-02** (the two-pass Dev Agent),
at the human's request, mid-run. The new flow:

- **The Dev Agent implements and commits in a single pass.** No
  `Commit: PENDING`, no halting on an uncommitted tree.
- **The orchestrator pushes the branch straight after that commit**, so the
  Phase 4B gate reviews a pushed commit (`git show --stat <sha>`) rather than a
  working tree. Rationale from the human: the diffs are simply easier to read
  that way, on GitHub rather than through the agent.
- **Phase 4B revisions go back to the Dev Agent, not the Tech Lead.** A
  code-level change is Dev's to make; only an explicitly wrong *design* goes
  back to Phase 2. Saves a full Tech Lead round-trip.
- **A revision is a new commit on top.** Never amend, never force-update —
  history stays additive.
- Phase 4B is still a mandatory stop. Pushed does not mean approved, and QA
  still does not run until the human clears it.

Updated in `.claude/skills/orchestrate/SKILL.md`,
`.claude/skills/dev-agent/SKILL.md`, `.claude/pipeline/rules/git.md` and
`.claude/pipeline/templates/dev.md`. **`.codex/` was deliberately left on the
old rule** — the human asked for it to be left alone, and it is a separately
worded single-thread adaptation, not a mirror of `.claude/`. The two now
disagree about Phase 4B.

### Next-session prompt

```text
Resume QuestLoggd. Item 8 (route guard and session) and an unplanned sign-out
follow-up are both done, QA PASS, and MERGED to develop at 129443c. Read
.agents/handover.md's top section first; it is current as of the second
2026-08-05 update.

Before anything else:
- Check `git status` is clean. `.agents/`, `.claude/` and `.codex/` are tracked.
- No Flutter in a fresh container. Install 3.41.4 to match .fvmrc, then
  `flutter pub get` and `dart run build_runner build --delete-conflicting-outputs`
  before trusting any baseline.

Week 1 item 3 (database schema and RLS) is the next checklist item — but
read the handover's "No way to sign in as a different account" note first: its
cross-account denial check cannot be verified with Discord/Google alone.

Smaller follow-ups, all recorded, none blocking, pick up when convenient:
- Item 8's AC12 test duplicates the AC10 test and never simulates the
  onboarding hop.
- No loading state while OAuth sign-in is in flight (item 7's gap).
- The Settings sign-out control's visual design is provisional, not signed off.
- Android has no VIEW intent filter for app routes, so URL deep links cannot be
  delivered; four of item 8's manual checks are deferred on that.

Item 6's manual checks (6.1 hero art, 6.2 nav bar colour) all PASSED on-device
2026-08-05 — nothing outstanding there. Finished run folders (items 6, 7, 8)
have been removed from `.agents/runs/`, evidence retired, same as items 2 and 4.

Note: `.codex/` was deliberately left on the OLD Phase 4B rule and now disagrees
with `.claude/`.
```

### Superseded next-session prompt (2026-08-05, first update)

```text
Resume QuestLoggd. Items through 7 are done (see handover.md's 2026-08-05
update for what shipped and why item 7's checkbox was stale). Next is week 1
item 8 — route guard and session — see .agents/week-1-task-briefs.md item 8
for the full spec.

First read:
- .agents/handover.md (this file, top section)
- .agents/week-1-task-briefs.md item 8

Before starting: `.agents/`, `.claude/`, `.codex/` are git-tracked now, not
ignored — check `git status` is clean before doing anything else, same as
any other tracked path.

Two things still outstanding, not blocking item 8 but worth doing when
convenient:
- On-device manual check for item 6.2 (system nav bar colour) — see
  `.agents/runs/welcome-screens-polish-20260804/qa-report.md`.
- 3 manual visual checks left over from item 6.1, never done.

Start item 8 through the normal `/orchestrate` pipeline — feed it the spec
from week-1-task-briefs.md item 8 as the source request. New run, new
branch off `develop`.
```

---

## Older update — 2026-08-03

The older item-6 status notes below are superseded by this update.

- `welcome-screens-20260802` is `COMPLETE` and merged to `develop` via PR #20.
- Welcome screens were committed as `ab62ef2` (`feat: add welcome screens`), then
  the focused analyzer/test-harness correction was committed as `dc7c768`.
- The working tree was clean when the run was closed. The feature branch was
  subsequently pushed and merged through PR #20.
- The human approved the current refactor and explicitly waived the QA retry after
  QA/tooling commands timed out without diagnostics. Treat the run as passed by
  human decision, not as a clean automated QA result.
- The welcome widget test now pumps `OnboardingScreen` directly with mocked
  preferences, avoiding `OnboardingGuard`; `analysis_options.yaml` excludes all
  generated Dart outputs.
- Next work: manually verify the two welcome screens when convenient. Week 1
  item 7 (auth screen) is the recommended next feature.

### Next-session prompt

```text
Resume QuestLoggd after the completed welcome-screens run.

First read:
- .agents/handover.md
- .agents/runs/welcome-screens-20260802/orchestrator-state.md

Use only skills under .codex/skills/ (never .agents/skills/).

Current state:
- Branch: feature/welcome-screens
- Welcome screens run: COMPLETE
- Commits: ab62ef2 (welcome screens), dc7c768 (focused analyzer/test correction)
- The run passed by explicit human QA-waiver after Flutter analyze/test commands
  timed out without diagnostics. Do not claim automated QA is green.
- Preserve all existing onboarding/widget refactors. Do not reset, revert, or
  reformat user changes.

If continuing delivery, first inspect git status and let the human decide whether
to push/open a PR. If starting new work, begin Week 1 item 7 (auth screen) through
the existing orchestration pipeline; do not reuse or overwrite the item-6 run.
```

---

## What this project is now

The app is being rebuilt as **QuestLoggd**, a game library and backlog tracker.
The product brief, design conventions and per-screen specs live in
`.agents/references/`. Read `questloggd-design-product-brief.md` first, then
`roadmap-deferred.md` — the second one records every decision consciously put
aside and is the fastest way to understand why the plan looks the way it does.

**Current phase: week 1 foundations.** The checklist is
`.agents/week-1-task-briefs.md`, which is **ephemeral — delete it when week 1 is
done.** Target is a TestFlight-equivalent Android beta around week 4.

**Hard constraints, both recorded in `project-conventions.md`:**
- **Android only.** Windows machine, no Mac, no iPhone. iOS cannot be built or
  verified. Agents must never write acceptance criteria that require iOS.
- **Account required**, one-tap social. Discord and Google. No Apple (iOS-gated),
  no Twitch (deferred).

---

## Where the pipeline stands

`/orchestrate` → BA → Tech Lead → **human gate (now presents `code-plan.md`,
see below)** → Dev → **human code review gate** → QA.

**Five runs complete (pending manual checks where relevant).**

1. **2026-07-29/30 — tracker sort persistence.** PASS pending manual, 0
   escalations. Verified on device, merged to `develop`.
2. **2026-07-30/31 — build flavours.** PASS pending manual, 1 escalation.
   Merged to `develop`.
3. **2026-07-31 — design token layer (week 1 item 4).** PASS pending manual.
   Run folder `design-token-layer-20260731` (since removed — run complete,
   evidence retired). Merged to `develop` via **PR #17** on 2026-08-02.
4. **2026-07-31 — Supabase client + DI (week 1 item 2).** PASS pending manual,
   manually verified on device 2026-08-01. Run folder `supabase-client-di-20260731`
   (since removed — run complete, evidence retired). Merged to `develop` via
   **PR #16**.
5. **2026-08-02 — auth domain and data layer (week 1 item 5).** Stalled mid-review
   for part of this session (see git history around commits `e0c9e39`–`b35278c`
   for the full story), then resolved: human review at the Phase 4B gate
   extracted the user-mapping code into its own file and settled the
   comment/formatting deviations, baselines re-verified clean, QA ran clean —
   PASS, no manual checks outstanding, Android debug build verified directly
   rather than left to a human. Run folder `auth-domain-data-layer-20260802`.
   Merged to `develop` via **PR #19**.

**Stale as of 2026-08-05 — item 6 finished and two more runs shipped after
it.** See the "Current update — 2026-08-05" section at the top of this file
for items 6 (+ its 6.1/6.2 follow-ups) and 7. Item 8 is next; no run started.
The paragraph below (6, "one run is active") is left as historical record of
where things stood on 2026-08-03, not current state.

6. **2026-08-02/03 — welcome screens (week 1 item 6).** Run folder
   `welcome-screens-20260802`. The BA pass is complete, all four critical
   ambiguities were resolved by the human, and the Tech Lead produced
   `tech-ac.md`, `ambiguities.md`, `tdd.md`, `task-brief.md`, and `code-plan.md`.
   `tdd.md ## Open questions` is `None`. The run is paused at
   **Phase 3 — HUMAN_GATE**, waiting for the human to review the code plan and
   choose **Approved**, **Revise**, or **Abort**. The Dev Agent has not run,
   `Dev commit` is `NONE`, and there is no `diff-summary.md` or `qa-report.md`
   for this run yet.

**Items 2, 4 and 5 are done and merged.**

**Proven across these runs:** the Phase 4B code review gate (twice now caught
real issues no agent raised — a design issue in run 2, and a build_runner
over-generation problem in run 4, see below), the escalation write/route/clear
lifecycle, the BA revise loop, and QA's FAIL verdict.

**Still unproven:** the QA→Dev retry route and the two-cycle cap. QA has never
failed for a reason that re-running the Dev Agent would fix. Also unproven as
of this writing: the new two-pass Dev Agent commit flow (see below) — item 5
predates it and was grandfathered under the old rule, so no run has exercised
it end-to-end yet.

**Repo state — verified 2026-08-03:**

- `develop` has both the design-token-layer and Supabase client/DI work
  (PR #16, PR #17)
- `develop` now also has item 5 (auth domain/data layer, PR #19).
- Current branch is `feature/welcome-screens` at
  `fb70662e173d38f115f732e9eb35cfc982405f35`, exactly even with `develop`.
  The working tree has no item-6 implementation changes. This clean state is
  expected because the run stopped before the Dev phase.
- Flutter pinned to **3.41.4** via `.fvmrc`; system Flutter matches
- Two build flavours, `dev` and `prod`. App IDs `com.questloggd.app` and
  `com.questloggd.app.dev`; labels `QuestLoggd` and `QuestLoggd Dev`
- `dev.env` exists with real Supabase dev values. `prod.env` does not — the prod
  Supabase project is deferred, so prod resolves placeholders. **Manually
  verified 2026-08-01: dev flavour reaches Supabase, prod flavour correctly
  reports unreachable, app reaches first frame either way.**

---

## Item 5 — resolved 2026-08-02

Was stalled at the Phase 4B human code review gate for part of this session —
a manual out-of-pipeline commit (`e0c9e39`) had reformatted two files with a
newer, disagreeing `dart format` and shortened three review comments in a way
that didn't hold up against `project-conventions.md`'s comment rule. Resolved
in conversation: the reformatting and two of the three comment shortenings
were reverted to keep the branch on one style; the `_userFrom` mapping method
was pulled out of `auth_repository_impl.dart` into its own file,
`lib/features/auth/data/mappers/authenticated_user_mapper.dart`, as a Dart
extension on Supabase's `User` type, per human request at the review gate.
`orchestrator-state.md` was updated by hand to record the Phase 4B approval
and deviation sign-offs (it does not update itself — see the standing rule
under "What the pipeline does now" below). QA then ran clean: PASS, 0
escalations, no manual checklist left over — the Android debug build was
verified directly (`flutter build apk --debug --flavor dev`) rather than
deferred to a human. Full detail in `qa-report.md` under the run folder.
Merged to `develop` via **PR #19**.

---

## Pipeline process changes made 2026-08-02 (apply from the next Dev Agent
## invocation onward — item 5 predates both and was grandfathered)

**1. Tech Lead now also writes `code-plan.md`.** A Dart code skeleton
(signatures, class/enum/freezed shapes, bodies sketched only where the logic
needs a reviewer's eye) for every file in the task brief's allowlist. This is
now what gets presented in full at the Phase 3 human gate, replacing the
prose `## Implementation plan` — the human asked for something they could
review as code rather than a wall of step-by-step text. `task-brief.md`
itself is unchanged and stays the Dev Agent's actual instructions.
Documented in `.claude/skills/tech-lead-agent/SKILL.md` and
`.claude/skills/orchestrate/SKILL.md`.

**2. The Dev Agent no longer commits on its first pass.** ~~It writes code,
tests, and `diff-summary.md` (with `Commit: PENDING`), then halts with the
change sitting uncommitted in the working tree.~~

**REVERSED 2026-08-05 — see "Phase 4B is now review-after-push" below.** This
two-pass rule stood for three runs and was undone at the human's request during
item 8. The text is kept only so the reversal makes sense; do not follow it.

**Change 1 still applies. Change 2 was reversed on 2026-08-05 (below).
Item 5 was already committed under the old single-pass rule before this decision
was made** — the human explicitly
chose to leave `3c51fb0` as-is rather than uncommit and redo the review, so
this run finishes under the old rule (see "Item 5 — current state" above).

---

## Old run folders were deleted 2026-08-02

`build-flavours-20260730`, `design-token-layer-20260731`,
`supabase-client-di-20260731`, and `tracker-sort-persistence-20260729` were
all `COMPLETE` with no open escalations, so they were removed to keep
`.agents/runs/` to just the active run. References to them in this file and
in `week-1-task-briefs.md` were updated to say "evidence retired" rather than
pointing at dead paths. The retained run folders are
`auth-domain-data-layer-20260802/` and the active
`welcome-screens-20260802/` run.

---

**Where things live:**

- `.claude/skills/` — the five skills. Invocable as slash commands.
- `.agents/references/` — product brief, design conventions, per-screen specs,
  project conventions, deferred roadmap
- `.agents/runs/<run-id>/` — one folder per pipeline run
- **`.agents/`, `.claude/`, and `.codex/` are git-tracked**, as of 2026-08-04
  (see the 2026-08-05 update at the top of this file). No longer the risk
  this note used to warn about.

---

## New this round: comment and naming conventions (added 2026-08-01)

While building item 2 (Supabase), a round of direct back-and-forth review
produced two new sections in `project-conventions.md`, applied retroactively to
both the Supabase files and the design-token files:

- **Comments — plain English only.** No jargon, no restating what the code
  already says, no framework/pattern names unless unavoidable. Refrain from
  obvious comments entirely — an enum with self-explanatory values or a class
  whose method names already say what it does needs no comment. Developers can
  read the implementation.
- **Naming — simple English only.** Class, variable, constant and string names
  read as plain English. No invented compound jargon terms
  (`ISupabaseHealthProbe`), no placeholder-looking values
  (`__gameyes_connectivity_probe__`).

**Update:** folded into `.claude/skills/dev-agent/SKILL.md` as of 2026-08-02
(a `## Comments and naming` section, wired into step 2 and reinforced in
"What NOT to do"). Item 5 was built under the updated skill and needed no
retroactive comment/naming pass from the Dev Agent itself — see "Item 5 —
current state" above for the one place a **human**, not the Dev Agent, later
shortened three comments outside the pipeline.

Also decided in the same pass: prefer a **concrete class over a single-
implementation interface** unless a second implementation is actually coming
(dropped `ISupabaseHealthProbe`, kept `SupabasePing` concrete) — Mockito can
mock concrete classes directly as long as they are not `final`/`sealed`/`base`,
so the interface bought nothing.

---

## Two pipeline defects found in run 2, not yet fixed

**QA has no verdict for "the commit is fine, the environment isn't."** Run 2
failed because a git-tracked template, `dev.env.example`, held a real Supabase
credential in the working tree — never committed, but one `git add -A` from it.
The Dev Agent could not have caused or fixed that. The skill treats FAIL as "code
is wrong, Dev retries", so the orchestrator recorded it as an escalation and left
`QA cycles used` at 0 instead. Correct outcome, but not what the skill says. It
needs a fifth verdict — BLOCKED, or similar.

**Line-ending churn is handled inconsistently.** `build_runner` rewrites ~17
tracked generated files with LF endings and an empty content diff. Some Dev
Agent runs restore them with `git checkout --`, others leave them dirty. The
skill is silent, so it is coin-flip behaviour. Pick one and write it down. Week
1 item 11 is meant to fix this properly with `.gitattributes`.

---

## New gotcha found in run 4 (item 2, Supabase): build_runner can genuinely corrupt unrelated generated files, not just churn line endings

This is **distinct from the line-ending gotcha above** and more serious. Twice
during item 2's work, `dart run build_runner build --delete-conflicting-outputs`
rewrote ~17–35 unrelated generated files project-wide with genuinely degraded
formatting — 700+ character single lines, real content change, not an empty
diff. Root cause not fully pinned down (freezed version was unchanged in
`pubspec.lock` both times), but the symptom is reliable.

**How to tell the two apart:** run `git diff --stat` on the touched files.

- Harmless line-ending noise → **empty diff, only mode/eol markers change.**
  Safe to `git checkout --` at will.
- This new variant → **real insertions/deletions show up in the stat**, even
  though the file's actual meaning didn't change. `dart format` on the file
  reports "0 changed" because it respects the file's own `// dart format off`
  marker, so it can't be fixed retroactively — the only fix is reverting to the
  last known-good committed version.

**Fix used both times:** at the Phase 4B gate, reject with "revise" and instruct
the Dev Agent to `git checkout <last-good-ref> -- <path>` on every generated
file not genuinely needed by the task, keeping only what the task actually
touches (e.g. `service_locator.config.dart` plus new/renamed test mocks),
re-verify baselines, and create a **new** commit — never amend. Reduced an
86-file/+13434/-17378 diffstat down to 16 files both times this happened.

---

## Gotchas that will bite

### 1. Localisation — ~~cannot be generated by an agent~~ **CORRECTED 2026-08-05**

**This gotcha was wrong, and it cost real design decisions.** For weeks it told
every run to avoid user-facing strings on the premise that only the IDE could
regenerate the `S` class. Items 2 and 5 were deliberately scoped around it.

`intl_utils` **is** the generator the Flutter Intl IDE plugin wraps, and
`pubspec.yaml` already carries the `flutter_intl: enabled: true` config it
reads. It runs perfectly well from the command line:

```
dart pub global activate intl_utils
dart pub global run intl_utils:generate
```

Verified 2026-08-05 during the sign-out run: it generated two new accessors,
left the analyzer at baseline (38 issues, 0 errors), and needed no IDE. It is
not a dependency in `pubspec.yaml` — that part of the old note was true — but
`pub global activate` does not require it to be.

One thing to expect: it regenerates strictly from the `.arb` files, so **any
getter whose key was deleted disappears.** That first run removed 10 dead
getters (`welcome_chip_*`, `welcome_stat_*`, `welcome_countdown_*`,
`welcome_social_proof`) left behind by item 6.1, plus the `featured_revamp` one
this file used to mention. Correct behaviour — but check the removals are
genuinely unreferenced before committing, exactly as was done there.

**Adding a user-facing string is no longer a reason to reshape a feature.**

Pending cleanup: `lib/generated/l10n.dart` and `messages_*.dart` still carry a
dead `featured_revamp` getter. Harmless. It disappears on the next IDE regen.

### 2. Code generation is mandatory and easy to get wrong

freezed, json_serializable, retrofit, injectable, isar, auto_route, and mockito
all generate code. An annotated file **will not analyze clean until the generator
has run** — that is expected state, not a failure.

```
dart run build_runner build --delete-conflicting-outputs
```

Test mocks (`@GenerateMocks`) need this too, so test files will not compile until
build_runner has run over them.

**Never include generated files in a bulk rename.** This caused a real bug on
2026-07-29: a `sed` pass across `lib/**/*.dart` renamed a key inside the
generated l10n lookup table, producing a duplicate map key. Valid Dart, compiled
fine, and the later entry silently won — so a tab label rendered the wrong
string. `build_runner` repairs its own output, but the IDE-generated l10n files
cannot be regenerated from the CLI, so that damage had to be undone with
`git checkout`. The dev-agent skill now has a rename guard; do not work around it.

**Also see "New gotcha found in run 4" above** — a second, more serious form of
generated-file damage beyond line-ending churn.

### 3. The test suite is not green

**11 tests fail on a clean checkout of `develop`** and always have. Verified
against a pristine worktree at HEAD — they are not caused by recent work. The
pass count has since risen as tracker, theme and Supabase tests were added; the
failing eleven are unchanged.

- `test/api/games/`, `test/api/game_detail/` — type-cast errors in fixtures
- `test/cubit/games/`, `test/cubit/game_detail/` — related
- `test/repository/tracker/`
- `test/widget_test.dart` — the default Flutter counter template test

QA scopes its test run to files in the task-brief allowlist, so these should not
block a run. But **"all tests pass" is not this repo's baseline** — do not read
a red suite as evidence the pipeline broke something. Phase 0 records a fresh
test baseline (`Test baseline` / `Pre-existing test failures`) at the start of
every run; the Tech Lead quotes it verbatim rather than asserting green, and
both Dev and QA agents check a failure against that baseline before treating it
as theirs.

Worth fixing separately. Not part of a pipeline test run.

### 4. fvm vs. bare commands — unresolved

The project pins Flutter 3.41.4 via `.fvmrc`, and `.vscode/tasks.json` uses
`fvm ...` for everything. **The skills still say bare `dart` / `flutter`.**

Right now this is harmless — the system Flutter is also 3.41.4. It stops being
harmless the moment they diverge, at which point an agent regenerates code with
the wrong SDK.

Complication: `fvm` is on the PATH in PowerShell but **not** in Git Bash. So
prefixing the skills with `fvm` also pins agents to one shell.

Options: put `fvm` on the Bash PATH and prefix everything; or leave bare and have
the agent verify `flutter --version` matches `.fvmrc` before generating.
Undecided.

### 5. Test folder layout

`testing-conventions.md` says tests are grouped **by layer** —
`test/cubit/[feature]/`, `test/use_case/[feature]/`, `test/repository/[feature]/`,
`test/api/[feature]/`, `test/widget/[feature]/`. Never mirrored from `lib/`.

Known debt: `test/features/featured/` violates this. It came from the original
featured_revamp build and was moved, not restructured. Do not copy that shape.
Only unit and widget tests — **never golden tests.**

### 6. Line endings

The repo is `core.autocrlf=true`. Tools that rewrite files wholesale (`sed -i`)
flip CRLF to LF on every file they touch, even ones they do not change, which
turns `git status` into hundreds of phantom modifications. `git diff` shows the
truth — an empty diff means content is unchanged and the file can be restored
with `git checkout --`. See also the "New gotcha found in run 4" section above
for the more dangerous, non-empty-diff variant.

### 7. `injectable`'s `@preResolve` factory is structurally, not just conventionally, a singleton

Confirmed by reading `injectable`'s actual package source
(`get_it_helper.dart`): a `@preResolve` async `@module` provider is called
exactly once, then `get_it` re-registers it via `factory(() => instance, ...)`.
So every later resolve of that type returns the same instance, even though the
registration is technically a "factory". This is what guarantees
`SupabaseClient` and `SharedPreferences` are each a true single instance across
the whole app, without needing `@singleton` or `@lazySingleton`.

---

## What the pipeline does now

Worth knowing before you watch it run:

- **Phase 0** refuses to start on a dirty tree, creates `feature/<slug>`, and
  records an analyzer baseline and a **test baseline** (see gotcha #3 above).
- **Artifacts** live in `.agents/runs/<run-id>/` — one folder per run. Nothing
  lands in the repo root any more.
- **There are two mandatory human gates.** Phase 3 approves the *task brief* — no
  code is written before you clear it. Phase 4B approves the *code* — no QA cycle
  runs before you clear that one. Phase 4B presents a diffstat and the
  `git diff` command rather than pasting the diff, and it folds the Dev Agent's
  deviation sign-off into itself so you are not stopped twice for one change.
  Sending code back at 4B does not consume a QA cycle, and you may do it as many
  times as you like. **Always check the diffstat file count before approving** —
  a much larger-than-expected file count is the first sign of the build_runner
  over-generation gotcha (see above).
- **The Dev agent makes exactly one commit**, checks its own file list against
  the allowlist first, and never pushes. Commit messages are short, with **no AI
  signature**.
- **QA checks scope against `git diff`**, not against the Dev agent's self-report.
  It has four verdicts: PASS (must cite file/line or test as evidence), FAIL,
  PARTIAL, and **MANUAL** for anything that needs the app running — visual
  states, shimmer, scroll position, offline behaviour. MANUAL does not fail the
  run but produces a checklist you must work through.
- **Escalations** are a live signal, not a log. They carry a `Run:` stamp and are
  cleared by the orchestrator when resolved, with the resolution recorded under
  `## Escalation history` in `orchestrator-state.md`.
- Two QA cycles maximum, then it halts and asks you.
- `orchestrator-state.md` needs to be kept current by hand if you make any
  commits or approvals outside the pipeline's own flow (e.g. a manual fix after
  QA) — it does not update itself retroactively. Check `Current phase`,
  `Dev commit`, `Code review outcomes` and `Deviation approvals` are accurate
  before treating a run as closed.

---

## What's next

**Stale below this line as of 2026-08-05 — items 6/6.1/6.2 and 7 are all
done. Start item 8 (route guard and session) through a normal `/orchestrate`
run.** See the "Current update — 2026-08-05" section at the top of this file
for what shipped and the next-session prompt to use verbatim.

The bullets below (item 6's Phase-3-resume instructions) are left as
historical record of 2026-08-03's state, not current instructions — do not
follow them.

- Read `.agents/runs/welcome-screens-20260802/orchestrator-state.md` first.
- Present `tdd.md ## Feature summary`, `task-brief.md ## Testing mode`, the full
  `task-brief.md ## File allowlist`, and `code-plan.md` in full for human review.
- Wait for an explicit **Approved**, **Revise**, or **Abort** decision.
- On **Approved**, continue to the Dev phase using the existing run folder and
  branch. The implementation replaces the old three-page Lottie onboarding
  with the planned two-screen welcome flow and keeps the existing `first_use`
  seen flag and `/onboarding` route.
- The current plan adds and removes localisation keys. After implementation, a
  human must regenerate the Flutter Intl output from the IDE before the branch
  can compile; this is an expected manual step, not a defect.

Still accurate, not superseded:

- **0.3 (Discord app)** and **0.4/0.6 (Google + Supabase provider config)**
  are deferred, human's choice, no blocker cited (see `week-1-task-briefs.md`).
  Item 5's code path for both providers is built and unit-tested regardless;
  manual end-to-end sign-in verification is blocked until at least one of
  these lands. Item 8's guard reacts to the auth state stream either way —
  it doesn't need a real provider configured to be built and tested.
- Deferred to item 10 (Sentry): what the user sees if Supabase is unreachable
  at startup. Right now the connectivity check only logs and never surfaces UI
  — that's intentional for now, not a bug.

---

## What is NOT in week 1

Guarding against scope creep, since several of these feel adjacent:

- The component library — week 2. Only the token layer lands now.
- Library, Home, Search, Game Detail — weeks 3 and 4.
- Custom lists beyond the schema stub — deferred Pro feature.
- Light theme — deferred. Structure for it, do not build it.
- Subscriptions and RevenueCat — month 2–3. Only the nullable `tier` column now.
- Moderation and reporting — gated on user-generated content.
- The `tracker` → `library` migration — week 3, and it needs the Library design
  spec first.

---

## Open decisions that could block

- [ ] **Game Detail hero ramp hue** — flagged inline in
      `game-detail-design-conventions.md` §2. Blocks the Game Detail hero in week 3,
      not week 1.
- [ ] **Library design spec** — needed before week 3. The biggest screen, no spec,
      and the brief flags the hard part: it must work at 3 games and at 300.
- [ ] **Search design spec** — needed before week 4.

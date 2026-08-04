# Handover — QuestLoggd

Written 2026-07-29. This version rewritten 2026-08-04 after a data-loss incident
(see below) — treat everything before the incident note as reconstructed from
conversation context, not as an unbroken continuation of the original file.

---

## ⚠ Incident, 2026-08-04 — read this first

Sometime between roughly 22:33 and 23:35 on 2026-08-04, `.agents/`, `.codex/`,
and almost all of `.claude/` were deleted from disk. This happened **outside**
the acting session — it was discovered mid-conversation while trying to read
this very file, which no longer existed.

**Best-guess sequence, not confirmed:** the product owner edited `.gitignore` to
un-ignore `.agents/`, `.claude/`, and `.codex/` (all three were previously
git-ignored by design — see "Where things live" below), intending to push them
to the remote. Shortly after, all three were found deleted, and `.gitignore` was
found back to ignoring them again. The most likely explanation is some form of
`git clean` running against the briefly-unignored state, which would delete
exactly these three (untracked, and no longer ignored at that moment) without
touching anything else — consistent with what was actually lost. This is
inference, not a confirmed root cause; nobody involved has a clear account of
which command ran. The Windows Recycle Bin was checked and had nothing matching.

**Nothing was ever git-committed** in any of these three directories — that's
the whole reason they were gitignored in the first place (see "Where things
live"). So there is no `git checkout` path back. Recovery for this session was
done by reconstructing from the acting session's own conversation context,
which had complete or near-complete coverage of some files and none at all of
others.

**What's actually safe — this is the important part:** no *shipped* work was
lost. Every feature that reached a Dev Agent commit (items 2, 4, 5, 6, 6.1, 7)
has its code safely in git history, on its branch, independent of any of this.
What was lost is *pipeline paperwork* — the `tech-ac.md`/`tdd.md`/`task-brief.md`/
`qa-report.md` trail for already-completed runs, and this file's own narrative.

### What was reconstructed, then fully recovered (2026-08-04, same session)

**Update: five files initially marked "partial" below were subsequently fully
recovered.** The product owner found that `.agents/references/` had, at some
point before the incident, actually been pushed to the `develop` branch on the
remote (despite the `.gitignore` confusion — see below) and pulled real copies
back down. Cross-checked against this session's reconstructions: identical
everywhere the reconstruction had content, complete everywhere it had gaps. No
merge conflicts, no divergent content — just replaced the reconstructions with
the real files. Now **fully recovered, not reconstructed**:
- `.agents/references/flutter-arch.md`
- `.agents/references/project-conventions.md`
- `.agents/references/dart-style.md`
- `.agents/references/roadmap-deferred.md`
- `.agents/references/onboarding-auth-design-spec.md`

High confidence, reconstructed verbatim or near-verbatim from conversation
context (not from a `develop` pull — no copy was available for these):
- All of `.claude/agents/`, `.claude/skills/`, `.claude/pipeline/` (the entire
  pipeline restructuring done earlier this session — see below)
- `.agents/references/system-foundation-specs.md`
- `.agents/references/api-contracts.md`
- `.agents/references/onboarding-welcome-design-spec.md`
- `.agents/week-1-task-briefs.md`
- `.agents/runs/welcome-screens-polish-20260804/source-request.md` and
  `orchestrator-state.md` (the paused run — see "Where the pipeline stands")

**Update: fully recovered too**, pasted in directly by the product owner from
their own source rather than pulled from `develop`:
- `.agents/references/testing-conventions.md`
- `.agents/references/questloggd-design-product-brief.md`
- `.agents/references/home-screen-design-conventions.md`
- `.agents/references/game-detail-design-conventions.md`

Cross-checked all four against every other reference doc for stale pointers —
clean, nothing references the deleted `design-conventions.md` by name anywhere
in `.agents/`.

**`.codex/` — confirmed fine, not this session's concern.** The `develop`
branch on remote has an updated copy. Since the standing instruction is
hands-off on `.codex/` regardless, no action was taken here — the product
owner will handle it directly if/when needed.

**Update: `welcome-screens-header-rework-20260804` (item 6.1's run) fully
recovered too.** It turned out to be committed on `develop` (not just the
reference docs) — pulled all 9 files (`ambiguities.md`, `code-plan.md`,
`diff-summary.md`, `orchestrator-state.md`, `qa-report.md`, `source-request.md`,
`task-brief.md`, `tdd.md`, `tech-ac.md`) via
`git checkout origin/develop -- .agents/runs/welcome-screens-header-rework-20260804/`.
Verified genuine: `orchestrator-state.md`'s `Dev commit` SHA, timestamps, and
deviation notes match exactly what this session had recorded before the
incident.

**Explicitly not pursued, by product-owner decision:**
`welcome-screens-20260802/` (item 6) and `auth-screen-20260803/` (item 7) — both
superseded/already-shipped, not worth recovering. Their *code* was never at
risk regardless (both reached a Dev Agent commit, safe in git history).

**`design-conventions.md` stays intentionally absent** — deleted earlier this
session as part of a documentation cleanup after confirming every fact in it
duplicated (more completely) in `system-foundation-specs.md`. Not incident
damage.

**Bottom line: recovery is complete.** All twelve `.agents/references/` files,
the full pipeline machinery in `.claude/`, and every run folder that matters
going forward (`welcome-screens-header-rework-20260804`, complete;
`welcome-screens-polish-20260804`, the paused run, complete as of when it was
paused) are back, verified accurate. Nothing is blocked by residual data loss.

**If another copy of any reconstructed or gap-marked file exists** — another
machine, a synced folder, an IDE's local edit history — prefer that over what's
here and replace the reconstruction.

---

## Where things live — and why this happened

- `.claude/skills/` — five pipeline skills, invocable as slash commands.
- `.claude/agents/` — four registered subagent-type definitions (`ba-agent`,
  `tech-lead-agent`, `dev-agent`, `qa-agent`) with fixed `model`/`effort`/`tools`.
- `.claude/pipeline/rules/` and `.claude/pipeline/templates/` — shared protocol
  text and artifact templates, read conditionally by the skills above instead of
  being duplicated in each one.
- `.agents/references/` — product brief, design specs, project/architecture
  conventions.
- `.agents/runs/<run-id>/` — one folder per pipeline run.
- **All three of `.claude/`, `.agents/`, `.codex/` are (again, as of now)
  git-ignored.** This is deliberate, not an oversight — it keeps fast-moving
  planning/prompt content out of the repo's real history. The tradeoff, made
  very concrete by this incident, is **zero recovery path if something deletes
  them outside of git.** If you want that changed, the honest options are: (a)
  actually commit them (accept they become part of real repo history, readable
  by anyone with repo access — see the earlier push-safety discussion, nothing
  secret was ever found in them), or (b) leave them ignored but keep an
  independent backup (a synced folder, a scheduled copy) so "ignored by git"
  doesn't also mean "one `rm -rf` from gone." Worth a deliberate decision, not
  another silent edit to `.gitignore`.

---

## What this project is now

The app is being rebuilt as **QuestLoggd**, a game library and backlog tracker.
The product brief, design conventions and per-screen specs live in
`.agents/references/` (see the incident note above for which of these survived
in what state). **Current phase: week 1 foundations**, checklist in
`.agents/week-1-task-briefs.md`. Target: a TestFlight-equivalent Android beta
around week 4.

**Hard constraints:** Android only (no Mac, no iPhone, iOS cannot be built or
verified here). Account required, one-tap social — Discord and Google, both now
fully configured (0.3/0.4/0.6 all done as of this session). No Apple, no Twitch
login.

---

## Pipeline restructuring, earlier this session (2026-08-04)

Before the incident, the entire `.claude/skills` pipeline was rebuilt for token
efficiency, modeled on a size comparison against `.codex`'s equivalent (same
five roles, ~70% smaller there). Result: skills went from ~2,140 lines total to
~610, with shared protocol text factored out into `.claude/pipeline/rules/`
(git, code-generation, escalation, execution/communication/code-quality) and
`.claude/pipeline/templates/` (one per role's artifacts), read conditionally
instead of duplicated per-skill. The subagent-delegation execution model was
kept (orchestrator spawns real `subagent_type`s with fixed model/effort — this
was itself fixed a session earlier, since `general-purpose` + "invoke this
skill" was silently ignoring each skill's declared model). Two behavior
improvements were adopted from `.codex`'s design: acceptance criteria are
referenced by ID from `tech-ac.md` rather than copy-pasted into every
downstream artifact, and Phase 3 revisions append to
`code-plan.md ## Approved feedback delta` instead of triggering a full
`tdd.md`/`task-brief.md` rewrite. All of this was lost in the incident and
fully reconstructed (see above) — verify it against the artifact templates by
eye if you want to be sure nothing drifted in reconstruction.

---

## Where the pipeline stands

**Items 2, 4, 5 — done, merged to `develop`.** No change since before this
session; see `week-1-task-briefs.md` for detail on each.

**Item 6 — welcome screens — superseded, not current.** Originally shipped with
fully composed-widget heroes (cover-fan tiles, glass stat pill, key art,
countdown). Merged via PR #20. Its widget test had 2 failing tests in `develop`
this whole time that the original QA pass never caught (a human-authorized QA
waiver let it through after tooling timed out) — this is what item 6.1 quietly
fixed as a side effect.

**Item 6.1 — welcome screens header rework — done, committed, NOT merged.**
Branch `feature/welcome-screens-header-rework`, commit `5bd84e8`. Replaced both
heroes' composed-widget content with flat PNG art the product owner supplied
(`welcome-1-header.png`, `welcome-2-header.png`, `welcome-2-header-bg.png`).
Net deletion: 3 widget files removed, 1 new reusable `WelcomeHero` widget added,
10 dead localisation keys removed, `welcome_screen_test.dart` rewritten (8/8
green, including the 2 previously-broken tests). QA: PASS — pending 3 manual
visual checks (framing/centering/PNG-transparency-seam — all "code is right, a
human should look," never actually done). Two human-authored deviations at
Phase 4B, both now codified as standing conventions: a feature-scoped
`const.dart` pattern (`flutter-arch.md`), and a stricter "no per-field
dartdoc that just restates the field name" comment rule
(`project-conventions.md`, `execution.md`). This was also the pipeline's first
real end-to-end exercise since the restructuring — it worked cleanly.

**Item 6.2 — welcome screens polish + a new global system-UI convention —
PAUSED mid-Phase-0, on the same branch as 6.1.** Product-owner feedback from
manually testing 6.1: hero content has no padding, hero takes up roughly half
the screen (should be ~1/3), neither welcome screen has `SafeArea` (and system
status/nav bars aren't styled — confirmed decision: transparent status bar,
nav bar matches the *screen's own canvas colour*, as a **global app-wide
default**, not just onboarding), and there's no horizontal swipe between the
two screens (confirmed: swipe is additive alongside the existing Next/Skip/Get
started buttons; reaching screen 2 by swipe alone never writes the
onboarding-seen flag, matching item 6's original rule). This explicitly
reverses `[W1-6.31]` from item 6's original criteria ("no scroll-jacking") —
confirmed intentional.

Ticket for this is fully written: `.agents/runs/welcome-screens-polish-20260804/source-request.md`.
**What actually happened before the pause:** Phase 0 started (continuing on
`feature/welcome-screens-header-rework`, not a new branch — 6.1 isn't merged
yet), analyzer baseline captured clean (0 errors, 2 warnings, 36 info,
identical to 6.1's), but the full `flutter test` run for the baseline failed —
not a code problem, the machine's `C:` drive had ~60MB free and the test
compiler ran out of disk space (`D:`/`W:` both have hundreds of GB free, so this
is a drive-specific problem, likely Flutter/Gradle/pub caches living on `C:`).
The run was paused there, at the product owner's request, to deal with disk
space. **BA has not been spawned yet for this run.**

**Item 7 — auth screen — done, merged.** PR #21. One known deviation from the
original spec: the official Discord/Google SVG marks were replaced with PNG
conversions (`flutter_svg` never added) — product-owner decision, the SVGs
rendered solid black. Discord sign-in manually verified end-to-end this
session (a "invalid redirect_uri" issue was Discord Developer Portal
configuration, not app code).

**Item 0.3/0.4/0.6 (Discord + Google OAuth, both providers configured in
Supabase)** — all done this session, closing out what was previously the
biggest blocker to manually verifying auth end-to-end.

---

## Next-session prompt

```text
Resume QuestLoggd after the 2026-08-04 data-loss incident and recovery.

First read:
- .agents/handover.md (this file) — incident note at the top is not optional reading
- .agents/runs/welcome-screens-polish-20260804/orchestrator-state.md
- .agents/runs/welcome-screens-polish-20260804/source-request.md

Current state:
- Branch: feature/welcome-screens-header-rework (item 6.1's branch — item 6.2
  continues on it, not a new branch)
- Item 6.1: DONE, committed (5bd84e8), NOT merged, 3 manual visual checks still
  outstanding (see handover's item 6.1 section)
- Item 6.2: ticket written, Phase 0 incomplete — analyzer baseline captured,
  test baseline failed on a disk-space error, not a code issue

Before resuming the pipeline:
1. Confirm disk space is free on C: (was ~60MB free at time of pause — check
   Flutter/Gradle/pub cache locations first, since D:/W: both have hundreds of
   GB spare if the fix is relocating a cache rather than freeing C: directly).
2. Re-run `flutter test`, get a real baseline, write it into
   welcome-screens-polish-20260804/orchestrator-state.md (it currently says
   NOT CAPTURED, honestly, not a guess).
3. Proceed to Phase 1 — spawn ba-agent with source-request.md as input — then
   continue the pipeline normally through Phase 3 for human review.

Also worth doing, not blocking the pipeline:
- The 3 manual visual checks for item 6.1, still outstanding.
- A decision on whether .claude/.agents/.codex should actually be committed to
  git now, or stay ignored with some other backup — see handover's "Where
  things live" section; this incident is the reason to decide, not defer again.
- If you have another copy of the reconstructed/gap-marked reference docs
  (flutter-arch.md, project-conventions.md, dart-style.md, testing-conventions.md,
  roadmap-deferred.md, questloggd-design-product-brief.md,
  home-screen-design-conventions.md, game-detail-design-conventions.md,
  onboarding-auth-design-spec.md), replace what's here with it.
```

---

## Gotchas that will bite (carried forward, still true)

### 1. Localisation cannot be generated by an agent

The `S` class in `lib/generated/l10n.dart` comes from the **Flutter Intl IDE
plugin**. There is no CLI for it. An agent that adds a user-facing string
**cannot make the code compile** — add the key to both `.arb` files, use
`S.current.[key]`, then stop and flag it. A human must open the IDE and let the
plugin regenerate.

### 2. Code generation is mandatory and easy to get wrong

freezed, json_serializable, retrofit, injectable, isar_community, auto_route,
and mockito all generate code — an annotated file **will not analyze clean
until the generator has run**, which is expected state, not a failure.

```
dart run build_runner build --delete-conflicting-outputs
```

**Never include generated files in a bulk rename.** A `sed` pass across
`lib/**/*.dart` once renamed a key inside the generated l10n lookup table,
producing a duplicate map key — valid Dart, compiled fine, later entry
silently won. `build_runner` repairs its own output; the IDE-generated l10n
files cannot be regenerated from the CLI.

### 3. The test suite is not green

11 tests fail on a clean checkout of `develop` and always have (API/cubit
fixture type-cast errors in games/game_detail, tracker repository tests, the
default counter smoke test). Verified against a pristine worktree. QA scopes
its run to allowlisted files, so this shouldn't block a run — but "all tests
pass" is not this repo's baseline. Phase 0 records a fresh baseline every run;
compare against that, not against zero failures.

### 4. fvm vs. bare commands — still unresolved

`.vscode/tasks.json` uses `fvm`; the pipeline skills use bare `flutter`/`dart`.
Harmless while the SDK versions match (3.41.4 both). `.codex`'s equivalent
pipeline resolved this by using `fvm` everywhere — worth adopting the same way
here if the SDK versions ever diverge, but it's a deliberate decision to make,
not something to silently copy over.

### 5. Line endings

`core.autocrlf=true`. `build_runner` writes LF; git expects CRLF. Generator
runs leave ~17 tracked generated files showing modified with an **empty**
content diff — safe to `git checkout --` at will (confirmed via
`git diff --stat` returning nothing for them). A rarer, more dangerous variant
also seen twice: `build_runner` genuinely corrupting unrelated generated files
with real content changes (700+ char single lines) — check `git diff --stat`,
not just `git status`, to tell the two apart. Week 1 item 11 (`.gitattributes`)
is the planned real fix, not yet done.

### 6. `injectable`'s `@preResolve` factory is a true singleton

Confirmed from `injectable`'s source: a `@preResolve` async `@module` provider
runs once, then `get_it` re-registers it via `factory(() => instance, ...)` —
every later resolve returns the same instance despite the "factory"
registration. This is what makes `SupabaseClient` and `SharedPreferences` each
a true singleton without `@singleton`/`@lazySingleton`.

---

## What the pipeline does now (per the restructured skills)

- **Phase 0** refuses to start on a dirty tree, creates `feature/<slug>` (or
  continues an existing unmerged branch, as item 6.2 did), records an
  analyzer **and** test baseline.
- **Two mandatory human gates.** Phase 3 approves the design (`code-plan.md`
  in full, a code skeleton not prose). Phase 4B approves the actual code
  (diffstat + `git diff` command, never a pasted diff). Revise loops at either
  are unlimited and don't consume anything.
- **The Dev Agent commits exactly once**, on a second, explicit invocation
  after Phase 4B approval — the first pass writes code and halts uncommitted
  on purpose, so the human reviews the real working tree, not a fait accompli.
- **QA has four verdicts**: PASS, PASS — pending manual checks, FAIL, and a
  MANUAL sub-verdict per criterion for anything needing the app running. Two
  QA cycles maximum before it halts and asks a human.
- **Escalations are live signals, not logs** — stamped with `Run:`, cleared
  the moment they're resolved, never left on disk into `COMPLETE`.

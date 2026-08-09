# Handover — QuestLoggd

Written 2026-07-29. Last updated 2026-08-07: **week 1 is fully shipped** —
items 1 through 11 all done and merged to `develop`. Week 2 (component
library) has a drafted checklist but nothing built yet. Pipeline restructuring
also landed today: Dart conventions for widgets through datasources are now
invokable skills, not just reference docs. Full detail below.

---

## Where things stand

**Items 1 through 11 — done, merged to `develop`, nothing outstanding as
pipeline work.** `week-1-task-briefs.md` is deleted per its own top note
(week 1 shipped). The per-item history that used to live there survives only
in git history past commit `167a026` and in the condensed record just below —
see the gotcha at the bottom about why that almost got lost.

**Condensed record of items 9, 10, 10.1** (their run folders are retired,
this is what's left):
- **Item 9** (`igdb-client-repoint`) — IGDB calls moved server-side behind a
  `igdb-proxy` Edge Function. `NetworkModule`/`TwitchAuthInterceptor` kept as
  `@Deprecated` reference code by human request rather than deleted. Two
  human-approved rounds: the deprecation carve-out, and later
  `IgdbProxyConstants` → `SupabaseIgdbProxyConstants` /
  `ErrorType.functionError` → `ErrorType.supabaseIgdbError` renamed by direct
  human commits (`8f9f9bf`, `5cd8a4f`).
- **Item 10** (`sentry`) — Sentry crash reporting, single project/DSN,
  `environment` set from flavour. Scope grew mid-run to add `talker`
  request/response/error logging around the IGDB client and remove the
  deprecated `PrettyDioLogger`. Dev commit `7adeb25`. `TestCrash` and its
  three `SentryConstants.testCrash*` constants were removed afterward once
  both manual checks passed. See gotcha #8 for the `--flavor dev` requirement
  that manual check needed.
- **Item 10.1** (`igdb-transport`) — swapped the IGDB client from
  `functions.invoke` to Dio + Retrofit. Dev commit `5385338`. Four approved
  deviations: `talker_dio_logger` adopted, `IgdbCallLog` deleted;
  `SupabaseIgdbClient` collapsed entirely (its three callers now depend on
  `SupabaseIgdbProxyService` directly); the Retrofit interface renamed
  `SupabaseIgdbProxyService`; error-propagation tests swapped from
  `FunctionException` to a `DioException` fixture. Left two things open — see
  "Known non-blocking gaps" below.
- **Item 11** (`cleanup`) — `.gitattributes` fix for generated-file line-ending
  churn, `coverage/` untracked, a wrong `envied` TODO removed, 14 zero-reference
  `static const` members deleted from `const.dart`, and the three run folders
  above retired (their record migrated here and into what was
  `week-1-task-briefs.md` first). One QA cycle used — a dangling sentence
  fragment left over from that record migration, fixed same day.

**One open item, carried from item 3:** the on-device cross-account RLS
check. Schema, RLS policies and the account-picker sign-in fix are all done
and applied to the real `questloggd-dev` project — this is only about
*verifying* it live. Blocked because nothing in the app writes to
`library_entries` yet (week 3's Library feature will; the human declined a
temporary test screen sooner).

**Prod deploys are blocked project-wide**, not per item — there is no prod
Supabase project yet (0.1b, still deferred on the free-plan cap). Every
item's dev-only work (schema, RLS, Edge Function, provider config) will need
repeating there once it exists.

**Week 2 (component library) — checklist drafted, nothing built.**
`.agents/week-2-task-briefs.md`, 17 items across two stages (9 primitives,
8 composites), all `[PIPELINE]`. Read its own "How to use this" section — it
points at both the visual spec (`system-foundation-specs.md` §3) and the new
`flutter-widgets` skill for how to actually build one. Explicitly out of
scope there: `system-foundation-specs.md` §3.1 (an external, bound design
bundle for a different property — not a Flutter build target, confirmed by
grepping the repo for its import mechanism), and the Add-to-library sheet
(needs week 3's Library feature first).

---

## Skills restructuring (2026-08-07)

Dart conventions that used to live only in `.agents/references/flutter-arch.md`,
`dart-style.md`, and `project-conventions.md` are now split into six invokable
skills under `.claude/skills/`, covering everything from widgets down to
datasources:

- `flutter-widgets` — widget/screen placement, naming, style, UI patterns
  (shimmer, error/retry, empty state, network image, hero transition,
  snackbar), the widget catalogue.
- `flutter-state` — BLoC/Cubit shape, provisioning, pagination,
  pull-to-refresh, status-driven rendering.
- `flutter-usecase` — use case shape, domain entities (including an explicit
  DIP statement added 2026-08-07: an entity may depend on Dart core types and
  `freezed` only — no Flutter, Dio, Isar, JSON, or any data/presentation-layer
  import).
- `flutter-repository` — repository interface + implementation together
  (always designed as one unit in this project), `BaseRepositoryMixin`,
  `ErrorType`.
- `flutter-datasource` — datasource shape, Isar patterns, SharedPreferences.
- `flutter-dto` — DTO/model shape, JSON serialisation, the `toEntity()`
  boundary.

**Deliberately not skill-ified yet: the service layer** (Dio clients,
Retrofit services, `TwitchAuthInterceptor`-style auth interceptors). Stays in
`flutter-arch.md` for now — explicit human decision, revisit later.

**`tech-lead-agent`, `dev-agent`, and `qa-agent` all have Skill tool access**
now (they didn't before) and are told to invoke the matching component
skill(s) for whatever layer they're touching, instead of reading the old docs
by hand. `ba-agent` and `orchestrate` were deliberately left alone — BA
writes requirement-level criteria, not class shapes, and the orchestrator
never designs or writes code itself. QA's "architectural compliance" check
now checks against **two** sources: `tdd.md` (the task's specific design) and
the relevant skill (the project's standing convention) — a skill-level
violation is a FAIL even if `tdd.md` never mentioned it, since `tdd.md`'s
silence isn't authorisation.

The three old reference docs are trimmed, not deleted — they still hold
folder-structure overview, the service layer, DI, routing, code generation,
localisation, secrets, platform constraints, and naming/comment rules. Read
them for anything the six skills don't cover.

---

## Known non-blocking gaps (carried forward)

- Item 8's AC12 test duplicates AC10 and never simulates the onboarding hop
  — test-quality gap, not a behaviour gap.
- No loading state while OAuth sign-in is in flight — `sign_in_cubit.dart`
  emits idle as soon as the browser opens, not when sign-in completes
  (item 7's gap, found during item 8).
- The Settings sign-out control's visual design is provisional, not signed
  off — its *behaviour* (tap performs no navigation, the guard moves the
  user) is settled and must be preserved. Full detail in `roadmap-deferred.md`.
- Android has no `VIEW` intent filter for app routes, so URL deep links
  can't be delivered at all — 4 of item 8's manual checks are deferred on
  this.
- No way to switch Supabase accounts on one device without the interim
  account-picker query-param trick added for item 3. Real fix is
  email/password auth, unscheduled. Full detail in `roadmap-deferred.md`.
- That account-picker trick has a known rough edge on Google (blank in-app
  browser after Google's own broken re-auth flow, looks like a crash, isn't).
  Full detail in `roadmap-deferred.md`.
- Item 10.1 left dead code behind, deferred to a separate run:
  `BaseRepositoryMixin`'s `on FunctionException` catch branch,
  `ErrorType.supabaseIgdbError`, `mockFunctionException`, and
  `games_repository_test.dart`'s "throws FunctionException" test are all
  unreachable now that `supabase_igdb_client.dart` — the only producer of
  `FunctionException` — is gone. Still present and still passing.
- Item 10.1's four manual checks have never been performed by anyone, and need
  a device:
  - `10.1-AC-16` — debug **dev** build: each IGDB call should print its
    request line and `{endpoint, query}` body, and a failed call should print
    status, message and the function's error body. No 50-line trim, no caller
    stack trace — gone by approved deviation, don't expect them.
  - `10.1-AC-17` — **release** build and **prod-flavour** build: exercise the
    games list, expect zero IGDB transport output in the console.
  - `10.1-AC-2` — a dev build and a prod build each hit their own Supabase
    project host (visible in the dev build's logger output).
  - `10.1-AC-10` — with an expired access token, or a forced 401, the games
    list still loads with no error shown to the user.

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
- **A substantial Phase 3 revision may correct `tdd.md`/`task-brief.md` in
  place**, not just append to `code-plan.md`'s delta — established this
  session (item 10.1's four Phase 3 revision rounds) when the delta would
  otherwise leave the Dev Agent's literal allowlist check reading a stale
  file list. Small/naming-only revisions still just get a delta entry, per
  the original rule. The `tech-lead-agent` skill's own text hasn't been
  updated to reflect this yet — worth doing.
- **Tech Lead, Dev, and QA invoke component skills** (see "Skills
  restructuring" above) for widget/state/use-case/repository/datasource/DTO
  work, instead of reading `.agents/references/*.md` by hand for those
  layers. The old docs are still the source for everything else.
- **`.codex/` was deliberately left on the OLD Phase 4B rule** (two-pass,
  uncommitted review) at the human's request — it now disagrees with
  `.claude/` on purpose, not a bug to fix.
- **Resume sessions run the pipeline directly on the harness-designated
  session branch**, instead of creating a nested `feature/<slug>` branch per
  run. Multiple runs' artifacts can coexist under `.agents/runs/` on the same
  branch; only one run's Dev/QA phases are ever active at once. The branch
  gets merged into `develop` directly (not via PR) once the human says so —
  and **pure documentation/pipeline-config changes (not tied to a specific
  run) can go straight to `develop`** rather than riding along on whatever
  branch happens to be checked out, established this session for the skills
  restructuring and the entity DIP addition.

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
- **Harmless line-ending churn** — item 11's `.gitattributes` fix should have
  eliminated this on a real checkout with `core.autocrlf=true`. If it still
  shows up, check `core.autocrlf` is actually set before assuming the fix
  failed — this session's container had it unset, so there was nothing to
  observe either way.
- **Genuine corruption (rarer, more serious)** — real insertions/deletions
  in unrelated generated files (700+ char single lines). `dart format`
  can't fix it retroactively (respects the file's own
  `// dart format off` marker). Only fix: revert the affected files to the
  last known-good commit and re-verify baselines — never hand-edit.

### 3. The test suite has never been green
**11** pre-existing failures on a clean checkout:
- `test/repository/tracker/tracker_repository_test.dart` (4)
- `test/cubit/game_detail/game_detail_cubit_test.dart` (3)
- `test/cubit/games/games_bloc_test.dart` (3)
- `test/widget_test.dart` (1)

QA scopes its run to the task-brief's allowlisted files, so these don't
block a pipeline run — don't read a red suite as evidence something broke.
Total test count moves as features add/remove tests — track the count in the
most recent `orchestrator-state.md`, not a number quoted here.

### 4. fvm vs. bare flutter/dart — unresolved
`.vscode/tasks.json` uses `fvm ...`, the pipeline skills use bare commands.
Harmless while the system Flutter matches `.fvmrc` (3.41.4); stops being
harmless the moment they diverge.

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
available-types list until partway through the session. Spawning one by name
before then fails with "Agent type not found." Workaround: fall back to
`subagent_type: "general-purpose"` with an explicit `model` override matching
the missing agent's frontmatter (`ba-agent`/`tech-lead-agent`/`qa-agent` are
`opus`, `dev-agent` is `sonnet`), and instruct it in the prompt to invoke the
matching skill via the Skill tool and follow it exactly. Retry spawning the
real registered type on the next phase — it may have appeared by then.

### 8. `flutter run` needs `--flavor dev`, not just `-t lib/main.dart`
`flutter run -t lib/main.dart --dart-define=SENTRY_TEST_CRASH=true` **without**
`--flavor dev` produced no crash and an unexpected light-themed screen instead
of the app's hardcoded dark theme. The working command needs both:
`flutter run --flavor dev -t lib/main.dart --dart-define=SENTRY_TEST_CRASH=true`.

### 9. An ephemeral checklist's content must actually be promoted before deletion — check, don't assume
`week-1-task-briefs.md` said "delete once week 1 ships... anything worth
keeping should have been promoted into `.agents/references/` or the roadmap
by then." Item 11's Dev Agent had just migrated three retired run folders'
detailed history *into* that same file moments earlier. It got deleted right
after anyway, without verifying that migrated content had gone anywhere
further — so it briefly existed only in git history, contradicting the very
file's own instruction. Caught and fixed same session (the condensed record
is now under "Where things stand" above). **Before deleting any file whose
own note says "promote first, then delete," actually grep the destination for
the content, don't just trust that an earlier step must have handled it.**

---

## What this project is

The app is being rebuilt as **QuestLoggd**, a game library and backlog
tracker. Product brief, design conventions and per-screen specs live in
`.agents/references/` — read `questloggd-design-product-brief.md` first,
then `roadmap-deferred.md` (every decision consciously put aside, and the
fastest way to understand why the plan looks the way it does).

**Current phase: week 2, component library.** Checklist is
`.agents/week-2-task-briefs.md` (ephemeral — delete it when week 2 is done,
same convention as week 1's). Nothing in it has been built yet. Target is a
TestFlight-equivalent Android beta around week 4.

**Hard constraints** (both in `project-conventions.md`):
- **Android only.** No Mac, no iPhone. iOS cannot be built or verified here.
- **Account required, one-tap social.** Discord and Google only. No Apple
  (iOS-gated), no Twitch (deferred).

---

## Where things live

- `.claude/skills/` — the pipeline skills (`ba-agent`, `tech-lead-agent`,
  `dev-agent`, `qa-agent`, `orchestrate`), plus the six Dart component skills
  added 2026-08-07 (`flutter-widgets`, `flutter-state`, `flutter-usecase`,
  `flutter-repository`, `flutter-datasource`, `flutter-dto`).
- `.agents/references/` — product brief, design conventions, per-screen
  specs, project conventions, deferred roadmap. Trimmed 2026-08-07 where
  content moved into the component skills above.
- `.agents/runs/<run-id>/` — one folder per pipeline run; removed once a run
  is complete with no open escalations, its record migrated somewhere durable
  first (see gotcha #9 — verify this actually happened, don't assume).
- `.agents/`, `.claude/`, and `.codex/` are all **git-tracked**, not ignored.

---

## Open decisions that could block

- [ ] **Game Detail hero ramp hue** — flagged inline in
      `game-detail-design-conventions.md` §2. Blocks the Game Detail hero in
      week 3, not week 2.
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

Current state: week 1 is fully done -- items 1 through 11, all merged to
develop. week-1-task-briefs.md is deleted; a condensed record of items 9/10/10.1
lives in handover.md's "Where things stand" section now, since that's the only
place it survives (see gotcha #9 for why).

Pipeline restructuring also landed: Dart conventions for widgets through
datasources are now six invokable skills under .claude/skills/
(flutter-widgets, flutter-state, flutter-usecase, flutter-repository,
flutter-datasource, flutter-dto), wired into tech-lead-agent/dev-agent/qa-agent.
Service-layer conventions (Dio clients, Retrofit services, auth interceptors)
are deliberately NOT skill-ified yet -- still in flutter-arch.md, revisit later
if asked.

Week 2 (component library) has a drafted checklist, .agents/week-2-task-briefs.md
-- 17 items across two stages (9 primitives, 8 composites), all [PIPELINE],
none started. Read its "How to use this" section before running anything --
it points at both the visual spec and the flutter-widgets skill for how to
build one. Normal PIPELINE runs through /orchestrate, starting with Stage 1
(primitives) in order, since Stage 2 composites build on them.

Still open regardless: item 3's on-device cross-account RLS check, blocked
until something writes to library_entries (week 3's Library feature). Item
10.1 left a dead-code follow-up and four never-performed manual checks behind
-- both in handover.md's "Known non-blocking gaps". Gotcha #7 in handover.md
if the custom ba-agent/tech-lead-agent/dev-agent/qa-agent types aren't
available yet when you try to spawn one.
```

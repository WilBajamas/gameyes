# Handover — QuestLoggd

Written 2026-07-29. Last updated 2026-08-21: **week 2 Stage 2 is under way — 2
of 8 composites done.** Item 2.1 (Game card) and 2.2 (Completion ring) both
shipped this session and are merged to `develop`. Stage 1's 9 primitives were
already complete. Full detail below.

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
  `week-1-task-briefs.md` first). Dev commit `37f82ee`, QA cycle 1 fix
  `12d08d9` (the dangling-sentence fragment above). One resolved escalation:
  `task_detail_screen.dart`'s unused `_TaskReminder` class is the entire
  2-warning analyzer baseline — human chose to leave it alone rather than have
  the unused-code scan delete it, so it's still there, on purpose, not missed
  by a future sweep. Two deviations approved beyond REQ-11.1–11.6 itself: this
  file's "Where things stand" and "Next-session prompt" sections were edited
  directly, both normally out of this item's stated scope.

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

**Week 2 Stage 1 (primitives) — all 9 items done, merged to `develop`.**
Items 1.1–1.9, across 6 pipeline runs (1.5/1.6/1.7 combined into one, 1.8/1.9
into another, both at human request). `.agents/week-2-task-briefs.md` still
exists — do NOT delete it yet, Stage 2 (8 composite items) hasn't started and
the checklist's own top note says delete only once the whole week ships. Every
Stage 1 box in it was ticked 2026-08-20; they had stayed unticked through
every merge until then.

**A "stage complete" claim is worth one grep before the next stage inherits
it.** This file once claimed Stage 1 was done while 1.8 and 1.9 had never been
built; a resume session caught it by checking rather than believing, and shipped
both the same day. Same shape as gotcha #9. The 2.1 run then found the checklist
misnaming `GameItem`'s callers — so this applies to any inherited claim about
what exists, not just stage status.

**Condensed record of items 1.1–1.9** (run folders retired 2026-08-20 — this
is what's left, plus `.agents/manual-check-backlog.md`):
- **1.1 Zone label** (`lib/widgets/zone_label.dart`) — one Phase 3 reversal:
  human rejected the widget owning its own vertical spacing; established the
  **"No spacing of its own"** standing convention now in `flutter-widgets`
  skill. Dev commit `2a220f6`.
- **1.2 Status chip** (`status_chip.dart`) — six status pills, glass on-media
  variant. No revisions. Dev commit `dd940a5`.
- **1.3 Cover tile** (`cover_tile.dart`) — one Phase 3 reversal: human
  rejected the spec's `saturate(.5) contrast(1.05)` artwork filter, artwork
  keeps original colours (only the indigo wash overlay remains). Dev commit
  `c2ab32f`.
- **1.4 Placeholder slot** (`placeholder_slot.dart`, renamed from
  `logo_placeholder.dart`) — one Phase 3 reversal: human rejected the spec's
  dashed border, solid outline instead; established **"Outlines are always
  solid"** as a standing convention (`system-foundation-specs.md` §0 item 6
  plus a `flutter-widgets` bullet). Corrected two design docs that had
  described the old dashed treatment as if it were still current. Dev commit
  `482a319`.
- **1.5/1.6/1.7 combined** (`filter_count_chip.dart`, `context_chip.dart`,
  `stat_pill.dart`) — one BA/Tech-Lead/Dev/QA run covering all three, human
  request (none of the three depend on each other). Notable: human wrote the
  three widget test files personally rather than Dev — established via a
  Phase 3 revision reversing `tech-ac.md`'s test-authorship criterion, not a
  standing rule for future items unless asked again. Also established
  **"Dimensions are even numbers"** and **"Prefer Expanded over Flexible,
  unless the widget hugs its content"** as standing conventions. Dev commit
  `bb9b6e5`. `ContextChip` and `StatPill` (the glass form) ship unwired — no
  caller since the welcome heroes went to flat PNG art before Stage 1 started.
- **1.8/1.9 combined** (`progress_dots.dart`, `action_row.dart`) — one run for
  both promotions, human request. Three Dev commits: `cf6d4d8` built it,
  `29a516d` applied a Phase 4B revision, `495a27f` fixed QA cycle 1's single
  defect. `provider_action_button.dart` was deleted (git records it as renamed
  into `action_row.dart`); both screens rewired in-run with no visual change.
  Three things settled here that outlive the run:
  - **The checklist was wrong that the provider row matched spec.** Its label
    renders Inter 16/400, not §3.3's 15px/500. Resolved as *preserve what
    ships* — a promotion moves code, it doesn't restyle a live screen — so
    the gap is still open, and correcting it needs a new 15px type token
    (none exists). `[1.9-AC5]`'s "full ink" was also wrong: `body` carries no
    colour and inherits `ink70` via `bodyMedium`→`meta`, so the code pins
    `ink70` deliberately. Don't "fix" either to match the spec text without
    asking.
  - **The dots' 5px dimensions are a recorded exception** to "dimensions are
    even numbers" — that convention postdates the dots, and the promotion
    preserved them on purpose.
  - **`Flexible` over `Expanded`** around the row's label, under the
    hug-content exception, approved at Phase 3.

**Week 2 Stage 2 (composites) — 2 of 8 done.** Both shipped 2026-08-21, run
folders retired. Read `.agents/week-2-task-briefs.md`'s "How to use this"
section before the next one — it points at the visual spec
(`system-foundation-specs.md` §3) and the `flutter-widgets`/`flutter-widget-test`
skills. Explicitly out of scope there: `system-foundation-specs.md` §3.1 (an
external, bound design bundle for a different property — not a Flutter build
target), and the Add-to-library sheet (needs week 3's Library feature first).

**Condensed record of items 2.1 and 2.2:**
- **2.1 Game card** (`lib/widgets/game_card/`, Dev commit `26b5951`) — three
  sizes, 3:4 cover at r16, three overlays, onyx missing-art fallback. Rewired
  `games_screen` and both shimmers; `GameItem` is `@Deprecated`, not deleted.
  **The checklist's caller list for this item was wrong** — it named tracker and
  featured, neither of which ever referenced `GameItem`; the real ones were
  `games_screen` and the two shimmers. That bullet is now corrected in place, and
  it is worth verifying 2.5's caller list before trusting it. `LibraryTick` and
  `CriticBadge` were promoted to app-wide primitives at the human's request.
  Three things ship knowingly off-spec, all deliberate: §3.2's desaturation filter
  (see below), platform marks staying as `PlatformRowList` logo images rather than
  §1.9 abbreviations, and `md`'s 220px being a design reference rather than an
  enforced minimum (two columns on a 360dp phone give ~168 each — C1 and R2 cannot
  both hold literally).
  **The desaturation reversal repeated item 1.3's.** BA wrote a criterion straight
  from §3.2 demanding the 50% desaturation; the human had already rejected exactly
  that filter at 1.3, and `1.3-AC7` stands as a live check that it be *visibly
  absent*. Tech Lead caught it. §3.2 still describes the filter and was NOT
  corrected — see the follow-ups below.
- **2.2 Completion ring** (`lib/widgets/completion_ring/`, Dev commit `a3a918a`) —
  three fixed sizes (60/80/88), `ink12` track, indigo arc, closed magenta ring at
  exactly 100. Ships **unwired** by design; groundwork for Game Detail in week
  3/4. The project's first real `CustomPainter`. Two approved deviations: the
  semantics label reuses the existing `completed_percentage` key so it announces
  "37% completed", and the 60px centre type is 14 rather than §3.2's 15.
  **The `linear_progress_bar` package was evaluated at the human's request and
  rejected**, as was Material's `CircularProgressIndicator` — don't re-open
  without new information; the reasoning is in the checklist bullet.
  The single indigo→magenta test was removed at Phase 4B by human decision; it
  turned out to be carrying C8, C9's colour and C10's colour as well, so all three
  are manual-only now. `CompletionRingPainter` is still public, which was
  justified *only* by that test — worth revisiting.

**Two conventions worth knowing before the next Stage 2 item**, both learned the
hard way this session:
- **§3's type steps keep colliding with "dimensions are even numbers."** Item 1.9
  hit it at 15px and left the gap open for want of a token; 2.2 hit it again and
  shipped 14. A 15px type token still doesn't exist. Expect a third collision.
- **A "one file per widget family" flat `lib/widgets/` is no longer true.** The
  human directed module folders for both 2.1 and 2.2 (`game_card/`,
  `completion_ring/`, each with an `enum/` subfolder). The `flutter-widgets` skill
  still says the opposite — see the follow-ups.

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

### `flutter-widget-test` skill (added 2026-08-14/15, human-authored)

A seventh skill, but different from the six above: it's a widget-*testing*
convention (naming, setup proportionality, what earns a dedicated test file,
banned patterns like fake image bytes/`Completer`/zones), not a code-layer
skill. Wired into all three agents: Tech Lead now decides per-widget whether
a dedicated test file is warranted (not just testing mode), Dev applies its
naming/setup/assertion rules when writing tests, QA checks tests against it
independently — same "skill silence isn't authorisation" treatment as the
six code skills.

**The human revised this skill three times in one session**, each revision
retroactively invalidating the prior full-suite pass and triggering another
complete re-check of every existing widget test file. Expect this skill to
keep evolving — always re-read it in full before trusting prior compliance,
never assume a file that passed last time still passes.

**A fourth revision landed 2026-08-20**, during the 1.8/1.9 run and prompted
by the same human trimming that run's tests at the Phase 4B gate: dimensions
are now simply not tested at all (height, width, padding, gaps, radii,
offsets, positions — pixel appearance is a manual check), colour assertions
need to carry meaning and name a token, and the skill now points at two
**reference files** — `context_chip_test.dart` and `stat_pill_test.dart`,
both human-written, one and two tests each — as the shape to copy and the
length to stay near. The same session made widgets **comment-free**: the
`flutter-widgets` bullet moved from "few comments" to "no comments", with a
matching line in `execution.md`'s Code quality section.

The skill got progressively stricter: v1 allowed occasional comments and
didn't address image testing; v2 banned comments entirely and forbade
manufacturing image-loading success (fake bytes, manual builder invocation);
v3 added "treat visual styling deliberately" (don't assert an exact
color/radius/position unless it's a documented contract, not just because it
matches the widget's own implementation) and "reject redundant setup and
assertions." See gotcha #10 for the specific async-testing trap this
uncovered.

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
- **The whole on-device manual-check backlog now lives in
  `.agents/manual-check-backlog.md`** — **44 checks** as of 2026-08-21 (item
  10.1's four, all nine week 2 Stage 1 items', 2.1's eight and 2.2's ten), every
  one still unperformed. That file is the only copy: it was written when the run
  folders were retired, precisely so the checks would outlive the `qa-report.md`
  files that had been holding them. Don't summarise it back into here — point at
  it. Note 2.2's ten need a scratch harness or its first real caller, since the
  ring ships unwired.
- **Human-authored test gaps from the 1.5/1.6/1.7 run**, flagged by QA as
  advisory (not blocking, QA doesn't gate on files outside Dev's allowlist):
  no `StatTile` test at all despite it being the only one of the three with a
  live caller; `count == 0` unexercised in `filter_count_chip_test.dart`
  despite `tech-ac.md` naming it explicitly; two color assertions there
  hardcode literal hex instead of referencing the design token.
- **`.claude/skills/flutter-widgets/SKILL.md`'s "one file per widget family" rule
  text contradicts two shipped modules** (`game_card/`, `completion_ring/`). Both
  folders were human-directed; the rule sentence was deliberately not updated in
  either run. Flagged by QA in both. Whoever next edits that skill should settle
  the wording rather than leave a rule the codebase openly breaks.
- **`system-foundation-specs.md` §3.2 still describes the cover-art desaturation
  filter** that was rejected at item 1.3 and rejected again at 2.1. Two runs have
  now had a BA write a criterion straight from that stale text. Correcting the
  doc would stop it happening a third time — item 1.4 set the precedent for fixing
  a design doc when a decision reverses it.
- **§1.9 conformance for platform marks** — `PlatformRowList` renders IGDB logo
  images where §1.9 calls for text abbreviations (`PS5`, `XSX`). Deliberately not
  converted in 2.1, because it would have changed a shipped screen beyond the card
  swap and the row is shared with `saved_game_item.dart`. Worth one follow-up
  converting both callers together, sequenced against week 3's tracker migration.
- **`lib/widgets/primary_button.dart:29` defaults its fill to `tokens.color.green`**
  — a third `color.green` resolution beyond `critic_badge.dart` and the focus
  ring, where §2's colour law names only two sanctioned exceptions. Either the
  button is a legitimate third (and the catalogue wording needs widening) or it is
  a leak. Pre-existing, found by 2.1's compliance sweep, owned by nobody yet.
- **Import blocks in six of item 2.1's files are no longer alphabetised** — the
  human's `enum/` rename moved `game_card_size.dart` without resorting them.
  Cosmetic, no diagnostic. Sweep when something else edits those files.
- **`enum/` (singular) vs the repo's `lib/core/enums/` (plural)** — both new module
  folders use the singular. Noted so it reads as a deliberate choice, not drift.
- **A live "outlines are always solid" violation already exists**,
  independent of anything built this week: `library_stats.dart` has a
  `_DashedBorderPainter` (`BorderStyle.none, // We want dashed border`)
  around the empty now-playing card. Belongs to Stage 2 item 2.8's empty
  state, deliberately left untouched by every run that has since edited that
  file for unrelated reasons — don't fix it in passing, it's 2.8's to own.
- **`_SignOutButton` is a third hand-rolled copy of the `ActionRow` anatomy**
  (`lib/features/settings/presentation/widgets/sign_out_section.dart`), minus
  the leading mark. Deliberately left out of the 1.8/1.9 run — folding it in
  would have forced an optional mark slot and put a third screen's pixels at
  risk mid-run. It's the natural second caller and the only real argument for
  that optional slot; worth its own small item.
- **Two comment-rule leftovers**, both created by the 2026-08-20 convention
  change rather than by a bad run: `welcome_container.dart` still carries four
  pre-existing comments that the new "widgets carry no comments" rule now
  covers (out of the 1.8/1.9 run's allowlist, so it couldn't touch them), and
  `action_row_test.dart` duplicates its `Text` constructor args around lines
  64–65. Neither is urgent; sweep them when something else edits those files.
- **Two more off-spec filter chips** exist beyond what item 1.5 named:
  `_SelectionChip` in both `default_filter_list_app_bar.dart` and
  `filter_list_app_bar.dart`. Not migrated to `FilterCountChip`, flagged as a
  follow-up, not silently expanded into scope.

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
  the original rule. The `tech-lead-agent` skill's "Revision mode" section
  was updated to say this on 2026-08-20.
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
- **A human can defer widget-test authorship to themselves for a given
  run**, via a Phase 3 revision reversing the BA's test-coverage criterion
  (not a Tech Lead-only delta, since it changes what `tech-ac.md` requires).
  Established for the 1.5/1.6/1.7 run — one-off by request, not a standing
  default; ask again each time rather than assuming it repeats.
- **The orchestrator can commit run-folder planning docs directly**, ahead
  of Dev's own commit, when the human explicitly asks to review `code-plan.md`
  on GitHub before approving at a gate — a deliberate, requested deviation
  from "only the Dev Agent commits," not a standing practice to repeat
  unprompted.
- **A Phase 3 revision that changes implementation style but no acceptance
  criterion** (e.g. "remove this comment," "use `Expanded` not `Flexible`")
  is Tech Lead-only — append to `code-plan.md`'s delta, no BA involvement.
  Only route back to BA when the fix actually reverses or adds a criterion
  in `tech-ac.md` itself.

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
**10** pre-existing failures on a clean checkout (was 11 until `test/widget_test.dart` —
the leftover Flutter-scaffold counter smoke test, testing a `MyApp()` counter this app
never had — was deleted during the week 2 widget-test revision, 2026-08-14):
- `test/repository/tracker/tracker_repository_test.dart` (4)
- `test/cubit/game_detail/game_detail_cubit_test.dart` (3)
- `test/cubit/games/games_bloc_test.dart` (3)

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

### 10. Widget tests that pre-resolve `AppTokens.dark`/theme values hit a real async trap
`google_fonts` throws inside a detached, unawaited background `Future` when
a font isn't bundled and `allowRuntimeFetching` is false (the norm in this
project's test files, to avoid slow/flaky network-dependent tests) — nothing
else awaits that future, so it leaks as an unhandled exception into whatever
test happens to be running when it fires, not necessarily the one that
triggered it.

**First-choice fix, and usually sufficient**: don't pre-resolve the theme at
all. If a test doesn't assert exact token values (which the `flutter-widget-test`
skill now discourages anyway — see "Treat visual styling deliberately"),
nothing needs synchronising, and the theme resolves naturally inside
`pumpWidget`'s own zone with no helper of any kind. This is what `cover_tile_test.dart`
looks like today — the human's own rewrite, treated as the benchmark.

**If a test genuinely needs pre-resolved tokens** (asserting an exact
`AppTokens.dark.color.x`), empirically verified, in order of what was tried:
- Draining `google_fonts`' own internal `pendingFontFutures` set (via a deep
  `src/` import) — doesn't work reliably; font loading cascades into new
  futures faster than a bounded drain catches them, and an unbounded drain
  hangs.
- Setting `allowRuntimeFetching = true` and letting the real fetch happen
  (matches the package's own official example test, zero workaround) — works
  *only* if the resolution stays inside `setUpAll`; hoisting it to bare
  top-level `main()` code breaks with "no current invoker," because the real
  HTTP path needs `package:test`'s zone machinery.
- `runZonedGuarded` (returning its own async body's `Future` directly,
  **no** `Completer`, **no** artificial `Future.delayed`) is the only
  mechanism that reliably worked across every case tried, verified over
  multiple repeated runs with no flakiness.

The real, fully-clean fix — bundling actual `.ttf` files as test assets so
neither network nor the exception path is ever hit — was **not done**: it
requires adding binary font files and touching `pubspec.yaml`'s asset list,
changing the app's real shipped asset footprint, not just a test file. Left
as an open question if a future session wants to pursue it.

### 11. Remote branch deletion is blocked in these containers
Cleaning up merged `claude/*` branches on GitHub cannot be done from a session:
`git push origin --delete` fails with `HTTP 403` from the egress proxy, and the
REST `DELETE /git/refs/heads/...` returns *"Write access to this GitHub API
path is not permitted through this proxy."* Not a credential problem and not
worth retrying — the branches have to be deleted by hand in the GitHub UI.
Merged and safe to delete there — seven `claude/*` branches:
`questloggd-item-10-1-igdb-ogvf5r`, `questloggd-resume-e1e0fi`,
`questloggd-week-2-components-ha43qm`, `questloggd-week1-item3-rls-x334sm`,
`questloggd-week1-item8-sosqs6`, `questloggd-stage-2-resume-ikpjd6`
(the 1.8/1.9 session branch, merged at `52c9528`), and
`questloggd-stage-2-game-card-nxg2vg` (the 2.1/2.2 session branch, merged
2026-08-21). Whether the first six have actually been deleted in the UI yet is
unknown to any session — check before assuming this list is still current.

Note the last three share **no merge base** with `develop` (`--merged` won't
list them) because `develop`'s history was rebuilt at some point. They're still
fully merged by content — verified by diffing their trees against `develop`,
where the only files they hold that `develop` lacks are ones deliberately
deleted later (`supabase_igdb_client.dart`, `logo_placeholder.dart`,
`widget_test.dart`, `coverage/`). Use a content diff, not `--merged`, before
deleting anything here.

---

## What this project is

The app is being rebuilt as **QuestLoggd**, a game library and backlog
tracker. Product brief, design conventions and per-screen specs live in
`.agents/references/` — read `questloggd-design-product-brief.md` first,
then `roadmap-deferred.md` (every decision consciously put aside, and the
fastest way to understand why the plan looks the way it does).

**Current phase: week 2, component library, Stage 1 done, Stage 2 in progress
(2 of 8).** Checklist is `.agents/week-2-task-briefs.md` (ephemeral — delete it
when the whole week is done, same convention as week 1's). All 9 Stage 1
primitives plus composites 2.1 and 2.2 are built and merged; 2.3 through 2.8
remain. Target is a TestFlight-equivalent Android beta around week 4.

**Hard constraints** (both in `project-conventions.md`):
- **Android only.** No Mac, no iPhone. iOS cannot be built or verified here.
- **Account required, one-tap social.** Discord and Google only. No Apple
  (iOS-gated), no Twitch (deferred).

---

## Where things live

- `.claude/skills/` — the pipeline skills (`ba-agent`, `tech-lead-agent`,
  `dev-agent`, `qa-agent`, `orchestrate`), the six Dart component skills
  added 2026-08-07 (`flutter-widgets`, `flutter-state`, `flutter-usecase`,
  `flutter-repository`, `flutter-datasource`, `flutter-dto`), and
  `flutter-widget-test` (added 2026-08-14/15, testing conventions — see
  "Skills restructuring").
- `.agents/references/` — product brief, design conventions, per-screen
  specs, project conventions, deferred roadmap. Trimmed 2026-08-07 where
  content moved into the component skills above.
- `.agents/manual-check-backlog.md` — every on-device check QA identified and
  nobody has performed, across every run. Created 2026-08-20 as the durable
  home for these; tick one off by deleting it, and if one fails it becomes a
  bug to file rather than a backlog line.
- `.agents/runs/<run-id>/` — one folder per pipeline run; removed once a run
  is complete with no open escalations, its record migrated somewhere durable
  first (see gotcha #9 — verify this actually happened, don't assume).
  **The directory doesn't currently exist** — Stage 1's six folders were retired
  2026-08-20, and 2.1's and 2.2's on 2026-08-21, each with its record condensed
  into "Where things stand" above and its manual checks moved to the backlog file
  first. Git doesn't keep empty directories. The next run's Phase 0 recreates it;
  nothing to restore first.
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
(it's long now, read it anyway).

Before anything else:
- Check `git status` is clean. `.agents/`, `.claude/` and `.codex/` are tracked.
- No Flutter in a fresh container. Install 3.41.4 to match `.fvmrc` (a
  /etc/profile.d/flutter.sh script works well so every login shell picks it up
  automatically, including subagents' Bash calls), then `flutter pub get` and
  `dart run build_runner build --delete-conflicting-outputs` before trusting
  any baseline. Expect 10 pre-existing test failures across three files
  (gotcha #3) -- the suite is not green and never has been.

Current state: week 2 Stage 1 (9 primitives) is fully done, and Stage 2 is 2 of
8 -- items 2.1 (Game card) and 2.2 (Completion ring) shipped 2026-08-21 and are
merged to develop. Next is 2.3 (Countdown + Countdown tile). Work in order,
since later composites build on earlier ones -- read
.agents/week-2-task-briefs.md's own "How to use this" section first. Unlike 2.1,
2.3 has a single known caller (featured's countdown section) and the checklist
says to rewire it in the same run.

Three things that repeated themselves across 2.1 and 2.2, so expect them again:
- The checklist's caller lists are not reliable. 2.1's named tracker and
  featured, and neither ever referenced GameItem. Grep before believing one --
  2.5's is the next unverified claim.
- BAs write criteria straight from system-foundation-specs.md §3 even where a
  human decision has already overruled that text. It happened twice on the same
  desaturation filter (items 1.3 and 2.1). §3.2 still describes it.
- §3's type steps keep colliding with "dimensions are even numbers" (1.9 at 15px,
  2.2 again at 15px). A 15px token still doesn't exist.

Conventions, stricter than what older code and older run artifacts show --
re-read the skills, don't pattern-match off existing files:
- Widgets carry NO comments at all (flutter-widgets, and execution.md's Code
  quality section). Not "few" -- none.
- Widget tests never assert dimensions, gaps, radii or positions, and colour
  assertions must carry meaning and name a token. context_chip_test.dart and
  stat_pill_test.dart are the reference files for shape and length; read one
  before writing a new test file. The flutter-widget-test skill has been revised
  four times -- always re-read it in full rather than trusting a prior compliance
  pass. Keep test plans proportionate: 2.1's card was trimmed from 19 tests to 10
  at the gate, and it is a far bigger component than most.
- lib/widgets/ is no longer flat. 2.1 and 2.2 both ship module folders with an
  enum/ subfolder, human-directed. The flutter-widgets skill still says the
  opposite; that contradiction is a live follow-up.

Known follow-ups, none blocking, all itemised in "Known non-blocking gaps":
item 3's on-device cross-account RLS check (blocked on week 3's Library
feature), item 10.1's dead-code cleanup, the on-device manual-check backlog in
.agents/manual-check-backlog.md (44 checks, none performed yet -- that file is
the only copy, the run folders it came from were retired), the flutter-widgets
rule text contradicting two shipped modules, §3.2's stale desaturation text,
§1.9 platform-mark conformance, primary_button.dart's unexplained third
color.green, _SignOutButton as a third copy of the ActionRow anatomy, two
comment-rule leftovers, a couple of human-authored-test coverage gaps, and a
pre-existing dashed-border violation in library_stats.dart that is Stage 2 item
2.8's to fix, not a stray bug to patch in passing.

Two environment things that will waste your time otherwise: remote branch
deletion is blocked by the egress proxy (gotcha #11 -- the merged claude/*
branches have to be deleted by hand in the GitHub UI, don't retry the 403),
and the custom ba-agent/tech-lead-agent/dev-agent/qa-agent types may be
missing at session start (gotcha #7 has the fallback).
```

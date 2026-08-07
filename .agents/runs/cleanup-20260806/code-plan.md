# Code Plan
Source: `.agents/week-1-task-briefs.md` § "11 — Cleanup [PIPELINE]" (now lines
435–479), plus the human instructions of 2026-08-07 adding items 4, 5 and 6 — all
via `.agents/runs/cleanup-20260806/tech-ac.md`
Date: 2026-08-07 (supersedes the 2026-08-06 version, which covered items 1–3 only)

Almost nothing here is Dart shape work. Items 1–3 are configuration text, item 4
is a deletion-only Dart diff, and items 5–6 are documentation and git operations —
so those are shown as before/after listings of the exact text, not as skeletons.
`+` marks an added line, `-` a deleted one; unmarked lines are existing context
shown for position only and must not be retyped or reformatted.

Proposed record text below is a starting point at the right level of detail, not
dictation. Where Dev's own re-check of a run folder contradicts it, the folder
wins and `diff-summary.md` says so.

## CREATE NEW

### .agents/runs/cleanup-20260806/analyzer-baseline.txt

The raw `flutter analyze` output, redirected verbatim, no editing, no summary:

```text
$ flutter analyze          # captured <UTC timestamp>, tree = base commit + the
                           # three config edits only, no Dart file edited yet
Analyzing gameyes...
   info • ... • lib/... • lines_longer_than_80_chars
   warning • The declaration '_TaskReminder' isn't referenced • lib/features/tracker/presentation/screens/task_detail_screen.dart:201:7 • unused_element
   ...
34 issues found. (ran in Ns)
```

The classification itself goes in `diff-summary.md`, not here — this file exists
so the classification can be checked against the real output (AC-5.1).

### .agents/runs/cleanup-20260806/diff-summary.md

Section skeleton; Dev fills it as the run proceeds.

```markdown
# Diff Summary — item 11, repo cleanup
Commit: <sha>   Branch: claude/questloggd-item-10-1-igdb-ogvf5r

## Read the diffstat first
<N> generated Dart files — one-time line-ending renormalisation, the REQ-11.1 fix
landing, not churn and not scope creep (AC-1.7). Named individually below.
25 deleted `.md` files — the three retired run folders (REQ-11.6).
Everything else is 6 files.

## REQ-11.1 — .gitattributes and renormalisation
git status before / after `dart run build_runner build`, verbatim; `git diff --stat`;
the renormalised file list; AC-1.6 verdict.

## REQ-11.2 — coverage untracked
`git ls-files coverage/` empty; file still on disk; `git status` silent on it.

## REQ-11.3 — envied TODO

## REQ-11.4 — unused-declaration sweep
Analyzer: 34 issues, each with its diagnostic code, split into the
unused-declaration family and the rest, with a total per group. AC-5.2 and AC-5.3
observations. Per-member table for all 58 `static const` members: searches run,
match locations, count excluding the declaration. Value-search results for each
zero-reference candidate. Members deleted. AC-5.10 findings, reported not deleted.
Statement that the sweep is not a completeness proof.

## REQ-11.5 — docs cull
One line per file for all 15 files: "nothing removed" + reason, or the exact lines
removed with AC-6.2(c) argued.

## REQ-11.6 — run folders retired
Per-folder AC-7.1 check (four conditions each, all folders including this one).
AC-7.5 open-work re-read result for the two older folders. What was migrated where.
Deleted file count from `git ls-files`. AC-7.6 search hits and how each reads.

## Deviations from implementation plan
```

## MODIFY EXISTING

### .gitattributes

Current file is 12 lines. Lines 1–12 are untouched (AC-1.2); the diff must show
additions only. Append after line 12:

```gitattributes
  5 | # Flutter writes them.
  6 | **/generated_plugin_registrant.cc   text eol=lf
  ...
 12 | **/GeneratedPluginRegistrant.m      text eol=lf
 13 |+
 14 |+# Same problem, second source: build_runner writes its Dart output with LF.
 15 |+# Pin it so a generator run stops showing these files as modified with an
 16 |+# empty diff. Generated patterns only — a blanket rule would renormalise
 17 |+# every hand-written source file in the repository.
 18 |+*.g.dart        text eol=lf
 19 |+*.freezed.dart  text eol=lf
 20 |+*.gr.dart       text eol=lf
 21 |+*.config.dart   text eol=lf
 22 |+*.mocks.dart    text eol=lf
```

Pattern text is the brief's code block verbatim (AC-1.1). Bare patterns, no
leading slash — they already match at any depth, so `**/` is not needed and is not
added. `text eol=lf` is the same attribute pairing the seven existing lines use.
Forbidden and absent (AC-1.3): `* text=auto`, `*.dart eol=lf`, `* eol=…`, and
anything else reaching a hand-written `.dart` file.

### .gitignore

Current file is 50 lines, last entry `.fvm/flutter_sdk`. Confirm that line is
newline-terminated, then append:

```gitignore
 48 | # FVM Version Cache
 49 | .fvm/
 50 | .fvm/flutter_sdk
 51 |+
 52 |+# Coverage
 53 |+coverage/
```

Directory form, so it covers `coverage/lcov.info` and anything else QA's
`--coverage` run drops there (AC-2.1). New `# Heading` + entry section matching the
file's existing style. No existing line is edited — in particular the commented-out
`#.vscode/` on line 22 stays commented out (AC-4.3).

### pubspec.yaml

One line changes. Line 102 only:

```yaml
101 |   # Envied - Privatise file
102 |-  envied: ^1.3.4 # TODO: To deprecate this package and use flutter_secure_storage
102 |+  envied: ^1.3.4
103 |
104 |   # Path provider
```

The comment is deleted, not reworded, relocated, or replaced with a note
explaining why it was wrong (AC-3.1). Verified by inspection: line 102 is the only
occurrence of `flutter_secure_storage` and the only `TODO` in the file, so this
single edit satisfies AC-3.1 completely.

Unchanged and explicitly out of bounds (AC-3.2, AC-4.1): line 101's section
comment, the `^1.3.4` constraint, `envied_generator: ^1.3.4` at line 136, and every
other dependency, dev dependency and version constraint. `pubspec.lock` is not
regenerated — no `flutter pub get` in this run.

### lib/core/res/const.dart

The only Dart file this run changes. Deletions only — no class removed, no member
renamed, moved, re-ordered or re-valued, and no comment added to explain a
retention. The diff for this file must contain deleted lines and nothing else
(AC-5.9). Every deletion below is a *candidate*: it lands only if step 9's
per-member count is exactly zero across `lib/` and `test/` and its value search
comes back empty (AC-5.4, AC-5.5, AC-5.8).

Four of the ten classes change. The other six —`AssetConstants`,
`StorageConstants`, `SupabaseConstants`, `SentryConstants`, `IGDBConfig`,
`SupabaseIgdbProxyConstants` — are swept and recorded, and expected to keep every
member.

```dart
class ConfigConstants {
-  static const baseUrl = 'https://api.rawg.io/api/';       // RAWG-era, 0 refs
   static const igdbBaseUrl = 'https://api.igdb.com/v4/';   // kept: AC-5.6
-  static const gamesEndpoint = 'games';                    // RAWG-era, 0 refs
-  static const screenshotsEndpoint = 'screenshots';        // RAWG-era, 0 refs
   static const apiKey = 'API_KEY';                         // kept: @Envied varName
   static const heroTag = 'hero_tag';
   ...                                                      // rest unchanged
 }

 class PathConstants {
-  static const lottieAnimationAssetPath = 'assets/animations/';
   static const imagePath = 'assets/images/';
 }

 class StringConstants {
   static const emptyStringPlaceholder = '-';
   static const na = 'NA';
   static const connectionTimeout = 'Connection timeout';
-  static const sharedPrefTypeError = 'Unsupported type for shared preferences';
 }

 class RouteConstants {
-  static const root = '/';
-  static const home = '/home';
   static const featured = '/featured';                     // kept: AC-5.7
   static const games = '/games';                           // read as fromScreen
   static const tracker = '/tracker';                       // read as fromScreen
-  static const trackerDetail = '/tracker_detail';
-  static const taskDetail = '/task_detail';
-  static const imagePageView = 'image_page_view';
   static const onboarding = '/onboarding';                 // read by openPaths
-  static const gameDetail = '/game_detail';
-  static const browse = '/browse';
-  static const news = '/news';
-  static const settings = '/settings';

   static const auth = '/auth';                             // read by openPaths
   static const legal = '/legal';                           // read by openPaths

   /// The only paths reachable without signing in.
   static const openPaths = {onboarding, auth, legal};
 }
```

The trailing `// kept:` notes above are review aids for this plan — **they are not
written into the file.** The file has no imports, so no deletion can leave one
dangling (AC-5.11). Blank-line grouping inside `RouteConstants` is preserved as-is.

Two members deserve their retention argued, because both look deletable on a
name-only search:

- `ConfigConstants.igdbBaseUrl` — read only by `lib/core/di/network_module.dart`,
  which is `@Deprecated`, DI-unregistered reference code the human asked to keep.
  It must keep compiling (AC-5.6).
- `RouteConstants.featured` — zero code references, but
  `.agents/references/project-conventions.md` § "Hero transition pattern" names it
  as the `fromScreen` value to pass from Featured (AC-5.7). Reference docs are
  outside this run's write boundary, so the constant stays.

One consequence to report, not to fix: `.agents/references/api-contracts.md`
§ "Known gaps" mentions `ConfigConstants.baseUrl` — as legacy to avoid, not as a
convention to follow, so AC-5.7 does not retain it — and that line goes stale when
the constant goes. Correcting a merely-stale statement is barred by AC-6.4 and the
file is not in the write set, so it is a `diff-summary.md` finding.

### lib/features/onboarding/const.dart

Expected to end the run **byte-identical**. All six members are referenced
(`onboarding_screen.dart`, `welcome_hero.dart`, `welcome_screen_test.dart`), and
its one import stays because `PathConstants.imagePath` stays. In the allowlist
only so that a zero-count verified in step 9 can be actioned without escalating;
if none is, record the counts and leave the file alone.

### .agents/week-1-task-briefs.md — item 9 (AC-7.3, AC-7.6)

The third bullet currently ends by pointing into a folder this run deletes.
Replace the pointer with what it pointed at; the rest of the bullet is untouched:

```markdown
      human wants the old shape available to consult. `tech-ac.md`'s
      criteria were amended with an explicit carve-out for this; see
-     `orchestrator-state.md ## Deviation approvals` in the run folder.
+     A second approval from the same run, recorded nowhere else:
+     `IgdbProxyConstants` was renamed `SupabaseIgdbProxyConstants` and
+     `ErrorType.functionError` renamed `ErrorType.supabaseIgdbError` by
+     direct human commits `8f9f9bf` and `5cd8a4f` after the Dev commit,
+     with the explicit instruction that the run's `task-brief.md` and
+     `code-plan.md` were not to be updated for it. Run folder
+     `igdb-client-repoint-20260805` retired 2026-08-07 — run complete,
+     evidence retired.
```

### .agents/week-1-task-briefs.md — item 10 (AC-7.3, AC-7.8)

```markdown
-- [ ] Done
+- [x] Done. **2026-08-07.** Full pipeline run, `sentry-20260806` (retired
+      2026-08-07 — run complete, evidence retired). QA PASS, 0 QA cycles. Dev
+      commit `7adeb25`, on top of `e652d1f` / `a963c5f`; merged to `develop`
+      (no PR — merged directly, no merge SHA recorded). Sentry initialises
+      before `runApp` behind the single DSN, with `environment` set from the
+      flavour, flavour and app-version tags, and no personally identifying
+      field. Scope grew mid-run at the human's request: `talker`
+      request/response/error logging around the IGDB client, and removal of the
+      deprecated `PrettyDioLogger` — CRITICAL-1, resolved by the human choosing
+      option A (strip it from `twitch_auth_interceptor.dart` too, then drop the
+      package), with `flutter-arch.md`'s stale `network_module.dart` path fixed
+      in the same pass. One approved deviation: the revised code plan covering
+      that added scope. One code-review send-back before approval —
+      `CrashReportingSettings` and `AppVersion` simplified from classes to
+      top-level functions, the latter moved to `lib/core/utils/version_utils.dart`.
+      Both manual checks confirmed on-device 2026-08-07: [10.12] Sentry delivery
+      (needed `--flavor dev`, now `handover.md` gotcha #8) and [10.18] IGDB log
+      lines. `TestCrash`, its `bootstrap.dart` call site and the three
+      `SentryConstants.testCrash*` constants were removed afterwards, as agreed,
+      once QA passed and [10.12] was confirmed.
```

### .agents/week-1-task-briefs.md — item 10.1 (AC-7.3, AC-7.8)

This is the entry that matters most: the folder is currently the only evidence in
the repository that item 10.1 shipped at all.

```markdown
-- [ ] Done
+- [x] Done. **2026-08-07.** Full pipeline run, `igdb-transport-20260807`
+      (retired 2026-08-07 — run complete, evidence retired). QA PASS, 0 QA
+      cycles, no escalations. Dev commit `5385338` on base `cf3ddc6`, branch
+      `claude/questloggd-item-10-1-igdb-ogvf5r`, merged to `develop`. The IGDB
+      transport is now Dio + Retrofit calling the `igdb-proxy` Edge Function's
+      URL directly, with a Supabase-session interceptor attaching `Authorization`
+      and `apikey` per request and refreshing-and-retrying once on a 401. Four
+      approved deviations: (1) `talker_dio_logger` added as a new direct
+      dependency and `IgdbCallLog` deleted in favour of `TalkerDioLogger`,
+      accepting the loss of the 50-line response trim and the caller stack trace;
+      (2) `IgdbProxyService` renamed `SupabaseIgdbProxyService`; (3)
+      `SupabaseIgdbClient` deleted outright, having become a one-line passthrough
+      — `GamesApiService`, `GameDetailApiService` and `FeaturedApiService` now
+      depend on `SupabaseIgdbProxyService` and their tests mock it, which
+      overturns that run's own guarantee that callers and their tests needed no
+      change; (4) `games_test.dart` / `game_detail_test.dart` error cases
+      throw and assert `DioException` (new `mockDioException` fixture) instead of
+      the now-impossible `FunctionException`. Four manual checks were never
+      performed and are carried in `handover.md`, not here.
```

### .agents/handover.md — § "Known non-blocking gaps (carried forward)" (AC-7.4)

Appended after the existing last bullet (the account-picker rough edge). Both are
open work, so they go here and **not** into the ephemeral checklist:

```markdown
 detail in `roadmap-deferred.md`.
+- Item 10.1 left dead code behind, deferred by the human on 2026-08-07 to a
+  separate run: `BaseRepositoryMixin`'s `on FunctionException` catch branch,
+  `ErrorType.supabaseIgdbError`, `mockFunctionException`, and
+  `games_repository_test.dart`'s "throws FunctionException" test are all
+  unreachable now that `supabase_igdb_client.dart` — the only producer of
+  `FunctionException` — is gone. All still present and still passing; removing
+  them is its own run, not a defect in 10.1.
+- Item 10.1's four manual checks have never been performed by anyone, and need a
+  device:
+  - `10.1-AC-16` — debug **dev** build: each IGDB call should print its request
+    line and `{endpoint, query}` body, and a failed call should print status,
+    message and the function's error body. The 50-line response trim, its
+    omitted-line note and the caller stack trace are gone by approved deviation —
+    do not expect them.
+  - `10.1-AC-17` — **release** build and **prod-flavour** build: exercise the
+    games list, expect zero IGDB transport output in the console.
+  - `10.1-AC-2` — a dev build and a prod build each hit their own Supabase
+    project host (visible in the dev build's logger output).
+  - `10.1-AC-10` — with an expired access token, or a forced 401, the games list
+    still loads with no error shown to the user.
```

### .agents/handover.md — § "Where things stand" (step 15, CONDITIONAL)

**Only if the human approves it at the Phase 3 gate.** `tech-ac.md ## Out of
scope` currently bars this paragraph from being touched, but AC-7.4 puts item
10.1's leftovers into the same document, so the file would otherwise carry work
left over from an item it also says never started.

```markdown
-**Item 10.1 (IGDB client transport: Dio + Retrofit) is written up but not
-started.** Full brief is in `week-1-task-briefs.md`'s "### 10.1" section —
-swap `SupabaseIgdbClient`'s transport from `functions.invoke` to Dio +
-Retrofit hitting the `igdb-proxy` Edge Function's URL directly, with a new
-Supabase-session auth interceptor. Ready for a normal PIPELINE run, nothing
-blocking it.
+**Item 10.1 (IGDB client transport: Dio + Retrofit) shipped 2026-08-07** and is
+merged to `develop` — see `week-1-task-briefs.md`'s "### 10.1" entry for what
+landed and which deviations were approved. It left two things open, both under
+"Known non-blocking gaps" below: a dead-code follow-up and four manual checks.
```

If the gate says no, skip it and record the residual inconsistency in
`diff-summary.md` instead.

### .agents/handover.md — § "Next-session prompt" (step 18, last content edit)

Human-approved on 2026-08-07. The block currently tells the next session to "Do
item 10.1 next", which shipped and merged that same day, and describes item 11 as
parked at a gate it has since passed. Written last so it reflects the run's true
end state, and worded so it stays correct whenever it is read — it sends the
reader to the state file for item 11's status instead of asserting one, which is
the only formulation that survives this very run finishing.

Everything above "Current state:" — the "Resume QuestLoggd" opener and the
"Before anything else" bullets — is unchanged. Replace from "Current state:" to
the end of the code block:

```text
-Current state: items 1-10 (with 6.1/6.2) are all done and merged to develop.
-The only other open thing is item 3's on-device cross-account RLS check,
-blocked until something writes to library_entries (week 3's Library
-feature) -- nothing to do there right now unless asked to build a temporary
-test screen sooner.
-
-Do item 10.1 next: IGDB client transport, Dio + Retrofit. Full brief is in
-.agents/week-1-task-briefs.md's "### 10.1" section -- read it in full before
-starting, it already records several decisions made in discussion last
-session (do not reuse NetworkModule/TwitchAuthInterceptor as-is, do reuse
-ConfigConstants' timeout values, IgdbCallLog's fate vs. talker_dio_logger is
-an open call for this item's own BA/Tech Lead phase to make, not pre-decided).
-Normal PIPELINE run through /orchestrate, nothing blocking it. Gotcha #7 in
-handover.md if the custom ba-agent/tech-lead-agent/dev-agent/qa-agent types
-aren't available yet when you try to spawn one.
-
-Also still open, not started this run: item 11 (repo cleanup) has an
-existing run parked at the Phase 3 human design gate in
-.agents/runs/cleanup-20260806/ -- resume and get a decision on that existing
-run rather than starting a new one, whenever it comes up.
-
-Items 10.1 and 11 are the last two week-1 checklist items. Once both ship,
-week 1 is done -- delete week-1-task-briefs.md per its own top note, and
-check with the human on what's next (week 2 component library, or week 3
-Library/tracker migration).
+Current state: items 1-10 and 10.1 (with 6.1/6.2) are all done and merged to
+develop. Item 11 (repo cleanup) is the last week-1 checklist item, and its run
+folder is .agents/runs/cleanup-20260806/ -- read that folder's
+orchestrator-state.md `Current phase` line before assuming anything: COMPLETE
+means item 11 shipped too and week 1 is done; anything else means the run is
+still live, so resume it rather than starting a new one for item 11. Gotcha #7
+in handover.md if the custom ba-agent/tech-lead-agent/dev-agent/qa-agent types
+aren't available yet when you try to spawn one.
+
+Still open regardless: item 3's on-device cross-account RLS check, blocked
+until something writes to library_entries (week 3's Library feature) --
+nothing to do there right now unless asked to build a temporary test screen
+sooner. Item 10.1 also left a dead-code follow-up and four never-performed
+manual checks behind; both are in handover.md's "Known non-blocking gaps".
+
+Once week 1 is done, delete week-1-task-briefs.md per its own top note, and
+check with the human on what's next (week 2 component library, or week 3
+Library/tracker migration).
```

Check `orchestrator-state.md` before writing this and adjust if reality has moved
past the proposed wording.

### README.md and .agents/references/*.md (12 files)

In the allowlist for REQ-11.5's scan only. Expected outcome for every one of them
is **nothing removed**, recorded per file with a one-line reason (AC-6.1). Do not
open these files to fix anything else you notice in them.

## DELETE

`git rm -r` these three, after step 12's qualification check passes for each and
after steps 13–14's records are written. Confirm the real list with `git ls-files`
first and remove what it reports, not what this plan expects:

```text
.agents/runs/igdb-client-repoint-20260805/   expected 9 files
    ambiguities.md  code-plan.md  diff-summary.md  orchestrator-state.md
    qa-report.md  source-request.md  task-brief.md  tdd.md  tech-ac.md
.agents/runs/sentry-20260806/                expected 8 files
    ambiguities.md  code-plan.md  diff-summary.md  orchestrator-state.md
    qa-report.md  task-brief.md  tdd.md  tech-ac.md
.agents/runs/igdb-transport-20260807/        expected 8 files
    ambiguities.md  code-plan.md  diff-summary.md  orchestrator-state.md
    qa-report.md  task-brief.md  tdd.md  tech-ac.md
```

`.agents/runs/cleanup-20260806/` stays in full — it is this run (AC-7.1(d)).

Expected AC-7.6 search result for the three names after deletion: hits in
`.agents/week-1-task-briefs.md` (the new retired-folder records — correct with the
folders gone) and in this run's own artifacts (history). `handover.md`'s "one
folder per pipeline run … removed once a run is complete" line names no folder and
reads correctly. Anything else that *instructs* a reader to open a deleted folder
must be fixed.

## INDEX OPERATIONS

No file content is authored here; these are the load-bearing part of REQ-11.1,
REQ-11.2 and REQ-11.6, shown in execution order.

```sh
# after the .gitignore edit, so nothing can restage it
git rm --cached coverage/lcov.info
git ls-files coverage/          # expect empty
ls coverage/lcov.info           # expect the file still on disk
git status --short              # expect no line mentioning coverage/

# after .gitattributes is saved, before every other item's edits —
# exactly one pass, repo-wide
git add --renormalize .

# scope gate: every changed blob must match a .gitattributes pattern
git status --short
git diff --cached --stat

# after the AC-7.3/AC-7.4 records are written, in the same commit
git rm -r .agents/runs/igdb-client-repoint-20260805 \
          .agents/runs/sentry-20260806 \
          .agents/runs/igdb-transport-20260807
ls .agents/runs/                # expect exactly: cleanup-20260806
git status --short              # expect no untracked residue under those paths
```

Expected in the renormalisation diff: only files matching `*.g.dart`,
`*.freezed.dart`, `*.gr.dart`, `*.config.dart`, `*.mocks.dart` (AC-1.4). Those
blobs are committed as part of this change, not reverted or split out (AC-1.5).

Prohibited: hand-editing line endings, any scripted bulk rewrite across generated
files, and any second renormalise pass. Gotcha #2 records a bulk pass silently
corrupting generated content.

## VERIFICATION

```sh
git status                                                   # capture "before"
dart run build_runner build --delete-conflicting-outputs
git status                                                   # capture "after"
git diff --stat
```

AC-1.6 passes only when the "after" capture reports zero modified generated Dart
files. A generated file with a *real* insertion/deletion diff, rather than a pure
line-ending difference, is gotcha #2's corruption symptom: `git checkout --` the
affected files, re-verify, escalate. Do not hand-repair.

```sh
flutter analyze > .agents/runs/cleanup-20260806/analyzer-baseline.txt   # step 8
# ... sweep, deletions, docs, folder retirement ...
flutter analyze   # vs "0 errors, 2 warnings, 32 info"
flutter test      # vs "+218 -11"
```

Baselines quoted verbatim from `orchestrator-state.md` as read at execution time
(AC-4.4 — not AC-4.2's older inline numbers). The two analyzer runs must agree
with each other and with the baseline: deleting a public constant the analyzer
never reported cannot move the count, so any movement means the deletion was wrong
or created a new diagnostic (AC-5.11).

Sweep commands, per member, both forms, both trees (AC-5.4) — the counts, not a
tool's summary, are the evidence:

```sh
rg -n --glob '*.dart' '\bRouteConstants\.root\b' lib test
rg -n --glob '*.dart' '\broot\b'                 lib test
# then, for each zero-reference candidate, its literal value (AC-5.8)
rg -n "'/'" lib test supabase android pubspec.yaml *.env.example
```

## TEST FILES

None. Testing mode is `none` (cosmetic/config-only) — see
`task-brief.md ## Testing mode`. No file under `test/` may be edited (AC-5.12);
`test/` is read only as a source of references. Never a golden test.

## COMMIT

One commit for the whole brief, per `git.md`. Conventional-commit message,
`chore:` scope, no file list in the body, no AI signature or `Co-Authored-By`
trailer, never `--no-verify`, never pushed by the Dev Agent. The body must state
that the renormalised generated files are an intended one-time consequence of the
`.gitattributes` fix (AC-1.7), and that the three retired run folders' records
land in the same commit as their deletion.

# Diff Summary — item 11, repo cleanup
Source: `.agents/week-1-task-briefs.md` § "11 — Cleanup [PIPELINE]", plus
`.agents/runs/cleanup-20260806/tech-ac.md`
Date: 2026-08-07
Branch: claude/questloggd-item-10-1-igdb-ogvf5r (harness-designated session
branch, see `orchestrator-state.md ## Note on branch naming`)
Commit: 37f82ee85413ed9089de0f5fc0d9fc9c560e85c6

## Read the diffstat first

0 generated Dart files needed renormalising in this checkout — this
environment's git config carries no `core.autocrlf` and every generated file
was already stored with LF endings, so `git add --renormalize .` produced no
generated-file diff. The `.gitattributes` fix (REQ-11.1) still lands and is
correct and needed for any tree that does carry the CRLF/LF mismatch the
brief describes; it is simply a no-op renormalisation here. This is not a
gap in the fix, only an artefact of this run's environment (AC-1.6/AC-1.7).
25 deleted `.md` files — the three retired run folders (REQ-11.6).
Everything else is 6 files: `.gitattributes`, `.gitignore`, `pubspec.yaml`,
`lib/core/res/const.dart`, `.agents/week-1-task-briefs.md`,
`.agents/handover.md` — plus the index deletion of `coverage/lcov.info` and
this run's own artifacts.

## REQ-11.1 — .gitattributes and renormalisation

`.gitattributes` extended (lines 1–12 untouched) with the five generated-Dart
patterns from the brief, each `text eol=lf`, under a new comment naming
build_runner as the LF writer. No blanket rule added.

`git status` before `dart run build_runner build --delete-conflicting-outputs`:
```
On branch claude/questloggd-item-10-1-igdb-ogvf5r
Changes to be committed:
	modified:   .gitattributes
	modified:   .gitignore
	deleted:    coverage/lcov.info
	modified:   pubspec.yaml
```
`git status` after: identical — no generated Dart file reported modified.
`git diff --stat` after the build: empty (no output). AC-1.6 passes: zero
generated Dart files reported modified, before or after regeneration.

`git add --renormalize .` (run once, after `.gitattributes` was saved and
before every other edit) changed no file's stored content beyond what was
already staged from steps 2–4 (`.gitattributes`, `.gitignore`,
`coverage/lcov.info`'s removal, `pubspec.yaml`) — no generated Dart file, no
hand-written source, no doc/asset/config file appeared in the renormalisation
diff (AC-1.4). Nothing to name individually per AC-1.7 because nothing
changed content as a result of the renormalise pass itself; the fix (the
`.gitattributes` patterns) is landing and correct regardless.

## REQ-11.2 — coverage untracked

`.gitignore` gained a `# Coverage` section (`coverage/`) after the `# FVM
Version Cache` block; no existing line touched. `git rm --cached
coverage/lcov.info` removed it from the index only. `git ls-files coverage/`
returns empty. The file still exists on disk (`ls coverage/lcov.info`
confirmed, 57593 bytes). `git status` reports it in no category (ignored by
the new rule).

## REQ-11.3 — envied TODO

`pubspec.yaml` line 102: `# TODO: To deprecate this package and use
flutter_secure_storage` deleted; the line now reads
`  envied: ^1.3.4`. No replacement comment. `flutter_secure_storage` no
longer appears anywhere in the file (only remaining hit, the removed one,
confirmed gone). `envied_generator` at line 136, and every other dependency,
unchanged. `pubspec.lock` untouched — `flutter pub get` was not run.

## REQ-11.4 — unused-declaration sweep

**Analyzer baseline** (`analyzer-baseline.txt`, captured before any Dart edit
this run — tree at that point = base commit + the three config edits only):
34 issues, 0 errors, 2 warnings, 32 info.

Classification by diagnostic code:
- Unused-declaration family (`unused_import`, `unused_field`,
  `unused_local_variable`, `unused_element`, `unused_shown_name`,
  `unused_catch_clause`, `dead_code`): **1** —
  `unused_element` on `_TaskReminder`
  (`task_detail_screen.dart:201:7`).
- Not in that family: **33** — 1 `unused_element_parameter`
  (`task_detail_screen.dart:204:29`, closely related but not one of the
  seven named codes) plus 32 lint-rule infos
  (`lines_longer_than_80_chars`, `avoid_redundant_argument_values`,
  `unnecessary_underscores`, `prefer_const_constructors_in_immutables`,
  `deprecated_member_use`).

AC-5.2 observations:
(a) `analysis_options.yaml linter.rules` has 17 entries; none is an
unused-declaration rule.
(b) `unused_element`/`unused_element_parameter` appear in the baseline
anyway — they are built-in analyzer diagnostics, not lint rules, so (a) not
naming them doesn't suppress them.
(c) `analyzer.exclude` lists the five generated-Dart globs plus
`lib/generated/**`; nothing unused inside generated/localisation output is
in the baseline or in scope here.
`analysis_options.yaml` was read only, never edited.

AC-5.3: the analyzer catches unused private declarations and unused
imports; it reports nothing about unused **public** declarations — every
`static const` on every `*Constants` class is invisible to it. The baseline
above (1 unused-declaration-family issue, private) is not evidence about the
two constants files; that is what the grep sweep below is for.

**Constants sweep** — every `static const` in `lib/core/res/const.dart` (52
members) and `lib/features/onboarding/const.dart` (6 members), both the bare
name and `Class.member` form, over all of `lib/` and `test/`. Full 58-member
qualified-count table (declaration line excluded):

| Member | Qualified refs | Verdict |
|---|---|---|
| ConfigConstants.baseUrl | 0 | deleted |
| ConfigConstants.igdbBaseUrl | 1 (`network_module.dart`, `@Deprecated`) | kept — AC-5.6 |
| ConfigConstants.gamesEndpoint | 0 | deleted |
| ConfigConstants.screenshotsEndpoint | 0 | deleted |
| ConfigConstants.apiKey | 1 | kept |
| ConfigConstants.heroTag | 2 | kept |
| ConfigConstants.enviedFilePath/.enviedDevFilePath/.enviedProdFilePath | 1 each | kept |
| ConfigConstants.supabaseUrl/.supabaseAnonKey | 2 each | kept |
| ConfigConstants.sentryDsn | 1 | kept |
| ConfigConstants.connectTimeout/.receiveTimeout/.sendTimeout | 3 each | kept |
| PathConstants.lottieAnimationAssetPath | 0 | deleted |
| PathConstants.imagePath | 3 | kept |
| AssetConstants.error404 | 1 | kept |
| StorageConstants.firstUseKey | 18 | kept |
| StorageConstants.trackerSortTagKey | 2 | kept |
| SupabaseConstants.* (4 members) | 1 each | kept |
| SentryConstants.* (3 members) | 1–4 | kept |
| StringConstants.emptyStringPlaceholder | 7 | kept |
| StringConstants.na | 1 | kept |
| StringConstants.connectionTimeout | 7 | kept |
| StringConstants.sharedPrefTypeError | 0 | deleted |
| RouteConstants.root | 0 | deleted |
| RouteConstants.home | 0 | deleted |
| RouteConstants.featured | 0 code refs | kept — AC-5.7 (`project-conventions.md` § "Hero transition pattern") |
| RouteConstants.games | 2 (`games_screen.dart`) | kept |
| RouteConstants.tracker | 1 (`tracker_screen.dart`) | kept |
| RouteConstants.trackerDetail | 0 | deleted |
| RouteConstants.taskDetail | 0 | deleted |
| RouteConstants.imagePageView | 0 | deleted |
| RouteConstants.onboarding | 0 qualified, but self-referenced bare inside `openPaths = {onboarding, auth, legal}` | kept |
| RouteConstants.gameDetail | 0 | deleted |
| RouteConstants.browse/.news/.settings | 0 each | deleted |
| RouteConstants.auth/.legal | 0 qualified, self-referenced inside `openPaths` | kept |
| RouteConstants.openPaths | 1 | kept |
| IGDBConfig.standardGameFields | 5 | kept |
| SupabaseIgdbProxyConstants.* (4 members, incl. its own `gamesEndpoint`) | 1–9 | kept |
| WelcomeAssetConstants.* / WelcomeLayoutConstants.* (onboarding, 6 members) | 1–3 each | kept, file byte-identical |

Full search commands and raw match locations were run per member
(`rg -n --glob '*.dart' 'ClassName\.member\b' lib test` and the bare-name
form); the table above is the reduced result, not a tool summary — every
count was read from listed match locations.

**Value search (AC-5.8)** for the 14 zero-reference candidates, across
`lib/`, `test/`, `supabase/`, `android/`, `pubspec.yaml`,
`dev.env.example`/`secret.env.example`/`prod.env.example`:
- `RouteConstants.root` ('/') — the literal `'/'` also appears in
  `auto_route_config.dart:20` as the router's own independently-declared
  root path. This is the exact situation the BA's confirmed finding
  describes: every route in `auto_route_config.dart` is a hardcoded literal
  that reads no constant from `RouteConstants` (see `ambiguities.md`); the
  coincidence is not a hidden reference to this constant, so it does not
  block deletion.
- `RouteConstants.gameDetail` ('/game_detail') — no match; the router's own
  literal is `/game-detail` (hyphen), confirming the documented drift.
- `RouteConstants.home/.trackerDetail/.taskDetail/.imagePageView/.browse
  /.news/.settings`, `ConfigConstants.baseUrl`,
  `StringConstants.sharedPrefTypeError` — no match anywhere outside their own
  declaration.
- `ConfigConstants.gamesEndpoint`/`.screenshotsEndpoint` ('games'/
  'screenshots') — the literal `'games'` also appears in
  `SupabaseIgdbProxyConstants.gamesEndpoint`'s own (separate, kept) constant,
  in `lib/generated/l10n.dart` as an unrelated localisation message name, in
  `auto_route_config.dart` as the router's own route-path literal, and in a
  test's map key; `'screenshots'` appears only in `l10n.dart`'s localisation
  key. None of these read `ConfigConstants.gamesEndpoint`/
  `.screenshotsEndpoint` — each is an independent, coincidentally-identical
  string for an unrelated purpose. Not a block.
- `PathConstants.lottieAnimationAssetPath` ('assets/animations/') — the same
  literal appears in `pubspec.yaml`'s `flutter.assets` list (line 154). That
  is pubspec's own static asset-folder declaration, required regardless of
  whether this Dart constant exists; pubspec.yaml does not read Dart
  constants. Not a block.

No `@Envied(varName:)`-style indirect read, no DI name lookup, and no
generated-code reference was found for any of the 14.

**Members deleted** (`lib/core/res/const.dart`, pure-deletion diff, nothing
else changed): `ConfigConstants.baseUrl`, `.gamesEndpoint`,
`.screenshotsEndpoint`; `PathConstants.lottieAnimationAssetPath`;
`StringConstants.sharedPrefTypeError`; `RouteConstants.root`, `.home`,
`.trackerDetail`, `.taskDetail`, `.imagePageView`, `.gameDetail`, `.browse`,
`.news`, `.settings`. 14 members, matching the independently re-verified
zero-reference set.

`lib/features/onboarding/const.dart` — swept, all 6 members referenced
(1–3 qualified refs each), file left byte-identical.

**AC-5.10 findings, not deleted:**
- `_TaskReminder` and its commented-out call site in
  `task_detail_screen.dart` — CRITICAL-1, resolved 2026-08-07 by the human
  choosing option A, out of scope, left alone.
- No other whole class or file, and no unused public declaration outside the
  two constants files, was found during this sweep. (The sweep covers only
  the two constants files per REQ-11.4's scope; it makes no completeness
  claim about the rest of `lib/`.)

**Consequence reported, not fixed:** `.agents/references/api-contracts.md`
§ "Known gaps" mentions `ConfigConstants.baseUrl` as legacy to avoid (not a
convention to follow, so AC-5.7 doesn't retain it) — that line is now stale.
Correcting it is barred by AC-6.4 and the file isn't in this run's write set.

**This sweep is not a completeness proof.** It establishes zero references
for the 58 named members by showing the searches and their results. It says
nothing about members it didn't search, and it cannot see dynamic
construction, name-based DI/generator lookups, or analyzer-excluded
generated code — which is why the separate AC-5.8 value search exists.

## REQ-11.5 — docs cull

All 15 files scanned (`README.md`, `.agents/handover.md`,
`.agents/week-1-task-briefs.md`, all 12 files in `.agents/references/`).
Outcome for every file: **nothing removed.**

- `README.md` — no finished-task content at all.
- `.agents/handover.md` — every "done"/"complete" hit is either the
  AC-6.3-protected framing/per-item paragraphs, or inside the "Item 10.1"
  and "Next-session prompt" text this run edits under REQ-11.6/the approved
  deviation (substantive corrections, not a cull removal).
- `.agents/week-1-task-briefs.md` — every hit is an AC-6.3-protected
  `- [x] Done` entry or the ephemeral top banner.
- `.agents/references/api-contracts.md`, `flutter-arch.md`,
  `game-detail-design-conventions.md`, `onboarding-auth-design-spec.md`,
  `questloggd-design-product-brief.md`, `system-foundation-specs.md` — every
  "done"/"complete(d)" hit is prose or a UI/library status value ("Completed"
  as a tracker status, "done" inside a design description, "complete route
  lifecycle", DI wiring being "done" by generated code), never a
  finished-task note. AC-6.3's carve-out for these applies directly.
- `.agents/references/roadmap-deferred.md` — three genuine finished-task
  notes ("✅ RESOLVED 2026-08-05", "shipped 2026-08-05" ×2). All three fail
  AC-6.2(c): each carries a date, a run-folder name, or forward-looking
  reasoning (known rough edges, what's still deferred, "revisit when
  Settings gets a real spec") that would be lost. Left alone.
- `dart-style.md`, `home-screen-design-conventions.md`,
  `onboarding-welcome-design-spec.md`, `project-conventions.md`,
  `testing-conventions.md` — zero "done"-family hits.

Empty removal set across all 15 files — a valid, passing outcome per
`task-brief.md ## Testing mode`'s own framing of this item as "expected to
remove nothing."

## REQ-11.6 — run folders retired

AC-7.1 check, all four folders under `.agents/runs/`:

| Folder | (a) COMPLETE | (b) no escalation.md | (c) escalations resolved/NONE | (d) not this run | Qualifies |
|---|---|---|---|---|---|
| `igdb-client-repoint-20260805` | yes | yes | yes (1 entry, resolved) | yes | yes |
| `sentry-20260806` | yes | yes | yes (1 entry, resolved) | yes | yes |
| `igdb-transport-20260807` | yes | yes | yes (NONE) | yes | yes |
| `cleanup-20260806` | no (DEV) | — | — | no | no — this run |

AC-7.5 open-work re-read: `sentry-20260806`'s `## Follow-up actions` records
both `[10.12]` (Sentry delivery, needed `--flavor dev`) and `[10.18]` (IGDB
log lines) confirmed on-device 2026-08-07 — nothing open, matches the
expected outcome. `igdb-client-repoint-20260805`'s manual device testing is
recorded in `week-1-task-briefs.md` lines 357–358 (games list, search,
pagination, game detail, all three Featured sections, offline/retry, fresh
install) — also matches. Nothing further migrated from either.

`igdb-transport-20260807` carried the two AC-7.4 items, migrated into
`.agents/handover.md ## Known non-blocking gaps`: the `FunctionException`
dead-code follow-up and the four never-performed manual checks
(`10.1-AC-16`, `10.1-AC-17`, `10.1-AC-2`, `10.1-AC-10`), each with enough
of its own text (verified against `qa-report.md`'s wording) to be executable
without the deleted folder.

`.agents/week-1-task-briefs.md` written before deletion: item 9's pointer
replaced with the substance of the second approval it pointed at
(`IgdbProxyConstants`→`SupabaseIgdbProxyConstants`,
`ErrorType.functionError`→`ErrorType.supabaseIgdbError`, commits `8f9f9bf`/
`5cd8a4f`); items 10 and 10.1 given full shipped entries from their
`orchestrator-state.md`/`qa-report.md` (dates, SHAs, QA outcome, cycle
counts, every approved deviation) and ticked `- [x] Done`. All three records
verified against the source folders' own files before the folders were
deleted (`orchestrator-state.md` for all three, `qa-report.md` for
`igdb-transport-20260807`'s manual-check text).

Deleted: `git rm -r` on the three folders — 9 + 8 + 8 = **25 files**, every
one tracked, matching `git ls-files`'s real list exactly (not just the
brief's expected counts). `.agents/runs/` afterwards contains exactly one
entry, `cleanup-20260806`. No untracked residue.

AC-7.6 cross-reference search, all three folder names, repo-wide: every
surviving hit is either this run's own artifacts (`task-brief.md`,
`tech-ac.md`, `tdd.md`, `ambiguities.md`, `code-plan.md` — history/plan
text, correct as history) or `week-1-task-briefs.md`'s new retired-folder
records, which name the folders as retired history and read correctly with
them gone. No surviving instruction points a reader into a deleted folder.
`handover.md`'s general "one folder per pipeline run … removed once a run is
complete" line names no folder and reads correctly unchanged.

Two human-approved deviations applied in the same commit: `handover.md
## Next-session prompt` rewritten (dropped the shipped "do item 10.1 next"
instruction and the stale "item 11 parked at gate" line; now points readers
at `orchestrator-state.md`'s `Current phase` line instead of asserting a
status) and `handover.md § "Where things stand"`'s item 10.1 paragraph
corrected from "written up but not started" to "shipped 2026-08-07". Both
recorded in `orchestrator-state.md ## Deviation approvals` before this pass.

## Deviations from implementation plan

NONE — every step executed as planned. One environmental note (not a
deviation from the plan, but worth flagging): this container's git has no
`core.autocrlf` set and every generated Dart file already had LF line
endings, so `git add --renormalize .` found nothing to rewrite. The
`.gitattributes` fix is correct and lands as specified; it simply had no
content to renormalise in this particular checkout.

## Files created

.agents/runs/cleanup-20260806/analyzer-baseline.txt — verbatim `flutter analyze` output captured before any Dart edit
.agents/runs/cleanup-20260806/diff-summary.md — this file

## Files modified

.gitattributes — five generated-Dart `text eol=lf` patterns appended under a new comment; lines 1–12 untouched
.gitignore — `# Coverage` / `coverage/` section appended after `# FVM Version Cache`; no existing line touched
pubspec.yaml — trailing TODO comment deleted from the `envied` line; nothing else changed
lib/core/res/const.dart — 14 zero-reference `static const` members deleted; nothing else changed
.agents/week-1-task-briefs.md — item 9's pointer completed; items 10 and 10.1 given full shipped entries and ticked
.agents/handover.md — item 10.1's dead-code follow-up and four manual checks migrated in; "written up but not started" corrected to "shipped"; "Next-session prompt" rewritten (both human-approved deviations)

## Files deleted (index)

coverage/lcov.info — `git rm --cached`; still present on disk

## Folders deleted

.agents/runs/igdb-client-repoint-20260805/ — 9 tracked files
.agents/runs/sentry-20260806/ — 8 tracked files
.agents/runs/igdb-transport-20260807/ — 8 tracked files

## Test files

None — testing mode: none.

## Self-corrections

NONE.

## Verification against baseline

`flutter analyze`: 34 issues, 0 errors, 2 warnings, 32 info — matches
`orchestrator-state.md`'s baseline (`0 errors, 2 warnings, 32 info`) exactly,
before and after the constants deletions.
`flutter test`: +218 -11 — matches `orchestrator-state.md`'s baseline
(`+218 -11`) exactly. Pre-existing failures unchanged:
`test/repository/tracker/tracker_repository_test.dart` (4),
`test/cubit/game_detail/game_detail_cubit_test.dart` (3),
`test/cubit/games/games_bloc_test.dart` (3), `test/widget_test.dart` (1).
No test file touched (AC-5.12).

## Acceptance criteria status

AC-1.1: satisfied
AC-1.2: satisfied
AC-1.3: satisfied
AC-1.4: satisfied
AC-1.5: satisfied — no generated file changed content this run, so nothing to revert/split; the rule was landed
AC-1.6: satisfied
AC-1.7: satisfied
AC-2.1: satisfied
AC-2.2: satisfied
AC-2.3: satisfied
AC-3.1: satisfied
AC-3.2: satisfied
AC-5.1: satisfied
AC-5.2: satisfied
AC-5.3: satisfied
AC-5.4: satisfied
AC-5.5: satisfied
AC-5.6: satisfied
AC-5.7: satisfied
AC-5.8: satisfied
AC-5.9: satisfied
AC-5.10: satisfied
AC-5.11: satisfied
AC-5.12: satisfied
AC-6.1: satisfied
AC-6.2: satisfied — empty removal set
AC-6.3: satisfied
AC-6.4: satisfied
AC-6.5: satisfied
AC-7.1: satisfied
AC-7.2: satisfied
AC-7.3: satisfied
AC-7.4: satisfied
AC-7.5: satisfied
AC-7.6: satisfied
AC-7.7: satisfied
AC-7.8: satisfied
AC-4.1: satisfied
AC-4.2: superseded by AC-4.4, see AC-4.4
AC-4.3: superseded by AC-4.4, see AC-4.4
AC-4.4: satisfied

## QA cycle 1 fix

AC-7.6 came back PARTIAL: the item 9 pointer replacement at
`.agents/week-1-task-briefs.md:366-368` left a dangling `; see` lead-in
running into the next sentence. Fixed by closing the sentence at
`… carve-out for this.` and leaving the next line as its own sentence — one
line, no other change. New commit: `12d08d9bb0dcafdd3ffccb7dc68dd9ff6f0ceb13`.

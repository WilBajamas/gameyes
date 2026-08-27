# Orchestrator State
Feature: Week 3 item 3.2 — Tab swap, Library shell, Tracker and Browse tab retirement
Run ID: library-tab-swap-20260826
Run folder: .agents/runs/library-tab-swap-20260826/
Started: 2026-08-26
Current phase: HUMAN_GATE
QA cycles used: 0
Analyzer baseline: 0 errors, 2 warnings, 28 info (30 issues total) — captured 2026-08-26T17:30:00Z
Test baseline: +361 -10 — captured 2026-08-26T17:32:00Z
Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart (4), test/cubit/game_detail/game_detail_cubit_test.dart (3), test/cubit/games/games_bloc_test.dart (3)
Branch: feature/library-tab-swap
Base branch: feature/library-foundations (item 3.1) — NOT develop
Base SHA: 14da82c3aad19e48fe52c78d14eaff49209b5583
Dev commit: NONE
Last updated: 2026-08-26T17:32:00Z

## Escalation history
2026-08-26T17:45:00Z Phase 1 — ba-agent — CRITICAL: `saved_game_status_tag.dart` cannot be retired without editing the protected task tree — Resolved: orchestrator applied the human's standing task-tree decision (defer the retirement); the week-3 checklist was corrected at the same time

## Orchestrator decision — 2026-08-26, Phase 1

**The retirement of `saved_game_status_tag.dart` is DEFERRED out of item 3.2.**

This was an error in `.agents/week-3-task-briefs.md`, not a discovery about the
code. That retirement list was written **before** the human decided to keep the
task tree, and was never re-checked against that decision. The item's stated
rationale — "loses its only reachable caller the moment the tabs change" — is
true for `tracker_screen.dart` and `saved_game_item.dart` and **false** for
`saved_game_status_tag.dart`, whose only caller is
`tracker_game_detail_screen.dart:131-133`, a file the task-tree decision protects.

Verified independently: `grep -rn "SavedGameStatusTag"` returns exactly one call
site, and it is that one.

Not escalated to the human because it needs no new decision — their standing
ruling ("leave the task tree for now; a design convention is coming") admits only
this answer. The alternatives both edit the protected screen, and substituting
`StatusChip` would additionally require inventing which status a spec-less screen
should display. The widget and its `Status` enum retire alongside whichever item
adopts the task-tree convention.

`.agents/week-3-task-briefs.md` item 3.2 was corrected in the same pass so the
wrong instruction cannot be inherited by a later session — that file is read as
current intent.

## Corrections to the checklist's inherited claims, found by Phase 0 grep

- **The six-row `setActiveIndex` table is correct and complete.** Verified line by
  line. A seventh occurrence exists at `home_screen.dart:27` — a tear-off with no
  literal, needing no change. Note the Library shell will add a **seventh literal**,
  so "the count is six" is a pre-change fact only.
- **`bottom_tab_bar.dart` confirmed index-free** — iterates `values`, uses
  `destination.index`. No change, verified rather than assumed.
- **`browse_screen.dart` was understated** in the checklist: 59 lines, a
  `StatefulWidget` with its own `ScrollController` and a sliver app bar, not a bare
  `Center(child: Text('Browse'))`. Still free to delete — one file, no bloc, no
  datasource.
- **The `tracker` l10n key also becomes unreferenced**, not just `browse`. The
  checklist named only `browse`.
- **`bottom_tab_bar_test.dart` needs more than fixture edits**: `:80` pumps
  `selectedIndex: 4`, and `:166-172` is built on `S.current.tracker` and asserts
  `tabLabel(tabIndex: 3, tabCount: 5)`.
- **`default_sliver_app_bar_test.dart:20,82` uses the literal string `'Browse'` as
  an unrelated fixture.** Must not be swept up by a text search for Browse.
- **`library_stats.dart:315` sits in a branch that has never rendered** (Featured's
  `statusEqualTo('Playing')` filter has no writers). It must still change — the
  branch starts firing when item 3.4 lands.
- **`DefaultAlertDialog` is NOT orphaned**, contrary to the BA's report:
  `task_detail_screen.dart` also uses it and survives. `TrackerCubit` and
  `default_filter_list_app_bar.dart` genuinely are orphaned; both are flagged, not
  swept, and neither is an analyzer issue.

## Deviation approvals
NONE

## Code review outcomes
NONE

## Run notes

Requirement text: `.agents/week-3-task-briefs.md`, "Stage 3 — Foundations and
data", item 3.2. Read `.agents/handover.md`'s "Stage 3 brief" for the six human
rulings; **ruling 1 and ruling 6 govern this item directly**, and the
`setActiveIndex` table under them is this item's core work.

**This run is STACKED on item 3.1, not branched from `develop`.** 3.1 was
complete and QA-PASSed at `e1ada3a` but had not been merged when 3.2 opened.
Branching from `develop` would have handed this run's BA the **uncorrected**
design docs — `library-design-conventions.md` §5 still carrying the rejected
`saturate(.5) contrast(1.05)` and §11 still saying "gradient" — which is the
precise recurrence 3.1 exists to prevent. Consequence: 3.1 and 3.2 must merge to
`develop` **in order**. If 3.1 is revised after this point, rebase this branch.

Baselines re-verified on this branch rather than carried over from 3.1's run;
both are unchanged, as expected for a tokens-and-docs item.

The 2 analyzer warnings are the deliberate `_TaskReminder` pair in
`task_detail_screen.dart`. The task tree is **dormant by human decision** all
week — this item deletes its only real entry point but must not delete the tree
itself. A run reporting 28 issues has broken something.

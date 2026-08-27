# Orchestrator State
Feature: Week 3 item 3.2 — Tab swap, Library shell, Tracker and Browse tab retirement
Run ID: library-tab-swap-20260826
Run folder: .agents/runs/library-tab-swap-20260826/
Started: 2026-08-26
Current phase: COMPLETE
Result: PASS — pending manual checks
Completed: 2026-08-26
QA cycles used: 0
Analyzer baseline: 0 errors, 2 warnings, 28 info (30 issues total) — captured 2026-08-26T17:30:00Z, PRE-deletion
Analyzer at completion: 0 errors, 2 warnings, 26 info (28 issues total) — the drop is info lints in the three deleted files; later items in this stage should expect 28
Test baseline: +361 -10 — captured 2026-08-26T17:32:00Z
Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart (4), test/cubit/game_detail/game_detail_cubit_test.dart (3), test/cubit/games/games_bloc_test.dart (3)
Branch: feature/library-tab-swap
Base branch: feature/library-foundations (item 3.1) — NOT develop
Base SHA: 14da82c3aad19e48fe52c78d14eaff49209b5583
Dev commit: e7dcee40ac820649a8af333874a63da9dab6449f
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

## Human decisions — 2026-08-26, Phase 3 design gate

**D6 — the tab set is FIVE, not four: `Featured(0) · Library(1) · Browse(2) ·
Feed(3) · Settings(4)`.** This supersedes the four-tab target the BA and Tech Lead
built to, so both artifacts are stale and this run returns to Phase 1.

- **Browse = the existing Games screen, relabelled.** Not the old
  `browse_screen.dart` stub, which is still deleted. The relabel is **user-visible
  only**: `lib/features/games/` keeps its name, bloc, repository and datasource;
  `GamesScreen` keeps its class name. That screen is due for its own redesign, so
  renaming the feature now is a large diff on code slated for replacement. The
  route path (`games` → `browse`) is a Tech Lead call — nothing user-visible turns
  on it, because Android has no `VIEW` intent filter and URL deep links cannot be
  delivered at all.
- **`games_screen.dart:171` uses `S.current.games` as its own app-bar title** and
  must follow the tab, or screen and tab disagree.
- **Feed is a new, deliberately BARE placeholder** — title plus `Center(Text(...))`.
  The human explicitly chose this over the `EmptyStateCard` shell the Library tab
  gets. It is replaced wholesale when Feed is designed. It must not write to
  `ScrollNotifier`.
- **Settings does NOT move.** It stays at index 4.

**What D6 does not change:** the six-row `setActiveIndex` table is unaffected —
every "go find a game" site still lands on 2, and `library_stats.dart:315` still
moves to 1.

**What D6 inverts:** the `browse` l10n key is now **kept** (it is slot 2's label,
and is already translated as 浏览). The orphaned key is **`games`** (游戏), plus
`tracker`. `library` and `feed` are both added, and both need real zh values.

**What D6 makes cheaper:** `bottom_tab_bar_test.dart` stays at five destinations,
so `tabCount: 5` and `selectedIndex: 4` remain valid — much less churn than the
four-tab shape. TL-1's two run-time-failing assertions still apply unchanged.

**D7 — TL-4 resolved, and it mostly dissolves.** Because the app returns to five
tabs, `.claude/skills/flutter-widgets/SKILL.md:220`'s "five fixed destinations …
the other four" becomes **correct again** and needs no edit. Only `:160` and
`:202`, which list the deleted `SavedGameItem`, go stale. Whether that two-line
correction rides in this item or a follow-up was not explicitly answered — treat
it as in scope, since it is two lines inside the same class of staleness item 3.1
exists to close, and a skill file is the *enforcing* copy agents are told to obey.

## Human decisions — 2026-08-26, Phase 3 design gate (revision 2)

**D8 — the design is APPROVED, with no widget test for the Feed shell.**
`test/widget/feed/feed_screen_test.dart` leaves scope; the human approved
proceeding straight to Dev afterwards, so there is no re-gate.

Scope of D8, checked before routing:
- **Only `3.2-AC34` is retired.** It is the sole test-bound Feed criterion.
- **`3.2-AC32` and `3.2-AC33` survive as source reads.** AC32 (a title plus one
  centred `Text`, no `EmptyStateCard`, no glyph, no action, no `setActiveIndex`)
  and AC33 (no bloc/cubit/repository/use case/datasource/DTO/entity/DI, no
  `ScrollController` listener, no `ScrollNotifier` write) are both verifiable by
  reading `feed_screen.dart`. QA must read the file, not infer from a green suite —
  the same treatment `3.1-AC4` received under D5.
- **`3.2-AC33` is the one that matters most without a test.** It is the second of
  two chances in this item to reopen item 2.4's closed `ScrollNotifier` follow-up,
  and now nothing automated guards it.
- **The Library shell keeps its test** (`3.2-AC29`). Only Feed's goes.
- **The expected suite count changes**: it rises by the Library shell's tests only,
  no longer by Feed's. Any criterion quoting a post-change total needs that.
- The three glyphs are approved as proposed: Library
  `Icons.collections_bookmark_outlined`, Browse `Icons.search_outlined`, Feed
  `Icons.dynamic_feed_outlined`. The struck ruling-1 sentence that forbade
  `search_outlined` stays struck.
- The Tech Lead's call that slot 2's **route path stays `games`** was not
  overruled, so it stands.

## Deviation approvals
NONE

## Code review outcomes
2026-08-26T19:40:00Z e7dcee40ac820649a8af333874a63da9dab6449f — Reviewed and approved by human

### Two things the orchestrator verified at this gate, both worth carrying

**The analyzer baseline for this branch is now 28 issues, not 30 — and that is
correct, not drift.** The orchestrator's Dev briefing said "a result of 28 means
something broke". That heuristic was about the **2 warnings** (the `_TaskReminder`
pair, which proves the protected task tree survived) and was wrongly generalised
to the total. Dev hit 28, investigated instead of forcing it back, and traced the
drop to info-level lints that lived only in the three deleted files. Verified
independently at the gate: 0 errors; **2 warnings, both still in
`task_detail_screen.dart`**; and no new issue in any file this item touched — the
five hits in `featured_screen.dart:195,270` and `bottom_tab_bar.dart:22` are
pre-existing (unrelated `_` patterns, and the redundant `elevation: 0` that item
2.4 knowingly kept). **Later items in this stage should expect 28 / 2 warnings.**

**Dev ran `git stash` once while diagnosing that count, which `git.md` forbids
outright.** It self-reported, popped immediately, and confirmed the tree. Verified
rather than trusted: `git stash list` is empty and the working tree is clean, so
nothing was stranded. Recorded because an agent reaching for a forbidden command
under diagnostic pressure is worth knowing — and it happened because the
orchestrator's own wrong instruction sent it hunting a problem that did not exist.
The rule held because the agent reported itself.

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

# Ambiguities Report
Source: `.agents/week-3-task-briefs.md` — Stage 3, item 3.2 (as corrected 2026-08-26), with the preamble "How to use this", "What week 3 does NOT touch", "Baselines"; `.agents/handover.md` "Stage 3 brief" rulings 1 and 6 and the six-row `setActiveIndex` table; `orchestrator-state.md` "## Orchestrator decision — 2026-08-26, Phase 1"
Date: 2026-08-26

## CRITICAL (pipeline blocked — requires human decision before proceeding)

NONE

## RESOLVED

RESOLVED-1 (was CRITICAL-1): item 3.2 "Retires here" vs. "What week 3 does NOT
touch" — `saved_game_status_tag.dart` could not be deleted without editing the
protected task tree.

**Resolution: option A — defer the retirement.** Recorded in
`orchestrator-state.md`, "## Orchestrator decision — 2026-08-26, Phase 1", and in
its escalation history. `saved_game_status_tag.dart` and its `Status` enum stay
exactly as they are this run and retire alongside whichever item adopts the
incoming task-tree design convention. `tracker_screen.dart` and
`saved_game_item.dart` still retire here.

The retirement bullet was an error in the checklist, not a discovery about the
code: it was written before the human's decision to keep the task tree and never
re-checked against it. The bullet's stated rationale — these widgets "lose their
only reachable caller the moment the tabs change" — holds for the other two and is
false for this one, whose sole caller `tracker_game_detail_screen.dart:131-133` is
protected. No new human decision was needed; their standing ruling admits only this
answer. `.agents/week-3-task-briefs.md` item 3.2 has been corrected in place so the
wrong instruction cannot be inherited.

Carried into criteria as [3.2-AC16] (widget and screen untouched), [3.2-AC18]
(whole tree untouched, and the 2-warning analyzer baseline that depends on it).

## ASSUMPTIONS (minor — pipeline may proceed)

All of these are carried into `tech-ac.md`. None blocks. The first is the only one
worth a human glance at the Phase 3 gate.

ASSUMPTION: **The Library tab's glyph is unspecified anywhere and is assumed to be
`Icons.collections_bookmark_outlined`.** `library-design-conventions.md:168` says
only "Tab bar. Unchanged from Home. Library active: indigo glyph and label";
`home-screen-design-conventions.md:108-115` describes a five-tab bar
(Home · Library · Search · Feed · Profile) with sizes but no icon names, and that IA
is superseded by ruling 1 in any case. This is a genuine gap in the design docs, not
a reading failure. The assumed glyph matches the existing set's `_outlined`
convention and reads as a saved collection rather than as books or video. **One enum
line; nothing is blocked by it, so it is recorded here for the human to overrule at
the Phase 3 gate rather than escalated.**

ASSUMPTION: **The Library shell's empty state reuses existing copy** — headline
`no_games_saved`, supporting line `no_games_saved_description`, action `browse_games`
routing to the Games tab, in `EmptyStateCard`. No new copy keys. Both
`no_games_saved` keys are freed by `tracker_screen.dart`'s deletion (that screen's
improvised bare-`Text` empty state at `:179-202` is their only current use) and both
still hold English values in `intl_zh.arb`, so reuse folds two more untranslated keys
into this run instead of minting throwaway copy. `EmptyStateCard` has no action-less
form — `actionLabel` and `onActionPressed` are both required — so an empty state
without a destination is not available without a dead button. §11's recruit card,
`surfaceArtDeep`, the green CTA and the `Showing 0 games out of 0` line all stay with
item 4.5.

ASSUMPTION: **The shell's empty state renders unconditionally.** This item ships no
data source, no bloc and no repository call, so there is no populated state to branch
on and no loading or error state to design.

ASSUMPTION: **The shell adds a seventh `setActiveIndex` literal**, `setActiveIndex(2)`
(Games) — the same destination as Featured's two `browse_games` empty states. Phase 0's
"the count is six" is a statement about the **pre-change** tree; afterwards the correct
figure is eight occurrences, seven of them literals. Flagged because a QA check phrased
as "six sites" would fail a correct build.

ASSUMPTION: **The shell does not write to `ScrollNotifier`.** `browse_screen.dart` is
one of its three writer sites and is deleted here, leaving two (`settings_screen`,
`home_screen`); a third from the new screen would quietly reopen item 2.4's follow-up,
which the item text explicitly forbids. `home_screen.dart`'s `NotificationListener`
already covers the tab body.

ASSUMPTION: **New file at `lib/features/library/presentation/screens/library_screen.dart`**,
carrying `@RoutePage()` so `LibraryRoute` generates; no `lib/features/library/` tree
exists today. Route path `library`, placed second in both `auto_route_config.dart`'s
children and `home_screen.dart`'s `routes:` list.

ASSUMPTION: **`.arb` edits are exactly three**: add `library` to both files, delete
`browse` from both, delete `tracker` from both. The item text names only `browse` as
becoming unreferenced; `tracker` becomes unreferenced by the same edit (its only uses
are the enum label switch and the tab-bar test fixture). `browse_games` and
`browse_for_your_next_game` stay — both are live on Featured (`featured_screen.dart:205`,
`countdown_releases.dart:91-92`). Every other key that loses its last caller with
`tracker_screen.dart` (`delete_saved_game`, `recently_changed`, and the rest of that
screen's strings) is **left in place**: an unreferenced key costs an unused getter and
nothing else, while deleting one silently removes its getter (gotcha #1) and item 3.4
may want them back.

ASSUMPTION: the zh value for `library` is **游戏库**. If it overflows the tab cell in
`bottom_tab_bar_test.dart`'s "renders every destination without overflow in zh at a
raised text scale" case, the fallback is the two-character 收藏 rather than widening
the cell — the tab bar's geometry is not this item's to change. (追踪 and 浏览 are two
of the very few Chinese strings ever fixed and both are deleted here, so the
untranslated count will not fall the way the diff suggests.)

ASSUMPTION: **`library` compiles as an `S` member.** It is a Dart *built-in
identifier*, not a reserved word, so `intl_utils` generating `String get library` and
a call of `S.current.library` are both legal. Written as the criterion ([3.2-AC22])
rather than carried as an open question. `library_tab` is the fallback **only if the
generator or analyzer actually rejects it** — Dev has a shell and can confirm in
seconds; BA does not.

## PHASE 0 FINDINGS (verified independently — corrections to the inherited text)

Recorded in full in `orchestrator-state.md`, "## Corrections to the checklist's
inherited claims, found by Phase 0 grep". Kept here for the criteria that trace to
each one.

OBSERVATION-1: **the six-row `setActiveIndex` table is correct and complete.** A
repo-wide grep returns exactly six literal call sites, at exactly the lines and with
exactly the values the handover records — `featured_screen.dart:144,145,147` (`1`),
`featured_screen.dart:207` (`3`), `countdown_releases.dart:93` (`3`),
`library_stats.dart:315` (`2`). Current tab order is
`featured(0) games(1) tracker(2) browse(3) settings(4)`, so every row's "Now"
destination checks out. A **seventh** occurrence, `home_screen.dart:27`, is a tear-off
with no literal and needs no change. No other tab-index literal exists anywhere:
`activeIndex`, `tabsRouter` and `AutoTabsRouter` were also grepped, and the only other
`activeIndex` hits are `ProgressDots`' onboarding dots. → [3.2-AC6], [3.2-AC7],
[3.2-AC9].

OBSERVATION-2: **`bottom_tab_bar.dart` genuinely needs no change** — verified, not
assumed. It iterates `BottomTabBarDestination.values` and uses `destination.index` for
both the selected comparison and the reported index (`:33-39`). Nothing in it names a
count or a slot. `bottom_tab_bar_cell.dart` is likewise index-free. → [3.2-AC2].

OBSERVATION-3: **`library_stats.dart:315` sits in a branch that has never rendered.**
It is inside the `playingGames.isNotEmpty` path, and Featured's "Playing" games come
from `featured_local_datasource.dart:46`'s `statusEqualTo('Playing')` filter against a
field with no writers — the never-fired branch item 3.4 repairs. The literal still has
to change: it starts firing the moment 3.4 lands, and by then nothing points at it as
a stale index. The same applies to the `TrackerGameDetailRoute` push at `:319`, which
survives. → [3.2-AC6] failure case, [3.2-AC4].

OBSERVATION-4: **`browse_screen.dart` is a bigger stub than the brief describes.** The
item and ruling 1 both call it `Center(child: Text('Browse'))`. It is 59 lines: a
`StatefulWidget` with its own `ScrollController`, an `initState`/`dispose` pair, a
`ScrollNotifier` write in `_onScroll`, a `DefaultSliverAppBar(title: S.current.browse)`
and a `CustomScrollView`. "No bloc, no datasource, one file, no folder beyond
`presentation/screens/`" is confirmed — `lib/features/browse/` contains exactly that
one file — so the deletion is still free; the description is understated. → [3.2-AC15].

OBSERVATION-5: **`default_sliver_app_bar_test.dart` contains the literal string
`'Browse'` twice** (`:20`, `:82`) as a title fixture, unrelated to `BrowseScreen` or
the `browse` l10n key. A grep-driven sweep would break a passing test for no reason.
→ [3.2-AC28].

OBSERVATION-6: **`bottom_tab_bar_test.dart` is 8 tests and needs more than a fixture
edit.** Beyond dropping the two fixture lists from five entries to four: `:80` pumps
`selectedIndex: 4`, which stops existing; `:166-172` is built entirely around
`S.current.tracker` and asserts `MaterialLocalizations.tabLabel(tabIndex: 3, tabCount: 5)`,
so the string and both numbers move (Library is enum index 1, tab 2 of 4); and `:199`'s
test name says "keeps all five destinations". → [3.2-AC24] to [3.2-AC27].

OBSERVATION-7: **deleting `tracker_screen.dart` orphans two things this item does not
retire** — `TrackerCubit` (still DI-registered at `service_locator.config.dart:337`,
still has passing tests in `test/cubit/tracker/tracker_cubit_test.dart`) and
`default_filter_list_app_bar.dart`. Neither is on the retirement list, neither produces
an analyzer issue, and item 3.4 renames and extends the tracker preferences plumbing.
Left alone, flagged not fixed. **Correction to this run's earlier report:
`default_alert_dialog.dart` is NOT orphaned** — `task_detail_screen.dart:319` also uses
it and that file survives. → [3.2-AC17].

OBSERVATION-8: **no test pumps `HomeScreen` or asserts the tab route list.** The four
test files importing `auto_route_config` use unrelated routes (`session_navigator_test`,
`auth_guard_test`, `games_screen_test`, `welcome_screen_test`), so
`bottom_tab_bar_test.dart` is the only existing test this item touches. → [3.2-AC30].

OBSERVATION-9: **the design docs still describe a different tab bar.**
`home-screen-design-conventions.md:113` says "Five tabs: Home · Library · Search · Feed ·
Profile". Ruling 1 supersedes it, so nothing here is in doubt — but the doc is now a
fifth place a future BA can inherit a dead IA from, the same failure shape item 3.1
exists to close. Correcting it is out of scope; noted for the handover.

OBSERVATION-10: **`library_stats.dart:314` carries the stale comment
`// Route to Tracker tab [Z1-BL-04]`**, one line above the literal that changes. Widget
files carry no comments in this project, so it is removed rather than reworded.
→ [3.2-AC10].

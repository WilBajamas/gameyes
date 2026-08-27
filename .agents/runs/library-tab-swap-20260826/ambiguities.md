# Ambiguities Report
Source: `.agents/week-3-task-briefs.md` — Stage 3, item 3.2 (as corrected 2026-08-26 at the Phase 3 gate), with the preamble "How to use this", "What week 3 does NOT touch", "Baselines"; `.agents/handover.md` "Stage 3 brief" ruling 1 (as corrected) and ruling 6 and the six-row `setActiveIndex` table; `orchestrator-state.md` "## Human decisions — 2026-08-26, Phase 3 design gate" (D6, D7) and "## Orchestrator decision — 2026-08-26, Phase 1"
Date: 2026-08-27 (revision 2 — retargeted from the superseded four-tab shape to D6's five)

## CRITICAL (pipeline blocked — requires human decision before proceeding)

NONE

The tab structure is settled by D6 and nothing in this revision needs a business
decision to proceed. The one genuine document conflict found — slot 2's glyph — is
one enum line either way and is recorded as an assumption below, first in the list.

## RESOLVED

RESOLVED-1 (was CRITICAL-1): item 3.2 "Retires here" vs. "What week 3 does NOT
touch" — `saved_game_status_tag.dart` could not be deleted without editing the
protected task tree.

**Resolution: option A — defer the retirement.** Recorded in
`orchestrator-state.md`, "## Orchestrator decision — 2026-08-26, Phase 1", and in
its escalation history. `saved_game_status_tag.dart` and its `Status` enum stay
exactly as they are this run and retire alongside whichever item adopts the
incoming task-tree design convention. `tracker_screen.dart` and
`saved_game_item.dart` still retire here. Unaffected by D6.

Carried into criteria as [3.2-AC16] (widget and screen untouched), [3.2-AC18]
(whole tree untouched, and the 2-warning analyzer baseline that depends on it).

RESOLVED-2: the tab set itself. **D6, human, at the Phase 3 design gate:
`Featured(0) · Library(1) · Browse(2) · Feed(3) · Settings(4)` — five tabs.** Two
shapes are dead and are recorded only so they are recognised as dead rather than
as options: `Featured · Library · Games · Browse · Settings` (five, Games kept)
and `Featured · Library · Games · Settings` (four, Browse deleted). This artifact
and `tech-ac.md` were written to the second of those and have been revised, not
regenerated.

RESOLVED-3 (was TL-4, resolved by D7): `.claude/skills/flutter-widgets/SKILL.md`.
At five tabs, `:220`'s "five fixed destinations … the other four" is correct again
and is **not** edited. Only `:160` and `:202`, which list the now-deleted
`SavedGameItem`, go stale, and that two-line correction is in scope — it is the
same class of staleness item 3.1 exists to close, in the *enforcing* copy agents
are told to obey. → [3.2-AC39].

## ASSUMPTIONS (minor — pipeline may proceed)

All of these are carried into `tech-ac.md`. None blocks. The first three are the
ones worth a human glance; the first is the only one where two project documents
actually disagree.

ASSUMPTION: **Slot 2's glyph is `Icons.search_outlined`** — the surviving `browse`
enum value keeps the icon it already carries. **Two source sentences pull opposite
ways.** Item 3.2 says "the `browse` value **survives and is reused** for the Games
screen", which reads as the value surviving intact, icon included. Ruling 1 says
"for now Games keeps its name and `Icons.gamepad_outlined`. Do not pre-emptively
rename it or hand it `Icons.search_outlined`" — but that sentence's premise (Games
keeps its name) is precisely what D6 reverses, and D6's "user-visible only" carve-
out is about code identity (folder, class, bloc), which does not settle a glyph
either way. A search glyph also matches the human's stated end state for this tab.
Assumed rather than escalated because it is **one enum line**, plus one test
fixture line ([3.2-AC24]) and one icon finder ([3.2-AC37]) — nothing is blocked in
either direction. **One line to overrule at the gate.**

ASSUMPTION: **The Library tab's glyph is unspecified anywhere and is assumed to be
`Icons.collections_bookmark_outlined`.** Unchanged from the previous pass and not
touched by D6. `library-design-conventions.md:168` says only "Tab bar. Unchanged
from Home. Library active: indigo glyph and label";
`home-screen-design-conventions.md:108-115` gives sizes but no icon names. A genuine
gap in the design docs, not a reading failure. The assumed glyph matches the
existing set's `_outlined` convention and reads as a saved collection rather than
as books or video. One enum line.

ASSUMPTION: **The Feed tab's glyph is likewise unspecified and is assumed to be
`Icons.dynamic_feed_outlined`.** Same shape, same reasoning and same cost as the
Library glyph. `home-screen-design-conventions.md:117` mentions Feed only to say it
keeps its tab; no spec describes the tab bar's Feed glyph anywhere.

ASSUMPTION: **The Library shell's empty state reuses existing copy** — headline
`no_games_saved`, supporting line `no_games_saved_description`, action
`browse_games` routing to Browse at index 2, in `EmptyStateCard`. No new copy keys.
Both `no_games_saved` keys are freed by `tracker_screen.dart`'s deletion (that
screen's improvised bare-`Text` empty state at `:179-202` is their only current use)
and both still hold English values in `intl_zh.arb`, so reuse folds two more
untranslated keys into this run instead of minting throwaway copy. `EmptyStateCard`
has no action-less form — `actionLabel` and `onActionPressed` are both required — so
an empty state without a destination is not available without a dead button. §11's
recruit card, `surfaceArtDeep`, the green CTA and the `Showing 0 games out of 0`
line all stay with item 4.5.

ASSUMPTION: **Feed's centred line reuses the existing `coming_soon` key** ("Coming
Soon" / "即将推出"). It exists in both `.arb` files with a real Chinese value; its
only other caller is `game_loading_data.dart:18`, where it stands in for an unknown
release date — the words fit, the context differs. The fallback, if the human wants
Feed-specific copy, is to mint `feed_coming_soon` in both files with a real zh
value. Recorded because the item text specifies Feed's *shape*
(`Center(Text(...))`) and not its words.

ASSUMPTION: **The two shells are deliberately asymmetric and that asymmetry is
load-bearing.** Library gets `EmptyStateCard`; Feed gets a bare centred `Text` and
explicitly **no** card — the human chose this at the gate. Feed is replaced wholesale
when designed, while Library's empty state is the one item 4.5 evolves. Written as a
criterion with an explicit `findsNothing` assertion ([3.2-AC32], [3.2-AC34]) rather
than left as prose, because "improving" Feed into Library's shape is the obvious and
wrong instinct for the next run that touches it.

ASSUMPTION: **Both shells render unconditionally.** This item ships no data source,
no bloc and no repository call, so there is no populated state to branch on and no
loading or error state to design.

ASSUMPTION: **The Library shell adds a seventh `setActiveIndex` literal**,
`setActiveIndex(2)` (Browse) — the same destination as Featured's two `browse_games`
empty states. Feed adds none. Phase 0's "the count is six" is a statement about the
**pre-change** tree; afterwards the correct figure is eight occurrences, seven of
them literals. Flagged because a QA check phrased as "six sites" would fail a correct
build.

ASSUMPTION: **Neither shell writes to `ScrollNotifier`.** `browse_screen.dart` is one
of its three writer sites and is deleted here, leaving two (`settings_screen`,
`home_screen`); a third from either new screen would quietly reopen item 2.4's
follow-up, which the item text explicitly forbids — and D6 doubles the opportunity by
adding a second new screen. `home_screen.dart`'s `NotificationListener` already covers
the tab body.

ASSUMPTION: **New files at
`lib/features/library/presentation/screens/library_screen.dart` and
`lib/features/feed/presentation/screens/feed_screen.dart`**, each carrying
`@RoutePage()` so `LibraryRoute` and `FeedRoute` generate; neither feature folder
exists today. Route paths `library` and `feed`, placed second and fourth in both
`auto_route_config.dart`'s children and `home_screen.dart`'s `routes:` list. Slot 2's
path is **not** assumed — it is the Tech Lead's call ([3.2-AC4]).

ASSUMPTION: **`.arb` edits are exactly four**: add `library` and `feed` to both files,
delete `games` and `tracker` from both. **`browse` is kept** — D6 inverted this from
the four-tab pass, where `browse` was the key being deleted; it is now slot 2's label
and `games_screen.dart:171`'s title, and it is already translated (浏览).
`browse_games` and `browse_for_your_next_game` stay throughout — both are live on
Featured (`featured_screen.dart:205`, `countdown_releases.dart:91-92`). Every other key
that loses its last caller with `tracker_screen.dart` (`delete_saved_game`,
`recently_changed`, and the rest of that screen's strings) is **left in place**, as is
`games_screen_subtitle`, whose caller survives: an unreferenced key costs an unused
getter and nothing else, while deleting one silently removes its getter (gotcha #1) and
item 3.4 may want them back.

ASSUMPTION: the zh values for the new keys are **游戏库** (library) and **动态** (feed) —
real translations, not English placeholders, per the translate-as-you-touch rule. If
either overflows the tab cell in `bottom_tab_bar_test.dart`'s "renders every destination
without overflow in zh at a raised text scale" case, the fallback is a shorter word (收藏
for library) rather than widening the cell — the tab bar's geometry is not this item's to
change. Note the translation arithmetic inverted with D6: 浏览 now **survives**, and the
real values being deleted are 追踪 (tracker) and 游戏 (games).

ASSUMPTION: **`library` compiles as an `S` member.** It is a Dart *built-in identifier*,
not a reserved word, so `intl_utils` generating `String get library` and a call of
`S.current.library` are both legal. Written as the criterion ([3.2-AC22]) rather than
carried as an open question. `library_tab` is the fallback **only if the generator or
analyzer actually rejects it** — Dev has a shell and can confirm in seconds; BA does not.
`feed` is an ordinary identifier and raises no question.

## PHASE 0 FINDINGS (verified independently — corrections to the inherited text)

Recorded in full in `orchestrator-state.md`, "## Corrections to the checklist's
inherited claims, found by Phase 0 grep". Kept here for the criteria that trace to
each one. All were re-checked against D6; the ones D6 moves are marked.

OBSERVATION-1: **the six-row `setActiveIndex` table is correct and complete, and D6
does not move a single row.** A repo-wide grep returns exactly six literal call sites,
at exactly the lines and with exactly the values the handover records —
`featured_screen.dart:144,145,147` (`1`), `featured_screen.dart:207` (`3`),
`countdown_releases.dart:93` (`3`), `library_stats.dart:315` (`2`). Every "go find a
game" site still lands on **2** (Browse, i.e. the Games screen) and `library_stats`
still moves to **1**. A **seventh** occurrence, `home_screen.dart:27`, is a tear-off
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
one file — so the deletion is still free; the description is understated. Under D6 its
*name* passes to the Games screen and its *code* still dies. → [3.2-AC15].

OBSERVATION-5: **`default_sliver_app_bar_test.dart` contains the literal string
`'Browse'` twice** (`:20`, `:82`) as a title fixture, unrelated to `BrowseScreen`, the
`browse` l10n key or the relabelled Games screen. D6 raises this risk rather than
lowering it: "Browse" is now a live label a run has reason to be editing. → [3.2-AC28].

OBSERVATION-6 (**substantially changed by D6**): **`bottom_tab_bar_test.dart` is 8
tests, it stays at five destinations, and the churn is now mostly retargeting rather
than resizing.** `:80`'s `selectedIndex: 4` stays valid (Settings is still last) and
`:166-172`'s `tabLabel(tabIndex: 3, tabCount: 5)` stays valid — `tabIndex` is 1-based,
so `tabIndex: 3` names enum index 2, which was Tracker and is now Browse, the same
slot. Only the string at `:166`, `:167`, `:172` moves. `:199`'s "keeps all five
destinations" is still true and is **not** renamed. The two fixture lists at `:9-23`
keep their length and change their contents. → [3.2-AC24] to [3.2-AC27].

OBSERVATION-7: **deleting `tracker_screen.dart` orphans two things this item does not
retire** — `TrackerCubit` (still DI-registered at `service_locator.config.dart:337`,
still has passing tests in `test/cubit/tracker/tracker_cubit_test.dart`) and
`default_filter_list_app_bar.dart`. Neither is on the retirement list, neither produces
an analyzer issue, and item 3.4 renames and extends the tracker preferences plumbing.
Left alone, flagged not fixed. `default_alert_dialog.dart` is **NOT** orphaned —
`task_detail_screen.dart:319` also uses it and that file survives. → [3.2-AC17].

OBSERVATION-8: **no test pumps `HomeScreen` or asserts the tab route list.** The four
test files importing `auto_route_config` use unrelated routes (`session_navigator_test`,
`auth_guard_test`, `games_screen_test`, `welcome_screen_test`), so
`bottom_tab_bar_test.dart` is the only existing test this item touches.
`games_screen_test` asserts no app-bar title string, so [3.2-AC35]'s title change does
not reach it either. → [3.2-AC30].

OBSERVATION-9: **the design docs still describe a different tab bar, and D6 makes the
resemblance closer.** `home-screen-design-conventions.md:113` says "Five tabs: Home ·
Library · Search · Feed · Profile". Ruling 1 supersedes it — but it is now also five
tabs and also has a Feed, so only three of five names differ and it reads more like the
truth than it did. Correcting it is out of scope; noted for the handover as a place a
future BA can still inherit a dead IA.

OBSERVATION-10: **`library_stats.dart:314` carries the stale comment
`// Route to Tracker tab [Z1-BL-04]`**, one line above the literal that changes. Widget
files carry no comments in this project, so it is removed rather than reworded. `:317`'s
`// Go to Tracker detail for this game` describes `TrackerGameDetailRoute`, which
survives — not stale, not this item's to sweep. → [3.2-AC10].

OBSERVATION-11 (**new — carries forward the Tech Lead's TL-1, which the previous BA pass
missed**): **two assertions in `bottom_tab_bar_test.dart` break at run time, not compile
time.** `:107` asserts `expect(reported, [1, 1, 1])` after tapping the cell found by
`find.text(S.current.games)`; that cell moves 1 → 2, so the correct assertion is
`[2, 2, 2]`. `:141` pumps `selectedIndex: 1` and then asserts the Games cell is selected;
index 1 is Library now, so the pumped index must become 2. The compiler *does* force the
string edit — `S.current.games` stops existing under [3.2-AC19] — but says nothing about
either number, so a mechanical `games` → `browse` sweep leaves both wrong and both
green-looking until the suite runs. Given their own criteria this pass rather than left
to the baseline check. → [3.2-AC37], [3.2-AC38].

OBSERVATION-12 (**new — D6**): **`games_screen.dart:171` uses `S.current.games` as its
own app-bar title**, and `:172` uses the separate key `games_screen_subtitle`. The title
must follow the tab or screen and tab disagree; the subtitle key is untouched. Verified
that this is the only non-enum caller of `S.current.games` in `lib/`. → [3.2-AC35],
[3.2-AC21].

OBSERVATION-13 (**new — D6**): **neither `library` nor `feed` exists as an l10n key
today**, and `games` (游戏), `browse` (浏览) and `tracker` (追踪) all exist in both files
with real Chinese values. `coming_soon` also exists in both with a real value (即将推出).
→ [3.2-AC19], [3.2-AC22], [3.2-AC23].

# Handover — QuestLoggd

Written 2026-07-29. Last updated 2026-08-25: **week 2 is COMPLETE — all 8 Stage 2
composites and all 9 Stage 1 primitives are built and merged to `develop`.** Items
2.1 (Game card), 2.2 (Completion ring), 2.3 (Countdown) and 2.4 (Tab bar) shipped
2026-08-21; 2.5 (Form fields), 2.6 (Rows & hairline groups) and 2.7 (Error states)
shipped 2026-08-24; **2.8 (Async states: shared empty state) shipped 2026-08-25**,
merged at `41829d0`. Full detail below.

**Verified, not inherited.** All 18 component files/folders were confirmed present
in `lib/widgets/` on 2026-08-25 rather than read off the checklist's ticks — this
file once claimed Stage 1 complete while 1.8 and 1.9 had never been built, so the
claim above was checked the way that mistake taught. `.agents/week-2-task-briefs.md`
was fully ticked — including the three "Open decisions" that had gone stale (2.5's
and 2.7's were settled inside their own runs and never ticked) — and then **deleted
2026-08-25**, per its own top note. Its three surviving scope rulings were promoted
into this file first (see "Three scope rulings promoted out of..." below); the rest
lives in git history.

**The next task is the manual-check backlog** — see `.agents/manual-check-backlog.md`,
**95 checks**, deliberately deferred through all of Stage 2 for one device sitting.
The human began that sitting on 2026-08-25.

**Baseline moved: the analyzer is now 30 issues (0 errors, 2 warnings, 28 info),
not 33.** Item 2.8 deleted 122 lines from `library_stats.dart`, `_DashedBorderPainter`
among them, taking 3 info issues with them. The 2 warnings are still the deliberate
`_TaskReminder` pair. Test suite is **+347 -10**; the 10 failures are the same
pre-existing set as ever. Verify both at Phase 0 anyway.

---

## Where things stand

**Items 1 through 11 — done, merged to `develop`, nothing outstanding as
pipeline work.** `week-1-task-briefs.md` is deleted per its own top note
(week 1 shipped). The per-item history that used to live there survives only
in git history past commit `167a026` and in the condensed record just below —
see the gotcha at the bottom about why that almost got lost.

**Condensed record of week 1's items 9, 10, 10.1 and 11.** Their run folders are
retired and `week-1-task-briefs.md` is deleted; full text is in git history past
`167a026`. What shipped: IGDB calls moved server-side behind an `igdb-proxy` Edge
Function (item 9, with `NetworkModule`/`TwitchAuthInterceptor` kept `@Deprecated` by
human request); Sentry crash reporting with `environment` from flavour, plus `talker`
logging around the IGDB client (item 10, `7adeb25`); the IGDB client swapped from
`functions.invoke` to Dio + Retrofit, collapsing `SupabaseIgdbClient` into
`SupabaseIgdbProxyService` (item 10.1, `5385338`); and a cleanup pass — `.gitattributes`
line-ending fix, `coverage/` untracked, 14 dead `const.dart` members removed (item 11,
`37f82ee`).

**The one thing from those runs that still binds:** `task_detail_screen.dart`'s unused
`_TaskReminder` class **is** the entire 2-warning analyzer baseline. The human chose to
leave it rather than let an unused-code scan delete it — it is deliberate, not missed,
so do not "fix" it and do not read the 2 warnings as drift.

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
into another, both at human request). `.agents/week-2-task-briefs.md` has since
been **deleted** (2026-08-25), once the whole week shipped, per its own note. Every
Stage 1 box in it was ticked 2026-08-20; they had stayed unticked through
every merge until then.

**A "stage complete" claim is worth one grep before the next stage inherits
it.** This file once claimed Stage 1 was done while 1.8 and 1.9 had never been
built; a resume session caught it by checking rather than believing, and shipped
both the same day. Same shape as gotcha #9. The 2.1 run then found the checklist
misnaming `GameItem`'s callers — so this applies to any inherited claim about
what exists, not just stage status.

**Condensed record of Stage 1's primitives 1.1–1.9.** Run folders retired 2026-08-20;
what each widget *is* now lives in `.claude/skills/flutter-widgets/SKILL.md`'s
catalogue, which is the place to look. Files: `zone_label.dart`, `status_chip.dart`,
`cover_tile.dart`, `placeholder_slot.dart`, `filter_count_chip.dart`,
`context_chip.dart`, `stat_pill.dart`, `progress_dots.dart`, `action_row.dart`.
`provider_action_button.dart` was deleted into `action_row.dart`.

**Four standing conventions were established by those runs and still bind every
widget** — all four are now written into the `flutter-widgets` skill, which is the
enforcing copy; they are listed here only so their origin is not lost:
- **"No spacing of its own"** (1.1) — a reusable widget never carries outer padding or
  a spacing parameter. Human reversal at a Phase 3 gate.
- **"Outlines are always solid"** (1.4) — the spec's dashed border was rejected;
  `system-foundation-specs.md` §0 item 6 records it. Item 2.8 finally removed the last
  live violation.
- **"Dimensions are even numbers"** (1.5/1.6/1.7). `progress_dots.dart`'s 5px values
  are a **recorded exception** — the convention postdates them and the promotion
  preserved them deliberately.
- **"Prefer `Expanded` over `Flexible`, unless the widget hugs its content"**
  (1.5/1.6/1.7), with `StatusChip` as the live hug-content example.

**Two traps from those runs that a future session can still fall into:**
- **The provider row's label renders Inter 16/400, not §3.3's 15px/500** — a promotion
  moves code, it does not restyle a live screen, so the gap is open on purpose and
  needs the missing 15px token. `[1.9-AC5]`'s "full ink" was also wrong: `body` carries
  no colour and inherits `ink70`, so the code pins `ink70` deliberately. **Do not
  "fix" either to match the spec text without asking.**
- **The human wrote three widget test files personally** (1.5/1.6/1.7), via a Phase 3
  revision reversing the BA's test-authorship criterion. That was a one-off by request,
  **not** a standing default — ask again rather than assuming it repeats.

**Week 2 Stage 2 (composites) — 7 of 8 done, only 2.8 left.** 2.1–2.4 shipped
2026-08-21, 2.5–2.7 on 2026-08-24, 2.8 on 2026-08-25; run folders retired. The
checklist that sequenced them is deleted; the standing sources it pointed at are the
visual spec (`system-foundation-specs.md` §3) and the `flutter-widgets`/`flutter-widget-test`
skills. Explicitly out of scope there: `system-foundation-specs.md` §3.1 (an
external, bound design bundle for a different property — not a Flutter build
target), and the Add-to-library sheet (needs week 3's Library feature first).

**Three scope rulings promoted out of `week-2-task-briefs.md` before it was deleted
on 2026-08-25** — this is now their only home:
- **§3.1 is never a Flutter build target.** Its components (`Button`, `Badge`,
  `NavBar`, `Hero`, `FeatureCard`, `PricingTable`, `FaqAccordion`, `CtaBand`,
  `MarqueeBand`, `DataTable`, `Modal`, `Toast`, `EmptyState`, `TextInput`,
  `AuthFormCard`) are mounted via
  `<x-import component-from-global-scope="QuestLoggdDesignSystem_347483.<Name>">` —
  an external bound bundle for a **different property**, reading as a
  marketing/landing-site set. Verified: `x-import` appears nowhere else in this repo.
  Do not build these in Flutter, and do not read §3.1's `EmptyState` as related to
  item 2.8's `EmptyStateCard`.
- **§3.5's "Device frame" is not an in-app component** — a `330×714` showcase frame
  with a label above it, a presentation convention for design mockups. Irrelevant to
  the shipping app; never build it.
- **`add_content_dialog.dart` is NOT the Add-to-library sheet under an old name.**
  It is a tracker-era dialog: no status pre-select, no platform or rating, no green
  CTA, and a `Dialog` rather than a bottom sheet. Building the real sheet before
  week 3's Library entity/status model exists means building it twice.

**Condensed record of Stage 2's composites 2.1–2.8.** Run folders retired; what each
component *is* lives in the `flutter-widgets` catalogue. Files and Dev commits:
`game_card/` `26b5951` · `completion_ring/` `a3a918a` · `countdown/` `5c2266b` ·
`bottom_tab_bar/` `31d3f55` · `labeled_text_field.dart` `79255bd` ·
`label_value_row.dart` + `hairline_group.dart` · `error_states/` `7d69ba4` ·
`empty_state_card.dart` `6199114`. Deleted along the way:
`scrolled_navigation_bar.dart`, `navigation_destination.dart`,
`default_border_text_field.dart`, `detail_screenshot_section.dart`, `game_item.dart`.

**What still binds, per item:**
- **2.1 Game card** — three things ship knowingly off-spec, all deliberate: §3.2's
  desaturation filter is **absent** (rejected at 1.3, rejected again here — `1.3-AC7`
  is a live check that it stays absent), platform marks stay as `PlatformRowList` logo
  images rather than §1.9 abbreviations, and `md`'s 220px is a design reference, not an
  enforced minimum. `LibraryTick` and `CriticBadge` were promoted to app-wide primitives.
- **2.2 Completion ring** — the `linear_progress_bar` package and Material's
  `CircularProgressIndicator` were both **evaluated and rejected**; do not re-open
  without new information. `CompletionRingPainter` is still public, justified only by a
  test that was later deleted — worth revisiting.
- **2.3 Countdown** — **provably timer-free**: every class is a `StatelessWidget`, so
  there is no lifecycle hook to start a timer in and the cubit stays the only clock.
  `ButtonPressScale` is deliberately not reused for that reason. Scope was widened by
  human decision to fix a real bug: the "Wishlisted" badge fired on whole-library
  membership, so a `CountdownGameEntity` now carries a real wishlist boolean and the
  stale-flag bug is *unrepresentable*, not merely avoided.
- **2.4 Tab bar** — **the scroll-hide behaviour was DROPPED by human decision**; the
  bar staying visible is correct, not a regression. `ScrollNotifier` is now fully
  orphaned but deliberately left in place (singleton, DI registration, three writer
  sites, one test registration) — its own follow-up. `elevation: 0` was knowingly kept
  though redundant. The run also corrected a live bug: the old destination painted
  **unselected** indigo and **selected** grey, inverted the entire time it shipped.
- **2.5 Form fields** — composes its own `FormField<String>` around a plain `TextField`
  because `TextFormField` renders its error inside the same decorator as the box, so a
  focus ring would enclose both. **A silent pre-existing bug was fixed here**:
  `maxLengthEnforcement: null` does **not** mean "no enforcement" — it resolves
  per-platform and enforces on Android, so the old flag did the opposite of its name.
- **2.6 Rows & hairline groups** — the hairline guarantee is **a construction, not a
  rule**: placement is `if (index > 0)` and `children` is the only parameter, so a
  leading or trailing hairline is a case the code cannot express. `Column` was chosen
  over `ListView.separated` deliberately (these sit inside already-scrolling screens;
  `shrinkWrap` builds every child anyway, losing the laziness that would justify it).
- **2.7 Error states** — three levels, not §3.4's four: the Field level was already
  shipped by 2.5 and is inherited. §3.4 specs **no per-section retry block**, so
  `ErrorRetryWidget` has no replacement by design. The first foundations edit ever
  permitted in a component run happened here (`surfaceToast` alias) — note
  `app_tokens_test.dart` asserts three *distinct* raised surfaces via a `Set`, so the
  alias had to stay out of it.
- **2.8 Empty state** — see "Bugs found on device" and the §3.2/§2.2 gaps below.

## Lessons that outlive the runs that produced them

Extracted from the per-item records above so they survive the next compression.
Each cost a real cycle to learn.

- **Grep the caller list at Phase 0 — the checklist was wrong 4 times out of 8.**
  2.1's named two files that never referenced the component; 2.6's called a file
  "tracker-specific" when its main caller was a game_detail screen; 2.7's claimed four
  error levels when one was already built; 2.8's carried two callers when a grep found
  seven, two of them holding hardcoded untranslated English nobody had recorded. This
  is the single highest-value thing Phase 0 does.
- **A test can pass by construction.** QA failed 2.7's first cycle for asserting
  `find.byType(TheWidget)` after an interaction where the harness placed that widget
  unconditionally — a self-suppressing widget would still have passed. **Prove
  falsifiability**: inject the regression the test is meant to catch, confirm it fails,
  revert. About two minutes. And **re-prove it if you later change the harness** — a
  harness change can quietly turn a real test into a passing one (item 2.8's app-bar
  fix hit exactly that).
- **Tests import only a module's public entry point.** Item 2.4 shipped ten violations
  (`find.byType(BottomTabBarCell)` ×10) against its own brief; QA caught them late and
  a post-QA commit reworked all eight tests onto the public surface. Easy default to
  fall into.
- **"Ship unwired" is a false choice for an in-place rework.** 2.5's checklist offered
  rework-vs-unwired as if both were available — but the same class in the same file
  changes every caller the moment it merges. Unwired only exists by building a *second*
  component beside the old one (2.6, 2.7). Ask which shape an item is before believing
  a bullet that offers the fork.
- **Removing a test often removes more than its name suggests.** 2.2 lost three
  criteria to one deletion; 2.4 lost the only automated cover for keyboard activation
  and for a colour correction. If asked to trim tests, say what each one carries first.
- **A criterion phrased about position or pixels usually has a checkable form.** 2.6
  could not test "hairline between rows only", so it pinned a count (N children → N−1
  separators) plus the *absence* of any parameter that could move one. 2.7 and 2.8 did
  the same. Reach for that before marking something manual-only.

**One convention still open, and it is the most-repeated gap in this file.**
§3's type steps keep colliding with "dimensions are even numbers": item 1.9 hit 15px
and left the gap open for want of a token, 2.2 hit it and shipped 14, **2.5 hit it a
third time and shipped 14 again**. A 15px type token still does not exist and three
runs have worked around its absence. Minting one is a foundations change, deliberately
kept out of every component run so far. (2.6, 2.7 and 2.8 did **not** hit it — check
rather than assume.)

*The companion convention — flat file versus module folder — was settled on
2026-08-25 and now lives in the `flutter-widgets` skill, which is the enforcing copy.*

---

## The skills, and what they enforce

Dart conventions live in seven invokable skills under `.claude/skills/`, not in the
reference docs — `flutter-widgets`, `flutter-state`, `flutter-usecase`,
`flutter-repository`, `flutter-datasource`, `flutter-dto` (all added 2026-08-07), and
`flutter-widget-test` (2026-08-14/15). The three old reference docs
(`flutter-arch.md`, `dart-style.md`, `project-conventions.md`) were trimmed, not
deleted: they still hold folder structure, the **service layer** (deliberately never
skill-ified — explicit human decision), DI, routing, code generation, localisation,
secrets, platform constraints and naming rules. Read them for anything the seven
skills don't cover.

**Tech Lead, Dev and QA all have Skill tool access** and are told to invoke the
matching component skill rather than reading the old docs by hand. `ba-agent` and
`orchestrate` deliberately do not — BA writes requirement-level criteria, not class
shapes, and the orchestrator never designs or writes code.

**A skill's silence is not authorisation.** QA checks architectural compliance against
**two** sources — `tdd.md` (the task's own design) and the relevant skill (the
project's standing convention) — and a skill-level violation is a FAIL even where
`tdd.md` never mentioned it.

**`flutter-widget-test` keeps changing, and each revision retroactively invalidates
prior passes.** It has been revised four times; the human revised it three times in a
single session, each round forcing a complete re-check of every existing widget test
file. **Always re-read it in full before trusting prior compliance.** Where it stands
now: dimensions are **not tested at all** (height, width, padding, gaps, radii,
offsets, positions are manual checks), colour assertions must carry meaning and name a
token, no golden tests ever, no manufactured image-loading success, and widgets carry
**no comments at all**. `context_chip_test.dart` and `stat_pill_test.dart` are the
human-written reference files — copy their shape and stay near their length.

## Bugs found on device (2026-08-25 sitting)

Two real defects, **found by looking rather than by any check that was hunting for
them** — the first concrete argument this project has for the device sitting being
worth its cost. Both were fixed the same day by direct human-directed edits, outside
the pipeline, at the human's explicit instruction.

- **Screen titles overflowed at Android's largest font size** — Games, Browse and
  Settings, "BOTTOM OVERFLOWED BY 24 PIXELS". **FIXED 2026-08-25** in
  `lib/widgets/default_sliver_app_bar.dart`, with
  `test/widget/components/default_sliver_app_bar_test.dart` (9 tests) guarding it.
  **The part worth carrying forward is why the obvious fix was already present and
  still failing.** `DefaultSliverAppBar` already used `AutoSizeText`, and
  `auto_size_text` was already a dependency — so "use AutoSizeText" was not the fix.
  It failed for two independent reasons:
  1. **`AutoSizeText` with no `maxLines` has no reason to shrink.** It wraps to as
     many lines as it needs; `toolbarHeight: kToolbarHeight + 12` is fixed, so the
     wrapped text overflowed a container that could not grow.
  2. **`maxFontSize` alone is not a ceiling.** Read
     `auto_size_text-3.0.0/lib/src/auto_size_text.dart:353` —
     `fontSize = right * userScale * stepGranularity`. The OS scale multiplies the
     result *after* the min/max clamp, so a 34px `maxFontSize` still renders at 68px
     when Android is at 2×. **A min/max band only becomes a real ceiling if the
     scale factor is clamped too.** Anyone reaching for `AutoSizeText` elsewhere in
     this app to solve an overflow needs to know this.
  The shipped fix sets `maxLines: 1`, a min/max band on both title (22–34) and
  subtitle (11–13), and `textScaleFactor` from
  `MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.3)`. **The trade-off is
  deliberate**: the app-bar title stops honouring OS font scaling past 1.3×. That
  was the human's stated preference over letting it grow.
  Note the test harness models a **24px status-bar inset**, because `flexibleSpace`
  gets the full app-bar extent — without that inset the harness is stricter than any
  real device and forces needless over-shrinking. It caps at **2.0**, which is
  Android's actual maximum; 3.0 tests a condition the platform cannot produce.
  Falsifiability was proved twice — once before the harness was made realistic and
  again after, since changing a harness can silently turn a real test into a
  pass-by-construction one. 8 of 9 fail against the unfixed widget; the one that
  passes is the scale-1.0 case that was never broken.
- **`GamesStatus.empty` was never emitted — the games empty state had never once
  been reachable.** **FIXED 2026-08-25** in `games_bloc.dart`; a successful fetch
  returning zero items now emits `empty` instead of `success`. Guarded by
  `test/cubit/games/games_bloc_empty_test.dart`.
  **This is the most valuable thing the device sitting found**, because two QA
  passes had already looked straight at it. Item 2.7 flagged `games_screen.dart:88`
  as "an empty state wearing an error component" and 2.8 dutifully swapped
  `ErrorRetryWidget` for `EmptyStateCard` — **but the status driving that branch was
  dead the whole time**, so neither the old widget nor the new one had ever
  rendered. `grep -rn "GamesStatus.empty" lib/` returned exactly one hit: the
  render condition. Nothing set it. A widget test cannot catch this — the branch is
  correct, its trigger simply never fires — which is why it survived to a human
  filtering a real games list.
  **Carry the lesson, not just the fix**: when a criterion says "renders X in state
  Y", check that anything ever *produces* state Y.
- **`games_bloc_test.dart`'s three failures have a root cause, now known and
  documented.** They are three of the ten pre-existing suite failures and were a
  mystery for weeks. `GamesBloc`'s constructor calls `add(const GamesFetched())` and
  both handlers use `droppable()`, so the bloc's own initial fetch is always in flight
  first and **every test's `act` event is silently dropped**. Full explanation, the
  two Mockito rules that compound it, and the working pattern are now in
  `.agents/references/testing-conventions.md` under "The pattern above does NOT work
  on a bloc that dispatches in its own constructor" —  read that before touching
  those tests. Fixing the original three needs restructuring, not a one-liner, and
  was deliberately left alone so the baseline did not move mid-session.
- **65 of 167 Chinese strings are untranslated English**, in `lib/l10n/intl_zh.arb`.
  **Only `browse` (浏览) and `tracker` (追踪) were fixed** on 2026-08-25, because
  those were the two visible in the tab bar. **63 remain.** Whole surfaces are still
  affected: every library status (`completed`, `onHold`, `rageQuit`, `toBuy`,
  `inProgress`), the entire group-task and step flow, all six featured-shelf titles,
  the saved-games empty state, and `ok`/`cancel`/`done`/`back`/`edit`/`remove`.
  Get the real list by diffing the two `.arb` files' *values* — do not eyeball it,
  and do not trust the count above without re-running that diff.
  `a_brief_description` also carries a typo in the **English** source:
  `"A breif description"`. Still unfixed.
  Localisation is generated (gotcha #1): edit the `.arb`, then
  `dart pub global run intl_utils:generate`. Never hand-edit `lib/generated/`.

---

## The component library: built, but only half of it has ever rendered

Established 2026-08-25 by grepping callers, not by reading the checklist's ticks.
All 17 week-2 items exist and are merged, but **"done" and "reusable everywhere" are
different claims** and only the first is true.

**8 of 17 have a caller outside `lib/widgets/`** — `EmptyStateCard` (5 sites),
`LabeledTextField` (2), `GameCard`, `BottomTabBar`, `CountdownCard`, `ActionRow`,
`ProgressDots`, `PlaceholderSlot`. **11 have never rendered anywhere**:
`CompletionRing`, `LabelValueRow`, `HairlineGroup`, `ErrorNotice`, `FailedItem`,
`DestructiveActionPair`, `ContextChip`, `StatPill`, `CountdownTile`, `ZoneLabel`,
`CoverTile`. `StatusChip` and `FilterCountChip` sit between the two — composed by
other widgets, never placed by a feature.

**Treat the first use of any unproven component as first use.** Things go wrong at
the seam between a component and a real screen, and 11 of these have never had that
seam. The evidence is item 2.8: it shipped wired to five sites, and one of them
turned out never to have been reachable in the app's history.

**`lib/widgets/` holds three tiers and the filename does not tell them apart** —
design-system components, legacy that is still load-bearing, and unproven new
components. The split is now written out in `.claude/skills/flutter-widgets/SKILL.md`
above its catalogue table; keep it current rather than re-deriving it.

**Do not sweep the legacy out before stage 3.** Human decision, 2026-08-25, after
weighing it: only `game_item.dart` was genuinely dead (deprecated, zero callers) and
it was deleted. Everything else either has live callers — so removing it *is* a
screen rewrite wearing a cleanup costume — or is superseded by a component that has
never rendered, which would leave neither implementation proven.
`horizontal_separator.dart` is the trap that looks safest: 15 lines, hardcoded
`Colors.grey`, superseded by `HairlineGroup` — but its main caller is a **Game
Detail** screen that stage 3 is about to rebuild, so deleting it now means touching
that screen twice. **Retire each legacy widget in the run that adopts its
replacement.**

**Two foundations gaps still block spec-exact work**: no 15px type token (three items
worked around it) and no art-deep surface (§2.2 names it as the empty-state fill and
it has no value anywhere). Both are recorded below.

---

## Known non-blocking gaps (carried forward)

- **REMINDER — the tracker task tree goes dormant at stage 3.2, and is owed a
  design convention before anyone touches it.** Human decision 2026-08-26: leave
  the task tree alone through week 3, and leave the Isar `SavedGame` store alive
  alongside `library_entries`. What that means concretely: item 3.2 deletes
  `tracker_screen.dart` (the tab's list), which is the **only real entry point**
  to `TrackerGameDetailRoute` and `TaskDetailRoute`. After it merges,
  `tracker_game_detail_screen.dart`, `task_detail_screen.dart`, `TaskCubit`,
  `GroupTask`, `SavedGameTask` and `TaskStep` still compile and still pass their
  tests, but are reachable only from `library_stats.dart:319`. That is deliberate,
  not an oversight — **do not "clean up" the orphan, and do not delete the Isar
  store to tidy the two-store situation.** The two stores hold different data and
  never need syncing while this holds.
  The human will supply a new design convention covering task detail, groups and
  group items. **Pick this up when that lands, not before.** The likely shape is
  re-keying tasks onto `library_entries.igdb_id` so the Isar store can retire in
  one move — but that is a guess, not a decision, and the convention outranks it.
  Two consequences worth knowing while it's dormant: the **analyzer baseline stays
  30 issues / 2 warnings** all week, because `_TaskReminder` lives in
  `task_detail_screen.dart` and that file survives; and `2015` lines of
  `lib/features/tracker/` stay in the tree, roughly 1,240 of them the task half.
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
  `.agents/manual-check-backlog.md`** — **77 checks** remaining as of 2026-08-25.
  **Item 2.4 is fully CLEARED** — all fifteen done, the first item in the backlog to
  finish. That includes both entries that had no automated guard at all: keyboard
  Enter/Space activation and the tab bar's selected/unselected colour correction,
  **now confirmed on device rather than inferred**, which retires the largest untested
  risk 2.4 left behind. `MC-4` and `MC-13`'s duration halves were **closed by human
  decision without being observed** — 0ms vs 140ms on a colour crossfade is at or
  below naked-eye perception and was judged not worth a frame-accurate recording;
  that is a deliberate call, not an oversight. **The sitting also turned up two real
  bugs nothing was hunting for, both since fixed** — see "Bugs found on device"
  above. **Do not quote the count from here; recount in the file.**
  **There is no scratch harness, and this file's long-standing advice to build one
  is now reversed.** One was built on 2026-08-25 and **deleted the same day** by
  human decision (`git show faa108b` if it is ever wanted back). The sixteen
  harness-able checks cover components with **zero callers anywhere** — verified by
  grep — so a harness was the only way to display them; but it would check them in
  isolation rather than in the layout they ship in, and several are only meaningful
  in a real screen. **They wait for Game Detail and Library in week 3/4.** Do not
  rebuild the harness without raising it first.
  Also corrected: the "eighteen at once" figure was wrong. `2.7-MC-3` is a real-app
  check ("open Game Detail") that was miscounted with the other four — it, plus 2.8's
  five, are the **only six checks reachable in the app as it stands today**.
  Every total previously written down was wrong: this file said 82, the backlog
  file said 90, and the itemised list here summed to 88. The counted breakdown is
  now recorded once, in the backlog file itself, and the Stage 1 group is **19**,
  not the twenty this file claimed for weeks.
  **2.2's ten, 2.6's three and 2.7's five all need one scratch harness** — those
  three modules ship unwired — so a single harness clears eighteen at once. **2.8's
  five need no harness** (it ships wired), and four of them sit on Featured, so one
  Featured sitting covers them. **Start with 2.4-MC-1 and 2.4-MC-2** — keyboard
  activation and the tab bar's colour correction, the two with no automated guard at
  all. That file is the only copy: it was written when the run folders were retired,
  precisely so the checks would outlive the `qa-report.md` files that had been
  holding them. Don't summarise it back into here — point at it.
- **Human-authored test gaps from the 1.5/1.6/1.7 run**, flagged by QA as
  advisory (not blocking, QA doesn't gate on files outside Dev's allowlist):
  no `StatTile` test at all despite it being the only one of the three with a
  live caller; `count == 0` unexercised in `filter_count_chip_test.dart`
  despite `tech-ac.md` naming it explicitly; two color assertions there
  hardcode literal hex instead of referencing the design token.
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
- **`_AddContentDialogState.initState` calls `super.initState()` inside a
  pattern-match branch** (`lib/widgets/add_content_dialog.dart`) — its
  `if (widget.titleDescription case final values?)` guard wraps the `super` call, so
  constructing that dialog with no initial values skips it and trips Flutter's
  debug assertion. A real latent bug, found by item 2.5's Tech Lead while rewiring
  that file and deliberately left unfixed as out of scope. Small and self-contained;
  worth folding into whatever next touches the dialog.
- **§3.4 has a spec gap: the failed-item badge and the library tick share one slot.**
  `failed_item.dart:29-31` and `game_card.dart:97` are **character-identical**
  `Positioned(top: 8, right: 8)`. §3.4 asks the badge to sit "in the same slot as the
  indigo library tick" and never says what happens when both marks apply — so a game
  that is in the library *and* failed stacks a red badge on the indigo tick. The
  implementation followed the spec exactly; **the spec has the hole**, so this needs a
  design answer, not a code fix. Found by 2.7's QA. `2.7-MC-2` in the backlog says to
  look at it on device before deciding.
- **A dormant screenshots feature sits behind the file item 2.7 deleted.** Removing
  `detail_screenshot_section.dart` orphaned `GameScreenshotCubit` (its only references
  were inside that file's commented-out block). Also unreferenced behind it:
  `game_screenshot_entity.dart`, `screenshot.dart`, `screenshot_response_model.dart`.
  `ImageRouteView` is still registered in `auto_route_config.dart:39` with nothing
  pushing to it. **`lib/widgets/game_screenshot.dart` is LIVE** — `image_page_view.dart:32`
  uses it — so it must not be swept up. Deliberately left by human decision at 2.7's
  gate: deleting it is a feature removal, not a cleanup, and may discard work intended
  for restoration. Decide it deliberately rather than in passing.
- **Some files in the repo are not `dart format` clean.** Item 2.7's Dev formatted one
  allowlisted file and reflowed a pre-existing block inside it. Harmless, but it means
  any future formatter run produces churn unrelated to the change that triggered it.
  Worth one deliberate repo-wide `dart format` in a cleanup item rather than letting
  each run carry a few stray hunks. **It happened again in 2.8** — five hunks of pure
  format churn in `critics_grid.dart`, on code the plan never asked Dev to touch. Two
  runs in a row now, which is the argument for doing the repo-wide pass rather than
  continuing to absorb it item by item.
- **§2.2's "art-deep is the empty-state card fill" is unimplemented app-side.**
  Found by item 2.8's BA and escalated as a CRITICAL rather than guessed at.
  `--surface-art` / `--surface-art-deep` are named in §2.2 and §5 with **no hex
  anywhere**, and the app palette has no art surface at all; §2.2 calls art-deep
  violet, while §2 rule 4 keeps violet `#7d4ee0` inside `--gradient-mesh` and "not a
  UI colour until ratified". The human chose the existing `surfaceRaised` for the
  card. This is now the **second** standing foundations gap beside the 15px token,
  and like it, minting the token is a deliberate foundations change, not a
  component run's business.
- **`EmptyStateCard`'s glyph has no positive-case test**, flagged by 2.8's QA.
  Mutating the widget so a glyph is *never* rendered leaves the suite green: the
  "hides when none supplied" behaviour is protected, "shows when supplied" is not,
  even though four of the five call sites pass one. No criterion required it, so it
  is a gap rather than a violation. Cheap to close whenever that file is next open.
- **`EmptyStateCard` declares no width of its own** — it fills its parent only
  because `PrimaryButton` sets `width: double.infinity`. Fine today at all five
  sites; worth knowing before the card is dropped somewhere narrower.
- **Two improvised empty states remain, ruled out of item 2.8's scope by the human**:
  `tracker_tasks_section.dart:42-49` and `tracker_game_detail_section.dart:147-151`,
  both bare `Text` with no card and no glyph. The first is the awkward one — its
  action (`DefaultOutlinedButton`) is a **sibling** rendered in *both* the empty and
  non-empty branches, so folding it into a one-action `EmptyStateCard` changes that
  screen's non-empty layout too. Now that the component exists, this is a small
  self-contained follow-up rather than a design question.
- **`horizontal_separator.dart` still hardcodes `Colors.grey` and forces
  `width: context.screenWidth`** — a §2 colour-law violation of the same shape as
  the `Colors.red` item 2.5 removed, with the `hairline` token already available,
  plus a separator sizing itself to the screen rather than its parent (fragile in
  any padded or constrained container). Deliberately left alone by item 2.6's gate
  decision: fixing it would have changed `detail_mid_section.dart`, a shipped
  **game_detail** screen, and killed that item's unwired option. It is 15 lines and
  has exactly two callers (`detail_mid_section.dart` and `group_task_item.dart`) —
  a small, self-contained follow-up, and the natural moment is whenever a screen
  first adopts `HairlineGroup`, since that is what supersedes it.
- **§4.4's green "Day one" price has no home yet.** `LabelValueRow`'s minimal API
  deliberately omits a per-row value colour, so the Where-to-play row's green price
  cannot be expressed. Flagged during item 2.6 rather than shipped speculatively;
  whoever builds that screen needs to add the capability or argue it away.
- **`LabeledTextField.onChanged` has zero call sites** — flagged by 2.5's QA.
  `tdd.md` invoked the "no parameter nothing calls" rule to drop `suffixIcon` in the
  same run, so the rule was applied unevenly; `onChanged` was an approved carry-over
  from the old API. (`helper` is also uncalled but is criterion-driven by
  `[2.5-AC3]`, so it stands.) Worth a trim, not urgent.
- **Two more off-spec filter chips** exist beyond what item 1.5 named:
  `_SelectionChip` in both `default_filter_list_app_bar.dart` and
  `filter_list_app_bar.dart`. Not migrated to `FilterCountChip`, flagged as a
  follow-up, not silently expanded into scope.

---

## Process rules currently in force

**Most of these now live in the pipeline docs themselves** — as of 2026-08-25 the
branch rule, the commit exceptions and the Tech Lead's missing shell were written into
`.claude/pipeline/rules/git.md`, `.claude/skills/orchestrate/SKILL.md` and
`.claude/skills/tech-lead-agent/SKILL.md`, which are the enforcing copies. Read those
first; what follows is only what has no home there yet.

- **Tech Lead also writes `code-plan.md`** — a Dart code skeleton (class/enum/freezed
  shapes, signatures) that is what actually gets presented at the Phase 3 gate,
  replacing a prose implementation plan.
- **Phase 4B is review-after-push.** Dev implements and commits in one pass; the
  orchestrator pushes; the human reviews the pushed commit (`git show --stat <sha>`),
  not a working tree. Revisions go back to **Dev** as new commits — never an amend,
  never back to Tech Lead unless the design itself was wrong. Pushed does not mean
  approved.
- **A substantial Phase 3 revision may correct `tdd.md`/`task-brief.md` in place**,
  not just append to `code-plan.md`'s delta, because the Dev Agent's literal allowlist
  check would otherwise read a stale file list. Small or naming-only revisions still
  just get a delta entry.
- **A Phase 3 revision that changes implementation style but no acceptance criterion**
  (e.g. "remove this comment", "use `Expanded` not `Flexible`") is Tech Lead-only.
  Route back to BA only when the fix reverses or adds a criterion in `tech-ac.md`.
- **A human can defer widget-test authorship to themselves for a given run**, via a
  Phase 3 revision reversing the BA's test-coverage criterion. Established for the
  1.5/1.6/1.7 run — **one-off by request, not a standing default**; ask each time.
- **Never `git add -A` while a subagent is live in the same tree.** The orchestrator
  did this during item 2.6 and swept a Dev Agent's in-progress files into a docs
  commit, splitting that item's implementation across two commits under a misleading
  message. Stage explicit paths, or wait for the agent to return.
- **`.codex/` is deliberately on the OLD Phase 4B rule** (two-pass, uncommitted
  review) at the human's request. It disagrees with `.claude/` **on purpose** — not a
  bug to fix, and not something to sync during a cleanup.

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

**Current phase: week 2 is COMPLETE** — component library, all 9 Stage 1
primitives and all 8 Stage 2 composites built and merged to `develop`. The
remaining week 2 work is not code. `.agents/week-2-task-briefs.md` was fully ticked
and **deleted 2026-08-25**, its three surviving scope rulings promoted into this file
first (gotcha #9 was actually honoured this time — the destination was grepped, and
§3.5's device frame turned out NOT to have been promoted, so it was written in before
the delete). The **74-check manual backlog** remains, but most of it is now gated on
screens that do not exist yet rather than being work anyone can pick up. Week 3
(Library feature) is next,
and it is blocked on a design spec — see "Open decisions that could block". Target
is a TestFlight-equivalent Android beta around week 4.

**Hard constraints** (both in `project-conventions.md`):
- **Android only.** No Mac, no iPhone. iOS cannot be built or verified here.
- **Account required, one-tap social.** Discord and Google only. No Apple
  (iOS-gated), no Twitch (deferred).

---

## Where things live

- `.claude/skills/` — the five pipeline skills (`orchestrate`, `ba-agent`,
  `tech-lead-agent`, `dev-agent`, `qa-agent`), the six Dart component skills
  (`flutter-widgets`, `flutter-state`, `flutter-usecase`, `flutter-repository`,
  `flutter-datasource`, `flutter-dto`), and `flutter-widget-test`.
  **`flutter-widgets` is the enforcing copy for widget conventions** — its catalogue
  also carries the three-tier split of `lib/widgets/` (design system / live legacy /
  never-rendered). `.claude/pipeline/` holds the shared rules (`git`, `execution`,
  `generation`, `escalation`) and the artifact templates.
- `.claude/agents/*.md` — the registered agent types. **Their frontmatter fixes each
  agent's model and tool grant**, and the grants differ: `tech-lead-agent` and
  `ba-agent` have **no Bash**, `dev-agent` and `qa-agent` do. Check the frontmatter
  before telling an agent to run a command.
- `.agents/references/` — product brief, design conventions, per-screen
  specs, project conventions, deferred roadmap. Trimmed 2026-08-07 where
  content moved into the component skills above.
- `.agents/manual-check-backlog.md` — every on-device check QA identified and
  nobody has performed, across every run. Created 2026-08-20 as the durable
  home for these; tick one off by deleting it, and if one fails it becomes a
  bug to file rather than a backlog line.
- `.agents/runs/<run-id>/` — one folder per pipeline run; removed once a run is
  complete with no open escalations, its record migrated somewhere durable first (see
  gotcha #9 — **verify** this happened, don't assume). **The directory does not
  currently exist**: every run folder through item 2.8 has been retired, the last on
  2026-08-25. Git keeps no empty directories, so the next run's Phase 0 recreates it —
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

## Stage 3 brief — read before writing the kickoff prompt

Written 2026-08-25, when week 2 closed. **Nothing here has been implemented.**

### Both blockers are CLEARED as of 2026-08-26. Six rulings, all human decisions.

The two blockers below ("no Library design spec", "navigation still open") are
**both settled** — the text under them is kept for the reasoning, not as open
questions. `.agents/references/library-design-conventions.md` landed on `develop`
at `15f068f` and answers all four of the brief's open design questions.

1. **Tab structure: `Featured · Library · Games · Browse · Settings`.** Library
   replaces Tracker *and* moves to slot 2 (index 1); Games shifts 1 → 2. Browse
   stays at 3 and Settings at 4.
2. **The desaturation filter stays absent.** §5 of the new Library spec re-introduced
   `saturate(.5) contrast(1.05)`; rejected for the **third** time. `1.3-AC7` remains a
   live check that it stays absent. Both the Library spec §5 **and**
   `system-foundation-specs.md` §3.2 are to be corrected so a fourth BA cannot
   inherit it — item 1.4 set that precedent.
3. **Mint `surfaceArt` and `surfaceArtDeep`.** The second standing foundations gap is
   closed by decision. Trap for whoever does it: `app_tokens_test.dart:97-110`
   asserts violet stays out of the surface and accent tokens, and §2.2 describes
   art-deep as violet — decide deliberately whether the new surface joins that list
   or gets a documented carve-out, the same shape as 2.7's `surfaceToast` alias
   having to stay outside the distinctness `Set`.
4. **The 15px type token is NOT minted — keep shipping 14.** Four items have now
   done this (1.9, 2.2, 2.5, and all of week 3). It is a settled convention, not a
   recurring workaround. **Stop raising it.**
5. **Playing's status dot is `accentIndigo`, and the spec is wrong, not the token.**
   `AppStatusTokens.playing` stands. Amend `library-design-conventions.md` §3
   ("Playing white") — and §12 in the same edit, since its colour ration currently
   says indigo is the active chip and tab "and nothing else".
6. **Featured's 3-step checklist points at Games (index 2).** All three of
   `featured_screen.dart:144,145,147` go `setActiveIndex(1)` → `(2)`. The literal
   changes; the destination screen does not. Note the human's stated intent is that
   the *Games* screen is eventually renamed Browse — which will collide with the
   existing Browse tab at index 3 (`featured_screen.dart:207`,
   `countdown_releases.dart:93` both point there). Not week 3's problem, but do not
   "helpfully" merge the two.

**The one index that changes meaning silently:** `library_stats.dart:315` is
`setActiveIndex(2)` and today means Tracker. It must become **1** (Library).
No compiler catches this — it is the exact trap the navigation blocker warned about.

**Verified at Phase 0 on 2026-08-26** (fresh container, Flutter 3.41.4): analyzer
**30 issues / 0 errors / 2 warnings / 28 info**, suite **+361 -10**, the 10 failures
being tracker_repository (4), game_detail_cubit (3), games_bloc (3). The
games_bloc root cause was re-confirmed in source, not inherited: `games_bloc.dart`
registers all three handlers `droppable()` at `:25-27` and calls
`add(const GamesFetched())` in the constructor at `:29`.

### What that Phase 0 found that no checklist had

- **`SavedGame.status` is dead code.** Constructor parameter only — zero writers,
  zero readers, anywhere. Same for `isWishlisted`, `dateModified` and the whole
  `PlaySessionLog` collection. `SavedGameStatusTag` has exactly one caller,
  `tracker_game_detail_screen.dart:131`, hardcoded to `Status.notStarted`.
- **Two more never-fired branches, the same shape as `GamesStatus.empty`.**
  `featured_local_datasource.dart:46` filters `statusEqualTo('Playing')` and
  `getWishlistedGames()` filters `isWishlistedEqualTo(true)` — both against fields
  nothing writes, so **Featured's now-playing shelf and wishlist stat have never
  once rendered with data**, and `library_stats.dart:287-305`'s progress branch is
  unreachable for the same reason. `'Playing'` also matches neither the enum nor
  the SQL vocabulary. Fixing this is folded into the run that builds the data layer.
- **The migration is mostly free, because the dead fields are the ones we need.**
  `hoursLogged`, `manualProgressPercentage`, `platforms` and `genres` already exist
  on the Isar model with no writers — they become live Supabase columns.
- **`library_entries` cannot serve the spec as it stands.** It needs `platform`,
  `rating`, `playtime_hours`, `progress_percent`, `genre` and `updated_at` before
  sort-by-rating/playtime, the four filter axes, the grid's `PS5 · 24h · Ch. 9`
  meta or the list's right-hand figure can exist.
- **Three status vocabularies, one genuinely ambiguous mapping.** Legacy `toBuy`
  collides with `wishlist`, which the legacy model carries as a *separate boolean*.
  Five of six map cleanly; that one needs a call when the migration is written.
- **`LibrarySnapshotEntity` holds `List<SavedGame>` directly** — an Isar model inside
  a domain entity. The migration has to break that seam whatever else it does.
- **The reactive shape changes.** Tracker drives `StreamBuilder` off Isar `.watch()`;
  Supabase has no drop-in equivalent, so Library is `Result<T>` + BLoC with explicit
  refetch and real pagination. That is a shape change, not a port.
- **A third improvised empty state exists** beyond the two recorded below:
  `tracker_screen.dart:179-202`, bare `Text`, no card, no glyph. (Moot once 3.2
  deletes that file.)
- **All 11 never-rendered components were read against their manual-check entries
  and are sound** — every recorded trade-off still holds, including the
  `FailedItem`/`GameCard` slot collision being character-identical. One new find:
  `zone_label.dart` carries 4 comment lines, violating "widgets carry no comments
  at all". Every other one of the 11 is comment-free.
- **Violet and cyan already exist** as `_statusViolet #7D4EE0` and
  `_accentLinkCyan #00B0F4` (`app_color_tokens.dart:11,15`), wired through
  `AppStatusTokens` for all six statuses. The Library spec's §13.5 worry that they
  are "still flagged" is stale.
- **`horizontal_separator.dart` has exactly the 2 callers on record**, and the
  63-untranslated-key count is correct — both re-derived rather than quoted.

**Stage 3 is the Library feature**, and it is the biggest thing this project has
attempted: the brief calls Library "the most important screen we haven't designed"
and "where the primary user lives".

**Two blockers are human deliverables, not engineering work. Both must be settled
before a pipeline run can start.**

1. **There is no Library design spec.** The product brief lists the requirements
   (status filtering across six states, grid/list toggle, five sort orders, four
   filter axes, custom lists, bulk edit, search-within-library, per-tab empty states)
   and then lists the *unanswered* design questions: how six status categories are
   navigated, whether cover grids or lists win, how bulk edit stays discoverable
   without cluttering, and how one screen serves a user with 3 games and a user with
   300. **A BA cannot translate requirements into criteria while those are open** —
   that is the "unstated threshold / unspecified edge case" shape that item 2.8's BA
   correctly halted on twice.
2. **The navigation decision is still open, and it invalidates part of what week 2
   just built.** The brief proposes **Home · Library · Search · Stats · Profile**
   against today's shipped **Featured · Games · Tracker · Browse · Settings**. That is
   not a rename — it is a different information architecture. `BottomTabBar` ships
   five *fixed* destinations in an enum, and `AutoTabsRouter` index positions are
   hardcoded at call sites (item 2.8 wired two actions to `setActiveIndex(3)` for
   Browse). Settle the tab structure **before** anything is built on top of it, or
   those indices silently point at the wrong screens.

**What stage 3 inherits, ready to use.** Week 2's component library is built and
merged, but **11 of 17 components have never rendered anywhere** — see "The component
library" above. Stage 3 is where they get proven. Three things fold into the build
rather than being separate tasks:
- **Perform each component's manual checks on the screen that adopts it**
  (`.agents/manual-check-backlog.md`, 74 entries, most gated on exactly these screens).
- **Retire each legacy widget in the run that replaces it** — `horizontal_separator.dart`
  when Game Detail adopts `HairlineGroup`, `saved_game_item.dart` when Library replaces
  it. Never as a standalone sweep.
- **Translate the strings you touch.** 63 Chinese keys still hold English values;
  human decision is to fix them per-screen as building proceeds.

**Known scope that is already decided:**
- **The Add-to-library sheet is stage 3's**, deferred from week 2 because it binds to a
  Library entity/status model that does not exist yet. `add_content_dialog.dart` is
  **not** it under an old name. The brief calls the add-to-library action "the single
  most important interaction in the app".
- **Game Detail is a rebuild**, and its hero ramp hue is still an open design question.
  Users arrive in two states (game in library or not) and the brief says these are
  "functionally different screens — design both".
- **Featured is on an old design** and is due to be rebuilt against
  `home-screen-design-conventions.md`. Do not invest in its current layout.
- **The tracker → library migration** is what unblocks item 3's on-device
  cross-account RLS check — nothing writes to `library_entries` until it lands.

**Two foundations gaps will be hit again.** No 15px type token (three items worked
around it) and no art-deep surface (§2.2 names it as the empty-state fill and it has
no value anywhere). Both are foundations changes, deliberately kept out of component
runs — decide whether stage 3 mints them rather than working around them a fourth time.

---

## Next-session prompt

```text
Resume QuestLoggd. Checkout develop first. Read .agents/handover.md in full
(it's long, read it anyway).

Before anything else:
- Check `git status` is clean. `.agents/`, `.claude/` and `.codex/` are tracked.
- No Flutter in a fresh container. Install 3.41.4 to match `.fvmrc` (a
  /etc/profile.d/flutter.sh script works well so every login shell picks it up
  automatically, including subagents' Bash calls), then `flutter pub get` and
  `dart run build_runner build --delete-conflicting-outputs` before trusting any
  baseline.
- Expect **30 analyzer issues (0 errors, 2 warnings, 28 info)** and **+347 -10** on
  the test suite. Both are correct and neither is drift. **The analyzer baseline
  moved down from 33 at item 2.8** — `library_stats.dart` lost 122 lines including
  `_DashedBorderPainter`, taking 3 info issues with them. The 2 warnings are still
  the deliberate `_TaskReminder` pair; the 10 failures are pre-existing in
  tracker_repository_test (4), game_detail_cubit_test (3), games_bloc_test (3). The
  suite has never been green. Verify both yourself at Phase 0 rather than inheriting
  them -- the pass count has now moved four times (312 -> 315 -> 325 -> 343 -> 347)
  and the analyzer count twice.

**Current state: week 2 is COMPLETE.** All 9 Stage 1 primitives and all 8 Stage 2
composites are built and merged to `develop` (2.8 merged 2026-08-25 at `41829d0`).
This was verified by confirming all 18 files/folders exist in `lib/widgets/`, not by
reading the checklist's ticks -- do the same before believing it, because this file
once claimed Stage 1 complete while 1.8 and 1.9 had never been built.

**There is no pipeline item queued.** The next work is one of three things, and the
human picks:

1. **The manual-check backlog** (`.agents/manual-check-backlog.md`) -- **74 left, and
   the easy value is already extracted.** The 2026-08-25 sitting cleared eighteen,
   including every one of item 2.4's fifteen. **Recount the total in that file rather
   than quoting one**: four different totals (82, 88, 90, 92) have been wrong at
   various points. Only **three** entries are reachable in the app as it stands --
   `2.8-MC-3`, `2.8-MC-4` and `2.7-MC-3` -- and the first two are Featured pixel
   checks the human has deprioritised because that screen is due for a rebuild.
   **Everything else waits on screens that do not exist yet**, so treat this file as
   a per-screen checklist to consult when building, not a queue to work down.
   **Do not build a scratch harness** -- one was built and deleted the same day; the
   reasoning is recorded in that file.
2. **The remaining Chinese translations** -- 63 keys still hold English values.
   Human decision 2026-08-25: **translate them as each screen is built**, rather than
   as one sweep. So this is not a standalone task; it is a rule for whoever touches a
   screen next.
3. **Week 3, the Library feature** -- but it is **blocked on a design spec that does
   not exist**. See "Open decisions that could block": the Library is the biggest
   screen in the app, has no spec, and the brief flags the hard part (it must work at
   3 games and at 300). That spec is a human deliverable, not something to invent.

**Five things recurred across every one of 2.1-2.8 and will recur again:**
- **Grep the caller list at Phase 0. The checklist was wrong four times out of
  eight** -- 2.1's named two files that never referenced the component, 2.6's called
  a file "tracker-specific" when its main caller was a game_detail screen, 2.7's
  claimed four levels when one was already built, and 2.8's carried two callers when
  a grep found seven (two of them holding hardcoded untranslated English that nobody
  had recorded). This is the single highest-value thing Phase 0 does.
- **A spec gap is escalated, not filled in.** 2.8's BA halted on §3.2's "art-deep
  card" having no value anywhere in the project, and on "one action" having no target
  at three sites. Both went to a human gate and were settled in minutes. A BA that
  guesses here costs a whole run.
- BAs write criteria straight from §3 even where a human decision already overruled
  that text (twice on the desaturation filter, once nearly on §3.4's field level).
  Check §3 claims against this file's records first.
- Screen docs outrank §3 where they disagree (precedence rule at
  system-foundation-specs.md lines 6-8).
- **A criterion phrased about position or pixels usually has a checkable form.** 2.6
  pinned a COUNT plus the ABSENCE of a parameter that could break the rule; 2.7 and
  2.8 both did the same. Reach for that before marking something manual-only.

**Two test traps, both found the hard way:**
- **A test can pass by construction.** Prove it by injecting the regression the test
  is meant to catch and confirming it fails -- about two minutes. 2.8's Dev and QA
  both did this independently (QA mutated the widget six ways in a scratch copy).
- **An unscoped `find.byType` can match something else entirely.** Scope finders with
  `find.descendant(of: find.byType(TheComponent))`. **A tree-shape claim is verified
  by BUILDING the tree, not asserted in a design doc** -- and if the phase that
  writes the design cannot build it, say so as an explicit caveat with a named
  fallback, which is what made 2.8's `ColoredBox` finder safe.

Conventions, stricter than older code and older run artifacts show -- re-read the
skills, do not pattern-match off existing files:
- Widgets carry NO comments at all. Not "few" -- none.
- Widget tests never assert dimensions, gaps, radii or positions; colour assertions
  must carry meaning and name a token; never a golden test. context_chip_test.dart
  and stat_pill_test.dart are the reference files for shape and length.
- Tests must import only a module's public entry point.
- **Module folder vs single file is a per-item judgement, not a rule either way.**
  2.1-2.4 and 2.7 ship module folders; 2.5, 2.6 and 2.8 deliberately ship flat files.
  The flutter-widgets skill still states the flat rule as absolute, matching neither
  -- a live follow-up, not a rule to obey blindly. QA has now flagged it six times.

**Agent-definition gotcha, corrected 2026-08-25:** `tech-lead-agent` has **no Bash
tool** (Read/Write/Grep/Glob/Skill only) -- it is not a session-level restriction, it
is that agent's definition, so do not tell it to "just run the command". `dev-agent`
and `qa-agent` both do have Bash. Separately, gotcha #7's missing-agent-type problem
and the Skill-tool-disabled problem from 2.6/2.7 may still recur; the fallbacks are
in gotcha #7 and are to read `.claude/skills/<name>/SKILL.md` from disk.

**Two process rules that earned their place during 2.6-2.8:**
- **Never `git add -A` while a subagent is live in the same tree.** Stage explicit
  paths.
- **If a subagent dies with finished-but-uncommitted work**, the orchestrator may
  commit it -- verify the baseline independently first, commit unchanged, state the
  authorship. 2.8 also hit a subagent dying with *nothing* finished (a session limit
  mid-phase); there the answer is simply to re-spawn the phase from scratch and
  delete any scratch file it left behind.

Known follow-ups, none blocking, all itemised in "Known non-blocking gaps": item 3's
on-device cross-account RLS check (blocked on week 3's Library feature), item 10.1's
dead-code cleanup, the orphaned ScrollNotifier ecosystem from 2.4, the flutter-widgets
rule text contradicting eight shipped items in two directions, §3.2's stale
desaturation text, §1.9 platform-mark conformance, primary_button.dart's unexplained
third color.green, ButtonPressScale registering no ActivateIntent, _SignOutButton as a
third copy of the ActionRow anatomy, add_content_dialog.dart's super.initState() inside
a pattern-match branch, LabeledTextField.onChanged having zero call sites,
horizontal_separator.dart's hardcoded Colors.grey and screen-width sizing, §4.4's green
"Day one" price having no home in LabelValueRow's API, §3.4's badge/library-tick slot
collision, the dormant screenshots chain behind the file 2.7 deleted (note
game_screenshot.dart is LIVE and must not be swept up), **the 15px type token and
§2.2's unimplemented art-deep surface -- now two standing foundations gaps, not one**,
**the two tracker empty states 2.8 left out of scope**, **EmptyStateCard's untested
glyph positive case**, **`no_results_found` being the one empty state that still
apologises**, and **files not being `dart format` clean, which has now produced stray
churn in two consecutive runs** and is the argument for one deliberate repo-wide pass.

One environment thing that will waste your time otherwise: remote branch deletion is
blocked by the egress proxy (gotcha #11 -- merged claude/* branches have to be deleted
by hand in the GitHub UI, don't retry the 403). `claude/async-states-empty-state-guasva`
joins that list, merged 2026-08-25.
```

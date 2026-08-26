# Week 3 — Library feature task briefs

> ## ⚠ EPHEMERAL — DELETE THIS FILE WHEN WEEK 3 IS DONE
>
> This is a working checklist, not a reference document. Once every item below is
> ticked, **delete `.agents/week-3-task-briefs.md`**. Anything worth keeping must be
> promoted into `.agents/references/` or `.agents/handover.md` **first** — and
> gotcha #9 says to *grep the destination and confirm it landed*, not to assume an
> earlier step handled it. `week-1-task-briefs.md` was deleted with freshly-migrated
> content in it that existed nowhere else; it was recovered the same session by luck.
>
> A stale checklist that outlives its week is worse than no checklist — agents read
> it as current intent.
>
> Written 2026-08-26.

---

## How to use this

Items are in dependency order. Every one is **[PIPELINE]** — feed the item text to
`/orchestrate` as a run. One item is one run.

**Source of truth for what to build:**
`.agents/references/library-design-conventions.md`, landed on `develop` at `15f068f`.
Read the specific section named in each item. It is a real spec: it answers all four
of the product brief's open design questions, so a BA does **not** need to invent
anything about navigation, density, bulk edit or the 3-vs-312 problem.

**Screen docs outrank `system-foundation-specs.md` §3 where they disagree**
(precedence rule at `system-foundation-specs.md` lines 6–8). This bit and hurt
during week 2 — check §3 claims against the handover's records before writing a
criterion from them.

**Source of truth for how to build it:** the Dart skills under `.claude/skills/`
(`flutter-widgets`, `flutter-state`, `flutter-usecase`, `flutter-repository`,
`flutter-datasource`, `flutter-dto`, `flutter-widget-test`). A skill's silence is not
authorisation — QA gates on the skill as well as on `tdd.md`.

**The six rulings that unblocked this week** are recorded in
`.agents/handover.md`'s "Stage 3 brief" section. Read them before Phase 1 of any
item. Two of them exist specifically to stop a BA writing a criterion that a human
already overruled:

- **The cover-art desaturation filter stays absent.** The Library spec's §5 asks for
  `saturate(.5) contrast(1.05)`. It has been rejected three times. `1.3-AC7` is a
  live check that it stays absent. Item 3.1 corrects both docs so this cannot recur.
- **The 15px type token is not minted; ship 14.** Settled after four items. Anything
  the spec puts at 15px ships at 14. Do not raise it again.

**Three things fold into every run rather than being separate tasks** (human
decision, carried from week 2):

1. **Perform each component's manual checks on the screen that first adopts it.**
   `.agents/manual-check-backlog.md` — most of its entries have been waiting for
   exactly these screens. Tick one off by deleting it.
2. **Retire each legacy widget in the run that replaces it.** Never a standalone
   sweep. Named per item below.
3. **Translate the Chinese strings on screens you touch.** 63 keys still hold
   English values. Get the real list by diffing the two `.arb` files' *values*;
   do not eyeball it or trust a count.

---

## What week 3 does NOT touch

**The tracker task tree.** Human decision 2026-08-26. `tracker_game_detail_screen.dart`,
`task_detail_screen.dart`, `TaskCubit`, `GroupTask`, `SavedGameTask` and `TaskStep`
all stay. Item 3.2 deletes their only real entry point, so they go **dormant** —
reachable only from `library_stats.dart:319`. That is deliberate. Do not clean up the
orphan, and do not delete the Isar `SavedGame` store to tidy the resulting two-store
situation. A design convention for task detail, groups and group items is coming from
the human; pick it up **when that lands, not before**. Full note in the handover's
"Known non-blocking gaps".

**Consequence:** the analyzer baseline stays **30 issues / 2 warnings** all week,
because `_TaskReminder` lives in `task_detail_screen.dart` and that file survives.
A run that reports 28 has broken something.

**Game Detail.** It is a rebuild with its own open question (the hero ramp hue) and
its own spec. Not week 3. This means `horizontal_separator.dart` is **not** retired
this week — its callers are `detail_mid_section.dart` (a Game Detail screen) and
`group_task_item.dart` (the dormant task tree). Leave it.

**Custom lists, bulk edit, the filter sheet's contents, search-result states, and
per-status empty states.** All descoped by the spec itself — bulk edit was cut in
review (§9), custom lists are §13.1. `lists.sql` stays a stub.

---

## Baselines — verify, never inherit

Confirmed on a fresh container 2026-08-26 with Flutter 3.41.4:

- Analyzer: **30 issues, 0 errors, 2 warnings, 28 info.** The 2 warnings are the
  deliberate `_TaskReminder` pair.
- Suite: **+361 -10.** Failures are `tracker_repository_test` (4),
  `game_detail_cubit_test` (3), `games_bloc_test` (3). The suite has never been green.

The pass count has now moved five times and the analyzer count twice. **Run both on
the untouched tree at Phase 0 of every item** rather than quoting these.

---

# Stage 3 — Foundations and data

Nothing user-visible except the tab itself. Build the substrate first so Stage 4
composes it instead of improvising. Same shape as week 2's primitives → composites.

- [ ] **3.1 — Foundations: art surfaces, and the three docs that keep re-seeding bad
      criteria.**
      Mint `surfaceArt` and `surfaceArtDeep` in `app_color_tokens.dart`, closing the
      second of the two standing foundations gaps. §2.2 and §5 of
      `system-foundation-specs.md` name them with **no hex anywhere**; item 2.8
      substituted `surfaceRaised` once already, and the Library spec now depends on
      them in two places (§5's cover placeholder, §11's recruit-card gradient).
      **The trap, and it is the whole risk of this item:** `app_tokens_test.dart:97-110`
      asserts violet stays out of the surface and accent tokens, and §2.2 describes
      art-deep as violet. Decide deliberately whether the new surface joins that list
      or gets a documented carve-out — the same shape as 2.7's `surfaceToast` alias
      having to stay outside the distinctness `Set` at `app_tokens_test.dart:496-500`.
      Settle this in `tdd.md`, not at QA.
      Then three doc corrections, each one closing a loop that has already cost runs:
      - `library-design-conventions.md` §5 — drop `saturate(.5) contrast(1.05)`.
      - `library-design-conventions.md` §3 — Playing's dot is `accentIndigo`, not
        white. **§12's colour ration must widen in the same edit**, since it currently
        says indigo is the active chip and tab "and nothing else".
      - `system-foundation-specs.md` §3.2 — delete the stale desaturation text. Two
        BAs have now written a criterion straight from it. Item 1.4 set the precedent
        for fixing a design doc when a decision reverses it.
      No screen changes. No widget changes.

- [ ] **3.2 — Tab swap, Library shell, Tracker and Browse tab retirement.**
      The IA change, isolated so nothing later is built on a moving index.
      Target: **`Featured(0) · Library(1) · Games(2) · Settings(3)`** — four tabs.
      - Rewrite `bottom_tab_bar/enum/bottom_tab_bar_destination.dart`: Library
        replaces Tracker and takes slot 2; the `browse` value is deleted.
        `bottom_tab_bar.dart` itself needs **no change** — it derives every index
        from `values`.
      - `home_screen.dart:16-22` routes list (order *is* the index) and
        `auto_route_config.dart:24-29` children, then regenerate.
      - **All six `setActiveIndex` literals change and none keeps its old value.**
        `featured_screen.dart:144,145,147` → `2`; `featured_screen.dart:207` → `2`;
        `countdown_releases.dart:93` → `2`; **`library_stats.dart:315` → `1`.**
        That last one currently means Tracker and has no compiler help — it is the
        exact trap the navigation blocker warned about. Grep `setActiveIndex` at
        Phase 0 and confirm the count is six.
      - A minimal `LibraryScreen`: title and empty state only, so the tab is not dead
        on arrival. Deliberately throwaway, ~30 lines, and worth it — it buys final
        indices before anything sits on them.
      - **Retires here, in the run that replaces them:** `tracker_screen.dart`,
        `saved_game_item.dart`, and the whole of `lib/features/browse/`. These lose
        their only reachable caller the moment the tabs change. Browse is one file
        with no bloc and no datasource — a 59-line `StatefulWidget` whose body is
        `Center(child: Text('Browse'))`.
      - **`saved_game_status_tag.dart` is NOT retired here.** Corrected 2026-08-26,
        mid-run: this list was written before the human's decision to keep the task
        tree, and never re-checked against it. Its only caller is
        `tracker_game_detail_screen.dart:131-133`, which that decision protects — so
        the "loses its only reachable caller" rationale is true for the other two and
        **false for this one**. Retiring it means editing a protected screen. Deferred
        to whichever item adopts the task-tree design convention, alongside its
        `Status` enum. Do not reinstate it here.
      - Deleting `tracker_screen.dart` also orphans `TrackerCubit` and
        `default_filter_list_app_bar.dart` (each has no other caller but its own
        test). Neither is an analyzer issue and neither is on the retirement list —
        flagged, not swept. `default_alert_dialog.dart` is **not** orphaned:
        `task_detail_screen.dart` still uses it, and that file survives.
      - **Do not over-delete l10n.** `browse_games` and `browse_for_your_next_game`
        are still live on Featured's empty states; only the bare `browse` key becomes
        unreferenced. Gotcha #1: `intl_utils` regenerates strictly from the `.arb`
        files, so a deleted key silently takes its getter. Add `library` to both
        files, then `dart pub global run intl_utils:generate`.
      - `bottom_tab_bar_test.dart` fixtures drop from five destinations to four.
      - Note `browse_screen.dart` is one of `ScrollNotifier`'s three writer sites;
        this leaves two. The notifier stays orphaned-but-deliberate exactly as 2.4
        left it. **This does not reopen that follow-up.**
      - Translation note: `browse` (浏览) and `tracker` (追踪) were the only two
        Chinese strings ever fixed, and both are deleted by this item. No real loss
        (浏览 survives in the two keys that stay) — but the untranslated count will
        not drop the way it looks like it should.

- [ ] **3.3 — Schema migration and the remote data layer.**
      `library_entries` **cannot serve the spec as it stands.** It holds
      `igdb_id, title, cover_url, release_date, status, created_at`. Add `platform`,
      `rating`, `playtime_hours`, `progress_percent`, `genre`, `updated_at` — without
      them there is no sort by rating or playtime, no filter axes, no grid meta
      (`PS5 · 24h · Ch. 9`) and no list-view figure (`68%`, `—`).
      **The migration is mostly a promotion, not new invention:** the Isar `SavedGame`
      already carries `hoursLogged`, `manualProgressPercentage`, `platforms` and
      `genres` — all with **zero writers**. These dead local fields become live
      remote columns.
      - `LibraryEntryDto` / `LibraryEntryEntity`; status mapping snake_case ↔
        `LibraryStatus`. The enum already matches the SQL check constraint exactly.
      - `LibraryRemoteDatasource` (Supabase), repository + impl on `Result<T>` via
        `BaseRepositoryMixin`.
      - Use cases: fetch page, add, update status, remove.
      - **One genuine ambiguity to settle in `ambiguities.md`, not guess:** legacy
        `toBuy` collides with `wishlist`, which the legacy model carries as a
        *separate boolean* (`isWishlisted`). Five of six statuses map cleanly.
      - **Break the layering violation while here:** `LibrarySnapshotEntity` holds
        `List<SavedGame>` directly — an Isar model inside a domain entity.
      **This is what finally unblocks item 3's on-device cross-account RLS check**,
      blocked since week 1 on nothing writing to `library_entries`.

- [ ] **3.4 — `LibraryBloc`, preferences, and the Featured repair.**
      - Status filter, sort, view mode, pagination, search-within-status. Per §9,
        **search composes with the active chip rather than overriding it** — that is
        a state-shape decision, not a UI one, so it belongs here.
      - **The reactive shape changes and this is where it happens.** The tracker
        drove `StreamBuilder` off Isar `.watch()`; Supabase has no drop-in
        equivalent, so Library is `Result<T>` + BLoC with explicit refetch and real
        pagination for the 312-game case. A port would be wrong.
      - View-mode and sort persistence (§9: a 300-game user who picks list must never
        be handed the grid again). `TrackerPreferencesDatasource` +
        `TrackerSortRepository` already do exactly this for the sort tag — rename and
        extend rather than writing a second one.
      - **Featured repair lands here, and it is a real bug fix, not a refactor.**
        `featured_local_datasource.dart:46` filters `statusEqualTo('Playing')` and
        `getWishlistedGames()` filters `isWishlistedEqualTo(true)` — both against
        fields nothing has ever written, so **Featured's now-playing shelf and
        wishlist stat have never once rendered with data**, and
        `library_stats.dart:287-305`'s progress branch is unreachable for the same
        reason. `'Playing'` also matches neither the enum nor the SQL vocabulary.
        Repoint at `library_entries`. Same never-fired-branch shape as
        `GamesStatus.empty` — carry the lesson: *when a criterion says "renders X in
        state Y", check that anything ever produces state Y.*
      - `GamesBloc`'s three pre-existing test failures are **not** in scope. Fixing
        them needs restructuring (see `testing-conventions.md`), and moving the
        baseline mid-week helps nobody.

**GATE.** Nothing shipped to a user yet, but every substrate Stage 4 needs is proven.
Worth a human pause here — the schema decision in 3.3 is the expensive one to reverse.

---

# Stage 4 — The Library screen

Six items, each a coherent user-visible slice. **Treat the first use of any unproven
component as first use** — 11 of week 2's 17 have never rendered anywhere, and things
go wrong at the seam between a component and a real screen. Item 2.8 shipped wired to
five sites and one turned out never to have been reachable in the app's history.

- [ ] **4.1 — Grid shelf, the default view.** §5, §7, §8.
      Two-up cards (`repeat(2,minmax(0,1fr))`, `gap:12px`), cover, status pill,
      footer meta, the Log-a-game cell, count line, shimmer skeletons, error state.
      **No library tick** — indigo means "in your library" everywhere else, so inside
      the Library it would be on all 312 covers.
      **First real caller for `CoverTile` and `StatusChip(variant: onMedia)`.**
      Perform `1.2-AC6`, `1.3-AC6`, `1.3-AC7`, `1.3-AC8`, `1.3-AC10`, `1.3-AC12` and
      `1.3-AC13` on this screen — seven backlog checks that have waited since Stage 1
      for exactly this screen. `1.3-AC7` is the desaturation check: confirm it is
      still visibly **absent**.

- [ ] **4.2 — List view and the view toggle.** §6, §9.
      Rows on `#2f333c`, cover 46×62, status line, right-aligned contextual figure.
      Backlog and Wishlist show `—`, never a fabricated `0%` — the spec is explicit
      that a zero reads as failure rather than as "not started".
      Toggle keeps the active filter, the sort and the scroll anchor.
      **First real caller for `HairlineGroup`** — §6 describes its construction
      almost exactly (hairline between rows only, never the outer edges, which in
      that widget is a *construction* rather than a rule). Perform `2.6-MC-1`,
      `2.6-MC-2` and `2.6-MC-3` here.

- [ ] **4.3 — Status chips and the sort control.** §3, §4, §9.
      Seven chips (`All` + six statuses) in one edge-bleeding horizontal scroller,
      each with a status dot and a **live count**. The counts are load-bearing, not
      decoration: they tell you a slice has contents before you tap it, so a filter
      never presents as a dead end.
      Sort pill carries its *current value* as its label, not the word "Sort".
      Only one status active at a time; multi-select lives in the filter sheet.
      Violet and cyan already exist as `_statusViolet` / `_accentLinkCyan` and are
      wired through `AppStatusTokens` for all six statuses — §13.5's "still flagged"
      worry is stale. Playing's dot is `accentIndigo` per the 3.1 correction.

- [ ] **4.4 — Search and the filter sheet.** §2, §9.
      Search-within-library (never the catalogue — that is what the Games tab is
      for), filter button, and the active-filter count badge on the sliders button
      so a filtered shelf can never be mistaken for the whole one.
      **First real placement for `FilterCountChip`.** Perform `1.5-AC11` if the
      filter groups are reused.
      Depends on 3.3's new columns for platform/genre/year/score.

- [ ] **4.5 — Cold start and empty states.** §10, §11.
      Cold start (3 games): chips reduce to the statuses that exist plus `All`, with
      `Wishlist 0` kept visible; no view toggle; Log-a-game lands where the fourth
      cover would be. **The small library differs by what is absent, not by a
      special layout** — do not build a second screen.
      Empty (0 games): search field at `opacity:.5`, recruit card on `surfaceArtDeep`
      (from 3.1), two lighter routes in a hairline group, `Showing 0 games out of 0`.
      The screen's single green CTA lives here — which settles the standing question
      about `primary_button.dart:29`'s `color.green` default being a legitimate third
      resolution rather than a leak.
      **Empty states recruit; they do not apologise.** Related standing follow-up:
      `no_results_found` is the one empty state in the app that still apologises.

- [ ] **4.6 — The add-to-library sheet.** §9, product brief §7.
      Status picker, rating, platform. Opened from the Log-a-game cell with status
      pre-selected to **Backlog**, the same component and the same pre-selection as
      every other entry point.
      The brief calls the add-to-library action **"the single most important
      interaction in the app"**.
      **`add_content_dialog.dart` is NOT this component under an old name** — it is a
      tracker-era dialog with no status pre-select, no platform or rating, no green
      CTA, and a `Dialog` rather than a bottom sheet. (It also has a latent bug worth
      folding in if it is touched: `_AddContentDialogState.initState` calls
      `super.initState()` inside a pattern-match branch, so constructing it with no
      initial values trips Flutter's debug assertion.)

---

## Five things that recurred across every one of 2.1–2.8 and will recur again

- **Grep the caller list at Phase 0. The checklist was wrong four times out of
  eight.** Phase 0 on 2026-08-26 made it five: this file's own predecessor recorded
  two improvised tracker empty states when there were three, and recorded
  `SavedGame.status` as live when it has never had a single writer or reader.
  **This is the single highest-value thing Phase 0 does.**
- **A spec gap is escalated, not filled in.** 2.8's BA halted twice and both were
  settled in minutes. A BA that guesses here costs a whole run.
- **A test can pass by construction.** Prove falsifiability: inject the regression
  the test is meant to catch, confirm it fails, revert. About two minutes. **Re-prove
  it if you later change the harness** — a harness change can quietly turn a real
  test into a passing one.
- **An unscoped `find.byType` can match something else entirely.** Scope finders with
  `find.descendant(of: find.byType(TheComponent))`. A tree-shape claim is verified by
  **building** the tree, not asserted in a design doc.
- **A criterion phrased about position or pixels usually has a checkable form.** 2.6
  pinned a count plus the *absence* of a parameter that could break the rule. Reach
  for that before marking something manual-only.

## Conventions stricter than older code shows — re-read the skills, don't pattern-match

- Widgets carry **no comments at all**. Not "few" — none. (`zone_label.dart` still
  carries four, found 2026-08-26; it predates the rule. Sweep it if that file is
  ever open.)
- Widget tests never assert dimensions, gaps, radii or positions; colour assertions
  must carry meaning and name a token; **never** a golden test.
  `context_chip_test.dart` and `stat_pill_test.dart` are the reference files for
  shape and length.
- Tests import only a module's public entry point. Item 2.4 shipped ten violations
  against its own brief.
- **Module folder vs single file is a per-item judgement, not a rule either way.**
  The `flutter-widgets` skill still states the flat rule as absolute, matching
  neither 2.1–2.4/2.7 (folders) nor 2.5/2.6/2.8 (flat). QA has flagged this six
  times; it is a live follow-up, not a rule to obey blindly.
- `tech-lead-agent` and `ba-agent` have **no Bash tool**. Do not tell them to run a
  command. `dev-agent` and `qa-agent` do.

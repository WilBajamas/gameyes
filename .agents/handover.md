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
is now fully ticked, including the three "Open decisions" that had gone stale
(2.5's and 2.7's were settled inside their own runs and never ticked).

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

**Week 2 Stage 2 (composites) — 7 of 8 done, only 2.8 left.** 2.1–2.4 shipped
2026-08-21, 2.5–2.7 on 2026-08-24; run folders retired. Read `.agents/week-2-task-briefs.md`'s "How to use this"
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

- **2.3 Countdown + Countdown tile** (`lib/widgets/countdown/`, Dev commit
  `5c2266b`) — two public widgets, `CountdownCard` and `CountdownTile`, over a
  shared `CountdownDigitRow`. Featured's countdown section rewired; the tile ships
  unwired (the welcome hero that would have hosted it went to flat PNG art in item
  6.1). **Provably timer-free**: every class in the module is a `StatelessWidget`,
  so there is no lifecycle hook in which to start a timer and the cubit stays the
  only clock — QA verified no `Timer`/`Ticker`/`AnimationController` anywhere in the
  folder. `ButtonPressScale` is deliberately not reused for the same reason.
  **Scope was deliberately widened past the component**, by human decision: the
  "Wishlisted" badge fired on whole-library membership (`isFallback =
  !localLibraryGameIds.contains(...)`), so it asserted something false about the
  user's own library. A real wishlist boolean now travels repo → use case → state
  via a new `CountdownGameEntity` with both fields `required`, and both repository
  branches resolve it through one helper — the stale-flag bug is *unrepresentable*,
  not merely avoided. The card takes no library-membership input at all; the rail
  keeps `localLibraryGameIds` for its owned marker.
  Three further human calls: the 80×110 cover thumbnail dropped (the screen doc
  lists none and outranks §3.2), `isReleaseDay` left the widget API (the component
  derives it from the duration), and the rail's hand-rolled green owned-marker
  replaced with 2.1's `LibraryTick`. All §4/§1.9 violations are gone — emoji,
  exclamation marks, `Colors.amber`/`Colors.green`, the gradient, `elevation: 3`
  and the file's `// TODO: Refactor this`.

- **2.4 Tab bar** (`lib/widgets/bottom_tab_bar/`, Dev commit `31d3f55`) — six-file
  module replacing `scrolled_navigation_bar.dart` and `navigation_destination.dart`,
  both **deleted** rather than deprecated (keeping the old bar alive would have left
  the only remaining reader of `ScrollNotifier` in the tree). Onyx `surfaceTabChrome`
  chrome, 3px indigo cap over the active glyph, labels always visible.
  **The scroll-hide behaviour was DROPPED by human decision.** The old bar collapsed
  to zero height on scroll-down via the `getIt` `ScrollNotifier` singleton. That is a
  deliberate, visible change to a shipped screen — do not "restore" it as a
  regression. **`ScrollNotifier` is now fully orphaned but deliberately left in
  place**: the singleton, its DI registration, three writer sites
  (`home_screen.dart:61`, `browse_screen.dart:19`, `settings_screen.dart:26`) and
  `settings_screen_test.dart:38`'s registration. Its own follow-up, not this run's.
  **It also corrected a live bug nobody had noticed**: `CustomNavigationDestination`
  painted the UNSELECTED destination indigo and the SELECTED one grey — inverted
  against spec the whole time.
  Two things about this run's test file are worth carrying forward. Four tests were
  removed at the human's request (12 → 8), including the only automated cover for
  keyboard activation and for the colour correction above — both are now the two
  **highest-priority entries in `manual-check-backlog.md`**. And QA caught the tests
  reaching into module internals (`find.byType(BottomTabBarCell)` ×10) against the
  brief's own constraint; a post-QA commit reworked all 8 onto the public surface.
  Worth watching for in the next module — it is an easy default.
  **`elevation: 0` on `Material` was knowingly kept** despite being redundant, so the
  analyzer baseline is **33 from here, not 32**. A decision, not drift; don't "fix"
  it in a sweep without asking.

- **2.5 Form fields** (`lib/widgets/labeled_text_field.dart`, Dev commit `79255bd`) —
  `DefaultBorderTextField` **deleted**, not deprecated, and replaced by
  `LabeledTextField`: label always above, helper and character counter folded onto
  that label row, `surfaceRaised` fill at r16, 2px green focus ring at 2px offset,
  and an error state that swaps the fill for `errorTint` plus a 1px `errorLine`
  hairline. All 7 call sites rewired across 3 files. QA PASS, 0 cycles.
  **A single file, not a module folder** — the first Stage 2 item where the folder
  wasn't earned (no variant enum, no painter, two parent-only helpers). A folder
  would only have imported 2.4's public-surface trap for no gain.
  **"Ship unwired" was a false choice, and this generalises.** The checklist offered
  rework-vs-unwired as if both were available; an in-place rework *cannot* ship
  unwired, because the same class in the same file changes every caller the moment
  it merges. "Unwired" only exists by building a second component beside the old
  one. Worth remembering the next time a checklist bullet offers that fork — 2.6
  and 2.7 both rework existing code.
  **The caller list was right this time**, unlike 2.1's — but it was still grepped
  before being trusted, which is what made the "false choice" finding possible.
  **It composes its own `FormField<String>` around a plain `TextField`** instead of
  using `TextFormField`, because `TextFormField` renders its error message inside
  the same decorator as the box: a focus ring around that decorator would enclose
  box *and* message, so `[2.5-AC7]` and `[2.5-AC9]` could not both hold. Documented
  boundary: the form value tracks the controller at first build then via
  `onChanged`, so external mutation of a validated controller wouldn't propagate.
  No call site does that today.
  **A silent pre-existing bug was found and fixed.** `maxLengthEnforce: false`
  passed `null`, and **`maxLengthEnforcement: null` does NOT mean "no enforcement"**
  — it resolves per-platform and *enforces* on Android. So the flag had been doing
  the opposite of its name. The widget now passes `MaxLengthEnforcement.none`
  explicitly, and `task_detail_screen.dart`'s two editors pass
  `enforceMaxLength: true` so their shipped behaviour is unchanged — "preserve what
  ships", the 1.9 precedent.
  Three shipped surfaces change appearance on merge, accepted at the gate. Renames
  beyond the class: `maxLengthEnforce` → `enforceMaxLength`, `hint` → `placeholder`,
  `suffixIcon` dropped (zero callers).
  **Two gate outcomes that bind other items:** 2.7 now covers only the Action,
  Screen and Item error levels — the field level was built here and 2.7 inherits it
  unchanged; and the 15px type collision hit a **third** time, shipped at 14 again.

- **2.6 Rows & hairline groups** (`lib/widgets/label_value_row.dart` +
  `hairline_group.dart`) — `LabelValueRow` (`label`, `value`, `showChevron`) and
  `HairlineGroup` (`children` only). Two flat files, no module folder. QA PASS,
  0 cycles. **Ships unwired**: `group_task_item.dart`, `task_item.dart` and
  `horizontal_separator.dart` are all untouched, and no existing file references
  either widget.
  **"Ship unwired" was genuinely available here, and 2.5 explains why it wasn't
  there.** 2.6 is an *extraction* (new files beside the old), where nothing changes
  on merge; 2.5 was an in-place *rework*, where the same class in the same file
  changes every caller the moment it lands. Ask which shape an item is before
  believing a checklist bullet that offers the fork — 2.7 and 2.8 both rework
  existing code.
  **The checklist's caller claim was wrong again**, the second time in Stage 2 after
  2.1's. The bullet called all three files "tracker/task-specific";
  `horizontal_separator.dart`'s main caller is `detail_mid_section.dart`, a
  **game_detail** screen. Grepping first is what made the unwired option visible as
  a real choice rather than an assumption.
  **The hairline guarantee is a construction, not a rule.** Placement is
  `if (index > 0)` inside the child loop, and `children` is the only constructor
  parameter, so a leading or trailing hairline is a case the code cannot express.
  `[2.6-AC9]` is therefore satisfied by the **absence** of a divider flag and was
  verified at the API surface, not by a behaviour test. The N−1 count tests use
  plain `Text` children rather than `LabelValueRow`, which *demonstrates* that arity
  alone drives placement.
  **`Column` was chosen over `ListView.separated` deliberately.** The strongest form
  of the objection is that `separatorBuilder` fires exactly `itemCount − 1` times —
  the same contract, guaranteed by the framework. It loses because these groups sit
  inside already-scrolling screens, so a nested `ListView` needs
  `shrinkWrap: true` + `NeverScrollableScrollPhysics`; `shrinkWrap` builds every
  child anyway, so laziness is lost while a viewport, hit-test layer and semantics
  node are added. `.builder` is worse still: the API takes an already-built
  `List<Widget>`, so there is nothing to build lazily — real laziness would need
  `itemBuilder` + `itemCount`, which is the rejected option C. If a group ever needs
  to be *long*, add a `HairlineGroup.builder` then.
  Two follow-ups left open on purpose — see "Known non-blocking gaps".

- **2.7 Error states** (`lib/widgets/error_states/`, commits `7d69ba4` + `9f7e6f8`) —
  five files: `ErrorDot`, `ErrorNoticeVariant`, `ErrorNotice`,
  `DestructiveActionPair`, `FailedItem`. First module folder since 2.4. QA PASS after
  **2 cycles**. **Ships unwired**; `error_retry_widget.dart` and
  `default_snackbar.dart` untouched.
  **Three levels, not §3.4's four** — the Field level was already shipped by 2.5's
  `LabeledTextField` and 2.7 inherits it. A BA reading §3.4 straight would rebuild it;
  that was headed off at a gate.
  **The scope finding that decided the run: §3.4 specs no per-section retry block.**
  `ErrorRetryWidget`'s anatomy comes from §3.2's *Async states* row, not Error states
  — so replacing it would have meant designing a surface no doc describes. Two more
  caller findings worth keeping: `games_screen.dart:88` renders `ErrorRetryWidget` for
  an **empty** state (2.8's scope), and `DefaultSnackbar`'s one caller pushes success
  *and* failure through it, so §3.4's error-only toast (red dot) cannot replace it.
  **The first foundations edit a component run has been permitted** — a `surfaceToast`
  alias for `#2e3236`, because the existing token holding that value is named
  `surfaceTabChrome` (from 2.4's tab bar). `surfaceTabChrome` was left alone. Note the
  trap this created: `app_tokens_test.dart:38-50` asserts three *distinct* raised
  surfaces via a `Set`, so `surfaceToast` had to stay out of it and go only into
  `_allColors`.
  **Two test lessons, both worth more than the component:**
  - **QA cycle 1 caught a guard that passed by construction.** The AC14 test asserted
    `find.byType(ErrorNotice)` after a "dismissal", but the harness placed that widget
    unconditionally and `onDismiss` was the default no-op — a self-suppressing
    `ErrorNotice` would still have passed. **This was proved rather than argued**: the
    regression was injected (stateful `_dismissed` flag), the old test passed 7/7
    against it, the replacement failed. Injecting the regression takes about two
    minutes and is worth doing whenever a test's whole value is its falsifiability.
  - **`tdd.md` asserted a tree-shape claim that was false.** It prescribed
    `find.byType(ColoredBox)` scoped to `ErrorNotice` as "single-match"; the toast's
    own `ErrorDot` also renders a `ColoredBox`. The design's proudest feature —
    structural finder discipline — had a hole at exactly the surface it protected. A
    tree-shape claim is verified by building the tree, not asserted in a doc.
  **A `dart format` hunk landed unreported.** Dev formatted an allowlisted file and
  reflowed a pre-existing `Icon` outside the authorised line range. Benign and
  accepted, but it means **other files in the repo are unformatted** and will churn
  whenever a formatter next touches them.

- **2.8 Async states: shared empty state** (`lib/widgets/empty_state_card.dart`,
  Dev commit `6199114`) — one `EmptyStateCard`: optional glyph, caps headline, one
  supporting line, one **required** action, on `surfaceRaised` at r16. A flat file,
  not a module folder (2.5/2.6's shape). QA PASS, **0 cycles**. **Ships wired at
  five sites**, and week 2's last item.
  **The caller list was wrong for the fourth time in Stage 2** — after 2.1's, 2.6's
  and 2.7's. The handover carried two known callers; Phase 0's grep found **seven**
  improvised empty states. Five were fixed: `games_screen.dart` (an `ErrorRetryWidget`
  rendering an *empty* state), `library_stats.dart`'s dashed card, and
  `critics_grid.dart` + `countdown_releases.dart`, which both held **hardcoded,
  untranslated English** — a defect nobody had recorded. The human ruled
  `featured_screen.dart`'s `SizedBox.shrink()` in scope too, so a section that
  vanished silently now recruits. **Grep at Phase 0. Four for four.**
  **The doc the checklist named was also wrong**: the empty-state workaround note
  lives in `.claude/skills/flutter-widgets/SKILL.md`, not `project-conventions.md`
  — it moved in the 2026-08-07 restructuring. The skill was updated.
  **Two spec gaps recorded rather than invented around, both at a human gate.**
  §3.2's "art-deep card" fill **has no value anywhere in the project** and the
  palette has no art surface at all; §2.2 calls art-deep violet while §2 rule 4
  keeps violet out of the UI until ratified. The card ships on `surfaceRaised`, and
  **§2.2's "art-deep is the empty-state card fill" is unimplemented app-side** —
  this now sits beside the 15px token as a standing foundations gap. Separately,
  §3.2's mandatory "one action" had **no target at three of the five sites**;
  destinations were named at the gate, not assumed.
  **AC-20 shaped the whole call-site design, and the reason generalises.** The three
  featured widgets are each constructed **twice** in `featured_screen.dart` — once
  for real, once inside a `Skeletonizer` loading branch — so *any* new required
  constructor parameter forces a diff hunk in a loading branch. That is why sites 4
  and 5 call `AutoTabsRouter.of(context).setActiveIndex(3)` on their own context
  inside the tap callback instead of taking a callback parameter. **Browse is a tab,
  not a route**: `router.push(BrowseRoute())` would stack it over Featured and leave
  the tab bar's cap in the wrong place. Any future work touching those widgets
  inherits this constraint.
  **The 2.7 finder trap did not repeat, and it was closed by building the tree.**
  `tdd.md` specified `ClipRRect` + `ColoredBox` (not `DecoratedBox`, which
  `PrimaryButton`'s `Container` and `ButtonPressScale` both emit) — but the Tech
  Lead had no Bash and could only verify it against Flutter SDK source, so it shipped
  as an explicit caveat with a named fallback. Dev confirmed it single-match on the
  first run. **Stating the caveat is what made it safe**; the design did not assert
  a tree shape it hadn't verified.
  Three non-blocking findings from QA, none gating: the glyph's **positive** case is
  untested (mutating the widget so a glyph never renders leaves the suite green —
  the "hides when absent" behaviour is protected, "shows when supplied" is not,
  despite four sites passing one); five hunks of pure `dart format` churn landed in
  `critics_grid.dart` on code the plan never asked Dev to touch, the same shape as
  2.7's stray hunk; and `EmptyStateCard` **declares no width**, filling its parent
  only because `PrimaryButton` sets `width: double.infinity`.

**Two conventions worth knowing before the next Stage 2 item**, both learned the
hard way this session:
- **§3's type steps keep colliding with "dimensions are even numbers."** Item 1.9
  hit it at 15px and left the gap open for want of a token; 2.2 hit it again and
  shipped 14; **2.5 hit it a third time and shipped 14 again**. A 15px type token
  still doesn't exist, and three runs have now worked around its absence. Minting
  one is a foundations change — deliberately kept out of every component run so
  far, but it is now the most-repeated open gap in this file.
- **A "one file per widget family" flat `lib/widgets/` is no longer true** — but
  neither is "always a module folder". 2.1, 2.2, 2.3 and 2.4 all ship module
  folders with an `enum/` subfolder, human-directed each time; **2.5 deliberately
  ships a single file**, because it has no variant enum, no painter and only two
  parent-only helpers. Decide on the merits per item. The `flutter-widgets` skill
  still states the flat rule as absolute — see the follow-ups.

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
  `.agents/manual-check-backlog.md`** — **92 checks** as of 2026-08-25, every one
  still unperformed. **Do not quote that number from here; recount in the file.**
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
- **`.claude/skills/flutter-widgets/SKILL.md`'s "one file per widget family" rule
  text contradicts four shipped modules** (`game_card/`, `completion_ring/`,
  `countdown/`, `bottom_tab_bar/`). Every folder was human-directed; the rule
  sentence was deliberately not updated in any run. Flagged by QA repeatedly.
  Item 2.5 edited that file's **catalogue row** (a gate decision) while still
  leaving the rule sentence alone, so the contradiction has now survived a run
  that had the file open. Note 2.5 also shipped a deliberate *single* file, so the
  right wording is "decide per item", not a simple inversion. Whoever next edits
  that skill should settle it.
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
- ~~A live "outlines are always solid" violation in `library_stats.dart`~~ —
  **CLOSED by item 2.8, 2026-08-25.** `_DashedBorderPainter` and its
  `BorderStyle.none` recipe are deleted; the empty now-playing card is now an
  `EmptyStateCard` with a solid edge. Confirming it on device is `2.8-MC-4`.
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
- **`no_results_found` is the one empty state that still apologises.** Item 2.8's
  site 1 (the games grid) reuses that key, so its headline reads "NO RESULTS FOUND"
  — correct per its criterion, but against §3.2's own "empty states recruit, they
  never apologise." Deliberately not reworded mid-run. `2.8-MC-5` asks for a human
  eye on device before deciding whether to raise the follow-up.
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
- **Never `git add -A` while a subagent is live in the same tree.** The
  orchestrator did this during item 2.6's Dev phase and swept the Dev Agent's
  in-progress widget and test files into a docs commit, so that item's
  implementation is split across two commits (`6689860` and `409fe04`) under a
  message describing only documentation. Harmless to the code, misleading in
  history, and it forced QA to be told to diff a range rather than read a commit.
  Stage explicit paths, or wait for the agent to return.
- **If a subagent dies with finished-but-uncommitted work, the orchestrator may
  commit it** — established during item 2.6, when the Dev Agent hit an
  account-wide session limit at its commit step with `diff-summary.md` already
  written. Verify the baseline independently first, commit the work *unchanged*,
  and state the authorship in the commit message. A deliberate one-off departure
  from "only the Dev Agent commits"; the alternative is losing finished work to an
  ephemeral container. Do not use it as licence to finish an agent's work.
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

**Current phase: week 2 is COMPLETE** — component library, all 9 Stage 1
primitives and all 8 Stage 2 composites built and merged to `develop`. The
remaining week 2 work is not code: the **92-check manual backlog**, and deleting
`.agents/week-2-task-briefs.md` per its own top note. **That file is still present
and now fully ticked** — before deleting it, see gotcha #9 and actually grep the
destination to confirm anything worth keeping was promoted here or into
`.agents/references/`; week 1's checklist was deleted on that assumption and the
content briefly survived only in git history. Week 3 (Library feature) is next,
and it is blocked on a design spec — see "Open decisions that could block". Target
is a TestFlight-equivalent Android beta around week 4.

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

1. **The 92-check manual backlog** (`.agents/manual-check-backlog.md`) -- deferred
   through all of Stage 2 for one device sitting, which the human began 2026-08-25.
   Ask where they got to before assuming it is untouched. **Recount the total in
   that file rather than quoting one**: three different totals (82, 88, 90) were all
   wrong before 2026-08-25. Start with 2.4-MC-1 and 2.4-MC-2, the only two with no
   automated guard at all. 2.2's ten + 2.6's three + 2.7's five need **one** scratch
   harness between them (those modules ship unwired); 2.8's five need none and four
   sit on Featured.
2. **Delete `.agents/week-2-task-briefs.md`**, per its own top note now that every
   box is ticked. **See gotcha #9 first** -- actually grep the destination to confirm
   anything worth keeping was promoted into this file or `.agents/references/`.
   Week 1's checklist was deleted on the assumption an earlier step had handled it,
   and the content briefly survived only in git history.
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

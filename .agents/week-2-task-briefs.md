# Week 2 — Component library task briefs

> ## ⚠ EPHEMERAL — DELETE THIS FILE WHEN WEEK 2 IS DONE
>
> This is a working checklist, not a reference document. Once every item below is
> ticked, **delete `.agents/week-2-task-briefs.md`**. Anything in here worth
> keeping should have been promoted into `.agents/references/` (most likely
> `project-conventions.md`'s widget catalogue) by then. A stale checklist that
> outlives its week is worse than no checklist — agents read it as current intent.
>
> Written 2026-08-07.

---

## How to use this

Items are in dependency order. All of them are:

- **[PIPELINE]** — feed the requirement text to `/orchestrate` as a run. One item
  is one run.

Unlike week 1, this checklist has no `[MANUAL]` or `[MANUAL-CODE]` items — no
vendor consoles, no SQL, no Edge Functions. It's all Flutter.

**Source of truth for what to build:** `.agents/references/system-foundation-specs.md`
§3 ("Component library"). Read the specific subsection named in each item before
running it — this checklist gives the sequencing and the gap against what already
exists, not the full spec text.

**Source of truth for how to build it:**
`.agents/references/project-conventions.md`'s "Building a new reusable widget"
section — file placement, naming (no `default` prefix on new widgets — name
them categorically: `PrimaryButton`, `StatusChip`), matching the hand-written
style, keeping them simple and configurable, and reuse-before-rebuild with
`@Deprecated` rather than deletion. Every item in this checklist should be read
against those rules, not just the visual spec.

**Out of scope entirely — §3.1.** `system-foundation-specs.md` §3.1 ("From the
bound bundle — compose, never recreate": `Button`, `Badge`, `NavBar`, `Hero`,
`FeatureCard`, `PricingTable`, `FaqAccordion`, `CtaBand`, `MarqueeBand`, `DataTable`,
`Modal`, `Toast`, `EmptyState`, `TextInput`, `AuthFormCard`, etc.) is mounted via
`<x-import component-from-global-scope="QuestLoggdDesignSystem_347483.<Name>">` — an
external, bound design-system bundle for a **different property** (reads as a
marketing/landing-site component set), not a Flutter build target. Confirmed:
`x-import` appears nowhere else in this repo. Nothing in this checklist touches §3.1.

**Explicitly deferred to week 3, not started here — the Add-to-library sheet.**
Spec'd in §3.2, but it binds to a Library entity/status model that doesn't exist
until week 3's `tracker` → `library` migration. `lib/widgets/add_content_dialog.dart`
is a tracker-era dialog, not this component under an old name — no status pre-select,
no platform/rating, no green CTA, and it's a `Dialog` not a bottom sheet. Building it
now means building it twice. Revisit alongside week 3's Library design spec.

**Two components already exist correctly** and just need promoting to
`lib/widgets/` from their current feature-only home — see 2.8 and 2.9.

---

## Stage 1 — Primitives

Small, mostly self-contained pieces other components in Stage 2 build on. Build
these first so Stage 2 items compose them rather than duplicating ad hoc styling.

- [x] **1.1 — Zone label.** `system-foundation-specs.md` §3.2 "Zone label" row.
      A text-style token already exists
      (`lib/config/theme/tokens/app_type_tokens.dart`'s `zoneLabel`) but nothing
      enforces the pattern itself: the label plus a large vertical gap **is** the
      separation — no rules, no dividers, no numbering, optional right-aligned
      cyan link at 13px/500. Build the widget so screens stop hand-rolling this.

- [x] **1.2 — Status chip / Status system.** `system-foundation-specs.md` §3.2
      "Status system" + §3.3 "Status chip" primitive. Missing entirely —
      `lib/widgets/saved_game_status_tag.dart` is a solid-color rect tag, not a
      glass pill with dot + label + count. Six status pills, Playing the only
      filled state (indigo), rest on 8% ink; on-media variant (6px dot) and list
      variant (7px dot). Counts are load-bearing per spec — never a dead-end
      filter.

- [x] **1.3 — Cover tile.** `system-foundation-specs.md` §3.3 "Cover tile"
      primitive. Missing — `default_cached_network_image.dart` has no
      `saturate(.5) contrast(1.05)` + flat indigo wash treatment, and none of the
      four sizes (mini/row/fan/focal). This is the image treatment Game card
      (2.1) will need, so it comes first.

- [x] **1.4 — Placeholder slot.** `system-foundation-specs.md` §3.3 "Placeholder
      slot" primitive. Rework — `lib/widgets/logo_placeholder.dart` is close
      (uses `ink12`/`ink24` tokens, r20) but the border is solid, not dashed, and
      it isn't constrained to the spec's two presets (app mark `88` r20 · provider
      mark `20` r-xs).

- [x] **1.5 — Filter / count chip.** `system-foundation-specs.md` §3.3
      "Filter / count chip" primitive. Rework —
      `lib/widgets/default_choice_chip.dart` wraps stock `ChoiceChip` with no
      active/inactive ink-token treatment and no count slot.

- [x] **1.6 — Context chip.** `system-foundation-specs.md` §3.3 "Context chip"
      primitive. Missing entirely — no matches anywhere in the repo. Glass, one
      per hero, `top:54px`.

- [x] **1.7 — Stat pill.** `system-foundation-specs.md` §3.2 "Stat pill" row +
      §3.3 "Stat pill" primitive (same component, two size contexts). Rework —
      `lib/features/featured/presentation/widgets/library_stats.dart`'s
      `_buildStatTile` is a plain bordered container (carries a `// TODO: Refactor
      this`), not the glass `--radius-pill` shape. Figure display 700, label 55%
      ink, used in threes.

- [x] **1.8 — Progress dots — promote to `lib/widgets/`.** `system-foundation-specs.md`
      §3.3 "Progress dots" primitive. **Already exists correctly** —
      `lib/features/onboarding/presentation/widgets/welcome_container.dart`
      lines 57–81 match spec exactly (22×5 active / 5×5 inactive, `radius.pill`,
      6px gap). It's hardcoded to 2 steps inline. Extract as a reusable widget
      under `lib/widgets/`, promoted per `flutter-arch.md`'s promotion rule (explicit
      app-wide ownership, generic API). Welcome screen becomes its first caller of
      the extracted version, not a rewrite of its own behaviour.

- [x] **1.9 — Provider / list row — promote to `lib/widgets/`.**
      `system-foundation-specs.md` §3.3 "Provider / list row" primitive.
      **Already exists correctly** —
      `lib/features/auth/presentation/widgets/provider_action_button.dart`'s
      `_ProviderActionButton` matches spec exactly (52px, `radius.sm`, 20px leading
      icon slot, centred 15px/500 label, 44px hit-target floor). Extract and
      promote the same way as 1.8. Sign-in screen becomes its first caller of the
      extracted version.

---

## Stage 2 — Composite components

Built on Stage 1's primitives. Do these after Stage 1 so they compose rather than
duplicate.

- [x] **2.1 — Game card.** `system-foundation-specs.md` §3.2 "Game card" row.
      Rework — `lib/widgets/game_item.dart` has one anatomy (spec wants three
      sizes: `xs` 64px no footer / `sm` 132px / `md` 220px+), wrong aspect ratio
      (4:4.8, spec wants 3:4 at r16), no overlays (indigo library tick, status
      chip, green critic badge), and missing-art falls back to an `error404` PNG
      instead of an onyx fill + hairline + gamepad glyph. Builds on 1.2 (status
      chip) and 1.4 (placeholder slot). **Done 2026-08-21** (run
      `game-card-20260821`, Dev commit `26b5951`).
      **This bullet's caller list was wrong** — tracker and featured never
      referenced `GameItem` at all. The three real direct references were
      `games_screen.dart` and the two shimmer widgets, and the human chose to
      rewire all three in-run (Option B). `critics_grid.dart` is an inline
      *duplicate* of the anatomy rather than a caller, and `saved_game_item.dart`
      is a different anatomy entirely; both were deliberately deferred. Three
      things ship knowingly off-spec by human decision, all recorded in the run's
      `ambiguities.md` and `tdd.md` — the §3.2 desaturation filter (rejected at
      1.3, absence is the pass condition), platform marks staying as
      `PlatformRowList` logo images rather than §1.9 text abbreviations, and
      `md`'s 220px being a design reference rather than an enforced minimum.

- [x] **2.2 — Completion ring.** `system-foundation-specs.md` §3.2 "Completion
      ring" row. Missing entirely — no ring widget anywhere in the codebase. A
      ring, not a bar; indigo the whole way, closed magenta ring at 100%. Three
      sizes: 60px inline / 80px specimen / 88px detail panel, percentage in the
      display face at centre. No current caller — this is groundwork for the
      Game Detail screen (week 3/4), fine to ship unwired.
      **Done 2026-08-21** (run `completion-ring-20260821`, Dev commit `a3a918a`).
      Built as a hand-rolled `CustomPainter`, the project's first — the
      `linear_progress_bar` package was evaluated at the human's request and
      rejected, as was Material's `CircularProgressIndicator`; don't re-open
      without new information. Ships unwired as planned. Two approved deviations:
      the semantics label reuses the existing `completed_percentage` key so it
      announces "37% completed", and the 60px centre type is 14 rather than
      §3.2's 15 (the even-number convention binds new code — the second time §3's
      type steps have collided with it, after item 1.9's 15px gap). The single
      indigo→magenta test was removed at Phase 4B by human decision; it turned out
      to be carrying C8, C9's colour and C10's colour too, so all of those are
      manual-only now and sit in `manual-check-backlog.md`.

- [x] **2.3 — Countdown + Countdown tile.** `system-foundation-specs.md` §3.2
      "Countdown" row + §3.3 "Countdown tile" primitive. Rework —
      `lib/features/featured/presentation/widgets/countdown_releases.dart`'s
      `_buildTimeBox` (carries a `// TODO: Refactor this`) has the digit-block
      idea but wrong fills, no colon glyphs, and emoji in copy that violates
      `system-foundation-specs.md` §4's content rules. Build both the raised-card
      form and the glass-tile hero variant, then swap `featured`'s countdown
      section over to the new component in the same item — this is a single
      known caller, low risk to rewire immediately rather than leave parallel
      implementations.
      **Done 2026-08-21** (run `countdown-20260821`, Dev commit `5c2266b`). Two
      public widgets — `CountdownCard` and `CountdownTile` — over a shared
      `CountdownDigitRow`, in `lib/widgets/countdown/`. Provably timer-free: every
      class in the module is a `StatelessWidget`, so the cubit stays the only clock.
      Featured's countdown section rewired; the tile ships unwired (the welcome hero
      that would have hosted it went to flat PNG art in item 6.1).
      **Scope was deliberately widened past the component at the human's request:**
      the "Wishlisted" badge was firing on whole-library membership, not the wishlist,
      so it asserted something false about the user's own library. A genuine wishlist
      boolean now travels repo → use case → state via a new `CountdownGameEntity`
      with both fields required, and both repository branches resolve it through one
      helper — the stale-flag bug is unrepresentable rather than merely avoided.
      Also at the human's call: the 80×110 cover thumbnail was dropped (the screen
      doc lists none and has authority over §3.2), `isReleaseDay` left the widget API
      (the component derives it from the duration), and the rail's hand-rolled green
      owned-marker was replaced with item 2.1's `LibraryTick` — indigo, per §2's
      colour law rationing green. All the §4/§1.9 violations are gone: emoji,
      exclamation marks, `Colors.amber`/`Colors.green`, the gradient and `elevation: 3`,
      along with the file's `// TODO: Refactor this`.

- [x] **2.4 — Tab bar.** `system-foundation-specs.md` §3.2 "Tab bar" row.
      Rework — `lib/features/home/presentation/screens/home_screen.dart` +
      `lib/widgets/scrolled_navigation_bar.dart` / `navigation_destination.dart`
      already have the right destination count (5) but use stock Material
      `NavigationBar` chrome, not the spec's onyx `#2e3236` background with a 3px
      cap above the active glyph. Single caller (home screen's shell) — rewire in
      the same item.
      **Done 2026-08-22** (run `tab-bar-20260822`, Dev commit `31d3f55`). New
      `lib/widgets/bottom_tab_bar/` module (6 files); both old widgets deleted
      rather than deprecated, because keeping them would have left the only
      remaining reader of `ScrollNotifier` alive. The single-caller claim was
      accurate this time — verified at Phase 0.
      **The bar's scroll-hide behaviour was DROPPED by human decision** — it used
      to collapse to zero height on scroll-down via the `ScrollNotifier` singleton.
      A deliberate, visible change to a shipped screen. `ScrollNotifier`, its DI
      registration, three writer sites and a test registration are now dead but were
      deliberately left in place as a follow-up rather than widening a chrome item
      into four unrelated files.
      Also corrected a live bug nobody had noticed: `CustomNavigationDestination`
      painted the UNSELECTED destination indigo and the selected one grey — inverted.
      Four widget tests were removed at the human's request (12 → 8), including the
      only automated cover for keyboard activation and for that colour correction;
      both are now the two highest-priority items in `manual-check-backlog.md`.
      `elevation: 0` was knowingly kept despite being redundant, so **the analyzer
      baseline is 33 from here, not 32** — that is a decision, not drift.

- [x] **2.5 — Form fields.** DONE 2026-08-24, merged to `develop`. Run
      `form-fields-20260823`, Dev commit `79255bd`, QA PASS with 0 cycles used.
      `default_border_text_field.dart` **deleted** (not deprecated) and replaced by
      `lib/widgets/labeled_text_field.dart` — a single file, not a module folder:
      no variant enum, no painter, two parent-only helpers, so a folder would only
      have imported 2.4's public-surface trap for no gain. First Stage 2 item where
      the folder wasn't earned.
      **The checklist's caller claim was RIGHT this time** — unlike 2.1's. Three
      files, seven sites, all rewired: `add_content_dialog.dart` (2),
      `filter_bottom_sheet.dart` (3), `task_detail_screen.dart` (2). Nothing else
      in the app builds a raw text input.
      **The "ship unwired" option above was a false choice**, and that is the most
      reusable thing this run found: an in-place rework *cannot* ship unwired, since
      the same class in the same file changes all its callers on merge. "Unwired" is
      only ever available by building a second component. Three shipped surfaces
      change appearance, accepted at the gate.
      **It composes its own `FormField<String>` around a plain `TextField`** rather
      than using `TextFormField`, because `TextFormField` renders its error message
      inside the same decorator as the box — so a focus ring around it would enclose
      box *and* message, and `[2.5-AC7]` and `[2.5-AC9]` could not both hold.
      **A silent pre-existing bug was found and fixed:** `maxLengthEnforce: false`
      passed `null`, and `maxLengthEnforcement: null` resolves to *enforced* on
      Android — so "not enforced" had been enforcing all along. The flag now means
      what it says, and `task_detail_screen.dart`'s two editors pass
      `enforceMaxLength: true` so their shipped behaviour is unchanged ("preserve
      what ships", per 1.9).
      Two gate outcomes that bind other items: **2.7 now covers only the Action,
      Screen and Item error levels** — the field level was built here and 2.7
      inherits it unchanged; and the **15px type collision hit a third time** (after
      1.9 and 2.2), shipped at 14 again, still no token.

- [x] **2.6 — Rows & hairline groups.** DONE 2026-08-24, merged to `develop`. Run
      `rows-hairline-20260824`, QA PASS with 0 cycles. Two new widgets, both in
      `lib/widgets/`: `LabelValueRow` (`label`, `value`, `showChevron`) and
      `HairlineGroup` (`children` only). Ships **unwired** — `group_task_item.dart`,
      `task_item.dart` and `horizontal_separator.dart` are all untouched, exactly as
      this bullet asked, and tracker's rows stay optional adopters.
      **This bullet was wrong that all three files are tracker-specific.**
      `horizontal_separator.dart`'s main caller is `detail_mid_section.dart`, a
      **game_detail** screen; `group_task_item.dart` uses it internally. It was
      already a shared cross-feature primitive, which is why touching it would have
      changed a shipped surface and killed the unwired option. Second checklist
      caller-list error in Stage 2, after 2.1's.
      **"Ship unwired" was genuinely available here, unlike 2.5** — because this is
      an *extraction* (new files) rather than an in-place rework. 2.5 established
      that a rework can never ship unwired. That distinction is the reusable one.
      **The hairline guarantee is a construction, not a rule.** Placement is
      `if (index > 0)` inside the child loop and `children` is the only constructor
      parameter, so a leading or trailing hairline is a case the code cannot express
      — `[2.6-AC9]` is satisfied by the *absence* of a divider flag, verified at the
      API surface rather than by a behaviour test. A `Column` was chosen over
      `ListView.separated` deliberately; the reasoning is in the handover.
      **Two follow-ups left open on purpose:** `horizontal_separator.dart` still has
      a hardcoded `Colors.grey` and `width: context.screenWidth` (out of scope by
      the gate decision, now in the handover's follow-ups), and §4.4's green
      "Day one" price needs a per-row value colour the minimal API omits — flagged
      for whoever builds Where to play.

- [x] **2.7 — Error states.** DONE 2026-08-24, merged to `develop`. Run
      `error-states-20260824`, commits `7d69ba4` + `9f7e6f8`, QA PASS after 2 cycles.
      Shipped as `lib/widgets/error_states/` — 5 files: `ErrorDot`,
      `ErrorNoticeVariant`, `ErrorNotice`, `DestructiveActionPair`, `FailedItem`.
      Ships **unwired**; `error_retry_widget.dart` and `default_snackbar.dart` are
      untouched.
      **THREE levels, not this bullet's four** — the Field level was already shipped
      by item 2.5's `LabeledTextField`, settled at a gate. 2.7 built Action, Screen
      and Item only.
      **The decisive scope finding: §3.4 specs no per-section retry block at all.**
      `ErrorRetryWidget`'s anatomy comes from §3.2's *Async states* row, not the
      Error states row — so replacing it would have meant designing a surface no
      document describes. That is why the item ships unwired rather than rewiring.
      Two further caller findings: `games_screen.dart:88` renders `ErrorRetryWidget`
      for an **empty** state (2.8's scope, not 2.7's), and `DefaultSnackbar`'s single
      caller pushes both success *and* failure through it, so §3.4's error-only toast
      cannot replace it as-is.
      Also **the first foundations edit a component run has been permitted**: a
      `surfaceToast` alias for `#2e3236`, because the existing token with that value
      is named `surfaceTabChrome` (minted for 2.4's tab bar) and a toast reading that
      name would look like a bug. `surfaceTabChrome` itself was left alone.
      **Dead code removed**, narrowly and by explicit decision:
      `detail_screenshot_section.dart` deleted in full — 66 lines of which 54 were
      commented out, a live body of `SizedBox.shrink()`, and its only reference also
      commented out. The dormant `GameScreenshotCubit` / entity / model chain behind
      it was deliberately **left**, as was `ImageRouteView`'s registration; see the
      handover follow-up.
      **One §3.4 spec gap surfaced, needing a design answer rather than a code fix:**
      `FailedItem`'s badge and the library tick occupy a character-identical
      `Positioned(top: 8, right: 8)`, so an item that is both in-library and failed
      stacks them.

- [ ] **2.8 — Async states: shared empty state.**
      `system-foundation-specs.md` §3.2 "Async states" row (empty-state half only
      — the loading/shimmer half is already correct and out of scope here: see
      `project-conventions.md`'s shimmer catalogue, nothing to change). Missing —
      there's no shared empty-state component; `project-conventions.md` itself
      documents the current workaround ("use `ErrorRetryWidget` with custom
      text... or a plain centred `Text`"), and features like `featured` improvise
      their own inline. Spec wants: art-deep card, glyph, caps display headline,
      one line, one action — "empty states recruit, they never apologise." Once
      built, this supersedes the `project-conventions.md` empty-state note — flag
      that doc for an update when this ships.

---

## Not in this checklist

- **Add-to-library sheet** — see "How to use this" above. Week 3, alongside the
  Library feature and its design spec.
- **§3.1's bundle-imported components** — see "How to use this" above. Not a
  Flutter build target, ever, in this codebase.
- **Device frame** (§3.5) — a showcase/marketing presentation convention
  (`330×714` frame with a label above it), not an in-app component. Not relevant
  to the shipping app.

---

## Open decisions that could block

- [x] **Rewiring scope for 2.1 (Game card)** — settled 2026-08-21: rewired in the
      same run (Option B). Note the checklist's own caller list for 2.1 was wrong;
      verify 2.5's before trusting it too.
- [ ] **Rewiring scope for 2.5 (Form fields)** — has multiple existing callers.
      That item's own BA/Tech Lead phase should size the blast radius and decide
      whether rewiring belongs in the same run or ships as a follow-up, rather
      than this checklist guessing.
- [ ] **2.7's grain** — four error-state levels in one task-brief vs. four. Tech
      Lead's call when that item runs.

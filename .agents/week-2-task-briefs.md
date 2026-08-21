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

- [ ] **2.2 — Completion ring.** `system-foundation-specs.md` §3.2 "Completion
      ring" row. Missing entirely — no ring widget anywhere in the codebase. A
      ring, not a bar; indigo the whole way, closed magenta ring at 100%. Three
      sizes: 60px inline / 80px specimen / 88px detail panel, percentage in the
      display face at centre. No current caller — this is groundwork for the
      Game Detail screen (week 3/4), fine to ship unwired.

- [ ] **2.3 — Countdown + Countdown tile.** `system-foundation-specs.md` §3.2
      "Countdown" row + §3.3 "Countdown tile" primitive. Rework —
      `lib/features/featured/presentation/widgets/countdown_releases.dart`'s
      `_buildTimeBox` (carries a `// TODO: Refactor this`) has the digit-block
      idea but wrong fills, no colon glyphs, and emoji in copy that violates
      `system-foundation-specs.md` §4's content rules. Build both the raised-card
      form and the glass-tile hero variant, then swap `featured`'s countdown
      section over to the new component in the same item — this is a single
      known caller, low risk to rewire immediately rather than leave parallel
      implementations.

- [ ] **2.4 — Tab bar.** `system-foundation-specs.md` §3.2 "Tab bar" row.
      Rework — `lib/features/home/presentation/screens/home_screen.dart` +
      `lib/widgets/scrolled_navigation_bar.dart` / `navigation_destination.dart`
      already have the right destination count (5) but use stock Material
      `NavigationBar` chrome, not the spec's onyx `#2e3236` background with a 3px
      cap above the active glyph. Single caller (home screen's shell) — rewire in
      the same item.

- [ ] **2.5 — Form fields.** `system-foundation-specs.md` §3.2 "Form fields" row.
      Rework — `lib/widgets/default_border_text_field.dart` is a stock
      `TextFormField` with a floating label and hardcoded `Colors.red` for errors,
      not the token-driven fill/focus/error treatment (label always above, no
      placeholder-as-label, `#2f333c` fill at r16, 2px green focus at 2px offset,
      error swaps fill for error tint + hairline). Tokens for this already exist
      in `app_color_tokens.dart`. Check current callers before deciding whether to
      rewire in this item or ship unwired — same call as 2.1.

- [ ] **2.6 — Rows & hairline groups.** `system-foundation-specs.md` §3.2
      "Rows & hairline groups" row. Rework — `group_task_item.dart`,
      `task_item.dart`, and `horizontal_separator.dart` cover the visual pattern
      (raised card at r16, hairline between rows only) but are tracker/task-
      specific, not a generic reusable row primitive with the spec's label-left/
      value-right/optional-chevron shape. Extract the generic pattern; leave
      tracker's own rows as later, optional adopters rather than forcing a rewrite
      here.

- [ ] **2.7 — Error states (4 levels).** `system-foundation-specs.md` §3.2
      "Error states" row + §3.4 (full detail: Field / Action / Screen / Item).
      Missing entirely — only the generic `error_retry_widget.dart` and
      `default_snackbar.dart` exist; none of the four spec'd levels (field-level
      tinted fill + red hairline; action-level destructive-fill confirmation;
      screen-level dismissable strip or single-line toast; item-level dimmed card
      + wordless corner badge) are built. Four sub-components, one item — Tech
      Lead should confirm that's the right grain rather than four separate runs.

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

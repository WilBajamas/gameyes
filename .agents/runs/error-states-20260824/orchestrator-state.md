# Orchestrator State
Feature: Week 2 Stage 2 item 2.7 — Error states (`system-foundation-specs.md` §3.2 "Error states" row + §3.4)
Run ID: error-states-20260824
Run folder: .agents/runs/error-states-20260824/
Started: 2026-08-24
Current phase: DEV
QA cycles used: 0
Analyzer baseline: 0 errors, 2 warnings, 31 info (33 total) — re-verified on `develop` after the 2.6 merge
Test baseline: +325 -10 — re-verified on `develop` after the 2.6 merge
Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart (4), test/cubit/game_detail/game_detail_cubit_test.dart (3), test/cubit/games/games_bloc_test.dart (3)
Branch: claude/form-fields-token-treatment-imd2bg
Base branch: develop
Base SHA: e0b2111 (develop, immediately after item 2.6 merged and its run folder retired)
Dev commit: NONE
Last updated: 2026-08-24

The pass count has moved twice recently — 312 → 315 (2.5's three tests) → 325
(2.6's ten). Both baselines were re-run on merged `develop`, not inherited.

## Phase 0 recon (orchestrator, pre-BA)

### Scope is REDUCED from the checklist bullet — three levels, not four

The checklist lists Field / Action / Screen / Item. **The Field level is already
built**: item 2.5's `LabeledTextField` ships the tinted fill plus error hairline,
and a human gate decision on 2026-08-24 settled that **2.7 inherits it unchanged**.
2.7 therefore covers **Action, Screen and Item only**.

This is exactly the trap the handover warns about — §3.4's text still describes all
four levels, and a BA writing criteria straight from it would rebuild the field
level. Third instance of that failure mode if it happens (after two on the
desaturation filter).

### Existing error surfaces — grepped, not inherited

The checklist has been wrong about callers **twice** in Stage 2 (2.1's named two
files that never referenced the component; 2.6's called
`horizontal_separator.dart` tracker-specific when its main caller is a game_detail
screen). So:

| Component | Live callers | Where |
|---|---|---|
| `ErrorRetryWidget` (37 lines) | **5** | `detail_top_header.dart:34`, `detail_mid_section.dart:29`, `games_screen.dart:68/78/88` |
| `DefaultSnackbar` (21 lines) | **1** | `task_detail_screen.dart:70` |

Note `detail_screenshot_section.dart:22` and `:52` hold two **commented-out**
`ErrorRetryWidget` blocks — dead code, not callers. Worth flagging rather than
counting either way.

### Rework or extraction — decide this before anything else

Items 2.5 and 2.6 together established the rule that decides whether "ship unwired"
is even available:
- **2.5 (in-place rework): unwired is impossible.** Same class, same file means
  every caller changes on merge.
- **2.6 (extraction, new files): unwired is genuinely available.** Nothing existing
  was touched.

**2.7 is a mix, and that is the gate question.** The Screen level overlaps
`DefaultSnackbar` (1 caller) and the Action/Screen levels arguably overlap
`ErrorRetryWidget` (5 callers, across two features). New components beside them ship
unwired; absorbing either changes shipped surfaces. Put the real shape to the human
rather than assuming.

### Tokens — all present, but one naming question

`errorStrong` (`0xFFD92D20`), `errorInk`, `errorLine`, `errorTint` all exist.

**§3.4's Screen toast specifies `#2e3236`, and a token with exactly that value
already exists — but it is named `surfaceTabChrome`** (`0xFF2E3236`, minted for
item 2.4's tab bar). So the value is right and the name is wrong for this use.
Either the toast reuses a token named for the tab bar, or a semantic alias is
minted. Worth raising rather than silently reusing — a component reading
`surfaceTabChrome` for a toast is the kind of thing that reads as a mistake later.

### §3.4's Item level has a positional dependency

"a wordless corner alert badge **in the same slot as the indigo library tick**" —
`lib/widgets/library_tick.dart` exists (promoted to an app-wide primitive during
item 2.1). The Item-level badge must share its slot, so `LibraryTick` is the
positional reference and probably wants reading side by side.

### Grain — a live question the checklist itself raises

The bullet asks the Tech Lead to confirm whether three sub-components in one item is
the right grain, or whether they should be separate runs. That question is real and
should reach the human at a gate. With three sub-components, this is also the
strongest candidate yet for a module folder — though note 2.5 and 2.6 both
deliberately shipped flat files, so it is a judgement, not a default.

## Phase 3 gate outcome (human, 2026-08-24)

**APPROVED as written**, no delta. `lib/widgets/error_states/` (5 files), ships
unwired, `surfaceToast` alias added, `detail_screenshot_section.dart` deleted.

Two sub-questions were put alongside the gate and resolved by accepting the design
as designed:
- **`DestructiveActionPair` reuses `PrimaryButton`**, and its green focus ring
  (from `ButtonPressScale`) stands. The green *fill* default at
  `primary_button.dart:29` is provably unreachable here because both fills are
  passed explicitly. The green *ring* is pre-existing, app-wide behaviour that 2.7
  does not introduce, and the alternative — a private button in the module — would
  duplicate the anatomy and drop focus rings entirely, widening the known
  `ButtonPressScale`/`ActivateIntent` accessibility gap.
- **The safe action keeps its `ink08` fill** rather than a bare text label. It still
  reads as subordinate to a solid `errorStrong` button, and it keeps a consistent
  44px hit target with a visible boundary — which matters when the loud option is
  destructive.

### `MaterialLocalizations` vs `context.l10n` — asked at the gate, settled

The human asked why the strip's close-button label uses
`MaterialLocalizations.closeButtonTooltip` rather than a `context.l10n` extension.
**`context.l10n` does not exist in this project** — `ContextExtensions on
BuildContext` (`lib/core/utils/extensions.dart:7`) provides only `themeData`,
`tokens`, `screenHeight`, `screenWidth` and `bottomPadding`, and there are zero
`context.l10n` usages. App strings come from the static **`S.current`** (172
usages, generated by `intl_utils`).

So the real choice was `S.current` vs `MaterialLocalizations`, and the division is
the right one: `S.current` carries **app** copy; `MaterialLocalizations` carries
**framework-generic affordances** already translated into every locale Flutter
ships. An app-owned "Close" string would need a new `.arb` key, an `intl_utils`
regeneration step, and would be English-only until translated. Precedent:
`bottom_tab_bar_cell.dart:34`, shipped in item 2.4.

Noted and **deliberately not filed as a follow-up** at the human's instruction:
`S.current` (static) does not rebuild on a locale change where `S.of(context)`
would. Pre-existing across 172 call sites; left exactly as it is.

## Escalation history
2026-08-24 Phase 1 — BA Agent — Three CRITICALs: grain (one run or several), whether 2.7 owns
the existing error surfaces (which decides if it can ship unwired at all), and which token
carries the toast fill. `tech-ac.md` deliberately not written. — Resolved 2026-08-24: human
answered all three at a gate, plus a fourth on dead-code scope. BA re-spawned;
`escalation.md` deleted.

## Gate decisions (human, 2026-08-24, resolving the BA escalation)

- **CRITICAL-2 — blast radius: option A, pure extraction.** New Action / Screen / Item
  components built beside the incumbents. `ErrorRetryWidget` and `DefaultSnackbar` are
  **not** reworked, replaced or rewired. The item ships genuinely **unwired**. The
  decisive argument is the BA's own: **§3.4 does not spec a per-section retry block at
  all** — `ErrorRetryWidget`'s anatomy comes from §3.2's *Async states* row — so
  replacing it would mean designing a surface no document describes.
  Accepted cost, recorded honestly: two error vocabularies coexist, four error call
  sites stay off-spec, and nothing exercises the new components (2.2's unwired ring
  left 10 manual checks still unperformable for want of a caller).
- **CRITICAL-1 — grain: option A, one run covering all three levels.** Coherent
  precisely *because* the blast-radius answer is uniform: pure extraction applies to
  every level, so the run ships unwired as a whole. The three levels also share tokens
  and probably a red-dot/badge primitive, which one run builds once.
- **CRITICAL-3 — toast token: mint a semantic alias.** `#2e3236` already exists as
  `surfaceTabChrome` (minted for 2.4's tab bar). A toast reading `surfaceTabChrome`
  would read as a bug later, so a second, semantically-named token carries the same
  value. **This is a foundations-file edit** — the first a component run has been
  allowed; every prior run stayed out (cf. the standing 15px gap). Scope it to adding
  the alias; do not rename or remove `surfaceTabChrome`, which the shipped tab bar
  depends on.
- **Dead code: remove the dead `ErrorRetryWidget` usage only.** In scope:
  **delete `lib/features/game_detail/presentation/screens/detail_screenshot_section.dart`
  entirely**, and the commented reference at `game_detail_screen.dart:73`.

### Why that file is genuinely dead — traced, not assumed

`detail_screenshot_section.dart` is 66 lines of which **54 are commented out**; the live
widget body is `return SizedBox.shrink()`, so it renders nothing. Its **only** reference
anywhere is itself commented out (`game_detail_screen.dart:73`). It is unreachable code
wrapping a widget that draws nothing. Deleting it also removes both phantom
`ErrorRetryWidget` "callers" (`:22` and `:52`) that this item's recon tripped over — so
the next caller-grep sees 5 real call sites, not 7.

**Explicitly NOT in scope** (human decision — deliberately left, not missed):
`GameScreenshotCubit` is orphaned once that file goes (its only references are inside the
commented block), and `game_screenshot_entity.dart`, `screenshot.dart` and
`screenshot_response_model.dart` form a dormant chain behind it. `ImageRouteView` stays
registered in `auto_route_config.dart:39` with nothing pushing to it. **`GameScreenshot`
(`lib/widgets/game_screenshot.dart`) is LIVE** — `image_page_view.dart:32` uses it — so
it must not be touched. Deleting the rest would turn a component item into a feature
removal, and may delete work intended for restoration. Record as a follow-up.

### Three BA findings that reshape the item — worth keeping even if the run is re-scoped

1. **One of `ErrorRetryWidget`'s five callers is not an error.**
   `games_screen.dart:88` renders it for `GamesStatus.empty` with `no_results_found` — an
   **empty** state, which is item **2.8**'s scope. So absorbing `ErrorRetryWidget` into 2.7
   either reaches into 2.8 or leaves the widget alive for one empty-state caller. 4 of 5
   callers are genuine errors.
2. **`DefaultSnackbar`'s single caller shows both outcomes through it** —
   `task_detail_screen.dart:70`: `RemoveStepSuccess` → "removed step", `RemoveStepFailed` →
   "remove step failed". §3.4's toast is error-only by construction (it carries a red dot) and
   §0.3/§2.1 ration red hard, so a straight swap would put a red dot on a success message.
   Replacing it needs the call site split, or a non-error toast variant no doc describes.
   (`DefaultSnackbar` is off-spec regardless: it fills `kColorScheme.primary` indigo, not
   `#2e3236`.)
3. **§3.4 does not spec a per-section retry block at all.** `ErrorRetryWidget`'s anatomy — a
   centred message plus retry inside a failed section — comes from §3.2's **Async states**
   row, not the Error states row. Replacing it means designing a surface no current doc
   describes. That is not a BA call, and it is a strong argument for leaving it alone in 2.7.

Two useful negatives, both grepped: **neither screen doc mentions errors**, so §3 is
uncontested for this item (no precedence conflict to resolve); and 14/500 sits inside §1.2's
"14–15" range, so **2.7 does NOT re-open the 15px collision** that 1.9, 2.2 and 2.5 each hit.

Also confirmed: §3.4's "never both a strip and a toast for the same failure" **has a checkable
form** in the 2.6 shape — a single required variant selector making "both" unrepresentable,
plus the absence of any parameter that could render the second surface. It need not be
manual-only.

## Deviation approvals
NONE

## Code review outcomes
NONE

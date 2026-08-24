# Technical Acceptance Criteria
Source: `system-foundation-specs.md` §3.2 "Error states" row (line 247) + §3.4 (lines 266–279),
with §2.1 (error ramp), §3.3 (error field/action/screen/item row), §1.2 (type ramp), §5
(accessibility); `week-2-task-briefs.md` item 2.7. Gate decisions of 2026-08-24 recorded in
`orchestrator-state.md` bind scope.
Date: 2026-08-24
BA Agent version: 1.0

## Feature summary

Build three new error-state components — Action, Screen and Item — as **pure extraction**: new
files beside the existing error surfaces, none of which are reworked, replaced or rewired. The
run ships **unwired**; no existing screen changes appearance. One foundations edit is permitted
and tightly scoped: a semantically named colour token carrying `0xFF2E3236` for the Screen-level
toast surface, added alongside `surfaceTabChrome`, which keeps its name, value and callers. One
dead file is deleted (`detail_screenshot_section.dart`) together with its single commented-out
reference; nothing else in the dormant screenshot chain is touched. The Field level is out of
scope — it shipped with item 2.5 and 2.7 inherits it unchanged.

## Technical acceptance criteria

### Foundations — the toast surface token

[2.7-AC1] THEME TOKENS: `lib/config/theme/tokens/app_color_tokens.dart` gains exactly one new
colour field holding `0xFF2E3236`, named for the toast/overlay surface it serves rather than for
the tab bar. It is wired through the constructor, the `dark` instance, `copyWith` and `lerp` in
the same way as every existing field.
  Failure case: if the field is missing from any of those four places the run fails; the toast
  must not fall back to a literal hex nor to `surfaceTabChrome`.

[2.7-AC2] THEME TOKENS: `surfaceTabChrome` keeps its name, its `0xFF2E3236` value and every
existing reference to it. No rename, no removal, no redirection of the tab bar to the new token.
  Failure case: any diff hunk that renames or deletes `surfaceTabChrome`, or changes a tab-bar
  file, fails this criterion — the shipped tab bar depends on it.

[2.7-AC3] THEME TOKENS: a unit test asserts the new token's value is `0xFF2E3236` and that
`surfaceTabChrome` still resolves to `0xFF2E3236`. Both assertions name their token.
  Failure case: an assertion that couples the two (e.g. requiring they stay equal forever) is
  wrong — they are independent names that happen to share a value today.

[2.7-AC4] THEME TOKENS: no other foundations file is modified. `app_type_tokens.dart`,
`app_radius_tokens.dart`, `app_status_tokens.dart` and the theme wiring are untouched.
  Failure case: a new type step (see the 15px note under Out of scope) or a new radius introduced
  here fails the criterion — the run's foundations allowance covers the colour alias only.

### Action level — destructive confirmation (§3.4 "Action")

[2.7-AC5] WIDGET (Action): the component renders two actions side by side — a destructive action
whose fill is the `errorStrong` token, and a safe action beside it that carries no fill from the
error ramp. Colour assertions name the token.
  Failure case: the destructive fill resolving to `error` rather than `errorStrong` fails — §2.1
  reserves `errorStrong` for solid fills precisely so white label text clears AA.

[2.7-AC6] WIDGET (Action): the safe action carries no green in any form — not as fill, label or
border.
  Failure case: any use of the `green` token in this component fails; §2.1 rule 1 states green
  never appears in a destructive confirm.

[2.7-AC7] WIDGET (Action): both labels are caller-supplied `String` parameters. The component
hardcodes no user-visible English and owns no localisation key.
  Failure case: a default label value baked into the constructor fails, even a "safe" one like
  "Cancel".

[2.7-AC8] WIDGET (Action): tapping the destructive action invokes its callback exactly once;
tapping the safe action invokes its own callback exactly once. Neither invokes the other.
  Failure case: a shared callback, or a callback fired on build, fails.

[2.7-AC9] WIDGET (Action): the constructor exposes no parameter, enum value or named constructor
for an outline-in-error-ink variant. That variant is not built (see Assumptions).
  Verified by: API-surface check on the constructor parameter list, never a widget test.
  Failure case: an unused variant selector present in the API fails — the "no parameter nothing
  calls" rule that dropped `suffixIcon` in item 2.5.

[2.7-AC10] WIDGET (Action): both actions meet the 44px minimum hit target (§5), and the
destructive action reads as the loud one while the safe action reads as plain ink (§3.4).
  Verified by: code review / QA visual check, never a widget test.
  Failure case: QA finds the safe action styled with comparable weight to the destructive one.

### Screen level — strip or toast (§3.4 "Screen")

[2.7-AC11] WIDGET (Screen): the component takes a **single required variant selector** with
exactly two values — strip and toast. There is no default, no nullable variant, and no parameter
that could cause the other surface to render alongside the selected one.
  Verified by: API-surface check on the constructor parameter list, never a widget test.
  Failure case: an optional or defaulted selector fails; so does any additional boolean that
  turns the second surface on. §3.4's "never both for the same failure" is satisfied by being
  unrepresentable, in the shape item 2.6 used for its hairline guarantee.

[2.7-AC12] WIDGET (Screen): a widget test per variant asserts that the selected surface is in the
tree and the other is absent — strip present / toast absent, and the reverse.
  Failure case: both present in one build, or a variant that renders nothing, fails.

[2.7-AC13] WIDGET (Screen, strip): the strip's fill is the `errorTint` token, its hairline is the
`errorLine` token, and its message renders in the `errorInk` token. All three assertions name
their token.
  Failure case: a literal `rgba(248,68,60,…)` or a `Colors.red` anywhere in the component fails.

[2.7-AC14] WIDGET (Screen, strip): the strip exposes a dismiss affordance. Activating it invokes
the caller's dismiss callback exactly once and removes the strip from the tree. The component
stores no dismissal state: rebuilding it with the same inputs renders the strip again.
  Failure case: a component-held `_dismissed` flag that suppresses a later failure fails — §3.4
  says dismissable, not "dismissed once, gone".

[2.7-AC15] WIDGET (Screen, toast): the toast's surface fill is the new token from [2.7-AC1],
asserted by token name.
  Failure case: reading `surfaceTabChrome` or a literal hex fails.

[2.7-AC16] WIDGET (Screen, toast): the toast carries a **dot, not an icon** — a circular element
filled with the `error` token — and the component contains no `Icon` descendant in the toast
variant.
  Failure case: any icon widget in the toast variant fails; §3.4 chose a dot specifically so the
  toast stays one line at 390px.

[2.7-AC17] WIDGET (Screen, toast): the toast's message is constrained to a single line with
overflow handling, so long caller copy truncates rather than wrapping.
  Failure case: unconstrained text that wraps to a second line fails. Assert the line constraint
  on the text widget, not any rendered width or height.

[2.7-AC18] WIDGET (Screen): the toast introduces no new display-duration value. Its dismissal
timing matches the app's existing snackbar behaviour rather than a number minted here.
  Verified by: code review, never a widget test.
  Failure case: a hardcoded `Duration(seconds: n)` inside the component fails.

[2.7-AC19] WIDGET (Screen): both variants are caller-supplied copy only, per [2.7-AC7]'s rule.
Neither hardcodes English nor owns a localisation key.
  Failure case: a default message baked into either variant fails.

[2.7-AC20] WIDGET (Screen): neither variant is a full-page layout and neither exposes a parameter
that hides, replaces or blocks page content — §3.4's "data already loaded keeps rendering
underneath" holds because the component has no way to remove it.
  Verified by: API-surface check on the constructor parameter list, never a widget test.
  Failure case: a `child`/`content` parameter that the component conditionally swaps out fails.

### Item level — failed row or card (§3.4 "Item")

[2.7-AC21] WIDGET (Item): the component wraps a caller-supplied child and applies the failed
treatment to it: the child's own content is dimmed to 55% **opacity** (not recoloured to the
`ink55` token), a hairline in the `errorLine` token is drawn around it, and a corner badge is
overlaid.
  Failure case: recolouring the child's text instead of dimming fails — a colour token cannot dim
  cover artwork, which is what §3.4 asks for.

[2.7-AC22] WIDGET (Item): a widget test asserts the child is wrapped in an opacity of `0.55`, and
that the hairline colour resolves to the `errorLine` token. The colour assertion names the token.
  Failure case: asserting the hairline's width, the badge's size, or any offset fails the
  project's testing constraints — dimensions and positions are never asserted.

[2.7-AC23] WIDGET (Item): the badge is **wordless** — the component renders no `Text` widget and
accepts no label string for the badge.
  Failure case: any text inside the badge fails; §3.4 is explicit that no label fits a 64px cover.

[2.7-AC24] WIDGET (Item): the badge carries a semantics label so the failure is announced to
assistive technology. §5 exempts only the tab bar and circular icon buttons from label pairing,
so this is required, not optional. A widget test asserts the semantics label is present.
  Failure case: a badge with no semantics node fails. The label's wording follows [2.7-AC7] —
  caller-supplied, or drawn from the existing localisation path, never hardcoded English.

[2.7-AC25] WIDGET (Item): the badge's fill is the `error` token — the signal red of §2.1, not
`errorStrong`. Asserted by token name.
  Failure case: `errorStrong`, magenta or a literal hex fails. §2.1 rule 2: magenta means
  progress and is never repurposed for errors.

[2.7-AC26] WIDGET (Item): the badge occupies the same corner slot as the indigo library tick, and
the dimmed item still reads as findable in a dense grid without reading any text.
  Verified by: code review / QA visual check, never a widget test.
  Failure case: QA finds the badge in a different corner from the library tick, or the two
  overlapping illegibly when an item is both in-library and failed.

[2.7-AC27] WIDGET (Item): the component exposes no "not failed" or pass-through mode — no
`isFailed` boolean. A caller whose item has not failed simply does not wrap it.
  Verified by: API-surface check on the constructor parameter list, never a widget test.
  Failure case: a toggle that renders the child untouched fails the "no parameter nothing calls"
  rule.

### Repository hygiene — the one dead file

[2.7-AC28] REPO: `lib/features/game_detail/presentation/screens/detail_screenshot_section.dart`
is deleted in full, and the commented-out reference to it at `game_detail_screen.dart:73` is
removed.
  Failure case: emptying the file, or leaving the class as a stub, fails — the criterion is
  deletion. Leaving the commented reference behind fails too; it is the file's only reference
  anywhere, and its removal is what makes the deletion safe.

[2.7-AC29] REPO: the deletion changes no rendered output. The deleted widget's live body was
`return SizedBox.shrink()` and its only call site was commented out, so `game_detail_screen`
renders exactly what it rendered before. The live "Screenshots" heading above the removed
comment stays — it is untouched by this run even though it now heads an empty section.
  Verified by: code review / QA visual check on game detail, never a widget test.
  Failure case: removing the heading, its padding, or any live widget from `game_detail_screen`
  fails — that would be a shipped-surface change this run is not permitted.

[2.7-AC30] REPO: the following are **not** touched by this run, in any way, including
"tidying" imports or removing now-unused code that the deletion orphans:
  - `GameScreenshotCubit` and its state/DI registration
  - `game_screenshot_entity.dart`, `screenshot.dart`, `screenshot_response_model.dart`
  - `ImageRouteView`'s route registration in `auto_route_config.dart`
  - **`lib/widgets/game_screenshot.dart` — this file is LIVE**; `image_page_view.dart:32` uses it
  - `lib/widgets/error_retry_widget.dart` and `lib/widgets/default_snackbar.dart`
  Failure case: deleting any of the above fails the criterion. The dead-code trail continues past
  the one file in scope, and following it turns a component item into a feature removal; the
  human decision of 2026-08-24 deliberately stops at one file. `game_screenshot.dart` in
  particular looks dead from the deleted file's commented block and is not.

[2.7-AC31] REPO: after the deletion, `flutter analyze` shows no new error, warning or info
against the recorded baseline of 0 errors / 2 warnings / 31 info.
  Failure case: a new "unused import" or "unused element" arising from the deletion is in scope
  to fix inside the allowlist. A pre-existing one is not.

### Run-level guarantees

[2.7-AC32] REPO: the run ships **unwired**. No existing file gains a reference to any of the
three new components. The only non-new files modified are `app_color_tokens.dart` (the alias),
`game_detail_screen.dart` (the commented line), plus the single deletion.
  Verified by: diff review against the base SHA, never a widget test.
  Failure case: any call site added to `games_screen.dart`, `task_detail_screen.dart`,
  `detail_top_header.dart` or `detail_mid_section.dart` fails — wiring is explicitly not in this
  run.

[2.7-AC33] WIDGET (all three levels): every colour in the three new components resolves through a
token. No literal hex, no `Colors.*` constant, no `withOpacity` on a raw colour to fake a token.
  Failure case: any literal colour value in the new files fails. §2 rule 7 requires every literal
  to be logged as a local addition, and this run mints exactly one token — the [2.7-AC1] alias.

[2.7-AC34] WIDGET (all three levels): body copy across all three levels uses the existing 14/500
body-500 step. No new type token is created.
  Verified by: code review, never a widget test.
  Failure case: a hardcoded `fontSize:` in any new component fails. See the 15px note under Out
  of scope — this item does not re-open that collision.

[2.7-AC35] TESTS: no golden test is written for any criterion in this document, whatever a
criterion says about appearance. No test asserts a dimension, gap, radius or position. Every
colour assertion names the token it expects and exists to prove a meaning, not to pin a pixel.
  Failure case: a `matchesGoldenFile` anywhere in the run fails outright. A colour assertion
  written as a raw `Color(0x…)` comparison fails; assert against the token.

## Out of scope

- **The Field level.** §3.4 describes four levels; the field level shipped with item 2.5
  (tinted fill + 1px error hairline on the labelled text field) and 2.7 inherits it unchanged.
  No criterion here covers it, and §3.4's field bullet is not a requirement for this run.
- **`ErrorRetryWidget`** — not reworked, replaced, rewired or deleted. Its five call sites stay as
  they are. §3.4 does not spec a per-section retry block at all (that anatomy comes from §3.2's
  *Async states* row), so replacing it would mean designing a surface no document describes.
- **`DefaultSnackbar`** — not reworked, replaced or rewired, and its indigo fill stays off-spec
  for now. Its one call site shows both a success and a failure through it, so a swap for an
  error-only toast would put a red dot on a success message.
- **`games_screen.dart:88`** — renders `ErrorRetryWidget` for `GamesStatus.empty`. That is an
  empty state and belongs to item 2.8.
- **`task_detail_screen.dart:70`** — the success/failure snackbar call site. Untouched.
- **Wiring the three new components to anything.** Consequence, recorded honestly: two error
  vocabularies coexist after this run, four error call sites stay off-spec, and nothing exercises
  the new components — QA's checks on them are component-level only, as with item 2.2's unwired
  completion ring.
- **The rest of the screenshot chain** — see [2.7-AC30]. Follow-up debt, not this run.
- **`library_stats.dart`'s dashed-border violation** — belongs to item 2.8.
- **The 15px type collision.** §1.2 gives "Row label / button 14–15 / 500" as a range and the
  shipped primary button already uses 14/500, so 14 is inside spec here and no new token is
  needed. This item does not become the fourth instance of that standing foundations gap.
- **Screen-doc precedence.** Neither `game-detail-design-conventions.md` nor
  `home-screen-design-conventions.md` mentions errors, retry, toasts or strips — grepped. §3.4 is
  uncontested for the two features that host the existing error surfaces, so there is no
  precedence conflict to resolve in this run.
- **Whether the three components live in a module folder or as flat files** — a Tech Lead call,
  not a criterion. Items 2.5 and 2.6 both shipped flat deliberately.

## Assumptions

ASSUMPTION: §3.4's Action level names an outline-in-error-ink variant "reserved for the rarer,
heavier destruction (account deletion)". No account-deletion flow exists and there would be no
caller, so only the solid destructive-fill variant is built — the "no parameter nothing calls"
rule that dropped `suffixIcon` in item 2.5. Cheap to overrule at the design gate. See [2.7-AC9].

ASSUMPTION: no copy is specified for any level and §4 forbids a corporate register but supplies
no strings. Every user-visible string is caller-supplied; no component hardcodes English, and
anything a component owns internally goes through the existing localisation path. See [2.7-AC7],
[2.7-AC19], [2.7-AC24].

ASSUMPTION: §3.4's toast has no stated duration. The app's existing snackbar sets none and
inherits the framework default; the toast does the same rather than minting a number.
See [2.7-AC18].

ASSUMPTION: §3.4 calls the strip "dismissable" without defining dismissal. Dismissal removes the
strip for that failure only — no persistence, no suppression of a later failure. Re-showing is
the caller's decision, not the component's. See [2.7-AC14].

ASSUMPTION: §3.4's Item level says the failed row or card "dims to 55%". That is 55% opacity on
the item's own content, not a recolour of its text to the `ink55` token — §3.4 describes a dim,
and a colour token cannot dim cover artwork. See [2.7-AC21].

ASSUMPTION: no type step is specified for any of the three levels. §1.2's "Row label / button
14–15 / 500" is a range and the shipped primary button already uses 14/500, so 14/500 throughout.
See [2.7-AC34].

ASSUMPTION: §3.4's Item badge is explicitly wordless and sits "in the same slot as the indigo
library tick", so the library tick is the positional reference. The badge carries no text in any
form and its accessibility affordance is a semantics label. See [2.7-AC23], [2.7-AC24],
[2.7-AC26].

ASSUMPTION: §3.4 does not state the toast's text colour. The red dot carries the signal and §2.1
rations red hard, so the toast message renders in the `ink` token on the `#2e3236` surface rather
than in `errorInk`. The strip, which has no dot, keeps `errorInk` per §3.3. Overrule at the
design gate if the toast should carry error ink instead.

ASSUMPTION: the `/// TODO: fetch screenshots - from game detail` comment sitting immediately above
`game_detail_screen.dart:73` is removed together with the commented reference it annotates, since
it would otherwise dangle above nothing. It refers only to the deleted section.

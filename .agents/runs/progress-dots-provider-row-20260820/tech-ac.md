# Technical Acceptance Criteria
Source: Week 2 task briefs items 1.8, 1.9 (combined run) · `system-foundation-specs.md` §3.3
("Progress dots", "Provider / list row") · `onboarding-auth-design-spec.md` §5 · `flutter-arch.md`
promotion rule · build conventions from the `flutter-widgets` skill
Date: 2026-08-20
BA Agent version: 1.0

## Feature summary

Two independent Stage 1 promotions in one run. Neither is a new design: both components already
render on a live screen and both are moved, unchanged in appearance, out of a feature folder into
`lib/widgets/` with a generic app-wide API. **1.8** extracts the two hardcoded progress dots that
`welcome_container.dart` builds inline into a reusable widget driven by a caller-supplied dot count
and active index; the welcome container becomes its first caller. **1.9** extracts the auth screen's
private `_ProviderActionButton` `part` class into an app-wide row — full width, 52px, `sm` radius,
caller-supplied fill, 20px leading mark slot, centred label — and the two sign-in rows become its
first callers. Both are stateless presentation widgets: no new state, no repository, no persistence,
no network call, no new localisation key, no new dependency, no new screen. **The governing rule for
both is that nothing visible changes.** What the welcome pages and the sign-in screen render after
this run is pixel-identical to what they render before it; the only behaviour that moves is where
the code lives and how it is parameterised. One known gap between the shipped sign-in row and §3.3
(label size and weight) is deliberately *not* corrected here — see "Out of scope" and
`ambiguities.md`.

Criterion IDs are namespaced per item. `ALL-ACn` covers the standing rules that apply identically to
both components; they are not a third component.

## Technical acceptance criteria

### 1.8 — Progress dots

[1.8-AC1] PRESENTATION: A progress-dots widget exists in `lib/widgets/`, in one file, named
categorically for what it is, with no `default` prefix, a `const` constructor, and a name that
collides with nothing in Flutter's own library — no call site and no part of its own file needs an
import alias, `hide`, or a `package:flutter/material.dart` qualification. File and class names agree.
Any helper it needs is a private class in the same file.
  Failure case: the widget left in the onboarding feature folder, a `default` prefix, a name forcing
  an import alias anywhere, or a Widget-returning function or getter instead of a widget class.

[1.8-AC2] PRESENTATION: The widget's API is a total dot count and which index is active, both
supplied by the caller. The file contains nothing onboarding-specific: no import of the onboarding
feature, no reference to `WelcomeStep` or any other feature enum, no default of 2, and no assumption
anywhere that the count is 2.
  Failure case: `WelcomeStep` (or any feature type) appearing in the widget's signature or file, a
  count defaulted or hardcoded to 2, or a parameter named for the welcome flow.

[1.8-AC3] PRESENTATION: The widget renders exactly `count` dots in a single horizontal row in index
order, with exactly one dot — the one at the active index — drawn in the active form and every other
dot in the inactive form.
  Failure case: a dot count that does not match the parameter, two dots drawn active, no dot active,
  or the active dot at the wrong position.

[1.8-AC4] PRESENTATION: The active dot is 22 logical pixels wide and 5 tall; every inactive dot is
5×5. Every dot uses the `pill` radius token. Adjacent dots are separated by a 6px gap, with no gap
before the first dot and none after the last. None of these four values is a constructor parameter.
  Failure case: dots rounded to even dimensions (6×6 / 22×6), a literal radius instead of the token,
  a gap that is not 6px, leading or trailing gap inside the row, or any of these exposed as a
  parameter. The 5px dimension is a recorded exception to the even-dimension convention — see
  "Assumptions".

[1.8-AC5] PRESENTATION: The active dot's fill is the `ink` token; every inactive dot's fill is the
`ink12` token.
  Failure case: an inactive dot at `ink08`/`ink24`, an active dot below full ink, or either colour
  resolved from `Theme.of(context)`/`ColorScheme` rather than the app's colour tokens.

[1.8-AC6] PRESENTATION: The row sizes to its content — it never expands to fill the width offered and
never takes a fixed width. Its rendered height is 5 logical pixels. It applies no alignment,
positioning or transform of its own; where the row sits horizontally is entirely its parent's
decision.
  Failure case: a row stretching to the parent's width, an `Expanded`/`double.infinity` width, a
  `Center`/`Align`/`Padding` baked into the widget, or a height above 5px.

[1.8-AC7] PRESENTATION: The widget renders dots and nothing else — no step number, no `n of m`
fraction, no percentage, no progress bar, line or track behind the dots, no label, no icon. It holds
no user-facing string.
  Failure case: any text or bar in the widget's tree, or a numeric progress readout.

[1.8-AC8] PRESENTATION: The widget is display-only: no tap or gesture callback, no ink ripple, no
press, hover or focus treatment, and no way for a caller to attach one through its API.
  Failure case: an `onTap`/`onDotPressed` parameter, a `GestureDetector`/`InkWell` in the tree, or a
  dot that responds visibly to touch.

[1.8-AC9] PRESENTATION: Changing the active index paints the new state on the next frame with no
tween, animation or implicit transition — a dot's width and colour change instantly, exactly as the
welcome screens behave today.
  Failure case: an `AnimatedContainer`, `AnimatedSwitcher`, `TweenAnimationBuilder` or `Duration`
  anywhere in the widget.

[1.8-AC10] PRESENTATION: A count below 1, or an active index outside `0..count-1`, fails loudly in
debug builds rather than rendering an undefined row.
  Failure case: an out-of-range index rendering all-inactive dots silently, a zero-dot row, a range
  error thrown at paint time in release, or the limit enforced only by a comment.

[1.8-AC11] PRESENTATION: `welcome_container.dart`'s inline two-`Container` dot row is deleted and
replaced by one use of the extracted widget, given a count of 2 and an active index derived from the
container's existing `step` input (first step → index 0, second → index 1). Nothing else in that file
changes: the hero height and short-screen shortfall calculation, the scroll view and its paddings,
the 22px/18px gap between the dots and the headline, and the headline, body and actions all stay
exactly as they are. `WelcomeStep` stays in the onboarding feature and `WelcomeContainer` keeps
taking it.
  Failure case: the inline dots left in place beside the new widget, the step-to-index mapping
  inverted, a spacing value in that file changed, `WelcomeStep` moved or widened, or the file
  otherwise refactored in this run.

[1.8-AC12] PRESENTATION: Both welcome pages render exactly as before the run — page one shows a
22-wide active dot then a 5-wide inactive dot, page two shows a 5-wide inactive dot then a 22-wide
active dot, in the same position, at the same left alignment, with the same 6px gap between them and
the same gap to the headline below. Swiping between pages, including a partial drag, updates the dots
as it does today.
  Failure case: any visible change to either welcome page, dots that stop tracking the page during a
  drag, or dot order reversed.

### 1.9 — Provider / list row

[1.9-AC1] PRESENTATION: A row widget exists in `lib/widgets/`, in one file, named categorically, with
no `default` prefix, a `const` constructor, no name collision requiring an import alias anywhere, and
file and class names in agreement. `lib/features/auth/presentation/widgets/provider_action_button.dart`
and its private `_ProviderActionButton` class are gone at the end of the run, and `auth_screen.dart`
no longer declares that `part`.
  Failure case: the private class kept beside the promoted one, an orphaned `part` directive, a
  `@Deprecated` shim with no caller, or two widgets drawing the same row.

[1.9-AC2] PRESENTATION: Everything that differs between callers is a constructor parameter: the
label, the leading mark, the fill colour, whether the row is enabled, whether it is showing a busy
indicator and that indicator's accessible label, and the tap callback. The file contains nothing
sign-in specific — no `SignInProvider`, no auth cubit or state type, no `S.current` lookup, no
hardcoded provider name or asset path.
  Failure case: an auth type or localisation lookup inside the widget file, a provider-specific
  branch, or a value that one of the two live callers needs being hardcoded.

[1.9-AC3] PRESENTATION: The row occupies the full width its parent offers and is exactly 52 logical
pixels tall. Its shape is the `sm` radius token and its surface is the caller's fill drawn as one
flat colour — no gradient, border, outline, shadow or elevation.
  Failure case: a height other than 52, an intrinsic or fixed width, a hardcoded fill, a `sm` radius
  replaced by a literal, or any border/shadow added.

[1.9-AC4] PRESENTATION: The leading mark slot is 20×20 logical pixels and is required — every row has
one. The mark and the label are centred together as a group with a 10px gap between them, so the pair
reads optically centred; the label is not centred independently with the mark pushed to the edge.
Neither the slot size nor the gap is a constructor parameter.
  Failure case: a mark at 16px or 24px, an iconless variant with no caller, the mark left-aligned
  against the row's edge, or a size/gap parameter on the constructor.

[1.9-AC5] PRESENTATION: The label renders through the app's `body` type token (16px, weight 400) —
the same treatment the sign-in rows render today — with its colour resolved explicitly from the `ink`
token rather than inherited from an ambient default text style, so the row renders identically
wherever it is placed. It renders on one line, truncated with an ellipsis if the row is too narrow.
  Failure case: a locally declared `TextStyle`, font family or weight; a label whose colour changes
  with its surroundings; a wrapped label; or an overflow error in a narrow parent. §3.3's 15px/500 is
  deliberately not applied in this run — see "Out of scope".

[1.9-AC6] PRESENTATION: The row's tappable region is at least 44 logical pixels tall and the drawn row
stays exactly 52px — the hit target is met by the row's own height, not by padding that grows it.
  Failure case: a drawn row taller than 52px, or a hit region smaller than the drawn row.

[1.9-AC7] PRESENTATION: When enabled, tapping anywhere on the row fires its callback exactly once per
tap, including on the fill between the mark and the label. When disabled, a tap fires nothing and the
row's appearance is unchanged — no dimming, no opacity change, no colour shift, matching today.
  Failure case: a tap that fires twice or only on the label's glyphs, a disabled row that still fires,
  or a disabled row that changes appearance.

[1.9-AC8] PRESENTATION: While busy, a 16px circular indicator with a 2px stroke renders after the
label with a 10px gap, carrying the caller-supplied accessible label. While not busy, no indicator
exists in the tree. The busy state changes neither the row's height nor its fill, and the label stays
visible throughout.
  Failure case: an indicator present when not busy, an indicator replacing the label, a row that
  resizes when the indicator appears, or a hardcoded loading string inside the widget.

[1.9-AC9] PRESENTATION: Press and focus feedback is preserved exactly as the sign-in rows behave
today: pressing scales the row down and releases it on tap-up or cancel, keyboard focus draws the
app's green focus ring, and the press animation respects the device's reduced-motion setting.
  Failure case: press feedback lost in the move, a scale value or duration hardcoded inside the row,
  or an animation that ignores reduced motion.

[1.9-AC10] PRESENTATION: The row exposes itself to accessibility as a single button node reporting its
enabled state, as it does today. No new announcement is introduced by the promotion.
  Failure case: the button semantics dropped in the move, the enabled flag no longer reflected, or a
  second competing node introduced.

[1.9-AC11] PRESENTATION: `auth_screen.dart`'s two rows use the promoted widget with everything
unchanged: Discord first with the indigo primary fill and `assets/icons/discord-logo.png`, Google
second with the `surfaceRaised` fill and `assets/icons/google-logo.png`, both marks at 20px, both
labels the existing localised `Continue with …` strings, and the 10px gap between the two rows still
owned by the screen's column rather than the widget.
  Failure case: row order swapped, a fill or mark changed, a label string changed or relocalised, or
  the 10px gap absorbed into the widget.

[1.9-AC12] PRESENTATION: Sign-in behaviour on the auth screen is unchanged. Tapping either row starts
that provider's sign-in; while a sign-in is in flight both rows ignore taps and only the active
provider's row shows the busy indicator; a failure still renders the existing inline error below the
rows and both rows remain tappable for a retry.
  Failure case: a row still actionable during sign-in, both rows showing an indicator, the inline
  error no longer appearing, or a retry that no longer works.

### ALL — standing rules, applied identically to 1.8 and 1.9

[ALL-AC1] PRESENTATION: Neither widget adds spacing of its own. No outer padding, margin or spacer
around its content, and no `EdgeInsets`, `padding`, `margin`, `gap` or spacing constructor parameter
on either. Each renders flush inside the bounds its parent gives it. The gap *between* dots
([1.8-AC4]) and the gaps inside the row's own surface ([1.9-AC4], [1.9-AC8]) are those components'
anatomy and are unaffected by this rule.
  Failure case: outer padding or margin baked into either widget, a spacing parameter on either
  constructor, or a caller's column spacing absorbed into a component.

[ALL-AC2] PRESENTATION: Every colour, radius, type style and motion value in both components comes
from the app's design tokens, read through the project's context extension — never
`Theme.of(context)`, never `ColorScheme`, never a `Colors.*` or hex/`rgba` literal, never a locally
declared font family, weight or duration. The only literals permitted are the dimensions this
document states explicitly.
  Failure case: a direct `Theme.of(context)` call, a colour literal, a `GoogleFonts.*` call inside a
  component file, or a token value re-declared locally.

[ALL-AC3] PRESENTATION: Neither component draws a dashed or dotted edge and neither custom-paints
anything. As specified, neither draws a border at all — every surface is a fill.
  Failure case: a `CustomPainter`/`CustomPaint` in either file, a dash constant, or a decorative
  border added where the spec gives a fill.

[ALL-AC4] PRESENTATION: This run makes no visual change to any screen. The two welcome pages and the
sign-in screen render the same sizes, colours, positions, spacing and states after the run as before
it. Any visual difference is a defect, not an improvement, regardless of what §3.3 says.
  Failure case: any deliberate restyling of a migrated call site, including "while I was in there"
  corrections to type, colour or spacing.

[ALL-AC5] LOCALISATION: No new localisation key is added and neither component contains a user-facing
string — labels and accessible labels are supplied by the caller. `intl_en.arb`, `intl_zh.arb` and
the generated `S` class are untouched.
  Failure case: a hardcoded caption in either widget, a new `.arb` key, or a regenerated `S` class in
  the diff.

[ALL-AC6] BUILD: No new third-party dependency is added. `pubspec.yaml` stays read-only, and
`flutter analyze` reports nothing new against the recorded baseline (0 errors, 2 warnings, 31 info).
  Failure case: a package added without a recorded deviation approval, or a new analyzer error or
  warning attributable to this run.

[ALL-AC7] DOCS: The `flutter-widgets` skill's reusable-widget catalogue gains one row per component,
each describing what it actually is and noting that it adds no spacing of its own, matching the
existing `ZoneLabel`, `StatusChip`, `PlaceholderSlot`, `FilterCountChip`, `ContextChip` and
`StatPill` entries. No existing row is removed.
  Failure case: a component missing from the catalogue so the next agent rebuilds it, a row omitting
  the no-spacing note, or an unrelated catalogue row edited.

[ALL-AC8] TESTS: Each component gets its own widget test file covering, at widget-test level:
  · 1.8: the requested number of dots rendered; exactly one active dot, at the requested index; the
    active dot 22×5 and inactive dots 5×5; the `ink`/`ink12` fills; the 6px gap; the row hugging its
    content; no text and no tap handler in the tree; an out-of-range index failing in debug.
  · 1.9: the 52px height and full width; the `sm` radius and the caller's fill; the 20px mark and the
    label centred as a pair; one callback per tap when enabled and none when disabled; the indicator
    present only while busy; the label rendered on one line and ellipsised when narrow.
  The existing `test/widget/onboarding/welcome_screen_test.dart` and
  `test/widget/auth/auth_screen_test.dart` must still pass. The welcome test's dot-counting helper
  may be retargeted at the new widget if the extracted dots are no longer plain `Container`s, but its
  assertions must stay equivalent — one 22-wide dot and one 5-wide dot per page — and no existing test
  may be deleted, skipped or weakened. No golden test and no `matchesGoldenFile`, whatever the
  criteria above say about appearance.
  Failure case: a component shipped with no test file, a new test failure beyond the recorded
  baseline (`+259 -10`, with the three known pre-existing failing files), an existing assertion
  loosened to make the run pass, or a golden test added.

## Out of scope

- **Correcting the sign-in row's label to §3.3's `15px/500`.** The checklist calls the shipped row
  spec-exact, but it renders the `body` token (16px, weight 400) while both §3.3 and
  `onboarding-auth-design-spec.md` §5 specify `15px/500` in full ink. This run preserves what ships
  ([1.9-AC5], [ALL-AC4]) and flags the gap in `ambiguities.md`; correcting it is a visible change to
  a live screen and is the human's call at this gate, not a side effect of a promotion.
- **`_SignOutButton` in `lib/features/settings/presentation/widgets/sign_out_section.dart`.** A third
  hand-rolled instance of the same 52px / `sm` / `surfaceRaised` row anatomy, differing only in
  having no leading mark. Not named by item 1.9 and not migrated here; flagged in `ambiguities.md` so
  Tech Lead can schedule it rather than rediscover it.
- **An optional or absent leading mark slot, a trailing chevron or value, and the "list row" half of
  the primitive's name.** No current caller needs any of them, and the promotion rule forbids
  speculative parameters. They arrive with the first real list-row caller.
- **The reserved provider-mark placeholder** (`PlaceholderSlot`'s `providerMark` preset) as a
  fallback when no mark asset is supplied. Both live rows ship real marks.
- **The parked Apple row and any third provider** — `onboarding-auth-design-spec.md` §5a, v1 is
  Android-only.
- **Onboarding beyond the existing two steps** — no third welcome page, no `PageView` rewiring, no
  dot-tap navigation, no animated dot transition.
- **New design tokens**, including a `15/500` text token, which is tied to the flagged label gap.
- **Screen-reader work beyond preserving the semantics that exist today**, and any iOS or on-device
  verification.
- **Deleting or ticking `week-2-task-briefs.md` items** and any reference-doc edit other than the
  catalogue rows in [ALL-AC7].

## Assumptions

ASSUMPTION: A promotion preserves what renders. Where the shipped code and a spec value disagree, this
run keeps the shipped value and reports the gap, because the brief frames both items as extractions
with the existing screen becoming the first caller "rather than having its own behaviour rewritten".
This resolves both known collisions — the row's label type and the dots' odd dimensions — under one
rule.
ASSUMPTION: The dots stay 22×5 / 5×5 with a 6px gap, as an explicit exception to the standing
"dimensions are even numbers" convention. §3.3 states those values literally, the welcome screens
already ship them, an existing test asserts them, and the convention's own carve-out treats shipped
odd values as a follow-up rather than something to rewrite inside an unrelated run. Recorded so QA
does not read it as a skill violation.
ASSUMPTION: The dots' API is a count plus an active index, which is the narrowest generic form that
covers the one live caller; an active-step enum or a percentage would not be.
ASSUMPTION: The dots are display-only and unanimated, matching today's behaviour. Neither §3.3 nor
the welcome spec mentions interaction or a transition.
ASSUMPTION: The row's fill stays a required caller-supplied colour, since the two live rows need two
different values (indigo primary and `surfaceRaised`, the token for §3.3's `#2f333c`). Whether it
also carries a default is Tech Lead's call; the rendered fills are fixed by [1.9-AC11].
ASSUMPTION: The row's leading mark stays required, because both live callers supply one and an
iconless variant has no caller until `_SignOutButton` is migrated. If the human folds that migration
into this run, the slot becomes optional and [1.9-AC4] changes with it.
ASSUMPTION: The row's busy and enabled inputs stay part of the promoted API rather than being dropped
as sign-in specific — both are exercised by current callers, so neither is speculative. Whether busy
is a flag or a trailing slot is Tech Lead's call; the behaviour is fixed by [1.9-AC8].
ASSUMPTION: The label's colour is made explicit at the `ink` token during the move. Today it inherits
from the theme's default text style and resolves to the same colour, so this is a robustness fix with
no visual effect, not a restyle.
ASSUMPTION: Both components are named categorically without a `default` prefix, and neither name may
force an import alias at a call site. Exact names are Tech Lead's.
ASSUMPTION: Both call sites migrate in this run, so no `@Deprecated` alias is retained — nothing is
left pointing at an old API.
ASSUMPTION: No new localisation key, no new dependency, no generated output; `pubspec.yaml` is
read-only.

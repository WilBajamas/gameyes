# Technical Acceptance Criteria
Source: Week 2 task brief item 1.4 · `system-foundation-specs.md` §3.3 "Placeholder slot" (with §0.1, §1.2, §1.4, §1.9, §6, §7.2) · `onboarding-auth-design-spec.md` §3, §5, §8, §9, §10 · build conventions from the `flutter-widgets` skill "Building a new reusable widget"
Date: 2026-08-13
BA Agent version: 1.0

## Feature summary

Rework the existing global widget `lib/widgets/logo_placeholder.dart` into the spec's
placeholder-slot primitive: a reserved, deliberately-empty box that signals "real art goes
here". Three gaps against §3.3 — the border is solid where the spec is dashed, the size is a
free width/height pair where the spec has two fixed presets (app mark 88 at radius 20,
provider mark 20 at radius `xs`), and the marker label is set in the body face where the spec
says display 700 caps. Fill (`ink12`) and border colour (`ink24`) are already correct and
already tokenised. This is a rework of one existing widget, not a new file beside it: the
widget is renamed to something categorical, its single caller (the auth screen header) is
migrated in the same run, and nothing is left deprecated. The provider mark preset ships
with no caller — both provider rows render licensed marks today — and no new token, package,
or localisation key is added.

## Technical acceptance criteria

[1.4-AC1] PRESENTATION: After this run exactly one placeholder-slot widget exists in
`lib/widgets/`, produced by reworking the existing `logo_placeholder.dart` rather than adding
a second widget beside it. No `@Deprecated` alias or old class is retained, because the sole
caller is migrated in the same run ([1.4-AC12]).
  Failure case: a new placeholder widget added while `LogoPlaceholder` survives, a deprecated
  shim left with no caller, or two widgets in `lib/widgets/` drawing the same reserved box.

[1.4-AC2] PRESENTATION: The widget is named categorically for what it is — a reserved
placeholder slot — not for one of its two presets and not with a `default` prefix. File and
class names agree. It is built from plain Flutter widgets in the style of the existing
hand-written `lib/widgets/` components, has a `const` constructor, and keeps any private
helper widget in the same file.
  Failure case: the name still says "logo" while the widget also renders provider slots, a
  `default` prefix, a Widget-returning function or getter, or a helper split into its own file
  with no second caller.

[1.4-AC3] PRESENTATION: Size is a closed set of exactly two presets — app mark and provider
mark — selected by a single constructor input. There is no `width`, `height`, `size` or other
caller-supplied dimension, and no third preset.
  Failure case: the current `required this.width, required this.height` API surviving in any
  form, an arbitrary size escape hatch, or a preset nothing in §3.3 names.

[1.4-AC4] PRESENTATION: The app mark preset renders an 88×88 logical-pixel box; the provider
mark preset renders a 20×20 box. Both are square.
  Failure case: a non-square box, a dimension derived from the parent, or either number
  differing from the spec.

[1.4-AC5] PRESENTATION: The app mark preset uses corner radius 20 on all four corners; the
provider mark preset uses the existing `xs` radius token (6). Radius 20 stays a literal in the
widget — no new radius token is declared or added to `AppRadiusTokens`.
  Failure case: a shared radius across both presets, a square corner, `lg`/`sm` substituted
  for either value, or a new token added to the radius scale.

[1.4-AC6] PRESENTATION: Both presets fill their box with the existing `ink12` colour token.
  Failure case: a `Color(0x…)`/`Colors.*` literal, a re-declared duplicate of `ink12`, or the
  auth doc's `rgba(255,255,255,.18)` used for the provider preset.

[1.4-AC7] PRESENTATION: Both presets draw a 1 logical-pixel **dashed** outline in the existing
`ink24` colour token. The dashes follow the box's rounded outline on all four corners and all
four sides — no solid segment, no gap at a corner, no dash painted outside the widget's box.
  Failure case: a solid border (the current `Border.all`), a dashed rectangle ignoring the
  radius, a border thicker or thinner than 1px, `rgba(255,255,255,.32)` used for the provider
  preset, or dashes clipped away at the corners.

[1.4-AC8] PRESENTATION: One dash pattern serves both presets. At the 20px preset the outline
reads as a dashed line — at minimum several dashes per side — rather than as a broken solid
edge or a single dash per side.
  Failure case: a per-preset dash pattern, or a 20px box whose outline is visually
  indistinguishable from a solid border.

[1.4-AC9] PRESENTATION: The app mark preset renders the caps marker text `LOGO`, centred in
its box, in the display face at weight 700, 14px, `+.16em` letter spacing, in the `ink55`
colour token. The style derives from an app type token; the widget declares no font family or
weight of its own. The provider mark preset renders no text at all.
  Failure case: the label set in the body face (the current `microLabel` Inter 10/500 `ink70`
  token), a `GoogleFonts.*`/`TextStyle(fontFamily:…)` literal in the widget file, a label
  rendering inside the 20px preset, or the marker text changing from `LOGO`.

[1.4-AC10] PRESENTATION: The widget sizes itself in both axes and ignores its parent's
constraints — the same preset produces the same box inside a `Row`, a `Center`, a `Column` or
an unbounded parent, and never expands to fill available width.
  Failure case: the box stretching, collapsing to zero, or overflowing in an unbounded parent.

[1.4-AC11] PRESENTATION: The widget adds no spacing of its own — no outer padding, margin or
spacer, and no `EdgeInsets`, `padding` or gap constructor parameter reintroducing it through
the API. It renders flush inside the bounds its parent gives it. The fill, radius, dashed
outline and the label's centring inside the drawn box are the widget's own anatomy and are
unaffected by this rule.
  Failure case: any outer padding/margin baked in, or a spacing parameter on the constructor.

[1.4-AC12] PRESENTATION: `auth_screen.dart`'s header slot uses the app mark preset. It still
renders an 88×88 centred box in the same position in the column, with the same surrounding
gaps — the screen's layout is unchanged apart from the slot's own border and label treatment.
No other screen or widget is touched.
  Failure case: the auth screen failing to compile against the new API, a size or position
  shift in the header, or an unrelated screen edited.

[1.4-AC13] PRESENTATION: The provider mark preset ships unwired. The two provider rows keep
rendering `assets/icons/discord-logo.png` and `assets/icons/google-logo.png` at 20px; no
placeholder slot is inserted into them and no provider asset is removed.
  Failure case: a licensed mark replaced by a placeholder box, or a provider row's leading
  slot changing at all.

[1.4-AC14] PRESENTATION: The slot is display-only and non-interactive — no `onTap`, no
`InkWell`, no `GestureDetector`, no press, hover or focus treatment. All colour and radius
values come from tokens read through the project's context extension, never
`Theme.of(context)`. The only literal values in the widget are the two box sizes, the app
mark's radius 20, the 1px border width, and the dash pattern.
  Failure case: a tap callback or ripple, a direct `Theme.of(context)` call, or a hardcoded
  colour anywhere in the file.

[1.4-AC15] DOCS: The stale descriptions of this widget are corrected in the same run —
`onboarding-auth-design-spec.md` §9's "use the global **solid-border** `LogoPlaceholder`" and
§10's "accepts explicit width and height and uses a solid border" now describe the dashed,
two-preset widget under its new name. The `flutter-widgets` skill's reusable-widget catalogue
gains a row for it, noting it adds no spacing of its own.
  Failure case: either doc still telling the next agent the widget is solid-bordered and
  freely sized, or the catalogue still omitting it so the next agent rebuilds the same thing.

[1.4-AC16] TESTS: Widget tests cover — each preset rendering its stated box size; each preset
rendering its stated radius; the `ink12` fill on both; a dashed 1px `ink24` outline present
and no solid `Border`/`Border.all` on either preset; the `LOGO` label rendering at the app
mark preset with the display-face 700 style and no text rendering at the provider mark preset;
the box holding its size inside both a tight and an unbounded parent. The existing
`test/widget/auth/auth_screen_test.dart` assertion on `find.text('LOGO')` still passes. No
golden test and no `matchesGoldenFile`, whatever the criteria above say about appearance.
  Failure case: a new test failure beyond the recorded baseline, the auth screen test weakened
  or deleted to make the run pass, or a golden test added.

[1.4-AC17] BUILD: No new third-party dependency is added for the dashed border; it is drawn
with what the repo already carries. `pubspec.yaml` stays read-only.
  Failure case: a new package in `pubspec.yaml` without a recorded deviation approval.

## Out of scope

- Replacing either placeholder with real art. No logo asset and no licensed provider marks
  beyond Discord and Google exist (§7.2) — the dashed box is the deliberate signal that art is
  still owed, and `onboarding-auth-design-spec.md` §9's replacement checklist stays open.
- The Apple provider row and its mark. Parked for v1 (§5a), and per §9 it is never a
  placeholder slot — the native button supplies its own mark.
- The auth doc's `rgba(255,255,255,.18)` / `.32` provider slot values, and any `ink18`/`ink32`
  token to carry them. Superseded by §3.3's single anatomy — see `ambiguities.md`.
- Promoting §6's local additions (`radius 20px`, `rgba(255,255,255,.24)` as a named
  `--color-ink-24`) into the bound design system. `ink24` already exists as a Flutter colour
  token; radius 20 stays a literal.
- The game card's missing-art fallback (item 2.1). That is the onyx fill + hairline + gamepad
  glyph built into the cover tile in item 1.3, not this reserved slot — item 2.1 decides for
  itself whether it needs anything from this primitive.
- Localising the `LOGO` marker or adding an l10n key for it.
- Screen-reader semantics, press/hover states (§1.8), and any iOS verification.
- Any screen other than the auth screen header, and any change to the two provider rows.

## Assumptions

ASSUMPTION: In-place rework of the existing widget with its single caller migrated in the same
run; no `@Deprecated` alias retained, since nothing is left pointing at the old API.
ASSUMPTION: `88` and `20` are square boxes, per `onboarding-auth-design-spec.md` §3 and §5.
ASSUMPTION: Radius 20 stays a literal — it is not in the radius scale and §6 logs it as a
local addition pending promotion. `r-xs` is the existing `xs` token (6).
ASSUMPTION: Dash and gap lengths are not specified anywhere; one pattern serves both presets,
sized so the 20px box still reads as dashed. Border width is the specified 1px.
ASSUMPTION: The label follows §3.3's "display 700 caps" at the only numbers any doc supplies —
§3's 14px, `+.16em`, `ink55`. The current `microLabel` body-face token does not satisfy it.
ASSUMPTION: The marker text stays the literal `LOGO` inside the widget — placeholder chrome,
one caller, and it keeps the existing auth screen test green. Not localised, not a parameter.
ASSUMPTION: The provider mark preset renders no label; a 14px caps word does not fit 20px.
ASSUMPTION: The slot is display-only, with no interaction and no semantics work.
ASSUMPTION: Both presets are built even though only the app mark has a caller — the
requirement defines the item as constraining the widget to the spec's two presets.
ASSUMPTION: No new dependency; `pubspec.yaml` is read-only to pipeline phases.

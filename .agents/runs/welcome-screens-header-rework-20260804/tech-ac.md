# Technical Acceptance Criteria
Source: Ticket `W1-6.1R` — "Welcome screens header rework (item 6.1)"
(`.agents/runs/welcome-screens-header-rework-20260804/source-request.md`), amending
`.agents/runs/welcome-screens-20260802/tech-ac.md` (ref `W1-6`)
Date: 2026-08-04
BA Agent version: 1.0

## Feature summary

Both welcome-screen heroes stop being composed widget scenes and become a code-rendered
container holding one flat PNG. The container itself is unchanged — same fixed height,
same directional bottom radius — but everything previously drawn inside it (cover-fan
tiles, status chip, stat pill, context chip, key art, wash, countdown title and tiles,
ambient circles) is deleted and replaced by a single centered content image per screen.
Screen 1 keeps its flat indigo fill behind that image; screen 2's flat magenta fill is
replaced by a background image. Screen 2's copy block additionally loses the
social-proof row, with nothing in its place. Ten localisation keys whose only consumers
were the deleted widgets are removed from both `.arb` files. Everything else about the
two screens — frame, copy block, actions, motion, persistence, navigation, tests,
Android-only scope — is carried forward from item 6 unchanged and must survive this run.
This is a net deletion: no new dependency, no `pubspec.yaml` change, no token value
change, no new localisation key.

**Two things the Tech Lead must plan around:**

1. **This run reverses item 6's "no image files" rule.** `[W1-6.17]` and item 6's
   out-of-scope note banned adding assets. Ticket `W1-6.1R` supersedes that ban for
   these three files, which already exist on disk under an already-registered asset
   directory. Do not escalate the added PNGs as scope creep. `pubspec.yaml` still must
   not change.
2. **Unlike item 6, this run does not need a manual localisation regeneration to
   compile.** It adds no key, so no new `S` accessor is required. See `[W1-6.1R.14]`.

## Technical acceptance criteria

### Hero container

[W1-6.1R.1] UI: Both heroes remain a code-rendered container, not an image. Each keeps
the directional bottom radius `0 0 88 88` resolved from the existing `heroShape` token,
its existing fixed height (400 on screen 1, 356 on screen 2), and full viewport width.
  Failure case: a hero replaced wholesale by a single full-bleed image, a uniform border
  radius, or either height changed, fails the criterion.

[W1-6.1R.2] UI: Screen 1's hero fill stays the existing `surfaceIndigoPanel` (`#2f3782`)
flat colour. Screen 1 gets no background image.
  Failure case: any background image on screen 1, or a fill resolved from anything other
  than the existing token, fails the criterion.

[W1-6.1R.3] UI: Screen 2's hero fill is the image `assets/images/welcome-2-header-bg.png`
in place of the flat magenta. It covers the container's full area with its aspect ratio
preserved, cropping the overflow, and is clipped to the container's directional bottom
radius. This supersedes only the fill clause of `[W1-6.12]` for screen 2; that
criterion's height and radius requirements stand.
  Failure case: the background stretched to fit (aspect distorted), letterboxed so the
  container colour shows through at an edge, painting past the rounded bottom corners, or
  the magenta still rendering as screen 2's hero fill, fails the criterion.

### Hero content image

[W1-6.1R.4] UI: Each hero renders exactly one content image — screen 1
`assets/images/welcome-1-header.png`, screen 2 `assets/images/welcome-2-header.png` —
centered on both axes within its container and scaled to fit entirely inside the
container bounds with aspect ratio preserved and no cropping.
  Failure case: the content image anchored anywhere other than centered, cropped,
  stretched, overflowing the container, or either image appearing on the wrong screen,
  fails the criterion.

[W1-6.1R.5] UI: The content image composites directly onto the layer beneath it — the
indigo fill on screen 1, the background image on screen 2. No opaque panel, card, scrim
or padding block is drawn behind it.
  Failure case: a visible rectangular edge around the content image, or any surface
  introduced between the image and the hero fill, fails the criterion.

[W1-6.1R.6] UI: No fallback art, placeholder, spinner or error widget is introduced for
either image. If an asset fails to load, the hero still renders its container fill at
full size and neither screen crashes, overflows or shifts its copy block.
  Failure case: a bespoke error/placeholder widget, or a layout that collapses when an
  image is unavailable, fails the criterion.

### Removals

[W1-6.1R.7] UI: Neither hero renders an ambient circle — no neutral circle, no accent
circle, none at any radius. Supersedes `[W1-6.13]`.
  Failure case: any decorative circle on either hero fails the criterion.

[W1-6.1R.8] UI: None of the following is rendered as a widget on either screen: the glass
context chip, screen 1's `Playing` status chip, the glass stat pill, the three cover-fan
tiles, screen 2's key art and its wash, the countdown title, the countdown tiles and
their separator colons. The widget files that existed solely to build them, and any
helper used only by them, are deleted, and no reference to them survives in `lib/` or
`test/`. Supersedes `[W1-6.14]` and `[W1-6.16]` through `[W1-6.21]`.
  Failure case: any of these still built, any of them merely hidden behind a flag or
  commented out, or an orphaned widget file left in the tree, fails the criterion.

[W1-6.1R.9] UI/STATE: The welcome flow contains no timer, `Ticker`, `Stream.periodic`,
date arithmetic or other clock dependency. Item 6's countdown was already static
illustrative numbers; it is now not a widget at all, so nothing remains to drive.
Supersedes `[W1-6.22]`.
  Failure case: any clock or timer dependency in the welcome widget tree fails the
  criterion.

[W1-6.1R.10] UI: Screen 2's copy block does not render the social-proof row — neither the
line of text nor its three overlapping mini covers — and nothing replaces it. The copy
block runs hero → progress dots → headline → body → action row, and the vertical spacing
that belonged to the removed row is removed with it, leaving no gap where it sat. The
spacing between every surviving pair of copy-block elements is unchanged from item 6.
Supersedes `[W1-6.23]`.
  Failure case: the row still rendering, a replacement element in its place, or dead
  vertical space left behind, fails the criterion.

### Assets and build surface

[W1-6.1R.11] BUILD: The three PNGs are consumed from `assets/images/`, which
`pubspec.yaml`'s `flutter: assets:` list already registers. `pubspec.yaml` is not
modified, no asset directory is added, no density-variant folder (`2.0x`, `3.0x`) is
introduced, and no dependency is added or removed. This criterion reverses item 6's ban
on adding image files (`[W1-6.17]` and its matching out-of-scope note) for these three
files only.
  Failure case: any `pubspec.yaml` edit, an image loaded by file path or network rather
  than from the asset bundle, or a new dependency, fails the criterion.

[W1-6.1R.12] THEME: No token value is changed and no token is added. Tokens left unused
by this run's deletions (the ambient-circle colours, the glass fills, the key-art and
cover-tile washes, the countdown colon, the welcome-2 magenta) stay in place untouched.
  Failure case: any edit to a value in `lib/config/theme/tokens/` fails the criterion.

[W1-6.1R.13] UI: Any widget file this run adds or modifies still resolves every visual
value through `context.tokens` — no `Color(0x…)`, no literal `BoxShadow`, no literal blur
sigma, no inline `TextStyle` carrying a font size. `[W1-6.7]` remains binding on the
reduced widget set.
  Failure case: any raw colour, shadow, blur or type literal outside
  `lib/config/theme/tokens/` fails the criterion.

### Localisation

[W1-6.1R.14] L10N: These ten keys are removed from **both** `lib/l10n/intl_en.arb` and
`lib/l10n/intl_zh.arb`: `welcome_chip_one`, `welcome_chip_two`, `welcome_stat_tracked`,
`welcome_stat_hours`, `welcome_stat_playing`, `welcome_social_proof`,
`welcome_countdown_title`, `welcome_countdown_days`, `welcome_countdown_hours`,
`welcome_countdown_minutes`. No key is added. Every other key stays in both files
untouched, explicitly including `welcome_headline_one`, `welcome_headline_two`,
`welcome_body_one`, `welcome_body_two`, `next`, `skip`, `get_started` and `playing`.
This amends `[W1-6.33]`'s key table; that criterion's rule that all rendered text
resolves through `S.current` still binds the surviving text.
  Failure case: a key removed from one `.arb` but not the other, a surviving reference to
  a removed key anywhere in `lib/` or `test/`, a new key added, or any key outside the
  listed ten removed, fails the criterion.

[W1-6.1R.15] BUILD: Because this run adds no localisation key, it needs no new `S`
accessor and the branch compiles without an IDE regeneration. The generated accessors for
the ten removed keys remain in `lib/generated/` until a human regenerates; that staleness
is expected and is not a defect, not a build failure and not a QA finding. `[W1-6.34]`
still binds absolutely: no generated localisation file is hand-edited, including to
delete those stale accessors. `[W1-6.35]`'s "the branch is expected not to compile" halt
does **not** apply to this run.
  Failure case: any manual edit to `lib/generated/l10n.dart`,
  `lib/generated/intl/messages_en.dart` or `messages_zh.dart`, or a Dev/QA halt raised
  over the stale accessors, fails the criterion.

### Accessibility

[W1-6.1R.16] UI/A11Y: The three images are exposed as decorative — excluded from the
semantics tree, carrying no semantic label and no alt text, and no new copy is invented
for them. The screens' meaning continues to be carried by the headline, body and action
labels, which remain real localised text. `[W1-6.40]`'s contrast requirement continues to
apply to those elements; it no longer applies to overlay text over cover placeholders,
which no longer exist as widgets.
  Failure case: a screen reader announcing a filename or a raw asset key, or a new
  user-facing string introduced to label an image, fails the criterion.

[W1-6.1R.17] UI: With the images in place, neither screen overflows on a viewport shorter
than the 714 reference or at increased platform text scale. The hero keeps its fixed
height, the content image scales within it, and the copy block stays bottom-anchored.
`[W1-6.41]` carries forward and now covers the image case.
  Failure case: any framework render-overflow on a short viewport or at large text scale
  fails the criterion.

### Tests and baselines

[W1-6.1R.18] TEST: The widget tests under `test/widget/onboarding/` are updated so that
every assertion on a removed element — context chip, status chip, stat pill, cover tiles,
key art, countdown, ambient circles, social-proof row — is deleted rather than skipped or
commented out, and no test references a removed localisation key. Each screen's test
asserts its hero renders the expected asset exactly once, identified by asset key. No
golden test. `[W1-6.42]`'s remaining coverage (headline, body, progress-dot state, Skip
and Get started writing the flag, Next not writing it, one green element per screen,
reduced-motion collapse) is preserved.
  Failure case: a test still asserting a removed widget, a `skip:`-ed or commented-out
  test, a `matchesGoldenFile` call, or a welcome screen with no assertion that its hero
  image renders, fails the criterion.

[W1-6.1R.19] BUILD: `flutter analyze` reports no new error or warning against this run's
recorded baseline (0 errors, 2 warnings, 36 info) and the Android debug build compiles.
  Failure case: any new analyser error or warning attributable to this run's files fails
  the criterion. Note that deleting widgets and keys is expected to *reduce* the info
  count; a drop is not a regression.

[W1-6.1R.20] TEST: The onboarding widget tests pass at the end of this run. The two
failures in `test/widget/onboarding/welcome_screen_test.dart` that `orchestrator-state.md`
records as pre-existing sit inside this run's own scope — that file is rewritten here —
so leaving them red is not acceptable on the baseline exemption. Every other recorded
pre-existing failure stays exempt and must not be touched.
  Failure case: a red onboarding widget test at the end of the run fails the criterion.
  If a failure there traces to a cause outside this ticket, it is escalated with that
  root cause named, not silently carried.

### Carried forward from item 6, unchanged

These remain in force verbatim from `.agents/runs/welcome-screens-20260802/tech-ac.md`.
They are referenced, never re-derived, and must not be dropped, weakened or re-litigated
by this run. Downstream artifacts cite them by their original ID.

| ID | Subject | Note |
|---|---|---|
| `[W1-6.1]`–`[W1-6.6]` | Token layer values, `green` correction, elevation/blur/type/radius additions, complete `copyWith`/`lerp` | Already merged; this run neither extends nor edits them (see `[W1-6.1R.12]`) |
| `[W1-6.7]` | No raw colour/shadow/blur/type literals in widget files | Restated for this run's file set as `[W1-6.1R.13]` |
| `[W1-6.8]`–`[W1-6.10]` | `OnboardingRoute` resolution, deletion of the old Lottie flow, `OnboardingGuard` unchanged | Untouched |
| `[W1-6.11]` | Two-part frame: fixed-height hero, then bottom-anchored copy block, no divider | Untouched |
| `[W1-6.12]` | Hero height and directional bottom radius | Fill clause for screen 2 superseded by `[W1-6.1R.3]`; heights and radius stand |
| `[W1-6.15]` | No mockup device frame, no 38 radius, no screen label | Untouched |
| `[W1-6.24]`–`[W1-6.26]` | Progress dots, headline type, body type | Untouched |
| `[W1-6.27]`–`[W1-6.29]` | Screen 1 Next + text Skip, screen 2 Get started alone, one green element per screen | Untouched |
| `[W1-6.30]` | Press scale 0.97, 2px green focus ring at 2px offset | Untouched |
| `[W1-6.31]`–`[W1-6.32]` | Screen transition via existing tokens, reduced-motion collapse | Untouched |
| `[W1-6.33]` | All rendered text via `S.current`; both `.arb` files kept in sync | Key table amended by `[W1-6.1R.14]` |
| `[W1-6.34]` | Generated localisation files never hand-edited | Reaffirmed by `[W1-6.1R.15]` |
| `[W1-6.35]` | Manual regeneration halt | **Does not apply to this run** — see `[W1-6.1R.15]` |
| `[W1-6.36]`–`[W1-6.38]` | `first_use` flag written on both exits, never mid-flow, suppresses the flow on later launches | Untouched |
| `[W1-6.39]` | Both exits replace the flow with `HomeRoute`; back moves screen 2 → screen 1 | Untouched |
| `[W1-6.40]` | 44 minimum hit targets, WCAG AA for body and metadata | Narrowed by `[W1-6.1R.16]`: the cover-placeholder overlay clause is moot |
| `[W1-6.41]` | No overflow on short viewports or at large text scale | Restated for the image case as `[W1-6.1R.17]` |
| `[W1-6.42]` | Widget tests under `test/widget/onboarding/`, no golden tests | Coverage list amended by `[W1-6.1R.18]` |
| `[W1-6.43]` | Android debug build and analyser baseline | Baseline figures replaced by this run's, see `[W1-6.1R.19]` |
| `[W1-6.44]` | No platform conditional, no iOS branch, no landscape layout | Untouched |

Superseded and no longer in force: `[W1-6.13]`, `[W1-6.14]`, `[W1-6.16]`, `[W1-6.17]`,
`[W1-6.18]`, `[W1-6.19]`, `[W1-6.20]`, `[W1-6.21]`, `[W1-6.22]`, `[W1-6.23]`.

## Out of scope

- Any `pubspec.yaml` change, including asset registration — `assets/images/` is already
  registered.
- Pruning tokens left unused by these deletions. The ticket accepts them as dead weight
  for this run.
- Pruning the `playing` localisation key. It is not on the ticket's removal list even
  though its only consumer is deleted here — see the assumption below.
- Routing, `OnboardingGuard` and persistence logic. Nothing in this run touches them.
- Screen 1's hero background. It keeps its flat colour; no image is added behind it.
- Locale-specific artwork. All three PNGs carry baked-in English text and the same files
  are served to every locale, including `zh` — recorded as an assumption below.
- The legibility and contrast of text baked inside the PNGs. It cannot be asserted in a
  widget test and no golden test is permitted on this project, so it is QA's manual
  visual check against the run's screenshots, not a criterion. The same applies to the
  images' exact framing and crop within the hero.
- Auth, splash, the design-system component library, light theme, analytics and iOS —
  all still out of scope exactly as item 6 recorded.

## Assumptions

ASSUMPTION: The ten unused localisation keys are removed from both `.arb` files. The
ticket delegates this call explicitly to the Tech Lead/BA rather than the Product Owner,
recommends removal, and cites item 6's own precedent of deleting the superseded
`onboarding_description_*` keys. Their only consumers are deleted in this run, so the
blast radius is nil and the change is trivially reversible.

ASSUMPTION: The `playing` key stays. The ticket enumerated ten keys to remove and a
separate list of keys that stay, and `playing` appears on neither, so its removal is
unauthorised. Its only consumer, the deleted status chip, does disappear here, which
leaves it unused — accepted on the same basis the ticket accepts unused tokens. Removing
a key the ticket did not name is the riskier of the two options. `AppStatusTokens.playing`
is a token, not a string, and is unrelated and untouched.

ASSUMPTION: "Centered" means the content image is scaled down to fit wholly inside the
hero with its aspect ratio preserved and no crop, then centered on both axes. The
alternative reading — fill and crop — would clip baked-in text, which is the one thing
these images exist to display.

ASSUMPTION: The screen 2 background image covers the container and crops its overflow,
rather than fitting inside it. A background that fits would letterbox and expose the
container colour at an edge, which is exactly the flat fill this ticket replaces.

ASSUMPTION: Both content PNGs have transparent backgrounds and are composited over the
layer beneath. Confirmed by inspecting the three files on disk.

ASSUMPTION: The images are decorative for accessibility purposes and carry no semantic
label. Labelling them would require inventing new user-facing copy and new localisation
keys, which this ticket forbids, and the content they display is illustrative stand-in
material that item 6 already recorded as non-informational.

ASSUMPTION: All locales get the same three PNGs. The baked-in text is English
("YOUR LIBRARY", "Playing", "Games / Hours / Platforms", "WISHLISTED · PS5",
"SILENT HOLLOW II", "DAYS / HRS / MIN"), so the `zh` build shows English hero art where
item 6 showed translated strings. No Chinese asset was supplied and none may be invented
here. This is a known and accepted consequence of the flat-art decision, not a defect for
QA to raise. It is surfaced in `ambiguities.md` for the Product Owner's visibility.

ASSUMPTION: Removing the social-proof row removes its spacing too, rather than leaving an
equivalent gap. "Nothing replaces it" reads as the row and its rhythm both going.

ASSUMPTION: `[W1-6.12]`'s "screen 2 is 356 high on the welcome-2 magenta" is amended, not
contradicted, by requirement 1's background image. The ticket did not list `[W1-6.12]` as
superseded but did explicitly restate screen 2's fill, so the later explicit statement
governs the fill and the rest of `[W1-6.12]` survives.

ASSUMPTION: The stat figures, chip copy and countdown values baked into the images are
illustrative and are not expected to match item 6's strings. They differ already
("Games / Hours / Platforms" against `Tracked / Hours / Playing`, "SILENT HOLLOW II"
against `NEON VESPER`), which is consistent with all of it being stand-in art.

## Constraints

- This run is a net deletion. Any criterion that appears to require building something
  new, other than two `Image` placements and one background, has been misread.
- Item 6's asset ban is dead for these three files and only these three files. A Tech
  Lead or Dev Agent that escalates the PNGs as scope creep has misread this document.
- Conversely, `pubspec.yaml` remains untouchable. The asset directory is already
  registered; nothing needs to change there.
- No golden tests, whatever a criterion says about pixel appearance. Visual fidelity of
  the images inside the heroes is QA's manual check.
- Android portrait only, unchanged.

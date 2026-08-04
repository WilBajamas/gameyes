# Technical Acceptance Criteria
Source: Week-1 checklist item 6 — "Welcome screens" (ticket-style requirement, ref `W1-6`), implementing `.agents/references/onboarding-welcome-design-spec.md` against `.agents/references/system-foundation-specs.md`
Date: 2026-08-02
BA Agent version: 1.0

## Feature summary

Replace the app's existing three-page Lottie onboarding with a two-screen welcome
flow built to a fixed design spec. Screen 1 shows a cover-fan hero and a glass stat
bar over an indigo panel, and offers Next plus a plain-text Skip. Screen 2 shows a
key-art hero with a countdown over a magenta panel, and ends the flow with a single
Get started action and no skip. Both screens share one frame: a fixed-height hero
panel with a directional bottom radius above a bottom-anchored copy block carrying
progress dots, an all-caps display headline, one line of body and an action row.
Cover art and key art are drawn placeholders — no image files are added. Exiting by
either route records onboarding as seen in the existing `SharedPreferences` flag, so
the flow does not reappear on later launches. The theme extension from week-1 item 4
is extended, under explicit authorisation, with the onboarding values the spec needs
and which no token currently carries.

**Two things the Tech Lead must plan around, both authorised, neither an escalation:**

1. **The merged item-4 token layer is reopened on purpose.** `lib/config/theme/tokens/`
   must appear in the task brief's file allowlist. See `[W1-6.1]`–`[W1-6.7]`. This is
   an approved extension, not scope creep — do not escalate it.
2. **This run cannot compile on its own.** It adds sixteen localisation keys, and the
   `S` accessors come from the Flutter Intl **IDE plugin**, which has no CLI on this
   project. A human must regenerate before the branch builds. This is an **expected
   manual step, not a defect** — see `[W1-6.33]`–`[W1-6.35]`.

## Technical acceptance criteria

### Token layer (authorised extension of week-1 item 4)

[W1-6.1] THEME: `AppColorTokens` gains the onboarding colour values the spec requires
and which no existing token carries: the welcome-2 hero fill `#8a2f86`; the key-art
wash `rgba(30,20,64,.5)`; the cover-tile wash `rgba(10,13,58,.42)`; the neutral
ambient circle `rgba(255,255,255,.09)`; the accent ambient circle
`rgba(236,72,189,.2)`; the glass fills at `rgba(0,0,0,.30)`, `.32` and `.34`; and the
countdown colon at `rgba(255,255,255,.4)`. The welcome-1 hero fill reuses the existing
`surfaceIndigoPanel` (`#2f3782`) rather than adding a duplicate.
  Failure case: if any of these values appears as a literal inside a widget rather
  than as a token, or if `surfaceIndigoPanel` is duplicated under a second name, the
  criterion fails.

[W1-6.2] THEME: The `green` token is corrected from `Color(0xFF4CAF50)` to `#35ed7e`,
the Electric Green given in `system-foundation-specs.md` §1.1. The existing value is a
Material default that predates the authoritative source.
  Failure case: if the CTA renders in Material green, or the old value survives
  anywhere in the token files, the criterion fails.

[W1-6.3] THEME: An elevation token carries `--shadow-float`
(`0 3px 68px rgba(69,42,124,0.1)`, §1.5) and a blur token carries `--blur-glass`
(sigma equivalent to `blur(18px)`, §1.6). Neither exists in the layer today.
  Failure case: if a `BoxShadow` or `ImageFilter.blur` is constructed inline in any
  widget with literal numbers, the criterion fails.

[W1-6.4] THEME: `AppTypeTokens` gains the app-scale steps the spec needs and the
current set lacks: the welcome headline at 34 / 1.02 line-height / `-0.01em` tracking /
display 700 / uppercase; the countdown figure at display 700 30; the panel title at
display 700 26; the countdown colon at display 22; the stat figure at display 700 18 /
1.1; a 13px `ink55` body style; and a 10px `.1em` uppercase micro-label. The `body`
style's line height is corrected from 1.5 to 1.45 per §1.2's Lead row and welcome spec
§4.4.
  Failure case: if the headline renders without uppercase, without the tight leading,
  or without negative tracking; or if any of the listed sizes is applied via an inline
  `TextStyle`, the criterion fails.

[W1-6.5] THEME: `AppRadiusTokens` gains the `5` mini-cover radius, now a sanctioned
local addition (`system-foundation-specs.md` §1.4, §3.3, §6). The file's existing
comment naming 5 among the deliberately-excluded sizes is updated so it no longer
contradicts the code.
  Failure case: if the mini covers render at radius 6, or the stale comment still
  claims 5 is excluded, the criterion fails.

[W1-6.6] THEME: Every token class touched keeps its `copyWith` and `lerp` complete —
each new field appears in both, and `AppTokens` remains constructible as a second
instance for a future light theme without restructuring.
  Failure case: if any new field is missing from `copyWith` or `lerp`, the criterion
  fails. A silently un-lerped field is the exact defect that makes a later light theme
  a rewrite.

[W1-6.7] UI: No widget file added or modified by this run contains a `Color(0x…)`,
`Color.fromRGBO(…)`, a literal `BoxShadow`, a literal blur sigma, or an inline
`TextStyle` with a font size. Every visual value resolves through `context.tokens`.
Verified by inspecting the diff.
  Failure case: any raw colour, shadow, blur or type literal outside
  `lib/config/theme/tokens/` fails the criterion.

### Replacing the existing flow

[W1-6.8] ROUTING: `OnboardingRoute` resolves to the new two-screen welcome flow. The
route name, its `/onboarding` path and its registration in `AppRouter` are reused
rather than replaced with new names.
  Failure case: if a second onboarding route is introduced, or `OnboardingRoute` still
  resolves to the deleted screen, the criterion fails.

[W1-6.9] CLEANUP: `lib/features/onboarding/presentation/screens/onboarding_screen.dart`
(in its three-page Lottie form), `page_view_item.dart`, and
`assets/animations/onboarding_anim_1.json`, `_2.json` and `_3.json` are deleted, along
with their `AssetConstants.onboardingAnimation1/2/3` entries. No reference to any of
them survives anywhere in `lib/`.
  Failure case: if any deleted file is still referenced, or a constant points at a
  missing asset, the criterion fails.

[W1-6.10] ROUTING: `OnboardingGuard` keeps its current behaviour unchanged — it reads
`StorageConstants.firstUseKey` and redirects to `OnboardingRoute` when the flag is
absent or false. No auth awareness is added; that is item 8.
  Failure case: if the guard gains an auth dependency, or its redirect logic changes,
  the criterion fails.

### Shared frame

[W1-6.11] UI: Both screens render a column of exactly two parts — a fixed-height hero
panel, then a copy block that takes the remaining height with its content anchored to
the bottom. There is no border, divider or shadow between the two.
  Failure case: if a separator of any kind appears between hero and copy block, or the
  copy block is top-anchored, the criterion fails.

[W1-6.12] UI: The hero panel is a flat fill with the directional bottom radius
`0 0 88 88`, resolved from the existing `heroShape` radius token. Screen 1 is 400 high
on `surfaceIndigoPanel`; screen 2 is 356 high on the welcome-2 magenta.
  Failure case: any gradient fill, any clipped decorative shape inside the hero, or a
  uniform border radius fails the criterion.

[W1-6.13] UI: Each hero carries one or two ambient circles at the full radius, bled off
the panel edge, using the neutral and accent ambient tokens. Never more than two per
hero, and they are not animated.
  Failure case: a third circle on either hero, or any animation driving them, fails the
  criterion.

[W1-6.14] UI: Each hero carries exactly one glass context chip at 54 from the hero top,
left-aligned, with pill radius, the `.30–.34` black glass fill, `--blur-glass` behind
it, an 11px/500 `.08em` uppercase label and a 13px leading icon. Screen 1 reads
`Your library`; screen 2 reads `Wishlisted · PS5`.
  Failure case: two chips on one hero, a chip with no backdrop blur, or a chip rendered
  as a flat opaque fill fails the criterion.

[W1-6.15] UI: The `330 × 714` device frame, its 38 radius, its hairline outline and the
uppercase screen label are **not** built. The screens fill the device viewport.
  Failure case: if a fixed-size rounded container or a screen-label caption is rendered
  in the app, the criterion fails — that is mockup chrome, and
  `system-foundation-specs.md` §6 records 38 as "hardware geometry, not a UI radius".

### Screen 1 hero

[W1-6.16] UI: Three cover tiles form a fan at `--radius-lg`: left `100 × 134` rotated
-9°, bottom 96; right `100 × 134` rotated 10°, bottom 88; centre `124 × 166` rotated 2°,
bottom 112. Only the centre tile carries the float shadow.
  Failure case: a shadow on any tile other than the centre, or more than one shadow on
  the screen, fails the criterion — §6 states the shadow "appears exactly once".

[W1-6.17] UI: Each cover tile renders a drawn placeholder, not an image asset, carrying
the cover-tile wash so the tile reads as a brand block. No file is added to `assets/`
and no `pubspec.yaml` asset entry changes. Each placeholder is structured so a real
image swaps in without reshaping the widget.
  Failure case: if the run adds an image file, edits `pubspec.yaml`, or renders the
  covers as dashed placeholder slots (a pattern reserved for un-licensable brand marks
  per §1.9), the criterion fails.

[W1-6.18] UI: The centre tile carries a status chip reading `Playing` with a 5px dot,
per welcome spec §3a — not the 6px on-media dot from `system-foundation-specs.md` §3.3.
The welcome spec takes precedence for its own screen.
  Failure case: a 6px dot, or a status chip on a tile other than the centre, fails the
  criterion.

[W1-6.19] UI: A glass stat pill is inset 24 from each side at 34 from the hero bottom,
with pill radius, `10 × 14` padding, the `.3` black glass fill and `--blur-glass`. It
holds three figure/label pairs spaced apart, each figure in display 700 18 and each
label at 10. The figures read `312`, `1,204` and `7` as literal strings.
  Failure case: figures rendered from computed data, a fourth pair, or a flat opaque
  pill fails the criterion.

### Screen 2 hero

[W1-6.20] UI: The key art renders as a drawn placeholder under the flat key-art wash
`rgba(30,20,64,.5)`. The wash is a solid colour, never a scrim gradient. No image file
is added.
  Failure case: any gradient wash, or an added asset file, fails the criterion.

[W1-6.21] UI: A countdown renders as three glass tiles in `DAYS : HRS : MIN` order, each
at `--radius-xs`, minimum width 52, padding `8 × 12`, the `.32` black glass fill with
blur, a display 700 30 figure and a 10px `.1em` uppercase label beneath. Separator
colons render in display 22 at the 40% ink value, optically raised by 26 of bottom
padding. A display 700 26 title sits above.
  Failure case: a colon aligned to the tile centre rather than optically, or a missing
  blur, fails the criterion.

[W1-6.22] UI/STATE: The countdown values are fixed illustrative numbers. No timer,
ticker, `Stream.periodic`, date arithmetic or data source drives them.
  Failure case: any timer or clock dependency in the widget tree fails the criterion —
  §7 states the welcome screens are static by default.

[W1-6.23] UI: A social-proof row appears on screen 2 only, above the progress dots:
three overlapping `26 × 34` mini covers at radius 5, each with a 1.5 border in the onyx
canvas colour and an -8 overlap, beside a 13px `ink55` line.
  Failure case: the row appearing on screen 1, or mini covers at any radius other than
  5, fails the criterion.

### Copy block

[W1-6.24] UI: Progress dots render with the active step as a `22 × 5` pill in full ink
and the inactive step as a `5 × 5` dot at `ink12`, with a 6 gap. Screen 1 has the first
active, screen 2 the second.
  Failure case: numbers, a progress bar, or an equal-width active dot fails the
  criterion.

[W1-6.25] UI: The headline renders in the display face at 700, size 34, line height
1.02, tracking `-0.01em`, in full ink, uppercase, with no terminal period.
  Failure case: a headline with a trailing period, sentence case, or default leading
  fails the criterion.

[W1-6.26] UI: The body renders at 16 / 1.45 in `ink70`, one sentence, sentence case,
ending in a period.
  Failure case: multi-sentence body copy, or body at 1.5 leading, fails the criterion.

[W1-6.27] UI: Screen 1's action row pairs the full-width green primary with a
plain-text `Skip` at 14/500 in `ink70` with `0 × 8` padding, in a row with a 10 gap.
Skip is text, never a second button — it has no fill, no border and no elevation.
  Failure case: Skip rendered as an outlined or filled button fails the criterion.

[W1-6.28] UI: Screen 2's action row holds the green primary alone, with no secondary
action and no skip.
  Failure case: any secondary action on screen 2 fails the criterion.

[W1-6.29] UI: Each screen shows exactly one green element — the primary action — with
black label text, at a minimum height of 44 and full width. No other element on either
screen uses the green token, except the focus ring.
  Failure case: green appearing twice on one screen, or a green CTA with non-black
  label text, fails the criterion. Green is rationed by
  `system-foundation-specs.md` §0.2 and §2.1.

[W1-6.30] UI: Press on any interactive element scales it to 0.97 with no colour change.
Focus renders a 2px green outline at 2px offset.
  Failure case: a press ripple, colour shift, or bounce fails the criterion.

### Motion

[W1-6.31] UI: Advancing screen 1 → screen 2 uses the existing `screenTransition`
duration (420ms) and `screenTransitionCurve`. No parallax, no spring, no scroll-jacking.
  Failure case: a hardcoded duration or curve, or any spring physics, fails the
  criterion.

[W1-6.32] UI: All motion collapses when the platform reports reduced motion, via the
existing `AppMotionTokens.resolve`. A widget test asserts zero duration when
`MediaQuery.disableAnimations` is true.
  Failure case: any animation that still runs under reduced motion fails the criterion.

### Localisation

[W1-6.33] L10N: Sixteen keys are added to **both** `lib/l10n/intl_en.arb` and
`lib/l10n/intl_zh.arb`, and the three `onboarding_description_one/two/three` keys are
removed from both. `next` and `skip` are reused. All user-facing text resolves through
`S.current` — no string literal is rendered directly by any widget.

| Key | English | Chinese |
|---|---|---|
| `welcome_headline_one` | TRACK EVERY GAME YOU'VE EVER TOUCHED | 追踪你玩过的每一款游戏 |
| `welcome_body_one` | Every game you have played, beaten, dropped or shelved, in one place — 312 or 3. | 你打通的、弃坑的、积灰的游戏，全都在一处 —— 312 款还是 3 款都一样。 |
| `welcome_headline_two` | AND KNOW WHAT DROPS NEXT | 抢先知道下一款大作 |
| `welcome_body_two` | Track what you are waiting on and see the countdown to every release you care about. | 追踪你在等的游戏，看着倒计时一天天逼近每一个发售日。 |
| `welcome_chip_one` | Your library | 你的游戏库 |
| `welcome_chip_two` | Wishlisted · PS5 | 已心愿 · PS5 |
| `welcome_stat_tracked` | Tracked | 已追踪 |
| `welcome_stat_hours` | Hours | 小时 |
| `welcome_stat_playing` | Playing | 在玩 |
| `welcome_social_proof` | 2.4M games tracked so far. | 已追踪 240 万款游戏。 |
| `welcome_countdown_title` | NEON VESPER | NEON VESPER |
| `welcome_countdown_days` | Days | 天 |
| `welcome_countdown_hours` | Hrs | 时 |
| `welcome_countdown_minutes` | Min | 分 |
| `get_started` | Get started | 开始使用 |
| `playing` | Playing | 在玩 |

  Failure case: a key present in one `.arb` but not the other, a widget rendering a
  hardcoded string, or a surviving `onboarding_description_*` key fails the criterion.

[W1-6.34] L10N: `lib/generated/l10n.dart`, `lib/generated/intl/messages_en.dart` and
`messages_zh.dart` are **not** hand-edited, and no accessor is hand-written. No bulk
rename touches them.
  Failure case: any manual edit to a generated localisation file fails the criterion.
  This is the exact mistake recorded in `handover.md` gotcha #2, where a `sed` pass
  produced a duplicate map key that compiled fine and silently rendered the wrong
  string.

[W1-6.35] BUILD: The branch is **expected not to compile** until a human opens the IDE
and lets the Flutter Intl plugin regenerate the `S` class. This is a known constraint
of the project's localisation setup (`handover.md` gotcha #1, week-1 item 1a), not a
defect of this run and not a Dev Agent failure. The Dev Agent adds the keys, uses
`S.current.<key>`, and flags the regeneration as a manual step. Analyzer and test
criteria below are assessed **after** that regeneration.
  Failure case: if the Dev Agent hand-writes accessors to force a green build, or QA
  records the pre-regeneration state as a failure, the criterion fails.

### Persistence

[W1-6.36] STORAGE: Exiting the flow by either route — `Skip` on screen 1 or
`Get started` on screen 2 — writes `true` to `StorageConstants.firstUseKey`
(`'first_use'`) via the injected `SharedPreferences`. No new key is introduced and no
wrapper class is written.
  Failure case: if Skip leaves the flag unwritten, or a second key is added, the
  criterion fails.

[W1-6.37] STORAGE: The flag is not written while the flow is in progress. Advancing
from screen 1 to screen 2 writes nothing.
  Failure case: if the flag is set on screen 1's `Next`, the criterion fails — a user
  who kills the app mid-flow would then never see the flow again.

[W1-6.38] STORAGE: With the flag set, a subsequent launch does not show the welcome
flow. With the flag absent or false, it does. Verified against `OnboardingGuard`'s
existing behaviour.
  Failure case: onboarding reappearing after a completed flow fails the criterion.

[W1-6.39] NAVIGATION: Both exits route to the app's existing post-onboarding
destination (`HomeRoute`) and replace the flow in the stack, so back does not re-enter
it. Within the flow, back moves screen 2 → screen 1.
  Failure case: if the welcome flow remains on the back stack after exit, or either
  exit routes somewhere other than the current post-onboarding destination, the
  criterion fails.

### Accessibility, tests, platform

[W1-6.40] UI/A11Y: Every interactive element meets a 44 minimum hit target. Body copy
and metadata meet WCAG AA against their own surface, including text over the hero
fills and over the cover placeholders.
  Failure case: a tap target below 44, or overlay text failing AA against its surface,
  fails the criterion.

[W1-6.41] UI: Neither screen overflows on a viewport shorter than the 714 reference or
at increased platform text scale. The hero panel absorbs the difference; the copy block
stays bottom-anchored.
  Failure case: any render overflow reported by the framework on a shorter viewport
  fails the criterion.

[W1-6.42] TEST: Widget tests live under `test/widget/onboarding/` and cover: both
screens rendering their headline, body and progress-dot state; Skip and Get started
each writing the flag; `Next` not writing it; the single-green-element rule per screen;
and the reduced-motion collapse. No golden tests.
  Failure case: a golden test, a test mirroring `lib/`'s folder shape, or an untested
  flag-writing path fails the criterion.

[W1-6.43] BUILD: After the manual localisation regeneration, the Android debug build
compiles and the analyser reports no new errors or warnings against the run's recorded
baseline (0 errors, 2 warnings, 55 info).
  Failure case: any new analyser error or warning attributable to this run's files
  fails the criterion.

[W1-6.44] PLATFORM: No file added or modified contains a platform conditional, an
iOS-specific branch or a landscape layout.
  Failure case: any platform check in this run's files fails the criterion.

## Out of scope

- Any authentication wiring. This run consumes none of item 5's use cases; the auth
  screen is item 7 and the auth-aware route guard is item 8.
- The splash screen and the auth screen, both explicitly outside the welcome spec's
  scope.
- The design system `Button`, `Badge`, `Icon` and every other component-library item —
  week 2. The green action is a widget local to the onboarding feature.
- Light theme. The token extension must remain structurally ready for a second
  instance, but no light instance is built.
- Real cover art, key art and the app mark. All three stay drawn placeholders;
  `system-foundation-specs.md` §7.3 records that no imagery was supplied.
- `--surface-art` / `--surface-art-deep`. Still numerically undefined, and confirmed
  not needed — they serve missing-art fallback rendering, which is not this run's case.
- Removing the now-unused `lottie` dependency from `pubspec.yaml`. Dependency changes
  are not authorised here.
- Any `pubspec.yaml` change at all, including asset registration.
- The `ql-breathe` ambient animation, kept unused per §7.
- Analytics, telemetry and event tracking.
- iOS layout, verification or platform parity.
- The dead `featured_revamp` localisation getter — pre-existing, disappears on the next
  IDE regeneration, not this run's concern.

## Assumptions

ASSUMPTION: The device frame, its 38 radius and the screen label are mockup chrome, not
app UI — confirmed by `system-foundation-specs.md` §6, "hardware geometry, not a UI
radius".

ASSUMPTION: Cover and key art are drawn from tokens, not added as files. Dashed
placeholder slots are reserved for third-party brand marks (§1.9) and are not used
here.

ASSUMPTION: The existing `green` token value is a placeholder from item 4 and is
corrected to the now-authoritative `#35ed7e`. Nothing consumes green today, so the
blast radius is nil.

ASSUMPTION: Where the welcome spec and `system-foundation-specs.md` disagree, the
welcome spec wins for these two screens, per the latter's own precedence note. The one
live case is the focal cover's 5px status dot.

ASSUMPTION: `welcome_countdown_title` is invented stand-in content matched to the
placeholder key art, chosen not to collide with a real trademark, and is swapped when
real art lands. Game titles are not translated, so the Chinese value matches the
English.

ASSUMPTION: The three stat figures are literal display strings, not localised and not
computed. §3b states "Numbers are the copy".

ASSUMPTION: Chinese carries no uppercase treatment; `AppTextToken.uppercase` is a
no-op for it and no separate style is needed.

ASSUMPTION: The seen-flag is device-local and survives sign-out — corroborated by item
8's requirement that a signed-out user who completed onboarding lands on the auth
screen, not on welcome screen 1.

ASSUMPTION: Both exits mark onboarding seen; an interrupted flow restarts at screen 1.

ASSUMPTION: The countdown is static, with no timer and no data source.

ASSUMPTION: Coverage is widget tests only, grouped by layer, with no golden tests.

ASSUMPTION: Android portrait only.

## Constraints

- The token layer extension is **authorised and expected**. `lib/config/theme/tokens/`
  belongs in the file allowlist. A Tech Lead or Dev Agent that escalates it as scope
  creep has misread this document.
- Every new token field must be carried through `copyWith` and `lerp`. A field that is
  added to the constructor but skipped in `lerp` will not fail any criterion above at
  build time, and will quietly make the deferred light theme a rewrite.
- Localisation regeneration is a human step and the branch will not compile before it.
  Plan the Dev Agent's halt point around this rather than treating it as a build
  failure.
- Green is rationed to one element per screen. This is a system-wide law
  (`system-foundation-specs.md` §0.2, §2.1), not a preference for these screens.
- Flat fills only on app surfaces. No gradient may be introduced anywhere in this run,
  including behind the placeholder art.
- The welcome spec is authoritative for these two screens where it conflicts with the
  foundations document.
- Android is the sole target platform.

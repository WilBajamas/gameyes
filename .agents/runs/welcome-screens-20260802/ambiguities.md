# Ambiguities Report
Source: Week-1 checklist item 6 — "Welcome screens" (ticket-style requirement, ref `W1-6`), read against `.agents/references/onboarding-welcome-design-spec.md` and `.agents/references/system-foundation-specs.md`
Date: 2026-08-02
Status: All CRITICAL items resolved by the human on 2026-08-02. Pipeline clear to
proceed — `tech-ac.md` written. `escalation.md` was cleared by the Orchestrator and
confirmed absent from the run folder; the BA Agent did not delete it and has not
recreated it.

## CRITICAL (all resolved — recorded here as an audit trail, none open)

CRITICAL-1: [W1-6] — The app already ships a different onboarding flow, and the
requirement did not say what happens to it.
  `lib/features/onboarding/presentation/screens/onboarding_screen.dart` is a live
  three-page Lottie flow. It owns `OnboardingRoute`, is what `OnboardingGuard` sends
  first-run users to, writes the seen-flag `StorageConstants.firstUseKey`
  (`'first_use'`), and depends on `page_view_item.dart`, three Lottie assets and three
  localised strings. Design spec §1 states "Two screens, never three". Undecidable
  from the requirement whether this run replaced it or added a second flow beside it.
  **RESOLVED 2026-08-02 — full replacement.** Delete `onboarding_screen.dart`,
  `page_view_item.dart`, `assets/animations/onboarding_anim_1–3.json` and the three
  `onboarding_description_one/two/three` keys from both `.arb` files. Repoint
  `OnboardingRoute` at the new two-screen welcome flow. Reuse the existing
  architecture, file names and route names where they fit rather than inventing new
  ones. Reuse `StorageConstants.firstUseKey` (`'first_use'`) — no new key.

CRITICAL-2: [W1-6] — The screens' copy was not specified, and no agent on this project
can add a user-facing string that compiles.
  The design spec fixes the two headlines, two chip labels and the three stat figures,
  but not the two body sentences, the three stat-bar labels, the social-proof line, the
  countdown title, the three countdown unit labels or the final action label. Compounded
  by `handover.md` gotcha #1: `lib/generated/l10n.dart` comes from the Flutter Intl IDE
  plugin, there is no CLI, and an agent adding a key **cannot make the code compile**.
  **RESOLVED 2026-08-02 — agent drafts the copy.** Because the old flow is being
  replaced outright rather than kept alongside, the human authorised drafting all
  missing copy directly, in English against the spec's §8 / §4 voice rules, and drafting
  the `intl_zh.arb` Chinese in the same pass rather than deferring it. `Get started` is
  confirmed as the final action label. The drafted strings are specified in `tech-ac.md`
  under `[W1-6.32]`. The manual IDE regeneration step remains required before the branch
  will build, and is recorded in `tech-ac.md` as an **expected manual step, not a
  defect**.

CRITICAL-3: [W1-6] — "Use the design tokens from the theme extension — no raw hex
values" was not satisfiable; roughly half the spec's values had no token.
  Missing from the merged item-4 layer: `#8a2f86`, the key-art wash, the glass fills,
  both ambient-circle colours, the cover tint, four display sizes, the headline's caps /
  tracking / leading treatment, the body's 1.45 leading, and `radius 5px` — which
  `app_radius_tokens.dart` excluded **by name**.
  **RESOLVED 2026-08-02 — new authoritative reference plus authorised token extension.**
  `.agents/references/system-foundation-specs.md` now supplies every missing value: the
  app-scale type ramp and display tracking (§1.2), the sanctioned `radius 5px` mini-cover
  addition (§1.4, §3.3, §6), and the cover-tile wash `rgba(10,13,58,.42)` (§6). The two
  ambient-circle colours were already given directly in the welcome spec §3a. The human
  has **authorised extending `AppTokens`** with all of these as an onboarding-scoped set.
  This is an approved, intentional reopening of the merged item-4 layer and is **not**
  scope creep — `tech-ac.md` says so explicitly so the Tech Lead's file allowlist can
  include the token files without a second escalation.
  One value, `--surface-art` / `--surface-art-deep`, still has no numeric value anywhere
  (§2.2, §6) and was confirmed **not needed** by this run — it is for missing-art
  fallback rendering, and this run's cover art is placeholder-drawn rather than a
  fallback case. Do not block on it, do not use it.

CRITICAL-4: [W1-6] — `--shadow-float` and `--blur-glass` had no value anywhere, and
`--shadow-float`'s use contradicted two other reference documents.
  **RESOLVED 2026-08-02 — values supplied, contradiction dissolved.**
  `system-foundation-specs.md` §1.5 gives `--shadow-float`
  `0 3px 68px rgba(69,42,124,0.1)` and §1.6 gives `--blur-glass` `blur(18px)`. There is
  no contradiction: §1.5 defines the shadow as an explicitly named, tightly-rationed
  exception that "lifts one focal element per screen and nothing else", while the
  general "colour steps separate, not lines or shadows" principle (§0.4) governs card
  separation. Both readings stand. The welcome spec's use — exactly one shadow, on the
  focal cover tile — is the sanctioned case.

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: The `330 × 714` device frame, its `38px` radius, its hairline and the
uppercase screen label above it are the mockup's device shell, not app UI, and are not
built. Now directly confirmed rather than inferred: `system-foundation-specs.md` §6
lists `radius 38px` against "device frame" with the note "**Hardware geometry, not a UI
radius**".

ASSUMPTION: "Cover art and key art are placeholder assets at this stage" does not mean
new image files. No cover or key art exists in `assets/images/`, and
`system-foundation-specs.md` §7.3 records that no imagery was supplied. Assuming the
three cover tiles, the three social-proof mini covers and the screen-2 key art are
drawn in-widget from tokens, that no file is added to `assets/` and no `pubspec.yaml`
asset entry changes, and that each is structured so real art swaps in without reshaping
the widget. Assuming further that the **dashed placeholder slot** pattern (§3.3) is
*not* used for cover art — §1.9 reserves dashed slots for third-party brand marks,
which may never be drawn or approximated for licensing reasons. Cover art carries no
such constraint; §7.3 calls it stand-in photography.

ASSUMPTION: The existing `green` token is wrong and this run corrects it.
`app_color_tokens.dart` has `green: Color(0xFF4CAF50)` — Material green 500, evidently a
placeholder chosen when item 4 had no source value. `system-foundation-specs.md` §1.1
gives `--color-green` as `#35ed7e` Electric Green. Assuming the token is corrected to
`#35ed7e` under the same authorisation that reopens the token layer. Low risk: nothing
in the app consumes `green` today, since the component library is week 2. Flagged
loudly because it changes an existing merged token value rather than adding a new one.

ASSUMPTION: Where the welcome spec and `system-foundation-specs.md` disagree on a
detail, the welcome spec wins for these two screens. `system-foundation-specs.md`
states this precedence itself in its scope note ("Surface conventions live in sibling
docs and take precedence for their own screen"). The one live instance: the focal
cover's status chip carries a **5px** dot per welcome spec §3a, against the on-media
**6px** dot in §3.3. Building 5px.

ASSUMPTION: The screen-2 countdown title is invented stand-in content matched to the
placeholder key art, not a real release. Assuming a clearly fictional title that cannot
collide with a real trademark, swapped out when real key art lands.

ASSUMPTION: The three stat figures (`312`, `1,204`, `7`) are rendered as literal
display strings and are **not** localised. They are illustrative placeholder values, not
data, and §3b states "Numbers are the copy". This avoids three further `.arb` keys.

ASSUMPTION: Chinese copy carries no uppercase treatment. The spec's ALL-CAPS headline
and `.1em`-tracked caps micro-labels are Latin-script instructions; Chinese has no case,
so `AppTextToken.uppercase` is a no-op there and no separate style is needed.

ASSUMPTION: The `lottie` dependency stays in `pubspec.yaml` even though
`page_view_item.dart` is its only consumer and is being deleted. Removing a now-unused
dependency is a `pubspec.yaml` change this run is not authorised to make, and week-1
item 11 (cleanup) explicitly forbids dependency changes in its own run. Assuming the
orphaned dependency is left for a later cleanup rather than removed here.

ASSUMPTION: Both `Skip` on screen 1 and `Get started` on screen 2 record onboarding as
seen. §1 calls Skip an exit from the flow, and the existing `skipClicked()` already sets
the flag, so a Skip that left it unwritten would return the user to onboarding next
launch — the outcome the requirement forbids.

ASSUMPTION: The seen-flag is device-local, not per-account. It lives in
`SharedPreferences` and survives sign-out. Corroborated by item 8: "A user who has
completed onboarding but signed out should land on the auth screen, not on welcome
screen 1" — which a per-account flag could not satisfy, being unreadable while signed
out.

ASSUMPTION: The flag is written only on deliberate exit, via Skip or Get started. A user
who kills the app on screen 1 sees the flow again from screen 1; there is no
partial-progress state.

ASSUMPTION: The destination after the flow ends is the current post-onboarding
destination (`HomeRoute`), not the auth screen. The auth screen is item 7 and does not
exist; the auth-aware guard is item 8. This run introduces no auth wiring.

ASSUMPTION: The screen-2 countdown shows fixed illustrative values with no timer and no
data source. §7 states the welcome screens are static by default and there is no
wishlist or IGDB data in this run. The digits do not tick.

ASSUMPTION: Advancing screen 1 → screen 2 uses the existing `screenTransition` (420ms)
and `screenTransitionCurve` (`Cubic(0.16, 1, 0.3, 1)`) tokens, which already match §7 and
`system-foundation-specs.md` §1.7 exactly, collapsing to zero duration under reduced
motion via the existing `AppMotionTokens.resolve`.

ASSUMPTION: The ambient circles do not animate. §7 states `ql-breathe` is "currently
unused on welcome and should stay that way".

ASSUMPTION: The green primary action is a widget local to the onboarding feature,
composed from tokens. The design system `Button` named in §5 is **not** created — the
component library is week 2, and no catalogue widget matches the spec's 44px minimum,
black-on-green label and `scale(0.97)` press.

ASSUMPTION: Android system back moves screen 2 → screen 1; on screen 1 it follows the
platform default and does not record onboarding as seen. No back affordance is drawn.

ASSUMPTION: The spec's absolute offsets (`top:54px`, `bottom:34/88/96/112px`, hero
heights 400 and 356) are authored against the 714px reference frame. Assuming they are
honoured there and that the layout must not overflow on shorter viewports or at
increased text scale, with the hero panel absorbing the difference.

ASSUMPTION: Coverage is widget tests under `test/widget/onboarding/` per
`testing-conventions.md`'s by-layer grouping. No golden tests — forbidden by
`handover.md` gotcha #5.

ASSUMPTION: No analytics, telemetry or event tracking is attached to the flow. None is
mentioned and none exists in the project today.

ASSUMPTION: Android only, portrait. No iOS criterion and no landscape layout, per
`project-conventions.md`'s platform-target section.

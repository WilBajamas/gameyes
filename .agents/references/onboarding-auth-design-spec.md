# Onboarding — Auth screen design convention

Scope: the single **auth** screen (`SIGN IN`) that follows the two welcome screens.
Welcome screens are documented in `onboarding-welcome-design-spec.md`; splash is separate.

Source of truth: `QuestLoggd App.dc.html`. Tokens from the QuestLoggd Design System bundle;
local additions flagged in §8.

---

## 1. Principle — social only, zero setup

One decision on this screen: **which account you already have.** There is no email/password
path, no account creation, no genre or platform questionnaire, and no library-import offer.
Everything configurable happens after the user is inside the app.

**Two providers. Android only — v1 does not ship iOS.**

| Order | Provider | Treatment |
|---|---|---|
| 1 | Discord | Design system `Button` `variant="primary"` (Royal Indigo). The only filled row. |
| 2 | Google | Raised chip, `#2f333c` |

Discord is first and is the only filled button — it is the gaming-native identity and the
brand's own indigo. Google is the quiet alternative.

**Green is not used on this screen.** With only two options and no single highest-intent
action, the green CTA is withheld rather than spent arbitrarily.

Two rows is a decision, not a list. Adding a third means justifying it against that rule.

> **Reduced to two, 2026-07-30.** This screen briefly specified Apple, Discord, Google and
> Twitch. Both removals are recorded rather than erased, because both reverse:
>
> - **Twitch — deferred (TBD).** Retained briefly on the belief that IGDB required it. It does
>   not: IGDB authenticates through Twitch's *developer* OAuth as a server-to-server
>   credential, unrelated to end-user login, and that credential moves server-side entirely
>   with the IGDB Edge Function proxy. The Twitch developer app is still needed for the API
>   credential; the login row is not.
> - **Apple — dormant until iOS ships.** Required by App Store Review Guideline 4.8, which has
>   no Play Store equivalent. v1 is Android-only (see `project-conventions.md`), so it is not
>   required and cannot be built or tested on a Windows machine. **§5a below is written and
>   parked** — when iOS ships, Apple returns at position 1 and takes co-equal emphasis with
>   Discord, because Apple's HIG requires its button be at least as prominent as any other.

There is no email/password path and no account creation form. Social sign-in makes sign-in and
sign-up the same act, which is why the headline is `SIGN IN` rather than "Welcome back".

---

## 2. Frame

Same device frame as the welcome screens (`onboarding-welcome-design-spec.md § 2`) —
`330 × 714`, `border-radius: 38px`, onyx fill, `1px` ink-12 hairline — so the flow
reads as one surface. What differs here:

- No hero panel — this screen has no colour field, no cover art, no ambient circles.
  After two image-heavy welcome screens the auth screen goes deliberately quiet.
- Single content column: `flex:1`, `padding: 56px 24px 28px`, `gap: 16px`, top-anchored.

The `56px` top padding replaces the hero — it is the breathing room that signals a change
of mode from marketing to transaction.

---

## 3. Header — logo lockup

A single centred logo placeholder, no wordmark beside it.

- `88 × 88`, `border-radius: 20px`, centred via `justify-content: center` on its row
- Fill `var(--color-ink-12)`, `1px dashed rgba(255,255,255,.24)`
- Label: display 700, `14px`, `letter-spacing:.16em`, `--color-ink-55`, reading `LOGO`

**This is a reserved slot, not a design.** The design system states no logo or wordmark
exists; the dashed outline is the explicit signal that real art must be dropped in. When a
real mark ships, replace the span with the SVG at the same 88px box and drop the dashed
border. The word `QuestLoggd` in Space Grotesk 700 remains the sanctioned text stand-in
elsewhere in the app, but this screen shows the mark alone — the app name is already
established by the two screens before it.

---

## 4. Title block

`gap: 8px`, left-aligned:

1. **Headline** — display 700, `32px`, `line-height:1.05`, `letter-spacing:-0.01em`,
   ALL-CAPS, `--color-ink`. Two words: `SIGN IN`. Not "Welcome back" — the user may be new,
   and social auth makes sign-in and sign-up the same act.
2. **Lead** — `15px/1.45`, `--color-ink-70`, one sentence.
   Its job is to pre-empt the fear of a setup wizard: *"No setup questions. Genres and
   platforms happen inside."*

`32px` here is one step below the welcome screens' `34px` — the auth screen is a step, not a
pitch.

---

## 5. Provider rows

Stacked column, `gap: 10px`, all rows full-width and `52px` tall (above the 44px minimum hit
target). Two rows — `2 × 52 + 10 = 114px`, comfortably inside the `714px` frame.

- **Discord** — design system `Button`, `variant="primary"`, `full-width`. Children are an
  `inline-flex` row with `gap:10px` so the mark and label stay optically centred together.
- **Google** — `52px` row, `--radius-sm`, fill `#2f333c` (raised step above onyx), content
  centred, label `15px/500` in `--color-ink`.

### 5a. Apple row — vendor-controlled chrome — ⏸ PARKED, NOT BUILT IN v1

> **Do not implement.** v1 is Android-only, so Sign in with Apple is not required and cannot
> be built or verified on this project's toolchain. This section is retained, fully specified,
> so that when iOS ships the design decision does not have to be rediscovered. Apple returns
> at position 1 with co-equal emphasis to Discord.

The only row whose appearance this system does not own. Apple's Human Interface Guidelines
mandate the button style, corner radius range, mark, clear space, and permitted wording; the
mark may not be recoloured, redrawn, or substituted.

- Use **black** (`SignInWithAppleButton.Style.black`) — the only variant that sits correctly
  on onyx. White and outline variants are for light surfaces.
- Wording: `Continue with Apple`, which Apple permits and which matches the other three rows.
- Height `52px` and full width to match the stack. Corner radius follows `--radius-sm` (12px),
  which falls inside Apple's permitted range.
- Do **not** apply the global `scale(0.97)` press state or the `brightness(1.08)` hover — the
  native button owns its own pressed state.

This is the doc's own escape clause in action: *"if any provider's brand guidelines forbid the
current row treatment, that row's chrome changes, not the layout."* Apple's does; the layout
holds.

Each row carries a **provider mark placeholder** at the left of its label:

- `20 × 20`, `--radius-xs`
- Fill `rgba(255,255,255,.18)`, `1px dashed rgba(255,255,255,.32)`

Same reserved-slot logic as the header. Official provider marks are third-party trademarks —
they are **not** drawn or approximated in this system. Drop the licensed SVGs into these boxes
at 20px; nothing else changes. Until then the dashed square is honest about being empty, which
is why a generic outline icon (globe, screen, etc.) is explicitly rejected: a wrong glyph reads
as a bug, an empty slot reads as pending.

Labels are the full `Continue with {Provider}` phrasing on all three rows — never a bare
provider name, and never mixed forms across rows.

---

## 6. Footer copy

Two paragraphs, both `--color-ink-55`:

1. **Scope reassurance** — `13px/1.5`, left-aligned, directly under the rows:
   *"We only read your name and avatar. Nothing gets posted."* This sits next to the buttons,
   not in the legal footer, because it changes the decision.
2. **Legal** — `12px/1.5`, `text-align: center`, pushed to the bottom edge with
   `margin: auto 0 0`. Terms and privacy policy are inline `<a>` links in `--color-link`.

The `margin-top:auto` is what makes the legal line hug the bottom while everything above stays
top-anchored — the screen has one hinge, not two.

---

## 7. States & motion

- **Press** — global `scale(0.97)`, no colour change.
- **Hover** — Discord brightens (`brightness(1.08)`); Google/Twitch rows lift toward
  `--color-ink-12`.
- **Focus** — 2px `--color-green` outline at 2px offset. This is the only green on the screen.
- **Loading** — a tapped row keeps its fill and label; do not swap in a spinner-only state.
- **Error** — provider failures use the error-state field/action conventions in
  `system-foundation-specs.md` (`#f8443c` signal, `#ff8f88` body). No error styling lives on this
  screen by default.
- The authentication screen has no entrance tween. Route navigation owns any
  transition into the screen. Press feedback must respect reduced-motion settings.

---

## 8. Local additions (pending promotion)

| Value | Where | Note |
|---|---|---|
| `#2f333c` | Google / Twitch row fill | Lightness step above `--color-surface-onyx`; no hue shift. |
| `rgba(255,255,255,.24)` | header slot border | Literal — `--color-ink-24` does not exist in the system. |
| `rgba(255,255,255,.18)` / `.32` | provider mark slots | Placeholder fill + border, removed when real marks land. |
| `radius 20px` | header logo slot | Between `--radius-lg` (16) and the 40px panel radius. |

---

## 9. Replacement checklist

Before ship, all placeholders must be resolved:

- [ ] `88px` app mark — use the global solid-border `LogoPlaceholder` until the
      final app mark is supplied.
- [x] `20px` Discord mark — `assets/icons/discord-logo.png`
- [x] `20px` Google mark — `assets/icons/google-logo.png`. Render the official
      asset as-is without recolouring.
- ⏸ Apple mark — not needed in v1. When iOS ships it is **not** a placeholder slot: it is
      supplied by the native `SignInWithAppleButton` and is never drawn, traced, or
      approximated.

Provider marks are trademarks, but every vendor publishes brand guidelines that **expressly
permit** their use in sign-in buttons — that is the marks' intended purpose. Using the official
asset within the stated rules is not infringement; drawing an approximation of one is the thing
that creates risk, which is why the reserved-slot convention exists.

If any provider's brand guidelines forbid the current row treatment (fill colour, label
wording, mark size), that row's chrome changes, not the layout.

---

## 10. Flutter composition

- `AuthScreen` directly owns `BlocProvider`, `Scaffold`, `SafeArea`,
  `CustomScrollView`, and `SliverFillRemaining`.
- Do not introduce an `_AuthView` passthrough.
- `_AuthContent` owns the lowest `BlocBuilder` boundary because it contains the
  state-dependent authentication content.
- `_LegalFooter` and `_ProviderActionButton` are cohesive feature-private widgets
  stored in separate files under `auth/presentation/widgets/`.
- `LogoPlaceholder` is a global reusable widget under `lib/widgets/`. It accepts
  explicit width and height and uses a solid border.
- `AppWebView` is routed directly. Do not add a `LegalWebViewScreen` passthrough.

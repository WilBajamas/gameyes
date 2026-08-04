# Ticket — Welcome screens header rework (item 6.1)

Source: Week-1 item 6.1, a minor rework of the already-shipped welcome screens
(item 6, merged via PR #20). Ticket ID `W1-6.1R`.

## Context

Item 6 built both welcome-screen heroes as fully composed widgets: screen 1 was
a fanned cover-tile stack plus a glass stat pill; screen 2 was key art plus a
title and a live-looking countdown. Both carried a small glass context chip and
1-2 ambient decorative circles. All of that was specified in
`.agents/runs/welcome-screens-20260802/tech-ac.md`.

The product owner has since decided to replace both hero **contents** with
flat PNG art instead of composing them from widgets — less risk, less
maintenance, less code. Three new assets already exist on disk:

- `assets/images/welcome-1-header.png` — the complete screen 1 hero content
  (replaces the cover-fan tiles, the "Playing" status chip, the stat pill, and
  the context chip — all baked into this one image now).
- `assets/images/welcome-2-header-bg.png` — the screen 2 hero **background**
  image (replaces the flat `#8a2f86` fill).
- `assets/images/welcome-2-header.png` — the complete screen 2 hero content
  (replaces the key art, wash, title text, countdown tiles, and context chip —
  all baked into this one image now).

`assets/images/` is already registered under `pubspec.yaml`'s `flutter: assets:`
list, so no dependency or asset-path change is needed.

## This ticket supersedes, from `welcome-screens-20260802/tech-ac.md`

`[W1-6.13]` (ambient circles), `[W1-6.14]` (context chip as a widget), `[W1-6.16]`
through `[W1-6.19]` (screen 1 hero composition), `[W1-6.20]` through `[W1-6.23]`
(screen 2 hero composition, including the social-proof row). Every other
criterion in that document — shared frame, copy block, motion, persistence,
navigation, accessibility, tests, platform, and the parts of localisation not
listed below — remains valid and unchanged; do not re-derive them, reference
them.

## Requirements

1. **Hero container stays a widget.** Both heroes remain a code-rendered
   container with the existing directional bottom radius (`0 0 88 88`, the
   `heroShape` token) — this does not become an image. Screen 1's container
   fill stays the existing `surfaceIndigoPanel` (`#2f3782`) flat colour.
   Screen 2's container fill becomes `welcome-2-header-bg.png`.
2. **Content image, centered.** Each screen's content PNG
   (`welcome-1-header.png` / `welcome-2-header.png`) is centered within its
   hero container. Screen 1 has no separate background image, only its
   existing flat fill plus the centered content PNG.
3. **Remove the ambient circles** from both heroes entirely — no neutral or
   accent circle on either screen.
4. **Remove the context chip, status chip, stat pill, cover-fan tiles, key art,
   wash, title text, and countdown tiles as separate widgets** — all now part
   of the flat content images. None of that composition is rebuilt.
5. **Remove the social-proof row** ("3 more on your wishlist this autumn",
   with its three overlapping mini covers) from screen 2's copy block
   entirely. Nothing replaces it — the copy block goes straight from the hero
   to the progress dots.
6. **Countdown is no longer dynamic in any sense** — it was already static
   illustrative numbers per the original run; now it isn't a widget at all, so
   there's nothing to verify about timers, which is a simplification, not a
   regression.
7. Everything else about the two screens — the shared frame (hero, then a
   bottom-anchored copy block, no divider), progress dots, headline, body,
   action rows (Next + Skip on screen 1, Get started alone on screen 2), press
   and focus states, screen-transition motion, reduced-motion collapse, the
   `first_use` persistence flag and its timing, post-onboarding navigation,
   accessibility, and Android-only scope — is unchanged from item 6. Preserve
   all of it.

## Needs a decision: unused localisation keys

These keys exist in both `.arb` files from item 6 and rendered text that is
now baked into the images instead: `welcome_chip_one`, `welcome_chip_two`,
`welcome_stat_tracked`, `welcome_stat_hours`, `welcome_stat_playing`,
`welcome_social_proof`, `welcome_countdown_title`, `welcome_countdown_days`,
`welcome_countdown_hours`, `welcome_countdown_minutes`. Recommend removing all
ten from both `intl_en.arb` and `intl_zh.arb`, matching the precedent item 6
itself set when it removed the old `onboarding_description_*` keys — but this
is a call for the Tech Lead/BA to make explicit, not assume. Keys that stay:
`welcome_headline_one/two`, `welcome_body_one/two`, `next`, `skip`,
`get_started` — their widgets are unchanged.

## Not in scope

No change to `pubspec.yaml`. No change to the token layer's *values* (existing
tokens like the ambient-circle colours, glass fills, and countdown colon may
become unused — that's acceptable, do not spend effort pruning them in this
run). No change to routing, the `OnboardingGuard`, or persistence logic. No
change to screen 1's background (it keeps its existing flat colour, no image).

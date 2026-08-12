# Ambiguities Report
Source: Week 2 task brief item 1.3 + `system-foundation-specs.md` §3.3 "Cover tile" (with §0, §1.1, §1.3, §1.4, §2.2, §2.6, §3.2, §5, §6)
Date: 2026-08-12

## CRITICAL (pipeline blocked — requires human decision before proceeding)
NONE

Two candidates were examined and both resolve from context:

1. **Flat wash vs. gradient veil.** §3.3 says "flat indigo wash";
   `home-screen-design-conventions.md` §3.1 spec's the same `112×150` cover with an
   indigo→canvas *gradient* veil, and `game-detail-design-conventions.md` §2 carries an
   open decision about a hero ramp. Resolved: §2.6 and §1.1 are colour law — "the app
   screens use flat fills only — no gradient mesh, no scrim gradients", and
   `system-foundation-specs.md` declares itself the single source of truth for component
   anatomy. The one tokenised value for this exact use (`coverWash`, `rgba(10,13,58,.42)`,
   logged in §6 as "cover tile wash") is a flat fill. The open game-detail decision is
   about the *hero key art* ramp, not this primitive. Nothing to decide here; the
   reconciliation is owed when Home's hero adopts the tile, not now.

2. **Missing-art fallback.** §3.2 (Game card) says "onyx fill + hairline + gamepad glyph,
   never a title initial"; §2.2 says the art surfaces stand behind cover imagery "so a
   failed image load still reads as a brand block". Resolved: §3.2 is the component-level,
   cover-specific rule and item 1.3's whole purpose is to be the game card's cover
   treatment; §2.2 is background rationale for tokens that do not exist in
   `app_color_tokens.dart` at all (`surfaceArt` / `surfaceArtDeep` were never added, while
   onyx and `hairline` both are). Taking §3.2 also needs no new token.

## ASSUMPTIONS (minor — pipeline may proceed)
ASSUMPTION: The wash is flat, at one opacity across the whole tile, per the reasoning above.
The existing `coverWash` token is used as-is; no gradient, no per-size opacity.

ASSUMPTION: Missing art renders §3.2's onyx fill + hairline + gamepad glyph, per the
reasoning above. This supersedes the current `error_404.png` fallback pattern for this
component only — `lib/widgets/game_item.dart` and the `flutter-widgets` skill's
"local/asset fallback" note keep their behaviour until item 2.1 runs.

ASSUMPTION: A null URL, an empty URL and a load failure are one path, not three. The tile
cannot distinguish "no art on the record" from "art failed to fetch" in a way that changes
what should be drawn, and §3.2 gives one fallback.

ASSUMPTION: The gamepad glyph comes from the icon set already compiled into the app
(`Icons.videogame_asset` is used in four places today). §1.9's Lucide requirement is a web
concern — no Lucide package is in `pubspec.yaml`, and adding one for a single glyph fails
the "reach for a package only on a real gap" rule.

ASSUMPTION: The glyph is omitted at the `mini` size. A 26×34 box holds a legible glyph only
if the glyph eats the whole tile; the mini fallback is the onyx fill + hairline alone.
Flagged for Tech Lead to overturn cheaply if it disagrees.

ASSUMPTION: The four sizes are literal fixed dimensions (`26×34`, `112×150`, `100×134`,
`124×166`), not aspect ratios. None of them is exactly 3:4, so deriving them from a ratio
would silently change three of the four numbers.

ASSUMPTION: The size set is closed — no arbitrary width/height parameter. §0.1 is "sized
rather than redrawn", and no caller exists in this run. Note for item 2.1: the game card's
`xs 64 / sm 132 / md 220+` widths are not in this set, so 2.1 either adds a size or sizes
covers itself — that is 2.1's call, not a gap to pre-solve here.

ASSUMPTION: The wash and the saturate/contrast treatment apply to loaded imagery only. The
fallback is already a designed flat surface; washing it would just darken a token colour.

ASSUMPTION: The status chip slot is the on-media variant of the existing chip primitive
(item 1.2), inset from the bottom-left corner by 8px (§1.3 scale — the spec gives no inset).
`mini` gets no chip: an 11px label pill does not fit a 26×34 tile.

ASSUMPTION: Loading shows a shimmer/skeleton block at the tile's exact size and radius, not
the spinner that `DefaultCachedNetworkImage` currently draws. §3.2 is explicit — "shimmer
skeletons shaped like their content... never spinners" — and `skeletonizer` is already a
dependency. The existing widget's spinner and error-icon behaviour is not changed for its
six current callers.

ASSUMPTION: The tile is display-only — no tap, no hero tag. §3.3 gives it no interaction,
covers are tapped through the card that contains them (item 2.1), and the hero-transition
pattern is owned by the caller that knows the game id and source screen.

ASSUMPTION: §1.8's press and hover treatments are not built — Android-only target, and §1.8
itself says "media tiles do not move".

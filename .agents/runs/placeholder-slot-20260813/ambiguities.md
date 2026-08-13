# Ambiguities Report
Source: Week 2 task brief item 1.4 + `system-foundation-specs.md` §3.3 "Placeholder slot" (with §1.2, §1.4, §1.9, §6, §7.2) + `onboarding-auth-design-spec.md` §3, §5, §8, §9, §10
Date: 2026-08-13

## CRITICAL (pipeline blocked — requires human decision before proceeding)
NONE

Three candidates were examined; all three resolve from the requirement text and the specs.

1. **Solid vs dashed border — a direct doc conflict.** `system-foundation-specs.md` §3.3
   and `onboarding-auth-design-spec.md` §3 both specify `1px dashed rgba(255,255,255,.24)`,
   but the same auth doc's §9 replacement checklist ("use the global **solid-border**
   `LogoPlaceholder`") and §10 Flutter-composition note ("accepts explicit width and height
   and **uses a solid border**") describe the widget as solid — and a sibling surface doc
   normally takes precedence for its own screen. Resolved: the week-2 checklist names the
   solid border as *the defect this item exists to fix*, and §3.3 is the designated source
   of truth for component anatomy. §9 and §10 are records of an interim implementation, now
   stale — they are corrected in this run ([1.4-AC15]), not obeyed.

2. **Provider mark slot fill/border values.** §3.3 gives one anatomy for both presets
   (`ink12` fill, `rgba(255,255,255,.24)` border); `onboarding-auth-design-spec.md` §5 and
   §8 give the provider slot `rgba(255,255,255,.18)` fill and `.32` border. Resolved to
   §3.3: §0.1 is "one anatomy per concept, sized rather than redrawn", the presets differ
   only in size and radius, and no `.18`/`.32` ink tokens exist in `app_color_tokens.dart`
   while `ink12`/`ink24` both do. The §5 values also have no live consumer — both provider
   rows render licensed PNG marks today.

3. **Building the provider mark preset with no caller.** The `flutter-widgets` convention
   says "no parameter, variant, or branch for a case nothing calls yet", and nothing calls a
   20px slot: Discord and Google use real assets, Apple is parked. Resolved as in scope
   anyway — the requirement text defines the item as constraining the widget to *the spec's
   two presets*, so the second preset is the requirement, not speculation. It ships unwired
   ([1.4-AC13]). Flagged for Tech Lead: if it judges the unwired preset dead code, that is a
   cheap reversal at Phase 2, not a rebuild.

## ASSUMPTIONS (minor — pipeline may proceed)
ASSUMPTION: This is an in-place rework of `lib/widgets/logo_placeholder.dart`, not a new
widget beside it. Its one caller (`auth_screen.dart`) is migrated in the same run, so no
`@Deprecated` alias is left behind — the convention's deprecation step covers a full rebuild
that leaves callers on the old widget, which does not apply to a single in-repo caller.

ASSUMPTION: The widget is renamed to something categorical for what it is (a reserved
placeholder slot). "Logo" describes one of its two presets, and the provider preset renders
no logo. Exact name is Tech Lead's.

ASSUMPTION: `88` and `20` are square boxes (88×88, 20×20). The spec gives one number each,
and the auth doc states `88 × 88` and `20 × 20` explicitly.

ASSUMPTION: The app mark radius stays the literal `20` — it is not in the radius scale
(`xs` 6 · `mini` 5 · `sm` 12 · `lg` 16 · `xl` 40) and §6 logs it as a local addition
pending promotion. No new radius token is added. The provider mark uses the existing `xs`
token (6), which is what `r-xs` means.

ASSUMPTION: Dash and gap lengths are unspecified in every doc. One dash pattern serves both
presets, chosen so the 20px box still reads as dashed rather than as a broken solid line.
Border width is the specified 1 logical pixel.

ASSUMPTION: The label follows §3.3's display face 700 caps, at the only numbers any doc
gives — `onboarding-auth-design-spec.md` §3's 14px, `+.16em`, `ink55`. The current
`microLabel` token (Inter 10/500, `ink70`) is the body face and does not satisfy "display
700"; §1.2's micro-label ramp permits either face, but §3.3's component anatomy is the
specific rule here.

ASSUMPTION: The marker text stays the literal `LOGO` inside the widget, not localised and
not a constructor parameter. It is placeholder chrome that gets deleted when real art lands
(§7.2), there is one caller, and preserving it keeps `test/widget/auth/auth_screen_test.dart:52`
(`expect(find.text('LOGO'), findsOneWidget)`) passing. Cheap for Tech Lead to promote to a
parameter if a second caller appears.

ASSUMPTION: The provider mark preset renders no label — a 14px caps word does not fit a 20px
box, and §5 describes that slot as fill + border only.

ASSUMPTION: The slot is display-only: no tap, no press state, no semantics work. §3.3 gives
it no interaction and the current widget has none.

ASSUMPTION: No new third-party dependency. Flutter has no dashed-border primitive, but
`pubspec.yaml` is read-only to pipeline phases unless the task brief allowlists it, so the
dash is drawn with what the repo already has. If Tech Lead judges a package genuinely
necessary, that is a recorded deviation, not a silent addition.

ASSUMPTION: This run rewires only `auth_screen.dart`, because the API change (width/height →
preset) breaks its call site. Blast radius is one file, one line, plus one existing test.

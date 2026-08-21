# Code Plan
Source: Week 2 task briefs items 1.8, 1.9 (combined run) · `tech-ac.md` 2026-08-20
Date: 2026-08-20

## CREATE NEW

### lib/widgets/progress_dots.dart

```dart
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class ProgressDots extends StatelessWidget {
  const ProgressDots({super.key, required this.count, required this.activeIndex})
    : assert(count >= 1, 'A progress row needs at least one dot.'),
      assert(
        activeIndex >= 0 && activeIndex < count,
        'The active dot must be one of the dots being drawn.',
      );

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    // min + spacing keeps the gap between dots only: nothing before the first
    // dot, nothing after the last, and the row stays at its content's width.
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: List.generate(
        count,
        (index) => _Dot(active: index == activeIndex),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      width: active ? 22 : 5,
      height: 5,
      decoration: BoxDecoration(
        color: active ? tokens.color.ink : tokens.color.ink12,
        borderRadius: BorderRadius.circular(tokens.radius.pill),
      ),
    );
  }
}
```

### lib/widgets/action_row.dart

```dart
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/button_press_scale.dart';

class ActionRow extends StatelessWidget {
  const ActionRow({
    super.key,
    required this.label,
    required this.markAsset,
    required this.fill,
    required this.enabled,
    required this.loading,
    required this.loadingLabel,
    required this.onPressed,
  });

  final String label;
  final String markAsset;
  final Color fill;
  final bool enabled;
  final bool loading;
  final String loadingLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Semantics(
      button: true,
      enabled: enabled,
      child: IgnorePointer(
        ignoring: !enabled,
        child: ButtonPressScale(
          onPressed: onPressed,
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(tokens.radius.sm),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    markAsset,
                    width: 20,
                    height: 20,
                    semanticLabel: label,
                  ),
                  const SizedBox(width: 10),
                  // Flexible, not Expanded: the mark and label read as one
                  // centred pair, and Expanded would push the mark to the edge.
                  Flexible(
                    child: Text(
                      label,
                      // body carries no colour of its own, so pin the one it
                      // resolves to today rather than inherit from wherever
                      // this row is placed.
                      style: tokens.typography.body.style.copyWith(
                        color: tokens.color.ink70,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (loading) ...[
                    const SizedBox(width: 10),
                    SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        semanticsLabel: loadingLabel,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

## MODIFY EXISTING

### lib/features/onboarding/presentation/widgets/welcome_container.dart

```dart
// + import 'package:gaming_library_assessment_flutter/widgets/progress_dots.dart';

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // was: Row(children: [Container(...), SizedBox(width: 6),
                      //      Container(...)])  — lines 57-81
                      ProgressDots(count: 2, activeIndex: isFirstStep ? 0 : 1),
                      SizedBox(height: isFirstStep ? 22 : 18),
                      Text(
                        tokens.typography.welcomeHeadline.format(headline),
                        style: tokens.typography.welcomeHeadline.style,
                      ),
```

### lib/features/auth/presentation/screens/auth_screen.dart

```dart
// - import '.../widgets/button_press_scale.dart';   (unused once the part goes)
// + import 'package:gaming_library_assessment_flutter/widgets/action_row.dart';
   import 'package:gaming_library_assessment_flutter/widgets/placeholder_slot.dart';

   part '../widgets/legal_footer.dart';
// - part '../widgets/provider_action_button.dart';

              ActionRow(
                label: S.current.continue_with_discord,
                markAsset: 'assets/icons/discord-logo.png',
                fill: tokens.color.accentIndigo,
                enabled: !loading,
                loading: state.activeProvider == SignInProvider.discord,
                loadingLabel: S.current.auth_signing_in('Discord'),
                onPressed: () =>
                    context.read<SignInCubit>().signIn(SignInProvider.discord),
              ),
              const SizedBox(height: 10),
              ActionRow(
                label: S.current.continue_with_google,
                markAsset: 'assets/icons/google-logo.png',
                fill: tokens.color.surfaceRaised,
                // ... enabled / loading / loadingLabel / onPressed unchanged
              ),
```

### lib/features/auth/presentation/widgets/provider_action_button.dart

Deleted. Both callers migrate in this run, so no `@Deprecated` shim is kept.

### .claude/skills/flutter-widgets/SKILL.md

Two rows appended to the catalogue table, no existing row touched:

```markdown
| `ProgressDots` | `progress_dots.dart` | Step dots for a paged flow: caller supplies the dot count and which index is active; 22x5 ink pill for the active dot, 5x5 ink-12 for the rest, 6px apart, display-only and unanimated; hugs its content and adds no spacing of its own |
| `ActionRow` | `action_row.dart` | Full-width 52px r-sm row on a caller-supplied flat fill: required 20px leading mark and label centred together as a pair, optional trailing 16px busy indicator, press-scale and focus ring, disabled without dimming; adds no spacing of its own |
```

## TEST FILES

Behaviours only — naming, setup and assertions are Dev's, per `flutter-widget-test`. Pump the real
`buildDarkTheme()` and assert what the widget shows; do not pre-resolve tokens in `setUpAll` to
compare values.

### test/widget/components/progress_dots_test.dart
- renders the requested number of dots
- draws exactly one dot at the active form, at the requested index (the 22-wide one)
- inactive dots are 5x5 and the active dot is 22x5 — §3.3's stated contract
- active dot fills `ink`, inactive dots fill `ink12`
- adjacent dots sit 6px apart with no leading or trailing gap
- the row hugs its content rather than filling the width offered, at 5px tall
- no text and no tap handler anywhere in the tree
- an out-of-range active index fails in debug

### test/widget/components/action_row_test.dart
- draws exactly 52px tall and takes the full width offered
- uses the `sm` radius and the caller's fill
- shows the 20px mark and the label centred together as a pair
- calls `onPressed` once per tap when enabled
- calls nothing when disabled, and looks unchanged
- shows the busy indicator only while loading, keeping the label visible and the height fixed
- shows the label on one line, ellipsised, in a narrow parent

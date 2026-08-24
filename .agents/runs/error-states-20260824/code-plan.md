# Code Plan
Source: `tech-ac.md` (week 2 Stage 2 item 2.7 — Error states)
Date: 2026-08-24

## CREATE NEW

### lib/widgets/error_states/error_dot.dart

```dart
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class ErrorDot extends StatelessWidget {
  const ErrorDot({super.key, required this.size, this.glyph});

  final double size;
  final IconData? glyph;

  @override
  Widget build(BuildContext context) {
    final colors = context.tokens.color;
    final glyph = this.glyph;

    return SizedBox.square(
      dimension: size,
      child: ClipOval(
        child: ColoredBox(
          color: colors.error,
          child: glyph == null
              ? null
              : Center(child: Icon(glyph, size: 12, color: colors.ink)),
        ),
      ),
    );
  }
}
```

### lib/widgets/error_states/enum/error_notice_variant.dart

```dart
enum ErrorNoticeVariant { strip, toast }
```

### lib/widgets/error_states/error_notice.dart

```dart
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_states/enum/error_notice_variant.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_states/error_dot.dart';

class ErrorNotice extends StatelessWidget {
  const ErrorNotice({
    super.key,
    required this.variant,
    required this.message,
    required this.onDismiss,
  });

  final ErrorNoticeVariant variant;
  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      ErrorNoticeVariant.strip => _ErrorStrip(
        message: message,
        onDismiss: onDismiss,
      ),
      ErrorNoticeVariant.toast => _ErrorToast(message: message),
    };
  }
}

class _ErrorStrip extends StatelessWidget {
  const _ErrorStrip({required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.color.errorTint,
        border: Border.all(color: tokens.color.errorLine),
        borderRadius: BorderRadius.circular(tokens.radius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          spacing: 8,
          children: [
            Expanded(
              child: Text(
                message,
                style: tokens.typography.meta.style.copyWith(
                  color: tokens.color.errorInk,
                ),
              ),
            ),
            Semantics(
              container: true,
              button: true,
              label: MaterialLocalizations.of(context).closeButtonTooltip,
              child: InkWell(
                onTap: onDismiss,
                child: SizedBox.square(
                  dimension: 44,
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: tokens.color.errorInk,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorToast extends StatelessWidget {
  const _ErrorToast({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return ClipRRect(
      borderRadius: BorderRadius.circular(tokens.radius.sm),
      child: ColoredBox(
        color: tokens.color.surfaceToast,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            spacing: 8,
            children: [
              const ErrorDot(size: 8),
              Expanded(
                child: Text(
                  message,
                  style: tokens.typography.meta.style.copyWith(
                    color: tokens.color.ink,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### lib/widgets/error_states/destructive_action_pair.dart

```dart
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/primary_button.dart';

class DestructiveActionPair extends StatelessWidget {
  const DestructiveActionPair({
    super.key,
    required this.destructiveLabel,
    required this.safeLabel,
    required this.onDestructive,
    required this.onSafe,
  });

  final String destructiveLabel;
  final String safeLabel;
  final VoidCallback onDestructive;
  final VoidCallback onSafe;

  @override
  Widget build(BuildContext context) {
    final colors = context.tokens.color;

    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: PrimaryButton(
            label: safeLabel,
            onPressed: onSafe,
            backgroundColor: colors.ink08,
            labelColor: colors.ink,
          ),
        ),
        Expanded(
          child: PrimaryButton(
            label: destructiveLabel,
            onPressed: onDestructive,
            backgroundColor: colors.errorStrong,
            labelColor: colors.ink,
          ),
        ),
      ],
    );
  }
}
```

### lib/widgets/error_states/failed_item.dart

```dart
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_states/error_dot.dart';

class FailedItem extends StatelessWidget {
  const FailedItem({
    super.key,
    required this.semanticsLabel,
    required this.child,
  });

  final String semanticsLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Stack(
      children: [
        DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            border: Border.all(color: tokens.color.errorLine),
            borderRadius: BorderRadius.circular(tokens.radius.lg),
          ),
          child: Opacity(opacity: 0.55, child: child),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Semantics(
            container: true,
            label: semanticsLabel,
            child: const ErrorDot(size: 20, glyph: Icons.priority_high),
          ),
        ),
      ],
    );
  }
}
```

## MODIFY EXISTING

### lib/config/theme/tokens/app_color_tokens.dart

```dart
  const AppColorTokens({
    required this.canvas,
    required this.surfaceRaised,
    required this.surfaceIndigoPanel,
    required this.surfaceMagentaPanel,
    required this.surfaceTabChrome,
    required this.surfaceToast,
    required this.accentIndigo,
    // ... unchanged

  // ** Surfaces
  final Color canvas;
  final Color surfaceRaised;
  final Color surfaceIndigoPanel;
  final Color surfaceMagentaPanel;
  final Color surfaceTabChrome;
  final Color surfaceToast;

  static const AppColorTokens dark = AppColorTokens(
    // ...
    surfaceTabChrome: Color(0xFF2E3236),
    surfaceToast: Color(0xFF2E3236),
    // ...
  );

  AppColorTokens copyWith({
    // ...
    Color? surfaceTabChrome,
    Color? surfaceToast,
    // ...
  }) {
    return AppColorTokens(
      // ...
      surfaceTabChrome: surfaceTabChrome ?? this.surfaceTabChrome,
      surfaceToast: surfaceToast ?? this.surfaceToast,
      // ...
    );
  }

  static AppColorTokens lerp(AppColorTokens a, AppColorTokens b, double t) {
    return AppColorTokens(
      // ...
      surfaceTabChrome: Color.lerp(a.surfaceTabChrome, b.surfaceTabChrome, t)!,
      surfaceToast: Color.lerp(a.surfaceToast, b.surfaceToast, t)!,
      // ...
    );
  }
```

### lib/features/game_detail/presentation/screens/game_detail_screen.dart

```dart
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 12),
                  child: Text(
                    S.current.screenshots,
                    style: context.themeData.textTheme.displayLarge,
                  ),
                ),
              ],
            ),
```

Lines 71–73 (the blank line, the `/// TODO: fetch screenshots - from game detail` comment and the
`// DetailScreenshotsSection(id: gameExtra!.$1);` line) are removed. The heading `Padding` above
them and the closing brackets below are untouched. No import is removed — the file never imported
the deleted section.

## DELETE

### lib/features/game_detail/presentation/screens/detail_screenshot_section.dart

Deleted in full (66 lines, 54 of them commented out, live body `return SizedBox.shrink()`).

## TEST FILES

Shape for all three new files: `buildSubject` helper, `MaterialApp(theme: buildDarkTheme())`, the
four localisation delegates, `GoogleFonts.config.allowRuntimeFetching = false`, no comments.
Colour expectations read `AppColorTokens.dark.<token>`.

### test/widget/components/destructive_action_pair_test.dart
- `'fills the destructive action with the errorStrong token'` — the `PrimaryButton` carrying the
  destructive label has `backgroundColor` `AppColorTokens.dark.errorStrong` [2.7-AC5]
- `'keeps the safe action off the error ramp and off green'` — the safe `PrimaryButton`'s
  `backgroundColor` and `labelColor` are neither `errorStrong`, `error`, `errorTint`, `errorLine`
  nor `green` [2.7-AC5], [2.7-AC6]
- `'calls onDestructive once when the destructive action is tapped'` — tap by label text;
  destructive counter is 1 and the safe counter is 0 [2.7-AC8]
- `'calls onSafe once when the safe action is tapped'` — the mirror case [2.7-AC8]

### test/widget/components/error_notice_test.dart
- `'shows the strip and no toast marks when the strip variant is selected'` — scoped under
  `ErrorNotice`: the `DecoratedBox` surface resolves to `errorTint`, and `find.byType(ErrorDot)`
  finds nothing [2.7-AC12]
- `'shows the toast and no strip marks when the toast variant is selected'` — scoped under
  `ErrorNotice`: the `ColoredBox` surface resolves to `surfaceToast`, and `find.byType(Icon)`
  finds nothing [2.7-AC12], [2.7-AC15], [2.7-AC16]
- `'uses the error tint, error line and error ink tokens for the strip'` — surface colour, border
  side colour and the message `Text`'s style colour [2.7-AC13]
- `'calls onDismiss once and leaves the tree when the strip is dismissed'` — harness owns the
  visibility flag; tap the dismiss affordance, counter is 1 and `ErrorNotice` is gone [2.7-AC14]
- `'shows the strip again when rebuilt with the same inputs after a dismissal'` — proves no
  dismissal state is held by the component [2.7-AC14]
- `'shows a dot filled with the error token in the toast'` — scoped through
  `find.byType(ErrorDot)` to its `ColoredBox` [2.7-AC16]
- `'constrains the toast message to a single line'` — the message `Text`'s `maxLines` is 1 and
  its `overflow` is `TextOverflow.ellipsis` [2.7-AC17]

### test/widget/components/failed_item_test.dart
- `'dims the wrapped child to 55 percent'` — the scoped `Opacity`'s `opacity` is 0.55 [2.7-AC22]
- `'draws the surrounding hairline in the errorLine token'` — the scoped `DecoratedBox`'s border
  side colour [2.7-AC22]
- `'fills the badge with the error token'` — scoped through `find.byType(ErrorDot)` [2.7-AC25]
- `'announces the supplied semantics label on the badge'` — either `find.bySemanticsLabel` behind
  a `tester.ensureSemantics()` handle that the test disposes, or the scoped `Semantics` widget's
  `properties.label`; whichever stays shorter [2.7-AC24]
- `'shows no text when wrapping a wordless child'` — `find.descendant(of: find.byType(FailedItem),
  matching: find.byType(Text))` finds nothing, with a non-`Text` child [2.7-AC23]

### test/widget/theme/app_tokens_test.dart (MODIFY)
- `'should expose the toast surface when reading the dark set'` — `colors.surfaceToast` is
  `const Color(0xFF2E3236)` [2.7-AC3]
- Extend the existing surfaces group with a separate assertion that `colors.surfaceTabChrome` is
  still `const Color(0xFF2E3236)` [2.7-AC2], [2.7-AC3]. Leave the "three distinct raised
  surfaces" `Set` at lines 38–50 exactly as it is — `surfaceToast` shares that value on purpose.
- Add `colors.surfaceToast` to the `_allColors` helper list so the "no untokenised colour" scan
  and the `lerp` sweep cover it.

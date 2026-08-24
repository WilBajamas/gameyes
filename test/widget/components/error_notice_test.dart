import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_color_tokens.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_states/enum/error_notice_variant.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_states/error_dot.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_states/error_notice.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildSubject({
    required ErrorNoticeVariant variant,
    String message = 'Something failed',
    VoidCallback? onDismiss,
  }) {
    return MaterialApp(
      theme: buildDarkTheme(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(
        body: ErrorNotice(
          variant: variant,
          message: message,
          onDismiss: onDismiss ?? () {},
        ),
      ),
    );
  }

  testWidgets(
    'shows the strip and no toast marks when the strip variant is selected',
    (tester) async {
      await tester.pumpWidget(buildSubject(variant: ErrorNoticeVariant.strip));

      final surface = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(ErrorNotice),
          matching: find.byType(DecoratedBox),
        ),
      );
      final decoration = surface.decoration as BoxDecoration;

      expect(decoration.color, AppColorTokens.dark.errorTint);
      expect(find.byType(ErrorDot), findsNothing);
    },
  );

  testWidgets(
    'shows the toast and no strip marks when the toast variant is selected',
    (tester) async {
      await tester.pumpWidget(buildSubject(variant: ErrorNoticeVariant.toast));

      expect(
        find.descendant(
          of: find.byType(ErrorNotice),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is ColoredBox &&
                widget.color == AppColorTokens.dark.surfaceToast,
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(ErrorNotice),
          matching: find.byType(Icon),
        ),
        findsNothing,
      );
    },
  );

  testWidgets('uses the error tint, error line and error ink tokens for the '
      'strip', (tester) async {
    await tester.pumpWidget(buildSubject(variant: ErrorNoticeVariant.strip));

    final surface = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(ErrorNotice),
        matching: find.byType(DecoratedBox),
      ),
    );
    final decoration = surface.decoration as BoxDecoration;

    expect(decoration.color, AppColorTokens.dark.errorTint);
    expect(decoration.border!.top.color, AppColorTokens.dark.errorLine);

    final message = tester.widget<Text>(find.text('Something failed'));
    expect(message.style!.color, AppColorTokens.dark.errorInk);
  });

  testWidgets(
    'calls onDismiss once and leaves the tree when the strip is dismissed',
    (tester) async {
      var dismissCount = 0;

      await tester.pumpWidget(
        _DismissibleStripHarness(onDismiss: () => dismissCount++),
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(dismissCount, 1);
      expect(find.byType(ErrorNotice), findsNothing);
    },
  );

  testWidgets(
    'shows the strip content again when rebuilt with the same inputs after '
    'a dismissal',
    (tester) async {
      var dismissCount = 0;

      await tester.pumpWidget(
        buildSubject(
          variant: ErrorNoticeVariant.strip,
          onDismiss: () => dismissCount++,
        ),
      );
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(dismissCount, 1);

      await tester.pumpWidget(
        buildSubject(
          variant: ErrorNoticeVariant.strip,
          onDismiss: () => dismissCount++,
        ),
      );

      expect(
        find.descendant(
          of: find.byType(ErrorNotice),
          matching: find.text('Something failed'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('shows a dot filled with the error token in the toast', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(variant: ErrorNoticeVariant.toast));

    final dotFill = tester.widget<ColoredBox>(
      find.descendant(
        of: find.byType(ErrorDot),
        matching: find.byType(ColoredBox),
      ),
    );

    expect(dotFill.color, AppColorTokens.dark.error);
  });

  testWidgets('constrains the toast message to a single line', (tester) async {
    await tester.pumpWidget(buildSubject(variant: ErrorNoticeVariant.toast));

    final message = tester.widget<Text>(find.text('Something failed'));

    expect(message.maxLines, 1);
    expect(message.overflow, TextOverflow.ellipsis);
  });
}

class _DismissibleStripHarness extends StatefulWidget {
  const _DismissibleStripHarness({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  State<_DismissibleStripHarness> createState() =>
      _DismissibleStripHarnessState();
}

class _DismissibleStripHarnessState extends State<_DismissibleStripHarness> {
  var _visible = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: buildDarkTheme(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(
        body: _visible
            ? ErrorNotice(
                variant: ErrorNoticeVariant.strip,
                message: 'Something failed',
                onDismiss: () {
                  widget.onDismiss();
                  setState(() => _visible = false);
                },
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

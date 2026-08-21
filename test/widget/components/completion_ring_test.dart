import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_color_tokens.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/completion_ring.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildSubject({
    required double value,
    CompletionRingSize size = CompletionRingSize.detail,
    String? caption,
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
        body: CompletionRing(value: value, size: size, caption: caption),
      ),
    );
  }

  CompletionRingPainter painterOf(WidgetTester tester) =>
      (tester
              .widget<CustomPaint>(
                find.byWidgetPredicate(
                  (widget) =>
                      widget is CustomPaint &&
                      widget.painter is CompletionRingPainter,
                ),
              )
              .painter!
          as CompletionRingPainter);

  testWidgets(
    'shows the truncated percentage when the value carries a fraction',
    (tester) async {
      await tester.pumpWidget(buildSubject(value: 99.6));

      expect(find.text('99%'), findsOneWidget);

      await tester.pumpWidget(buildSubject(value: 0.4));

      expect(find.text('0%'), findsOneWidget);
    },
  );

  testWidgets('shows a clamped percentage when the value falls outside 0 to '
      '100', (tester) async {
    await tester.pumpWidget(buildSubject(value: -5));

    expect(find.text('0%'), findsOneWidget);

    await tester.pumpWidget(buildSubject(value: 140));

    expect(find.text('100%'), findsOneWidget);
  });

  testWidgets(
    'switches the arc to accentMagenta only at 100 and leaves the ink12 '
    'track unchanged',
    (tester) async {
      await tester.pumpWidget(buildSubject(value: 99));

      expect(painterOf(tester).progressColor, AppColorTokens.dark.accentIndigo);
      expect(painterOf(tester).trackColor, AppColorTokens.dark.ink12);

      await tester.pumpWidget(buildSubject(value: 100));

      expect(
        painterOf(tester).progressColor,
        AppColorTokens.dark.accentMagenta,
      );
      expect(painterOf(tester).trackColor, AppColorTokens.dark.ink12);

      await tester.pumpWidget(buildSubject(value: 140));

      expect(
        painterOf(tester).progressColor,
        AppColorTokens.dark.accentMagenta,
      );
      expect(painterOf(tester).trackColor, AppColorTokens.dark.ink12);
    },
  );

  testWidgets('shows the percentage at every size and drops the caption at the '
      'inline size', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildDarkTheme(),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                CompletionRing(
                  value: 50,
                  size: CompletionRingSize.inline,
                  caption: 'done',
                ),
                CompletionRing(
                  value: 50,
                  size: CompletionRingSize.specimen,
                  caption: 'done',
                ),
                CompletionRing(
                  value: 50,
                  size: CompletionRingSize.detail,
                  caption: 'done',
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('50%'), findsNWidgets(3));
    expect(find.text('done'), findsNWidgets(2));
  });

  testWidgets('states the clamped percentage in the semantics label', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(buildSubject(value: 37));

    expect(find.bySemanticsLabel('37% completed'), findsOneWidget);

    await tester.pumpWidget(buildSubject(value: -5));

    expect(find.bySemanticsLabel('0% completed'), findsOneWidget);

    await tester.pumpWidget(buildSubject(value: 140));

    expect(find.bySemanticsLabel('100% completed'), findsOneWidget);

    handle.dispose();
  });
}

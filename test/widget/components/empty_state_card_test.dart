import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_color_tokens.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/empty_state_card.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildSubject({
    String headline = 'headline copy',
    String supportingLine = 'supporting line copy',
    String actionLabel = 'action label',
    VoidCallback? onActionPressed,
    IconData? glyph,
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
        body: EmptyStateCard(
          headline: headline,
          supportingLine: supportingLine,
          actionLabel: actionLabel,
          onActionPressed: onActionPressed ?? () {},
          glyph: glyph,
        ),
      ),
    );
  }

  testWidgets(
    'shows the headline in capitals, the supporting line and the action label',
    (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('HEADLINE COPY'), findsOneWidget);
      expect(find.text('supporting line copy'), findsOneWidget);
      expect(find.text('action label'), findsOneWidget);
    },
  );

  testWidgets('calls the action callback once when the action is tapped', (
    tester,
  ) async {
    var tapCount = 0;

    await tester.pumpWidget(buildSubject(onActionPressed: () => tapCount++));
    await tester.tap(find.text('action label'));
    await tester.pump();

    expect(tapCount, 1);
  });

  testWidgets('hides the glyph when none is supplied', (tester) async {
    await tester.pumpWidget(buildSubject());

    expect(
      find.descendant(
        of: find.byType(EmptyStateCard),
        matching: find.byType(Icon),
      ),
      findsNothing,
    );
  });

  testWidgets('fills the card with the surfaceRaised token', (tester) async {
    await tester.pumpWidget(buildSubject());

    final coloredBox = tester.widget<ColoredBox>(
      find.descendant(
        of: find.byType(EmptyStateCard),
        matching: find.byType(ColoredBox),
      ),
    );

    expect(coloredBox.color, AppColorTokens.dark.surfaceRaised);
  });
}

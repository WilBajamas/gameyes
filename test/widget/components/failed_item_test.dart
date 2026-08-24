import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_color_tokens.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_states/error_dot.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_states/failed_item.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildSubject({required Widget child, String? semanticsLabel}) {
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
        body: FailedItem(
          semanticsLabel: semanticsLabel ?? 'Failed to sync',
          child: child,
        ),
      ),
    );
  }

  testWidgets('dims the wrapped child to 55 percent', (tester) async {
    await tester.pumpWidget(
      buildSubject(child: const Icon(Icons.videogame_asset)),
    );

    final opacity = tester.widget<Opacity>(
      find.descendant(
        of: find.byType(FailedItem),
        matching: find.byType(Opacity),
      ),
    );

    expect(opacity.opacity, 0.55);
  });

  testWidgets('draws the surrounding hairline in the errorLine token', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(child: const Icon(Icons.videogame_asset)),
    );

    final hairline = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(FailedItem),
        matching: find.byType(DecoratedBox),
      ),
    );
    final decoration = hairline.decoration as BoxDecoration;

    expect(decoration.border!.top.color, AppColorTokens.dark.errorLine);
  });

  testWidgets('fills the badge with the error token', (tester) async {
    await tester.pumpWidget(
      buildSubject(child: const Icon(Icons.videogame_asset)),
    );

    final dotFill = tester.widget<ColoredBox>(
      find.descendant(
        of: find.byType(ErrorDot),
        matching: find.byType(ColoredBox),
      ),
    );

    expect(dotFill.color, AppColorTokens.dark.error);
  });

  testWidgets('announces the supplied semantics label on the badge', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        child: const Icon(Icons.videogame_asset),
        semanticsLabel: 'Failed to sync',
      ),
    );

    expect(find.bySemanticsLabel('Failed to sync'), findsOneWidget);
  });

  testWidgets('shows no text when wrapping a wordless child', (tester) async {
    await tester.pumpWidget(
      buildSubject(child: const Icon(Icons.videogame_asset)),
    );

    expect(
      find.descendant(of: find.byType(FailedItem), matching: find.byType(Text)),
      findsNothing,
    );
  });
}

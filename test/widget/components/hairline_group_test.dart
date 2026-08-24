import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_color_tokens.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/hairline_group.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildSubject({required List<Widget> children}) {
    return MaterialApp(
      theme: buildDarkTheme(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(body: HairlineGroup(children: children)),
    );
  }

  testWidgets('shows no separator when given a single child', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(children: [const Text('One')]));

    expect(find.byType(Divider), findsNothing);
  });

  testWidgets('shows one separator between two children', (tester) async {
    await tester.pumpWidget(
      buildSubject(children: [const Text('One'), const Text('Two')]),
    );

    expect(find.byType(Divider), findsOneWidget);
  });

  testWidgets('shows two separators between three children', (tester) async {
    await tester.pumpWidget(
      buildSubject(
        children: [
          const Text('One'),
          const Text('Two'),
          const Text('Three'),
        ],
      ),
    );

    expect(find.byType(Divider), findsNWidgets(2));
  });

  testWidgets('shows no card fill when given no children', (tester) async {
    await tester.pumpWidget(buildSubject(children: const []));

    expect(find.byType(ColoredBox), findsNothing);
  });

  testWidgets('fills the card with the surfaceRaised token', (tester) async {
    await tester.pumpWidget(buildSubject(children: [const Text('One')]));

    final coloredBox = tester.widget<ColoredBox>(find.byType(ColoredBox));

    expect(coloredBox.color, AppColorTokens.dark.surfaceRaised);
  });

  testWidgets('uses the hairline token for the separator', (tester) async {
    await tester.pumpWidget(
      buildSubject(children: [const Text('One'), const Text('Two')]),
    );

    final divider = tester.widget<Divider>(find.byType(Divider));

    expect(divider.color, AppColorTokens.dark.hairline);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/stat_pill.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildSubject({required List<StatEntry> stats}) {
    return MaterialApp(
      theme: buildDarkTheme(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(body: StatPill(stats: stats)),
    );
  }

  testWidgets('should show 2 stats when passed 2 entries', (tester) async {
    await tester.pumpWidget(
      buildSubject(
        stats: [
          StatEntry(figure: 'figure 1', label: 'label 1'),
          StatEntry(figure: 'figure 2', label: 'label 2'),
        ],
      ),
    );

    expect(find.text('figure 1'), findsOneWidget);
    expect(find.text('label 1'), findsOneWidget);
    expect(find.text('figure 2'), findsOneWidget);
    expect(find.text('label 2'), findsOneWidget);
  });

  testWidgets('should assert on list length not 2 or 3', (_) async {
    expect(
      () => buildSubject(
        stats: [StatEntry(figure: 'figure 1', label: 'label 1')],
      ),
      throwsAssertionError,
    );
  });
}

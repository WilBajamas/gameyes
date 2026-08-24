import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_color_tokens.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/label_value_row.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildSubject({
    required String label,
    required String value,
    bool showChevron = false,
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
        body: LabelValueRow(
          label: label,
          value: value,
          showChevron: showChevron,
        ),
      ),
    );
  }

  testWidgets('shows the label in ink and the value in ink70', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(label: 'Label', value: 'Value'));

    final labelWidget = tester.widget<Text>(find.text('Label'));
    final valueWidget = tester.widget<Text>(find.text('Value'));

    expect(labelWidget.style!.color, AppColorTokens.dark.ink);
    expect(valueWidget.style!.color, AppColorTokens.dark.ink70);
  });

  testWidgets('shows one chevron when a chevron is requested', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(label: 'Label', value: 'Value', showChevron: true),
    );

    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
  });

  testWidgets('hides the chevron by default', (tester) async {
    await tester.pumpWidget(buildSubject(label: 'Label', value: 'Value'));

    expect(find.byIcon(Icons.chevron_right), findsNothing);
  });

  testWidgets('draws no separator of its own', (tester) async {
    await tester.pumpWidget(buildSubject(label: 'Label', value: 'Value'));

    expect(find.byType(Divider), findsNothing);
  });
}

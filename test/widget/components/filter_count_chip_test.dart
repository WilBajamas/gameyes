import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/filter_count_chip.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
    int? count,
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
        body: FilterCountChip(
          label: label,
          isSelected: isSelected,
          onSelected: onSelected,
          count: count,
        ),
      ),
    );
  }

  testWidgets('calls onSelected when tapped', (tester) async {
    var selected = false;

    await tester.pumpWidget(
      buildSubject(
        label: 'filter',
        isSelected: selected,
        onSelected: () => selected = true,
      ),
    );

    await tester.tap(find.byType(FilterCountChip));

    expect(selected, isTrue);
  });

  testWidgets('label is displayed', (tester) async {
    await tester.pumpWidget(
      buildSubject(label: 'filter', isSelected: false, onSelected: () {}),
    );

    expect(find.text('filter'), findsOneWidget);
  });

  testWidgets('count is displayed when count is not null', (tester) async {
    await tester.pumpWidget(
      buildSubject(
        label: 'filter',
        isSelected: false,
        onSelected: () {},
        count: 1,
      ),
    );

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('count is not displayed when count is null', (tester) async {
    await tester.pumpWidget(
      buildSubject(label: 'filter', isSelected: false, onSelected: () {}),
    );

    expect(find.text('1'), findsNothing);
  });

  testWidgets('color appear accentIndigo when isSelected is true', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(label: 'filter', isSelected: true, onSelected: () {}),
    );

    final decoratedBox = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
    final decorationColor = (decoratedBox.decoration as BoxDecoration).color;

    expect(decorationColor, const Color(0xFF5865F2));
  });

  testWidgets('color appear ink08 when isSelected is false', (tester) async {
    await tester.pumpWidget(
      buildSubject(label: 'filter', isSelected: false, onSelected: () {}),
    );

    final decoratedBox = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
    final decorationColor = (decoratedBox.decoration as BoxDecoration).color;

    expect(decorationColor, const Color.fromRGBO(255, 255, 255, 0.08));
  });
}

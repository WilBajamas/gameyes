import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_filter_list_app_bar.dart';

void main() {
  const filterList = <(SavedGameFilterTag, String, IconData?)>[
    (SavedGameFilterTag.recentlyChanged, 'Recently Changed', null),
    (SavedGameFilterTag.name, 'Name', null),
    (SavedGameFilterTag.date, 'Date Added', null),
  ];

  Widget buildSubject({
    SavedGameFilterTag? initialSelection,
    void Function(SavedGameFilterTag)? selected,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            DefaultFilterListAppBar<SavedGameFilterTag>(
              filterList: filterList,
              initialSelection: initialSelection,
              selected: selected ?? (_) {},
            ),
          ],
        ),
      ),
    );
  }

  /// A chip renders bold when selected and normal weight otherwise.
  bool isChipSelected(WidgetTester tester, String label) {
    final text = tester.widget<Text>(find.text(label));

    return text.style?.fontWeight == FontWeight.bold;
  }

  testWidgets('renders every filter label', (tester) async {
    await tester.pumpWidget(buildSubject());

    expect(find.text('Recently Changed'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Date Added'), findsOneWidget);
  });

  testWidgets('the chip matching initialSelection renders as selected',
      (tester) async {
    await tester.pumpWidget(
      buildSubject(initialSelection: SavedGameFilterTag.date),
    );

    expect(isChipSelected(tester, 'Date Added'), isTrue);
    expect(isChipSelected(tester, 'Recently Changed'), isFalse);
    expect(isChipSelected(tester, 'Name'), isFalse);
  });

  testWidgets('the middle entry can be the initial selection', (tester) async {
    await tester.pumpWidget(
      buildSubject(initialSelection: SavedGameFilterTag.name),
    );

    expect(isChipSelected(tester, 'Name'), isTrue);
    expect(isChipSelected(tester, 'Recently Changed'), isFalse);
  });

  testWidgets('the first chip is selected when initialSelection is omitted',
      (tester) async {
    await tester.pumpWidget(buildSubject());

    expect(isChipSelected(tester, 'Recently Changed'), isTrue);
    expect(isChipSelected(tester, 'Name'), isFalse);
    expect(isChipSelected(tester, 'Date Added'), isFalse);
  });

  testWidgets('calls selected and switches the selected chip when a chip is '
      'tapped', (tester) async {
    SavedGameFilterTag? tapped;

    await tester.pumpWidget(
      buildSubject(selected: (tag) => tapped = tag),
    );

    await tester.tap(find.text('Date Added'));
    await tester.pumpAndSettle();

    expect(tapped, SavedGameFilterTag.date);
    expect(isChipSelected(tester, 'Date Added'), isTrue);
    expect(isChipSelected(tester, 'Recently Changed'), isFalse);
  });
}

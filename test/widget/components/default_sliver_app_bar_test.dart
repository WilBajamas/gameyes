import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_sliver_app_bar.dart';

void main() {
  Widget buildSubject({required double textScale, String? subtitle}) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(
          textScaler: TextScaler.linear(textScale),
          padding: const EdgeInsets.only(top: 24),
        ),
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              DefaultSliverAppBar(title: 'Browse', subtitle: subtitle),
            ],
          ),
        ),
      ),
    );
  }

  group('DefaultSliverAppBar', () {
    for (final scale in <double>[1, 1.3, 1.5, 2]) {
      testWidgets('does not overflow at a text scale of $scale', (
        tester,
      ) async {
        await tester.pumpWidget(buildSubject(textScale: scale));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      });

      testWidgets(
        'does not overflow with a subtitle at a text scale of $scale',
        (tester) async {
          await tester.pumpWidget(
            buildSubject(
              textScale: scale,
              subtitle: 'Search for your favourite games here',
            ),
          );
          await tester.pumpAndSettle();

          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets('keeps the title on a single line at the largest scale', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject(textScale: 2));
      await tester.pumpAndSettle();

      final title = tester.widget<Text>(
        find.descendant(
          of: find.byType(DefaultSliverAppBar),
          matching: find.text('Browse'),
        ),
      );

      expect(title.maxLines, 1);
    });
  });
}

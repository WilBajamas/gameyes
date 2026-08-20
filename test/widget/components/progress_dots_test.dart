import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_tokens.dart';
import 'package:gaming_library_assessment_flutter/widgets/progress_dots.dart';

void main() {
  testWidgets('renders the requested number of dots', (tester) async {
    await tester.pumpWidget(_buildSubject(count: 3, activeIndex: 0));

    expect(find.byType(Container), findsNWidgets(3));
  });

  testWidgets('draws exactly one dot at the active form and requested index', (
    tester,
  ) async {
    await tester.pumpWidget(_buildSubject(count: 3, activeIndex: 1));

    final dots = tester.widgetList<Container>(find.byType(Container)).toList();
    final activeDots = dots.where((dot) => dot.constraints?.maxWidth == 22);

    expect(activeDots, hasLength(1));
    expect(dots[1].constraints?.maxWidth, 22);
  });

  testWidgets('sizes the active dot 22x5 and every inactive dot 5x5', (
    tester,
  ) async {
    await tester.pumpWidget(_buildSubject(count: 2, activeIndex: 0));

    final dots = tester.widgetList<Container>(find.byType(Container)).toList();

    expect(dots[0].constraints?.maxWidth, 22);
    expect(dots[0].constraints?.maxHeight, 5);
    expect(dots[1].constraints?.maxWidth, 5);
    expect(dots[1].constraints?.maxHeight, 5);
  });

  testWidgets('fills the active dot with ink and inactive dots with ink12', (
    tester,
  ) async {
    final tokens = buildDarkTheme().extension<AppTokens>()!;
    await tester.pumpWidget(_buildSubject(count: 2, activeIndex: 0));

    final dots = tester.widgetList<Container>(find.byType(Container)).toList();
    final activeDecoration = dots[0].decoration! as BoxDecoration;
    final inactiveDecoration = dots[1].decoration! as BoxDecoration;

    expect(activeDecoration.color, tokens.color.ink);
    expect(inactiveDecoration.color, tokens.color.ink12);
  });

  testWidgets('sits adjacent dots 6px apart with no leading or trailing gap', (
    tester,
  ) async {
    await tester.pumpWidget(_buildSubject(count: 2, activeIndex: 0));

    final row = tester.widget<Row>(find.byType(Row));

    expect(row.spacing, 6);
    expect(row.mainAxisSize, MainAxisSize.min);
  });

  testWidgets('hugs its content instead of filling the offered width', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildDarkTheme(),
        home: const Scaffold(
          body: SizedBox(
            width: 400,
            child: Align(
              alignment: Alignment.centerLeft,
              child: ProgressDots(count: 2, activeIndex: 0),
            ),
          ),
        ),
      ),
    );

    final size = tester.getSize(find.byType(ProgressDots));

    expect(size.width, lessThan(400));
    expect(size.height, 5);
  });

  testWidgets('shows no text and no tap handler', (tester) async {
    await tester.pumpWidget(_buildSubject(count: 2, activeIndex: 0));

    expect(find.byType(Text), findsNothing);
    expect(find.byType(GestureDetector), findsNothing);
    expect(find.byType(InkWell), findsNothing);
  });

  testWidgets('fails in debug when the active index is out of range', (
    tester,
  ) async {
    expect(() => ProgressDots(count: 2, activeIndex: 2), throwsAssertionError);
  });
}

Widget _buildSubject({required int count, required int activeIndex}) {
  return MaterialApp(
    theme: buildDarkTheme(),
    home: Scaffold(
      body: ProgressDots(count: count, activeIndex: activeIndex),
    ),
  );
}

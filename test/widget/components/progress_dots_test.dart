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

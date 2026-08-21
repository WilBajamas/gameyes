import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_color_tokens.dart';
import 'package:gaming_library_assessment_flutter/widgets/critic_badge.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildSubject({required double score}) {
    return MaterialApp(
      theme: buildDarkTheme(),
      home: Scaffold(body: CriticBadge(score: score)),
    );
  }

  testWidgets('shows the score rounded to a whole number', (tester) async {
    await tester.pumpWidget(buildSubject(score: 8.6));

    expect(find.text('9'), findsOneWidget);
  });

  testWidgets('uses the sanctioned green token for the badge fill', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(score: 7.2));

    final badge = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
    final decoration = badge.decoration as BoxDecoration;

    expect(decoration.color, AppColorTokens.dark.green);
  });
}

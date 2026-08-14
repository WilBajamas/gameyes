import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_tokens.dart';
import 'package:gaming_library_assessment_flutter/widgets/zone_label.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildSubject({
    String label = 'now playing',
    String? linkLabel,
    VoidCallback? onLinkPressed,
  }) {
    return MaterialApp(
      theme: buildDarkTheme(),
      home: Scaffold(
        body: ZoneLabel(
          label: label,
          linkLabel: linkLabel,
          onLinkPressed: onLinkPressed,
        ),
      ),
    );
  }

  testWidgets('shows the label in capitals when the caller passes lower case', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    expect(find.text('NOW PLAYING'), findsOneWidget);
    expect(find.text('now playing'), findsNothing);
  });

  testWidgets('styles the label from the zoneLabel token when rendering', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    final text = tester.widget<Text>(find.text('NOW PLAYING'));

    expect(text.style, AppTokens.dark.typography.zoneLabel.style);
  });

  testWidgets(
    'shows the link styled from the zoneLink token when label and callback '
    'are both supplied',
    (tester) async {
      await tester.pumpWidget(
        buildSubject(linkLabel: 'See all', onLinkPressed: () {}),
      );

      final text = tester.widget<Text>(find.text('See all'));

      expect(text.style, AppTokens.dark.typography.zoneLink.style);
    },
  );

  testWidgets('hides the link when only one of label or callback is supplied', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(linkLabel: 'See all'));
    expect(find.text('See all'), findsNothing);

    await tester.pumpWidget(buildSubject(onLinkPressed: () {}));
    expect(
      find.descendant(
        of: find.byType(ZoneLabel),
        matching: find.byType(GestureDetector),
      ),
      findsNothing,
    );
  });

  testWidgets('calls onLinkPressed once when the link is tapped', (
    tester,
  ) async {
    var callCount = 0;
    await tester.pumpWidget(
      buildSubject(linkLabel: 'See all', onLinkPressed: () => callCount++),
    );

    await tester.tap(find.text('See all'));
    await tester.pump();

    expect(callCount, 1);
  });

  testWidgets('keeps the link tap target at least 44 high when rendering', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(linkLabel: 'See all', onLinkPressed: () {}),
    );

    final size = tester.getSize(
      find.descendant(
        of: find.byType(ZoneLabel),
        matching: find.byType(GestureDetector),
      ),
    );

    expect(size.height, greaterThanOrEqualTo(44));
  });

  testWidgets('adds no vertical spacing around the label when rendering', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    final zoneLabelSize = tester.getSize(find.byType(ZoneLabel));
    final labelSize = tester.getSize(find.text('NOW PLAYING'));

    expect(zoneLabelSize.height, labelSize.height);
  });
}

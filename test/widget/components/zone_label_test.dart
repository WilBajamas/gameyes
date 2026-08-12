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

  testWidgets(
    'should render the label in capitals when the caller passes lower case',
    (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('NOW PLAYING'), findsOneWidget);
      expect(find.text('now playing'), findsNothing);
    },
  );

  testWidgets(
    'should style the label from the zoneLabel token when rendering',
    (tester) async {
      await tester.pumpWidget(buildSubject());

      final text = tester.widget<Text>(find.text('NOW PLAYING'));
      final expected = AppTokens.dark.typography.zoneLabel.style;

      expect(text.style?.fontSize, expected.fontSize);
      expect(text.style?.fontWeight, expected.fontWeight);
      expect(text.style?.letterSpacing, expected.letterSpacing);
      expect(text.style?.color, expected.color);
    },
  );

  testWidgets(
    'should style the link from the zoneLink token when a link is supplied',
    (tester) async {
      await tester.pumpWidget(
        buildSubject(linkLabel: 'See all', onLinkPressed: () {}),
      );

      final text = tester.widget<Text>(find.text('See all'));
      final expected = AppTokens.dark.typography.zoneLink.style;

      expect(text.style?.fontSize, expected.fontSize);
      expect(text.style?.fontWeight, expected.fontWeight);
      expect(text.style?.letterSpacing, expected.letterSpacing);
      expect(text.style?.color, expected.color);
    },
  );

  testWidgets(
    'should render the link when both text and callback are supplied',
    (tester) async {
      await tester.pumpWidget(
        buildSubject(linkLabel: 'See all', onLinkPressed: () {}),
      );

      expect(find.text('See all'), findsOneWidget);
    },
  );

  testWidgets('should render no link when only the text is supplied', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(linkLabel: 'See all'));

    expect(find.text('See all'), findsNothing);
    expect(
      find.descendant(
        of: find.byType(ZoneLabel),
        matching: find.byType(GestureDetector),
      ),
      findsNothing,
    );
  });

  testWidgets('should render no link when only the callback is supplied', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(onLinkPressed: () {}));

    expect(
      find.descendant(
        of: find.byType(ZoneLabel),
        matching: find.byType(GestureDetector),
      ),
      findsNothing,
    );
  });

  testWidgets('should invoke the callback once when the link is tapped', (
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

  testWidgets('should render no divider in any configuration', (tester) async {
    await tester.pumpWidget(buildSubject());
    expect(find.byType(Divider), findsNothing);

    await tester.pumpWidget(
      buildSubject(linkLabel: 'See all', onLinkPressed: () {}),
    );
    expect(find.byType(Divider), findsNothing);
  });

  testWidgets(
    'should keep the link tap target at least 44 high when rendering',
    (tester) async {
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

      final text = tester.widget<Text>(find.text('See all'));
      final expected = AppTokens.dark.typography.zoneLink.style;
      expect(text.style?.fontSize, expected.fontSize);
    },
  );

  testWidgets(
    'should add no vertical spacing around the label when rendering',
    (tester) async {
      await tester.pumpWidget(buildSubject());

      final zoneLabelSize = tester.getSize(find.byType(ZoneLabel));
      final labelSize = tester.getSize(find.text('NOW PLAYING'));

      expect(zoneLabelSize.height, labelSize.height);

      final row = find.descendant(
        of: find.byType(ZoneLabel),
        matching: find.byType(Row),
      );
      expect(
        find.ancestor(of: row, matching: find.byType(Padding)),
        findsNothing,
      );
    },
  );
}

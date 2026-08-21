import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/widgets/action_row.dart';

void main() {
  testWidgets('calls onPressed once per tap when enabled', (tester) async {
    var taps = 0;
    await tester.pumpWidget(_buildSubject(onPressed: () => taps++));

    await tester.tap(find.byType(ActionRow));

    expect(taps, 1);
  });

  testWidgets('calls nothing when disabled', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _buildSubject(enabled: false, onPressed: () => taps++),
    );

    await tester.tap(find.byType(ActionRow), warnIfMissed: false);

    expect(taps, 0);
  });

  testWidgets('shows the busy indicator only while loading', (tester) async {
    await tester.pumpWidget(_buildSubject());
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.pumpWidget(_buildSubject(loading: true));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(tester.getSize(find.byType(ActionRow)).height, 52);
  });

  testWidgets('shows the label on one line ellipsised in a narrow parent', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildDarkTheme(),
        home: Scaffold(
          body: SizedBox(
            width: 80,
            child: ActionRow(
              label: 'A very long provider name that will not fit',
              markAsset: 'assets/icons/discord-logo.png',
              fill: Colors.transparent,
              enabled: true,
              loading: false,
              loadingLabel: 'Signing in',
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(
      find.text('A very long provider name that will not fit'),
    );

    expect(text.maxLines, 1);
    expect(text.overflow, TextOverflow.ellipsis);
    expect(tester.takeException(), isNull);
  });
}

Widget _buildSubject({
  String label = 'Continue',
  bool enabled = true,
  bool loading = false,
  Color fill = Colors.transparent,
  VoidCallback? onPressed,
}) {
  return MaterialApp(
    theme: buildDarkTheme(),
    home: Scaffold(
      body: SizedBox(
        width: 400,
        child: ActionRow(
          label: label,
          markAsset: 'assets/icons/discord-logo.png',
          fill: fill,
          enabled: enabled,
          loading: loading,
          loadingLabel: 'Signing in',
          onPressed: onPressed ?? () {},
        ),
      ),
    ),
  );
}

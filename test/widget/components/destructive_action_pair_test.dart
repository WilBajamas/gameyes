import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_color_tokens.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_states/destructive_action_pair.dart';
import 'package:gaming_library_assessment_flutter/widgets/primary_button.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildSubject({VoidCallback? onDestructive, VoidCallback? onSafe}) {
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
        body: DestructiveActionPair(
          destructiveLabel: 'Delete account',
          safeLabel: 'Keep account',
          onDestructive: onDestructive ?? () {},
          onSafe: onSafe ?? () {},
        ),
      ),
    );
  }

  testWidgets('fills the destructive action with the errorStrong token', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    final button = tester.widget<PrimaryButton>(
      find.widgetWithText(PrimaryButton, 'Delete account'),
    );

    expect(button.backgroundColor, AppColorTokens.dark.errorStrong);
  });

  testWidgets('keeps the safe action off the error ramp and off green', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    final button = tester.widget<PrimaryButton>(
      find.widgetWithText(PrimaryButton, 'Keep account'),
    );

    expect(
      button.backgroundColor,
      isNot(
        anyOf(
          AppColorTokens.dark.errorStrong,
          AppColorTokens.dark.error,
          AppColorTokens.dark.errorTint,
          AppColorTokens.dark.errorLine,
          AppColorTokens.dark.green,
        ),
      ),
    );
    expect(button.labelColor, isNot(AppColorTokens.dark.green));
  });

  testWidgets(
    'calls onDestructive once when the destructive action is tapped',
    (tester) async {
      var destructiveCount = 0;
      var safeCount = 0;

      await tester.pumpWidget(
        buildSubject(
          onDestructive: () => destructiveCount++,
          onSafe: () => safeCount++,
        ),
      );

      await tester.tap(find.text('Delete account'));

      expect(destructiveCount, 1);
      expect(safeCount, 0);
    },
  );

  testWidgets('calls onSafe once when the safe action is tapped', (
    tester,
  ) async {
    var destructiveCount = 0;
    var safeCount = 0;

    await tester.pumpWidget(
      buildSubject(
        onDestructive: () => destructiveCount++,
        onSafe: () => safeCount++,
      ),
    );

    await tester.tap(find.text('Keep account'));

    expect(safeCount, 1);
    expect(destructiveCount, 0);
  });
}

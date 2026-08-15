import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_tokens.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/placeholder_slot.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUpAll(() async {
    await resolveDarkTokensAfterFontsSettle();
  });

  Widget wrap(Widget child) {
    return MaterialApp(
      theme: buildDarkTheme(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  Widget buildSubject(PlaceholderSlotSize size) {
    return wrap(PlaceholderSlot(size: size));
  }

  testWidgets(
    'sizes the box 88 at the app mark preset and 20 at the provider mark '
    'preset',
    (tester) async {
      await tester.pumpWidget(buildSubject(PlaceholderSlotSize.appMark));
      expect(tester.getSize(find.byType(PlaceholderSlot)), const Size(88, 88));

      await tester.pumpWidget(buildSubject(PlaceholderSlotSize.providerMark));
      expect(tester.getSize(find.byType(PlaceholderSlot)), const Size(20, 20));
    },
  );

  testWidgets('shows the LOGO marker only at the app mark preset', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(PlaceholderSlotSize.appMark));
    expect(find.text('LOGO'), findsOneWidget);

    await tester.pumpWidget(buildSubject(PlaceholderSlotSize.providerMark));
    expect(find.byType(Text), findsNothing);
  });
}

Future<AppTokens> resolveDarkTokensAfterFontsSettle() async {
  final future = runZonedGuarded<Future<AppTokens>>(() async {
    return AppTokens.dark;
  }, (error, stack) {});
  return await future!;
}

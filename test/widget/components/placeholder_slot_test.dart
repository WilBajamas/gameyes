import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_color_tokens.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_radius_tokens.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_tokens.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/placeholder_slot.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  late final AppColorTokens colors;
  late final AppRadiusTokens radius;
  late final TextStyle zoneLabelStyle;

  // Same font warm-up as test/widget/components/cover_tile_test.dart.
  setUpAll(() async {
    final completer = Completer<AppTokens>();
    runZonedGuarded<Future<void>>(() async {
      final tokens = AppTokens.dark;
      await Future<void>.delayed(const Duration(milliseconds: 250));
      completer.complete(tokens);
    }, (error, stack) {});
    final tokens = await completer.future;
    colors = tokens.color;
    radius = tokens.radius;
    zoneLabelStyle = tokens.typography.zoneLabel.style;
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

  BoxDecoration decorationOf(WidgetTester tester) {
    final decorated = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(PlaceholderSlot),
        matching: find.byType(DecoratedBox),
      ),
    );
    return decorated.decoration as BoxDecoration;
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

  testWidgets(
    'renders the ink12 fill, ink24 border, and preset corner radius at both '
    'presets',
    (tester) async {
      await tester.pumpWidget(buildSubject(PlaceholderSlotSize.appMark));
      var decoration = decorationOf(tester);
      expect(decoration.color, colors.ink12);
      expect(decoration.borderRadius, BorderRadius.circular(20));
      var border = decoration.border as Border;
      expect(border.isUniform, isTrue);
      expect(border.top.color, colors.ink24);
      expect(border.top.width, 1);

      await tester.pumpWidget(buildSubject(PlaceholderSlotSize.providerMark));
      decoration = decorationOf(tester);
      expect(decoration.color, colors.ink12);
      expect(decoration.borderRadius, BorderRadius.circular(radius.xs));
      border = decoration.border as Border;
      expect(border.isUniform, isTrue);
      expect(border.top.color, colors.ink24);
      expect(border.top.width, 1);
    },
  );

  testWidgets(
    'shows the LOGO marker in the display face style only at the app mark '
    'preset',
    (tester) async {
      await tester.pumpWidget(buildSubject(PlaceholderSlotSize.appMark));
      final text = tester.widget<Text>(find.text('LOGO'));
      final expected = zoneLabelStyle.copyWith(
        fontSize: 14,
        letterSpacing: 2.24,
      );
      expect(text.style, expected);

      await tester.pumpWidget(buildSubject(PlaceholderSlotSize.providerMark));
      expect(find.byType(Text), findsNothing);
    },
  );
}

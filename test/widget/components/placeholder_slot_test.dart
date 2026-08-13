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
  late final String zoneLabelFontFamily;

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
    zoneLabelFontFamily = tokens.typography.zoneLabel.style.fontFamily!;
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
    'should render an 88 box at the app mark preset and a 20 box at the '
    'provider mark preset',
    (tester) async {
      await tester.pumpWidget(buildSubject(PlaceholderSlotSize.appMark));
      expect(tester.getSize(find.byType(PlaceholderSlot)), const Size(88, 88));

      await tester.pumpWidget(buildSubject(PlaceholderSlotSize.providerMark));
      expect(tester.getSize(find.byType(PlaceholderSlot)), const Size(20, 20));
    },
  );

  testWidgets(
    'should round the app mark to 20 and the provider mark to the xs radius',
    (tester) async {
      await tester.pumpWidget(buildSubject(PlaceholderSlotSize.appMark));
      expect(decorationOf(tester).borderRadius, BorderRadius.circular(20));

      await tester.pumpWidget(buildSubject(PlaceholderSlotSize.providerMark));
      expect(
        decorationOf(tester).borderRadius,
        BorderRadius.circular(radius.xs),
      );
    },
  );

  testWidgets('should fill both presets with ink12', (tester) async {
    for (final size in PlaceholderSlotSize.values) {
      await tester.pumpWidget(buildSubject(size));
      expect(decorationOf(tester).color, colors.ink12);
    }
  });

  testWidgets('should draw a solid 1px ink24 border at both presets', (
    tester,
  ) async {
    for (final size in PlaceholderSlotSize.values) {
      await tester.pumpWidget(buildSubject(size));
      final border = decorationOf(tester).border as Border;
      expect(border.isUniform, isTrue);
      for (final side in [
        border.top,
        border.right,
        border.bottom,
        border.left,
      ]) {
        expect(side.color, colors.ink24);
        expect(side.width, 1);
        expect(side.style, BorderStyle.solid);
      }
    }
  });

  testWidgets('should not custom-paint its outline', (tester) async {
    for (final size in PlaceholderSlotSize.values) {
      await tester.pumpWidget(buildSubject(size));
      expect(
        find.descendant(
          of: find.byType(PlaceholderSlot),
          matching: find.byType(CustomPaint),
        ),
        findsNothing,
      );
    }
  });

  testWidgets(
    'should render the LOGO marker in the display face at 700 only at the '
    'app mark preset',
    (tester) async {
      await tester.pumpWidget(buildSubject(PlaceholderSlotSize.appMark));
      final text = tester.widget<Text>(find.text('LOGO'));
      expect(text.style?.fontWeight, FontWeight.w700);
      expect(text.style?.fontSize, 14);
      expect(text.style?.letterSpacing, 2.24);
      expect(text.style?.color, colors.ink55);
      expect(text.style?.fontFamily, zoneLabelFontFamily);

      await tester.pumpWidget(buildSubject(PlaceholderSlotSize.providerMark));
      expect(find.byType(Text), findsNothing);
    },
  );

  testWidgets(
    'should hold its box inside a fixed-size parent and inside an unbounded '
    'parent',
    (tester) async {
      await tester.pumpWidget(
        wrap(
          const Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Center(
                child: PlaceholderSlot(size: PlaceholderSlotSize.appMark),
              ),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(PlaceholderSlot)), const Size(88, 88));
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(
        wrap(
          Row(
            children: [
              const PlaceholderSlot(size: PlaceholderSlotSize.appMark),
            ],
          ),
        ),
      );
      expect(tester.getSize(find.byType(PlaceholderSlot)), const Size(88, 88));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('should add no spacing of its own', (tester) async {
    for (final size in PlaceholderSlotSize.values) {
      await tester.pumpWidget(buildSubject(size));

      expect(
        find.ancestor(
          of: find.byType(PlaceholderSlot),
          matching: find.byType(Padding),
        ),
        findsNothing,
      );
      expect(
        tester.getSize(find.byType(PlaceholderSlot)),
        Size(size.dimension, size.dimension),
      );
    }
  });
}

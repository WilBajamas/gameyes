import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_color_tokens.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/countdown/countdown_card.dart';
import 'package:gaming_library_assessment_flutter/widgets/countdown/countdown_tile.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

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

  Widget buildCard({
    String title = 'Test Game',
    bool isWishlisted = false,
    Duration? remaining,
    String? releaseDateText,
    VoidCallback? onOpen,
    VoidCallback? onRemind,
  }) {
    return wrap(
      CountdownCard(
        title: title,
        isWishlisted: isWishlisted,
        remaining: remaining,
        releaseDateText: releaseDateText,
        onOpen: onOpen ?? () {},
        onRemind: onRemind,
      ),
    );
  }

  Widget buildTile({Duration? remaining, String? releaseDateText}) {
    return wrap(
      CountdownTile(remaining: remaining, releaseDateText: releaseDateText),
    );
  }

  testWidgets(
    'shows three padded unit groups and two colons for a supplied duration',
    (tester) async {
      await tester.pumpWidget(
        buildCard(remaining: const Duration(days: 3, hours: 5, minutes: 12)),
      );

      expect(find.text('03'), findsOneWidget);
      expect(find.text('05'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('DAYS'), findsOneWidget);
      expect(find.text('HRS'), findsOneWidget);
      expect(find.text('MIN'), findsOneWidget);
      expect(find.text(':'), findsNWidgets(2));
    },
  );

  testWidgets(
    'shows the released label and no digits when the duration has run out',
    (tester) async {
      await tester.pumpWidget(buildCard(remaining: Duration.zero));

      expect(
        find.text(S.current.countdown_released.toUpperCase()),
        findsOneWidget,
      );
      expect(find.text(':'), findsNothing);
    },
  );

  testWidgets('shows the caller release-date text when no duration is given', (
    tester,
  ) async {
    await tester.pumpWidget(buildCard(releaseDateText: 'Q2 2026'));

    expect(find.text('Q2 2026'), findsOneWidget);
    expect(find.text(':'), findsNothing);
  });

  testWidgets(
    'shows the unannounced-date label when neither duration nor date is given',
    (tester) async {
      await tester.pumpWidget(buildCard());

      expect(
        find.text(S.current.countdown_date_unannounced.toUpperCase()),
        findsOneWidget,
      );
      expect(find.text(':'), findsNothing);
    },
  );

  testWidgets(
    'shows the cyan wishlist reason line when the game is wishlisted',
    (tester) async {
      await tester.pumpWidget(buildCard(isWishlisted: true));

      final text = tester.widget<Text>(find.text(S.current.on_your_wishlist));

      expect(text.style?.color, AppColorTokens.dark.accentLinkCyan);
    },
  );

  testWidgets(
    'shows the neutral reason line, and no cyan, when it is not wishlisted',
    (tester) async {
      await tester.pumpWidget(buildCard());

      expect(find.text(S.current.most_anticipated), findsOneWidget);
      expect(find.text(S.current.on_your_wishlist), findsNothing);
    },
  );

  testWidgets('hides the remind action when no handler is supplied', (
    tester,
  ) async {
    await tester.pumpWidget(buildCard());

    expect(find.text(S.current.remind), findsNothing);
  });

  testWidgets('calls onOpen once when the card is tapped', (tester) async {
    var openCount = 0;

    await tester.pumpWidget(buildCard(onOpen: () => openCount++));

    await tester.tap(find.text('TEST GAME'));

    expect(openCount, 1);
  });

  testWidgets(
    'calls onRemind and does not open the game when the remind action is tapped',
    (tester) async {
      var openCount = 0;
      var remindCount = 0;

      await tester.pumpWidget(
        buildCard(onOpen: () => openCount++, onRemind: () => remindCount++),
      );

      await tester.tap(find.text(S.current.remind));

      expect(remindCount, 1);
      expect(openCount, 0);
    },
  );

  testWidgets(
    'leaves the digits unchanged after time elapses without a rebuild',
    (tester) async {
      await tester.pumpWidget(
        buildCard(remaining: const Duration(days: 1, hours: 2, minutes: 3)),
      );

      await tester.pump(const Duration(minutes: 5));

      expect(find.text('01'), findsOneWidget);
      expect(find.text('02'), findsOneWidget);
      expect(find.text('03'), findsOneWidget);
    },
  );

  testWidgets('shows the same three unit groups in the tile form', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTile(remaining: const Duration(days: 3, hours: 5, minutes: 12)),
    );

    expect(find.text('03'), findsOneWidget);
    expect(find.text('05'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('DAYS'), findsOneWidget);
    expect(find.text('HRS'), findsOneWidget);
    expect(find.text('MIN'), findsOneWidget);
    expect(find.text(':'), findsNWidgets(2));
  });
}

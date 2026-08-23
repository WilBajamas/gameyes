import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/bottom_tab_bar/bottom_tab_bar.dart';
import 'package:gaming_library_assessment_flutter/widgets/bottom_tab_bar/bottom_tab_bar_cap.dart';
import 'package:gaming_library_assessment_flutter/widgets/bottom_tab_bar/bottom_tab_bar_cell.dart';
import 'package:gaming_library_assessment_flutter/widgets/bottom_tab_bar/enum/bottom_tab_bar_destination.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUpAll(() async {
    await S.load(const Locale('en'));
  });

  Widget buildSubject({
    required int selectedIndex,
    required ValueChanged<int> onDestinationSelected,
    Widget? body,
    Locale locale = const Locale('en'),
    double textScaleFactor = 1,
    bool disableAnimations = false,
    EdgeInsets viewPadding = EdgeInsets.zero,
  }) {
    return MediaQuery(
      data: MediaQueryData(
        textScaler: TextScaler.linear(textScaleFactor),
        disableAnimations: disableAnimations,
        padding: viewPadding,
      ),
      child: MaterialApp(
        theme: buildDarkTheme(),
        locale: locale,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Scaffold(
          body: body ?? const SizedBox.shrink(),
          bottomNavigationBar: BottomTabBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
          ),
        ),
      ),
    );
  }

  testWidgets(
    'shows every destination label and glyph whichever destination is selected',
    (tester) async {
      await tester.pumpWidget(
        buildSubject(selectedIndex: 0, onDestinationSelected: (_) {}),
      );

      for (final destination in BottomTabBarDestination.values) {
        expect(find.text(destination.label), findsOneWidget);
        expect(find.byIcon(destination.icon), findsOneWidget);
      }

      await tester.pumpWidget(
        buildSubject(selectedIndex: 4, onDestinationSelected: (_) {}),
      );

      for (final destination in BottomTabBarDestination.values) {
        expect(find.text(destination.label), findsOneWidget);
        expect(find.byIcon(destination.icon), findsOneWidget);
      }
    },
  );

  testWidgets('reports the tapped destination index once per tap', (
    tester,
  ) async {
    final reported = <int>[];
    await tester.pumpWidget(
      buildSubject(selectedIndex: 0, onDestinationSelected: reported.add),
    );

    await tester.tap(find.text(S.current.games));
    await tester.tap(find.byIcon(BottomTabBarDestination.games.icon));

    final cell = find.byType(BottomTabBarCell).at(1);
    await tester.tapAt(tester.getTopLeft(cell) + const Offset(2, 2));

    expect(reported, [1, 1, 1]);
  });

  testWidgets(
    'moves the selected state to the destination the caller supplies',
    (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildSubject(selectedIndex: 0, onDestinationSelected: (_) {}),
      );

      expect(
        tester.getSemantics(find.byType(BottomTabBarCell).at(0)),
        isSemantics(isSelected: true),
      );
      expect(
        tester.getSemantics(find.byType(BottomTabBarCell).at(1)),
        isSemantics(isSelected: false),
      );

      await tester.tap(find.text(S.current.games));
      await tester.pump();

      expect(
        tester.getSemantics(find.byType(BottomTabBarCell).at(0)),
        isSemantics(isSelected: true),
      );
      expect(
        tester.getSemantics(find.byType(BottomTabBarCell).at(1)),
        isSemantics(isSelected: false),
      );

      await tester.pumpWidget(
        buildSubject(selectedIndex: 1, onDestinationSelected: (_) {}),
      );

      expect(
        tester.getSemantics(find.byType(BottomTabBarCell).at(0)),
        isSemantics(isSelected: false),
      );
      expect(
        tester.getSemantics(find.byType(BottomTabBarCell).at(1)),
        isSemantics(isSelected: true),
      );

      handle.dispose();
    },
  );

  testWidgets(
    'announces the destination name once with its localized tab position',
    (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildSubject(selectedIndex: 0, onDestinationSelected: (_) {}),
      );

      final label = tester
          .getSemantics(find.byType(BottomTabBarCell).at(2))
          .label;
      final context = tester.element(find.byType(BottomTabBarCell).at(2));
      final position = MaterialLocalizations.of(
        context,
      ).tabLabel(tabIndex: 3, tabCount: 5);

      expect(label.split(S.current.tracker).length - 1, 1);
      expect(label, contains(position));

      handle.dispose();
    },
  );

  testWidgets(
    'shows the destination label as a tooltip on long press without selecting',
    (tester) async {
      var reportedCount = 0;
      await tester.pumpWidget(
        buildSubject(
          selectedIndex: 0,
          onDestinationSelected: (_) => reportedCount++,
        ),
      );

      await tester.longPress(find.text(S.current.games));
      await tester.pump(const Duration(seconds: 2));

      expect(find.byTooltip(S.current.games), findsOneWidget);
      expect(reportedCount, 0);
    },
  );

  testWidgets(
    'reports the destination reached by keyboard traversal when activated',
    (tester) async {
      final reported = <int>[];
      await tester.pumpWidget(
        buildSubject(selectedIndex: 0, onDestinationSelected: reported.add),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(reported, [2]);
    },
  );

  testWidgets(
    'keeps all five destinations while the body scrolls with no scroll state',
    (tester) async {
      await tester.pumpWidget(
        buildSubject(
          selectedIndex: 0,
          onDestinationSelected: (_) {},
          body: ListView(
            children: List.generate(
              30,
              (i) => SizedBox(height: 60, child: Text('item $i')),
            ),
          ),
        ),
      );

      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pump();
      await tester.drag(find.byType(ListView), const Offset(0, 400));
      await tester.pump();

      for (final destination in BottomTabBarDestination.values) {
        expect(find.text(destination.label), findsOneWidget);
      }
    },
  );

  testWidgets('fills the bar with the surfaceTabChrome token', (tester) async {
    await tester.pumpWidget(
      buildSubject(selectedIndex: 0, onDestinationSelected: (_) {}),
    );

    final tokens = tester.element(find.byType(BottomTabBar)).tokens;
    final material = tester.widget<Material>(
      find
          .descendant(
            of: find.byType(BottomTabBar),
            matching: find.byType(Material),
          )
          .first,
    );

    expect(material.color, tokens.color.surfaceTabChrome);
  });

  testWidgets(
    'tints the selected destination and cap indigo and the rest ink55',
    (tester) async {
      await tester.pumpWidget(
        buildSubject(selectedIndex: 0, onDestinationSelected: (_) {}),
      );
      await tester.pumpAndSettle();

      final tokens = tester.element(find.byType(BottomTabBar)).tokens;

      final selectedIcon = tester.widget<Icon>(
        find.byIcon(BottomTabBarDestination.featured.icon),
      );
      final unselectedIcon = tester.widget<Icon>(
        find.byIcon(BottomTabBarDestination.games.icon),
      );
      expect(selectedIcon.color, tokens.color.accentIndigo);
      expect(unselectedIcon.color, tokens.color.ink55);

      final selectedLabel = tester.widget<Text>(find.text(S.current.featured));
      final unselectedLabel = tester.widget<Text>(find.text(S.current.games));
      expect(selectedLabel.style?.color, tokens.color.accentIndigo);
      expect(unselectedLabel.style?.color, tokens.color.ink55);

      final caps = tester
          .widgetList<BottomTabBarCap>(find.byType(BottomTabBarCap))
          .toList();
      expect(caps.length, 5);
      expect(caps.where((cap) => cap.selected).length, 1);
      expect(caps[0].selected, isTrue);

      final capDecorations = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .map((container) => (container.decoration as BoxDecoration).color)
          .toList();
      expect(
        capDecorations.where((color) => color == tokens.color.accentIndigo),
        hasLength(1),
      );
      expect(
        capDecorations.where((color) => color == Colors.transparent),
        hasLength(4),
      );
    },
  );

  testWidgets('consumes the bottom safe-area inset so its content sees none', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        selectedIndex: 0,
        onDestinationSelected: (_) {},
        viewPadding: const EdgeInsets.only(bottom: 40),
      ),
    );

    final descendant = tester.element(find.byType(BottomTabBarCell).first);
    expect(MediaQuery.of(descendant).padding.bottom, 0);

    await tester.pumpWidget(
      buildSubject(selectedIndex: 0, onDestinationSelected: (_) {}),
    );
    expect(find.byType(BottomTabBar), findsOneWidget);
  });

  testWidgets(
    'renders every destination without overflow in zh at a raised text scale',
    (tester) async {
      await S.load(const Locale('zh'));
      addTearDown(() => S.load(const Locale('en')));

      await tester.pumpWidget(
        buildSubject(
          selectedIndex: 0,
          onDestinationSelected: (_) {},
          locale: const Locale('zh'),
          textScaleFactor: 2,
        ),
      );

      expect(tester.takeException(), isNull);

      for (final destination in BottomTabBarDestination.values) {
        expect(find.text(destination.label), findsOneWidget);
      }
    },
  );

  testWidgets(
    'settles a selection change with no running animation under reduced motion',
    (tester) async {
      await tester.pumpWidget(
        buildSubject(
          selectedIndex: 0,
          onDestinationSelected: (_) {},
          disableAnimations: true,
        ),
      );

      final tokens = tester.element(find.byType(BottomTabBar)).tokens;

      await tester.pumpWidget(
        buildSubject(
          selectedIndex: 1,
          onDestinationSelected: (_) {},
          disableAnimations: true,
        ),
      );
      await tester.pump();

      expect(tester.binding.hasScheduledFrame, isFalse);

      final newlySelectedIcon = tester.widget<Icon>(
        find.byIcon(BottomTabBarDestination.games.icon),
      );
      expect(newlySelectedIcon.color, tokens.color.accentIndigo);
    },
  );
}

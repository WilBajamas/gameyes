import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/features/library/presentation/screens/library_screen.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:google_fonts/google_fonts.dart';

class _RecordingTabsRouter extends Fake implements TabsRouter {
  final selectedIndexes = <int>[];

  @override
  void setActiveIndex(int index, {bool notify = true}) =>
      selectedIndexes.add(index);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUpAll(() async {
    await S.load(const Locale('en'));
  });

  Widget buildSubject(TabsRouter tabsRouter) {
    return MaterialApp(
      theme: buildDarkTheme(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: TabsRouterScope(
        controller: tabsRouter,
        stateHash: 0,
        child: const LibraryScreen(),
      ),
    );
  }

  testWidgets('shows the library title and the saved-games empty state', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(_RecordingTabsRouter()));

    expect(find.text(S.current.library), findsOneWidget);
    expect(find.text(S.current.no_games_saved.toUpperCase()), findsOneWidget);
    expect(find.text(S.current.no_games_saved_description), findsOneWidget);
    expect(find.text(S.current.browse_games), findsOneWidget);
  });

  testWidgets(
    'reports the browse tab index when the empty state action is tapped',
    (tester) async {
      final tabsRouter = _RecordingTabsRouter();
      await tester.pumpWidget(buildSubject(tabsRouter));

      await tester.tap(find.text(S.current.browse_games));
      await tester.pump();

      expect(tabsRouter.selectedIndexes, [2]);
    },
  );
}

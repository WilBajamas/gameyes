import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/features/games/presentation/blocs/games_bloc.dart';
import 'package:gaming_library_assessment_flutter/features/games/presentation/blocs/games_state.dart';
import 'package:gaming_library_assessment_flutter/features/games/presentation/screens/games_screen.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_card/game_card.dart';
import 'package:gaming_library_assessment_flutter/widgets/library_tick.dart';
import 'package:gaming_library_assessment_flutter/widgets/status_chip.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/games_state_mock.dart';
import 'games_screen_test.mocks.dart';

@GenerateMocks([GamesBloc, StackRouter])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  late MockGamesBloc bloc;
  late MockStackRouter router;

  setUpAll(() {
    provideDummy<GamesState>(const GamesState());
  });

  setUp(() {
    bloc = MockGamesBloc();
    router = MockStackRouter();
    when(bloc.state).thenReturn(mockExistingGamesState);
    when(bloc.stream).thenAnswer((_) => const Stream.empty());
    when(router.push<dynamic>(any)).thenAnswer((_) async => null);
  });

  Widget buildSubject() {
    return StackRouterScope(
      controller: router,
      stateHash: 0,
      child: MaterialApp(
        theme: buildDarkTheme(),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: BlocProvider<GamesBloc>.value(
          value: bloc,
          child: const Scaffold(
            body: CustomScrollView(slivers: [GamesSliverGrid()]),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'shows a card for each game with no status chip and no library tick',
    (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 3000);

      await tester.pumpWidget(buildSubject());

      expect(
        find.byType(GameCard),
        findsNWidgets(mockExistingGamesState.games.length),
      );
      expect(find.byType(StatusChip), findsNothing);
      expect(find.byType(LibraryTick), findsNothing);
    },
  );

  testWidgets('renders the grid without overflow at a narrow and a wide '
      'surface', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.devicePixelRatio = 1;

    tester.view.physicalSize = const Size(320, 844);
    await tester.pumpWidget(buildSubject());
    expect(tester.takeException(), isNull);
    expect(find.text(mockExistingGamesState.games.first.name), findsWidgets);

    tester.view.physicalSize = const Size(430, 932);
    await tester.pumpWidget(buildSubject());
    expect(tester.takeException(), isNull);
    expect(find.text(mockExistingGamesState.games.first.name), findsWidgets);
  });

  testWidgets(
    'pushes the game detail route with the unchanged payload when a card '
    'is tapped',
    (tester) async {
      await tester.pumpWidget(buildSubject());

      await tester.tap(find.byType(GameCard).first);

      final game = mockExistingGamesState.games.first;
      final captured = verify(router.push<dynamic>(captureAny)).captured;
      final route = captured.single as GameDetailRoute;

      expect(route.args!.gameExtra, (
        game.id,
        RouteConstants.games,
        game.cover.url,
      ));
    },
  );
}

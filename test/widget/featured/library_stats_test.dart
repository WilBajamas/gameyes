import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/entities/now_playing_game_entity.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repositories/featured_repository.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/widgets/library_stats.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/empty_state_card.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() async {
    await S.load(const Locale('en'));
  });

  Widget buildSubject({required LibrarySnapshotEntity snapshot}) {
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
        body: LibraryStatsWidget(
          snapshot: snapshot,
          isChecklistDismissed: true,
          step1Completed: true,
          step2Completed: true,
          step3Completed: true,
          checklistProgress: 1.0,
          onAddPlayedGame: () {},
          onMarkNowPlaying: () {},
          onWishlistUpcoming: () {},
        ),
      ),
    );
  }

  testWidgets('shows the playing game title when a game is playing', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        snapshot: LibrarySnapshotEntity(
          totalGamesCount: 1,
          nowPlayingGames: [
            const NowPlayingGameEntity(title: 'Chrono Trigger', coverUrl: null),
          ],
          thisWeekPlayHours: 0.0,
          wishlistCount: 0,
          ownedGameIds: {1},
        ),
      ),
    );

    expect(find.text('Chrono Trigger'), findsOneWidget);
  });

  testWidgets('shows the empty state card when nothing is playing', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        snapshot: LibrarySnapshotEntity(
          totalGamesCount: 1,
          nowPlayingGames: const [],
          thisWeekPlayHours: 0.0,
          wishlistCount: 0,
          ownedGameIds: {1},
        ),
      ),
    );

    expect(find.byType(EmptyStateCard), findsOneWidget);
  });
}

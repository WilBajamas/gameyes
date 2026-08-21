import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_cover_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/critic_badge.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_cached_network_image.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_card/game_card.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_card/game_card_size.dart';
import 'package:gaming_library_assessment_flutter/widgets/library_tick.dart';
import 'package:gaming_library_assessment_flutter/widgets/platform_row_list.dart';
import 'package:gaming_library_assessment_flutter/widgets/status_chip.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../mocks/game_mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildSubject({
    required GameCardSize size,
    GameEntity? game,
    String? fromScreen,
    double? criticScore,
    LibraryStatus? status,
    bool inLibrary = false,
    VoidCallback? onTap,
    VoidCallback? onAddTap,
  }) {
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
        body: Center(
          child: SizedBox(
            width: size.width,
            child: GameCard(
              size: size,
              game: game,
              fromScreen: fromScreen,
              criticScore: criticScore,
              status: status,
              inLibrary: inLibrary,
              onTap: onTap,
              onAddTap: onAddTap,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('shows the missing-art glyph when no cover url is supplied', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        size: GameCardSize.md,
        game: mockGameEntity.copyWith(cover: const GameCoverEntity()),
      ),
    );

    expect(find.byIcon(Icons.videogame_asset_outlined), findsOneWidget);
    expect(find.byType(DefaultCachedNetworkImage), findsNothing);
  });

  testWidgets(
    'shows the library tick, the status chip and the critic badge when the '
    'caller supplies them',
    (tester) async {
      await tester.pumpWidget(
        buildSubject(
          size: GameCardSize.md,
          game: mockGameEntity,
          inLibrary: true,
          status: LibraryStatus.playing,
          criticScore: 87.6,
        ),
      );

      expect(find.byType(LibraryTick), findsOneWidget);

      final chip = tester.widget<StatusChip>(find.byType(StatusChip));
      expect(chip.status, LibraryStatus.playing);
      expect(chip.variant, StatusChipVariant.onMedia);

      final badge = tester.widget<CriticBadge>(find.byType(CriticBadge));
      expect(badge.score, 87.6);
    },
  );

  testWidgets(
    'hides the overlays, the platform row and the add action when the '
    'caller supplies none of them',
    (tester) async {
      await tester.pumpWidget(
        buildSubject(
          size: GameCardSize.md,
          game: mockGameEntity.copyWith(platforms: const []),
        ),
      );

      expect(find.byType(LibraryTick), findsNothing);
      expect(find.byType(StatusChip), findsNothing);
      expect(find.byType(CriticBadge), findsNothing);
      expect(find.byType(PlatformRowList), findsNothing);
      expect(find.byType(IconButton), findsNothing);
    },
  );

  testWidgets('hides the title at xs', (tester) async {
    await tester.pumpWidget(
      buildSubject(size: GameCardSize.xs, game: mockGameEntity),
    );

    expect(find.text(mockGameEntity.name), findsNothing);
  });

  testWidgets('shows the title and the platform row capped at one at sm', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(size: GameCardSize.sm, game: mockGameEntity),
    );

    expect(find.text(mockGameEntity.name), findsOneWidget);

    final row = tester.widget<PlatformRowList>(find.byType(PlatformRowList));
    expect(row.showMax, 1);
    expect(row.platforms, mockGameEntity.platforms);
  });

  testWidgets(
    'shows the release date, the platform row and the add action at md',
    (tester) async {
      await tester.pumpWidget(
        buildSubject(
          size: GameCardSize.md,
          game: mockGameEntity,
          onAddTap: () {},
        ),
      );

      expect(
        find.text(mockGameEntity.releaseDates!.first.human),
        findsOneWidget,
      );

      final row = tester.widget<PlatformRowList>(find.byType(PlatformRowList));
      expect(row.platforms, mockGameEntity.platforms);

      expect(find.byType(IconButton), findsOneWidget);
    },
  );

  testWidgets(
    'calls the add action without calling the card tap when the add is '
    'tapped',
    (tester) async {
      var tapped = false;
      var added = false;

      await tester.pumpWidget(
        buildSubject(
          size: GameCardSize.md,
          game: mockGameEntity,
          onTap: () => tapped = true,
          onAddTap: () => added = true,
        ),
      );

      await tester.tap(find.byType(IconButton));

      expect(added, isTrue);
      expect(tapped, isFalse);
    },
  );

  testWidgets('calls the tap action once when the card is tapped', (
    tester,
  ) async {
    var tapCount = 0;

    await tester.pumpWidget(
      buildSubject(
        size: GameCardSize.md,
        game: mockGameEntity,
        onTap: () => tapCount++,
      ),
    );

    await tester.tap(find.byType(GameCard));

    expect(tapCount, 1);
  });

  testWidgets('uses the shared hero tag built from the game id and '
      'fromScreen', (tester) async {
    await tester.pumpWidget(
      buildSubject(
        size: GameCardSize.md,
        game: mockGameEntity.copyWith(id: 42),
        fromScreen: 'test_from_screen',
      ),
    );

    final hero = tester.widget<Hero>(find.byType(Hero));

    expect(hero.tag, '${ConfigConstants.heroTag}/42/test_from_screen');
  });

  testWidgets('registers no hero when several dataless cards render '
      'together', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildDarkTheme(),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Scaffold(
          body: ListView(
            children: const [
              GameCard(size: GameCardSize.md),
              GameCard(size: GameCardSize.md),
              GameCard(size: GameCardSize.md),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(Hero), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

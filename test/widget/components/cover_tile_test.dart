import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/cover_tile.dart';
import 'package:gaming_library_assessment_flutter/widgets/status_chip.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildSubject({
    required CoverTileSize size,
    String? imageUrl,
    LibraryStatus? status,
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
        body: CoverTile(size: size, imageUrl: imageUrl, status: status),
      ),
    );
  }

  testWidgets('uses the dimensions defined by each size', (tester) async {
    const expectedSizes = {
      CoverTileSize.mini: Size(26, 34),
      CoverTileSize.row: Size(112, 150),
      CoverTileSize.fan: Size(100, 134),
      CoverTileSize.focal: Size(124, 166),
    };

    for (final entry in expectedSizes.entries) {
      await tester.pumpWidget(buildSubject(size: entry.key));

      expect(tester.getSize(find.byType(CoverTile)), entry.value);
    }
  });

  testWidgets('shows a fallback glyph when the image url is null or empty', (
    tester,
  ) async {
    for (final imageUrl in <String?>[null, '']) {
      await tester.pumpWidget(
        buildSubject(size: CoverTileSize.row, imageUrl: imageUrl),
      );

      expect(find.byIcon(Icons.videogame_asset_outlined), findsOneWidget);
    }
  });

  testWidgets('hides the fallback glyph at mini size', (tester) async {
    await tester.pumpWidget(buildSubject(size: CoverTileSize.mini));

    expect(find.byIcon(Icons.videogame_asset_outlined), findsNothing);
  });

  testWidgets('shows the supplied status using the on-media variant', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(size: CoverTileSize.row, status: LibraryStatus.playing),
    );

    final chip = tester.widget<StatusChip>(find.byType(StatusChip));

    expect(chip.status, LibraryStatus.playing);
    expect(chip.variant, StatusChipVariant.onMedia);
  });

  testWidgets('hides the status when none is supplied', (tester) async {
    await tester.pumpWidget(buildSubject(size: CoverTileSize.row));

    expect(find.byType(StatusChip), findsNothing);
  });

  testWidgets('hides the status at mini size even when one is supplied', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(size: CoverTileSize.mini, status: LibraryStatus.playing),
    );

    expect(find.byType(StatusChip), findsNothing);
  });
}

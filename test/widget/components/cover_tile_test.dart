import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_color_tokens.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_tokens.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/cover_tile.dart';
import 'package:gaming_library_assessment_flutter/widgets/status_chip.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  late final AppColorTokens colors;

  setUpAll(() async {
    colors = (await resolveDarkTokensAfterFontsSettle()).color;
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

  Widget buildSubject({
    required CoverTileSize size,
    String? imageUrl,
    LibraryStatus? status,
  }) {
    return wrap(CoverTile(size: size, imageUrl: imageUrl, status: status));
  }

  testWidgets('shows its stated dimensions for each of the four sizes', (
    tester,
  ) async {
    const expected = {
      CoverTileSize.mini: Size(26, 34),
      CoverTileSize.row: Size(112, 150),
      CoverTileSize.fan: Size(100, 134),
      CoverTileSize.focal: Size(124, 166),
    };

    for (final entry in expected.entries) {
      await tester.pumpWidget(buildSubject(size: entry.key));
      expect(tester.getSize(find.byType(CoverTile)), entry.value);
    }
  });

  testWidgets(
    'shows the status chip using the on-media variant when a status is '
    'supplied',
    (tester) async {
      await tester.pumpWidget(
        buildSubject(size: CoverTileSize.row, status: LibraryStatus.playing),
      );

      final chip = tester.widget<StatusChip>(find.byType(StatusChip));
      expect(chip.variant, StatusChipVariant.onMedia);
    },
  );

  testWidgets('hides the status chip when no status is supplied', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(size: CoverTileSize.row));

    expect(find.byType(StatusChip), findsNothing);
  });

  testWidgets(
    'hides the status chip at the mini size even when a status is supplied',
    (tester) async {
      await tester.pumpWidget(
        buildSubject(size: CoverTileSize.mini, status: LibraryStatus.playing),
      );

      expect(find.byType(StatusChip), findsNothing);
    },
  );

  testWidgets(
    'shows the onyx fallback with a hairline and a gamepad glyph when the '
    'url is null or empty',
    (tester) async {
      for (final imageUrl in [null, '']) {
        await tester.pumpWidget(
          buildSubject(size: CoverTileSize.row, imageUrl: imageUrl),
        );

        final decorated = tester.widget<DecoratedBox>(
          find.descendant(
            of: find.byType(CoverTile),
            matching: find.byType(DecoratedBox),
          ),
        );
        final decoration = decorated.decoration as BoxDecoration;
        expect(decoration.color, colors.canvas);
        expect(decoration.border, Border.all(color: colors.hairline));
        expect(find.byIcon(Icons.videogame_asset_outlined), findsOneWidget);
      }
    },
  );

  testWidgets('hides the glyph from the fallback at the mini size', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(size: CoverTileSize.mini));

    expect(find.byType(Icon), findsNothing);
  });
}

Future<AppTokens> resolveDarkTokensAfterFontsSettle() async {
  final future = runZonedGuarded<Future<AppTokens>>(() async {
    return AppTokens.dark;
  }, (error, stack) {});
  return await future!;
}

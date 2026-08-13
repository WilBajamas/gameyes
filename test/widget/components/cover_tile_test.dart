import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_color_tokens.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_radius_tokens.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_tokens.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/cover_tile.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_cached_network_image.dart';
import 'package:gaming_library_assessment_flutter/widgets/status_chip.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

// A minimal one-pixel transparent GIF, decodable without a real network
// call, used to exercise the loaded-image branch's built widgets.
final _fakeImageBytes = Uint8List.fromList([
  0x47,
  0x49,
  0x46,
  0x38,
  0x39,
  0x61,
  0x01,
  0x00,
  0x01,
  0x00,
  0x80,
  0x00,
  0x00,
  0xFF,
  0xFF,
  0xFF,
  0x00,
  0x00,
  0x00,
  0x21,
  0xF9,
  0x04,
  0x01,
  0x00,
  0x00,
  0x00,
  0x00,
  0x2C,
  0x00,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x01,
  0x00,
  0x00,
  0x02,
  0x02,
  0x44,
  0x01,
  0x00,
  0x3B,
]);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  late final AppColorTokens colors;
  late final AppRadiusTokens radius;

  // Same font warm-up as test/widget/components/status_chip_test.dart.
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

  // Builds the widget the loaded-image branch would render, without
  // hitting the network: pulls the builder off the pumped
  // DefaultCachedNetworkImage and invokes it directly.
  Future<Widget> pumpLoadedArtwork(
    WidgetTester tester,
    CoverTileSize size,
  ) async {
    await tester.pumpWidget(
      buildSubject(size: size, imageUrl: 'https://example.com/cover.png'),
    );
    final dcni = tester.widget<DefaultCachedNetworkImage>(
      find.byType(DefaultCachedNetworkImage),
    );
    final context = tester.element(find.byType(DefaultCachedNetworkImage));
    final artwork = dcni.imageBuilder!(context, MemoryImage(_fakeImageBytes));
    await tester.pumpWidget(wrap(artwork));
    return artwork;
  }

  Future<void> pumpFailedArtwork(
    WidgetTester tester,
    CoverTileSize size,
  ) async {
    await tester.pumpWidget(
      buildSubject(size: size, imageUrl: 'https://example.com/cover.png'),
    );
    final dcni = tester.widget<DefaultCachedNetworkImage>(
      find.byType(DefaultCachedNetworkImage),
    );
    final context = tester.element(find.byType(DefaultCachedNetworkImage));
    final fallback = dcni.errorWidget!(
      context,
      'https://example.com/cover.png',
      Exception('load failed'),
    );
    await tester.pumpWidget(wrap(fallback));
  }

  Future<void> pumpLoadingPlaceholder(
    WidgetTester tester,
    CoverTileSize size,
  ) async {
    await tester.pumpWidget(
      buildSubject(size: size, imageUrl: 'https://example.com/cover.png'),
    );
    final dcni = tester.widget<DefaultCachedNetworkImage>(
      find.byType(DefaultCachedNetworkImage),
    );
    final context = tester.element(find.byType(DefaultCachedNetworkImage));
    final loading = dcni.placeholder!(context, 'https://example.com/cover.png');
    await tester.pumpWidget(wrap(loading));
    await tester.pump();
  }

  testWidgets('should render its stated dimensions when each of the four sizes '
      'renders', (tester) async {
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

  testWidgets('should clip to the mini radius at mini and the lg radius at the '
      'other three sizes', (tester) async {
    await tester.pumpWidget(buildSubject(size: CoverTileSize.mini));
    var clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
    expect(clip.borderRadius, BorderRadius.circular(radius.mini));

    for (final size in [
      CoverTileSize.row,
      CoverTileSize.fan,
      CoverTileSize.focal,
    ]) {
      await tester.pumpWidget(buildSubject(size: size));
      clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clip.borderRadius, BorderRadius.circular(radius.lg));
    }
  });

  testWidgets(
    'should render the wash at coverWash above the artwork when art loads',
    (tester) async {
      final artwork = await pumpLoadedArtwork(tester, CoverTileSize.row);

      final stack = tester.widget<Stack>(
        find.descendant(
          of: find.byWidget(artwork),
          matching: find.byType(Stack),
        ),
      );
      final children = stack.children;

      expect(children[0], isA<Image>());
      final wash = children[1] as ColoredBox;
      expect(wash.color, colors.coverWash);
    },
  );

  testWidgets(
    'should render the artwork with no colour filter when art loads',
    (tester) async {
      for (final size in CoverTileSize.values) {
        final artwork = await pumpLoadedArtwork(tester, size);

        expect(
          find.descendant(
            of: find.byWidget(artwork),
            matching: find.byType(ColorFiltered),
          ),
          findsNothing,
        );
        expect(
          find.descendant(
            of: find.byWidget(artwork),
            matching: find.byType(Opacity),
          ),
          findsNothing,
        );

        final image = tester.widget<Image>(
          find.descendant(
            of: find.byWidget(artwork),
            matching: find.byType(Image),
          ),
        );
        expect(image.color, isNull);
        expect(image.colorBlendMode, isNull);
      }
    },
  );

  testWidgets(
    'should render no wash over the fallback when no url is supplied',
    (tester) async {
      await tester.pumpWidget(buildSubject(size: CoverTileSize.row));

      expect(
        find.byWidgetPredicate(
          (widget) => widget is ColoredBox && widget.color == colors.coverWash,
        ),
        findsNothing,
      );
    },
  );

  testWidgets(
    'should render the status chip bottom-left in the on-media variant '
    'when a status is supplied',
    (tester) async {
      await tester.pumpWidget(
        buildSubject(size: CoverTileSize.row, status: LibraryStatus.playing),
      );

      final chip = tester.widget<StatusChip>(find.byType(StatusChip));
      expect(chip.variant, StatusChipVariant.onMedia);

      final positioned = tester.widget<Positioned>(
        find.ancestor(
          of: find.byType(StatusChip),
          matching: find.byType(Positioned),
        ),
      );
      expect(positioned.left, 8);
      expect(positioned.bottom, 8);
    },
  );

  testWidgets(
    'should render nothing in the chip slot when no status is supplied',
    (tester) async {
      await tester.pumpWidget(
        buildSubject(size: CoverTileSize.row, status: LibraryStatus.playing),
      );
      final chippedSize = tester.getSize(find.byType(CoverTile));

      await tester.pumpWidget(buildSubject(size: CoverTileSize.row));
      expect(find.byType(StatusChip), findsNothing);
      expect(tester.getSize(find.byType(CoverTile)), chippedSize);
    },
  );

  testWidgets('should render no chip at the mini size even when a status is '
      'supplied', (tester) async {
    await tester.pumpWidget(
      buildSubject(size: CoverTileSize.mini, status: LibraryStatus.playing),
    );

    expect(find.byType(StatusChip), findsNothing);
  });

  testWidgets(
    'should render the onyx fallback with a hairline and a gamepad glyph '
    'when the url is null or empty',
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
        expect(find.byIcon(Icons.error), findsNothing);
        expect(find.byType(Image), findsNothing);
        expect(find.byType(Text), findsNothing);
      }
    },
  );

  testWidgets('should render the same fallback when the image fails to load', (
    tester,
  ) async {
    await pumpFailedArtwork(tester, CoverTileSize.row);

    final decorated = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
    final decoration = decorated.decoration as BoxDecoration;
    expect(decoration.color, colors.canvas);
    expect(decoration.border, Border.all(color: colors.hairline));
    expect(find.byIcon(Icons.videogame_asset_outlined), findsOneWidget);
  });

  testWidgets('should omit the glyph from the fallback at the mini size', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(size: CoverTileSize.mini));

    final decorated = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(CoverTile),
        matching: find.byType(DecoratedBox),
      ),
    );
    final decoration = decorated.decoration as BoxDecoration;
    expect(decoration.color, colors.canvas);
    expect(decoration.border, Border.all(color: colors.hairline));
    expect(find.byType(Icon), findsNothing);
  });

  testWidgets(
    'should render no CircularProgressIndicator while the image loads',
    (tester) async {
      await pumpLoadingPlaceholder(tester, CoverTileSize.row);

      expect(
        find.byWidgetPredicate((widget) => widget is Skeletonizer),
        findsOneWidget,
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets('should add no spacing of its own when rendering', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(size: CoverTileSize.row));

    final sizedBox = find.descendant(
      of: find.byType(CoverTile),
      matching: find.byType(SizedBox),
    );
    expect(
      find.ancestor(of: sizedBox, matching: find.byType(Padding)),
      findsNothing,
    );
    expect(tester.getSize(find.byType(CoverTile)), const Size(112, 150));
  });
}

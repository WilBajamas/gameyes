import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_color_tokens.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_tokens.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/glass_surface_widget.dart';
import 'package:gaming_library_assessment_flutter/widgets/status_chip.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  late final AppColorTokens colors;

  setUpAll(() async {
    colors = (await resolveDarkTokensAfterFontsSettle()).color;
  });

  Widget buildSubject({
    required LibraryStatus status,
    required StatusChipVariant variant,
    int? count,
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
        body: StatusChip(status: status, variant: variant, count: count),
      ),
    );
  }

  Finder capsuleFinder() => find.byWidgetPredicate(
    (widget) =>
        widget is DecoratedBox &&
        (widget.decoration as BoxDecoration).borderRadius != null,
  );

  const tintedStatuses = [
    LibraryStatus.backlog,
    LibraryStatus.completed,
    LibraryStatus.onHold,
    LibraryStatus.wishlist,
    LibraryStatus.dropped,
  ];

  Color tokenColorFor(LibraryStatus status) => switch (status) {
    LibraryStatus.playing => colors.status.playing.color,
    LibraryStatus.backlog => colors.status.backlog.color,
    LibraryStatus.completed => colors.status.completed.color,
    LibraryStatus.onHold => colors.status.onHold.color,
    LibraryStatus.wishlist => colors.status.wishlist.color,
    LibraryStatus.dropped => colors.status.dropped.color,
  };

  testWidgets(
    'shows each status dot in its token colour across all six statuses',
    (tester) async {
      for (final status in LibraryStatus.values) {
        await tester.pumpWidget(
          buildSubject(status: status, variant: StatusChipVariant.list),
        );

        final dot = tester.widget<Container>(
          find.descendant(
            of: find.byType(StatusChip),
            matching: find.byType(Container),
          ),
        );
        final decoration = dot.decoration! as BoxDecoration;

        final expected = status == LibraryStatus.playing
            ? colors.ink
            : tokenColorFor(status);
        expect(decoration.color, expected);
      }
    },
  );

  testWidgets(
    'fills the capsule with the status colour and shows the dot in ink when '
    'the status is playing',
    (tester) async {
      await tester.pumpWidget(
        buildSubject(
          status: LibraryStatus.playing,
          variant: StatusChipVariant.list,
        ),
      );

      final capsule = tester.widget<DecoratedBox>(capsuleFinder());
      final decoration = capsule.decoration as BoxDecoration;

      expect(decoration.color, colors.status.playing.fill);
      expect(find.byType(GlassSurface), findsNothing);

      final dot = tester.widget<Container>(
        find.descendant(
          of: find.byType(StatusChip),
          matching: find.byType(Container),
        ),
      );
      expect((dot.decoration! as BoxDecoration).color, colors.ink);
    },
  );

  testWidgets(
    'fills the capsule with 8% ink when a tinted status renders in the list '
    'variant',
    (tester) async {
      for (final status in tintedStatuses) {
        await tester.pumpWidget(
          buildSubject(status: status, variant: StatusChipVariant.list),
        );

        final capsule = tester.widget<DecoratedBox>(capsuleFinder());
        final decoration = capsule.decoration as BoxDecoration;

        expect(decoration.color, colors.ink08);
      }
    },
  );

  testWidgets(
    'hides the blur when a tinted status renders in the list variant',
    (tester) async {
      await tester.pumpWidget(
        buildSubject(
          status: LibraryStatus.backlog,
          variant: StatusChipVariant.list,
        ),
      );

      expect(find.byType(BackdropFilter), findsNothing);
    },
  );

  testWidgets(
    'fills the capsule with 42% black behind a blur in the on-media variant',
    (tester) async {
      await tester.pumpWidget(
        buildSubject(
          status: LibraryStatus.backlog,
          variant: StatusChipVariant.onMedia,
        ),
      );

      final glass = tester.widget<GlassSurface>(find.byType(GlassSurface));

      expect(glass.fill, colors.glass42);
      expect(find.byType(BackdropFilter), findsOneWidget);
    },
  );

  testWidgets('sizes the dot 6px on media and 7px in a list', (tester) async {
    await tester.pumpWidget(
      buildSubject(
        status: LibraryStatus.backlog,
        variant: StatusChipVariant.onMedia,
      ),
    );
    var dotSize = tester.getSize(
      find.descendant(
        of: find.byType(StatusChip),
        matching: find.byType(Container),
      ),
    );
    expect(dotSize.width, 6);
    expect(dotSize.height, 6);

    await tester.pumpWidget(
      buildSubject(
        status: LibraryStatus.backlog,
        variant: StatusChipVariant.list,
      ),
    );
    dotSize = tester.getSize(
      find.descendant(
        of: find.byType(StatusChip),
        matching: find.byType(Container),
      ),
    );
    expect(dotSize.width, 7);
    expect(dotSize.height, 7);
  });

  testWidgets('renders the pill radius on the capsule in both variants', (
    tester,
  ) async {
    final expectedRadius = BorderRadius.circular(AppTokens.dark.radius.pill);

    await tester.pumpWidget(
      buildSubject(
        status: LibraryStatus.playing,
        variant: StatusChipVariant.list,
      ),
    );
    final capsule = tester.widget<DecoratedBox>(capsuleFinder());
    expect((capsule.decoration as BoxDecoration).borderRadius, expectedRadius);

    await tester.pumpWidget(
      buildSubject(
        status: LibraryStatus.backlog,
        variant: StatusChipVariant.onMedia,
      ),
    );
    final glass = tester.widget<GlassSurface>(find.byType(GlassSurface));
    expect(glass.borderRadius, expectedRadius);
  });

  testWidgets('shows the label uppercase in the pill token style', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        status: LibraryStatus.backlog,
        variant: StatusChipVariant.list,
      ),
    );

    final text = tester.widget<Text>(find.text('BACKLOG'));
    final expected = AppTokens.dark.typography.pill.style.copyWith(
      color: colors.ink,
    );

    expect(text.style, expected);
  });

  testWidgets('shows the count after the label when a count is supplied', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        status: LibraryStatus.backlog,
        variant: StatusChipVariant.list,
        count: 12,
      ),
    );

    expect(find.text('12'), findsOneWidget);
    final text = tester.widget<Text>(find.text('12'));
    expect(text.style?.color, colors.ink55);
  });

  testWidgets('shows the count when the count is zero', (tester) async {
    await tester.pumpWidget(
      buildSubject(
        status: LibraryStatus.backlog,
        variant: StatusChipVariant.list,
        count: 0,
      ),
    );

    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('shows the count in full ink when the status is playing', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        status: LibraryStatus.playing,
        variant: StatusChipVariant.list,
        count: 3,
      ),
    );

    final text = tester.widget<Text>(find.text('3'));
    expect(text.style?.color, colors.ink);
  });

  testWidgets('hides the count when none is supplied', (tester) async {
    await tester.pumpWidget(
      buildSubject(
        status: LibraryStatus.backlog,
        variant: StatusChipVariant.list,
      ),
    );

    expect(
      find.descendant(of: find.byType(StatusChip), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('renders the capsule flush with no extra spacing', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        status: LibraryStatus.backlog,
        variant: StatusChipVariant.list,
      ),
    );

    final chipSize = tester.getSize(find.byType(StatusChip));
    final capsuleSize = tester.getSize(capsuleFinder());

    expect(chipSize, capsuleSize);
  });
}

Future<AppTokens> resolveDarkTokensAfterFontsSettle() {
  final completer = Completer<AppTokens>();
  runZonedGuarded<Future<void>>(() async {
    final tokens = AppTokens.dark;
    await Future<void>.delayed(const Duration(milliseconds: 250));
    completer.complete(tokens);
  }, (error, stack) {});
  return completer.future;
}

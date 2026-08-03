import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_color_tokens.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_tokens.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  // Both must run before the themes are built: they resolve their faces
  // through GoogleFonts, which reads the asset bundle.
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  late final ThemeData lightTheme;
  late final ThemeData darkTheme;
  late final AppColorTokens colors;

  setUpAll(() async {
    final themes = await _buildThemes();
    lightTheme = themes.light;
    darkTheme = themes.dark;
    colors = AppTokens.dark.color;
  });

  Widget app({required Widget child}) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: child,
    );
  }

  group('buildDarkTheme — extension registration', () {
    test('should carry an AppTokens extension when the theme is built', () {
      expect(darkTheme.extension<AppTokens>(), isNotNull);
      expect(darkTheme.extension<AppTokens>(), isA<AppTokens>());
    });

    test('should expose all five token groups when the extension resolves', () {
      final tokens = darkTheme.extension<AppTokens>()!;

      expect(tokens.color, isNotNull);
      expect(tokens.typography, isNotNull);
      expect(tokens.radius, isNotNull);
      expect(tokens.motion, isNotNull);
      expect(tokens.effect, isNotNull);
    });
  });

  group('buildDarkTheme — scheme and scaffold', () {
    test('should paint the scaffold onyx when the theme is built', () {
      expect(darkTheme.scaffoldBackgroundColor, colors.canvas);
    });

    test('should resolve primary to indigo and not green when the theme is '
        'built', () {
      expect(darkTheme.colorScheme.primary, colors.accentIndigo);
      expect(darkTheme.colorScheme.primary, isNot(colors.green));
    });

    test(
      'should resolve surface to the canvas token when the theme is built',
      () {
        expect(darkTheme.colorScheme.surface, colors.canvas);
      },
    );

    test('should drop the retired cyan seed when the theme is built', () {
      const retiredCyanSeed = Color(0xFF4CC9F0);

      expect(darkTheme.colorScheme.primary, isNot(retiredCyanSeed));
      expect(darkTheme.colorScheme.surface, isNot(retiredCyanSeed));
      expect(darkTheme.colorScheme.secondary, isNot(retiredCyanSeed));
      expect(darkTheme.scaffoldBackgroundColor, isNot(retiredCyanSeed));
    });

    test('should re-point the remaining scheme roles at tokens when the '
        'theme is built', () {
      final scheme = darkTheme.colorScheme;

      expect(scheme.secondary, colors.accentMagenta);
      expect(scheme.tertiary, colors.accentLinkCyan);
      expect(scheme.onSurface, colors.ink);
      expect(scheme.outline, colors.hairline);
      expect(scheme.error, colors.error);
    });
  });

  group('buildDarkTheme — text theme', () {
    test('should resolve the display face to Space Grotesk when the theme is '
        'built', () {
      expect(
        darkTheme.textTheme.displayLarge?.fontFamily,
        contains('SpaceGrotesk'),
      );
      expect(
        darkTheme.textTheme.titleLarge?.fontFamily,
        contains('SpaceGrotesk'),
      );
    });

    test('should resolve the body face to Inter when the theme is built', () {
      expect(darkTheme.textTheme.bodyLarge?.fontFamily, contains('Inter'));
      expect(darkTheme.textTheme.bodyMedium?.fontFamily, contains('Inter'));
      expect(darkTheme.textTheme.labelSmall?.fontFamily, contains('Inter'));
    });

    test('should drop the previous faces when the theme is built', () {
      final textTheme = darkTheme.textTheme;

      final families = <String?>[
        textTheme.displayLarge?.fontFamily,
        textTheme.headlineMedium?.fontFamily,
        textTheme.titleLarge?.fontFamily,
        textTheme.bodyLarge?.fontFamily,
        textTheme.bodyMedium?.fontFamily,
        textTheme.bodySmall?.fontFamily,
        textTheme.labelLarge?.fontFamily,
        textTheme.labelMedium?.fontFamily,
        textTheme.labelSmall?.fontFamily,
      ];

      for (final family in families) {
        expect(family, isNotNull);
        expect(family, isNot(contains('ChakraPetch')));
        expect(family, isNot(contains('OpenSans')));
      }
    });
  });

  group('AppTokens resolution from the widget tree', () {
    testWidgets('should resolve a non-null AppTokens when read from a '
        'descendant of the app root', (tester) async {
      AppTokens? resolved;

      await tester.pumpWidget(
        app(
          child: Builder(
            builder: (context) {
              resolved = Theme.of(context).extension<AppTokens>();
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolved, isNotNull);
      expect(resolved!.color.canvas, colors.canvas);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should still resolve AppTokens when the device reports '
        'light platform brightness', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

      AppTokens? resolved;
      Brightness? brightness;
      Color? scaffold;

      await tester.pumpWidget(
        app(
          child: Builder(
            builder: (context) {
              resolved = Theme.of(context).extension<AppTokens>();
              brightness = Theme.of(context).colorScheme.brightness;
              scaffold = Theme.of(context).scaffoldBackgroundColor;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolved, isNotNull);
      expect(brightness, Brightness.dark);
      expect(scaffold, colors.canvas);
      expect(tester.takeException(), isNull);
    });
  });

  group('Reduced motion', () {
    testWidgets('should collapse a duration to zero when animations are '
        'disabled', (tester) async {
      Duration? resolved;

      await tester.pumpWidget(
        app(
          child: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Builder(
              builder: (context) {
                final motion = Theme.of(context).extension<AppTokens>()!.motion;
                resolved = motion.resolve(context, motion.stateChange);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(resolved, Duration.zero);
    });

    testWidgets('should keep the duration when animations are not disabled', (
      tester,
    ) async {
      Duration? resolved;

      await tester.pumpWidget(
        app(
          child: MediaQuery(
            data: const MediaQueryData(),
            child: Builder(
              builder: (context) {
                final motion = Theme.of(context).extension<AppTokens>()!.motion;
                resolved = motion.resolve(context, motion.stateChange);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(resolved, const Duration(milliseconds: 140));
      expect(resolved, isNot(Duration.zero));
    });
  });
}

// Fonts can't actually load in a test environment (no network, no bundled
// files), and that failure happens in the background where nothing's
// watching for it - so without this wrapper it would silently crash a
// totally unrelated test. This catches it safely instead, and every test
// below reuses these same built themes.
Future<({ThemeData light, ThemeData dark})> _buildThemes() {
  final completer = Completer<({ThemeData light, ThemeData dark})>();

  runZonedGuarded<Future<void>>(() async {
    final themes = (light: buildTheme(), dark: buildDarkTheme());
    await Future<void>.delayed(const Duration(milliseconds: 250));
    completer.complete(themes);
  }, (error, stack) {});

  return completer.future;
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_color_tokens.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_effect_tokens.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_motion_tokens.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_radius_tokens.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_status_tokens.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_tokens.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_type_tokens.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  late final AppColorTokens colors;
  late final AppTypeTokens type;
  late final AppRadiusTokens radius;
  late final AppMotionTokens motion;
  late final AppEffectTokens effect;

  setUpAll(() async {
    final tokens = await _resolveTokens();
    colors = tokens.color;
    type = tokens.typography;
    radius = tokens.radius;
    motion = tokens.motion;
    effect = tokens.effect;
  });

  group('AppColorTokens — surfaces', () {
    test('should expose the onyx canvas when reading the dark set', () {
      expect(colors.canvas, const Color(0xFF23272A));
    });

    test('should expose three distinct raised surfaces when reading the '
        'dark set', () {
      expect(colors.surfaceRaised, const Color(0xFF2F333C));
      expect(colors.surfaceIndigoPanel, const Color(0xFF2F3782));
      expect(colors.surfaceTabChrome, const Color(0xFF2E3236));

      final distinct = <Color>{
        colors.surfaceRaised,
        colors.surfaceIndigoPanel,
        colors.surfaceTabChrome,
      };
      expect(distinct.length, 3);
    });

    test('should expose the toast surface when reading the dark set', () {
      expect(colors.surfaceToast, const Color(0xFF2E3236));
    });

    test(
      'should keep surfaceTabChrome unchanged when reading the dark set',
      () {
        expect(colors.surfaceTabChrome, const Color(0xFF2E3236));
      },
    );

    test('should not tokenise #1e2353 when scanning the whole colour set', () {
      const unusable = Color(0xFF1E2353);

      expect(_allColors(colors).contains(unusable), isFalse);
    });

    test('should expose the welcome surface and glass colours', () {
      expect(colors.surfaceMagentaPanel, const Color(0xFF8A2F86));
      expect(colors.keyArtWash, const Color.fromRGBO(30, 20, 64, 0.5));
      expect(colors.coverWash, const Color.fromRGBO(10, 13, 58, 0.42));
      expect(colors.ambientNeutral, const Color.fromRGBO(255, 255, 255, 0.09));
      expect(colors.ambientAccent, const Color.fromRGBO(236, 72, 189, 0.2));
      expect(colors.glass30, const Color.fromRGBO(0, 0, 0, 0.3));
      expect(colors.glass32, const Color.fromRGBO(0, 0, 0, 0.32));
      expect(colors.glass34, const Color.fromRGBO(0, 0, 0, 0.34));
      expect(colors.glass42, const Color.fromRGBO(0, 0, 0, 0.42));
      expect(colors.countdownColon, const Color.fromRGBO(255, 255, 255, 0.4));
    });
  });

  group('AppColorTokens — accents', () {
    test('should expose the three QuestLoggd accents when reading the dark '
        'set', () {
      expect(colors.accentIndigo, const Color(0xFF5865F2));
      expect(colors.accentMagenta, const Color(0xFFEC48BD));
      expect(colors.accentLinkCyan, const Color(0xFF00B0F4));
    });

    test('should pair a single green with the black label ink when reading '
        'the dark set', () {
      expect(colors.green, const Color(0xFF35ED7E));
      expect(colors.inkDark, const Color(0xFF000000));
    });

    test('should keep violet out of the surface and accent tokens when '
        'scanning them', () {
      expect(colors.statusViolet, const Color(0xFF7D4EE0));

      final surfacesAndAccents = <Color>[
        colors.canvas,
        colors.surfaceRaised,
        colors.surfaceIndigoPanel,
        colors.surfaceTabChrome,
        colors.accentIndigo,
        colors.accentMagenta,
        colors.accentLinkCyan,
      ];
      expect(surfacesAndAccents.contains(colors.statusViolet), isFalse);
    });
  });

  group('AppColorTokens — ink ramp', () {
    test('should expose six pure-white steps when reading the ramp', () {
      final ramp = <Color>[
        colors.ink,
        colors.ink70,
        colors.ink55,
        colors.ink24,
        colors.ink12,
        colors.ink08,
      ];

      for (final step in ramp) {
        expect(step.r, 1.0);
        expect(step.g, 1.0);
        expect(step.b, 1.0);
      }
    });

    test('should expose six distinct opacities when reading the ramp', () {
      expect(colors.ink.a, closeTo(1, 0.0001));
      expect(colors.ink70.a, closeTo(0.7, 0.0001));
      expect(colors.ink55.a, closeTo(0.55, 0.0001));
      expect(colors.ink24.a, closeTo(0.24, 0.0001));
      expect(colors.ink12.a, closeTo(0.12, 0.0001));
      expect(colors.ink08.a, closeTo(0.08, 0.0001));

      final opacities = <double>{
        colors.ink.a,
        colors.ink70.a,
        colors.ink55.a,
        colors.ink24.a,
        colors.ink12.a,
        colors.ink08.a,
      };
      expect(opacities.length, 6);
    });

    test('should resolve hairline to the 12% ink step when reading it', () {
      expect(colors.hairline, colors.ink12);
    });
  });

  group('AppColorTokens — error ramp', () {
    test('should expose five error tokens when reading the ramp', () {
      expect(colors.error, const Color(0xFFF8443C));
      expect(colors.errorStrong, const Color(0xFFD92D20));
      expect(colors.errorInk, const Color(0xFFFF8F88));
      expect(colors.errorTint, const Color.fromRGBO(248, 68, 60, 0.14));
      expect(colors.errorLine, const Color.fromRGBO(248, 68, 60, 0.55));
    });

    test('should keep tint and line below full opacity when reading them', () {
      expect(colors.errorTint.a, lessThan(1.0));
      expect(colors.errorLine.a, lessThan(1.0));
    });
  });

  group('AppStatusTokens', () {
    test(
      'should expose exactly the six schema statuses when reading the set',
      () {
        final statuses = <AppStatusToken>[
          colors.status.playing,
          colors.status.backlog,
          colors.status.completed,
          colors.status.onHold,
          colors.status.wishlist,
          colors.status.dropped,
        ];

        expect(statuses.length, 6);
      },
    );

    test(
      'should carry the specified hue for each status when reading them',
      () {
        expect(colors.status.playing.color, const Color(0xFF5865F2));
        expect(colors.status.backlog.color, colors.ink55);
        expect(colors.status.completed.color, const Color(0xFFEC48BD));
        expect(colors.status.onHold.color, const Color(0xFF7D4EE0));
        expect(colors.status.wishlist.color, const Color(0xFF00B0F4));
        expect(
          colors.status.dropped.color,
          const Color.fromRGBO(255, 255, 255, 0.28),
        );
      },
    );

    test('should mark playing alone as filled when reading the treatments', () {
      expect(colors.status.playing.treatment, StatusTreatment.filled);

      final tinted = <AppStatusToken>[
        colors.status.backlog,
        colors.status.completed,
        colors.status.onHold,
        colors.status.wishlist,
        colors.status.dropped,
      ];
      for (final status in tinted) {
        expect(status.treatment, StatusTreatment.tinted);
        expect(status.fill, colors.ink08);
      }
    });

    test('should fill playing with its own hue when reading it', () {
      expect(colors.status.playing.fill, colors.accentIndigo);
    });
  });

  group('AppTypeTokens', () {
    test('should use Space Grotesk w700 for the display steps when reading '
        'them', () {
      for (final token in <AppTextToken>[
        type.screenTitle,
        type.cardHeading,
        type.zoneLabel,
      ]) {
        expect(token.style.fontFamily, contains('SpaceGrotesk'));
        expect(token.style.fontWeight, FontWeight.w700);
      }

      expect(type.screenTitle.style.fontSize, 34);
      expect(type.cardHeading.style.fontSize, 22);
    });

    test('should use Inter at w400 or w500 for the UI steps when reading '
        'them', () {
      for (final token in <AppTextToken>[
        type.body,
        type.meta,
        type.zoneLink,
        type.pill,
        type.tabLabel,
      ]) {
        expect(token.style.fontFamily, contains('Inter'));
        expect(token.style.fontWeight, anyOf(FontWeight.w400, FontWeight.w500));
      }
    });

    test('should expose the five primary steps when reading their metrics', () {
      expect(type.screenTitle.style.fontSize, 34);
      expect(type.cardHeading.style.fontSize, 22);

      expect(type.zoneLabel.style.fontSize, 12);
      expect(type.zoneLabel.style.letterSpacing, closeTo(2.16, 0.0001));
      expect(type.zoneLabel.style.color, colors.ink55);

      expect(type.body.style.fontSize, 16);
      expect(type.body.style.fontWeight, FontWeight.w400);
      expect(type.body.style.height, 1.45);

      expect(type.meta.style.fontSize, 14);
      expect(type.meta.style.fontWeight, FontWeight.w500);
      expect(type.meta.style.color, colors.ink70);
    });

    test(
      'should expose the three smaller steps when reading their metrics',
      () {
        expect(type.zoneLink.style.fontSize, 13);
        expect(type.zoneLink.style.fontWeight, FontWeight.w500);
        expect(type.zoneLink.style.color, colors.accentLinkCyan);

        expect(type.pill.style.fontSize, 11);
        expect(type.pill.style.fontWeight, FontWeight.w500);
        expect(type.pill.style.letterSpacing, closeTo(0.88, 0.0001));

        expect(type.tabLabel.style.fontSize, 10);
        expect(type.tabLabel.style.fontWeight, FontWeight.w500);
      },
    );

    test('should expose the welcome styles when reading their metrics', () {
      expect(type.welcomeHeadline.style.fontSize, 34);
      expect(type.welcomeHeadline.style.fontWeight, FontWeight.w700);
      expect(type.welcomeHeadline.style.height, 1.02);
      expect(type.welcomeHeadline.style.letterSpacing, -0.34);
      expect(type.welcomeHeadline.uppercase, isTrue);

      expect(type.countdownFigure.style.fontSize, 30);
      expect(type.countdownFigure.style.fontWeight, FontWeight.w700);
      expect(type.panelTitle.style.fontSize, 26);
      expect(type.panelTitle.style.fontWeight, FontWeight.w700);
      expect(type.countdownColon.style.fontSize, 22);
      expect(type.countdownColon.style.fontWeight, FontWeight.w400);
      expect(type.countdownColon.style.color, colors.countdownColon);
      expect(type.statFigure.style.fontSize, 18);
      expect(type.statFigure.style.fontWeight, FontWeight.w700);
      expect(type.statFigure.style.height, 1.1);
      expect(type.caption.style.fontSize, 13);
      expect(type.caption.style.fontWeight, FontWeight.w400);
      expect(type.caption.style.color, colors.ink55);
      expect(type.microLabel.style.fontSize, 10);
      expect(type.microLabel.style.fontWeight, FontWeight.w500);
      expect(type.microLabel.style.letterSpacing, 1);
      expect(type.microLabel.uppercase, isTrue);
    });

    test('should carry uppercase intent on zone label and pill only when '
        'reading the scale', () {
      expect(type.zoneLabel.uppercase, isTrue);
      expect(type.pill.uppercase, isTrue);

      expect(type.screenTitle.uppercase, isFalse);
      expect(type.cardHeading.uppercase, isFalse);
      expect(type.body.uppercase, isFalse);
      expect(type.meta.uppercase, isFalse);
      expect(type.zoneLink.uppercase, isFalse);
      expect(type.tabLabel.uppercase, isFalse);
    });

    test('should upper-case through format when the token is uppercase', () {
      expect(type.zoneLabel.format('now playing'), 'NOW PLAYING');
      expect(type.pill.format('rpg'), 'RPG');
    });

    test('should leave the value untouched through format when the token is '
        'not uppercase', () {
      expect(type.body.format('Now playing'), 'Now playing');
    });
  });

  group('AppRadiusTokens', () {
    test('should expose the six scale steps when reading the scale', () {
      expect(radius.xs, 6);
      expect(radius.mini, 5);
      expect(radius.sm, 12);
      expect(radius.lg, 16);
      expect(radius.xl, 40);
      expect(radius.pill, 50);
      expect(radius.full, 9999);
    });

    test('should not add the pending one-off radii when reading the scale', () {
      final scale = <double>[
        radius.xs,
        radius.mini,
        radius.sm,
        radius.lg,
        radius.xl,
        radius.pill,
        radius.full,
      ];

      for (final pending in <double>[20, 38, 44]) {
        expect(scale.contains(pending), isFalse);
      }
    });

    test('should expose a directional hero shape when reading it', () {
      expect(radius.heroShape.topLeft, Radius.zero);
      expect(radius.heroShape.topRight, Radius.zero);
      expect(radius.heroShape.bottomLeft, const Radius.circular(88));
      expect(radius.heroShape.bottomRight, const Radius.circular(88));
    });
  });

  group('AppMotionTokens', () {
    test('should expose the four durations when reading them', () {
      expect(motion.stateChange, const Duration(milliseconds: 140));
      expect(motion.expandCollapse, const Duration(milliseconds: 220));
      expect(motion.shimmer, const Duration(milliseconds: 1400));
      expect(motion.screenTransition, const Duration(milliseconds: 420));
    });

    test('should expose the standard easing when reading the curves', () {
      final standard = motion.standard;
      expect(standard, isA<Cubic>());
      expect((standard as Cubic).a, 0.2);
      expect(standard.b, 0.7);
      expect(standard.c, 0.2);
      expect(standard.d, 1);
    });

    test('should keep the shimmer curve linear when reading the curves', () {
      expect(motion.shimmerCurve, same(Curves.linear));
    });

    test(
      'should expose the screen-transition easing when reading the curves',
      () {
        final transition = motion.screenTransitionCurve;
        expect(transition, isA<Cubic>());
        expect((transition as Cubic).a, 0.16);
        expect(transition.b, 1);
        expect(transition.c, 0.3);
        expect(transition.d, 1);
      },
    );
  });

  group('AppEffectTokens', () {
    test('should expose the float shadow and glass blur when reading them', () {
      expect(effect.float.color, const Color.fromRGBO(69, 42, 124, 0.1));
      expect(effect.float.offset, const Offset(0, 3));
      expect(effect.float.blurRadius, 68);
      expect(effect.glassBlur, 9);
    });
  });

  group('AppTokens — copyWith and lerp', () {
    test('should return an equal-valued instance when copyWith takes no '
        'arguments', () {
      final copy = AppTokens.dark.copyWith();

      expect(copy, isA<AppTokens>());
      expect(copy.color, same(AppTokens.dark.color));
      expect(copy.typography, same(AppTokens.dark.typography));
      expect(copy.radius, same(AppTokens.dark.radius));
      expect(copy.motion, same(AppTokens.dark.motion));
      expect(copy.effect, same(AppTokens.dark.effect));
    });

    test('should replace only the named group when copyWith takes one '
        'argument', () {
      final swapped = AppColorTokens.dark.copyWith(
        canvas: const Color(0xFF000000),
      );
      final copy = AppTokens.dark.copyWith(color: swapped);

      expect(copy.color.canvas, const Color(0xFF000000));
      expect(copy.color.accentIndigo, AppTokens.dark.color.accentIndigo);
      expect(copy.typography, same(AppTokens.dark.typography));
    });

    test('should return a fully populated AppTokens when lerping between '
        'two instances', () {
      final other = AppTokens.dark.copyWith(
        color: AppColorTokens.dark.copyWith(canvas: const Color(0xFF000000)),
        radius: AppRadiusTokens.dark.copyWith(xs: 10),
        motion: AppMotionTokens.dark.copyWith(
          stateChange: const Duration(milliseconds: 240),
        ),
        effect: AppEffectTokens.dark.copyWith(glassBlur: 12),
      );

      final lerped = AppTokens.dark.lerp(other, 0.5);

      expect(lerped, isA<AppTokens>());
      expect(lerped.color, isNotNull);
      expect(lerped.typography, isNotNull);
      expect(lerped.radius, isNotNull);
      expect(lerped.motion, isNotNull);
      expect(lerped.effect, isNotNull);

      for (final color in _allColors(lerped.color)) {
        expect(color, isNotNull);
      }
      expect(lerped.color.status.playing.treatment, isNotNull);

      expect(lerped.typography.screenTitle.style, isNotNull);
      expect(lerped.typography.tabLabel.style, isNotNull);

      expect(lerped.radius.xs, 8);
      expect(lerped.radius.heroShape, isNotNull);

      expect(lerped.motion.stateChange, const Duration(milliseconds: 190));
      expect(lerped.motion.standard, isNotNull);
      expect(lerped.motion.screenTransitionCurve, isNotNull);
      expect(lerped.effect.float, isNotNull);
      expect(lerped.effect.glassBlur, 10.5);
    });

    test('should return itself when lerping against a foreign extension', () {
      final result = AppTokens.dark.lerp(null, 0.5);

      expect(result, same(AppTokens.dark));
    });
  });
}

Future<AppTokens> _resolveTokens() async {
  final future = runZonedGuarded<Future<AppTokens>>(() async {
    return AppTokens.dark;
  }, (error, stack) {});
  return await future!;
}

List<Color> _allColors(AppColorTokens colors) {
  return <Color>[
    colors.canvas,
    colors.surfaceRaised,
    colors.surfaceIndigoPanel,
    colors.surfaceMagentaPanel,
    colors.surfaceTabChrome,
    colors.surfaceToast,
    colors.accentIndigo,
    colors.accentMagenta,
    colors.accentLinkCyan,
    colors.green,
    colors.inkDark,
    colors.statusViolet,
    colors.ink,
    colors.ink70,
    colors.ink55,
    colors.ink24,
    colors.ink12,
    colors.ink08,
    colors.keyArtWash,
    colors.coverWash,
    colors.ambientNeutral,
    colors.ambientAccent,
    colors.glass30,
    colors.glass32,
    colors.glass34,
    colors.countdownColon,
    colors.hairline,
    colors.error,
    colors.errorStrong,
    colors.errorInk,
    colors.errorLine,
    colors.errorTint,
    colors.status.playing.color,
    colors.status.playing.fill,
    colors.status.backlog.color,
    colors.status.backlog.fill,
    colors.status.completed.color,
    colors.status.completed.fill,
    colors.status.onHold.color,
    colors.status.onHold.fill,
    colors.status.wishlist.color,
    colors.status.wishlist.fill,
    colors.status.dropped.color,
    colors.status.dropped.fill,
  ];
}

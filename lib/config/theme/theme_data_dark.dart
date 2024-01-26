import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/color.dart';
import 'package:google_fonts/google_fonts.dart';

final kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: ColorPalette.lightPrimaryBlue,
);

ThemeData buildDarkTheme() {
  //** Base theme*/
  final baseTheme = ThemeData().copyWith(
    colorScheme: kDarkColorScheme,
  );

  final filledButtonTheme = FilledButtonThemeData(
    style: const ButtonStyle().copyWith(
      backgroundColor: MaterialStateProperty.all<Color>(
        kDarkColorScheme.primary,
      ),
      foregroundColor: MaterialStateProperty.all<Color>(
        kDarkColorScheme.background,
      ),
    ),
  );

  final textTheme = GoogleFonts.openSansTextTheme(baseTheme.textTheme).copyWith(
    titleLarge: GoogleFonts.chakraPetch(
      fontWeight: FontWeight.w600,
      color: kDarkColorScheme.background,
      textStyle: baseTheme.textTheme.titleLarge,
    ),
  );

  return baseTheme.copyWith(
    filledButtonTheme: filledButtonTheme,
    textTheme: textTheme,
  );
}

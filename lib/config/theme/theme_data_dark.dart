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
    bodyLarge: GoogleFonts.openSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      textStyle: baseTheme.textTheme.bodyLarge,
    ),
    displaySmall: GoogleFonts.openSans(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      textStyle: baseTheme.textTheme.displaySmall,
    ),
    displayMedium: GoogleFonts.chakraPetch(
      fontSize: 20,
      fontWeight: FontWeight.w800,
      textStyle: baseTheme.textTheme.displayMedium,
    ),
  );

  final navigationBarTheme = NavigationBarThemeData(
    labelTextStyle: MaterialStateProperty.all(
      const TextStyle(fontSize: 14),
    ),
    backgroundColor: kDarkColorScheme.primaryContainer,
    indicatorColor: kDarkColorScheme.onBackground,
  );

  return baseTheme.copyWith(
    filledButtonTheme: filledButtonTheme,
    textTheme: textTheme,
    navigationBarTheme: navigationBarTheme,
  );
}

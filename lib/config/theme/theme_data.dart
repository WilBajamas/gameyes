import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/color.dart';
import 'package:google_fonts/google_fonts.dart';

final kColorScheme = ColorScheme.fromSeed(seedColor: ColorPalette.primaryBlue);

ThemeData buildTheme() {
  //** Base theme*/
  final baseTheme = ThemeData().copyWith(
    colorScheme: kColorScheme,
  );

  final textTheme = GoogleFonts.openSansTextTheme(baseTheme.textTheme).copyWith(
    titleLarge: GoogleFonts.chakraPetch(
      fontWeight: FontWeight.w600,
      textStyle: baseTheme.textTheme.titleLarge,
    ),
    bodyLarge: GoogleFonts.openSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      textStyle: baseTheme.textTheme.bodyLarge,
    ),
  );

  final filledButtonTheme = FilledButtonThemeData(
    style: const ButtonStyle().copyWith(
      backgroundColor: MaterialStateProperty.all<Color>(
        kColorScheme.primary,
      ),
      foregroundColor: MaterialStateProperty.all<Color>(
        kColorScheme.background,
      ),
      textStyle: MaterialStateProperty.all<TextStyle?>(textTheme.bodyLarge),
    ),
  );

  return baseTheme.copyWith(
    filledButtonTheme: filledButtonTheme,
    textTheme: textTheme,
  );
}

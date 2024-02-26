import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/color.dart';
import 'package:google_fonts/google_fonts.dart';

final kColorScheme = ColorScheme.fromSeed(
  seedColor: ColorPalette.primaryBlue,
  primary: ColorPalette.primaryBlue,
);

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
    titleMedium: GoogleFonts.chakraPetch(
      fontSize: 18,
      fontWeight: FontWeight.w800,
      textStyle: baseTheme.textTheme.titleMedium,
    ),
    titleSmall: GoogleFonts.chakraPetch(
      fontSize: 14,
      fontWeight: FontWeight.w800,
      textStyle: baseTheme.textTheme.titleSmall,
    ),
    bodySmall: GoogleFonts.openSans(
      fontSize: 14,
      textStyle: baseTheme.textTheme.bodySmall,
    ),
    bodyMedium: GoogleFonts.openSans(
      fontSize: 16,
      fontWeight: FontWeight.w800,
      textStyle: baseTheme.textTheme.bodyMedium,
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
    displayLarge: GoogleFonts.chakraPetch(
      fontSize: 22,
      fontWeight: FontWeight.w800,
      textStyle: baseTheme.textTheme.displayLarge,
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

  final elevatedButtonTheme = ElevatedButtonThemeData(
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

  final navigationBarTheme = NavigationBarThemeData(
    labelTextStyle: MaterialStateProperty.all(
      TextStyle(color: kColorScheme.primary, fontSize: 14),
    ),
    backgroundColor: Colors.white,
    indicatorColor: kColorScheme.primary,
    surfaceTintColor: Colors.white,
  );

  const iconTheme = IconThemeData(
    color: Colors.white,
  );

  final iconButtonTheme = IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(
        Colors.white,
      ),
    ),
  );

  final chipTheme = ChipThemeData(
    checkmarkColor: Colors.white,
    selectedColor: kColorScheme.primary,
    backgroundColor: kColorScheme.background,
    labelStyle: TextStyle(color: kColorScheme.background),
    shape: StadiumBorder(
      side: const BorderSide().copyWith(color: kColorScheme.primary),
    ),
  );

  final inputDecorationTheme = InputDecorationTheme(
    labelStyle: const TextStyle(color: Colors.grey),
    suffixIconColor: Colors.grey,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12), // Set desired radius
    ),
  );

  final appBarTheme = const AppBarTheme().copyWith(
    backgroundColor: kColorScheme.primary,
    foregroundColor: kColorScheme.primaryContainer,
  );

  return baseTheme.copyWith(
    filledButtonTheme: filledButtonTheme,
    textTheme: textTheme,
    navigationBarTheme: navigationBarTheme,
    elevatedButtonTheme: elevatedButtonTheme,
    iconTheme: iconTheme,
    iconButtonTheme: iconButtonTheme,
    chipTheme: chipTheme,
    inputDecorationTheme: inputDecorationTheme,
    appBarTheme: appBarTheme,
    scaffoldBackgroundColor: Colors.grey[150],
  );
}

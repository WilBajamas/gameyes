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
      color: kDarkColorScheme.onBackground,
      textStyle: baseTheme.textTheme.titleLarge,
    ),
    titleMedium: GoogleFonts.chakraPetch(
      fontSize: 18,
      fontWeight: FontWeight.w800,
      color: kDarkColorScheme.onBackground,
      textStyle: baseTheme.textTheme.titleLarge,
    ),
    labelSmall: GoogleFonts.openSans(
      fontSize: 12,
      textStyle: baseTheme.textTheme.labelSmall,
    ),
    bodySmall: GoogleFonts.openSans(
      fontSize: 14,
      color: kDarkColorScheme.onBackground,
      textStyle: baseTheme.textTheme.bodySmall,
    ),
    bodyMedium: GoogleFonts.openSans(
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: kDarkColorScheme.onBackground,
      textStyle: baseTheme.textTheme.bodyMedium,
    ),
    bodyLarge: GoogleFonts.openSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: kDarkColorScheme.onBackground,
      textStyle: baseTheme.textTheme.bodyLarge,
    ),
    displaySmall: GoogleFonts.openSans(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: kDarkColorScheme.onBackground,
      textStyle: baseTheme.textTheme.displaySmall,
    ),
    displayMedium: GoogleFonts.chakraPetch(
      fontSize: 20,
      fontWeight: FontWeight.w800,
      color: kDarkColorScheme.onBackground,
      textStyle: baseTheme.textTheme.displayMedium,
    ),
    displayLarge: GoogleFonts.chakraPetch(
      fontSize: 22,
      fontWeight: FontWeight.w800,
      color: kDarkColorScheme.onBackground,
      textStyle: baseTheme.textTheme.displayLarge,
    ),
  );

  final navigationBarTheme = NavigationBarThemeData(
    labelTextStyle: MaterialStateProperty.all(
      TextStyle(fontSize: 14, color: kDarkColorScheme.onBackground),
    ),
    backgroundColor: kDarkColorScheme.primaryContainer,
    indicatorColor: kDarkColorScheme.onBackground,
  );

  final elevatedButtonTheme = ElevatedButtonThemeData(
    style: const ButtonStyle().copyWith(
      backgroundColor: MaterialStateProperty.all<Color>(
        kDarkColorScheme.primary,
      ),
      foregroundColor: MaterialStateProperty.all<Color>(
        kDarkColorScheme.background,
      ),
      textStyle: MaterialStateProperty.all<TextStyle?>(textTheme.bodyLarge),
    ),
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
    checkmarkColor: kDarkColorScheme.background,
    selectedColor: kDarkColorScheme.primary,
    backgroundColor: kDarkColorScheme.background,
    labelStyle: TextStyle(color: kDarkColorScheme.background),
    shape: StadiumBorder(
      side: const BorderSide().copyWith(color: kDarkColorScheme.primary),
    ),
  );

  final inputDecorationTheme = InputDecorationTheme(
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
    labelStyle: const TextStyle(color: Colors.grey),
    suffixIconColor: Colors.grey,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  final appBarTheme = const AppBarTheme().copyWith(
    backgroundColor: kDarkColorScheme.primaryContainer,
    foregroundColor: kDarkColorScheme.onPrimaryContainer,
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
    scaffoldBackgroundColor: kDarkColorScheme.background,
    appBarTheme: appBarTheme,
  );
}

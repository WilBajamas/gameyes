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
      backgroundColor: WidgetStateProperty.all<Color>(
        kDarkColorScheme.primary,
      ),
      foregroundColor: WidgetStateProperty.all<Color>(
        kDarkColorScheme.surface,
      ),
    ),
  );

  final textTheme = GoogleFonts.openSansTextTheme(baseTheme.textTheme).copyWith(
    titleLarge: GoogleFonts.chakraPetch(
      fontWeight: FontWeight.w600,
      color: kDarkColorScheme.onSurface,
      textStyle: baseTheme.textTheme.titleLarge,
    ),
    titleMedium: GoogleFonts.chakraPetch(
      fontSize: 18,
      fontWeight: FontWeight.w800,
      color: kDarkColorScheme.onSurface,
      textStyle: baseTheme.textTheme.titleLarge,
    ),
    headlineMedium: GoogleFonts.openSans(
      fontSize: 20,
      textStyle: baseTheme.textTheme.headlineMedium,
    ),
    labelSmall: GoogleFonts.openSans(
      fontSize: 12,
      textStyle: baseTheme.textTheme.labelSmall,
    ),
    bodySmall: GoogleFonts.openSans(
      fontSize: 14,
      color: kDarkColorScheme.onSurface,
      textStyle: baseTheme.textTheme.bodySmall,
    ),
    bodyMedium: GoogleFonts.openSans(
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: kDarkColorScheme.onSurface,
      textStyle: baseTheme.textTheme.bodyMedium,
    ),
    bodyLarge: GoogleFonts.openSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: kDarkColorScheme.onSurface,
      textStyle: baseTheme.textTheme.bodyLarge,
    ),
    displaySmall: GoogleFonts.openSans(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: kDarkColorScheme.onSurface,
      textStyle: baseTheme.textTheme.displaySmall,
    ),
    displayMedium: GoogleFonts.chakraPetch(
      fontSize: 20,
      fontWeight: FontWeight.w800,
      color: kDarkColorScheme.onSurface,
      textStyle: baseTheme.textTheme.displayMedium,
    ),
    displayLarge: GoogleFonts.chakraPetch(
      fontSize: 22,
      fontWeight: FontWeight.w800,
      color: kDarkColorScheme.onSurface,
      textStyle: baseTheme.textTheme.displayLarge,
    ),
  );

  final navigationBarTheme = NavigationBarThemeData(
    labelTextStyle: WidgetStateProperty.all(
      TextStyle(fontSize: 14, color: kDarkColorScheme.onSurface),
    ),
    backgroundColor: kDarkColorScheme.primaryContainer,
    indicatorColor: kDarkColorScheme.onSurface,
  );

  final elevatedButtonTheme = ElevatedButtonThemeData(
    style: const ButtonStyle().copyWith(
      backgroundColor: WidgetStateProperty.all<Color>(
        kDarkColorScheme.primary,
      ),
      foregroundColor: WidgetStateProperty.all<Color>(
        kDarkColorScheme.surface,
      ),
      textStyle: WidgetStateProperty.all<TextStyle?>(textTheme.bodyLarge),
    ),
  );

  const iconTheme = IconThemeData(
    color: Colors.white,
  );

  final iconButtonTheme = IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all<Color>(
        Colors.white,
      ),
    ),
  );

  final chipTheme = ChipThemeData(
    checkmarkColor: kDarkColorScheme.surface,
    selectedColor: kDarkColorScheme.primary,
    backgroundColor: kDarkColorScheme.surface,
    labelStyle: TextStyle(color: kDarkColorScheme.surface),
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
    scaffoldBackgroundColor: kDarkColorScheme.surface,
    appBarTheme: appBarTheme,
  );
}

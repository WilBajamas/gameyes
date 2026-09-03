import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_tokens.dart';
import 'package:google_fonts/google_fonts.dart';

final _tokens = AppTokens.dark;
final _colors = _tokens.color;
final _type = _tokens.typography;
final _radius = _tokens.radius;

final kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: _colors.accentIndigo,
  primary: _colors.accentIndigo,
  onPrimary: _colors.ink,
  secondary: _colors.accentMagenta,
  tertiary: _colors.accentLinkCyan,
  surface: _colors.canvas,
  onSurface: _colors.ink,
  surfaceContainer: _colors.surfaceRaised,
  surfaceContainerHighest: _colors.surfaceRaised,
  outline: _colors.hairline,
  error: _colors.error,
  onError: _colors.ink,
);

ThemeData buildDarkTheme() {
  //** Base theme*/
  final baseTheme = ThemeData().copyWith(colorScheme: kDarkColorScheme);

  final filledButtonTheme = FilledButtonThemeData(
    style: const ButtonStyle().copyWith(
      backgroundColor: WidgetStateProperty.all<Color>(_colors.accentIndigo),
      foregroundColor: WidgetStateProperty.all<Color>(_colors.ink),
    ),
  );

  final textTheme = GoogleFonts.interTextTheme(baseTheme.textTheme).copyWith(
    displayLarge: _type.screenTitle.style,
    headlineMedium: _type.cardHeading.style,
    titleLarge: _type.cardHeading.style,
    labelLarge: _type.zoneLabel.style,
    bodyLarge: _type.body.style,
    bodyMedium: _type.meta.style,
    bodySmall: _type.zoneLink.style,
    labelMedium: _type.pill.style,
    labelSmall: _type.tabLabel.style,
  );

  final navigationBarTheme = NavigationBarThemeData(
    labelTextStyle: WidgetStateProperty.all(textTheme.labelSmall),
    backgroundColor: _colors.surfaceTabChrome,
    indicatorColor: _colors.accentIndigo,
  );

  final elevatedButtonTheme = ElevatedButtonThemeData(
    style: const ButtonStyle().copyWith(
      backgroundColor: WidgetStateProperty.all<Color>(_colors.accentIndigo),
      foregroundColor: WidgetStateProperty.all<Color>(_colors.ink),
      textStyle: WidgetStateProperty.all<TextStyle?>(textTheme.bodyLarge),
    ),
  );

  final iconTheme = IconThemeData(color: _colors.ink);

  final iconButtonTheme = IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all<Color>(_colors.ink),
    ),
  );

  final chipTheme = ChipThemeData(
    checkmarkColor: _colors.ink,
    selectedColor: _colors.accentIndigo,
    backgroundColor: _colors.surfaceRaised,
    labelStyle: textTheme.labelMedium,
    shape: StadiumBorder(
      side: const BorderSide().copyWith(color: _colors.hairline),
    ),
  );

  final inputDecorationTheme = InputDecorationTheme(
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: _colors.error),
    ),
    labelStyle: textTheme.bodyMedium,
    suffixIconColor: _colors.ink55,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(_radius.sm)),
  );

  final appBarTheme = const AppBarTheme().copyWith(
    backgroundColor: _colors.canvas,
    foregroundColor: _colors.ink,
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
    scaffoldBackgroundColor: _colors.canvas,
    appBarTheme: appBarTheme,
    extensions: <ThemeExtension<dynamic>>[_tokens],
  );
}

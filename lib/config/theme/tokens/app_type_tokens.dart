import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_color_tokens.dart';
import 'package:google_fonts/google_fonts.dart';

// A text style bundled with whether it should show in capital letters. Text
// styles alone can't capitalize text, so this carries that instruction along
// with it.
@immutable
class AppTextToken {
  const AppTextToken({
    required this.style,
    required this.uppercase,
  });

  final TextStyle style;
  final bool uppercase;

  // Capitalizes the text if this style calls for it.
  String format(String value) => uppercase ? value.toUpperCase() : value;

  AppTextToken copyWith({
    TextStyle? style,
    bool? uppercase,
  }) {
    return AppTextToken(
      style: style ?? this.style,
      uppercase: uppercase ?? this.uppercase,
    );
  }

  static AppTextToken lerp(AppTextToken a, AppTextToken b, double t) {
    return AppTextToken(
      style: TextStyle.lerp(a.style, b.style, t)!,
      uppercase: t < 0.5 ? a.uppercase : b.uppercase,
    );
  }
}

// The eight text styles used across the app. Headings use Space Grotesk
// (bold), body and UI text use Inter (regular or medium weight).
@immutable
class AppTypeTokens {
  const AppTypeTokens({
    required this.screenTitle,
    required this.cardHeading,
    required this.zoneLabel,
    required this.body,
    required this.meta,
    required this.zoneLink,
    required this.pill,
    required this.tabLabel,
  });

  final AppTextToken screenTitle;
  final AppTextToken cardHeading;
  final AppTextToken zoneLabel;
  final AppTextToken body;
  final AppTextToken meta;
  final AppTextToken zoneLink;
  final AppTextToken pill;
  final AppTextToken tabLabel;

  // Not "const" because building these calls a function, not just plain
  // values.
  static final AppTypeTokens dark = AppTypeTokens(
    screenTitle: AppTextToken(
      style: GoogleFonts.spaceGrotesk(
        fontSize: 34,
        fontWeight: FontWeight.w700,
      ),
      uppercase: false,
    ),
    cardHeading: AppTextToken(
      style: GoogleFonts.spaceGrotesk(
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
      uppercase: false,
    ),
    zoneLabel: AppTextToken(
      style: GoogleFonts.spaceGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        // 12 x 0.18em
        letterSpacing: 2.16,
        color: AppColorTokens.dark.ink55,
      ),
      uppercase: true,
    ),
    body: AppTextToken(
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      uppercase: false,
    ),
    meta: AppTextToken(
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColorTokens.dark.ink70,
      ),
      uppercase: false,
    ),
    zoneLink: AppTextToken(
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColorTokens.dark.accentLinkCyan,
      ),
      uppercase: false,
    ),
    pill: AppTextToken(
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        // 11 x 0.08em
        letterSpacing: 0.88,
      ),
      uppercase: true,
    ),
    tabLabel: AppTextToken(
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
      uppercase: false,
    ),
  );

  AppTypeTokens copyWith({
    AppTextToken? screenTitle,
    AppTextToken? cardHeading,
    AppTextToken? zoneLabel,
    AppTextToken? body,
    AppTextToken? meta,
    AppTextToken? zoneLink,
    AppTextToken? pill,
    AppTextToken? tabLabel,
  }) {
    return AppTypeTokens(
      screenTitle: screenTitle ?? this.screenTitle,
      cardHeading: cardHeading ?? this.cardHeading,
      zoneLabel: zoneLabel ?? this.zoneLabel,
      body: body ?? this.body,
      meta: meta ?? this.meta,
      zoneLink: zoneLink ?? this.zoneLink,
      pill: pill ?? this.pill,
      tabLabel: tabLabel ?? this.tabLabel,
    );
  }

  static AppTypeTokens lerp(AppTypeTokens a, AppTypeTokens b, double t) {
    return AppTypeTokens(
      screenTitle: AppTextToken.lerp(a.screenTitle, b.screenTitle, t),
      cardHeading: AppTextToken.lerp(a.cardHeading, b.cardHeading, t),
      zoneLabel: AppTextToken.lerp(a.zoneLabel, b.zoneLabel, t),
      body: AppTextToken.lerp(a.body, b.body, t),
      meta: AppTextToken.lerp(a.meta, b.meta, t),
      zoneLink: AppTextToken.lerp(a.zoneLink, b.zoneLink, t),
      pill: AppTextToken.lerp(a.pill, b.pill, t),
      tabLabel: AppTextToken.lerp(a.tabLabel, b.tabLabel, t),
    );
  }
}

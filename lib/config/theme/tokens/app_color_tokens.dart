import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_status_tokens.dart';

const Color _ink = Color.fromRGBO(255, 255, 255, 1);
const Color _ink70 = Color.fromRGBO(255, 255, 255, 0.7);
const Color _ink55 = Color.fromRGBO(255, 255, 255, 0.55);
const Color _ink24 = Color.fromRGBO(255, 255, 255, 0.24);
const Color _ink12 = Color.fromRGBO(255, 255, 255, 0.12);
const Color _ink08 = Color.fromRGBO(255, 255, 255, 0.08);

const Color _statusViolet = Color(0xFF7D4EE0);

const Color _accentIndigo = Color(0xFF5865F2);
const Color _accentMagenta = Color(0xFFEC48BD);
const Color _accentLinkCyan = Color(0xFF00B0F4);

// Every color the app is allowed to use.
@immutable
class AppColorTokens {
  const AppColorTokens({
    required this.canvas,
    required this.surfaceRaised,
    required this.surfaceIndigoPanel,
    required this.surfaceMagentaPanel,
    required this.surfaceTabChrome,
    required this.accentIndigo,
    required this.accentMagenta,
    required this.accentLinkCyan,
    required this.green,
    required this.inkDark,
    required this.statusViolet,
    required this.ink,
    required this.ink70,
    required this.ink55,
    required this.ink24,
    required this.ink12,
    required this.ink08,
    required this.keyArtWash,
    required this.coverWash,
    required this.ambientNeutral,
    required this.ambientAccent,
    required this.glass30,
    required this.glass32,
    required this.glass34,
    required this.countdownColon,
    required this.hairline,
    required this.error,
    required this.errorStrong,
    required this.errorInk,
    required this.errorLine,
    required this.errorTint,
    required this.status,
  });

  // ** Surfaces
  final Color canvas;
  final Color surfaceRaised;
  final Color surfaceIndigoPanel;
  final Color surfaceMagentaPanel;
  final Color surfaceTabChrome;

  // ** Accents
  final Color accentIndigo;
  final Color accentMagenta;
  final Color accentLinkCyan;
  final Color green;
  final Color inkDark;

  final Color statusViolet;

  // ** Ink ramp — pure white at six opacities
  final Color ink;
  final Color ink70;
  final Color ink55;
  final Color ink24;
  final Color ink12;
  final Color ink08;
  final Color keyArtWash;
  final Color coverWash;
  final Color ambientNeutral;
  final Color ambientAccent;
  final Color glass30;
  final Color glass32;
  final Color glass34;
  final Color countdownColon;

  final Color hairline;
  final Color error;

  final Color errorStrong;
  final Color errorInk;

  /// Not yet in the official design system.
  final Color errorLine;

  /// Not yet in the official design system.
  final Color errorTint;

  // ** Status set
  final AppStatusTokens status;

  static const AppColorTokens dark = AppColorTokens(
    canvas: Color(0xFF23272A),
    surfaceRaised: Color(0xFF2F333C),
    surfaceIndigoPanel: Color(0xFF2F3782),
    surfaceMagentaPanel: Color(0xFF8A2F86),
    surfaceTabChrome: Color(0xFF2E3236),
    accentIndigo: _accentIndigo,
    accentMagenta: _accentMagenta,
    accentLinkCyan: _accentLinkCyan,
    green: Color(0xFF35ED7E),
    inkDark: Color(0xFF000000),
    statusViolet: _statusViolet,
    ink: _ink,
    ink70: _ink70,
    ink55: _ink55,
    ink24: _ink24,
    ink12: _ink12,
    ink08: _ink08,
    keyArtWash: Color.fromRGBO(30, 20, 64, 0.5),
    coverWash: Color.fromRGBO(10, 13, 58, 0.42),
    ambientNeutral: Color.fromRGBO(255, 255, 255, 0.09),
    ambientAccent: Color.fromRGBO(236, 72, 189, 0.2),
    glass30: Color.fromRGBO(0, 0, 0, 0.3),
    glass32: Color.fromRGBO(0, 0, 0, 0.32),
    glass34: Color.fromRGBO(0, 0, 0, 0.34),
    countdownColon: Color.fromRGBO(255, 255, 255, 0.4),
    hairline: _ink12,
    error: Color(0xFFF8443C),
    errorStrong: Color(0xFFD92D20),
    errorInk: Color(0xFFFF8F88),
    errorLine: Color.fromRGBO(248, 68, 60, 0.55),
    errorTint: Color.fromRGBO(248, 68, 60, 0.14),
    status: AppStatusTokens(
      playing: AppStatusToken(
        color: _accentIndigo,
        fill: _accentIndigo,
        treatment: StatusTreatment.filled,
      ),
      backlog: AppStatusToken(
        color: _ink55,
        fill: _ink08,
        treatment: StatusTreatment.tinted,
      ),
      completed: AppStatusToken(
        color: _accentMagenta,
        fill: _ink08,
        treatment: StatusTreatment.tinted,
      ),
      onHold: AppStatusToken(
        color: _statusViolet,
        fill: _ink08,
        treatment: StatusTreatment.tinted,
      ),
      wishlist: AppStatusToken(
        color: _accentLinkCyan,
        fill: _ink08,
        treatment: StatusTreatment.tinted,
      ),
      dropped: AppStatusToken(
        color: Color.fromRGBO(255, 255, 255, 0.28),
        fill: _ink08,
        treatment: StatusTreatment.tinted,
      ),
    ),
  );

  AppColorTokens copyWith({
    Color? canvas,
    Color? surfaceRaised,
    Color? surfaceIndigoPanel,
    Color? surfaceMagentaPanel,
    Color? surfaceTabChrome,
    Color? accentIndigo,
    Color? accentMagenta,
    Color? accentLinkCyan,
    Color? green,
    Color? inkDark,
    Color? statusViolet,
    Color? ink,
    Color? ink70,
    Color? ink55,
    Color? ink24,
    Color? ink12,
    Color? ink08,
    Color? keyArtWash,
    Color? coverWash,
    Color? ambientNeutral,
    Color? ambientAccent,
    Color? glass30,
    Color? glass32,
    Color? glass34,
    Color? countdownColon,
    Color? hairline,
    Color? error,
    Color? errorStrong,
    Color? errorInk,
    Color? errorLine,
    Color? errorTint,
    AppStatusTokens? status,
  }) {
    return AppColorTokens(
      canvas: canvas ?? this.canvas,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceIndigoPanel: surfaceIndigoPanel ?? this.surfaceIndigoPanel,
      surfaceMagentaPanel: surfaceMagentaPanel ?? this.surfaceMagentaPanel,
      surfaceTabChrome: surfaceTabChrome ?? this.surfaceTabChrome,
      accentIndigo: accentIndigo ?? this.accentIndigo,
      accentMagenta: accentMagenta ?? this.accentMagenta,
      accentLinkCyan: accentLinkCyan ?? this.accentLinkCyan,
      green: green ?? this.green,
      inkDark: inkDark ?? this.inkDark,
      statusViolet: statusViolet ?? this.statusViolet,
      ink: ink ?? this.ink,
      ink70: ink70 ?? this.ink70,
      ink55: ink55 ?? this.ink55,
      ink24: ink24 ?? this.ink24,
      ink12: ink12 ?? this.ink12,
      ink08: ink08 ?? this.ink08,
      keyArtWash: keyArtWash ?? this.keyArtWash,
      coverWash: coverWash ?? this.coverWash,
      ambientNeutral: ambientNeutral ?? this.ambientNeutral,
      ambientAccent: ambientAccent ?? this.ambientAccent,
      glass30: glass30 ?? this.glass30,
      glass32: glass32 ?? this.glass32,
      glass34: glass34 ?? this.glass34,
      countdownColon: countdownColon ?? this.countdownColon,
      hairline: hairline ?? this.hairline,
      error: error ?? this.error,
      errorStrong: errorStrong ?? this.errorStrong,
      errorInk: errorInk ?? this.errorInk,
      errorLine: errorLine ?? this.errorLine,
      errorTint: errorTint ?? this.errorTint,
      status: status ?? this.status,
    );
  }

  static AppColorTokens lerp(AppColorTokens a, AppColorTokens b, double t) {
    return AppColorTokens(
      canvas: Color.lerp(a.canvas, b.canvas, t)!,
      surfaceRaised: Color.lerp(a.surfaceRaised, b.surfaceRaised, t)!,
      surfaceIndigoPanel: Color.lerp(
        a.surfaceIndigoPanel,
        b.surfaceIndigoPanel,
        t,
      )!,
      surfaceMagentaPanel: Color.lerp(
        a.surfaceMagentaPanel,
        b.surfaceMagentaPanel,
        t,
      )!,
      surfaceTabChrome: Color.lerp(a.surfaceTabChrome, b.surfaceTabChrome, t)!,
      accentIndigo: Color.lerp(a.accentIndigo, b.accentIndigo, t)!,
      accentMagenta: Color.lerp(a.accentMagenta, b.accentMagenta, t)!,
      accentLinkCyan: Color.lerp(a.accentLinkCyan, b.accentLinkCyan, t)!,
      green: Color.lerp(a.green, b.green, t)!,
      inkDark: Color.lerp(a.inkDark, b.inkDark, t)!,
      statusViolet: Color.lerp(a.statusViolet, b.statusViolet, t)!,
      ink: Color.lerp(a.ink, b.ink, t)!,
      ink70: Color.lerp(a.ink70, b.ink70, t)!,
      ink55: Color.lerp(a.ink55, b.ink55, t)!,
      ink24: Color.lerp(a.ink24, b.ink24, t)!,
      ink12: Color.lerp(a.ink12, b.ink12, t)!,
      ink08: Color.lerp(a.ink08, b.ink08, t)!,
      keyArtWash: Color.lerp(a.keyArtWash, b.keyArtWash, t)!,
      coverWash: Color.lerp(a.coverWash, b.coverWash, t)!,
      ambientNeutral: Color.lerp(a.ambientNeutral, b.ambientNeutral, t)!,
      ambientAccent: Color.lerp(a.ambientAccent, b.ambientAccent, t)!,
      glass30: Color.lerp(a.glass30, b.glass30, t)!,
      glass32: Color.lerp(a.glass32, b.glass32, t)!,
      glass34: Color.lerp(a.glass34, b.glass34, t)!,
      countdownColon: Color.lerp(a.countdownColon, b.countdownColon, t)!,
      hairline: Color.lerp(a.hairline, b.hairline, t)!,
      error: Color.lerp(a.error, b.error, t)!,
      errorStrong: Color.lerp(a.errorStrong, b.errorStrong, t)!,
      errorInk: Color.lerp(a.errorInk, b.errorInk, t)!,
      errorLine: Color.lerp(a.errorLine, b.errorLine, t)!,
      errorTint: Color.lerp(a.errorTint, b.errorTint, t)!,
      status: AppStatusTokens.lerp(a.status, b.status, t),
    );
  }
}

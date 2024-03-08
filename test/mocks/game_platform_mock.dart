import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';

GamePlatform get mockGamePlatform => GamePlatform.playstation;

Set<GamePlatform> get mockGamePlatforms =>
    {GamePlatform.playstation, GamePlatform.pc, GamePlatform.android};

String get mockGamePlatformsName =>
// ignore: lines_longer_than_80_chars
    '${GamePlatform.playstation.name}, ${GamePlatform.pc.name}, ${GamePlatform.android.name},';

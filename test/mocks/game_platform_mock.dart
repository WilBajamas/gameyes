import 'package:gaming_library_assessment_flutter/features/filter/data/models/games_platform.dart';

GamePlatform get mockGamePlatform => const Playseason5();

Set<GamePlatform> get mockGamePlatforms =>
    {const Playseason5(), const PcPlatform()};

String get mockGamePlatformsName =>
// ignore: lines_longer_than_80_chars
    '${const Playseason5().name}, ${const PcPlatform().name},';

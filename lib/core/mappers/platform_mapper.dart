import '../enums/game_platform.dart';

extension PlatformIdMapper on int {
  GamePlatform toEntity() {
    return switch (this) {
      187 || 18 || 16 || 15 || 27 || 17 || 19 => GamePlatform.playstation,
      1 || 186 || 14 || 80 => GamePlatform.xbox,
      4 => GamePlatform.pc,
      7 || 8 || 9 || 13 || 83 => GamePlatform.nintendo,
      55 || 3 || 5 => GamePlatform.ios,
      21 => GamePlatform.android,
      6 => GamePlatform.linux,
      10 || 11 => GamePlatform.wii,
      _ => GamePlatform.other,
    };
  }
}

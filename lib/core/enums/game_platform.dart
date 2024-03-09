import 'package:gaming_library_assessment_flutter/core/interface/selection.dart';

enum GamePlatform implements EnumSelection {
  playstation(
    ids: [187, 18, 16, 15, 27, 17, 19],
    name: 'Playstation',
    assetName: 'icon_playstation.png',
  ),
  xbox(
    ids: [1, 186, 14, 80],
    name: 'Xbox',
    assetName: 'icon_xbox.png',
  ),
  android(
    ids: [21],
    name: 'Android',
    assetName: 'icon_android.png',
  ),
  ios(
    ids: [3, 5, 55],
    name: 'Apple',
    assetName: 'icon_apple.png',
  ),
  pc(
    ids: [4],
    name: 'PC',
    assetName: 'icon_windows.png',
  ),
  nintendo(
    ids: [7, 8, 9, 13, 83],
    name: 'Nintendo',
    assetName: 'icon_nintendo.png',
  ),
  wii(
    ids: [10, 11],
    name: 'Wii',
    assetName: 'icon_wii.png',
  ),
  linux(
    ids: [6],
    name: 'Linux',
    assetName: 'icon_linux.png',
  );

  final List<int> ids;
  final String name;
  final String assetName;

  const GamePlatform({
    required this.ids,
    required this.name,
    required this.assetName,
  });

  @override
  String get valueName => name;
}

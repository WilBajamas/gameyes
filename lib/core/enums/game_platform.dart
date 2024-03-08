import 'package:gaming_library_assessment_flutter/core/interface/selection.dart';

enum GamePlatform implements EnumSelection {
  playstation(
    ids: [187, 18, 16, 15, 27, 17, 19],
    testGetName: 'Playstation',
    assetName: 'icon_playstation.png',
  ),
  xbox(
    ids: [1, 186, 14, 80],
    testGetName: 'Xbox',
    assetName: 'icon_xbox.png',
  ),
  android(
    ids: [21],
    testGetName: 'Android',
    assetName: 'icon_android.png',
  ),
  ios(
    ids: [3, 5, 55],
    testGetName: 'Apple',
    assetName: 'icon_apple.png',
  ),
  pc(
    ids: [4],
    testGetName: 'PC',
    assetName: 'icon_windows.png',
  ),
  nintendo(
    ids: [7, 8, 9, 13, 83],
    testGetName: 'Nintendo',
    assetName: 'icon_nintendo.png',
  ),
  wii(
    ids: [10, 11],
    testGetName: 'Wii',
    assetName: 'icon_wii.png',
  ),
  linux(
    ids: [6],
    testGetName: 'Linux',
    assetName: 'icon_linux.png',
  );

  final List<int> ids;
  final String testGetName;
  final String assetName;

  const GamePlatform({
    required this.ids,
    required this.testGetName,
    required this.assetName,
  });

  @override
  String get valueName => testGetName;
}

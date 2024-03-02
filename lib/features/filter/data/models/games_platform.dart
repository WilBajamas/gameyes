//** Hardcoding game platforms for simplicity */
import 'package:equatable/equatable.dart';

// ** Locally used entity //

enum GamePlatfom {
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

  const GamePlatfom({
    required this.ids,
    required this.name,
    required this.assetName,
  });
}

class GamePlatform extends Equatable {
  final int id;
  final String name;
  final String slug;

  const GamePlatform({
    required this.id,
    required this.name,
    required this.slug,
  });

  @override
  List<Object?> get props => [id, name, slug];
}

class Playstation5 extends GamePlatform {
  const Playstation5()
      : super(id: 187, name: 'Playstation 5', slug: 'playstation5');
}

class Playstation4 extends GamePlatform {
  const Playstation4()
      : super(id: 18, name: 'Playstation 4', slug: 'playstation4');
}

class Pc extends GamePlatform {
  const Pc() : super(id: 4, name: 'PC', slug: 'pc');
}

class XboxOne extends GamePlatform {
  const XboxOne() : super(id: 1, name: 'Xbox One', slug: 'xbox-one');
}

class XboxSeriesSX extends GamePlatform {
  const XboxSeriesSX()
      : super(id: 186, name: 'Xbox Series S/X', slug: 'xbox-series-x');
}

class NintendoSwitch extends GamePlatform {
  const NintendoSwitch()
      : super(id: 7, name: 'Nintendo Switch', slug: 'nintendo-swtich');
}

class Wii extends GamePlatform {
  const Wii() : super(id: 11, name: 'Wii', slug: 'wii');
}

class WiiU extends GamePlatform {
  const WiiU() : super(id: 10, name: 'Wii U', slug: 'wii-u');
}

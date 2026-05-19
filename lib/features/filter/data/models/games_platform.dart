import 'package:equatable/equatable.dart';
import 'package:gaming_library_assessment_flutter/core/interface/selection.dart';

class GamePlatform extends Equatable implements EnumSelection {
  final int id;
  final String name;
  final String slug;
  final List<int> ids;

  const GamePlatform({
    required this.id,
    required this.name,
    required this.slug,
    required this.ids,
  });

  @override
  String get valueName => name;

  @override
  List<Object?> get props => [id, name, slug, ids];

  static const List<GamePlatform> values = [
    Playseason5(),
    Playseason4(),
    PcPlatform(),
    XboxOnePlatform(),
    XboxSeriesPlatform(),
    NintendoSwitchPlatform(),
    WiiPlatform(),
    WiiUPlatform(),
  ];
}

class Playseason5 extends GamePlatform {
  const Playseason5()
      : super(id: 187, name: 'Playstation 5', slug: 'playstation5', ids: const [167]);
}

class Playseason4 extends GamePlatform {
  const Playseason4()
      : super(id: 18, name: 'Playstation 4', slug: 'playstation4', ids: const [48]);
}

class PcPlatform extends GamePlatform {
  const PcPlatform() : super(id: 4, name: 'PC', slug: 'pc', ids: const [6]);
}

class XboxOnePlatform extends GamePlatform {
  const XboxOnePlatform() : super(id: 1, name: 'Xbox One', slug: 'xbox-one', ids: const [49]);
}

class XboxSeriesPlatform extends GamePlatform {
  const XboxSeriesPlatform()
      : super(id: 186, name: 'Xbox Series S/X', slug: 'xbox-series-x', ids: const [169]);
}

class NintendoSwitchPlatform extends GamePlatform {
  const NintendoSwitchPlatform()
      : super(id: 7, name: 'Nintendo Switch', slug: 'nintendo-switch', ids: const [130]);
}

class WiiPlatform extends GamePlatform {
  const WiiPlatform() : super(id: 11, name: 'Wii', slug: 'wii', ids: const [5]);
}

class WiiUPlatform extends GamePlatform {
  const WiiUPlatform() : super(id: 10, name: 'Wii U', slug: 'wii-u', ids: const [41]);
}


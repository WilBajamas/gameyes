//** Hardcoding game platforms for simplicity */
import 'package:equatable/equatable.dart';

class GamesPlatform extends Equatable {
  final int id;
  final String name;
  final String slug;

  const GamesPlatform({
    required this.id,
    required this.name,
    required this.slug,
  });

  @override
  List<Object?> get props => [id, name, slug];
}

class Playstation5 extends GamesPlatform {
  const Playstation5()
      : super(id: 1, name: 'Playstation 5', slug: 'playstation5');
}

class Playstation4 extends GamesPlatform {
  const Playstation4()
      : super(id: 2, name: 'Playstation 4', slug: 'playstation4');
}

class Pc extends GamesPlatform {
  const Pc() : super(id: 3, name: 'PC', slug: 'pc');
}

class XboxOne extends GamesPlatform {
  const XboxOne() : super(id: 4, name: 'Xbox One', slug: 'xbox-one');
}

class XboxSeriesSX extends GamesPlatform {
  const XboxSeriesSX()
      : super(id: 5, name: 'Xbox Series S/X', slug: 'xbox-series-x');
}

class NintendoSwitch extends GamesPlatform {
  const NintendoSwitch()
      : super(id: 6, name: 'Nintendo Switch', slug: 'nintendo-swtich');
}

class Wii extends GamesPlatform {
  const Wii() : super(id: 7, name: 'Wii', slug: 'wii');
}

class WiiU extends GamesPlatform {
  const WiiU() : super(id: 8, name: 'Wii U', slug: 'wii-u');
}

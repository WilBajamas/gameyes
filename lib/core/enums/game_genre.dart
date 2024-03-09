import 'package:gaming_library_assessment_flutter/core/interface/selection.dart';

enum GameGenre implements EnumSelection {
  action(id: 4, slug: 'action', name: 'Action'),
  indie(id: 51, slug: 'indie', name: 'Indie'),
  rpg(id: 5, slug: 'role-playing-games-rpg', name: 'RPG'),
  strategy(id: 10, slug: 'strategy', name: 'Strategy'),
  shooter(id: 2, slug: 'shooter', name: 'Shooter'),
  simulation(id: 14, slug: 'simulation', name: 'Simulation'),
  puzzle(id: 7, slug: 'puzzle', name: 'Puzzle'),
  platformer(id: 83, slug: 'platformer', name: 'Platformer'),
  racing(id: 1, slug: 'racing', name: 'Racing'),
  mmorpg(id: 59, slug: 'massively-multiplayer', name: 'MMORPG'),
  sports(id: 15, slug: 'sports', name: 'Sports'),
  fighting(id: 6, slug: 'fighting', name: 'Fighting'),
  card(id: 17, slug: 'card', name: 'Card');

  final int id;
  final String slug;
  final String name;

  const GameGenre({
    required this.id,
    required this.slug,
    required this.name,
  });

  @override
  String get valueName => name;
}

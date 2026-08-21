import 'package:gaming_library_assessment_flutter/core/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_cover_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/platform_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/release_date_entity.dart';

GameEntity get mockGameEntity => GameEntity(
  id: 1,
  name: 'test_name',
  cover: const GameCoverEntity(url: 'https://example.com/cover.jpg'),
  platforms: [
    const PlatformEntity(id: 1, name: 'PlayStation 5', abbreviation: 'PS5'),
    const PlatformEntity(id: 2, name: 'Xbox Series X', abbreviation: 'XSX'),
  ],
  releaseDates: [
    ReleaseDateEntity(date: DateTime(2025), human: 'Jan 01, 2025'),
  ],
);

Game get mockGame => const Game(
  id: 1,
  name: 'test_name',
  gameModes: [],
  platforms: [],
  releaseDates: [],
);

List<Game> get mockListGames => [
  mockGame,
  mockGame,
  mockGame,
  mockGame,
  mockGame,
];

// The raw shape the igdb-proxy function returns, before it is decoded.
List<Map<String, dynamic>> get mockGamesJson =>
    mockListGames.map((game) => game.toJson()).toList();

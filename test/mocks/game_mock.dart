import 'package:gaming_library_assessment_flutter/core/data/models/game.dart';

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

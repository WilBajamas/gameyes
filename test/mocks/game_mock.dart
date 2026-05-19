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

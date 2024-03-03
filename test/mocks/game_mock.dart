import 'package:gaming_library_assessment_flutter/features/games/data/models/game.dart';

import 'platform_item_mock.dart';

Game get mockGame => Game(
      8,
      'slug',
      'test game name',
      '2020-01-01',
      'backgroundImage',
      90,
      mockListPlatformItem,
    );

List<Game> get mockListGames => [
      mockGame,
      mockGame,
      mockGame,
      mockGame,
      mockGame,
    ];

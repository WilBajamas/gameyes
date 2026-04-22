import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';

import 'platform_item_mock.dart';

GameEntity get mockGame => GameEntity(
      id: 8,
      slug: 'slug',
      name: 'test game name',
      releaseDate: '2020-01-01',
      imageUrl: 'backgroundImage',
      metacritic: 90,
      platforms: mockListPlatformItem,
    );

List<GameEntity> get mockListGames => [
      mockGame,
      mockGame,
      mockGame,
      mockGame,
      mockGame,
    ];

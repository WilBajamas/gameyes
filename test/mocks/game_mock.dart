import 'package:gaming_library_assessment_flutter/core/domain/entities/game_cover_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';

GameEntity get mockGame => const GameEntity(
      id: 8,
      name: 'test game name',
      cover: GameCoverEntity(url: 'test_image_url'),
      gameModes: [],
      gameKeywords: [],
      platforms: [],
      releaseDates: [],
    );

List<GameEntity> get mockListGames => [
      mockGame,
      mockGame,
      mockGame,
      mockGame,
      mockGame,
    ];

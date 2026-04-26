import 'package:gaming_library_assessment_flutter/core/domain/entities/game_list_entity.dart';

import 'game_mock.dart';

GameListEntity get mockGamesResponse => GameListEntity(
      totalCount: 20,
      items: mockListGames,
      nextUrl: 'next_url',
      currentPage: 1,
    );

GameListEntity get mockGamesResponseEmptyResults => const GameListEntity(
      totalCount: 0,
      items: [],
      currentPage: 2,
    );

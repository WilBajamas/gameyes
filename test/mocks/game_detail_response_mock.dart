import 'package:gaming_library_assessment_flutter/core/data/models/game_cover.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/game_detail_model.dart';

GameDetailModel get mockGameDetailResponse => const GameDetailModel(
  id: 1,
  name: 'test name',
  summary: 'test description, test description',
  cover: GameCover(url: 'test_image'),
  gameModes: [],
  keywords: [],
  platforms: [],
  releaseDates: [],
);

// The raw shape the igdb-proxy function returns, before it is decoded.
// Built by hand rather than via toJson(), which leaves nested models
// (cover) as objects instead of maps.
List<Map<String, dynamic>> get mockGameDetailJson => [
  {
    'id': 1,
    'name': 'test name',
    'summary': 'test description, test description',
    'cover': {'url': 'test_image'},
    'game_modes': <dynamic>[],
    'keywords': <dynamic>[],
    'platforms': <dynamic>[],
    'release_dates': <dynamic>[],
  },
];

List<Map<String, dynamic>> get mockEmptyGameDetailJson => [];

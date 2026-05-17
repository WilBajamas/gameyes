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

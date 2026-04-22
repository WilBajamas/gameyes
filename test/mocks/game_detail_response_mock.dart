import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/game_detail_model.dart';

import 'developer_mock.dart';
import 'genre_mock.dart';
import 'platform_item_mock.dart';
import 'publisher_mock.dart';

GameDetailModel get mockGameDetailResponse => GameDetailModel(
      id: 1,
      name: 'test name',
      slug: 'test-slug',
      metacritic: 31,
      released: '2020-01-01',
      backgroundImage: 'test_image',
      backgroundImageAdditional: 'test_image',
      platforms: mockListPlatformItem,
      developers: mockListDeveloper,
      genres: mockListGenre,
      publishers: mockListPublisher,
      description: 'test description, test description',
    );

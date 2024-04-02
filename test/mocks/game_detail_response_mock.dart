import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/game_detail_response.dart';

import 'developer_mock.dart';
import 'genre_mock.dart';
import 'platform_item_mock.dart';
import 'publisher_mock.dart';

GameDetailResponse get mockGameDetailResponse => GameDetailResponse(
      1,
      'test name',
      'test-slug',
      31,
      '2020-01-01',
      'test_image',
      'test_image',
      mockListPlatformItem,
      mockListDeveloper,
      mockListGenre,
      mockListPublisher,
      'test description, test description',
    );

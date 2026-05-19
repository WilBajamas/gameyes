import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/platform_item.dart';

import 'platform_mock.dart';

List<PlatformItem> get mockListPlatformItem => [
      mockPlatformItem,
      mockPlatformItem,
      mockPlatformItem,
    ];

PlatformItem get mockPlatformItem => PlatformItem(platform: mockPlatform);

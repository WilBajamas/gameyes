import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/features/filter/data/models/games_platform.dart';
import 'package:gaming_library_assessment_flutter/features/filter/presentation/cubit/filter_cubit.dart';

import '../../mocks/date_time_mock.dart';
import '../../mocks/game_platform_mock.dart';

void main() {
  late FilterCubit filterCubit;

  setUp(() {
    filterCubit = FilterCubit();
  });
  
  test('initial state is empty FilterInitial', () {
    expect(
      filterCubit.state,
      FilterInitial(),
    );
    expect(filterCubit.state.ordering, GameOrdering.released);
    expect(filterCubit.state.gamesPlatform, const Playstation5());
  });

  blocTest(
    'emits new FilterState object on changeSelectionValue called',
    build: () => filterCubit,
    act: (cubit) => cubit.changeSelectionValue(
      platform: mockGamePlatform,
      ordering: GameOrdering.created,
      searchTerm: 'test search',
      dateFrom: mockDateTimeBefore,
      dateTo: mockDateTimeAfter,
    ),
    expect: () => [
      FilterState(
        gamesPlatform: mockGamePlatform,
        ordering: GameOrdering.created,
        searchTerm: 'test search',
        dateFrom: mockDateTimeBefore,
        dateTo: mockDateTimeAfter,
      ),
    ],
  );
}

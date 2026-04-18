import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_ordering.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/features/filter/presentation/cubits/filter_cubit.dart';

import '../../mocks/date_time_mock.dart';

void main() {
  late FilterCubit filterCubit;

  setUp(() {
    filterCubit = FilterCubit(initialState: FilterInitial());
  });

  test('initial state is empty FilterInitial', () {
    expect(
      filterCubit.state,
      FilterInitial(),
    );
    expect(filterCubit.state.ordering, GameOrdering.released);
    expect(filterCubit.state.platforms, {});
  });

  blocTest(
    'emits new FilterState object on changeSelectionValue called',
    build: () => filterCubit,
    act: (cubit) => cubit.changeSelectionValue(
      platforms: {GamePlatform.playstation},
      ordering: GameOrdering.created,
      searchTerm: 'test search',
      dateFrom: mockDateTimeBefore,
      dateTo: mockDateTimeAfter,
    ),
    expect: () => [
      FilterState(
        platforms: const {GamePlatform.playstation},
        ordering: GameOrdering.created,
        searchTerm: 'test search',
        dateFrom: mockDateTimeBefore,
        dateTo: mockDateTimeAfter,
      ),
    ],
  );
}

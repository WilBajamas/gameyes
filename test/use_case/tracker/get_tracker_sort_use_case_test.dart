import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repositories/tracker_sort_repository.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/use_cases/get_tracker_sort_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_tracker_sort_use_case_test.mocks.dart';

@GenerateMocks([TrackerSortRepository])
void main() {
  late GetTrackerSortUseCase getTrackerSortUseCase;
  late TrackerSortRepository repository;

  setUp(() {
    repository = MockTrackerSortRepository();

    GetIt.I.registerSingleton(repository);

    getTrackerSortUseCase = GetTrackerSortUseCase(repository);
  });

  tearDown(() {
    GetIt.instance.reset();
    reset(repository);
  });

  test('returns exactly what the repository returns', () {
    when(repository.getSortTag()).thenReturn(SavedGameFilterTag.date);

    expect(getTrackerSortUseCase(), SavedGameFilterTag.date);
    verify(repository.getSortTag()).called(1);
  });

  test('returns the default when the repository returns the default', () {
    when(repository.getSortTag())
        .thenReturn(SavedGameFilterTag.recentlyChanged);

    expect(getTrackerSortUseCase(), SavedGameFilterTag.recentlyChanged);
    verify(repository.getSortTag()).called(1);
  });
}

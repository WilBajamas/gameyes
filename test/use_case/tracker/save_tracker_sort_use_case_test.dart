import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repositories/tracker_sort_repository.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/use_cases/save_tracker_sort_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'save_tracker_sort_use_case_test.mocks.dart';

@GenerateMocks([TrackerSortRepository])
void main() {
  late SaveTrackerSortUseCase saveTrackerSortUseCase;
  late TrackerSortRepository repository;

  setUp(() {
    repository = MockTrackerSortRepository();

    GetIt.I.registerSingleton(repository);

    saveTrackerSortUseCase = SaveTrackerSortUseCase(repository);
  });

  tearDown(() {
    GetIt.instance.reset();
    reset(repository);
  });

  test('forwards the tag to the repository', () async {
    when(
      repository.saveSortTag(SavedGameFilterTag.name),
    ).thenAnswer((_) async {});

    await saveTrackerSortUseCase(SavedGameFilterTag.name);

    verify(repository.saveSortTag(SavedGameFilterTag.name)).called(1);
  });

  test('forwards each supported tag unchanged', () async {
    for (final tag in SavedGameFilterTag.values) {
      when(repository.saveSortTag(tag)).thenAnswer((_) async {});
    }

    for (final tag in SavedGameFilterTag.values) {
      await saveTrackerSortUseCase(tag);

      verify(repository.saveSortTag(tag)).called(1);
    }
  });
}

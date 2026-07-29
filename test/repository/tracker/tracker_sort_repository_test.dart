import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/datasources/local/tracker_preferences_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/repositories/tracker_sort_repository_impl.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repositories/tracker_sort_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tracker_sort_repository_test.mocks.dart';

@GenerateMocks([TrackerPreferencesDatasource])
void main() {
  late TrackerSortRepository trackerSortRepository;
  late TrackerPreferencesDatasource datasource;

  setUp(() {
    datasource = MockTrackerPreferencesDatasource();

    GetIt.I.registerSingleton(datasource);

    trackerSortRepository = TrackerSortRepositoryImpl(datasource);
  });

  tearDown(() {
    GetIt.instance.reset();
    reset(datasource);
  });

  test('getSortTag decodes a stored name to its enum member', () {
    when(datasource.readSortTagName()).thenReturn(SavedGameFilterTag.name.name);

    expect(trackerSortRepository.getSortTag(), SavedGameFilterTag.name);
  });

  test('getSortTag decodes every supported member', () {
    for (final tag in SavedGameFilterTag.values) {
      when(datasource.readSortTagName()).thenReturn(tag.name);

      expect(trackerSortRepository.getSortTag(), tag);
    }
  });

  test('getSortTag falls back to the default when no value is stored', () {
    when(datasource.readSortTagName()).thenReturn(null);

    expect(
      trackerSortRepository.getSortTag(),
      SavedGameFilterTag.recentlyChanged,
    );
  });

  test('getSortTag falls back to the default on an unrecognised name', () {
    when(datasource.readSortTagName()).thenReturn('a_removed_option');

    expect(
      trackerSortRepository.getSortTag(),
      SavedGameFilterTag.recentlyChanged,
    );
  });

  test('getSortTag falls back to the default on an empty stored name', () {
    when(datasource.readSortTagName()).thenReturn('');

    expect(
      trackerSortRepository.getSortTag(),
      SavedGameFilterTag.recentlyChanged,
    );
  });

  test('saveSortTag forwards the tag name to the datasource', () async {
    when(datasource.writeSortTagName(SavedGameFilterTag.date.name))
        .thenAnswer((_) async {});

    await trackerSortRepository.saveSortTag(SavedGameFilterTag.date);

    verify(datasource.writeSortTagName(SavedGameFilterTag.date.name)).called(1);
  });
}

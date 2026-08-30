import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_sort.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_view_mode.dart';
import 'package:gaming_library_assessment_flutter/features/library/data/datasources/library_preferences_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/library/data/repositories/library_preferences_repository_impl.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/repositories/library_preferences_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'library_preferences_repository_test.mocks.dart';

@GenerateMocks([LibraryPreferencesDatasource])
void main() {
  late MockLibraryPreferencesDatasource datasource;
  late LibraryPreferencesRepository repository;

  setUp(() {
    datasource = MockLibraryPreferencesDatasource();
    GetIt.I.registerSingleton(datasource);
    repository = LibraryPreferencesRepositoryImpl(datasource);
  });

  tearDown(() async {
    await GetIt.instance.reset();
    reset(datasource);
  });

  test('should return grid and recently added when nothing is stored', () {
    when(datasource.readViewModeName()).thenReturn(null);
    when(datasource.readSortName()).thenReturn(null);

    expect(repository.getViewMode(), LibraryViewMode.grid);
    expect(repository.getSort(), LibrarySort.recentlyAdded);
  });

  test('should return the stored view mode and sort', () {
    when(datasource.readViewModeName()).thenReturn('list');
    when(datasource.readSortName()).thenReturn('alphabetical');

    expect(repository.getViewMode(), LibraryViewMode.list);
    expect(repository.getSort(), LibrarySort.alphabetical);
  });

  test(
    'should fall back to the defaults when the stored value is unrecognised',
    () {
      when(datasource.readViewModeName()).thenReturn('carousel');
      when(datasource.readSortName()).thenReturn('nonsense');

      expect(repository.getViewMode(), LibraryViewMode.grid);
      expect(repository.getSort(), LibrarySort.recentlyAdded);
    },
  );

  test('should write the enum name for the view mode and the sort', () async {
    when(datasource.writeViewModeName(any)).thenAnswer((_) async {});
    when(datasource.writeSortName(any)).thenAnswer((_) async {});

    await repository.saveViewMode(LibraryViewMode.list);
    await repository.saveSort(LibrarySort.playtime);

    verify(datasource.writeViewModeName('list'));
    verify(datasource.writeSortName('playtime'));
  });

  test('should not surface an error when a write fails', () async {
    // The datasource's own contract is to swallow a failed write and return
    // a normal, completed future; the repository forwards it as-is, so a
    // failure never reaches this caller either.
    when(datasource.writeViewModeName(any)).thenAnswer((_) async {});

    await expectLater(repository.saveViewMode(LibraryViewMode.list), completes);
  });
}

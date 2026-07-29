import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repositories/tracker_repository.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/use_cases/get_tracker_sort_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/use_cases/save_tracker_sort_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubits/tracker_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubits/tracker_state.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tracker_cubit_test.mocks.dart';

@GenerateMocks([
  TrackerRepository,
  GetTrackerSortUseCase,
  SaveTrackerSortUseCase,
])
void main() {
  late TrackerRepository repository;
  late GetTrackerSortUseCase getTrackerSortUseCase;
  late SaveTrackerSortUseCase saveTrackerSortUseCase;

  /// `any` and `argThat` are both typed `Null` in this mockito version, so
  /// neither can be passed to the non-nullable `SavedGameFilterTag`
  /// parameter. Every member is stubbed / asserted explicitly instead.
  void stubSaveSucceeds() {
    for (final tag in SavedGameFilterTag.values) {
      when(saveTrackerSortUseCase(tag)).thenAnswer((_) async {});
    }
  }

  void verifyNothingPersisted() {
    for (final tag in SavedGameFilterTag.values) {
      verifyNever(saveTrackerSortUseCase(tag));
    }
  }

  TrackerCubit buildCubit() => TrackerCubit(
        repository,
        saveTrackerSortUseCase,
        getTrackerSortUseCase,
      );

  setUp(() {
    repository = MockTrackerRepository();
    getTrackerSortUseCase = MockGetTrackerSortUseCase();
    saveTrackerSortUseCase = MockSaveTrackerSortUseCase();

    GetIt.I.registerSingleton(repository);

    when(getTrackerSortUseCase())
        .thenReturn(SavedGameFilterTag.recentlyChanged);
    stubSaveSucceeds();
  });

  tearDown(() {
    GetIt.instance.reset();
    reset(repository);
    reset(getTrackerSortUseCase);
    reset(saveTrackerSortUseCase);
  });

  test('initial state uses the restored tag', () {
    when(getTrackerSortUseCase()).thenReturn(SavedGameFilterTag.date);

    final cubit = buildCubit();

    expect(cubit.state.tag, SavedGameFilterTag.date);
    expect(cubit.state.searchTerm, isNull);
  });

  test('initial state falls back to the default the use case returns', () {
    when(getTrackerSortUseCase())
        .thenReturn(SavedGameFilterTag.recentlyChanged);

    final cubit = buildCubit();

    expect(cubit.state.tag, SavedGameFilterTag.recentlyChanged);
  });

  blocTest<TrackerCubit, TrackerState>(
    'setSortTag emits the new tag and persists it',
    build: buildCubit,
    act: (cubit) => cubit.setSortTag(SavedGameFilterTag.name),
    expect: () => const [TrackerState(tag: SavedGameFilterTag.name)],
    verify: (_) {
      verify(saveTrackerSortUseCase(SavedGameFilterTag.name)).called(1);
    },
  );

  blocTest<TrackerCubit, TrackerState>(
    'setSortTag with the current tag emits nothing and persists nothing',
    build: buildCubit,
    act: (cubit) => cubit.setSortTag(SavedGameFilterTag.recentlyChanged),
    expect: () => const <TrackerState>[],
    verify: (_) {
      verifyNothingPersisted();
    },
  );

  blocTest<TrackerCubit, TrackerState>(
    'setSortTag leaves an active searchTerm intact',
    build: buildCubit,
    act: (cubit) {
      cubit.setSearchTerm('halo');
      cubit.setSortTag(SavedGameFilterTag.date);
    },
    expect: () => const [
      TrackerState(searchTerm: 'halo'),
      TrackerState(tag: SavedGameFilterTag.date, searchTerm: 'halo'),
    ],
  );

  blocTest<TrackerCubit, TrackerState>(
    'setSearchTerm changes only searchTerm and persists nothing',
    build: buildCubit,
    act: (cubit) => cubit.setSearchTerm('doom'),
    expect: () => const [TrackerState(searchTerm: 'doom')],
    verify: (cubit) {
      expect(cubit.state.tag, SavedGameFilterTag.recentlyChanged);
      verifyNothingPersisted();
    },
  );

  blocTest<TrackerCubit, TrackerState>(
    'setSearchTerm clears the term when given null',
    build: buildCubit,
    act: (cubit) {
      cubit.setSearchTerm('doom');
      cubit.setSearchTerm(null);
    },
    expect: () => const [
      TrackerState(searchTerm: 'doom'),
      TrackerState(),
    ],
  );

  blocTest<TrackerCubit, TrackerState>(
    'a failing save still emits the new sort tag',
    build: () {
      when(saveTrackerSortUseCase(SavedGameFilterTag.name))
          .thenAnswer((_) async => Future<void>.error(Exception('write')));

      return buildCubit();
    },
    act: (cubit) => cubit.setSortTag(SavedGameFilterTag.name),
    expect: () => const [TrackerState(tag: SavedGameFilterTag.name)],
    verify: (cubit) {
      expect(cubit.state.tag, SavedGameFilterTag.name);
    },
  );
}

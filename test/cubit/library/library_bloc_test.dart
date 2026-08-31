import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_sort.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_view_mode.dart';
import 'package:gaming_library_assessment_flutter/features/library/const.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_counts_entity.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_entry_entity.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_page_entity.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/use_cases/fetch_library_counts_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/use_cases/fetch_library_page_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/use_cases/get_library_preferences_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/use_cases/save_library_sort_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/use_cases/save_library_view_mode_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/library/presentation/blocs/library_bloc.dart';
import 'package:gaming_library_assessment_flutter/features/library/presentation/blocs/library_state.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'library_bloc_test.mocks.dart';

LibraryEntryEntity _entry(
  int igdbId, {
  LibraryStatus status = LibraryStatus.playing,
}) => LibraryEntryEntity(
  id: 'entry-$igdbId',
  igdbId: igdbId,
  title: 'Game $igdbId',
  status: status,
  createdAt: DateTime.parse('2026-08-01T00:00:00.000Z'),
  updatedAt: DateTime.parse('2026-08-20T00:00:00.000Z'),
);

List<LibraryEntryEntity> _pageOf(int count, {int startAt = 0}) =>
    List.generate(count, (i) => _entry(startAt + i));

final _counts = LibraryCountsEntity(
  byStatus: {for (final status in LibraryStatus.values) status: 0},
  total: 0,
);

const _defaultPreferences = (
  viewMode: LibraryViewMode.grid,
  sort: LibrarySort.recentlyAdded,
);

@GenerateMocks([
  FetchLibraryPageUseCase,
  FetchLibraryCountsUseCase,
  GetLibraryPreferencesUseCase,
  SaveLibraryViewModeUseCase,
  SaveLibrarySortUseCase,
])
void main() {
  late MockFetchLibraryPageUseCase fetchLibraryPageUseCase;
  late MockFetchLibraryCountsUseCase fetchLibraryCountsUseCase;
  late MockGetLibraryPreferencesUseCase getLibraryPreferencesUseCase;
  late MockSaveLibraryViewModeUseCase saveLibraryViewModeUseCase;
  late MockSaveLibrarySortUseCase saveLibrarySortUseCase;
  late LibraryBloc bloc;

  setUp(() {
    provideDummy<Result<LibraryPageEntity>>(
      const Success(LibraryPageEntity(entries: [], matchedCount: 0)),
    );
    provideDummy<Result<LibraryCountsEntity>>(Success(_counts));

    fetchLibraryPageUseCase = MockFetchLibraryPageUseCase();
    fetchLibraryCountsUseCase = MockFetchLibraryCountsUseCase();
    getLibraryPreferencesUseCase = MockGetLibraryPreferencesUseCase();
    saveLibraryViewModeUseCase = MockSaveLibraryViewModeUseCase();
    saveLibrarySortUseCase = MockSaveLibrarySortUseCase();

    GetIt.I.registerSingleton(fetchLibraryPageUseCase);
    GetIt.I.registerSingleton(fetchLibraryCountsUseCase);
    GetIt.I.registerSingleton(getLibraryPreferencesUseCase);
    GetIt.I.registerSingleton(saveLibraryViewModeUseCase);
    GetIt.I.registerSingleton(saveLibrarySortUseCase);

    when(getLibraryPreferencesUseCase.call()).thenReturn(_defaultPreferences);
    when(saveLibraryViewModeUseCase.call(any)).thenAnswer((_) async {});
    when(saveLibrarySortUseCase.call(any)).thenAnswer((_) async {});

    bloc = LibraryBloc(
      fetchLibraryPageUseCase,
      fetchLibraryCountsUseCase,
      getLibraryPreferencesUseCase,
      saveLibraryViewModeUseCase,
      saveLibrarySortUseCase,
    );
  });

  tearDown(() async {
    await bloc.close();
    await GetIt.instance.reset();
    reset(fetchLibraryPageUseCase);
    reset(fetchLibraryCountsUseCase);
    reset(getLibraryPreferencesUseCase);
    reset(saveLibraryViewModeUseCase);
    reset(saveLibrarySortUseCase);
  });

  test(
    'initial state is the declared LibraryState and no use case is called',
    () {
      expect(bloc.state, const LibraryState());
      verifyZeroInteractions(fetchLibraryPageUseCase);
      verifyZeroInteractions(fetchLibraryCountsUseCase);
      verifyZeroInteractions(getLibraryPreferencesUseCase);
    },
  );

  blocTest<LibraryBloc, LibraryState>(
    'emits loading then success when the first page loads',
    setUp: () {
      when(
        fetchLibraryPageUseCase.call(
          sort: LibrarySort.recentlyAdded,
          limit: anyNamed('limit'),
          offset: 0,
        ),
      ).thenAnswer(
        (_) async =>
            Success(LibraryPageEntity(entries: [_entry(1)], matchedCount: 1)),
      );
      when(
        fetchLibraryCountsUseCase.call(),
      ).thenAnswer((_) async => Success(_counts));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const LibraryStarted()),
    expect: () => [
      const LibraryState(status: LibraryLoadStatus.loading),
      LibraryState(
        status: LibraryLoadStatus.success,
        entries: [_entry(1)],
        matchedCount: 1,
        hasReachedEnd: true,
        counts: _counts,
      ),
    ],
  );

  blocTest<LibraryBloc, LibraryState>(
    'emits loading then failed when the first page fails',
    setUp: () {
      when(
        fetchLibraryPageUseCase.call(
          sort: LibrarySort.recentlyAdded,
          limit: anyNamed('limit'),
          offset: 0,
        ),
      ).thenAnswer((_) async => Failure(const ErrorType.notSignedIn()));
      when(
        fetchLibraryCountsUseCase.call(),
      ).thenAnswer((_) async => Success(_counts));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const LibraryStarted()),
    expect: () => [
      const LibraryState(status: LibraryLoadStatus.loading),
      LibraryState(
        status: LibraryLoadStatus.failed,
        error: const ErrorType.notSignedIn(),
        counts: _counts,
      ),
    ],
  );

  blocTest<LibraryBloc, LibraryState>(
    'resets to the first page and keeps sort, view mode and term when the '
    'status changes',
    seed: () => LibraryState(
      sort: LibrarySort.playtime,
      viewMode: LibraryViewMode.list,
      searchTerm: 'mario',
      entries: [_entry(1)],
      status: LibraryLoadStatus.success,
      matchedCount: 1,
      hasReachedEnd: true,
      counts: _counts,
    ),
    setUp: () {
      when(
        fetchLibraryPageUseCase.call(
          status: LibraryStatus.backlog,
          sort: LibrarySort.playtime,
          limit: anyNamed('limit'),
          offset: 0,
          searchTerm: 'mario',
        ),
      ).thenAnswer(
        (_) async =>
            Success(LibraryPageEntity(entries: [_entry(2)], matchedCount: 1)),
      );
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const LibraryStatusSelected(LibraryStatus.backlog)),
    expect: () {
      final seeded = LibraryState(
        sort: LibrarySort.playtime,
        viewMode: LibraryViewMode.list,
        searchTerm: 'mario',
        entries: [_entry(1)],
        status: LibraryLoadStatus.success,
        matchedCount: 1,
        hasReachedEnd: true,
        counts: _counts,
      );
      return [
        seeded.copyWith(
          activeStatus: LibraryStatus.backlog,
          status: LibraryLoadStatus.loading,
          hasReachedEnd: false,
        ),
        seeded.copyWith(
          activeStatus: LibraryStatus.backlog,
          status: LibraryLoadStatus.success,
          entries: [_entry(2)],
          matchedCount: 1,
          hasReachedEnd: true,
        ),
      ];
    },
    verify: (_) => verifyZeroInteractions(fetchLibraryCountsUseCase),
  );

  blocTest<LibraryBloc, LibraryState>(
    'resets to the first page and keeps status, view mode and term when '
    'the sort changes',
    seed: () => LibraryState(
      activeStatus: LibraryStatus.completed,
      viewMode: LibraryViewMode.list,
      searchTerm: 'mario',
      entries: [_entry(1)],
      status: LibraryLoadStatus.success,
      matchedCount: 1,
      hasReachedEnd: true,
      counts: _counts,
    ),
    setUp: () {
      when(
        fetchLibraryPageUseCase.call(
          status: LibraryStatus.completed,
          sort: LibrarySort.alphabetical,
          limit: anyNamed('limit'),
          offset: 0,
          searchTerm: 'mario',
        ),
      ).thenAnswer(
        (_) async =>
            Success(LibraryPageEntity(entries: [_entry(2)], matchedCount: 1)),
      );
    },
    build: () => bloc,
    act: (bloc) =>
        bloc.add(const LibrarySortSelected(LibrarySort.alphabetical)),
    expect: () {
      final seeded = LibraryState(
        activeStatus: LibraryStatus.completed,
        viewMode: LibraryViewMode.list,
        searchTerm: 'mario',
        entries: [_entry(1)],
        status: LibraryLoadStatus.success,
        matchedCount: 1,
        hasReachedEnd: true,
        counts: _counts,
      );
      return [
        seeded.copyWith(
          sort: LibrarySort.alphabetical,
          status: LibraryLoadStatus.loading,
          hasReachedEnd: false,
        ),
        seeded.copyWith(
          sort: LibrarySort.alphabetical,
          status: LibraryLoadStatus.success,
          entries: [_entry(2)],
          matchedCount: 1,
          hasReachedEnd: true,
        ),
      ];
    },
    verify: (_) =>
        verify(saveLibrarySortUseCase.call(LibrarySort.alphabetical)),
  );

  blocTest<LibraryBloc, LibraryState>(
    'emits a new view mode without fetching',
    seed: () => const LibraryState(),
    build: () => bloc,
    act: (bloc) =>
        bloc.add(const LibraryViewModeSelected(LibraryViewMode.list)),
    expect: () => [const LibraryState(viewMode: LibraryViewMode.list)],
    verify: (_) {
      verify(saveLibraryViewModeUseCase.call(LibraryViewMode.list));
      verifyZeroInteractions(fetchLibraryPageUseCase);
    },
  );

  blocTest<LibraryBloc, LibraryState>(
    'sends both the status and the search term when a term is entered '
    'under an active status',
    seed: () => LibraryState(
      activeStatus: LibraryStatus.playing,
      status: LibraryLoadStatus.success,
      entries: [_entry(1)],
      matchedCount: 1,
      hasReachedEnd: true,
      counts: _counts,
    ),
    setUp: () {
      when(
        fetchLibraryPageUseCase.call(
          status: LibraryStatus.playing,
          sort: LibrarySort.recentlyAdded,
          limit: anyNamed('limit'),
          offset: 0,
          searchTerm: 'chrono',
        ),
      ).thenAnswer(
        (_) async =>
            Success(LibraryPageEntity(entries: [_entry(1)], matchedCount: 1)),
      );
    },
    build: () => bloc,
    act: (bloc) async {
      bloc.add(const LibrarySearchTermChanged('chrono'));
      await Future<void>.delayed(const Duration(milliseconds: 350));
    },
    expect: () {
      final seeded = LibraryState(
        activeStatus: LibraryStatus.playing,
        status: LibraryLoadStatus.success,
        entries: [_entry(1)],
        matchedCount: 1,
        hasReachedEnd: true,
        counts: _counts,
      );
      return [
        seeded.copyWith(
          searchTerm: 'chrono',
          status: LibraryLoadStatus.loading,
          hasReachedEnd: false,
        ),
        seeded.copyWith(
          searchTerm: 'chrono',
          status: LibraryLoadStatus.success,
          entries: [_entry(1)],
          matchedCount: 1,
          hasReachedEnd: true,
        ),
      ];
    },
  );

  blocTest<LibraryBloc, LibraryState>(
    'issues one query for three keystrokes inside the debounce window',
    seed: () => LibraryState(
      status: LibraryLoadStatus.success,
      entries: [_entry(1)],
      matchedCount: 1,
      hasReachedEnd: true,
      counts: _counts,
    ),
    setUp: () {
      when(
        fetchLibraryPageUseCase.call(
          sort: LibrarySort.recentlyAdded,
          limit: anyNamed('limit'),
          offset: 0,
          searchTerm: 'cho',
        ),
      ).thenAnswer(
        (_) async =>
            Success(LibraryPageEntity(entries: [_entry(1)], matchedCount: 1)),
      );
    },
    build: () => bloc,
    act: (bloc) async {
      bloc.add(const LibrarySearchTermChanged('c'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      bloc.add(const LibrarySearchTermChanged('ch'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      bloc.add(const LibrarySearchTermChanged('cho'));
      await Future<void>.delayed(const Duration(milliseconds: 400));
    },
    verify: (_) {
      verify(
        fetchLibraryPageUseCase.call(
          sort: LibrarySort.recentlyAdded,
          limit: anyNamed('limit'),
          offset: 0,
          searchTerm: 'cho',
        ),
      ).called(1);
    },
  );

  blocTest<LibraryBloc, LibraryState>(
    'emits nothing and keeps the loaded entries until the debounce window '
    'elapses',
    seed: () => LibraryState(
      status: LibraryLoadStatus.success,
      entries: [_entry(1)],
      matchedCount: 1,
      hasReachedEnd: true,
      counts: _counts,
    ),
    build: () => bloc,
    act: (bloc) async {
      bloc.add(const LibrarySearchTermChanged('chrono'));
      await Future<void>.delayed(const Duration(milliseconds: 150));
    },
    expect: () => <LibraryState>[],
    verify: (bloc) => expect(bloc.state.entries, [_entry(1)]),
  );

  blocTest<LibraryBloc, LibraryState>(
    'appends the next page rather than replacing the loaded entries',
    seed: () => LibraryState(
      status: LibraryLoadStatus.success,
      entries: _pageOf(20),
      matchedCount: 100,
      counts: _counts,
    ),
    setUp: () {
      when(
        fetchLibraryPageUseCase.call(
          sort: LibrarySort.recentlyAdded,
          limit: anyNamed('limit'),
          offset: 20,
        ),
      ).thenAnswer(
        (_) async => Success(
          LibraryPageEntity(
            entries: _pageOf(20, startAt: 20),
            matchedCount: 100,
          ),
        ),
      );
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const LibraryNextPageRequested()),
    expect: () {
      final seeded = LibraryState(
        status: LibraryLoadStatus.success,
        entries: _pageOf(20),
        matchedCount: 100,
        counts: _counts,
      );
      return [
        seeded.copyWith(nextPageStatus: LibraryNextPageStatus.loading),
        seeded.copyWith(
          nextPageStatus: LibraryNextPageStatus.initial,
          entries: [..._pageOf(20), ..._pageOf(20, startAt: 20)],
          matchedCount: 100,
          hasReachedEnd: false,
        ),
      ];
    },
  );

  blocTest<LibraryBloc, LibraryState>(
    'sets the end-of-results flag once the loaded count reaches the '
    'matched count',
    setUp: () {
      when(
        fetchLibraryPageUseCase.call(
          sort: LibrarySort.recentlyAdded,
          limit: anyNamed('limit'),
          offset: 0,
        ),
      ).thenAnswer(
        (_) async =>
            Success(LibraryPageEntity(entries: _pageOf(20), matchedCount: 20)),
      );
      when(
        fetchLibraryCountsUseCase.call(),
      ).thenAnswer((_) async => Success(_counts));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const LibraryStarted()),
    verify: (bloc) => expect(bloc.state.hasReachedEnd, isTrue),
  );

  blocTest<LibraryBloc, LibraryState>(
    'does not set the end-of-results flag on a full page that is not the '
    'last',
    setUp: () {
      when(
        fetchLibraryPageUseCase.call(
          sort: LibrarySort.recentlyAdded,
          limit: anyNamed('limit'),
          offset: 0,
        ),
      ).thenAnswer(
        (_) async =>
            Success(LibraryPageEntity(entries: _pageOf(20), matchedCount: 40)),
      );
      when(
        fetchLibraryCountsUseCase.call(),
      ).thenAnswer((_) async => Success(_counts));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const LibraryStarted()),
    verify: (bloc) => expect(bloc.state.hasReachedEnd, isFalse),
  );

  blocTest<LibraryBloc, LibraryState>(
    'sets the end-of-results flag when a full appended page reaches the '
    'matched count',
    seed: () => LibraryState(
      status: LibraryLoadStatus.success,
      entries: _pageOf(LibraryConstants.pageSize),
      matchedCount: LibraryConstants.pageSize * 2,
      counts: _counts,
    ),
    setUp: () {
      when(
        fetchLibraryPageUseCase.call(
          sort: LibrarySort.recentlyAdded,
          limit: anyNamed('limit'),
          offset: LibraryConstants.pageSize,
        ),
      ).thenAnswer(
        (_) async => Success(
          LibraryPageEntity(
            entries: _pageOf(
              LibraryConstants.pageSize,
              startAt: LibraryConstants.pageSize,
            ),
            matchedCount: LibraryConstants.pageSize * 2,
          ),
        ),
      );
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const LibraryNextPageRequested()),
    verify: (bloc) => expect(bloc.state.hasReachedEnd, isTrue),
  );

  blocTest<LibraryBloc, LibraryState>(
    'discards a next-page response that arrives after the status changed',
    seed: () => LibraryState(
      status: LibraryLoadStatus.success,
      entries: _pageOf(20),
      matchedCount: 100,
      counts: _counts,
    ),
    setUp: () {
      final nextPageCompleter = Completer<Result<LibraryPageEntity>>();

      when(
        fetchLibraryPageUseCase.call(
          sort: LibrarySort.recentlyAdded,
          limit: anyNamed('limit'),
          offset: 20,
        ),
      ).thenAnswer((_) => nextPageCompleter.future);
      when(
        fetchLibraryPageUseCase.call(
          status: LibraryStatus.playing,
          sort: LibrarySort.recentlyAdded,
          limit: anyNamed('limit'),
          offset: 0,
        ),
      ).thenAnswer(
        (_) async =>
            Success(LibraryPageEntity(entries: [_entry(1)], matchedCount: 1)),
      );

      // Exposed on the bloc test via a closure captured by `act`.
      _pendingNextPage = nextPageCompleter;
    },
    build: () => bloc,
    act: (bloc) async {
      bloc.add(const LibraryNextPageRequested());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const LibraryStatusSelected(LibraryStatus.playing));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      _pendingNextPage!.complete(
        Success(
          LibraryPageEntity(
            entries: _pageOf(20, startAt: 20),
            matchedCount: 100,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));
      _pendingNextPage = null;
    },
    expect: () {
      final seeded = LibraryState(
        status: LibraryLoadStatus.success,
        entries: _pageOf(20),
        matchedCount: 100,
        counts: _counts,
      );
      return [
        seeded.copyWith(nextPageStatus: LibraryNextPageStatus.loading),
        seeded.copyWith(
          activeStatus: LibraryStatus.playing,
          status: LibraryLoadStatus.loading,
          nextPageStatus: LibraryNextPageStatus.initial,
          hasReachedEnd: false,
        ),
        seeded.copyWith(
          activeStatus: LibraryStatus.playing,
          status: LibraryLoadStatus.success,
          nextPageStatus: LibraryNextPageStatus.initial,
          entries: [_entry(1)],
          matchedCount: 1,
          hasReachedEnd: true,
        ),
      ];
    },
  );

  blocTest<LibraryBloc, LibraryState>(
    'applies the stored view mode and sort before the first fetch',
    setUp: () {
      when(getLibraryPreferencesUseCase.call()).thenReturn((
        viewMode: LibraryViewMode.list,
        sort: LibrarySort.alphabetical,
      ));
      when(
        fetchLibraryPageUseCase.call(
          sort: LibrarySort.alphabetical,
          limit: anyNamed('limit'),
          offset: 0,
        ),
      ).thenAnswer(
        (_) async =>
            Success(LibraryPageEntity(entries: [_entry(1)], matchedCount: 1)),
      );
      when(
        fetchLibraryCountsUseCase.call(),
      ).thenAnswer((_) async => Success(_counts));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const LibraryStarted()),
    expect: () => [
      const LibraryState(
        sort: LibrarySort.alphabetical,
        viewMode: LibraryViewMode.list,
        status: LibraryLoadStatus.loading,
      ),
      LibraryState(
        sort: LibrarySort.alphabetical,
        viewMode: LibraryViewMode.list,
        status: LibraryLoadStatus.success,
        entries: [_entry(1)],
        matchedCount: 1,
        hasReachedEnd: true,
        counts: _counts,
      ),
    ],
  );

  blocTest<LibraryBloc, LibraryState>(
    'reads the counts once and not again when the status changes',
    setUp: () {
      when(
        fetchLibraryPageUseCase.call(
          sort: LibrarySort.recentlyAdded,
          limit: anyNamed('limit'),
          offset: 0,
        ),
      ).thenAnswer(
        (_) async =>
            Success(LibraryPageEntity(entries: [_entry(1)], matchedCount: 1)),
      );
      when(
        fetchLibraryPageUseCase.call(
          status: LibraryStatus.completed,
          sort: LibrarySort.recentlyAdded,
          limit: anyNamed('limit'),
          offset: 0,
        ),
      ).thenAnswer(
        (_) async =>
            Success(LibraryPageEntity(entries: [_entry(2)], matchedCount: 1)),
      );
      when(
        fetchLibraryCountsUseCase.call(),
      ).thenAnswer((_) async => Success(_counts));
    },
    build: () => bloc,
    act: (bloc) async {
      bloc.add(const LibraryStarted());
      await bloc.stream.firstWhere(
        (state) => state.status == LibraryLoadStatus.success,
      );
      bloc.add(const LibraryStatusSelected(LibraryStatus.completed));
      await Future<void>.delayed(const Duration(milliseconds: 50));
    },
    verify: (_) => verify(fetchLibraryCountsUseCase.call()).called(1),
  );
}

// Set inside a `setUp` closure and completed inside the matching `act`; kept
// at file scope because `blocTest`'s `setUp` and `act` cannot otherwise
// share a local.
Completer<Result<LibraryPageEntity>>? _pendingNextPage;

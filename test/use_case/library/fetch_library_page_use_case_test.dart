import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_sort.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_page_entity.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/repositories/library_repository.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/use_cases/fetch_library_page_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fetch_library_page_use_case_test.mocks.dart';

@GenerateMocks([LibraryRepository])
void main() {
  late MockLibraryRepository repository;
  late FetchLibraryPageUseCase useCase;

  setUp(() {
    provideDummy<Result<LibraryPageEntity>>(
      const Success(LibraryPageEntity(entries: [], matchedCount: 0)),
    );
    repository = MockLibraryRepository();
    GetIt.I.registerSingleton<LibraryRepository>(repository);
    useCase = FetchLibraryPageUseCase(repository);
  });

  tearDown(() async {
    await GetIt.instance.reset();
    reset(repository);
  });

  test('should return the repository result when the fetch succeeds', () async {
    when(
      repository.fetchPage(
        sort: LibrarySort.recentlyAdded,
        limit: 20,
        offset: 0,
      ),
    ).thenAnswer(
      (_) async =>
          const Success(LibraryPageEntity(entries: [], matchedCount: 0)),
    );

    final result = await useCase(
      sort: LibrarySort.recentlyAdded,
      limit: 20,
      offset: 0,
    );

    expect(result, isA<Success<LibraryPageEntity>>());
    verify(
      repository.fetchPage(
        sort: LibrarySort.recentlyAdded,
        limit: 20,
        offset: 0,
      ),
    );
  });

  test('should return the repository failure unchanged', () async {
    when(
      repository.fetchPage(
        sort: LibrarySort.recentlyAdded,
        limit: 20,
        offset: 0,
      ),
    ).thenAnswer((_) async => Failure(const ErrorType.notSignedIn()));

    final result = await useCase(
      sort: LibrarySort.recentlyAdded,
      limit: 20,
      offset: 0,
    );

    expect(result, isA<Failure<LibraryPageEntity>>());
    expect(
      (result as Failure<LibraryPageEntity>).error,
      const ErrorType.notSignedIn(),
    );
  });

  test('should forward the search term to the repository', () async {
    when(
      repository.fetchPage(
        sort: LibrarySort.recentlyAdded,
        limit: 20,
        offset: 0,
        searchTerm: 'chrono',
      ),
    ).thenAnswer(
      (_) async =>
          const Success(LibraryPageEntity(entries: [], matchedCount: 0)),
    );

    await useCase(
      sort: LibrarySort.recentlyAdded,
      limit: 20,
      offset: 0,
      searchTerm: 'chrono',
    );

    verify(
      repository.fetchPage(
        sort: LibrarySort.recentlyAdded,
        limit: 20,
        offset: 0,
        searchTerm: 'chrono',
      ),
    );
  });
}

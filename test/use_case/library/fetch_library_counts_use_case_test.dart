import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_counts_entity.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/repositories/library_repository.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/use_cases/fetch_library_counts_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fetch_library_counts_use_case_test.mocks.dart';

@GenerateMocks([LibraryRepository])
void main() {
  late MockLibraryRepository repository;
  late FetchLibraryCountsUseCase useCase;

  setUp(() {
    provideDummy<Result<LibraryCountsEntity>>(
      Success(
        LibraryCountsEntity(
          byStatus: {for (final status in LibraryStatus.values) status: 0},
          total: 0,
        ),
      ),
    );
    repository = MockLibraryRepository();
    GetIt.I.registerSingleton<LibraryRepository>(repository);
    useCase = FetchLibraryCountsUseCase(repository);
  });

  tearDown(() async {
    await GetIt.instance.reset();
    reset(repository);
  });

  test('should return the counts when the repository succeeds', () async {
    final counts = LibraryCountsEntity(
      byStatus: {
        LibraryStatus.playing: 5,
        LibraryStatus.backlog: 3,
        LibraryStatus.completed: 10,
        LibraryStatus.onHold: 1,
        LibraryStatus.wishlist: 2,
        LibraryStatus.dropped: 0,
      },
      total: 21,
    );
    when(repository.fetchCounts()).thenAnswer((_) async => Success(counts));

    final result = await useCase();

    expect(result, isA<Success<LibraryCountsEntity>>());
    expect((result as Success<LibraryCountsEntity>).value, counts);
  });

  test('should return the failure when the repository fails', () async {
    when(
      repository.fetchCounts(),
    ).thenAnswer((_) async => Failure(const ErrorType.notSignedIn()));

    final result = await useCase();

    expect(result, isA<Failure<LibraryCountsEntity>>());
    expect(
      (result as Failure<LibraryCountsEntity>).error,
      const ErrorType.notSignedIn(),
    );
  });
}

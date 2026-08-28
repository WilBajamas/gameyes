import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_entry_entity.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/repositories/library_repository.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/use_cases/update_library_entry_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_library_entry_use_case_test.mocks.dart';

@GenerateMocks([LibraryRepository])
void main() {
  late MockLibraryRepository repository;
  late UpdateLibraryEntryUseCase useCase;

  final updatedEntry = LibraryEntryEntity(
    id: 'entry-1',
    igdbId: 42,
    title: 'Chrono Trigger',
    status: LibraryStatus.playing,
    createdAt: DateTime.parse('2026-08-01T00:00:00.000Z'),
    updatedAt: DateTime.parse('2026-08-20T00:00:00.000Z'),
  );

  setUp(() {
    provideDummy<Result<LibraryEntryEntity>>(Success(updatedEntry));
    repository = MockLibraryRepository();
    GetIt.I.registerSingleton<LibraryRepository>(repository);
    useCase = UpdateLibraryEntryUseCase(repository);
  });

  tearDown(() async {
    await GetIt.instance.reset();
    reset(repository);
  });

  test('should forward a rating of 8 to the repository', () async {
    when(
      repository.update(igdbId: 42, rating: 8, clearRating: false),
    ).thenAnswer((_) async => Success(updatedEntry));

    final result = await useCase(igdbId: 42, rating: 8);

    expect(result, isA<Success<LibraryEntryEntity>>());
    verify(repository.update(igdbId: 42, rating: 8, clearRating: false));
  });

  test('should forward clearRating when the rating is being removed', () async {
    when(
      repository.update(igdbId: 42, clearRating: true),
    ).thenAnswer((_) async => Success(updatedEntry));

    final result = await useCase(igdbId: 42, clearRating: true);

    expect(result, isA<Success<LibraryEntryEntity>>());
    verify(repository.update(igdbId: 42, clearRating: true));
  });

  test('should return the repository failure unchanged', () async {
    when(
      repository.update(igdbId: 42, rating: 8, clearRating: false),
    ).thenAnswer((_) async => Failure(const ErrorType.invalidValue()));

    final result = await useCase(igdbId: 42, rating: 8);

    expect(result, isA<Failure<LibraryEntryEntity>>());
    expect(
      (result as Failure<LibraryEntryEntity>).error,
      const ErrorType.invalidValue(),
    );
  });
}

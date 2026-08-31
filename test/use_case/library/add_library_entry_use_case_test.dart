import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_entry_entity.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/repositories/library_repository.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/use_cases/add_library_entry_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_library_entry_use_case_test.mocks.dart';

@GenerateMocks([LibraryRepository])
void main() {
  late MockLibraryRepository repository;
  late AddLibraryEntryUseCase useCase;

  final addedEntry = LibraryEntryEntity(
    id: 'entry-1',
    igdbId: 42,
    title: 'Chrono Trigger',
    status: LibraryStatus.backlog,
    createdAt: DateTime.parse('2026-08-01T00:00:00.000Z'),
    updatedAt: DateTime.parse('2026-08-01T00:00:00.000Z'),
  );

  setUp(() {
    provideDummy<Result<LibraryEntryEntity>>(Success(addedEntry));
    repository = MockLibraryRepository();
    GetIt.I.registerSingleton<LibraryRepository>(repository);
    useCase = AddLibraryEntryUseCase(repository);
  });

  tearDown(() async {
    await GetIt.instance.reset();
    reset(repository);
  });

  test('should forward every supplied field to the repository', () async {
    when(
      repository.add(
        igdbId: 42,
        title: 'Chrono Trigger',
        coverUrl: 'https://example.com/cover.png',
        releaseDate: DateTime.parse('1995-03-11T00:00:00.000Z'),
        status: LibraryStatus.backlog,
        rating: 8,
        platform: 'SNES',
        genre: 'RPG',
        playtimeHours: 12.5,
        progressPercent: 40.0,
      ),
    ).thenAnswer((_) async => Success(addedEntry));

    final result = await useCase(
      igdbId: 42,
      title: 'Chrono Trigger',
      coverUrl: 'https://example.com/cover.png',
      releaseDate: DateTime.parse('1995-03-11T00:00:00.000Z'),
      status: LibraryStatus.backlog,
      rating: 8,
      platform: 'SNES',
      genre: 'RPG',
      playtimeHours: 12.5,
      progressPercent: 40.0,
    );

    expect(result, isA<Success<LibraryEntryEntity>>());
    verify(
      repository.add(
        igdbId: 42,
        title: 'Chrono Trigger',
        coverUrl: 'https://example.com/cover.png',
        releaseDate: DateTime.parse('1995-03-11T00:00:00.000Z'),
        status: LibraryStatus.backlog,
        rating: 8,
        platform: 'SNES',
        genre: 'RPG',
        playtimeHours: 12.5,
        progressPercent: 40.0,
      ),
    );
  });

  test('should return the repository failure unchanged', () async {
    when(
      repository.add(
        igdbId: 42,
        title: 'Chrono Trigger',
        status: LibraryStatus.backlog,
      ),
    ).thenAnswer((_) async => Failure(const ErrorType.duplicateEntry()));

    final result = await useCase(
      igdbId: 42,
      title: 'Chrono Trigger',
      status: LibraryStatus.backlog,
    );

    expect(result, isA<Failure<LibraryEntryEntity>>());
    expect(
      (result as Failure<LibraryEntryEntity>).error,
      const ErrorType.duplicateEntry(),
    );
  });
}

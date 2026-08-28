import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_sort.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/features/library/data/datasources/library_remote_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/library/data/models/library_entry_model.dart';
import 'package:gaming_library_assessment_flutter/features/library/data/repositories/library_repository_impl.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_entry_entity.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/repositories/library_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'library_repository_test.mocks.dart';

@GenerateMocks([LibraryRemoteDatasource])
void main() {
  late MockLibraryRemoteDatasource datasource;
  late LibraryRepository repository;

  final row = LibraryEntryModel(
    id: 'entry-1',
    userId: 'user-1',
    igdbId: 42,
    title: 'Chrono Trigger',
    status: 'playing',
    createdAt: DateTime.parse('2026-08-01T00:00:00.000Z'),
    updatedAt: DateTime.parse('2026-08-20T00:00:00.000Z'),
  );

  setUp(() {
    provideDummy<Result<List<LibraryEntryEntity>>>(Success([row.toEntity()]));
    provideDummy<Result<LibraryEntryEntity>>(Success(row.toEntity()));
    provideDummy<Result<void>>(const Success(null));
    provideDummy<LibraryEntryModel>(row);
    datasource = MockLibraryRemoteDatasource();
    GetIt.I.registerSingleton(datasource);
    repository = LibraryRepositoryImpl(datasource);
  });

  tearDown(() async {
    await GetIt.instance.reset();
    reset(datasource);
  });

  test(
    'should return the mapped entities when the datasource returns rows',
    () async {
      when(
        datasource.fetchPage(
          sort: LibrarySort.recentlyAdded,
          limit: 20,
          offset: 0,
        ),
      ).thenAnswer((_) async => [row]);

      final result = await repository.fetchPage(
        sort: LibrarySort.recentlyAdded,
        limit: 20,
        offset: 0,
      );

      expect(result, isA<Success<List<LibraryEntryEntity>>>());
      expect((result as Success<List<LibraryEntryEntity>>).value, [
        row.toEntity(),
      ]);
    },
  );

  test(
    'should return an empty success when the page is past the last row',
    () async {
      when(
        datasource.fetchPage(
          sort: LibrarySort.recentlyAdded,
          limit: 20,
          offset: 1000,
        ),
      ).thenAnswer((_) async => []);

      final result = await repository.fetchPage(
        sort: LibrarySort.recentlyAdded,
        limit: 20,
        offset: 1000,
      );

      expect(result, isA<Success<List<LibraryEntryEntity>>>());
      expect((result as Success<List<LibraryEntryEntity>>).value, isEmpty);
    },
  );

  test(
    'should return a failure when a row carries an unknown status',
    () async {
      final brokenRow = LibraryEntryModel(
        id: 'entry-2',
        userId: 'user-1',
        igdbId: 7,
        title: 'Broken Row',
        status: 'to_buy',
        createdAt: DateTime.parse('2026-08-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2026-08-20T00:00:00.000Z'),
      );
      when(
        datasource.fetchPage(
          sort: LibrarySort.recentlyAdded,
          limit: 20,
          offset: 0,
        ),
      ).thenAnswer((_) async => [brokenRow]);

      final result = await repository.fetchPage(
        sort: LibrarySort.recentlyAdded,
        limit: 20,
        offset: 0,
      );

      expect(result, isA<Failure<List<LibraryEntryEntity>>>());
    },
  );

  test('should return duplicateEntry when the insert conflicts on the '
      'unique index', () async {
    when(
      datasource.add(
        igdbId: anyNamed('igdbId'),
        title: anyNamed('title'),
        status: anyNamed('status'),
      ),
    ).thenThrow(
      const PostgrestException(message: 'duplicate key', code: '23505'),
    );

    final result = await repository.add(
      igdbId: 42,
      title: 'Chrono Trigger',
      status: LibraryStatus.playing,
    );

    expect(result, isA<Failure<LibraryEntryEntity>>());
    expect(
      (result as Failure<LibraryEntryEntity>).error,
      const ErrorType.duplicateEntry(),
    );
  });

  test('should return invalidValue when a check constraint rejects the '
      'write', () async {
    when(
      datasource.add(
        igdbId: anyNamed('igdbId'),
        title: anyNamed('title'),
        status: anyNamed('status'),
      ),
    ).thenThrow(
      const PostgrestException(message: 'check violation', code: '23514'),
    );

    final result = await repository.add(
      igdbId: 42,
      title: 'Chrono Trigger',
      status: LibraryStatus.playing,
    );

    expect(result, isA<Failure<LibraryEntryEntity>>());
    expect(
      (result as Failure<LibraryEntryEntity>).error,
      const ErrorType.invalidValue(),
    );
  });

  test('should return notAllowed when the row-level policy rejects the '
      'write', () async {
    when(
      datasource.add(
        igdbId: anyNamed('igdbId'),
        title: anyNamed('title'),
        status: anyNamed('status'),
      ),
    ).thenThrow(const PostgrestException(message: 'rls denial', code: '42501'));

    final result = await repository.add(
      igdbId: 42,
      title: 'Chrono Trigger',
      status: LibraryStatus.playing,
    );

    expect(result, isA<Failure<LibraryEntryEntity>>());
    expect(
      (result as Failure<LibraryEntryEntity>).error,
      const ErrorType.notAllowed(),
    );

    expect(
      const ErrorType.duplicateEntry() == const ErrorType.invalidValue(),
      isFalse,
    );
    expect(
      const ErrorType.invalidValue() == const ErrorType.notAllowed(),
      isFalse,
    );
    expect(
      const ErrorType.duplicateEntry() == const ErrorType.notAllowed(),
      isFalse,
    );
  });

  test('should return notSignedIn when there is no session', () async {
    when(
      datasource.add(
        igdbId: anyNamed('igdbId'),
        title: anyNamed('title'),
        status: anyNamed('status'),
      ),
    ).thenThrow(AuthSessionMissingException());

    final result = await repository.add(
      igdbId: 42,
      title: 'Chrono Trigger',
      status: LibraryStatus.playing,
    );

    expect(result, isA<Failure<LibraryEntryEntity>>());
    expect(
      (result as Failure<LibraryEntryEntity>).error,
      const ErrorType.notSignedIn(),
    );
  });

  test('should return a failure rather than throw when the datasource '
      'throws', () async {
    when(
      datasource.fetchPage(
        sort: LibrarySort.recentlyAdded,
        limit: 20,
        offset: 0,
      ),
    ).thenThrow(Exception('unexpected'));

    final result = await repository.fetchPage(
      sort: LibrarySort.recentlyAdded,
      limit: 20,
      offset: 0,
    );

    expect(result, isA<Failure<List<LibraryEntryEntity>>>());
  });

  test(
    'should return success when removing an entry that is not there',
    () async {
      when(datasource.remove(igdbId: 99)).thenAnswer((_) async {});

      final result = await repository.remove(igdbId: 99);

      expect(result, isA<Success<void>>());
    },
  );
}

import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/features/featured/data/datasources/featured_local_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/featured/data/repositories/featured_repository_impl.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/entities/countdown_game_entity.dart';
import 'package:gaming_library_assessment_flutter/features/featured/services/featured_api_service.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_counts_entity.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_entry_entity.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/repositories/library_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'featured_repository_test.mocks.dart';

@GenerateMocks([FeaturedLocalDatasource, FeaturedApiService, LibraryRepository])
void main() {
  late FeaturedRepositoryImpl repository;
  late MockFeaturedLocalDatasource localDatasource;
  late MockFeaturedApiService apiService;
  late MockLibraryRepository libraryRepository;

  LibraryEntryEntity entry(
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

  setUp(() {
    localDatasource = MockFeaturedLocalDatasource();
    apiService = MockFeaturedApiService();
    libraryRepository = MockLibraryRepository();
    repository = FeaturedRepositoryImpl(
      localDatasource,
      apiService,
      libraryRepository,
    );
    provideDummy<Result<CountdownGameEntity>>(
      const Success(CountdownGameEntity(game: null, isWishlisted: false)),
    );
    provideDummy<Result<List<LibraryEntryEntity>>>(
      const Success(<LibraryEntryEntity>[]),
    );
    provideDummy<Result<LibraryCountsEntity>>(
      Success(
        LibraryCountsEntity(
          byStatus: {for (final status in LibraryStatus.values) status: 0},
          total: 0,
        ),
      ),
    );
    when(localDatasource.getThisWeekPlayHours()).thenAnswer((_) async => 0.0);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  test(
    'should return isWishlisted true when the selected game id is in the wishlisted set',
    () async {
      when(
        libraryRepository.fetchAllEntries(status: LibraryStatus.wishlist),
      ).thenAnswer((_) async => Success([entry(1)]));
      when(
        apiService.fetchGames(argThat(contains('id = '))),
      ).thenAnswer((_) async => [const Game(id: 1, name: 'Wishlisted Game')]);

      final result = await repository.getCountdownGame();

      final entity = (result as Success<CountdownGameEntity>).value;
      expect(entity.game?.id, 1);
      expect(entity.isWishlisted, isTrue);
    },
  );

  test(
    'should return isWishlisted false when selection falls through to the global fallback',
    () async {
      when(
        libraryRepository.fetchAllEntries(status: LibraryStatus.wishlist),
      ).thenAnswer((_) async => const Success(<LibraryEntryEntity>[]));
      when(
        apiService.fetchGames(argThat(contains('hypes'))),
      ).thenAnswer((_) async => [const Game(id: 2, name: 'Hyped Game')]);

      final result = await repository.getCountdownGame();

      final entity = (result as Success<CountdownGameEntity>).value;
      expect(entity.game?.id, 2);
      expect(entity.isWishlisted, isFalse);
    },
  );

  test(
    'should return a non-empty now-playing list when library entries are playing',
    () async {
      when(libraryRepository.fetchAllEntries()).thenAnswer(
        (_) async =>
            Success([entry(1), entry(2, status: LibraryStatus.backlog)]),
      );
      when(libraryRepository.fetchCounts()).thenAnswer(
        (_) async => Success(
          LibraryCountsEntity(
            byStatus: {for (final status in LibraryStatus.values) status: 1},
            total: 2,
          ),
        ),
      );

      final result = await repository.getLibrarySnapshot();

      final snapshot = (result as Success).value;
      expect(snapshot.nowPlayingGames, hasLength(1));
      expect(snapshot.nowPlayingGames.first.title, 'Game 1');
    },
  );

  test(
    'should return a successful snapshot with zeroes when the library read fails',
    () async {
      when(
        libraryRepository.fetchAllEntries(),
      ).thenAnswer((_) async => const Failure(ErrorType.unknown()));
      when(
        libraryRepository.fetchCounts(),
      ).thenAnswer((_) async => const Failure(ErrorType.unknown()));

      final result = await repository.getLibrarySnapshot();

      final snapshot = (result as Success).value;
      expect(snapshot.totalGamesCount, 0);
      expect(snapshot.wishlistCount, 0);
      expect(snapshot.nowPlayingGames, isEmpty);
      expect(snapshot.ownedGameIds, isEmpty);
    },
  );

  test('should count owned ids across every status', () async {
    when(libraryRepository.fetchAllEntries()).thenAnswer(
      (_) async => Success([
        entry(1),
        entry(2, status: LibraryStatus.backlog),
        entry(3, status: LibraryStatus.wishlist),
      ]),
    );
    when(libraryRepository.fetchCounts()).thenAnswer(
      (_) async => Success(
        LibraryCountsEntity(
          byStatus: {for (final status in LibraryStatus.values) status: 1},
          total: 3,
        ),
      ),
    );

    final result = await repository.getLibrarySnapshot();

    final snapshot = (result as Success).value;
    expect(snapshot.ownedGameIds, {1, 2, 3});
  });
}

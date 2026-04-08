import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/datasources/local/game_local_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/repositories/tracker_repository_impl.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repository/tracker_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/saved_game_mock.dart';
import 'tracker_repository_test.mocks.dart';

@GenerateMocks([GameLocalDatasource])
void main() {
  late TrackerRepository trackerRepository;
  late GameLocalDatasource gamesLocalDataSource;

  setUp(() async {
    gamesLocalDataSource = MockGameLocalDatasource();
    await Isar.initializeIsarCore(download: true);

    GetIt.I.registerSingleton(gamesLocalDataSource);

    trackerRepository = TrackerRepositoryImpl();
  });

  tearDown(() {
    GetIt.instance.reset();
    reset(gamesLocalDataSource);
  });

  test('getSavedGames returns a list of SavedGame', () async {
    when(gamesLocalDataSource.getSavedGames())
        .thenAnswer((_) => Future.value(mockSavedGameList));

    final savedGames = await trackerRepository.getSavedGames();
    expect(savedGames, equals(mockSavedGameList));
  });

  test('getSavedGames returns an empty list', () async {
    when(gamesLocalDataSource.getSavedGames())
        .thenAnswer((_) => Future.value([]));

    final savedGames = await trackerRepository.getSavedGames();

    expect(savedGames, isEmpty);
  });

  test('listenToSavedGames emits recently changed games', () async {
    when(
      gamesLocalDataSource.listenToSavedGames(
        SavedGameFilterTag.recentlyChanged,
        null,
      ),
    ).thenAnswer((_) => Stream.value(mockSavedGameList));

    final stream = trackerRepository.savedGamesStream(
      SavedGameFilterTag.recentlyChanged,
      null,
    );

    final events = await stream.toList();

    expect(events.length, 1);
    expect(events[0], equals(mockSavedGameList));
  });

  test('listenToSavedGames emits empty list for no games', () async {
    when(
      gamesLocalDataSource.listenToSavedGames(
        SavedGameFilterTag.recentlyChanged,
        null,
      ),
    ).thenAnswer((_) => const Stream.empty());

    final stream = trackerRepository.savedGamesStream(
      SavedGameFilterTag.recentlyChanged,
      null,
    );

    final events = await stream.toList();

    expect(events.length, 0);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/featured/data/datasources/featured_local_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/featured/data/repositories/featured_repository_impl.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/entities/countdown_game_entity.dart';
import 'package:gaming_library_assessment_flutter/features/featured/services/featured_api_service.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'featured_repository_test.mocks.dart';

@GenerateMocks([FeaturedLocalDatasource, FeaturedApiService])
void main() {
  late FeaturedRepositoryImpl repository;
  late MockFeaturedLocalDatasource localDatasource;
  late MockFeaturedApiService apiService;

  setUp(() {
    localDatasource = MockFeaturedLocalDatasource();
    apiService = MockFeaturedApiService();
    repository = FeaturedRepositoryImpl(localDatasource, apiService);
    provideDummy<Result<CountdownGameEntity>>(
      const Success(CountdownGameEntity(game: null, isWishlisted: false)),
    );
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  test(
    'should return isWishlisted true when the selected game id is in the wishlisted set',
    () async {
      when(
        localDatasource.getWishlistedGames(),
      ).thenAnswer((_) async => [SavedGame(gameId: 1)]);
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
      when(localDatasource.getWishlistedGames()).thenAnswer((_) async => []);
      when(
        apiService.fetchGames(argThat(contains('hypes'))),
      ).thenAnswer((_) async => [const Game(id: 2, name: 'Hyped Game')]);

      final result = await repository.getCountdownGame();

      final entity = (result as Success<CountdownGameEntity>).value;
      expect(entity.game?.id, 2);
      expect(entity.isWishlisted, isFalse);
    },
  );
}

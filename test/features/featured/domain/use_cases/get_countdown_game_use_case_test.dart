import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_cover_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repositories/featured_repository.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_cases/get_countdown_game_use_case.dart';

class FakeFeaturedRepository implements FeaturedRepository {
  CountdownGameEntity countdown = const CountdownGameEntity(
    game: null,
    isWishlisted: false,
  );
  ErrorType? error;

  @override
  Future<Result<CountdownGameEntity>> getCountdownGame() async {
    if (error != null) return Failure(error!);
    return Success(countdown);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeFeaturedRepository repository;
  late GetCountdownGameUseCase useCase;

  setUp(() {
    repository = FakeFeaturedRepository();
    useCase = GetCountdownGameUseCase(repository);
  });

  group('GetCountdownGameUseCase Tests', () {
    test('returns CountdownGameEntity on success', () async {
      final game = GameEntity(
        id: 1,
        name: 'Countdown Game',
        cover: const GameCoverEntity(),
      );
      repository.countdown = CountdownGameEntity(
        game: game,
        isWishlisted: false,
      );

      final result = await useCase();

      expect(result, isA<Success<CountdownGameEntity>>());
      expect((result as Success<CountdownGameEntity>).value.game, game);
    });

    test('returns null game when no game available on success', () async {
      repository.countdown = const CountdownGameEntity(
        game: null,
        isWishlisted: false,
      );

      final result = await useCase();

      expect(result, isA<Success<CountdownGameEntity>>());
      expect((result as Success<CountdownGameEntity>).value.game, isNull);
    });

    test('returns Failure on error', () async {
      repository.error = const ErrorType.unknown();

      final result = await useCase();

      expect(result, isA<Failure<CountdownGameEntity>>());
      expect(
        (result as Failure<CountdownGameEntity>).error,
        const ErrorType.unknown(),
      );
    });

    test(
      'should pass the repository wishlist flag through unchanged',
      () async {
        final game = GameEntity(
          id: 1,
          name: 'Countdown Game',
          cover: const GameCoverEntity(),
        );
        repository.countdown = CountdownGameEntity(
          game: game,
          isWishlisted: true,
        );

        final result = await useCase();

        expect(
          (result as Success<CountdownGameEntity>).value.isWishlisted,
          isTrue,
        );
      },
    );
  });
}

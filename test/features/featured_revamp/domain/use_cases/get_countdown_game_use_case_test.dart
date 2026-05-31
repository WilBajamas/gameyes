import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_cover_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/features/featured_revamp/domain/repositories/featured_revamp_repository.dart';
import 'package:gaming_library_assessment_flutter/features/featured_revamp/domain/use_cases/get_countdown_game_use_case.dart';

class FakeFeaturedRevampRepository implements FeaturedRevampRepository {
  GameEntity? game;
  ErrorType? error;

  @override
  Future<Result<GameEntity?>> getCountdownGame() async {
    if (error != null) return Failure(error!);
    return Success(game);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeFeaturedRevampRepository repository;
  late GetCountdownGameUseCase useCase;

  setUp(() {
    repository = FakeFeaturedRevampRepository();
    useCase = GetCountdownGameUseCase(repository);
  });

  group('GetCountdownGameUseCase Tests', () {
    test('returns GameEntity on success', () async {
      final game = GameEntity(
        id: 1,
        name: 'Countdown Game',
        cover: const GameCoverEntity(),
      );
      repository.game = game;

      final result = await useCase();

      expect(result, isA<Success<GameEntity?>>());
      expect((result as Success<GameEntity?>).value, game);
    });

    test('returns null when no game available on success', () async {
      repository.game = null;

      final result = await useCase();

      expect(result, isA<Success<GameEntity?>>());
      expect((result as Success<GameEntity?>).value, isNull);
    });

    test('returns Failure on error', () async {
      repository.error = const ErrorType.unknown();

      final result = await useCase();

      expect(result, isA<Failure<GameEntity?>>());
      expect((result as Failure<GameEntity?>).error, const ErrorType.unknown());
    });
  });
}


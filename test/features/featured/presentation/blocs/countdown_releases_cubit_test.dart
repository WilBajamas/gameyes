import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_cover_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/release_date_entity.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repositories/featured_repository.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_cases/get_countdown_game_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_cases/get_out_this_week_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/blocs/countdown_releases_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/blocs/countdown_releases_state.dart';

class FakeGetCountdownGameUseCase extends GetCountdownGameUseCase {
  GameEntity? game;
  ErrorType? error;

  FakeGetCountdownGameUseCase() : super(FakeFeaturedRepository());

  @override
  Future<Result<GameEntity?>> call() async {
    if (error != null) return Failure(error!);
    return Success(game);
  }
}

class FakeGetOutThisWeekUseCase extends GetOutThisWeekUseCase {
  List<GameEntity>? games;
  ErrorType? error;
  bool? lastForceExtendWindow;

  FakeGetOutThisWeekUseCase() : super(FakeFeaturedRepository());

  @override
  Future<Result<List<GameEntity>>> call(
      {required bool forceExtendWindow}) async {
    lastForceExtendWindow = forceExtendWindow;
    if (error != null) return Failure(error!);
    return Success(games ?? []);
  }
}

class FakeFeaturedRepository implements FeaturedRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeGetCountdownGameUseCase fakeGetCountdownGame;
  late FakeGetOutThisWeekUseCase fakeGetOutThisWeek;
  late CountdownReleasesCubit cubit;

  setUp(() async {
    await S.load(const Locale('en'));
    fakeGetCountdownGame = FakeGetCountdownGameUseCase();
    fakeGetOutThisWeek = FakeGetOutThisWeekUseCase();
    cubit = CountdownReleasesCubit(fakeGetCountdownGame, fakeGetOutThisWeek);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('CountdownReleasesCubit Tests', () {
    test('initial state is correct', () {
      expect(cubit.state.status, CountdownReleasesStatus.initial);
      expect(cubit.state.countdownGame, isNull);
      expect(cubit.state.outThisWeekGames, isEmpty);
      expect(cubit.state.durationRemaining, isNull);
      expect(cubit.state.isReleaseDay, false);
      expect(cubit.state.isComingSoonLabel, false);
    });

    test('loadCountdownAndReleases success', () async {
      final releaseDate = DateTime.now().add(const Duration(days: 3));
      final game = GameEntity(
        id: 1,
        name: 'Test Countdown Game',
        cover: const GameCoverEntity(url: 'https://example.com/cover.jpg'),
        releaseDates: [
          ReleaseDateEntity(
            date: releaseDate,
            human: 'Q2 2026',
          ),
        ],
      );

      final weekGames = [
        GameEntity(
          id: 2,
          name: 'Released This Week',
          cover: const GameCoverEntity(),
        )
      ];

      fakeGetCountdownGame.game = game;
      fakeGetOutThisWeek.games = weekGames;

      await cubit.loadCountdownAndReleases();

      expect(cubit.state.status, CountdownReleasesStatus.success);
      expect(cubit.state.countdownGame, game);
      expect(cubit.state.outThisWeekGames, weekGames);
      expect(cubit.state.durationRemaining, isNotNull);
      expect(cubit.state.isReleaseDay, false);
    });

    test('loadCountdownAndReleases when release day is today', () async {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final game = GameEntity(
        id: 1,
        name: 'Test Countdown Game',
        cover: const GameCoverEntity(),
        releaseDates: [
          ReleaseDateEntity(
            date: todayStart,
            human: 'Today',
          ),
        ],
      );

      fakeGetCountdownGame.game = game;
      fakeGetOutThisWeek.games = [];

      await cubit.loadCountdownAndReleases();

      expect(cubit.state.status, CountdownReleasesStatus.success);
      expect(cubit.state.isReleaseDay, true);
      expect(cubit.state.durationRemaining, Duration.zero);
    });

    test('loadCountdownAndReleases error', () async {
      fakeGetCountdownGame.error = const ErrorType.unknown();
      fakeGetOutThisWeek.games = [];

      await cubit.loadCountdownAndReleases();

      expect(cubit.state.status, CountdownReleasesStatus.failed);
      expect(cubit.state.errorMessage, 'Failed to load countdown game');
    });
  });
}


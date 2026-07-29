import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_cover_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repositories/featured_repository.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_cases/get_critics_choice_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_cases/get_genre_preferences_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_cases/save_genre_preferences_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/blocs/critics_grid_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/blocs/critics_grid_state.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';

class FakeGetGenrePreferencesUseCase extends GetGenrePreferencesUseCase {
  GenrePreferencesEntity? prefs;
  ErrorType? error;

  FakeGetGenrePreferencesUseCase() : super(FakeFeaturedRepository());

  @override
  Future<Result<GenrePreferencesEntity>> call() async {
    if (error != null) return Failure(error!);
    return Success(
        prefs ?? GenrePreferencesEntity(genreIds: [], isSkipped: false));
  }
}

class FakeGetCriticsChoiceUseCase extends GetCriticsChoiceUseCase {
  List<GameEntity>? games;
  ErrorType? error;
  List<int>? lastGenrePreferences;

  FakeGetCriticsChoiceUseCase() : super(FakeFeaturedRepository());

  @override
  Future<Result<List<GameEntity>>> call(List<int> genrePreferences) async {
    lastGenrePreferences = genrePreferences;
    if (error != null) return Failure(error!);
    return Success(games ?? []);
  }
}

class FakeSaveGenrePreferencesUseCase extends SaveGenrePreferencesUseCase {
  ErrorType? error;
  List<int>? lastGenreIds;
  bool? lastIsSkipped;

  FakeSaveGenrePreferencesUseCase() : super(FakeFeaturedRepository());

  @override
  Future<Result<void>> call(List<int> genreIds,
      {required bool isSkipped}) async {
    lastGenreIds = genreIds;
    lastIsSkipped = isSkipped;
    if (error != null) return Failure(error!);
    return const Success(null);
  }
}

class FakeFeaturedRepository implements FeaturedRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeGetGenrePreferencesUseCase fakeGetGenrePreferences;
  late FakeGetCriticsChoiceUseCase fakeGetCriticsChoice;
  late FakeSaveGenrePreferencesUseCase fakeSaveGenrePreferences;
  late CriticsGridCubit cubit;

  setUp(() async {
    await S.load(const Locale('en'));
    fakeGetGenrePreferences = FakeGetGenrePreferencesUseCase();
    fakeGetCriticsChoice = FakeGetCriticsChoiceUseCase();
    fakeSaveGenrePreferences = FakeSaveGenrePreferencesUseCase();
    cubit = CriticsGridCubit(
      fakeGetGenrePreferences,
      fakeGetCriticsChoice,
      fakeSaveGenrePreferences,
    );
  });

  group('CriticsGridCubit Tests', () {
    test('initial state is correct', () {
      expect(cubit.state.status, CriticsGridStatus.initial);
      expect(cubit.state.criticsGames, isEmpty);
      expect(cubit.state.genrePreferencesEntity, isNull);
    });

    test('loadCriticsGrid success', () async {
      final prefs = GenrePreferencesEntity(genreIds: [1, 2], isSkipped: false);
      final games = <GameEntity>[
        GameEntity(
          id: 1,
          name: 'Critic Game 1',
          criticScore: 92,
          cover: const GameCoverEntity(),
        ),
        GameEntity(
          id: 2,
          name: 'Critic Game 2',
          criticScore: 85,
          cover: const GameCoverEntity(),
        ),
      ];

      fakeGetGenrePreferences.prefs = prefs;
      fakeGetCriticsChoice.games = games;

      await cubit.loadCriticsGrid();

      expect(cubit.state.status, CriticsGridStatus.success);
      expect(cubit.state.criticsGames, games);
      expect(cubit.state.genrePreferencesEntity, prefs);
      expect(fakeGetCriticsChoice.lastGenrePreferences, [1, 2]);
    });

    test('toggleGenrePreference adds genre and reloads', () async {
      final prefs = GenrePreferencesEntity(genreIds: [1], isSkipped: false);
      fakeGetGenrePreferences.prefs = prefs;
      fakeGetCriticsChoice.games = [];

      await cubit.loadCriticsGrid();

      await cubit.toggleGenrePreference(2);

      expect(fakeSaveGenrePreferences.lastGenreIds, [1, 2]);
      expect(fakeSaveGenrePreferences.lastIsSkipped, false);
      expect(cubit.state.genrePreferencesEntity?.genreIds, [1, 2]);
    });

    test('toggleGenrePreference removes genre if already selected', () async {
      final prefs = GenrePreferencesEntity(genreIds: [1, 2], isSkipped: false);
      fakeGetGenrePreferences.prefs = prefs;
      fakeGetCriticsChoice.games = [];

      await cubit.loadCriticsGrid();

      await cubit.toggleGenrePreference(1);

      expect(fakeSaveGenrePreferences.lastGenreIds, [2]);
      expect(fakeSaveGenrePreferences.lastIsSkipped, false);
      expect(cubit.state.genrePreferencesEntity?.genreIds, [2]);
    });

    test('skipGenrePreferences updates skip state and reloads', () async {
      final prefs = GenrePreferencesEntity(genreIds: [1], isSkipped: false);
      fakeGetGenrePreferences.prefs = prefs;
      fakeGetCriticsChoice.games = [];

      await cubit.loadCriticsGrid();

      await cubit.skipGenrePreferences();

      expect(fakeSaveGenrePreferences.lastGenreIds, isEmpty);
      expect(fakeSaveGenrePreferences.lastIsSkipped, true);
      expect(cubit.state.genrePreferencesEntity?.isSkipped, true);
      expect(cubit.state.genrePreferencesEntity?.genreIds, isEmpty);
    });

    test('loadCriticsGrid failure', () async {
      fakeGetGenrePreferences.error = const ErrorType.unknown();

      await cubit.loadCriticsGrid();

      expect(cubit.state.status, CriticsGridStatus.failed);
      expect(cubit.state.errorMessage, 'Failed to load genre preferences');
    });
  });
}

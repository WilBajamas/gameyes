import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repositories/featured_repository.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_cases/get_library_snapshot_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/blocs/library_stats_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/blocs/library_stats_state.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_saved_game_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeGetLibrarySnapshotUseCase extends GetLibrarySnapshotUseCase {
  LibrarySnapshotEntity? snapshot;
  ErrorType? error;

  FakeGetLibrarySnapshotUseCase() : super(FakeFeaturedRepository());

  @override
  Future<Result<LibrarySnapshotEntity>> call() async {
    if (error != null) {
      return Failure(error!);
    }
    return Success(snapshot!);
  }
}

class FakeFeaturedRepository implements FeaturedRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeGetLibrarySnapshotUseCase fakeUseCase;
  late LibraryStatsCubit cubit;

  setUp(() async {
    await S.load(const Locale('en'));
    SharedPreferences.setMockInitialValues({});
    fakeUseCase = FakeGetLibrarySnapshotUseCase();
    final prefs = await SharedPreferences.getInstance();
    cubit = LibraryStatsCubit(fakeUseCase, prefs);
  });

  group('LibraryStatsCubit Tests', () {
    test('initial state is correct', () {
      expect(cubit.state.status, LibraryStatsStatus.initial);
      expect(cubit.state.isChecklistDismissed, false);
      expect(cubit.state.step1Completed, false);
      expect(cubit.state.step2Completed, false);
      expect(cubit.state.step3Completed, false);
      expect(cubit.state.checklistProgress, 0.0);
    });

    test('loadLibrarySnapshot success with empty library (0 games)', () async {
      fakeUseCase.snapshot = LibrarySnapshotEntity(
        totalGamesCount: 0,
        nowPlayingGames: [],
        thisWeekPlayHours: 0.0,
        wishlistCount: 0,
        ownedGameIds: {},
      );

      await cubit.loadLibrarySnapshot();

      expect(cubit.state.status, LibraryStatsStatus.success);
      expect(cubit.state.isChecklistDismissed, false);
      expect(cubit.state.step1Completed, false);
      expect(cubit.state.step2Completed, false);
      expect(cubit.state.step3Completed, false);
      expect(cubit.state.checklistProgress, 0.0);
    });

    test('loadLibrarySnapshot success with 1 game, not playing', () async {
      fakeUseCase.snapshot = LibrarySnapshotEntity(
        totalGamesCount: 1,
        nowPlayingGames: [],
        thisWeekPlayHours: 0.0,
        wishlistCount: 0,
        ownedGameIds: {1},
      );

      await cubit.loadLibrarySnapshot();

      expect(cubit.state.status, LibraryStatsStatus.success);
      expect(
        cubit.state.isChecklistDismissed,
        true,
      ); // dismissed since count >= 1
      expect(cubit.state.step1Completed, true);
      expect(cubit.state.step2Completed, false);
      expect(cubit.state.step3Completed, false);
      expect(cubit.state.checklistProgress, closeTo(1.0 / 3.0, 0.01));
    });

    test(
      'loadLibrarySnapshot success with 1 game playing, and wishlist',
      () async {
        final playingGame = TrackerSavedGameEntity(
          id: 1,
          gameId: 1,
          name: 'Playing Game',
        );
        fakeUseCase.snapshot = LibrarySnapshotEntity(
          totalGamesCount: 2,
          nowPlayingGames: [playingGame],
          thisWeekPlayHours: 5.5,
          wishlistCount: 1,
          ownedGameIds: {1, 2},
        );

        await cubit.loadLibrarySnapshot();

        expect(cubit.state.status, LibraryStatsStatus.success);
        expect(cubit.state.isChecklistDismissed, true);
        expect(cubit.state.step1Completed, true);
        expect(cubit.state.step2Completed, true);
        expect(cubit.state.step3Completed, true);
        expect(cubit.state.checklistProgress, 1.0);
      },
    );

    test('loadLibrarySnapshot failure emits failed state', () async {
      fakeUseCase.error = const ErrorType.unknown();

      await cubit.loadLibrarySnapshot();

      expect(cubit.state.status, LibraryStatsStatus.failed);
      expect(cubit.state.errorMessage, 'Failed to load library stats');
    });
  });
}

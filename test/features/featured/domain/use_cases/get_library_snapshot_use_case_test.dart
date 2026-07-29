import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repositories/featured_repository.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_cases/get_library_snapshot_use_case.dart';

class FakeFeaturedRepository implements FeaturedRepository {
  LibrarySnapshotEntity? snapshot;
  ErrorType? error;

  @override
  Future<Result<LibrarySnapshotEntity>> getLibrarySnapshot() async {
    if (error != null) return Failure(error!);
    return Success(snapshot!);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeFeaturedRepository repository;
  late GetLibrarySnapshotUseCase useCase;

  setUp(() {
    repository = FakeFeaturedRepository();
    useCase = GetLibrarySnapshotUseCase(repository);
  });

  group('GetLibrarySnapshotUseCase Tests', () {
    test('returns LibrarySnapshotEntity on success', () async {
      final snapshot = LibrarySnapshotEntity(
        totalGamesCount: 5,
        nowPlayingGames: [],
        thisWeekPlayHours: 10.0,
        wishlistCount: 2,
        ownedGameIds: {1, 2, 3},
      );
      repository.snapshot = snapshot;

      final result = await useCase();

      expect(result, isA<Success<LibrarySnapshotEntity>>());
      expect((result as Success<LibrarySnapshotEntity>).value, snapshot);
    });

    test('returns Failure on error', () async {
      repository.error = const ErrorType.unknown();

      final result = await useCase();

      expect(result, isA<Failure<LibrarySnapshotEntity>>());
      expect((result as Failure<LibrarySnapshotEntity>).error,
          const ErrorType.unknown());
    });
  });
}


import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/data/datasource/base_repository_mixin.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/utils/igdb_query_builder.dart';
import 'package:gaming_library_assessment_flutter/features/featured/data/datasources/featured_local_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repositories/featured_repository.dart';
import 'package:gaming_library_assessment_flutter/features/featured/services/featured_api_service.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FeaturedRepository)
class FeaturedRepositoryImpl
    with BaseRepositoryMixin
    implements FeaturedRepository {
  final FeaturedLocalDatasource _localDatasource;
  final FeaturedApiService _featuredApiService;

  FeaturedRepositoryImpl(this._localDatasource, this._featuredApiService);

  static const _gameFields = [
    'name',
    'cover.url',
    'first_release_date',
    'release_dates.date',
    'release_dates.human',
    'release_dates.category',
    'total_rating',
    'hypes',
    'genres',
  ];

  @override
  Future<Result<LibrarySnapshotEntity>> getLibrarySnapshot() async {
    try {
      final totalCount = await _localDatasource.countSavedGames();
      final nowPlaying = await _localDatasource.getNowPlayingGames();
      final playHours = await _localDatasource.getThisWeekPlayHours();
      final wishlisted = await _localDatasource.getWishlistedGames();
      final ownedIds = await _localDatasource.getOwnedGameIds();

      final snapshot = LibrarySnapshotEntity(
        totalGamesCount: totalCount,
        nowPlayingGames: nowPlaying,
        thisWeekPlayHours: playHours,
        wishlistCount: wishlisted.length,
        ownedGameIds: ownedIds,
      );

      return Success(snapshot);
    } catch (e, stacktrace) {
      debugPrint(
        'Featured Repository getLibrarySnapshot $e | stacktrace: $stacktrace',
      );
      return Failure(const ErrorType.unknown());
    }
  }

  @override
  Future<Result<CountdownGameEntity>> getCountdownGame() async {
    try {
      final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final wishlisted = await _localDatasource.getWishlistedGames();
      final wishlistIds = wishlisted
          .map((g) => g.gameId)
          .where((id) => id != null)
          .cast<int>()
          .toSet();

      if (wishlistIds.isNotEmpty) {
        final idsString = wishlistIds.join(',');
        final query = IGDBQueryBuilder()
            .fields(_gameFields)
            .where(
              'id = ($idsString) & release_dates.date >= $nowSeconds & release_dates.category = 0',
            )
            .sort('first_release_date', descending: false)
            .limit(1)
            .build();

        final games = await _featuredApiService.fetchGames(query);
        if (games.isNotEmpty) {
          return Success(_countdownFrom(games.first.toEntity(), wishlistIds));
        }
      }

      // Fallback: Query globally most anticipated game
      final query = IGDBQueryBuilder()
          .fields(_gameFields)
          .where(
            'release_dates.date >= $nowSeconds & release_dates.category = 0 & hypes != null',
          )
          .sort('hypes', descending: true)
          .limit(1)
          .build();

      final games = await _featuredApiService.fetchGames(query);
      if (games.isNotEmpty) {
        return Success(_countdownFrom(games.first.toEntity(), wishlistIds));
      }

      return Success(
        const CountdownGameEntity(game: null, isWishlisted: false),
      );
    } catch (e, stacktrace) {
      debugPrint(
        'Featured Repository getCountdownGame $e | stacktrace: $stacktrace',
      );
      return Failure(const ErrorType.unknown());
    }
  }

  // The card's reason line claims a wishlist entry, so the flag is membership
  // of the wishlisted ids, and both selection branches derive it here.
  CountdownGameEntity _countdownFrom(GameEntity game, Set<int> wishlistIds) {
    return CountdownGameEntity(
      game: game,
      isWishlisted: wishlistIds.contains(game.id),
    );
  }

  @override
  Future<Result<List<GameEntity>>> getOutThisWeekGames(
    bool forceExtendWindow,
  ) async {
    try {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final startSeconds = todayStart.millisecondsSinceEpoch ~/ 1000;

      final wishlisted = await _localDatasource.getWishlistedGames();
      final wishlistIds = wishlisted
          .map((g) => g.gameId)
          .where((id) => id != null)
          .cast<int>()
          .toSet();

      Future<List<GameEntity>> queryWindow(int days) async {
        final endSeconds =
            todayStart.add(Duration(days: days)).millisecondsSinceEpoch ~/
                1000 -
            1;
        final query = IGDBQueryBuilder()
            .fields(_gameFields)
            .where(
              'release_dates.date >= $startSeconds & release_dates.date <= $endSeconds & release_dates.category = 0',
            )
            .sort('hypes', descending: true)
            .limit(50)
            .build();

        final games = await _featuredApiService.fetchGames(query);
        final gameEntities = games.map((g) => g.toEntity()).toList();

        // Sort: Wishlisted games first, then by hypes desc
        gameEntities.sort((a, b) {
          final aWish = wishlistIds.contains(a.id);
          final bWish = wishlistIds.contains(b.id);
          if (aWish && !bWish) return -1;
          if (!aWish && bWish) return 1;

          final aHypes = a.hypes ?? 0;
          final bHypes = b.hypes ?? 0;
          return bHypes.compareTo(aHypes);
        });

        return gameEntities.take(10).toList();
      }

      final initialDays = forceExtendWindow ? 14 : 7;
      var results = await queryWindow(initialDays);

      if (results.isEmpty && !forceExtendWindow) {
        results = await queryWindow(14);
      }

      return Success(results);
    } catch (e, stacktrace) {
      debugPrint(
        'Featured Repository getOutThisWeekGames $e | stacktrace: $stacktrace',
      );
      return Failure(const ErrorType.unknown());
    }
  }

  @override
  Future<Result<List<GameEntity>>> getCriticsChoiceGames(
    List<int> genrePreferences,
  ) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final sevenDaysAgo = now - (7 * 24 * 60 * 60);

      final List<GameEntity> results = [];

      if (genrePreferences.isNotEmpty) {
        final genresString = genrePreferences.join(',');
        final query = IGDBQueryBuilder()
            .fields(_gameFields)
            .where(
              'first_release_date >= $sevenDaysAgo & first_release_date <= $now & total_rating != null & genres = ($genresString)',
            )
            .sort('total_rating')
            .limit(4)
            .build();
        final genreGames = await _featuredApiService.fetchGames(query);
        results.addAll(genreGames.map((g) => g.toEntity()));
      }

      if (results.length < 4) {
        final query = IGDBQueryBuilder()
            .fields(_gameFields)
            .where(
              'first_release_date >= $sevenDaysAgo & first_release_date <= $now & total_rating != null',
            )
            .sort('total_rating')
            .limit(4)
            .build();
        final globalGames = await _featuredApiService.fetchGames(query);
        for (final game in globalGames) {
          final entity = game.toEntity();
          if (!results.any((g) => g.id == entity.id)) {
            results.add(entity);
            if (results.length == 4) break;
          }
        }
      }

      return Success(results);
    } catch (e, stacktrace) {
      debugPrint(
        'Featured Repository getCriticsChoiceGames $e | stacktrace: $stacktrace',
      );
      return Failure(const ErrorType.unknown());
    }
  }

  @override
  Future<Result<void>> saveGenrePreferences(
    List<int> genreIds,
    bool isSkipped,
  ) async {
    try {
      await _localDatasource.saveGenrePreferences(genreIds, isSkipped);
      return Success(null);
    } catch (e, stacktrace) {
      debugPrint(
        'Featured Repository saveGenrePreferences $e | stacktrace: $stacktrace',
      );
      return Failure(const ErrorType.unknown());
    }
  }

  @override
  Future<Result<GenrePreferencesEntity>> getGenrePreferences() async {
    try {
      final prefs = await _localDatasource.getSavedGenrePreferences();
      if (prefs != null) {
        return Success(prefs);
      }

      // If no preferences saved yet, derive them from local library
      final savedGames = await _localDatasource.getSavedGames();
      final genreCounts = <int, int>{};
      for (final game in savedGames) {
        if (game?.genres != null) {
          for (final g in game!.genres!) {
            genreCounts[g] = (genreCounts[g] ?? 0) + 1;
          }
        }
      }

      final sortedGenres = genreCounts.entries.toList()
        ..sort((a, b) {
          final cmp = b.value.compareTo(a.value);
          if (cmp != 0) return cmp;
          return a.key.compareTo(b.key);
        });

      final topGenres = sortedGenres.map((e) => e.key).toList();

      final fallbacks = [4, 5];
      for (final f in fallbacks) {
        if (topGenres.length >= 2) break;
        if (!topGenres.contains(f)) {
          topGenres.add(f);
        }
      }

      final finalGenres = topGenres.take(2).toList();

      // Persist the derived preferences so subsequent loads don't re-calculate
      await _localDatasource.saveGenrePreferences(finalGenres, false);

      return Success(
        GenrePreferencesEntity(genreIds: finalGenres, isSkipped: false),
      );
    } catch (e, stacktrace) {
      debugPrint(
        'Featured Repository getGenrePreferences $e | stacktrace: $stacktrace',
      );
      return Failure(const ErrorType.unknown());
    }
  }
}

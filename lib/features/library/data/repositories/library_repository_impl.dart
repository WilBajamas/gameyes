import 'package:gaming_library_assessment_flutter/core/data/datasource/base_repository_mixin.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_sort.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/features/library/data/datasources/library_remote_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_entry_entity.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/repositories/library_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LibraryRepository)
class LibraryRepositoryImpl
    with BaseRepositoryMixin
    implements LibraryRepository {
  const LibraryRepositoryImpl(this._datasource);

  final LibraryRemoteDatasource _datasource;

  // Turning rows into entities happens inside the future the mixin awaits,
  // not after it: a row with an unreadable status must fail here rather than
  // throw at whoever called us.
  @override
  Future<Result<List<LibraryEntryEntity>>> fetchPage({
    LibraryStatus? status,
    required LibrarySort sort,
    required int limit,
    required int offset,
  }) => fetchData(
    apiCall: _page(status: status, sort: sort, limit: limit, offset: offset),
  );

  @override
  Future<Result<LibraryEntryEntity>> add({
    required int igdbId,
    required String title,
    String? coverUrl,
    DateTime? releaseDate,
    required LibraryStatus status,
    int? rating,
    String? platform,
    String? genre,
    double? playtimeHours,
    double? progressPercent,
  }) => fetchData(
    apiCall: _added(
      igdbId: igdbId,
      title: title,
      coverUrl: coverUrl,
      releaseDate: releaseDate,
      status: status,
      rating: rating,
      platform: platform,
      genre: genre,
      playtimeHours: playtimeHours,
      progressPercent: progressPercent,
    ),
  );

  @override
  Future<Result<LibraryEntryEntity>> update({
    required int igdbId,
    LibraryStatus? status,
    int? rating,
    bool clearRating = false,
    String? platform,
    String? genre,
    double? playtimeHours,
    double? progressPercent,
  }) => fetchData(
    apiCall: _updated(
      igdbId: igdbId,
      status: status,
      rating: rating,
      clearRating: clearRating,
      platform: platform,
      genre: genre,
      playtimeHours: playtimeHours,
      progressPercent: progressPercent,
    ),
  );

  @override
  Future<Result<void>> remove({required int igdbId}) =>
      fetchData(apiCall: _datasource.remove(igdbId: igdbId));

  Future<List<LibraryEntryEntity>> _page({
    LibraryStatus? status,
    required LibrarySort sort,
    required int limit,
    required int offset,
  }) async {
    final rows = await _datasource.fetchPage(
      status: status,
      sort: sort,
      limit: limit,
      offset: offset,
    );

    return rows.map((row) => row.toEntity()).toList();
  }

  Future<LibraryEntryEntity> _added({
    required int igdbId,
    required String title,
    String? coverUrl,
    DateTime? releaseDate,
    required LibraryStatus status,
    int? rating,
    String? platform,
    String? genre,
    double? playtimeHours,
    double? progressPercent,
  }) async {
    final row = await _datasource.add(
      igdbId: igdbId,
      title: title,
      coverUrl: coverUrl,
      releaseDate: releaseDate,
      status: status,
      rating: rating,
      platform: platform,
      genre: genre,
      playtimeHours: playtimeHours,
      progressPercent: progressPercent,
    );

    return row.toEntity();
  }

  Future<LibraryEntryEntity> _updated({
    required int igdbId,
    LibraryStatus? status,
    int? rating,
    bool clearRating = false,
    String? platform,
    String? genre,
    double? playtimeHours,
    double? progressPercent,
  }) async {
    final row = await _datasource.update(
      igdbId: igdbId,
      status: status,
      rating: rating,
      clearRating: clearRating,
      platform: platform,
      genre: genre,
      playtimeHours: playtimeHours,
      progressPercent: progressPercent,
    );

    return row.toEntity();
  }
}

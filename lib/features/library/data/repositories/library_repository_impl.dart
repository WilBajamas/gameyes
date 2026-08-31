import 'package:gaming_library_assessment_flutter/core/data/datasource/base_repository_mixin.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_sort.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/features/library/data/datasources/library_remote_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_counts_entity.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_entry_entity.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_page_entity.dart';
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
  Future<Result<LibraryPageEntity>> fetchPage({
    LibraryStatus? status,
    required LibrarySort sort,
    required int limit,
    required int offset,
    String? searchTerm,
  }) => fetchData(
    apiCall: _page(
      status: status,
      sort: sort,
      limit: limit,
      offset: offset,
      searchTerm: searchTerm,
    ),
  );

  @override
  Future<Result<LibraryCountsEntity>> fetchCounts() =>
      fetchData(apiCall: _counts());

  @override
  Future<Result<List<LibraryEntryEntity>>> fetchAllEntries({
    LibraryStatus? status,
  }) => fetchData(apiCall: _allEntries(status: status));

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

  Future<LibraryPageEntity> _page({
    LibraryStatus? status,
    required LibrarySort sort,
    required int limit,
    required int offset,
    String? searchTerm,
  }) async {
    final (rows, matchedCount) = await _datasource.fetchPage(
      status: status,
      sort: sort,
      limit: limit,
      offset: offset,
      searchTerm: searchTerm,
    );

    return LibraryPageEntity(
      entries: rows.map((row) => row.toEntity()).toList(),
      matchedCount: matchedCount,
    );
  }

  Future<LibraryCountsEntity> _counts() async {
    final byStatus = await _datasource.fetchCounts();

    return LibraryCountsEntity(
      byStatus: byStatus,
      total: byStatus.values.fold(0, (sum, count) => sum + count),
    );
  }

  Future<List<LibraryEntryEntity>> _allEntries({LibraryStatus? status}) async {
    final rows = await _datasource.fetchAllEntries(status: status);

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

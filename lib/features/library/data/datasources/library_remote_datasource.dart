import 'package:gaming_library_assessment_flutter/core/enums/library_sort.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/features/library/const.dart';
import 'package:gaming_library_assessment_flutter/features/library/data/models/library_entry_model.dart';
import 'package:gaming_library_assessment_flutter/features/library/data/models/library_status_column.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class LibraryRemoteDatasource {
  const LibraryRemoteDatasource(this._client);

  final SupabaseClient _client;

  Future<List<LibraryEntryModel>> fetchPage({
    LibraryStatus? status,
    required LibrarySort sort,
    required int limit,
    required int offset,
  }) async {
    final userId = _currentUserId();
    final (column, isDescending) = _sortColumn(sort);

    var query = _client
        .from(LibraryEntryConstants.table)
        .select()
        .eq(LibraryEntryConstants.userId, userId);

    if (status != null) {
      query = query.eq(LibraryEntryConstants.status, status.columnValue);
    }

    final rows = await query
        .order(column, ascending: !isDescending)
        .range(offset, offset + limit - 1);

    return rows.map(LibraryEntryModel.fromJson).toList();
  }

  Future<LibraryEntryModel> add({
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
    final userId = _currentUserId();

    // A plain insert, not an upsert: a game already in the library must come
    // back as a conflict rather than overwrite what the person recorded.
    final row = await _client
        .from(LibraryEntryConstants.table)
        .insert({
          LibraryEntryConstants.userId: userId,
          LibraryEntryConstants.igdbId: igdbId,
          LibraryEntryConstants.title: title,
          LibraryEntryConstants.status: status.columnValue,
          LibraryEntryConstants.coverUrl: ?coverUrl,
          if (releaseDate != null)
            LibraryEntryConstants.releaseDate: releaseDate.toIso8601String(),
          LibraryEntryConstants.rating: ?rating,
          LibraryEntryConstants.platform: ?platform,
          LibraryEntryConstants.genre: ?genre,
          LibraryEntryConstants.playtimeHours: ?playtimeHours,
          LibraryEntryConstants.progressPercent: ?progressPercent,
        })
        .select()
        .single();

    return LibraryEntryModel.fromJson(row);
  }

  Future<LibraryEntryModel> update({
    required int igdbId,
    LibraryStatus? status,
    int? rating,
    bool clearRating = false,
    String? platform,
    String? genre,
    double? playtimeHours,
    double? progressPercent,
  }) async {
    final userId = _currentUserId();

    final row = await _client
        .from(LibraryEntryConstants.table)
        .update({
          LibraryEntryConstants.updatedAt: DateTime.now()
              .toUtc()
              .toIso8601String(),
          if (status != null) LibraryEntryConstants.status: status.columnValue,
          // null on its own means "leave this alone", so removing a rating
          // has to be asked for.
          if (clearRating)
            LibraryEntryConstants.rating: null
          else if (rating != null)
            LibraryEntryConstants.rating: rating,
          LibraryEntryConstants.platform: ?platform,
          LibraryEntryConstants.genre: ?genre,
          LibraryEntryConstants.playtimeHours: ?playtimeHours,
          LibraryEntryConstants.progressPercent: ?progressPercent,
        })
        .eq(LibraryEntryConstants.userId, userId)
        .eq(LibraryEntryConstants.igdbId, igdbId)
        .select()
        .single();

    return LibraryEntryModel.fromJson(row);
  }

  Future<void> remove({required int igdbId}) async {
    final userId = _currentUserId();

    await _client
        .from(LibraryEntryConstants.table)
        .delete()
        .eq(LibraryEntryConstants.userId, userId)
        .eq(LibraryEntryConstants.igdbId, igdbId);
  }

  String _currentUserId() {
    final session = _client.auth.currentSession;
    if (session == null) throw AuthSessionMissingException();

    return session.user.id;
  }

  // Rows with nothing in the sorted column go last -- order()'s default --
  // so sorting by rating does not lead with unrated games.
  (String, bool) _sortColumn(LibrarySort sort) => switch (sort) {
    LibrarySort.recentlyAdded => (LibraryEntryConstants.createdAt, true),
    LibrarySort.alphabetical => (LibraryEntryConstants.title, false),
    LibrarySort.releaseDate => (LibraryEntryConstants.releaseDate, true),
    LibrarySort.rating => (LibraryEntryConstants.rating, true),
    LibrarySort.playtime => (LibraryEntryConstants.playtimeHours, true),
  };
}

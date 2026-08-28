# Code Plan
Source: `.agents/week-3-task-briefs.md` item 3.3 (lines 211–232), via `tech-ac.md`
Date: 2026-08-27

## CREATE NEW

### supabase/migrations/20260827120000_library_entries_details.sql
```sql
-- The six columns the Library spec needs. Added, never replacing what is
-- already on the table: the applied migration stays byte-identical.
alter table public.library_entries
  add column platform text,
  add column rating int,
  add column playtime_hours numeric,
  add column progress_percent numeric,
  add column genre text,
  add column updated_at timestamptz not null default now();

-- 0 is not "unrated" -- an absent rating is null, so 0 must be rejected
-- rather than stored and later rendered as a one-star verdict.
alter table public.library_entries
  add constraint library_entries_rating_range
    check (rating is null or (rating >= 1 and rating <= 10)),
  add constraint library_entries_progress_percent_range
    check (progress_percent is null or
           (progress_percent >= 0 and progress_percent <= 100)),
  add constraint library_entries_playtime_hours_non_negative
    check (playtime_hours is null or playtime_hours >= 0);
```

### lib/core/enums/library_sort.dart
```dart
enum LibrarySort {
  recentlyAdded,
  alphabetical,
  releaseDate,
  rating,
  playtime,
}
```

### lib/features/library/const.dart
```dart
class LibraryEntryConstants {
  static const table = 'library_entries';

  static const id = 'id';
  static const userId = 'user_id';
  static const igdbId = 'igdb_id';
  static const title = 'title';
  static const coverUrl = 'cover_url';
  static const releaseDate = 'release_date';
  static const status = 'status';
  static const createdAt = 'created_at';
  static const platform = 'platform';
  static const rating = 'rating';
  static const playtimeHours = 'playtime_hours';
  static const progressPercent = 'progress_percent';
  static const genre = 'genre';
  static const updatedAt = 'updated_at';
}
```

### lib/features/library/data/models/library_status_column.dart
```dart
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';

// The database spells on hold as on_hold, so the value cannot come from the
// enum's own name. Adding a seventh status breaks this switch on purpose.
extension LibraryStatusColumn on LibraryStatus {
  String get columnValue => switch (this) {
        LibraryStatus.playing => 'playing',
        LibraryStatus.backlog => 'backlog',
        LibraryStatus.completed => 'completed',
        LibraryStatus.onHold => 'on_hold',
        LibraryStatus.wishlist => 'wishlist',
        LibraryStatus.dropped => 'dropped',
      };

  static LibraryStatus? fromColumnValue(String value) => switch (value) {
        'playing' => LibraryStatus.playing,
        'backlog' => LibraryStatus.backlog,
        'completed' => LibraryStatus.completed,
        'on_hold' => LibraryStatus.onHold,
        'wishlist' => LibraryStatus.wishlist,
        'dropped' => LibraryStatus.dropped,
        _ => null,
      };
}
```

### lib/features/library/data/models/library_entry_dto.dart
```dart
@freezed
sealed class LibraryEntryDto with _$LibraryEntryDto {
  const LibraryEntryDto._();

  const factory LibraryEntryDto({
    @JsonKey(name: LibraryEntryConstants.id) required String id,
    @JsonKey(name: LibraryEntryConstants.userId) required String userId,
    @JsonKey(name: LibraryEntryConstants.igdbId) required int igdbId,
    @JsonKey(name: LibraryEntryConstants.title) required String title,
    @JsonKey(name: LibraryEntryConstants.coverUrl) String? coverUrl,
    @JsonKey(name: LibraryEntryConstants.releaseDate) DateTime? releaseDate,
    @JsonKey(name: LibraryEntryConstants.status) required String status,
    @JsonKey(name: LibraryEntryConstants.createdAt) required DateTime createdAt,
    @JsonKey(name: LibraryEntryConstants.platform) String? platform,
    @JsonKey(name: LibraryEntryConstants.rating) int? rating,
    @JsonKey(name: LibraryEntryConstants.playtimeHours) double? playtimeHours,
    @JsonKey(name: LibraryEntryConstants.progressPercent)
    double? progressPercent,
    @JsonKey(name: LibraryEntryConstants.genre) String? genre,
    @JsonKey(name: LibraryEntryConstants.updatedAt) required DateTime updatedAt,
  }) = _LibraryEntryDto;

  factory LibraryEntryDto.fromJson(Map<String, dynamic> json) =>
      _$LibraryEntryDtoFromJson(json);

  LibraryEntryEntity toEntity() {
    final parsed = LibraryStatusColumn.fromColumnValue(status);
    // A status the app does not know is a broken row, not a reason to show
    // the person a status they never chose.
    if (parsed == null) {
      throw FormatException('Unknown library status', status);
    }

    return LibraryEntryEntity(
      id: id,
      igdbId: igdbId,
      title: title,
      coverUrl: coverUrl,
      releaseDate: releaseDate,
      status: parsed,
      createdAt: createdAt,
      platform: platform,
      rating: rating,
      playtimeHours: playtimeHours,
      progressPercent: progressPercent,
      genre: genre,
      updatedAt: updatedAt,
    );
  }
}
```

### lib/features/library/data/datasources/library_remote_datasource.dart
```dart
@injectable
class LibraryRemoteDatasource {
  const LibraryRemoteDatasource(this._client);

  final SupabaseClient _client;

  Future<List<LibraryEntryDto>> fetchPage({
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

    return rows.map(LibraryEntryDto.fromJson).toList();
  }

  Future<LibraryEntryDto> add({
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
          if (coverUrl != null) LibraryEntryConstants.coverUrl: coverUrl,
          if (releaseDate != null)
            LibraryEntryConstants.releaseDate:
                releaseDate.toIso8601String(),
          if (rating != null) LibraryEntryConstants.rating: rating,
          if (platform != null) LibraryEntryConstants.platform: platform,
          if (genre != null) LibraryEntryConstants.genre: genre,
          if (playtimeHours != null)
            LibraryEntryConstants.playtimeHours: playtimeHours,
          if (progressPercent != null)
            LibraryEntryConstants.progressPercent: progressPercent,
        })
        .select()
        .single();

    return LibraryEntryDto.fromJson(row);
  }

  Future<LibraryEntryDto> update({
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
          LibraryEntryConstants.updatedAt:
              DateTime.now().toUtc().toIso8601String(),
          if (status != null)
            LibraryEntryConstants.status: status.columnValue,
          // null on its own means "leave this alone", so removing a rating
          // has to be asked for.
          if (clearRating)
            LibraryEntryConstants.rating: null
          else if (rating != null)
            LibraryEntryConstants.rating: rating,
          if (platform != null) LibraryEntryConstants.platform: platform,
          if (genre != null) LibraryEntryConstants.genre: genre,
          if (playtimeHours != null)
            LibraryEntryConstants.playtimeHours: playtimeHours,
          if (progressPercent != null)
            LibraryEntryConstants.progressPercent: progressPercent,
        })
        .eq(LibraryEntryConstants.userId, userId)
        .eq(LibraryEntryConstants.igdbId, igdbId)
        .select()
        .single();

    return LibraryEntryDto.fromJson(row);
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
```

### lib/features/library/domain/entities/library_entry_entity.dart
```dart
@freezed
sealed class LibraryEntryEntity with _$LibraryEntryEntity {
  const factory LibraryEntryEntity({
    required String id,
    required int igdbId,
    required String title,
    String? coverUrl,
    DateTime? releaseDate,
    required LibraryStatus status,
    required DateTime createdAt,
    String? platform,
    int? rating,
    double? playtimeHours,
    double? progressPercent,
    String? genre,
    required DateTime updatedAt,
  }) = _LibraryEntryEntity;
}
```

### lib/features/library/domain/repositories/library_repository.dart
```dart
abstract interface class LibraryRepository {
  Future<Result<List<LibraryEntryEntity>>> fetchPage({
    LibraryStatus? status,
    required LibrarySort sort,
    required int limit,
    required int offset,
  });

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
  });

  Future<Result<LibraryEntryEntity>> update({
    required int igdbId,
    LibraryStatus? status,
    int? rating,
    bool clearRating,
    String? platform,
    String? genre,
    double? playtimeHours,
    double? progressPercent,
  });

  Future<Result<void>> remove({required int igdbId});
}
```

### lib/features/library/data/repositories/library_repository_impl.dart
```dart
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
  }) =>
      fetchData(
        apiCall: _page(
          status: status,
          sort: sort,
          limit: limit,
          offset: offset,
        ),
      );

  @override
  Future<Result<LibraryEntryEntity>> add({...}) =>
      fetchData(apiCall: _added(...));

  @override
  Future<Result<LibraryEntryEntity>> update({...}) =>
      fetchData(apiCall: _updated(...));

  @override
  Future<Result<void>> remove({required int igdbId}) =>
      fetchData(apiCall: _datasource.remove(igdbId: igdbId));

  Future<List<LibraryEntryEntity>> _page({...}) async {
    final rows = await _datasource.fetchPage(...);

    return rows.map((row) => row.toEntity()).toList();
  }

  Future<LibraryEntryEntity> _added({...}) async =>
      (await _datasource.add(...)).toEntity();

  Future<LibraryEntryEntity> _updated({...}) async =>
      (await _datasource.update(...)).toEntity();
}
```

### lib/features/library/domain/use_cases/fetch_library_page_use_case.dart
```dart
@injectable
class FetchLibraryPageUseCase {
  const FetchLibraryPageUseCase(this._repository);

  final LibraryRepository _repository;

  Future<Result<List<LibraryEntryEntity>>> call({
    LibraryStatus? status,
    required LibrarySort sort,
    required int limit,
    required int offset,
  }) =>
      _repository.fetchPage(
        status: status,
        sort: sort,
        limit: limit,
        offset: offset,
      );
}
```

### lib/features/library/domain/use_cases/add_library_entry_use_case.dart
```dart
@injectable
class AddLibraryEntryUseCase {
  const AddLibraryEntryUseCase(this._repository);

  final LibraryRepository _repository;

  Future<Result<LibraryEntryEntity>> call({
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
  }) =>
      _repository.add(...);
}
```

### lib/features/library/domain/use_cases/update_library_entry_use_case.dart
```dart
@injectable
class UpdateLibraryEntryUseCase {
  const UpdateLibraryEntryUseCase(this._repository);

  final LibraryRepository _repository;

  Future<Result<LibraryEntryEntity>> call({
    required int igdbId,
    LibraryStatus? status,
    int? rating,
    bool clearRating = false,
    String? platform,
    String? genre,
    double? playtimeHours,
    double? progressPercent,
  }) =>
      _repository.update(...);
}
```

### lib/features/library/domain/use_cases/remove_library_entry_use_case.dart
```dart
@injectable
class RemoveLibraryEntryUseCase {
  const RemoveLibraryEntryUseCase(this._repository);

  final LibraryRepository _repository;

  Future<Result<void>> call({required int igdbId}) =>
      _repository.remove(igdbId: igdbId);
}
```

## MODIFY EXISTING

### lib/core/data/models/error.dart
```dart
@freezed
sealed class ErrorType with _$ErrorType {
  const ErrorType._();

  // Postgres tells these three apart by code; the app could not, so every
  // one of them read as "something went wrong".
  static const _uniqueViolation = '23505';
  static const _checkViolation = '23514';
  static const _notAllowedByPolicy = '42501';

  // ...existing variants unchanged...

  const factory ErrorType.duplicateEntry() = DuplicateEntry;
  const factory ErrorType.invalidValue() = InvalidValue;
  const factory ErrorType.notAllowed() = NotAllowed;
  const factory ErrorType.notSignedIn() = NotSignedIn;

  factory ErrorType.postgrestError({
    required PostgrestException exception,
  }) =>
      switch (exception.code) {
        _uniqueViolation => const ErrorType.duplicateEntry(),
        _checkViolation => const ErrorType.invalidValue(),
        _notAllowedByPolicy => const ErrorType.notAllowed(),
        _ => ErrorType.responseError(
            message: exception.message,
            error: exception.code,
            statusCode: int.tryParse(exception.code ?? ''),
          ),
      };
}
```

### lib/core/data/datasource/base_repository_mixin.dart
```dart
    } on FunctionException catch (functionException) {
      return Failure(ErrorType.supabaseIgdbError(exception: functionException));
      // A table read or write, where the database says which rule was broken.
    } on PostgrestException catch (postgrestException) {
      return Failure(ErrorType.postgrestError(exception: postgrestException));
    } on AuthSessionMissingException {
      return Failure(const ErrorType.notSignedIn());
    } catch (_) {
      return Failure(ErrorType.unknown());
    }
```

### lib/core/domain/entities/tracker_saved_game_entity.dart
```dart
    DateTime? dateModified,
    double? hoursLogged,
    double? averageCompletionHours,
    double? manualProgressPercentage,
    @Default([]) List<TrackerGroupTaskEntity> groupTasks,
  }) = _TrackerSavedGameEntity;
```

### lib/features/tracker/data/models/saved_game.dart
```dart
        dateModified: dateModified,
        hoursLogged: hoursLogged,
        averageCompletionHours: averageCompletionHours,
        manualProgressPercentage: manualProgressPercentage,
        groupTasks: groupTasks.map((e) => e.toEntity()).toList(),
      );
```

### lib/features/featured/domain/entities/library_snapshot_entity.dart
```dart
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_saved_game_entity.dart';

class LibrarySnapshotEntity {
  final int totalGamesCount;
  final List<TrackerSavedGameEntity> nowPlayingGames;
  // ...remaining fields and constructor unchanged...
}
```

### lib/features/featured/data/repositories/featured_repository_impl.dart
```dart
      final snapshot = LibrarySnapshotEntity(
        totalGamesCount: totalCount,
        nowPlayingGames: nowPlaying.map((game) => game.toEntity()).toList(),
        thisWeekPlayHours: playHours,
        wishlistCount: wishlisted.length,
        ownedGameIds: ownedIds,
      );
```

### lib/features/featured/presentation/widgets/library_stats.dart
```dart
// import of features/tracker/data/models/saved_game.dart removed
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_saved_game_entity.dart';

  Widget _buildNowPlayingCard(
    BuildContext context,
    List<TrackerSavedGameEntity> playingGames,
  ) {

// ...unchanged through the progress branch at :287-305...

            context.router.push(
              TrackerGameDetailRoute(game: topGame),
            );
```

### .agents/references/library-design-conventions.md
```text
line 67, examples only:
  (`PS5 · 24h`, `NSW · Added 3d ago`, `PS5 · Out 14 Aug`)
plus a short inline note: the meta is two segments and `Ch. 9` is dropped
(decided 2026-08-27, D11) -- no chapter or progress-marker column exists.
The rule text `platform · contextual number` is unchanged.
```

## TEST FILES

### test/api/library/library_status_column_test.dart
- `'should produce on_hold for LibraryStatus.onHold'` — and one assertion per
  remaining value, each against the literal in the check constraint, asserted
  individually rather than round-tripped.
- `'should parse each stored status back to its enum value'` — the six literals.
- `'should return null for a status the app does not know'` — `'to_buy'`.

### test/api/library/library_entry_dto_test.dart
- `'should read every column into its field when the row is fully populated'`
- `'should keep null for every optional column when the row is empty'` — asserts
  `isNull`, explicitly not `0`, `0.0` or `''`.
- `'should write the column names as JSON keys'` — round-trips `toJson` back
  through `fromJson` rather than asserting a date's exact string form.
- `'should produce a LibraryStatus on the entity'`
- `'should throw a FormatException when the status is not one of the six'`

### test/repository/library/library_repository_test.dart
`@GenerateMocks([LibraryRemoteDatasource])`
- `'should return the mapped entities when the datasource returns rows'`
- `'should return an empty success when the page is past the last row'`
- `'should return a failure when a row carries an unknown status'`
- `'should return duplicateEntry when the insert conflicts on the unique index'`
  — datasource throws `PostgrestException(code: '23505')`.
- `'should return invalidValue when a check constraint rejects the write'` —
  `'23514'`.
- `'should return notAllowed when the row-level policy rejects the write'` —
  `'42501'`, and assert the three are not equal to one another.
- `'should return notSignedIn when there is no session'` —
  `AuthSessionMissingException`.
- `'should return a failure rather than throw when the datasource throws'`
- `'should return success when removing an entry that is not there'`

### test/use_case/library/fetch_library_page_use_case_test.dart
- `'should return the repository result when the fetch succeeds'`
- `'should return the repository failure unchanged'`

### test/use_case/library/add_library_entry_use_case_test.dart
- `'should forward every supplied field to the repository'`
- `'should return the repository failure unchanged'`

### test/use_case/library/update_library_entry_use_case_test.dart
- `'should forward a rating of 8 to the repository'`
- `'should forward clearRating when the rating is being removed'`
- `'should return the repository failure unchanged'`

### test/use_case/library/remove_library_entry_use_case_test.dart
- `'should forward the game id to the repository'`
- `'should return the repository failure unchanged'`

### test/features/featured/presentation/blocs/library_stats_cubit_test.dart (modify)
- `:99` builds `TrackerSavedGameEntity(id: 1, gameId: 1, name: 'Playing Game')`
  in place of the `SavedGame`. No assertion changes.

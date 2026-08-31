import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/features/library/data/models/library_entry_model.dart';

void main() {
  final fullRow = {
    'id': 'entry-1',
    'user_id': 'user-1',
    'igdb_id': 42,
    'title': 'Chrono Trigger',
    'cover_url': 'https://example.com/cover.png',
    'release_date': '1995-03-11T00:00:00.000Z',
    'status': 'on_hold',
    'created_at': '2026-08-01T00:00:00.000Z',
    'platform': 'SNES',
    'rating': 9,
    'playtime_hours': 24.5,
    'progress_percent': 60.0,
    'genre': 'RPG',
    'updated_at': '2026-08-20T00:00:00.000Z',
  };

  final emptyRow = {
    'id': 'entry-2',
    'user_id': 'user-1',
    'igdb_id': 7,
    'title': 'Untitled Backlog Game',
    'cover_url': null,
    'release_date': null,
    'status': 'backlog',
    'created_at': '2026-08-01T00:00:00.000Z',
    'platform': null,
    'rating': null,
    'playtime_hours': null,
    'progress_percent': null,
    'genre': null,
    'updated_at': '2026-08-20T00:00:00.000Z',
  };

  test('should read every column into its field when the row is fully '
      'populated', () {
    final model = LibraryEntryModel.fromJson(fullRow);

    expect(model.id, 'entry-1');
    expect(model.userId, 'user-1');
    expect(model.igdbId, 42);
    expect(model.title, 'Chrono Trigger');
    expect(model.coverUrl, 'https://example.com/cover.png');
    expect(model.releaseDate, DateTime.parse('1995-03-11T00:00:00.000Z'));
    expect(model.status, 'on_hold');
    expect(model.createdAt, DateTime.parse('2026-08-01T00:00:00.000Z'));
    expect(model.platform, 'SNES');
    expect(model.rating, 9);
    expect(model.playtimeHours, 24.5);
    expect(model.progressPercent, 60.0);
    expect(model.genre, 'RPG');
    expect(model.updatedAt, DateTime.parse('2026-08-20T00:00:00.000Z'));
  });

  test('should keep null for every optional column when the row is empty', () {
    final model = LibraryEntryModel.fromJson(emptyRow);

    expect(model.coverUrl, isNull);
    expect(model.releaseDate, isNull);
    expect(model.platform, isNull);
    expect(model.rating, isNull);
    expect(model.playtimeHours, isNull);
    expect(model.progressPercent, isNull);
    expect(model.genre, isNull);
  });

  test('should write the column names as JSON keys', () {
    final model = LibraryEntryModel.fromJson(fullRow);

    final roundTripped = LibraryEntryModel.fromJson(model.toJson());

    expect(roundTripped, model);
  });

  test('should produce a LibraryStatus on the entity', () {
    final model = LibraryEntryModel.fromJson(fullRow);

    final entity = model.toEntity();

    expect(entity.status, LibraryStatus.onHold);
  });

  test('should throw a FormatException when the status is not one of the '
      'six', () {
    final model = LibraryEntryModel.fromJson({...fullRow, 'status': 'to_buy'});

    expect(model.toEntity, throwsA(isA<FormatException>()));
  });
}

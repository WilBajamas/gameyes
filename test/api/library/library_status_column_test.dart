import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/features/library/data/models/library_status_column.dart';

void main() {
  test('should produce playing for LibraryStatus.playing', () {
    expect(LibraryStatus.playing.columnValue, 'playing');
  });

  test('should produce backlog for LibraryStatus.backlog', () {
    expect(LibraryStatus.backlog.columnValue, 'backlog');
  });

  test('should produce completed for LibraryStatus.completed', () {
    expect(LibraryStatus.completed.columnValue, 'completed');
  });

  test('should produce on_hold for LibraryStatus.onHold', () {
    expect(LibraryStatus.onHold.columnValue, 'on_hold');
  });

  test('should produce wishlist for LibraryStatus.wishlist', () {
    expect(LibraryStatus.wishlist.columnValue, 'wishlist');
  });

  test('should produce dropped for LibraryStatus.dropped', () {
    expect(LibraryStatus.dropped.columnValue, 'dropped');
  });

  test('should parse each stored status back to its enum value', () {
    expect(
      LibraryStatusColumn.fromColumnValue('playing'),
      LibraryStatus.playing,
    );
    expect(
      LibraryStatusColumn.fromColumnValue('backlog'),
      LibraryStatus.backlog,
    );
    expect(
      LibraryStatusColumn.fromColumnValue('completed'),
      LibraryStatus.completed,
    );
    expect(
      LibraryStatusColumn.fromColumnValue('on_hold'),
      LibraryStatus.onHold,
    );
    expect(
      LibraryStatusColumn.fromColumnValue('wishlist'),
      LibraryStatus.wishlist,
    );
    expect(
      LibraryStatusColumn.fromColumnValue('dropped'),
      LibraryStatus.dropped,
    );
  });

  test('should return null for a status the app does not know', () {
    expect(LibraryStatusColumn.fromColumnValue('to_buy'), isNull);
  });
}

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

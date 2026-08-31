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

class LibraryConstants {
  static const pageSize = 20;
  static const searchDebounce = Duration(milliseconds: 300);
}

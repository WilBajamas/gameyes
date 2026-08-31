/// Wraps [term] as a PostgREST `ilike` pattern that matches it literally.
String postgrestLikePattern(String term) {
  // Backslash is what LIKE escapes with, so it has to be doubled first or the
  // escapes added below would themselves be escaped.
  final escaped = term
      .replaceAll(r'\', r'\\')
      .replaceAll('%', r'\%')
      .replaceAll('_', r'\_');

  return '%$escaped%';
}

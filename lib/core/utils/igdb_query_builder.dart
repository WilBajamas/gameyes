class IGDBQueryBuilder {
  final List<String> _fields = [];
  String? _where;
  String? _sort;
  int? _limit;
  int? _offset;
  String? _search;

  /// e.g., ["name", "cover.url"]
  IGDBQueryBuilder fields(List<String> fields) {
    _fields.addAll(fields);
    return this;
  }

  /// e.g., "id = 123" or "platforms = (48, 49)"
  IGDBQueryBuilder where(String condition) {
    _where = condition;
    return this;
  }

  /// e.g., "first_release_date desc"
  IGDBQueryBuilder sort(String field, {bool descending = true}) {
    _sort = '$field ${descending ? 'desc' : 'asc'}';
    return this;
  }

  /// Search for a specific term (Note: search and sort cannot be used together in IGDB)
  IGDBQueryBuilder search(String term) {
    _search = term;
    return this;
  }

  IGDBQueryBuilder limit(int value) {
    _limit = value;
    return this;
  }

  IGDBQueryBuilder offset(int value) {
    _offset = value;
    return this;
  }

  /// Assembles the request body string
  String build() {
    final buffer = StringBuffer();

    // 1. Search (Must be first if present)
    if (_search != null && _search!.isNotEmpty) {
      buffer.write('search "$_search"; ');
    }

    // 2. Concatenate fields
    if (_fields.isNotEmpty) {
      buffer.write('fields ${_fields.join(', ')}; ');
    } else {
      buffer.write('fields *; '); // Default to all if none specified
    }

    // 3. Clauses
    if (_where != null) buffer.write('where $_where; ');

    // IGDB restriction: You cannot sort when using 'search'
    if (_sort != null && _search == null) buffer.write('sort $_sort; ');

    if (_limit != null) buffer.write('limit $_limit; ');
    if (_offset != null) buffer.write('offset $_offset; ');

    return buffer.toString().trim();
  }
}

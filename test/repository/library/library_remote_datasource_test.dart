import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_sort.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/features/library/data/datasources/library_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// A real SupabaseClient talking to a loopback server, per tdd.md's harness:
// no http package is a dependency, and this is the path that needs neither
// a MockClient nor a live database to see the exact request the datasource
// builds.
void main() {
  late HttpServer server;
  late SupabaseClient client;
  late LibraryRemoteDatasource datasource;

  final receivedRequests = <Uri>[];
  late Uri capturedUri;
  Object? capturedBody;

  // What the server hands back. Tests that only care about the request set
  // these before calling the datasource; the default is an empty page.
  var responseRows = <Map<String, dynamic>>[];
  var responseTotal = 0;

  setUp(() async {
    receivedRequests.clear();
    responseRows = [];
    responseTotal = 0;

    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) async {
      receivedRequests.add(request.uri);
      capturedUri = request.uri;

      final bytes = await request.fold<List<int>>(
        <int>[],
        (previous, chunk) => previous..addAll(chunk),
      );
      final rawBody = utf8.decode(bytes);
      capturedBody = rawBody.isEmpty ? null : jsonDecode(rawBody);

      final response = request.response
        ..statusCode = 200
        ..headers.set('content-range', '0-0/$responseTotal');

      if (request.method != 'HEAD') {
        response.headers.contentType = ContentType.json;
        final body = responseRows.length == 1
            ? responseRows.first
            : responseRows;
        response.write(jsonEncode(body));
      }

      await response.close();
    });

    client = SupabaseClient(
      'http://${server.address.address}:${server.port}',
      'test-anon-key',
    );

    await client.auth.setInitialSession(
      jsonEncode({
        'access_token': 'test-access-token',
        'token_type': 'bearer',
        'refresh_token': 'test-refresh-token',
        'expires_in': 3600,
        'user': {'id': 'user-1'},
      }),
    );

    datasource = LibraryRemoteDatasource(client);
  });

  tearDown(() async {
    await client.dispose();
    await server.close(force: true);
  });

  test('should filter by user and sort by created_at descending for a default '
      'paged fetch', () async {
    await datasource.fetchPage(
      sort: LibrarySort.recentlyAdded,
      limit: 20,
      offset: 0,
    );

    expect(capturedUri.path, '/rest/v1/library_entries');
    expect(capturedUri.queryParameters['user_id'], 'eq.user-1');
    expect(capturedUri.queryParameters['order'], 'created_at.desc.nullslast');
    expect(capturedUri.queryParameters.containsKey('status'), isFalse);
    expect(capturedUri.queryParameters.containsKey('title'), isFalse);
  });

  test('should add a status predicate when a status is supplied', () async {
    await datasource.fetchPage(
      status: LibraryStatus.playing,
      sort: LibrarySort.recentlyAdded,
      limit: 20,
      offset: 0,
    );

    expect(capturedUri.queryParameters['status'], 'eq.playing');
  });

  test('should add a case-insensitive title predicate when a search term is '
      'supplied', () async {
    await datasource.fetchPage(
      sort: LibrarySort.recentlyAdded,
      limit: 20,
      offset: 0,
      searchTerm: 'chrono',
    );

    expect(capturedUri.queryParameters['title'], 'ilike.%chrono%');
  });

  test('should keep both predicates when a status and a search term are '
      'supplied', () async {
    await datasource.fetchPage(
      status: LibraryStatus.backlog,
      sort: LibrarySort.recentlyAdded,
      limit: 20,
      offset: 0,
      searchTerm: 'chrono',
    );

    expect(capturedUri.queryParameters['status'], 'eq.backlog');
    expect(capturedUri.queryParameters['title'], 'ilike.%chrono%');
  });

  test(
    'should escape percent, underscore and backslash in the search term',
    () async {
      await datasource.fetchPage(
        sort: LibrarySort.recentlyAdded,
        limit: 20,
        offset: 0,
        searchTerm: r'100%_off\deal',
      );

      // Matches those characters literally: no wildcard survives, and the
      // backslash is doubled first so it does not escape the ones after it.
      expect(capturedUri.queryParameters['title'], r'ilike.%100\%\_off\\deal%');
    },
  );

  test(
    'should keep a comma in the search term inside a single predicate',
    () async {
      await datasource.fetchPage(
        sort: LibrarySort.recentlyAdded,
        limit: 20,
        offset: 0,
        searchTerm: 'chrono, trigger',
      );

      expect(capturedUri.queryParameters['title'], 'ilike.%chrono, trigger%');
    },
  );

  test(
    'should use the expected column and direction for each sort option',
    () async {
      final expected = {
        LibrarySort.recentlyAdded: 'created_at.desc.nullslast',
        LibrarySort.alphabetical: 'title.asc.nullslast',
        LibrarySort.releaseDate: 'release_date.desc.nullslast',
        LibrarySort.rating: 'rating.desc.nullslast',
        LibrarySort.playtime: 'playtime_hours.desc.nullslast',
      };

      for (final entry in expected.entries) {
        await datasource.fetchPage(sort: entry.key, limit: 20, offset: 0);

        expect(capturedUri.queryParameters['order'], entry.value);
      }
    },
  );

  test(
    'should request the second page when a non-zero offset is supplied',
    () async {
      await datasource.fetchPage(
        sort: LibrarySort.recentlyAdded,
        limit: 20,
        offset: 40,
      );

      expect(capturedUri.queryParameters['offset'], '40');
      expect(capturedUri.queryParameters['limit'], '20');
    },
  );

  test('should send the supplied fields on an add', () async {
    responseRows = [
      {
        'id': 'entry-1',
        'user_id': 'user-1',
        'igdb_id': 42,
        'title': 'Chrono Trigger',
        'status': 'playing',
        'cover_url': 'https://example.com/cover.png',
        'created_at': '2026-08-01T00:00:00.000Z',
        'updated_at': '2026-08-01T00:00:00.000Z',
      },
    ];

    await datasource.add(
      igdbId: 42,
      title: 'Chrono Trigger',
      coverUrl: 'https://example.com/cover.png',
      status: LibraryStatus.playing,
    );

    final body = capturedBody as Map<String, dynamic>;
    expect(body['igdb_id'], 42);
    expect(body['title'], 'Chrono Trigger');
    expect(body['status'], 'playing');
    expect(body['cover_url'], 'https://example.com/cover.png');
  });

  test('should omit unsupplied fields on a partial update', () async {
    responseRows = [
      {
        'id': 'entry-1',
        'user_id': 'user-1',
        'igdb_id': 42,
        'title': 'Chrono Trigger',
        'status': 'completed',
        'created_at': '2026-08-01T00:00:00.000Z',
        'updated_at': '2026-08-20T00:00:00.000Z',
      },
    ];

    await datasource.update(igdbId: 42, status: LibraryStatus.completed);

    final body = capturedBody as Map<String, dynamic>;
    expect(body['status'], 'completed');
    expect(body.containsKey('platform'), isFalse);
    expect(body.containsKey('genre'), isFalse);
    expect(body.containsKey('playtime_hours'), isFalse);
    expect(body.containsKey('progress_percent'), isFalse);
    expect(body.containsKey('rating'), isFalse);
  });

  test('should send an explicit null for the rating column when clearRating '
      'is set', () async {
    responseRows = [
      {
        'id': 'entry-1',
        'user_id': 'user-1',
        'igdb_id': 42,
        'title': 'Chrono Trigger',
        'status': 'completed',
        'created_at': '2026-08-01T00:00:00.000Z',
        'updated_at': '2026-08-20T00:00:00.000Z',
      },
    ];

    await datasource.update(igdbId: 42, clearRating: true);

    final body = capturedBody as Map<String, dynamic>;
    expect(body.containsKey('rating'), isTrue);
    expect(body['rating'], isNull);
  });

  test('should omit the rating key when neither a rating nor clearRating is '
      'supplied', () async {
    responseRows = [
      {
        'id': 'entry-1',
        'user_id': 'user-1',
        'igdb_id': 42,
        'title': 'Chrono Trigger',
        'status': 'completed',
        'created_at': '2026-08-01T00:00:00.000Z',
        'updated_at': '2026-08-20T00:00:00.000Z',
      },
    ];

    await datasource.update(igdbId: 42, status: LibraryStatus.completed);

    final body = capturedBody as Map<String, dynamic>;
    expect(body.containsKey('rating'), isFalse);
  });

  test('should request one count per status', () async {
    responseTotal = 3;

    await datasource.fetchCounts();

    expect(receivedRequests.length, LibraryStatus.values.length);

    final requestedStatuses = receivedRequests
        .map((uri) => uri.queryParameters['status'])
        .toSet();
    final expectedStatuses = {
      'eq.playing',
      'eq.backlog',
      'eq.completed',
      'eq.on_hold',
      'eq.wishlist',
      'eq.dropped',
    };

    expect(requestedStatuses, expectedStatuses);
  });
}

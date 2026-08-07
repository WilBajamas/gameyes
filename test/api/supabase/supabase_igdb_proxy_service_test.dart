import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_igdb_proxy_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'supabase_igdb_proxy_service_test.mocks.dart';

@GenerateMocks([HttpClientAdapter])
void main() {
  late MockHttpClientAdapter adapter;
  late SupabaseIgdbProxyService proxy;

  ResponseBody jsonResponseBody(Object? body, int statusCode) =>
      ResponseBody.fromString(
        jsonEncode(body),
        statusCode,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

  setUp(() {
    adapter = MockHttpClientAdapter();
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://test-project.supabase.co/functions/v1',
        contentType: Headers.jsonContentType,
      ),
    )..httpClientAdapter = adapter;
    proxy = SupabaseIgdbProxyService(dio);
  });

  tearDown(() {
    reset(adapter);
  });

  test(
    'should post to the igdb-proxy function url when invoke is called',
    () async {
      when(
        adapter.fetch(any, any, any),
      ).thenAnswer((_) async => jsonResponseBody([], 200));

      await proxy.invoke({'endpoint': 'games', 'query': 'fields name;'});

      final captured =
          verify(adapter.fetch(captureAny, any, any)).captured.single
              as RequestOptions;
      expect(captured.method, 'POST');
      expect(
        captured.uri.toString(),
        'https://test-project.supabase.co/functions/v1/igdb-proxy',
      );
    },
  );

  test('should send only the endpoint and query keys in the body', () async {
    when(
      adapter.fetch(any, any, any),
    ).thenAnswer((_) async => jsonResponseBody([], 200));

    await proxy.invoke({'endpoint': 'games', 'query': 'fields name;'});

    final captured =
        verify(adapter.fetch(captureAny, any, any)).captured.single
            as RequestOptions;
    expect(captured.data, {'endpoint': 'games', 'query': 'fields name;'});
    expect((captured.data as Map).keys, hasLength(2));
  });

  test('should send a json content type', () async {
    when(
      adapter.fetch(any, any, any),
    ).thenAnswer((_) async => jsonResponseBody([], 200));

    await proxy.invoke({'endpoint': 'games', 'query': 'fields name;'});

    final captured =
        verify(adapter.fetch(captureAny, any, any)).captured.single
            as RequestOptions;
    expect(captured.contentType, Headers.jsonContentType);
  });

  test('should not send anything to an igdb host', () async {
    when(
      adapter.fetch(any, any, any),
    ).thenAnswer((_) async => jsonResponseBody([], 200));

    await proxy.invoke({'endpoint': 'games', 'query': 'fields name;'});

    final captured =
        verify(adapter.fetch(captureAny, any, any)).captured.single
            as RequestOptions;
    expect(captured.uri.toString(), isNot(contains('api.igdb.com')));
  });

  test('should return the decoded list when the proxy answers 200', () async {
    final rawBody = [
      {'id': 1, 'name': 'test'},
    ];
    when(
      adapter.fetch(any, any, any),
    ).thenAnswer((_) async => jsonResponseBody(rawBody, 200));

    final result = await proxy.invoke({
      'endpoint': 'games',
      'query': 'fields name;',
    });

    expect(result, isA<List>());
    expect((result as List).first, {'id': 1, 'name': 'test'});
  });

  test(
    'should throw the error with its status when the proxy answers 400',
    () async {
      when(adapter.fetch(any, any, any)).thenAnswer(
        (_) async => jsonResponseBody({'error': 'bad request'}, 400),
      );

      expect(
        () => proxy.invoke({'endpoint': 'games', 'query': 'fields name;'}),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'status',
            400,
          ),
        ),
      );
    },
  );

  test(
    'should throw rather than return null when the proxy answers 502',
    () async {
      when(adapter.fetch(any, any, any)).thenAnswer(
        (_) async =>
            jsonResponseBody({'error': 'Upstream IGDB request failed'}, 502),
      );

      expect(
        () => proxy.invoke({'endpoint': 'games', 'query': 'fields name;'}),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'status',
            502,
          ),
        ),
      );
    },
  );
}

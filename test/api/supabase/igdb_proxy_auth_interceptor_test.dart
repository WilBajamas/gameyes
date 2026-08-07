import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/igdb_proxy_auth_interceptor.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Headers;

import '../../mocks/auth_mock.dart';
import 'igdb_proxy_auth_interceptor_test.mocks.dart';

@GenerateMocks([HttpClientAdapter, GoTrueClient])
void main() {
  late MockHttpClientAdapter adapter;
  late MockGoTrueClient auth;
  late Dio dio;

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
    auth = MockGoTrueClient();
    dio = Dio(BaseOptions(baseUrl: 'https://test-project.supabase.co'))
      ..httpClientAdapter = adapter;
    dio.interceptors.add(
      IgdbProxyAuthInterceptor(auth: auth, anonKey: 'test-anon-key', dio: dio),
    );
  });

  tearDown(() {
    reset(adapter);
    reset(auth);
  });

  Future<Response<Object?>> post() =>
      dio.post<Object?>(SupabaseIgdbProxyConstants.functionPath, data: {});

  test('should send the session token and the anon key when somebody is '
      'signed in', () async {
    when(auth.currentSession).thenReturn(mockDiscordSession);
    when(
      adapter.fetch(any, any, any),
    ).thenAnswer((_) async => jsonResponseBody([], 200));

    await post();

    final captured =
        verify(adapter.fetch(captureAny, any, any)).captured.single
            as RequestOptions;
    expect(
      captured.headers['Authorization'],
      'Bearer ${mockDiscordSession.accessToken}',
    );
    expect(captured.headers['apikey'], 'test-anon-key');
  });

  test(
    'should use the newer token when the session changed between calls',
    () async {
      when(
        adapter.fetch(any, any, any),
      ).thenAnswer((_) async => jsonResponseBody([], 200));

      when(auth.currentSession).thenReturn(mockDiscordSession);
      await post();

      when(auth.currentSession).thenReturn(mockRefreshedDiscordSession);
      await post();

      final captured = verify(
        adapter.fetch(captureAny, any, any),
      ).captured.cast<RequestOptions>();
      expect(
        captured.last.headers['Authorization'],
        'Bearer ${mockRefreshedDiscordSession.accessToken}',
      );
    },
  );

  test('should send the anon key as the bearer token when nobody is signed '
      'in', () async {
    when(auth.currentSession).thenReturn(null);
    when(
      adapter.fetch(any, any, any),
    ).thenAnswer((_) async => jsonResponseBody([], 200));

    await post();

    final captured =
        verify(adapter.fetch(captureAny, any, any)).captured.single
            as RequestOptions;
    expect(captured.headers['Authorization'], 'Bearer test-anon-key');
    expect(captured.headers['apikey'], 'test-anon-key');
  });

  test(
    'should refresh and try again once when the proxy answers 401',
    () async {
      var session = mockDiscordSession;
      when(auth.currentSession).thenAnswer((_) => session);
      when(auth.refreshSession()).thenAnswer((_) async {
        session = mockRefreshedDiscordSession;
        return AuthResponse(session: session);
      });

      var callCount = 0;
      when(adapter.fetch(any, any, any)).thenAnswer((_) async {
        callCount++;
        return callCount == 1
            ? jsonResponseBody({'error': 'unauthorized'}, 401)
            : jsonResponseBody([], 200);
      });

      final response = await post();

      expect(response.statusCode, 200);
      verify(auth.refreshSession()).called(1);

      final captured = verify(
        adapter.fetch(captureAny, any, any),
      ).captured.cast<RequestOptions>();
      expect(
        captured.last.headers['Authorization'],
        'Bearer ${mockRefreshedDiscordSession.accessToken}',
      );
    },
  );

  test('should make exactly two requests when the second answer is also '
      '401', () async {
    when(auth.currentSession).thenReturn(mockDiscordSession);
    when(auth.refreshSession()).thenAnswer(
      (_) async => AuthResponse(session: mockRefreshedDiscordSession),
    );
    when(
      adapter.fetch(any, any, any),
    ).thenAnswer((_) async => jsonResponseBody({'error': 'unauthorized'}, 401));

    await expectLater(
      post(),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          401,
        ),
      ),
    );

    verify(adapter.fetch(any, any, any)).called(2);
    verify(auth.refreshSession()).called(1);
  });

  test('should surface the original 401 when the refresh throws', () async {
    when(auth.currentSession).thenReturn(mockDiscordSession);
    when(
      auth.refreshSession(),
    ).thenThrow(const AuthException('refresh failed'));
    when(
      adapter.fetch(any, any, any),
    ).thenAnswer((_) async => jsonResponseBody({'error': 'unauthorized'}, 401));

    await expectLater(
      post(),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          401,
        ),
      ),
    );

    verify(adapter.fetch(any, any, any)).called(1);
  });

  test('should surface the original 401 when the refresh returns no '
      'session', () async {
    when(auth.currentSession).thenReturn(mockDiscordSession);
    when(auth.refreshSession()).thenAnswer((_) async => AuthResponse());
    when(
      adapter.fetch(any, any, any),
    ).thenAnswer((_) async => jsonResponseBody({'error': 'unauthorized'}, 401));

    await expectLater(
      post(),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          401,
        ),
      ),
    );

    verify(adapter.fetch(any, any, any)).called(1);
  });

  test('should not try again when the proxy answers 502', () async {
    when(auth.currentSession).thenReturn(mockDiscordSession);
    when(
      adapter.fetch(any, any, any),
    ).thenAnswer((_) async => jsonResponseBody({'error': 'bad gateway'}, 502));

    await expectLater(
      post(),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          502,
        ),
      ),
    );

    verify(adapter.fetch(any, any, any)).called(1);
    verifyNever(auth.refreshSession());
  });

  test(
    'should not try again when the request fails without a response',
    () async {
      when(auth.currentSession).thenReturn(mockDiscordSession);
      when(
        adapter.fetch(any, any, any),
      ).thenThrow(const SocketExceptionStandIn());

      await expectLater(post(), throwsA(isA<DioException>()));

      verify(adapter.fetch(any, any, any)).called(1);
      verifyNever(auth.refreshSession());
    },
  );
}

// A minimal stand-in for a connection-level failure, so the adapter can throw
// something that is not itself a DioException - Dio wraps it into one with
// no response attached, which is the shape a real network failure takes.
class SocketExceptionStandIn implements Exception {
  const SocketExceptionStandIn();
}

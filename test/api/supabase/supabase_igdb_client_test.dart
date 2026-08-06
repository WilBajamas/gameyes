import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_igdb_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_igdb_client_test.mocks.dart';

@GenerateMocks([SupabaseClient, FunctionsClient])
void main() {
  late MockSupabaseClient supabaseClient;
  late MockFunctionsClient functionsClient;
  late SupabaseIgdbClient igdbClient;

  setUp(() {
    supabaseClient = MockSupabaseClient();
    functionsClient = MockFunctionsClient();
    when(supabaseClient.functions).thenReturn(functionsClient);

    igdbClient = SupabaseIgdbClient(supabaseClient);
  });

  tearDown(() {
    reset(functionsClient);
  });

  test('should invoke the igdb-proxy function with the endpoint and query in '
      'the body', () async {
    when(
      functionsClient.invoke(
        IgdbProxyConstants.functionName,
        body: {'endpoint': 'games', 'query': 'fields name;'},
      ),
    ).thenAnswer((_) async => const FunctionResponse(data: [], status: 200));

    await igdbClient.invoke(endpoint: 'games', query: 'fields name;');

    verify(
      functionsClient.invoke(
        IgdbProxyConstants.functionName,
        body: {'endpoint': 'games', 'query': 'fields name;'},
      ),
    );
  });

  test('should return the function response data untouched', () async {
    final rawBody = [
      {'id': 1, 'name': 'test'},
    ];

    when(
      functionsClient.invoke(
        IgdbProxyConstants.functionName,
        body: anyNamed('body'),
      ),
    ).thenAnswer((_) async => FunctionResponse(data: rawBody, status: 200));

    final result = await igdbClient.invoke(
      endpoint: 'games',
      query: 'fields name;',
    );

    expect(result, same(rawBody));
  });

  testWidgets('should fail rather than hang when the function does not answer '
      'within 30 seconds', (tester) async {
    when(
      functionsClient.invoke(
        IgdbProxyConstants.functionName,
        body: anyNamed('body'),
      ),
    ).thenAnswer((_) => Completer<FunctionResponse>().future);

    final future = igdbClient.invoke(endpoint: 'games', query: 'fields name;');
    final matcher = expectLater(future, throwsA(isA<TimeoutException>()));

    await tester.pump(const Duration(seconds: 31));
    await matcher;
  });
}

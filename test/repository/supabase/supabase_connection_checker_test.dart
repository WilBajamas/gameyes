import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor_config.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_connection_checker.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_ping.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'supabase_connection_checker_test.mocks.dart';

@GenerateMocks([SupabasePing])
void main() {
  late SupabasePing ping;
  late SupabaseConnectionChecker connectionChecker;

  setUp(() {
    FlavorConfig.initialise(Flavor.dev);
    ping = MockSupabasePing();
    connectionChecker = SupabaseConnectionChecker(ping);
  });

  tearDown(() {
    reset(ping);
  });

  test('should return reachable when the ping completes normally', () async {
    when(ping.ping()).thenAnswer((_) async {});

    final result = await connectionChecker.check();

    expect(result, SupabaseConnectionStatus.reachable);
    verify(ping.ping());
  });

  test('should return unreachable when the ping throws', () async {
    when(ping.ping()).thenAnswer((_) async => throw Exception('boom'));

    final result = await connectionChecker.check();

    expect(result, SupabaseConnectionStatus.unreachable);
    verify(ping.ping());
  });

  testWidgets('should return unreachable when the ping never completes', (
    tester,
  ) async {
    when(ping.ping()).thenAnswer((_) => Completer<void>().future);

    final future = connectionChecker.check();
    await tester.pump(const Duration(seconds: 11));

    expect(await future, SupabaseConnectionStatus.unreachable);
    verify(ping.ping());
  });
}

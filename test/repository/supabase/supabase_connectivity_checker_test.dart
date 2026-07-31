import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor_config.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/i_supabase_health_probe.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_connectivity_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'supabase_connectivity_checker_test.mocks.dart';

@GenerateMocks([ISupabaseHealthProbe])
void main() {
  late ISupabaseHealthProbe healthProbe;
  late SupabaseConnectivityChecker connectivityChecker;

  setUp(() {
    FlavorConfig.initialise(Flavor.dev);
    healthProbe = MockISupabaseHealthProbe();
    connectivityChecker = SupabaseConnectivityChecker(healthProbe);
  });

  tearDown(() {
    reset(healthProbe);
  });

  test('should return reachable when the probe completes normally', () async {
    when(healthProbe.ping()).thenAnswer((_) async {});

    final result = await connectivityChecker.check();

    expect(result, SupabaseConnectivityStatus.reachable);
    verify(healthProbe.ping());
  });

  test('should return unreachable when the probe throws', () async {
    when(healthProbe.ping()).thenAnswer((_) async => throw Exception('boom'));

    final result = await connectivityChecker.check();

    expect(result, SupabaseConnectivityStatus.unreachable);
    verify(healthProbe.ping());
  });

  testWidgets('should return unreachable when the probe never completes', (
    tester,
  ) async {
    when(healthProbe.ping()).thenAnswer((_) => Completer<void>().future);

    final future = connectivityChecker.check();
    await tester.pump(const Duration(seconds: 11));

    expect(await future, SupabaseConnectivityStatus.unreachable);
    verify(healthProbe.ping());
  });
}

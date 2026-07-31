import 'package:flutter/foundation.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor_config.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_ping.dart';
import 'package:injectable/injectable.dart';

enum SupabaseConnectionStatus { reachable, unreachable }

// Runs the startup check: ask Supabase if it's there. Never crashes the app
// if it failed.
@injectable
class SupabaseConnectionChecker {
  const SupabaseConnectionChecker(this._ping);

  final SupabasePing _ping;

  Future<SupabaseConnectionStatus> check() async {
    final flavor = FlavorConfig.instance.flavor;

    try {
      await _ping.ping().timeout(SupabaseConstants.connectionTimeout);
      debugPrint('Supabase connectivity check [${flavor.name}]: reachable');
      return SupabaseConnectionStatus.reachable;
    } catch (error) {
      debugPrint(
        'Supabase connectivity check [${flavor.name}]: unreachable '
        '(${error.runtimeType})',
      );
      return SupabaseConnectionStatus.unreachable;
    }
  }
}

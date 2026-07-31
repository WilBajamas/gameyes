import 'package:flutter/foundation.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor_config.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/i_supabase_health_probe.dart';
import 'package:injectable/injectable.dart';

/// Outcome of the startup connectivity check.
enum SupabaseConnectivityStatus { reachable, unreachable }

/// Decides and reports whether the configured Supabase project responded.
///
/// Owns the timeout policy, the error containment, the logging and the result
/// mapping. It never throws and never returns anything but the two enum values.
@injectable
class SupabaseConnectivityChecker {
  const SupabaseConnectivityChecker(this._probe);

  final ISupabaseHealthProbe _probe;

  Future<SupabaseConnectivityStatus> check() async {
    final flavor = FlavorConfig.instance.flavor;

    try {
      await _probe.ping().timeout(SupabaseConstants.connectivityTimeout);
      debugPrint('Supabase connectivity check [${flavor.name}]: reachable');
      return SupabaseConnectivityStatus.reachable;
    } catch (error) {
      debugPrint(
        'Supabase connectivity check [${flavor.name}]: unreachable '
        '(${error.runtimeType})',
      );
      return SupabaseConnectivityStatus.unreachable;
    }
  }
}

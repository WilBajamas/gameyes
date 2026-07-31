import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/i_supabase_health_probe.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Performs one PostgREST round-trip through the injected [SupabaseClient].
///
/// The probe deliberately does not require [SupabaseConstants.connectivityProbePath]
/// to exist: a [PostgrestException] means the project's PostgREST answered, which
/// is exactly what the check asks. Every other error propagates to the caller.
@Injectable(as: ISupabaseHealthProbe)
class SupabaseHealthProbe implements ISupabaseHealthProbe {
  const SupabaseHealthProbe(this._client);

  final SupabaseClient _client;

  @override
  Future<void> ping() async {
    try {
      await _client
          .from(SupabaseConstants.connectivityProbePath)
          .select()
          .limit(1);
    } on PostgrestException {
      return;
    }
  }
}

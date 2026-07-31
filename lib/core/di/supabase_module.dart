import 'package:gaming_library_assessment_flutter/config/flavor/flavor_config.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The only place in `lib/` allowed to touch the Supabase SDK's initialisation
/// API or its global instance accessor. Every consumer receives the resulting
/// [SupabaseClient] by constructor injection.
@module
abstract class SupabaseModule {
  @preResolve
  Future<SupabaseClient> get supabaseClient async {
    final config = FlavorConfig.instance;
    final supabase = await Supabase.initialize(
      url: config.supabaseUrl,
      publishableKey: config.supabaseAnonKey,
    );
    return supabase.client;
  }
}

import 'package:gaming_library_assessment_flutter/config/flavor/flavor_config.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// This is the only file that starts up Supabase. Every other part of the app
// just borrows this same connection instead of starting its own.
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

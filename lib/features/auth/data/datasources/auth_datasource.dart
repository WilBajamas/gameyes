import 'package:gaming_library_assessment_flutter/config/flavor/flavor_config.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// A thin wrapper around the Supabase sign-in calls. It exists so tests can
// stand in for Supabase without opening a browser or reaching the network.
@injectable
class AuthDatasource {
  const AuthDatasource(this._client);

  final SupabaseClient _client;

  Future<bool> signInWithOAuth(OAuthProvider provider) =>
      _client.auth.signInWithOAuth(
        provider,
        redirectTo: FlavorConfig.instance.authRedirectUrl,
        // Both providers otherwise sign back into whatever account is already
        // active on the device without ever showing a picker.
        queryParams: switch (provider) {
          OAuthProvider.google => const {'prompt': 'select_account'},
          OAuthProvider.discord => const {'prompt': 'consent'},
          _ => null,
        },
      );

  Future<void> signOut() => _client.auth.signOut();

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Session? get currentSession => _client.auth.currentSession;
}

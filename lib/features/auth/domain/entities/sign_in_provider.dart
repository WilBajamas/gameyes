enum SignInProvider {
  discord,
  google;

  /// Returns [SignInProvider] based on Supabase returned string name
  static SignInProvider? fromName(String? name) {
    for (final provider in SignInProvider.values) {
      if (provider.name == name) {
        return provider;
      }
    }
    return null;
  }
}

enum SignInProvider {
  discord,
  google;

  // Supabase tells us which service signed the person in as a plain word.
  // This turns that word back into one of our own values, or nothing at all
  // when the word is missing or is a service this app does not offer.
  static SignInProvider? fromName(String? name) {
    for (final provider in SignInProvider.values) {
      if (provider.name == name) {
        return provider;
      }
    }
    return null;
  }
}

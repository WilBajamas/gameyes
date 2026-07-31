/// Contract for a single unauthenticated round-trip against the configured
/// Supabase project.
///
/// Completes normally when the configured project answered at the HTTP level.
/// Throws when it did not — transport failure, DNS failure, connection refused
/// or socket error. It does not apply a timeout, log, or interpret the result
/// any further than "answered" versus "did not answer".
abstract interface class ISupabaseHealthProbe {
  Future<void> ping();
}

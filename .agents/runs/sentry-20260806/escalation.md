# Escalation
Agent: BA Agent
Run: sentry-20260806
Opened: 2026-08-06T00:00:00Z
Phase: Phase 1 (BA re-run — added requirement, appended to the parked Phase 3 gate)
Reason: The added requirement's two instructions contradict each other. Removing
`pretty_dio_logger: ^1.4.0` from `pubspec.yaml` was premised on "nothing else
references it". The grep shows a second reference outside `network_module.dart`:
`lib/core/services/api/twitch_auth_interceptor.dart` imports the package and
registers `PrettyDioLogger` on its private `_tokenDio` in the constructor (lines
3 and 27-32). `TwitchAuthInterceptor` was named as a thing that "stays exactly
as-is", and the requirement says this is not a broader dead-code cleanup. So the
package cannot be removed without editing a file the requirement protects, and
cannot be kept without dropping a stated requirement. Removing it from
`pubspec.yaml` alone leaves an unresolved import and a new analyzer error against
the run baseline.
Route to: Human
Action required: Pick one, reply with A or B.

  Option A — Also strip `PrettyDioLogger` from
  `lib/core/services/api/twitch_auth_interceptor.dart` (its import plus the
  `_tokenDio.interceptors.add(PrettyDioLogger(...))` block in the constructor),
  then remove the package from `pubspec.yaml`. Nothing else in that file changes;
  it stays `@Deprecated` and unused. This is the only option that satisfies
  "remove the dependency" and leaves the tree compiling.

  Option B — Keep `pretty_dio_logger: ^1.4.0` in `pubspec.yaml`. Only the
  `network_module.dart` registration and import are deleted; the file allowlist
  stays at one file.

  Recommended: A. Both usages are the same one logger interceptor, both live in
  `@Deprecated` reference-only code that the app does not run, and A is the only
  option where the package actually leaves the project.

Notes for whichever option is chosen:
- `pubspec.lock` records `pretty_dio_logger` as `direct main` only; no other
  package pulls it in, so under A it leaves the lock entirely.
- `.agents/references/flutter-arch.md` (lines 170, 181) documents
  `PrettyDioLogger` as part of the Dio setup. Under A it becomes stale. Confirm
  whether the reference doc is in scope for this run or left for a later pass.

Not blocked by this: the `talker` request/response/error logging requirement for
`SupabaseIgdbClient.invoke` has no open ambiguity. Its criteria (10.15 onward)
are ready to append the moment A or B is chosen — per the BA rules no criterion
is written to `tech-ac.md` while a CRITICAL is open, so the existing 10.1-10.14
file is untouched.

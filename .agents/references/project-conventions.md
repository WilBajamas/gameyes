# project-conventions.md — Gameyes Project Conventions Reference
Project: gaming_library_assessment_flutter
Last updated: 2026-08-04

---

## State and widget patterns

BLoC/Cubit provisioning, status-driven rendering, pagination, and
pull-to-refresh moved to the `flutter-state` skill. Loading shimmer,
error + retry, network image, hero transition, snackbar, and empty state
patterns moved to the `flutter-widgets` skill.

---

## IGDB query building

Query construction (`IGDBQueryBuilder`, the search/sort constraint, the standard
field set) is documented once in `api-contracts.md § Query building` — read
that, not a restatement here.

---

## Isar local storage patterns & SharedPreferences

Moved to the `flutter-datasource` skill.

---

## Widget catalogue, placement, and how to build a new one

Moved to the `flutter-widgets` skill in full — the catalogue table, ownership/
extraction/route-composition rules, and the widget-building rules written
2026-08-07 for the component-library push.

---

## System bars and SafeArea

Moved to the `flutter-widgets` skill.

---

## Comments — plain English only

Comments explain the *why*, in plain words a non-technical person could follow.
No jargon, no restating what the code already says, no framework/pattern names
unless truly unavoidable.

Bad:  "Performs one PostgREST round-trip through the injected SupabaseClient."
Good: "Send one small request to Supabase just to check if it answers."

Only comment where the reason isn't obvious from reading the code. If a comment
just repeats the method or variable name in sentence form, delete it instead.

Refrain from obvious comments. An enum with self-explanatory values, or a class
whose method names already say what it does, needs no comment at all —
developers can read the implementation just fine. Comment the *why* behind a
non-obvious decision, not a running narration of *what* the code does.

Widget-tree comments are useful when they preserve a layout invariant that the
types do not reveal — for example, why the hero shrinks before the bottom-anchored
copy, or why one element alone owns a shadow. Keep that rationale once, next to the
owning composition. Do not repeat it above the class, constructor, and build method.

This includes dartdoc on constructor fields. A `///` line on every parameter that
just restates its name is still a repeated-name comment, one per field instead of
one for the whole class — delete those too.

Bad:
```dart
/// Art shown whole and centred, scaled down to fit rather than cropped.
final String contentAsset;

/// Flat fill behind the content.
final Color? backgroundColor;
```
Good — the names already say this; a one-line class comment covers anything that
isn't obvious, if anything is:
```dart
/// Rounded panel at the top of a welcome screen.
class WelcomeHero extends StatelessWidget {
  final String contentAsset;
  final Color? backgroundColor;
```

## Naming — simple English only

Class, variable, constant and string names must read as plain English words a
non-technical person would use — no jargon, no invented compound terms, no
placeholder-looking values.

Bad:  `__gameyes_connectivity_probe__`, `ISupabaseHealthProbe`
Good: `connectionPath`, `SupabasePing`

---

## Platform target — Android only (as of 2026-07-30)

**v1 ships Android only. iOS is deferred.** The developer works on Windows and has
no Mac and no iPhone, so iOS builds cannot be produced, run, or verified — Flutter's
iOS toolchain requires Xcode, which is macOS-only.

**Consequences for agents:**

- **Never write an acceptance criterion that requires iOS verification.** "Behaves
  identically on iOS and Android" and similar cannot be checked by anyone on this
  project and will sit unverified on a manual checklist forever. Write the criterion
  against Android alone.
- Do not propose iOS-only packages, capabilities, or platform channels.
- iOS project files may still be configured where it is free to do so (bundle IDs,
  flavour scaffolding) so the work is not repeated later — but **never claim it is
  verified**, and never gate a criterion on it.
- Sign in with Apple is **not** required. App Store Review Guideline 4.8 is an
  App Store rule with no Play Store equivalent. It returns when iOS does.

This is a resourcing constraint, not a product decision. It reverses the moment a
Mac is available — see `roadmap-deferred.md`.

---

## Key constraints for all agents

- Always check the widget catalogue in the `flutter-widgets` skill before
  creating a new widget
- Extract presentation components according to ownership and cohesion, not caller
  count alone
- Keep reactive state boundaries as low as possible in the widget tree
- Avoid passthrough screen, view, and route classes
- Use `lib/widgets/` for explicitly app-wide primitives with required generic inputs
- Never use Widget-returning helper functions or getters; extracted UI composition
  is a `StatelessWidget` or `StatefulWidget`
- Do not add generic wrappers, nullable future hooks, or one-use constants without
  a current requirement
- Always use `IGDBQueryBuilder` for IGDB API queries — never build query strings manually
- Always use `GameLocalStorageService` for Isar operations — never access `Isar` directly
- Inject `SharedPreferences` directly — there is no wrapper, and `StorageModule`
  is the only place `getInstance()` is called
- Always use `DefaultCachedNetworkImage` for remote images — never `Image.network`
- Pagination state uses two enums — never collapse them into one status
- Pull-to-refresh only shown when `status == success`


## Provisional UI — the Settings sign-out control (2026-08-05)

`lib/features/settings/presentation/widgets/sign_out_section.dart` is **test
scaffolding that stayed**. It exists because four of week 1 item 8's manual
checks could not be run without a sign-out trigger, and the app needs a sign-out
before beta regardless — so it was built properly rather than hacked in.

**Its visual design is not official.** It borrows the sign-in provider row's
anatomy for want of any Settings design spec. Do not treat it as the pattern for
future Settings rows, and do not cite it as precedent. Placement, wording, a
possible confirmation step, and grouping under an account section are all open —
see `roadmap-deferred.md`.

The behaviour, by contrast, is settled and should be preserved: the tap performs
no navigation. The auth guard and `AuthStatusListener` from item 8 move the user;
adding navigation here would race that mechanism.

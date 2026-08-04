# Shared execution rules

Read this file when a pipeline phase starts.

## Communication

Per the project's root `CLAUDE.md`: be token-saving, not a wall of text.

- Progress commentary is one short sentence — phase, result, or next gate.
- Do not narrate routine tool calls, waits, or diagnostics.
- Full detail is earned: give it only for an escalation the human must decide on,
  or when they explicitly ask.

## Scope

- The task brief's file allowlist is the source-write boundary. Nothing outside it,
  with two standing exceptions: `pubspec.yaml` (read-only, to check package
  availability) and generated outputs whose annotated source is allowlisted.
- Preserve unrelated and pre-existing changes — never revert something you didn't
  cause just because it's in the diff.
- Only unit and widget tests exist in this project. **Never a golden test** — no
  `matchesGoldenFile`, whatever a criterion says about pixel appearance. That's
  QA's manual check, not a test.

## Baselines

`orchestrator-state.md` records `Analyzer baseline`, `Test baseline`, and
`Pre-existing test failures` at Phase 0. This project carries pre-existing
analyzer warnings and pre-existing test failures — "all tests must pass" and "the
analyzer must be clean" are both false here. Compare new results against the
recorded baseline; only a new, in-scope failure is yours to fix or escalate.

## Self-correction

On a new in-scope `flutter analyze` error, `flutter test` failure, or unmet
criterion:

1. Identify the exact root cause — trace it, don't guess.
2. Apply the minimal fix, inside the allowlist, without weakening a test to make
   it pass.
3. Re-run the check. This is one attempt.

**Budget: 3 attempts per failure point**, reset per new failure, not per file. On
the 3rd failed attempt: escalate per `escalation.md`, do not attempt a 4th fix.

## Code quality

- **Comments — plain English, explain the why, and few of them.** No jargon, no
  restating what the code already says, no framework/pattern names unless
  unavoidable. An enum with self-explanatory values or a method whose name
  already says what it does needs no comment. This applies per-field, not just
  per-class or per-method: a `///` doc comment on every constructor parameter
  that just restates its name (`/// Flat fill behind the content.` above
  `final Color? backgroundColor;`) is a wall of comments, not documentation —
  delete it. Comment the one thing that isn't obvious from the code, once,
  next to where it matters; don't narrate the rest.
- **Naming — plain English words.** No invented compound jargon, no
  placeholder-looking values.
- **Constants — place near their scope.** A constant several features need
  belongs in the shared `lib/core/res/const.dart`. A constant only one feature
  needs belongs in that feature's own `const.dart` at its root — see
  `flutter-arch.md`'s folder structure — not wedged into whichever widget file
  happens to use it first.
- **Prefer a concrete class over a single-implementation interface.** Only
  introduce an `abstract class` when a second implementation is actually planned
  — Mockito mocks concrete classes fine as long as they aren't
  `final`/`sealed`/`base`. Does not apply to a repository interface the design
  explicitly places in the domain layer opposite a data-layer implementation —
  that split is architectural.

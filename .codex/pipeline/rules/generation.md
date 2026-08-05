# Flutter code generation

Read this file when the allowlist contains annotated sources, generated outputs,
Mockito tests, routing, DI, or localization changes.

## Build runner

Run `fvm dart run build_runner build --delete-conflicting-outputs` after each
contiguous annotated-source group and after all Mockito test annotations.

Generated outputs include:

| Source annotation | Output |
|---|---|
| Freezed, JSON, Retrofit, Isar, Envied | `*.freezed.dart`, `*.g.dart` |
| Injectable | `*.config.dart` |
| AutoRoute | `*.gr.dart` |
| Mockito | `*.mocks.dart` |

- Never hand-edit or bulk-rewrite generated files.
- Exclude generated files and `lib/generated/` from rename passes; rename source,
  regenerate, then analyze warnings as well as errors.
- Treat missing outputs before generation as expected, not a correction attempt.

## Localization

- Edit every supported ARB locale.
- Do not run `fvm flutter gen-l10n` or edit `lib/generated/`.
- Record Flutter Intl IDE regeneration as a manual prerequisite/deviation.
- Escalate if compilation must remain blocked; do not invent accessors.

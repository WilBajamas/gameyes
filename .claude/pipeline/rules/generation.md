# Flutter code generation

Read this file when the allowlist contains annotated sources, generated outputs,
Mockito tests, routing, DI, or localisation changes.

## Build runner

Run `dart run build_runner build --delete-conflicting-outputs` after each
contiguous group of annotated sources — not after every single file. At minimum:

1. After all model/entity/DTO changes, before anything imports them
2. After all `@injectable` classes exist, to wire the DI graph
3. After routing changes, to regenerate routes
4. After test files using `@GenerateMocks` are written, before running any test

| Annotation / package | Output |
|---|---|
| `freezed` | `*.freezed.dart` |
| `json_serializable`, `retrofit`, `isar_community`, `envied` | `*.g.dart` |
| `injectable` | `*.config.dart` |
| `auto_route` | `*.gr.dart` |
| `mockito` (`@GenerateMocks`, test files too) | `*.mocks.dart` |

An annotated file that doesn't analyze clean before its generator has run is
expected state, not a failure — never count it against the self-correction budget.

**Generated files are never hand-written.** Fix the annotated source and
regenerate; a wrong generated file means its source annotation is wrong.

## Bulk renames

Exclude every generated file and `lib/generated/` from a find-and-replace pass.
Rename sources only, then regenerate. A rename inside a generated lookup table
can produce a duplicate map key — valid Dart, compiles fine, and the later entry
silently wins, so check `flutter analyze` **warnings**, not just errors, after any
rename. If a generated file you can't regenerate was touched, restore it with
`git checkout -- <path>` rather than repairing it by hand.

## Localisation

The `S` class (`lib/generated/l10n.dart`, `messages_*.dart`) comes from the
**Flutter Intl IDE plugin** — no CLI, and `flutter gen-l10n` belongs to a
different, removed system. Never run it.

When a step adds a user-facing string:
1. Add the key to **both** `lib/l10n/intl_en.arb` and `intl_zh.arb`.
2. Use `S.current.[key]` in code as normal.
3. Expect it not to compile until a human runs the IDE regeneration.
4. Record it under `diff-summary.md ## Deviations from implementation plan` as
   needing a manual IDE pass. Don't hand-write the accessor, and don't burn
   self-correction attempts on it.

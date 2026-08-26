# dart-style.md — Gameyes Dart Coding Style Reference
Project: gaming_library_assessment_flutter
Last updated: 2026-08-04

---

## Enforced lint rules (analysis_options.yaml)

The project extends `package:flutter_lints/flutter.yaml` with these 17 additions.

Excluded from analysis: `lib/**.g.dart` and `lib/**.freezed.dart`.
**`.gr.dart` and `.config.dart` are still analysed** — they are generated too, so
issues reported in them are not yours to fix.

| Rule | Meaning |
|---|---|
| `prefer_single_quotes` | Always `'string'`, never `"string"` |
| `require_trailing_commas` | Multi-line argument lists must have a trailing comma |
| `lines_longer_than_80_chars` | Hard limit — use `// ignore: lines_longer_than_80_chars` only when unavoidable (e.g. long strings) |
| `avoid_empty_else` | No empty else blocks |
| `prefer_null_aware_operators` | Use `?.`, `??`, `??=` over null checks where possible |
| `prefer_if_elements_to_conditional_expressions` | In collection literals use `if (x) a else b`, not `x ? a : b` |
| `prefer_foreach` | Use `.forEach` where a for-loop only forwards each element to one call |
| `avoid_unnecessary_containers` | Do not wrap widgets in `Container` when a simpler widget suffices |
| `await_only_futures` | Do not `await` a non-Future |
| `avoid_redundant_argument_values` | Do not pass arguments that equal the default value |
| `avoid_renaming_method_parameters` | An override keeps the parameter names of the method it overrides |
| `avoid_returning_null_for_void` | Never `return null` from a `void`/`Future<void>` |
| `camel_case_extensions` | All extensions: `UpperCamelCase` |
| `camel_case_types` | All classes, enums, typedefs: `UpperCamelCase` |
| `no_default_cases` | Do not use `default:` in exhaustive switches on sealed classes or enums — handle every case explicitly |
| `no_duplicate_case_values` | No two `case` clauses with the same value |
| `prefer_function_declarations_over_variables` | Use named function declarations rather than assigning lambdas to variables |

---

## File naming

All files: `snake_case.dart`

| Type | Pattern | Example |
|---|---|---|
| BLoC | `[feature]_bloc.dart` | `games_bloc.dart` |
| BLoC event | `[feature]_event.dart` | `games_event.dart` |
| BLoC/Cubit state | `[feature]_state.dart` | `games_state.dart` |
| Cubit | `[feature]_cubit.dart` | `tracker_cubit.dart` |
| Screen | `[feature]_screen.dart` | `tracker_screen.dart` |
| Widget (global) | `[descriptor]_widget.dart` or plain `[descriptor].dart` | `status_chip.dart`, `default_snackbar.dart` |
| Repository interface | `[feature]_repository.dart` | `games_repository.dart` |
| Repository impl | `[feature]_repository_impl.dart` | `games_repository_impl.dart` |
| DataSource | `[feature]_datasource.dart` | `games_datasource.dart` |
| Use case | `[action]_[feature]_use_case.dart` | `fetch_games_use_case.dart` |
| Retrofit service | `[name]_service.dart` | `igdb_api_service.dart` |
| DTO model | `[entity_name].dart` | `game.dart`, `game_cover.dart` |
| Domain entity | `[entity_name]_entity.dart` | `game_entity.dart` |
| Enum | `[enum_name].dart` | `game_genre.dart` |
| Constants | `const.dart` (project-wide, in `core/res/`) | — |
| Extensions | `extensions.dart` (project-wide, in `core/utils/`) | — |

Generated companion files follow the same base name:
- `[name].freezed.dart` — freezed output
- `[name].g.dart` — json_serializable / retrofit / envied output
- `[name].gr.dart` — auto_route output

Never create files named `utils.dart`, `helpers.dart`, or `common.dart` — use specific descriptive names.

---

## Class naming

### BLoC / Cubit, Events, State

Moved to the `flutter-state` skill.

### Repository interface & implementation

Moved to the `flutter-repository` skill.

### DataSource

Moved to the `flutter-datasource` skill.

### Use cases

Moved to the `flutter-usecase` skill.

### Retrofit services
- `abstract class [Name]Service` — singular. The two that exist are
  `IgdbApiService` and `GameDetailService`.
- Annotated `@RestApi(baseUrl: ConfigConstants.igdbBaseUrl)`
- Factory: `factory [Name]Service(Dio dio) = _[Name]Service;`
- Named for the API it talks to, not the feature that owns the folder —
  `IgdbApiService` is shared across features despite living under
  `features/games/services/`

### DTO models

Moved to the `flutter-dto` skill.

### Domain entities

Moved to the `flutter-usecase` skill.

### Enums
- `enum [EnumName]` in `UpperCamelCase`
- Values in `lowerCamelCase`
- May implement interfaces (e.g. `EnumSelection`) for shared UI behaviour
- May carry named parameters (constructor fields): `action(id: 4, slug: 'action', name: 'Action')`

### Constants
- Grouped by concern in static-only classes: `ConfigConstants`, `PathConstants`,
  `AssetConstants`, `StorageConstants`, `StringConstants`, `RouteConstants`, `IGDBConfig`
- All members: `static const`
- No bare top-level constants outside these classes

### Extensions
- Named `[Subject]Extension` or `[Subject]Extensions` (project uses both)
- Grouped by type extended: one extension per file section
- All in `lib/core/utils/extensions.dart` — do not create new extension files

### Screens & presentation component placement

Moved to the `flutter-widgets` skill.

---

## Import ordering

Follow the Dart/Flutter convention — three groups separated by blank lines,
each group sorted alphabetically:

```dart
// 1. Dart SDK
import 'dart:async';

// 2. Package imports (flutter first, then third-party, then project)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/...';

// 3. Relative imports (only for part files or very close siblings)
import '../../../../generated/l10n.dart';
```

Prefer package imports (`package:gaming_library_assessment_flutter/...`) over
relative imports except for `part`/`part of` declarations and `generated/l10n.dart`.

---

## const usage

- Use `const` wherever the linter permits — widget constructors, values, lists
- Widget constructors that accept no mutable data must be `const`
- `EdgeInsets`, `TextStyle`, `Color`, `Duration` literals should always be `const`
- `@Default(...)` values in freezed states must be compile-time constants

---

## Switch expressions on sealed classes

Use `switch` expressions (not statements) when all branches return a value.
Handle every variant explicitly — no `default:` on sealed types or enums.

```dart
// Correct: exhaustive switch expression on Result
final newState = switch (result) {
  Success(value: final response) => state.copyWith(
      status: GamesStatus.success,
      games: response.items,
    ),
  Failure(error: final error) => state.copyWith(
      status: GamesStatus.failed,
      error: error,
    ),
};
```

---

## Localisation

All user-facing strings must use the generated `S.current.[key]` accessor.
Do not hardcode user-facing strings in widget code.
String keys use `snake_case`.

Import: the codebase uses both relative (`import '../../../../generated/l10n.dart';`)
and package (`import 'package:gaming_library_assessment_flutter/generated/l10n.dart';`)
forms. Relative is the majority. Match the file you are editing rather than
converting it.

**Adding a new string** means adding the key to **both** `lib/l10n/intl_en.arb`
and `lib/l10n/intl_zh.arb`. The `S` accessor is generated by the Flutter Intl IDE
plugin, not by `build_runner` and not by `flutter gen-l10n` — see
`flutter-arch.md § Localisation`. Code using a brand-new key will not compile
until that regen happens.

---

## Theme access

Use the `ContextExtensions` (from `lib/core/utils/extensions.dart`):
```dart
context.themeData               // ThemeData
context.themeData.colorScheme   // ColorScheme
context.themeData.textTheme     // TextTheme
context.screenWidth / context.screenHeight
```
Do not call `Theme.of(context)` directly — always use `context.themeData`.

---

## BLoC/Cubit access in widgets

Moved to the `flutter-state` skill.

---

## What NOT to do

- Do not use `dynamic` — always specify types
- Do not use `var` for class-level fields — always declare type explicitly
- Do not use `late` unless absolutely unavoidable and thoroughly justified
- Do not use string interpolation for single values — use `'$value'` not `'${value}'`
- Do not use `print()` — the project uses `logger` / `talker_flutter`
- Do not use `Navigator.push/pop` — always use `context.router`
- Do not write `default:` in switch on sealed classes or enums
- Do not hardcode user-facing strings — use `S.current.[key]`
- Do not call `Theme.of(context)` — use `context.themeData`
- Do not declare constants as bare top-level values — add them to the appropriate `*Constants` class

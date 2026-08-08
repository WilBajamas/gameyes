---
name: flutter-usecase
description: "Conventions for writing a use case or domain entity in the
  QuestLoggd app's domain layer — class shape, naming, the Result<T> return
  type, and entity vs. DTO boundaries. Triggers on: use case, UseCase, domain
  entity, domain layer, Result type, call method."
---

# Flutter use cases & entities — QuestLoggd conventions

Domain layer only — no API calls, no Isar, no Dio. A use case depends on a
repository **interface**, never an implementation. For the repository itself,
see the `flutter-repository` skill.

---

## Use case shape

- File: `[action]_[feature]_use_case.dart` (e.g. `fetch_games_use_case.dart`).
- Class: `[Action][Feature]UseCase`, annotated `@injectable`.
- **Single public method**: `call(...)` returning `Future<Result<T>>`.
- Receives the repository **interface** via constructor injection — never the
  implementation.
- One use case = one operation. If its name needs "and" to describe what it
  does, split it into two use cases.

```dart
@injectable
class FetchGamesUseCase {
  const FetchGamesUseCase(this._repository);

  final GamesRepository _repository;

  Future<Result<GameListEntity>> call(String query) => _repository.fetchGames(query);
}
```

## The `Result<T>` type

`lib/core/data/models/result.dart` — sealed class, no external package:

```dart
sealed class Result<T> {
  Result<R> map<R>(R Function(T value) transform);
}
class Success<T> extends Result<T> { final T value; }
class Failure<T> extends Result<T> { final ErrorType error; }
```

Every use case's `call()` returns `Future<Result<T>>`. Unwrap it with an
exhaustive `switch` **expression** (never a statement, never a `default:`) —
see the `flutter-state` skill for the worked example, since this is usually
consumed inside a BLoC/Cubit handler.

## Domain entities

- File: `[entity_name]_entity.dart`. Class: `@freezed sealed class [EntityName]Entity with _$[EntityName]Entity`.
- **No dependencies outside the domain layer.** An entity is the innermost,
  most stable thing in the app — nothing about it should ever need to change
  because a database, a package, or a screen changed. It may depend on Dart
  core types and `freezed` only. No Flutter widget types, no Dio, no Isar, no
  JSON, no data-layer or presentation-layer imports of any kind.
- Freezed for immutability and `copyWith` — **but no JSON.** Entities never
  get `fromJson`/`toJson`; that's the DTO's job. An entity that knows how to
  parse an API response has crossed a layer boundary. This is one specific
  case of the no-outside-dependencies rule above, not the whole of it.
- Private constructor `const [EntityName]Entity._();` only when the entity
  needs computed getters or methods.
- Shared entities: `lib/core/domain/entities/`. Feature-only entities:
  `lib/features/[feature]/domain/entities/`.
- Plain-Dart entities exist in older code (`LibrarySnapshotEntity`,
  `GenrePreferencesEntity`) — fine where they are, a plain `final`-field class
  that never needs `copyWith` isn't worth converting. Use freezed for new
  entities.

## Where a DTO becomes an entity

The DTO owns a `toEntity()` method on itself (not a separate mapper class) —
see the `flutter-dto` skill for the DTO side of this boundary.

## What NOT to do

- Do not give a use case more than one public method
- Do not inject a repository implementation — always the interface
- Do not let a use case call a datasource or service directly — only a
  repository
- Do not put JSON parsing on an entity
- Do not write `default:` on an exhaustive switch over `Result`
- Do not return anything other than `Future<Result<T>>` from `call()`

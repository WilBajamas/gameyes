---
name: flutter-repository
description: "Conventions for writing a repository interface and implementation
  in the QuestLoggd app — naming, the Result<T> contract, and error handling
  via BaseRepositoryMixin. Triggers on: repository, repository interface,
  repository implementation, BaseRepositoryMixin, ErrorType."
---

# Flutter repositories — QuestLoggd conventions

Covers the repository interface (domain layer, an abstract contract) and its
implementation (data layer) together — in this project they're always
designed and written in the same pass. Does **not** cover the service or Dio
client a repository implementation might call — that's out of scope for now,
read `flutter-arch.md` directly if you need it. For the datasource layer a
repository implementation sits on top of, see `flutter-datasource`.

---

## Repository interface

- File: `[feature]_repository.dart`.
- `abstract interface class [Feature]Repository` — no `I` prefix, no
  `Abstract` suffix. `interface` is the point: this exists to be implemented,
  never extended.
- All methods return `Future<Result<T>>`.

## Repository implementation

- File: `[feature]_repository_impl.dart`.
- `class [Feature]RepositoryImpl with BaseRepositoryMixin implements [Feature]Repository`.
- Annotated `@Injectable(as: [Feature]Repository)` — registers the impl
  against its interface, so callers (use cases) only ever see the interface.

## Error handling — `BaseRepositoryMixin`

Every repository implementation uses `BaseRepositoryMixin.fetchData<T>()`:
- Wraps the underlying call in try/catch.
- Returns `Success<T>` on success.
- Returns `Failure(ErrorType.dioError(...))` on `DioException`.
- Returns `Failure(ErrorType.unknown())` on any other exception.
- **A repository never throws** — always returns `Result<T>`.

## `ErrorType`

`lib/core/data/models/error.dart` — `@freezed sealed class ErrorType`.
Variants: `responseError({message, error, statusCode})`, `connectionTimeout`,
`receiveTimeout`, `sendTimeout`, `unknown`. Construct via the
`ErrorType.dioError(exception: e)` factory inside `BaseRepositoryMixin` — never
build an error variant by hand in feature code.

## What NOT to do

- Do not name an interface with an `I` prefix or `Abstract` suffix
- Do not let a repository implementation throw — always return `Result<T>`
- Do not construct an `ErrorType` variant manually outside `BaseRepositoryMixin`
- Do not inject a repository implementation anywhere except its own DI
  registration — everything else depends on the interface
- Do not skip `BaseRepositoryMixin` and hand-roll try/catch in a new
  repository implementation

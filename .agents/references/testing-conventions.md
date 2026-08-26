# testing-conventions.md — Gameyes Testing Conventions Reference
Project: gaming_library_assessment_flutter
Last updated: 2026-05-24

---

## Test layers

The project tests five layers independently. Each layer mocks only the
immediate dependency below it.

| Layer | Folder | Mocks | Package |
|---|---|---|---|
| API (HTTP) | `test/api/[feature]/` | `DioAdapter` (http_mock_adapter) | `flutter_test` |
| Repository | `test/repository/[feature]/` | DataSource via `@GenerateMocks` | `flutter_test` + mockito |
| Use case | `test/use_case/[feature]/` | Repository interface via `@GenerateMocks` | `flutter_test` + mockito |
| BLoC / Cubit | `test/cubit/[feature]/` | Use case via `@GenerateMocks` | `bloc_test` + mockito |
| Widget | `test/widget/[feature]/` | Cubit/BLoC via `@GenerateMocks` | `flutter_test` + mockito |

**Only unit tests and widget tests are written.**

- **Unit tests** — the first four layers above. Always grouped by layer, never by
  feature folder. A Cubit test goes in `test/cubit/[feature]/`, never in
  `test/features/[feature]/presentation/blocs/`.
- **Widget tests** — `test/widget/[feature]/`. Pump the widget with a mocked
  Cubit, then assert on what is on screen: which state renders which widget, that
  taps call the right Cubit method, that empty and error states render something
  rather than nothing.

**Never write golden tests.** No `matchesGoldenFile`, no golden image files, no
golden update workflow. Pixel comparisons are not part of this project's testing.

No integration tests either, beyond the Flutter-generated smoke test.

---

## Folder structure

Mirror the source feature path under `test/`.

```
test/
  api/
    [feature]/
      [feature]_test.dart
  repository/
    [feature]/
      [feature]_repository_test.dart
      [feature]_repository_test.mocks.dart   ← generated
  use_case/
    [feature]/
      [action]_[feature]_use_case_test.dart
      [action]_[feature]_use_case_test.mocks.dart  ← generated
  cubit/
    [feature]/
      [feature]_bloc_test.dart
      [feature]_bloc_test.mocks.dart         ← generated
  widget/
    [feature]/
      [widget_name]_test.dart
      [widget_name]_test.mocks.dart          ← generated
  mocks/
    [entity]_mock.dart      ← shared mock data (getters)
    error_mock.dart
```

---

## Mock generation — mockito @GenerateMocks

Use mockito's code-generation approach. Manual mock classes are never written.

**Step 1 — annotate the test file:**
```dart
@GenerateMocks([GamesRepository])
void main() { ... }
```

Place `@GenerateMocks` immediately before `void main()`.
Mock only the direct dependency of the class under test:
- Repository test → mock the DataSource
- Use case test → mock the Repository interface (never the impl)
- BLoC test → mock the Use case

**Step 2 — import the generated file:**
```dart
import '[test_file_name].mocks.dart';
```

**Step 3 — regenerate after any dependency change:**
```
dart run build_runner build --delete-conflicting-outputs
```

Generated files (`*.mocks.dart`) are committed to source control.
Never edit them manually.

---

## provideDummy — required for generic return types

Mockito cannot infer dummy values for generic types like `Result<T>`.
Call `provideDummy` in `setUp` before creating any mock instances:

```dart
setUp(() {
  provideDummy<Result<GameListEntity>>(Success(mockGamesResponse.toEntity()));
  gamesRepository = MockGamesRepository();
  ...
});
```

Rule: any method that returns `Future<Result<T>>` needs a `provideDummy` call.
Provide the `Success` variant as the dummy — it is never used in assertions.

---

## GetIt registration in tests

Injectable classes receive their dependencies via GetIt during tests.
Register the mock in `setUp` and reset in `tearDown`:

```dart
setUp(() {
  GetIt.I.registerSingleton(mockDependency);
  subjectUnderTest = SubjectClass(mockDependency);
});

tearDown(() {
  GetIt.instance.reset();
  reset(mockDependency); // resets all stubbing and interaction history
});
```

- Always call `GetIt.instance.reset()` in `tearDown` — tests share the process
- Always call `reset(mock)` to clear stubs between tests
- Never call `configureDependencies()` in tests — register only what is needed

---

## Stubbing with when / thenAnswer

Use `when(...).thenAnswer((_) async => ...)` for async methods.
Use `when(...).thenReturn(...)` only for synchronous methods.

```dart
// Async stub returning Success
when(
  gamesRepository.fetchGames(
    page: 1,
    searchTerm: anyNamed('searchTerm'),
    dateRange: anyNamed('dateRange'),
    platforms: anyNamed('platforms'),
    genres: anyNamed('genres'),
    ordering: anyNamed('ordering'),
  ),
).thenAnswer((_) async => Success(mockGamesResponse.toEntity()));

// Async stub returning Failure
when(...).thenAnswer((_) async => Failure(mockResponseError));

// Async stub throwing DioException (repository layer only)
when(...).thenAnswer((_) async => throw DioException(
  requestOptions: RequestOptions(path: ''),
  type: DioExceptionType.connectionTimeout,
));
```

Use `anyNamed('paramName')` for optional named parameters that the test
does not care about. Always match required parameters with exact values.

---

## Verification

After calling the subject under test, verify the mock was called:

```dart
verify(
  gamesRepository.fetchGames(
    page: 1,
    searchTerm: anyNamed('searchTerm'),
    ...
  ),
);
```

Use `verifyNever(mock.method())` to assert a method was not called.
Do not use `verifyNoMoreInteractions` unless the test specifically asserts
that no unexpected calls were made.

---

## BLoC / Cubit tests — blocTest

Use `blocTest` from `package:bloc_test` for all state-machine assertions.
Use plain `test()` only for non-state assertions (e.g. initial state value).

```dart
// Initial state check — plain test
test('initial state is GamesState with loading status', () {
  expect(gamesBloc.state.status, GamesStatus.loading);
});

// State sequence — blocTest
blocTest(
  'emits [loading, success] when GamesFetched succeeds',
  setUp: () async {
    when(fetchGamesUseCase.call(page: 1, ...))
        .thenAnswer((_) async => Success(mockGamesResponse.toEntity()));
  },
  build: () => gamesBloc,
  act: (bloc) async => bloc.add(const GamesFetched()),
  expect: () => [
    const GamesState(status: GamesStatus.loading),
    GamesState(
      status: GamesStatus.success,
      response: mockGamesResponse.toEntity(),
      games: mockGamesResponse.toEntity().items,
    ),
  ],
);
```

**`blocTest` field rules:**
- `setUp` — stub mocks here, not in the top-level `setUp`
- `build` — return the BLoC/Cubit instance (already constructed in top-level `setUp`)
- `act` — dispatch events or call methods; use `async` even for synchronous acts
- `expect` — list every emitted state in order; the initial state is not included

### The pattern above does NOT work on a bloc that dispatches in its own constructor

`GamesBloc` calls `add(const GamesFetched())` in its constructor and registers both
handlers with `transformer: droppable()`. The consequence, found 2026-08-25:

- The bloc's **own** initial fetch is always in flight first.
- `droppable()` therefore **silently discards** the event that `act` adds.
- The stub then sees the *constructor's* default arguments, not the test's, so a
  `when()` written against the test's arguments never matches and the call falls
  through to `MissingStubError` — or to `MissingDummyValueError` if no `provideDummy`
  was registered.

**This is why `test/cubit/games/games_bloc_test.dart`'s three `blocTest`s have never
passed** — three of the suite's ten long-standing failures. They are not flaky and not
an environment problem; the pattern cannot work as written.

For a self-dispatching bloc, drive the **constructor's own** fetch instead of adding
an event, and construct the bloc inside `build` so the stub is registered first:

```dart
provideDummy<Result<GameListEntity>>(Success(mockGamesResponse.toEntity()));
when(
  fetchGamesUseCase.call(
    page: anyNamed('page'),
    searchTerm: anyNamed('searchTerm'),
    // ...every remaining named argument as a matcher
  ),
).thenAnswer((_) async => Success(mockGamesResponseEmptyResults.toEntity()));

final bloc = GamesBloc(fetchGamesUseCase);
await expectLater(
  bloc.stream,
  emitsThrough(
    predicate<GamesState>((state) => state.status == GamesStatus.empty),
  ),
);
```

Two Mockito rules that bite here:
- **Matchers and concrete values cannot be mixed in one `when()`.** If any argument is
  `anyNamed(...)`, they all must be matchers — use `argThat(isA<int>(), named: 'page')`
  for a non-nullable argument rather than a bare `1`.
- `test/cubit/games/games_bloc_empty_test.dart` is the working example to copy.

---

## API layer tests — http_mock_adapter

Use `DioAdapter` (from `http_mock_adapter`) to intercept Dio calls.
Do not use `MockWebServer` or any other HTTP interception library.

```dart
setUp(() {
  dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
  dioAdapter = DioAdapter(dio: dio);
});

test('fetches games response successfully', () async {
  dioAdapter.onPost(
    '/games',
    (server) => server.reply(201, mockGamesResponse,
        delay: const Duration(seconds: 1)),
  );

  final response = await dio.post('/games');
  expect(response.statusCode, 201);
  expect(
    (response.data as List).map((i) => Game.fromJson(i)).toList(),
    isA<List<Game>>(),
  );
});

test('throws DioException on network failure', () async {
  dioAdapter.onPost(
    '/games',
    (server) => server.throws(404, DioException(
      requestOptions: RequestOptions(path: '/games'),
    )),
  );

  expect(() async => await dio.post('/games'), throwsA(isA<DioException>()));
});
```

API tests validate raw Dio + JSON deserialization only.
They do not test `BaseRepositoryMixin` error wrapping — that belongs in repository tests.

---

## Mock data — test/mocks/

Shared mock data is stored as top-level `get` getters (not `final` variables)
so each test gets a fresh instance. All files live in `test/mocks/`.

```dart
// test/mocks/game_mock.dart
Game get mockGame => const Game(id: 1, name: 'test_name', ...);
List<Game> get mockListGames => [mockGame, mockGame, mockGame];

// test/mocks/error_mock.dart
ErrorType get mockConnectionTimeoutError => ErrorType.connectionTimeout();
ErrorType get mockResponseError => const ResponseError(
  message: 'test response error message',
  statusCode: 401,
);

// test/mocks/game_response_mock.dart
GamesModel get mockGamesResponse => GamesModel(
  count: 20,
  results: mockListGames,
  next: 'next_url',
  currentPage: 1,
);
```

**Rules for mock data:**
- Use `get` (getter) not `final` — ensures a fresh object per access
- Use `const` constructors where possible to keep values predictable
- Keep values minimal but realistic — real IDs, representative strings
- Name pattern: `mock[ClassName]` for single instances, `mock[ClassName]List` for lists
- Error mocks: provide one instance of every `ErrorType` variant in `error_mock.dart`

---

## Existing mock data catalogue

| File | Exports |
|---|---|
| `game_mock.dart` | `mockGame`, `mockListGames` |
| `game_response_mock.dart` | `mockGamesResponse`, `mockGamesResponseEmptyResults` |
| `games_state_mock.dart` | `mockExistingGamesState`, `mockInitialGamesState` |
| `error_mock.dart` | `mockConnectionTimeoutError`, `mockReceiveTimeoutError`, `mockSendTimeoutError`, `mockResponseError` |
| `date_time_mock.dart` | `mockDateTimeBefore`, `mockDateTimeAfter` |
| `game_genre_mock.dart` | `mockGameGenres` |
| `game_platform_mock.dart` | `mockGamePlatforms` |
| `game_detail_response_mock.dart` | game detail response mock |
| `saved_game_mock.dart` | `mockSavedGame` |
| `platform_mock.dart` | `mockPlatform` |
| `platform_item_mock.dart` | `mockPlatformItem` |
| `genre_mock.dart` | `mockGenre` |
| `developer_mock.dart` | `mockDeveloper` |
| `publisher_mock.dart` | `mockPublisher` |

Always import from `test/mocks/` — never define mock data inline in a test file.
If a required mock does not exist, add it to the appropriate mock file.

---

## Test naming conventions

**Plain `test()`:** `'should [expected behaviour] when [condition]'`
- `'should return Success(GameListEntity) when datasource fetch is successful'`
- `'should return Failure(ErrorType) when datasource throws DioException'`

**`blocTest()`:** `'emits [state sequence] when [event/action]'`
- `'emits [loading, success] when GamesFetched succeeds'`
- `'emits [loading, failed] when GamesFetched fails'`

Long descriptions may exceed 80 chars — suppress with:
`// ignore: lines_longer_than_80_chars`

---

## Running tests

```
# Run all tests
flutter test

# Run a single test file
flutter test test/cubit/games/games_bloc_test.dart

# Run with coverage
flutter test --coverage
```

Regenerate mocks after any change to a mocked class:
```
dart run build_runner build --delete-conflicting-outputs
```

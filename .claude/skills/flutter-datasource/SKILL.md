---
name: flutter-datasource
description: "Conventions for writing a datasource in the QuestLoggd app's data
  layer — naming, and the local-storage patterns (Isar, SharedPreferences) a
  datasource uses. Triggers on: datasource, DataSource, Isar, local storage,
  SharedPreferences, GameLocalStorageService."
---

# Flutter datasources — QuestLoggd conventions

A datasource is what a repository implementation calls. It either calls a
Retrofit service (that service's own conventions are out of scope for now —
read `flutter-arch.md` directly if you need them) or local storage (covered
here in full).

---

## DataSource shape

- File: `[feature]_datasource.dart`.
- `class [Feature]DataSource` annotated `@injectable`.
- Receives its Retrofit service (if any) or storage service via constructor
  injection.
- `tracker`'s local source nests at `data/datasources/local/` — a known
  deviation, not the default shape to copy elsewhere without reason.

## Isar local storage

All Isar access goes through `GameLocalStorageService`
(extends `IsarLocalStorageService` at `lib/core/services/storage/`). Never
access `Isar` directly.

**Get the db instance first, then operate:**
```dart
final isar = await db; // inherited from IsarLocalStorageService
await isar.writeTxn(() async => isar.savedGames.put(game));
```

**Reads — query directly, no transaction needed:**
```dart
final isar = await db;
return await isar.savedGames.filter().gameIdEqualTo(gameId).findFirst();
```

**Real-time streams — `.watch(fireImmediately: true)`:**
```dart
yield* isar.savedGames.watchObject(savedGameId, fireImmediately: true);
```
Stream-based reads don't need a write transaction. Use `async*` + `yield*`
for stream methods in storage services.

**Linked objects (`IsarLinks`) — call `.save()` after adding, inside `writeTxn`:**
```dart
game.groupTasks.add(groupTaskToSave);
game.groupTasks.save();
```

A new Isar collection must be:
1. Annotated `@collection`.
2. Registered in `IsarLocalStorageService.openDb()`'s schema list — it won't
   exist at runtime otherwise.
3. Code-generated: `dart run build_runner build --delete-conflicting-outputs`.

## SharedPreferences

For simple key-value flags (e.g. onboarding-complete). **There is no wrapper
class, deliberately** — `SharedPreferences` already exposes `getBool` /
`setBool` / `getString` / `remove` and friends; wrapping it would just be
pass-throughs.

`StorageModule` (`lib/core/di/storage_module.dart`) provides the instance as
an async singleton. Inject it directly:
```dart
@injectable
class FeaturedLocalDatasource {
  final SharedPreferences _sharedPreferences;
  FeaturedLocalDatasource(this._sharedPreferences);
}
```
Never call `SharedPreferences.getInstance()` yourself — `StorageModule` is
the one place that does. All keys go in `StorageConstants`
(`lib/core/res/const.dart`) as `static const` — no inline string keys.

## What NOT to do

- Do not access `Isar` directly — always through `GameLocalStorageService`
- Do not call `SharedPreferences.getInstance()` outside `StorageModule`
- Do not use an inline string as a storage key — add it to `StorageConstants`
- Do not add a new Isar collection without registering it in `openDb()`
- Do not write a wrapper class around `SharedPreferences`

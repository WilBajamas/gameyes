---
name: flutter-dto
description: "Conventions for writing a DTO (data transfer object / API model)
  in the QuestLoggd app — naming, JSON serialisation, and the toEntity()
  boundary into the domain layer. Triggers on: DTO, model, JSON serializable,
  fromJson, toEntity, freezed model."
---

# Flutter DTOs / models — QuestLoggd conventions

A DTO is the shape data arrives in over the wire. It's the only thing allowed
to know about JSON. For what it turns into on the way out, see the
`flutter-usecase` skill's entity section.

---

## Shape

- File: `[entity_name].dart` (e.g. `game.dart`, `game_cover.dart`).
- `@freezed sealed class [ModelName] with _$[ModelName]`.
- Private constructor `const [ModelName]._();` only when a custom method is
  needed on the model itself.
- `factory [ModelName].fromJson(Map<String, dynamic> json) => _$[ModelName]FromJson(json);`
- `@JsonKey(name: 'snake_case_field')` for API fields that differ from their
  Dart name.
- **`toEntity()` lives on the model itself** — not a separate mapper class.
  This is the one place a DTO is allowed to know about the domain entity it
  produces.

## Where these live

- Shared DTOs: `lib/core/data/models/`.
- Feature-scoped DTOs: `lib/features/[feature]/data/models/`.

## Generation

Annotated with `@freezed` (immutability + `copyWith`) and `@JsonSerializable`
(via freezed's `fromJson`/`toJson`) when the model is API-sourced. Generated
files (`.freezed.dart`, `.g.dart`) are never hand-edited — run
`dart run build_runner build --delete-conflicting-outputs` after any change.

## What NOT to do

- Do not put `fromJson`/`toJson` on a domain entity — that's the DTO's job
  only
- Do not write a separate mapper class for `toEntity()` — it belongs on the
  model
- Do not hand-edit `.freezed.dart` or `.g.dart` — fix the source and
  regenerate
- Do not skip `@JsonKey` when the API field name isn't already camelCase

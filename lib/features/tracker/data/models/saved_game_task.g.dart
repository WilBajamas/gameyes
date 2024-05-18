// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_game_task.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSavedGameTaskCollection on Isar {
  IsarCollection<SavedGameTask> get savedGameTasks => this.collection();
}

const SavedGameTaskSchema = CollectionSchema(
  name: r'SavedGameTask',
  id: 4309674529777207973,
  properties: {
    r'completed': PropertySchema(
      id: 0,
      name: r'completed',
      type: IsarType.bool,
    ),
    r'currentStepIndex': PropertySchema(
      id: 1,
      name: r'currentStepIndex',
      type: IsarType.long,
    ),
    r'description': PropertySchema(
      id: 2,
      name: r'description',
      type: IsarType.string,
    ),
    r'gameId': PropertySchema(
      id: 3,
      name: r'gameId',
      type: IsarType.long,
    ),
    r'pinned': PropertySchema(
      id: 4,
      name: r'pinned',
      type: IsarType.bool,
    ),
    r'savedGameId': PropertySchema(
      id: 5,
      name: r'savedGameId',
      type: IsarType.long,
    ),
    r'setReminder': PropertySchema(
      id: 6,
      name: r'setReminder',
      type: IsarType.bool,
    ),
    r'steps': PropertySchema(
      id: 7,
      name: r'steps',
      type: IsarType.objectList,
      target: r'TaskStep',
    ),
    r'timeToComplete': PropertySchema(
      id: 8,
      name: r'timeToComplete',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 9,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _savedGameTaskEstimateSize,
  serialize: _savedGameTaskSerialize,
  deserialize: _savedGameTaskDeserialize,
  deserializeProp: _savedGameTaskDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'groupTask': LinkSchema(
      id: -8438136150487137746,
      name: r'groupTask',
      target: r'GroupTask',
      single: true,
      linkName: r'tasks',
    )
  },
  embeddedSchemas: {r'TaskStep': TaskStepSchema},
  getId: _savedGameTaskGetId,
  getLinks: _savedGameTaskGetLinks,
  attach: _savedGameTaskAttach,
  version: '3.1.0+1',
);

int _savedGameTaskEstimateSize(
  SavedGameTask object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.steps;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[TaskStep]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += TaskStepSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.timeToComplete;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _savedGameTaskSerialize(
  SavedGameTask object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.completed);
  writer.writeLong(offsets[1], object.currentStepIndex);
  writer.writeString(offsets[2], object.description);
  writer.writeLong(offsets[3], object.gameId);
  writer.writeBool(offsets[4], object.pinned);
  writer.writeLong(offsets[5], object.savedGameId);
  writer.writeBool(offsets[6], object.setReminder);
  writer.writeObjectList<TaskStep>(
    offsets[7],
    allOffsets,
    TaskStepSchema.serialize,
    object.steps,
  );
  writer.writeString(offsets[8], object.timeToComplete);
  writer.writeString(offsets[9], object.title);
}

SavedGameTask _savedGameTaskDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SavedGameTask();
  object.completed = reader.readBoolOrNull(offsets[0]);
  object.currentStepIndex = reader.readLong(offsets[1]);
  object.description = reader.readStringOrNull(offsets[2]);
  object.gameId = reader.readLongOrNull(offsets[3]);
  object.id = id;
  object.pinned = reader.readBoolOrNull(offsets[4]);
  object.savedGameId = reader.readLongOrNull(offsets[5]);
  object.setReminder = reader.readBool(offsets[6]);
  object.steps = reader.readObjectList<TaskStep>(
    offsets[7],
    TaskStepSchema.deserialize,
    allOffsets,
    TaskStep(),
  );
  object.timeToComplete = reader.readStringOrNull(offsets[8]);
  object.title = reader.readStringOrNull(offsets[9]);
  return object;
}

P _savedGameTaskDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readObjectList<TaskStep>(
        offset,
        TaskStepSchema.deserialize,
        allOffsets,
        TaskStep(),
      )) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _savedGameTaskGetId(SavedGameTask object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _savedGameTaskGetLinks(SavedGameTask object) {
  return [object.groupTask];
}

void _savedGameTaskAttach(
    IsarCollection<dynamic> col, Id id, SavedGameTask object) {
  object.id = id;
  object.groupTask
      .attach(col, col.isar.collection<GroupTask>(), r'groupTask', id);
}

extension SavedGameTaskQueryWhereSort
    on QueryBuilder<SavedGameTask, SavedGameTask, QWhere> {
  QueryBuilder<SavedGameTask, SavedGameTask, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SavedGameTaskQueryWhere
    on QueryBuilder<SavedGameTask, SavedGameTask, QWhereClause> {
  QueryBuilder<SavedGameTask, SavedGameTask, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SavedGameTaskQueryFilter
    on QueryBuilder<SavedGameTask, SavedGameTask, QFilterCondition> {
  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      completedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completed',
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      completedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completed',
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      completedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completed',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      currentStepIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentStepIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      currentStepIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentStepIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      currentStepIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentStepIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      currentStepIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentStepIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      gameIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gameId',
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      gameIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gameId',
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      gameIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gameId',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      gameIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gameId',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      gameIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gameId',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      gameIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gameId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      pinnedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pinned',
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      pinnedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pinned',
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      pinnedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pinned',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      savedGameIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'savedGameId',
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      savedGameIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'savedGameId',
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      savedGameIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'savedGameId',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      savedGameIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'savedGameId',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      savedGameIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'savedGameId',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      savedGameIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'savedGameId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      setReminderEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'setReminder',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      stepsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'steps',
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      stepsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'steps',
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      stepsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'steps',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      stepsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'steps',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      stepsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'steps',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      stepsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'steps',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      stepsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'steps',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      stepsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'steps',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      timeToCompleteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'timeToComplete',
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      timeToCompleteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'timeToComplete',
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      timeToCompleteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeToComplete',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      timeToCompleteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeToComplete',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      timeToCompleteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeToComplete',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      timeToCompleteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeToComplete',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      timeToCompleteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'timeToComplete',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      timeToCompleteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'timeToComplete',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      timeToCompleteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'timeToComplete',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      timeToCompleteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'timeToComplete',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      timeToCompleteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeToComplete',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      timeToCompleteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'timeToComplete',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      titleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      titleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      titleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      titleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension SavedGameTaskQueryObject
    on QueryBuilder<SavedGameTask, SavedGameTask, QFilterCondition> {
  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      stepsElement(FilterQuery<TaskStep> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'steps');
    });
  }
}

extension SavedGameTaskQueryLinks
    on QueryBuilder<SavedGameTask, SavedGameTask, QFilterCondition> {
  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition> groupTask(
      FilterQuery<GroupTask> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'groupTask');
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterFilterCondition>
      groupTaskIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'groupTask', 0, true, 0, true);
    });
  }
}

extension SavedGameTaskQuerySortBy
    on QueryBuilder<SavedGameTask, SavedGameTask, QSortBy> {
  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> sortByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy>
      sortByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy>
      sortByCurrentStepIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStepIndex', Sort.asc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy>
      sortByCurrentStepIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStepIndex', Sort.desc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> sortByGameId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameId', Sort.asc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> sortByGameIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameId', Sort.desc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> sortByPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinned', Sort.asc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> sortByPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinned', Sort.desc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> sortBySavedGameId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedGameId', Sort.asc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy>
      sortBySavedGameIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedGameId', Sort.desc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> sortBySetReminder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setReminder', Sort.asc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy>
      sortBySetReminderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setReminder', Sort.desc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy>
      sortByTimeToComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeToComplete', Sort.asc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy>
      sortByTimeToCompleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeToComplete', Sort.desc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension SavedGameTaskQuerySortThenBy
    on QueryBuilder<SavedGameTask, SavedGameTask, QSortThenBy> {
  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> thenByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy>
      thenByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy>
      thenByCurrentStepIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStepIndex', Sort.asc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy>
      thenByCurrentStepIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStepIndex', Sort.desc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> thenByGameId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameId', Sort.asc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> thenByGameIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameId', Sort.desc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> thenByPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinned', Sort.asc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> thenByPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinned', Sort.desc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> thenBySavedGameId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedGameId', Sort.asc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy>
      thenBySavedGameIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savedGameId', Sort.desc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> thenBySetReminder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setReminder', Sort.asc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy>
      thenBySetReminderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setReminder', Sort.desc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy>
      thenByTimeToComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeToComplete', Sort.asc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy>
      thenByTimeToCompleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeToComplete', Sort.desc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension SavedGameTaskQueryWhereDistinct
    on QueryBuilder<SavedGameTask, SavedGameTask, QDistinct> {
  QueryBuilder<SavedGameTask, SavedGameTask, QDistinct> distinctByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completed');
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QDistinct>
      distinctByCurrentStepIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStepIndex');
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QDistinct> distinctByGameId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gameId');
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QDistinct> distinctByPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pinned');
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QDistinct>
      distinctBySavedGameId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'savedGameId');
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QDistinct>
      distinctBySetReminder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'setReminder');
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QDistinct>
      distinctByTimeToComplete({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeToComplete',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedGameTask, SavedGameTask, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension SavedGameTaskQueryProperty
    on QueryBuilder<SavedGameTask, SavedGameTask, QQueryProperty> {
  QueryBuilder<SavedGameTask, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SavedGameTask, bool?, QQueryOperations> completedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completed');
    });
  }

  QueryBuilder<SavedGameTask, int, QQueryOperations>
      currentStepIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStepIndex');
    });
  }

  QueryBuilder<SavedGameTask, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<SavedGameTask, int?, QQueryOperations> gameIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gameId');
    });
  }

  QueryBuilder<SavedGameTask, bool?, QQueryOperations> pinnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pinned');
    });
  }

  QueryBuilder<SavedGameTask, int?, QQueryOperations> savedGameIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'savedGameId');
    });
  }

  QueryBuilder<SavedGameTask, bool, QQueryOperations> setReminderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'setReminder');
    });
  }

  QueryBuilder<SavedGameTask, List<TaskStep>?, QQueryOperations>
      stepsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'steps');
    });
  }

  QueryBuilder<SavedGameTask, String?, QQueryOperations>
      timeToCompleteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeToComplete');
    });
  }

  QueryBuilder<SavedGameTask, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}

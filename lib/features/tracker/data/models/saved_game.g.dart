// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_game.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSavedGameCollection on Isar {
  IsarCollection<SavedGame> get savedGames => this.collection();
}

const SavedGameSchema = CollectionSchema(
  name: r'SavedGame',
  id: -7719033278776789884,
  properties: {
    r'dateSaved': PropertySchema(
      id: 0,
      name: r'dateSaved',
      type: IsarType.dateTime,
    ),
    r'gameId': PropertySchema(
      id: 1,
      name: r'gameId',
      type: IsarType.long,
    ),
    r'gameSlug': PropertySchema(
      id: 2,
      name: r'gameSlug',
      type: IsarType.string,
    ),
    r'imageUrl': PropertySchema(
      id: 3,
      name: r'imageUrl',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 4,
      name: r'name',
      type: IsarType.string,
    ),
    r'platforms': PropertySchema(
      id: 5,
      name: r'platforms',
      type: IsarType.byteList,
      enumMap: _SavedGameplatformsEnumValueMap,
    ),
    r'playTime': PropertySchema(
      id: 6,
      name: r'playTime',
      type: IsarType.string,
    )
  },
  estimateSize: _savedGameEstimateSize,
  serialize: _savedGameSerialize,
  deserialize: _savedGameDeserialize,
  deserializeProp: _savedGameDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'groupTasks': LinkSchema(
      id: -2269878731325204049,
      name: r'groupTasks',
      target: r'GroupTask',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _savedGameGetId,
  getLinks: _savedGameGetLinks,
  attach: _savedGameAttach,
  version: '3.1.0+1',
);

int _savedGameEstimateSize(
  SavedGame object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.gameSlug;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.imageUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.platforms;
    if (value != null) {
      bytesCount += 3 + value.length;
    }
  }
  {
    final value = object.playTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _savedGameSerialize(
  SavedGame object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dateSaved);
  writer.writeLong(offsets[1], object.gameId);
  writer.writeString(offsets[2], object.gameSlug);
  writer.writeString(offsets[3], object.imageUrl);
  writer.writeString(offsets[4], object.name);
  writer.writeByteList(
      offsets[5], object.platforms?.map((e) => e.index).toList());
  writer.writeString(offsets[6], object.playTime);
}

SavedGame _savedGameDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SavedGame();
  object.dateSaved = reader.readDateTimeOrNull(offsets[0]);
  object.gameId = reader.readLongOrNull(offsets[1]);
  object.gameSlug = reader.readStringOrNull(offsets[2]);
  object.id = id;
  object.imageUrl = reader.readStringOrNull(offsets[3]);
  object.name = reader.readStringOrNull(offsets[4]);
  object.platforms = reader
      .readByteList(offsets[5])
      ?.map(
          (e) => _SavedGameplatformsValueEnumMap[e] ?? GamePlatform.playstation)
      .toList();
  object.playTime = reader.readStringOrNull(offsets[6]);
  return object;
}

P _savedGameDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader
          .readByteList(offset)
          ?.map((e) =>
              _SavedGameplatformsValueEnumMap[e] ?? GamePlatform.playstation)
          .toList()) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SavedGameplatformsEnumValueMap = {
  'playstation': 0,
  'xbox': 1,
  'android': 2,
  'ios': 3,
  'pc': 4,
  'nintendo': 5,
  'wii': 6,
  'linux': 7,
};
const _SavedGameplatformsValueEnumMap = {
  0: GamePlatform.playstation,
  1: GamePlatform.xbox,
  2: GamePlatform.android,
  3: GamePlatform.ios,
  4: GamePlatform.pc,
  5: GamePlatform.nintendo,
  6: GamePlatform.wii,
  7: GamePlatform.linux,
};

Id _savedGameGetId(SavedGame object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _savedGameGetLinks(SavedGame object) {
  return [object.groupTasks];
}

void _savedGameAttach(IsarCollection<dynamic> col, Id id, SavedGame object) {
  object.id = id;
  object.groupTasks
      .attach(col, col.isar.collection<GroupTask>(), r'groupTasks', id);
}

extension SavedGameQueryWhereSort
    on QueryBuilder<SavedGame, SavedGame, QWhere> {
  QueryBuilder<SavedGame, SavedGame, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SavedGameQueryWhere
    on QueryBuilder<SavedGame, SavedGame, QWhereClause> {
  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> idBetween(
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

extension SavedGameQueryFilter
    on QueryBuilder<SavedGame, SavedGame, QFilterCondition> {
  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> dateSavedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateSaved',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      dateSavedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateSaved',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> dateSavedEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateSaved',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      dateSavedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateSaved',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> dateSavedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateSaved',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> dateSavedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateSaved',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gameId',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gameId',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gameId',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameIdGreaterThan(
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

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameIdLessThan(
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

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameIdBetween(
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

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameSlugIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gameSlug',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      gameSlugIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gameSlug',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameSlugEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gameSlug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameSlugGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gameSlug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameSlugLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gameSlug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameSlugBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gameSlug',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameSlugStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'gameSlug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameSlugEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'gameSlug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameSlugContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'gameSlug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameSlugMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'gameSlug',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameSlugIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gameSlug',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      gameSlugIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gameSlug',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> imageUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imageUrl',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      imageUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imageUrl',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> imageUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> imageUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> imageUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> imageUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> imageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> imageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> imageUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> imageUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> imageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      imageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> platformsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'platforms',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      platformsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'platforms',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      platformsElementEqualTo(GamePlatform value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'platforms',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      platformsElementGreaterThan(
    GamePlatform value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'platforms',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      platformsElementLessThan(
    GamePlatform value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'platforms',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      platformsElementBetween(
    GamePlatform lower,
    GamePlatform upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'platforms',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      platformsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'platforms',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> platformsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'platforms',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      platformsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'platforms',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      platformsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'platforms',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      platformsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'platforms',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      platformsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'platforms',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> playTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'playTime',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      playTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'playTime',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> playTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> playTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'playTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> playTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'playTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> playTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'playTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> playTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'playTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> playTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'playTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> playTimeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'playTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> playTimeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'playTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> playTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playTime',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      playTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'playTime',
        value: '',
      ));
    });
  }
}

extension SavedGameQueryObject
    on QueryBuilder<SavedGame, SavedGame, QFilterCondition> {}

extension SavedGameQueryLinks
    on QueryBuilder<SavedGame, SavedGame, QFilterCondition> {
  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> groupTasks(
      FilterQuery<GroupTask> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'groupTasks');
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      groupTasksLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'groupTasks', length, true, length, true);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      groupTasksIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'groupTasks', 0, true, 0, true);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      groupTasksIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'groupTasks', 0, false, 999999, true);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      groupTasksLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'groupTasks', 0, true, length, include);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      groupTasksLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'groupTasks', length, include, 999999, true);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      groupTasksLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'groupTasks', lower, includeLower, upper, includeUpper);
    });
  }
}

extension SavedGameQuerySortBy on QueryBuilder<SavedGame, SavedGame, QSortBy> {
  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByDateSaved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateSaved', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByDateSavedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateSaved', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByGameId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameId', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByGameIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameId', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByGameSlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameSlug', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByGameSlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameSlug', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByPlayTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playTime', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByPlayTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playTime', Sort.desc);
    });
  }
}

extension SavedGameQuerySortThenBy
    on QueryBuilder<SavedGame, SavedGame, QSortThenBy> {
  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByDateSaved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateSaved', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByDateSavedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateSaved', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByGameId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameId', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByGameIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameId', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByGameSlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameSlug', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByGameSlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameSlug', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByPlayTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playTime', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByPlayTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playTime', Sort.desc);
    });
  }
}

extension SavedGameQueryWhereDistinct
    on QueryBuilder<SavedGame, SavedGame, QDistinct> {
  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByDateSaved() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateSaved');
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByGameId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gameId');
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByGameSlug(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gameSlug', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByImageUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByPlatforms() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'platforms');
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByPlayTime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playTime', caseSensitive: caseSensitive);
    });
  }
}

extension SavedGameQueryProperty
    on QueryBuilder<SavedGame, SavedGame, QQueryProperty> {
  QueryBuilder<SavedGame, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SavedGame, DateTime?, QQueryOperations> dateSavedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateSaved');
    });
  }

  QueryBuilder<SavedGame, int?, QQueryOperations> gameIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gameId');
    });
  }

  QueryBuilder<SavedGame, String?, QQueryOperations> gameSlugProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gameSlug');
    });
  }

  QueryBuilder<SavedGame, String?, QQueryOperations> imageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageUrl');
    });
  }

  QueryBuilder<SavedGame, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<SavedGame, List<GamePlatform>?, QQueryOperations>
      platformsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'platforms');
    });
  }

  QueryBuilder<SavedGame, String?, QQueryOperations> playTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playTime');
    });
  }
}

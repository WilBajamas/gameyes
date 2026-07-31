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
    r'availablePlatforms': PropertySchema(
      id: 0,
      name: r'availablePlatforms',
      type: IsarType.objectList,

      target: r'SavedGamePlatform',
    ),
    r'averageCompletionHours': PropertySchema(
      id: 1,
      name: r'averageCompletionHours',
      type: IsarType.double,
    ),
    r'completed': PropertySchema(
      id: 2,
      name: r'completed',
      type: IsarType.bool,
    ),
    r'dateModified': PropertySchema(
      id: 3,
      name: r'dateModified',
      type: IsarType.dateTime,
    ),
    r'dateSaved': PropertySchema(
      id: 4,
      name: r'dateSaved',
      type: IsarType.dateTime,
    ),
    r'gameId': PropertySchema(id: 5, name: r'gameId', type: IsarType.long),
    r'gameSlug': PropertySchema(
      id: 6,
      name: r'gameSlug',
      type: IsarType.string,
    ),
    r'genres': PropertySchema(id: 7, name: r'genres', type: IsarType.longList),
    r'hoursLogged': PropertySchema(
      id: 8,
      name: r'hoursLogged',
      type: IsarType.double,
    ),
    r'imageUrl': PropertySchema(
      id: 9,
      name: r'imageUrl',
      type: IsarType.string,
    ),
    r'isWishlisted': PropertySchema(
      id: 10,
      name: r'isWishlisted',
      type: IsarType.bool,
    ),
    r'manualProgressPercentage': PropertySchema(
      id: 11,
      name: r'manualProgressPercentage',
      type: IsarType.double,
    ),
    r'name': PropertySchema(id: 12, name: r'name', type: IsarType.string),
    r'platforms': PropertySchema(
      id: 13,
      name: r'platforms',
      type: IsarType.objectList,

      target: r'SavedGamePlatform',
    ),
    r'status': PropertySchema(id: 14, name: r'status', type: IsarType.string),
  },

  estimateSize: _savedGameEstimateSize,
  serialize: _savedGameSerialize,
  deserialize: _savedGameDeserialize,
  deserializeProp: _savedGameDeserializeProp,
  idName: r'id',
  indexes: {
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'dateSaved': IndexSchema(
      id: 6319705626594882365,
      name: r'dateSaved',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateSaved',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'dateModified': IndexSchema(
      id: 7664096291674774918,
      name: r'dateModified',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateModified',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {
    r'groupTasks': LinkSchema(
      id: -2269878731325204049,
      name: r'groupTasks',
      target: r'GroupTask',
      single: false,
    ),
  },
  embeddedSchemas: {r'SavedGamePlatform': SavedGamePlatformSchema},

  getId: _savedGameGetId,
  getLinks: _savedGameGetLinks,
  attach: _savedGameAttach,
  version: '3.3.2',
);

int _savedGameEstimateSize(
  SavedGame object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.availablePlatforms;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[SavedGamePlatform]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += SavedGamePlatformSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final value = object.gameSlug;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.genres;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
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
    final list = object.platforms;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[SavedGamePlatform]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += SavedGamePlatformSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final value = object.status;
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
  writer.writeObjectList<SavedGamePlatform>(
    offsets[0],
    allOffsets,
    SavedGamePlatformSchema.serialize,
    object.availablePlatforms,
  );
  writer.writeDouble(offsets[1], object.averageCompletionHours);
  writer.writeBool(offsets[2], object.completed);
  writer.writeDateTime(offsets[3], object.dateModified);
  writer.writeDateTime(offsets[4], object.dateSaved);
  writer.writeLong(offsets[5], object.gameId);
  writer.writeString(offsets[6], object.gameSlug);
  writer.writeLongList(offsets[7], object.genres);
  writer.writeDouble(offsets[8], object.hoursLogged);
  writer.writeString(offsets[9], object.imageUrl);
  writer.writeBool(offsets[10], object.isWishlisted);
  writer.writeDouble(offsets[11], object.manualProgressPercentage);
  writer.writeString(offsets[12], object.name);
  writer.writeObjectList<SavedGamePlatform>(
    offsets[13],
    allOffsets,
    SavedGamePlatformSchema.serialize,
    object.platforms,
  );
  writer.writeString(offsets[14], object.status);
}

SavedGame _savedGameDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SavedGame(
    availablePlatforms: reader.readObjectList<SavedGamePlatform>(
      offsets[0],
      SavedGamePlatformSchema.deserialize,
      allOffsets,
      SavedGamePlatform(),
    ),
    averageCompletionHours: reader.readDoubleOrNull(offsets[1]),
    dateModified: reader.readDateTimeOrNull(offsets[3]),
    dateSaved: reader.readDateTimeOrNull(offsets[4]),
    gameId: reader.readLongOrNull(offsets[5]),
    gameSlug: reader.readStringOrNull(offsets[6]),
    genres: reader.readLongList(offsets[7]),
    hoursLogged: reader.readDoubleOrNull(offsets[8]),
    imageUrl: reader.readStringOrNull(offsets[9]),
    isWishlisted: reader.readBoolOrNull(offsets[10]) ?? false,
    manualProgressPercentage: reader.readDoubleOrNull(offsets[11]),
    name: reader.readStringOrNull(offsets[12]),
    platforms: reader.readObjectList<SavedGamePlatform>(
      offsets[13],
      SavedGamePlatformSchema.deserialize,
      allOffsets,
      SavedGamePlatform(),
    ),
    status: reader.readStringOrNull(offsets[14]),
  );
  object.completed = reader.readBool(offsets[2]);
  object.id = id;
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
      return (reader.readObjectList<SavedGamePlatform>(
            offset,
            SavedGamePlatformSchema.deserialize,
            allOffsets,
            SavedGamePlatform(),
          ))
          as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readLongList(offset)) as P;
    case 8:
      return (reader.readDoubleOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 11:
      return (reader.readDoubleOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readObjectList<SavedGamePlatform>(
            offset,
            SavedGamePlatformSchema.deserialize,
            allOffsets,
            SavedGamePlatform(),
          ))
          as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _savedGameGetId(SavedGame object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _savedGameGetLinks(SavedGame object) {
  return [object.groupTasks];
}

void _savedGameAttach(IsarCollection<dynamic> col, Id id, SavedGame object) {
  object.id = id;
  object.groupTasks.attach(
    col,
    col.isar.collection<GroupTask>(),
    r'groupTasks',
    id,
  );
}

extension SavedGameQueryWhereSort
    on QueryBuilder<SavedGame, SavedGame, QWhere> {
  QueryBuilder<SavedGame, SavedGame, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhere> anyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'name'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhere> anyDateSaved() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateSaved'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhere> anyDateModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateModified'),
      );
    });
  }
}

extension SavedGameQueryWhere
    on QueryBuilder<SavedGame, SavedGame, QWhereClause> {
  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
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

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
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
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'name', value: [null]),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'name',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> nameEqualTo(
    String? name,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'name', value: [name]),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> nameNotEqualTo(
    String? name,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [],
                upper: [name],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [name],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [name],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [],
                upper: [name],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> nameGreaterThan(
    String? name, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'name',
          lower: [name],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> nameLessThan(
    String? name, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'name',
          lower: [],
          upper: [name],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> nameBetween(
    String? lowerName,
    String? upperName, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'name',
          lower: [lowerName],
          includeLower: includeLower,
          upper: [upperName],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> nameStartsWith(
    String NamePrefix,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'name',
          lower: [NamePrefix],
          upper: ['$NamePrefix\u{FFFFF}'],
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'name', value: ['']),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.lessThan(indexName: r'name', upper: ['']),
            )
            .addWhereClause(
              IndexWhereClause.greaterThan(indexName: r'name', lower: ['']),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.greaterThan(indexName: r'name', lower: ['']),
            )
            .addWhereClause(
              IndexWhereClause.lessThan(indexName: r'name', upper: ['']),
            );
      }
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> dateSavedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'dateSaved', value: [null]),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> dateSavedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateSaved',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> dateSavedEqualTo(
    DateTime? dateSaved,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'dateSaved', value: [dateSaved]),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> dateSavedNotEqualTo(
    DateTime? dateSaved,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateSaved',
                lower: [],
                upper: [dateSaved],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateSaved',
                lower: [dateSaved],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateSaved',
                lower: [dateSaved],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateSaved',
                lower: [],
                upper: [dateSaved],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> dateSavedGreaterThan(
    DateTime? dateSaved, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateSaved',
          lower: [dateSaved],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> dateSavedLessThan(
    DateTime? dateSaved, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateSaved',
          lower: [],
          upper: [dateSaved],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> dateSavedBetween(
    DateTime? lowerDateSaved,
    DateTime? upperDateSaved, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateSaved',
          lower: [lowerDateSaved],
          includeLower: includeLower,
          upper: [upperDateSaved],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> dateModifiedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'dateModified', value: [null]),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause>
  dateModifiedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateModified',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> dateModifiedEqualTo(
    DateTime? dateModified,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'dateModified',
          value: [dateModified],
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> dateModifiedNotEqualTo(
    DateTime? dateModified,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateModified',
                lower: [],
                upper: [dateModified],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateModified',
                lower: [dateModified],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateModified',
                lower: [dateModified],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateModified',
                lower: [],
                upper: [dateModified],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> dateModifiedGreaterThan(
    DateTime? dateModified, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateModified',
          lower: [dateModified],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> dateModifiedLessThan(
    DateTime? dateModified, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateModified',
          lower: [],
          upper: [dateModified],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> dateModifiedBetween(
    DateTime? lowerDateModified,
    DateTime? upperDateModified, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateModified',
          lower: [lowerDateModified],
          includeLower: includeLower,
          upper: [upperDateModified],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension SavedGameQueryFilter
    on QueryBuilder<SavedGame, SavedGame, QFilterCondition> {
  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  availablePlatformsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'availablePlatforms'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  availablePlatformsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'availablePlatforms'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  availablePlatformsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'availablePlatforms',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  availablePlatformsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'availablePlatforms', 0, true, 0, true);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  availablePlatformsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'availablePlatforms', 0, false, 999999, true);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  availablePlatformsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'availablePlatforms', 0, true, length, include);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  availablePlatformsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'availablePlatforms',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  availablePlatformsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'availablePlatforms',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  averageCompletionHoursIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'averageCompletionHours'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  averageCompletionHoursIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'averageCompletionHours'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  averageCompletionHoursEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'averageCompletionHours',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  averageCompletionHoursGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'averageCompletionHours',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  averageCompletionHoursLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'averageCompletionHours',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  averageCompletionHoursBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'averageCompletionHours',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> completedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'completed', value: value),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  dateModifiedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'dateModified'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  dateModifiedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'dateModified'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> dateModifiedEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateModified', value: value),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  dateModifiedGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dateModified',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  dateModifiedLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dateModified',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> dateModifiedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dateModified',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> dateSavedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'dateSaved'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  dateSavedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'dateSaved'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> dateSavedEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateSaved', value: value),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  dateSavedGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dateSaved',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> dateSavedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dateSaved',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> dateSavedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dateSaved',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'gameId'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'gameId'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'gameId', value: value),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'gameId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'gameId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'gameId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameSlugIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'gameSlug'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  gameSlugIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'gameSlug'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameSlugEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'gameSlug',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameSlugGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'gameSlug',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameSlugLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'gameSlug',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'gameSlug',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameSlugStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'gameSlug',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameSlugEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'gameSlug',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameSlugContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'gameSlug',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameSlugMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'gameSlug',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> gameSlugIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'gameSlug', value: ''),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  gameSlugIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'gameSlug', value: ''),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> genresIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'genres'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> genresIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'genres'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  genresElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'genres', value: value),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  genresElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'genres',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  genresElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'genres',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  genresElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'genres',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> genresLengthEqualTo(
    int length,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', length, true, length, true);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> genresIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', 0, true, 0, true);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> genresIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', 0, false, 999999, true);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  genresLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', 0, true, length, include);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  genresLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', length, include, 999999, true);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> genresLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  hoursLoggedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'hoursLogged'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  hoursLoggedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'hoursLogged'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> hoursLoggedEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'hoursLogged',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  hoursLoggedGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'hoursLogged',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> hoursLoggedLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'hoursLogged',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> hoursLoggedBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'hoursLogged',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> imageUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'imageUrl'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  imageUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'imageUrl'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> imageUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'imageUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> imageUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'imageUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> imageUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'imageUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'imageUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> imageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'imageUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> imageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'imageUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> imageUrlContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'imageUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> imageUrlMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'imageUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> imageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'imageUrl', value: ''),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  imageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'imageUrl', value: ''),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> isWishlistedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isWishlisted', value: value),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  manualProgressPercentageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'manualProgressPercentage'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  manualProgressPercentageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'manualProgressPercentage'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  manualProgressPercentageEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'manualProgressPercentage',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  manualProgressPercentageGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'manualProgressPercentage',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  manualProgressPercentageLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'manualProgressPercentage',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  manualProgressPercentageBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'manualProgressPercentage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'name'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'name'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> platformsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'platforms'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  platformsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'platforms'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  platformsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'platforms', length, true, length, true);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> platformsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'platforms', 0, true, 0, true);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  platformsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'platforms', 0, false, 999999, true);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  platformsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'platforms', 0, true, length, include);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  platformsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'platforms', length, include, 999999, true);
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

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> statusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'status'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> statusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'status'),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> statusEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> statusGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> statusLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> statusBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> statusContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> statusMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'status',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }
}

extension SavedGameQueryObject
    on QueryBuilder<SavedGame, SavedGame, QFilterCondition> {
  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  availablePlatformsElement(FilterQuery<SavedGamePlatform> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'availablePlatforms');
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> platformsElement(
    FilterQuery<SavedGamePlatform> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'platforms');
    });
  }
}

extension SavedGameQueryLinks
    on QueryBuilder<SavedGame, SavedGame, QFilterCondition> {
  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> groupTasks(
    FilterQuery<GroupTask> q,
  ) {
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
  groupTasksLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'groupTasks', 0, true, length, include);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
  groupTasksLengthGreaterThan(int length, {bool include = false}) {
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
        r'groupTasks',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension SavedGameQuerySortBy on QueryBuilder<SavedGame, SavedGame, QSortBy> {
  QueryBuilder<SavedGame, SavedGame, QAfterSortBy>
  sortByAverageCompletionHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageCompletionHours', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy>
  sortByAverageCompletionHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageCompletionHours', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByDateModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateModified', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByDateModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateModified', Sort.desc);
    });
  }

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

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByHoursLogged() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursLogged', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByHoursLoggedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursLogged', Sort.desc);
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

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByIsWishlisted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWishlisted', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByIsWishlistedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWishlisted', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy>
  sortByManualProgressPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manualProgressPercentage', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy>
  sortByManualProgressPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manualProgressPercentage', Sort.desc);
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

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension SavedGameQuerySortThenBy
    on QueryBuilder<SavedGame, SavedGame, QSortThenBy> {
  QueryBuilder<SavedGame, SavedGame, QAfterSortBy>
  thenByAverageCompletionHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageCompletionHours', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy>
  thenByAverageCompletionHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageCompletionHours', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByDateModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateModified', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByDateModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateModified', Sort.desc);
    });
  }

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

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByHoursLogged() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursLogged', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByHoursLoggedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursLogged', Sort.desc);
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

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByIsWishlisted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWishlisted', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByIsWishlistedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWishlisted', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy>
  thenByManualProgressPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manualProgressPercentage', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy>
  thenByManualProgressPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manualProgressPercentage', Sort.desc);
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

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension SavedGameQueryWhereDistinct
    on QueryBuilder<SavedGame, SavedGame, QDistinct> {
  QueryBuilder<SavedGame, SavedGame, QDistinct>
  distinctByAverageCompletionHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageCompletionHours');
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completed');
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByDateModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateModified');
    });
  }

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

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByGameSlug({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gameSlug', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByGenres() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'genres');
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByHoursLogged() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hoursLogged');
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByImageUrl({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByIsWishlisted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isWishlisted');
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct>
  distinctByManualProgressPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'manualProgressPercentage');
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByStatus({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
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

  QueryBuilder<SavedGame, List<SavedGamePlatform>?, QQueryOperations>
  availablePlatformsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'availablePlatforms');
    });
  }

  QueryBuilder<SavedGame, double?, QQueryOperations>
  averageCompletionHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageCompletionHours');
    });
  }

  QueryBuilder<SavedGame, bool, QQueryOperations> completedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completed');
    });
  }

  QueryBuilder<SavedGame, DateTime?, QQueryOperations> dateModifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateModified');
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

  QueryBuilder<SavedGame, List<int>?, QQueryOperations> genresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'genres');
    });
  }

  QueryBuilder<SavedGame, double?, QQueryOperations> hoursLoggedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hoursLogged');
    });
  }

  QueryBuilder<SavedGame, String?, QQueryOperations> imageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageUrl');
    });
  }

  QueryBuilder<SavedGame, bool, QQueryOperations> isWishlistedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isWishlisted');
    });
  }

  QueryBuilder<SavedGame, double?, QQueryOperations>
  manualProgressPercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'manualProgressPercentage');
    });
  }

  QueryBuilder<SavedGame, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<SavedGame, List<SavedGamePlatform>?, QQueryOperations>
  platformsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'platforms');
    });
  }

  QueryBuilder<SavedGame, String?, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SavedGamePlatformSchema = Schema(
  name: r'SavedGamePlatform',
  id: 1424528807746235984,
  properties: {
    r'abbreviation': PropertySchema(
      id: 0,
      name: r'abbreviation',
      type: IsarType.string,
    ),
    r'id': PropertySchema(id: 1, name: r'id', type: IsarType.long),
    r'logoUrl': PropertySchema(id: 2, name: r'logoUrl', type: IsarType.string),
    r'name': PropertySchema(id: 3, name: r'name', type: IsarType.string),
  },

  estimateSize: _savedGamePlatformEstimateSize,
  serialize: _savedGamePlatformSerialize,
  deserialize: _savedGamePlatformDeserialize,
  deserializeProp: _savedGamePlatformDeserializeProp,
);

int _savedGamePlatformEstimateSize(
  SavedGamePlatform object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.abbreviation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.logoUrl;
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
  return bytesCount;
}

void _savedGamePlatformSerialize(
  SavedGamePlatform object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.abbreviation);
  writer.writeLong(offsets[1], object.id);
  writer.writeString(offsets[2], object.logoUrl);
  writer.writeString(offsets[3], object.name);
}

SavedGamePlatform _savedGamePlatformDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SavedGamePlatform(
    abbreviation: reader.readStringOrNull(offsets[0]),
    id: reader.readLongOrNull(offsets[1]),
    logoUrl: reader.readStringOrNull(offsets[2]),
    name: reader.readStringOrNull(offsets[3]),
  );
  return object;
}

P _savedGamePlatformDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SavedGamePlatformQueryFilter
    on QueryBuilder<SavedGamePlatform, SavedGamePlatform, QFilterCondition> {
  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  abbreviationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'abbreviation'),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  abbreviationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'abbreviation'),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  abbreviationEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'abbreviation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  abbreviationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'abbreviation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  abbreviationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'abbreviation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  abbreviationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'abbreviation',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  abbreviationStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'abbreviation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  abbreviationEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'abbreviation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  abbreviationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'abbreviation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  abbreviationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'abbreviation',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  abbreviationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'abbreviation', value: ''),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  abbreviationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'abbreviation', value: ''),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'id'),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'id'),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  idEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  idGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  idLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  logoUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'logoUrl'),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  logoUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'logoUrl'),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  logoUrlEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'logoUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  logoUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'logoUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  logoUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'logoUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  logoUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'logoUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  logoUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'logoUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  logoUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'logoUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  logoUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'logoUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  logoUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'logoUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  logoUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'logoUrl', value: ''),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  logoUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'logoUrl', value: ''),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'name'),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'name'),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  nameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<SavedGamePlatform, SavedGamePlatform, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }
}

extension SavedGamePlatformQueryObject
    on QueryBuilder<SavedGamePlatform, SavedGamePlatform, QFilterCondition> {}

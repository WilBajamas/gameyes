// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_session_log.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlaySessionLogCollection on Isar {
  IsarCollection<PlaySessionLog> get playSessionLogs => this.collection();
}

const PlaySessionLogSchema = CollectionSchema(
  name: r'PlaySessionLog',
  id: 7432748903214683029,
  properties: {
    r'gameId': PropertySchema(id: 0, name: r'gameId', type: IsarType.long),
    r'hoursPlayed': PropertySchema(
      id: 1,
      name: r'hoursPlayed',
      type: IsarType.double,
    ),
    r'timestamp': PropertySchema(
      id: 2,
      name: r'timestamp',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _playSessionLogEstimateSize,
  serialize: _playSessionLogSerialize,
  deserialize: _playSessionLogDeserialize,
  deserializeProp: _playSessionLogDeserializeProp,
  idName: r'id',
  indexes: {
    r'gameId': IndexSchema(
      id: -1012023815008531514,
      name: r'gameId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'gameId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'timestamp': IndexSchema(
      id: 1852253767416892198,
      name: r'timestamp',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'timestamp',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _playSessionLogGetId,
  getLinks: _playSessionLogGetLinks,
  attach: _playSessionLogAttach,
  version: '3.3.2',
);

int _playSessionLogEstimateSize(
  PlaySessionLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _playSessionLogSerialize(
  PlaySessionLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.gameId);
  writer.writeDouble(offsets[1], object.hoursPlayed);
  writer.writeDateTime(offsets[2], object.timestamp);
}

PlaySessionLog _playSessionLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlaySessionLog(
    gameId: reader.readLongOrNull(offsets[0]),
    hoursPlayed: reader.readDoubleOrNull(offsets[1]),
    timestamp: reader.readDateTimeOrNull(offsets[2]),
  );
  object.id = id;
  return object;
}

P _playSessionLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _playSessionLogGetId(PlaySessionLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _playSessionLogGetLinks(PlaySessionLog object) {
  return [];
}

void _playSessionLogAttach(
  IsarCollection<dynamic> col,
  Id id,
  PlaySessionLog object,
) {
  object.id = id;
}

extension PlaySessionLogQueryWhereSort
    on QueryBuilder<PlaySessionLog, PlaySessionLog, QWhere> {
  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhere> anyGameId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'gameId'),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhere> anyTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestamp'),
      );
    });
  }
}

extension PlaySessionLogQueryWhere
    on QueryBuilder<PlaySessionLog, PlaySessionLog, QWhereClause> {
  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhereClause> idBetween(
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

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhereClause>
  gameIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'gameId', value: [null]),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhereClause>
  gameIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'gameId',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhereClause> gameIdEqualTo(
    int? gameId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'gameId', value: [gameId]),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhereClause>
  gameIdNotEqualTo(int? gameId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'gameId',
                lower: [],
                upper: [gameId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'gameId',
                lower: [gameId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'gameId',
                lower: [gameId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'gameId',
                lower: [],
                upper: [gameId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhereClause>
  gameIdGreaterThan(int? gameId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'gameId',
          lower: [gameId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhereClause>
  gameIdLessThan(int? gameId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'gameId',
          lower: [],
          upper: [gameId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhereClause> gameIdBetween(
    int? lowerGameId,
    int? upperGameId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'gameId',
          lower: [lowerGameId],
          includeLower: includeLower,
          upper: [upperGameId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhereClause>
  timestampIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'timestamp', value: [null]),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhereClause>
  timestampIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'timestamp',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhereClause>
  timestampEqualTo(DateTime? timestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'timestamp', value: [timestamp]),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhereClause>
  timestampNotEqualTo(DateTime? timestamp) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestamp',
                lower: [],
                upper: [timestamp],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestamp',
                lower: [timestamp],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestamp',
                lower: [timestamp],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestamp',
                lower: [],
                upper: [timestamp],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhereClause>
  timestampGreaterThan(DateTime? timestamp, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'timestamp',
          lower: [timestamp],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhereClause>
  timestampLessThan(DateTime? timestamp, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'timestamp',
          lower: [],
          upper: [timestamp],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterWhereClause>
  timestampBetween(
    DateTime? lowerTimestamp,
    DateTime? upperTimestamp, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'timestamp',
          lower: [lowerTimestamp],
          includeLower: includeLower,
          upper: [upperTimestamp],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PlaySessionLogQueryFilter
    on QueryBuilder<PlaySessionLog, PlaySessionLog, QFilterCondition> {
  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition>
  gameIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'gameId'),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition>
  gameIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'gameId'),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition>
  gameIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'gameId', value: value),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition>
  gameIdGreaterThan(int? value, {bool include = false}) {
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

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition>
  gameIdLessThan(int? value, {bool include = false}) {
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

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition>
  gameIdBetween(
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

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition>
  hoursPlayedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'hoursPlayed'),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition>
  hoursPlayedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'hoursPlayed'),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition>
  hoursPlayedEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'hoursPlayed',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition>
  hoursPlayedGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'hoursPlayed',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition>
  hoursPlayedLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'hoursPlayed',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition>
  hoursPlayedBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'hoursPlayed',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
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

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
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

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition>
  timestampIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'timestamp'),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition>
  timestampIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'timestamp'),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition>
  timestampEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timestamp', value: value),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition>
  timestampGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'timestamp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition>
  timestampLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'timestamp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterFilterCondition>
  timestampBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'timestamp',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PlaySessionLogQueryObject
    on QueryBuilder<PlaySessionLog, PlaySessionLog, QFilterCondition> {}

extension PlaySessionLogQueryLinks
    on QueryBuilder<PlaySessionLog, PlaySessionLog, QFilterCondition> {}

extension PlaySessionLogQuerySortBy
    on QueryBuilder<PlaySessionLog, PlaySessionLog, QSortBy> {
  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterSortBy> sortByGameId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameId', Sort.asc);
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterSortBy>
  sortByGameIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameId', Sort.desc);
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterSortBy>
  sortByHoursPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursPlayed', Sort.asc);
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterSortBy>
  sortByHoursPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursPlayed', Sort.desc);
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterSortBy>
  sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension PlaySessionLogQuerySortThenBy
    on QueryBuilder<PlaySessionLog, PlaySessionLog, QSortThenBy> {
  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterSortBy> thenByGameId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameId', Sort.asc);
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterSortBy>
  thenByGameIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameId', Sort.desc);
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterSortBy>
  thenByHoursPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursPlayed', Sort.asc);
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterSortBy>
  thenByHoursPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursPlayed', Sort.desc);
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QAfterSortBy>
  thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension PlaySessionLogQueryWhereDistinct
    on QueryBuilder<PlaySessionLog, PlaySessionLog, QDistinct> {
  QueryBuilder<PlaySessionLog, PlaySessionLog, QDistinct> distinctByGameId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gameId');
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QDistinct>
  distinctByHoursPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hoursPlayed');
    });
  }

  QueryBuilder<PlaySessionLog, PlaySessionLog, QDistinct>
  distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }
}

extension PlaySessionLogQueryProperty
    on QueryBuilder<PlaySessionLog, PlaySessionLog, QQueryProperty> {
  QueryBuilder<PlaySessionLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlaySessionLog, int?, QQueryOperations> gameIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gameId');
    });
  }

  QueryBuilder<PlaySessionLog, double?, QQueryOperations>
  hoursPlayedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hoursPlayed');
    });
  }

  QueryBuilder<PlaySessionLog, DateTime?, QQueryOperations>
  timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }
}

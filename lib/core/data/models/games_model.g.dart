// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'games_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GamesModel _$GamesModelFromJson(Map<String, dynamic> json) => _GamesModel(
  count: (json['count'] as num).toInt(),
  currentPage: (json['currentPage'] as num?)?.toInt(),
  next: json['next'] as String?,
  results: (json['results'] as List<dynamic>?)
      ?.map((e) => Game.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GamesModelToJson(_GamesModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'currentPage': instance.currentPage,
      'next': instance.next,
      'results': instance.results,
    };

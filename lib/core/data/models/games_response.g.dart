// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'games_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GamesResponse _$GamesResponseFromJson(Map<String, dynamic> json) =>
    _GamesResponse(
      count: (json['count'] as num).toInt(),
      currentPage: (json['currentPage'] as num?)?.toInt(),
      next: json['next'] as String?,
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => Game.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GamesResponseToJson(_GamesResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'currentPage': instance.currentPage,
      'next': instance.next,
      'results': instance.results,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'games_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GamesResponse _$GamesResponseFromJson(Map<String, dynamic> json) =>
    GamesResponse(
      (json['count'] as num).toInt(),
      (json['results'] as List<dynamic>?)
          ?.map((e) => Game.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['next'] as String?,
      (json['currentPage'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GamesResponseToJson(GamesResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'currentPage': instance.currentPage,
      'next': instance.next,
      'results': instance.results,
    };

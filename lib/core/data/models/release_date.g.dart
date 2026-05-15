// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReleaseDate _$ReleaseDateFromJson(Map<String, dynamic> json) => _ReleaseDate(
      date: (json['date'] as num?)?.toInt(),
      human: json['human'] as String?,
    );

Map<String, dynamic> _$ReleaseDateToJson(_ReleaseDate instance) =>
    <String, dynamic>{
      'date': instance.date,
      'human': instance.human,
    };

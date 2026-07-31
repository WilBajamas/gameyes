// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Platform _$PlatformFromJson(Map<String, dynamic> json) => _Platform(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      abbreviation: json['abbreviation'] as String?,
      platformLogo: json['platform_logo'] == null
          ? null
          : PlatformLogo.fromJson(
              json['platform_logo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlatformToJson(_Platform instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'abbreviation': instance.abbreviation,
      'platform_logo': instance.platformLogo,
    };

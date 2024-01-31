// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screenshot_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScreenshotResponse _$ScreenshotResponseFromJson(Map<String, dynamic> json) =>
    ScreenshotResponse(
      (json['results'] as List<dynamic>)
          .map((e) => Screenshot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ScreenshotResponseToJson(ScreenshotResponse instance) =>
    <String, dynamic>{
      'results': instance.results,
    };

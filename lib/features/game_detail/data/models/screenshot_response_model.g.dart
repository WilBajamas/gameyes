// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screenshot_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScreenshotResponseModel _$ScreenshotResponseModelFromJson(
  Map<String, dynamic> json,
) => _ScreenshotResponseModel(
  results: (json['results'] as List<dynamic>)
      .map((e) => Screenshot.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ScreenshotResponseModelToJson(
  _ScreenshotResponseModel instance,
) => <String, dynamic>{'results': instance.results};

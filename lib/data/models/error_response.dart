import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';

@JsonSerializable()
class ErrorResponse extends Equatable {
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'statusCode')
  final int? statusCode;
  @JsonKey(name: 'error')
  final String? error;

  const ErrorResponse({
    this.message = '',
    required this.statusCode,
    required this.error,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

  @override
  List<Object?> get props => [message, statusCode, error];
}

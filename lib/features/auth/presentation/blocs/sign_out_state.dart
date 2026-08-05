import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';

part 'sign_out_state.freezed.dart';

enum SignOutStatus { idle, loading, failed }

@freezed
sealed class SignOutState with _$SignOutState {
  const factory SignOutState({
    @Default(SignOutStatus.idle) SignOutStatus status,
    ErrorType? error,
  }) = _SignOutState;
}

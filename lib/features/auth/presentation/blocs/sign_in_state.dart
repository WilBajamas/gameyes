import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/sign_in_provider.dart';

part 'sign_in_state.freezed.dart';

enum SignInStatus { idle, loading, failed }

@freezed
sealed class SignInState with _$SignInState {
  const factory SignInState({
    @Default(SignInStatus.idle) SignInStatus status,
    SignInProvider? activeProvider,
    ErrorType? error,
  }) = _SignInState;
}

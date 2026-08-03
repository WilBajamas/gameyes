import 'package:freezed_annotation/freezed_annotation.dart';

part 'welcome_state.freezed.dart';

enum WelcomeStep { one, two }

enum WelcomeStatus { inProgress, finished }

@freezed
sealed class WelcomeState with _$WelcomeState {
  const factory WelcomeState({
    @Default(WelcomeStep.one) WelcomeStep step,
    @Default(WelcomeStatus.inProgress) WelcomeStatus status,
  }) = _WelcomeState;
}

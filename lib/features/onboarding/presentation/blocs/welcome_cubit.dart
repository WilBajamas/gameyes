import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/blocs/welcome_state.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit(this._preferences) : super(const WelcomeState());

  final SharedPreferences _preferences;

  void next() {
    emit(state.copyWith(step: WelcomeStep.two));
  }

  void back() {
    emit(state.copyWith(step: WelcomeStep.one));
  }

  Future<void> finish() async {
    await _preferences.setBool(StorageConstants.firstUseKey, true);
    emit(state.copyWith(status: WelcomeStatus.finished));
  }
}

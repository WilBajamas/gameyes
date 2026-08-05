import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:injectable/injectable.dart';

import 'sign_out_state.dart';

@injectable
class SignOutCubit extends Cubit<SignOutState> {
  SignOutCubit(this._signOut) : super(const SignOutState());

  final SignOutUseCase _signOut;

  Future<void> signOut() async {
    if (state.status == SignOutStatus.loading) return;

    emit(const SignOutState(status: SignOutStatus.loading));

    final result = await _signOut();
    // The redirect can dispose this screen before the call comes back.
    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(const SignOutState());
      case Failure<void>(error: final error):
        emit(SignOutState(status: SignOutStatus.failed, error: error));
    }
  }
}

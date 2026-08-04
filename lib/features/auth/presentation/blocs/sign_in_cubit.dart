import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/sign_in_provider.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:injectable/injectable.dart';

import 'sign_in_state.dart';

@injectable
class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._signIn) : super(const SignInState());

  final SignInUseCase _signIn;

  Future<void> signIn(SignInProvider provider) async {
    if (state.status == SignInStatus.loading) return;

    emit(SignInState(status: SignInStatus.loading, activeProvider: provider));

    final result = await _signIn(provider);
    switch (result) {
      case Success<void>():
        emit(const SignInState());
      case Failure<void>(error: SignInCancelled()):
        emit(const SignInState());
      case Failure<void>(error: final error):
        emit(SignInState(status: SignInStatus.failed, error: error));
    }
  }
}

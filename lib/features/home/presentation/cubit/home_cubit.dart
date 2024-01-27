import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void selectScreenTab(int index) =>
      emit(state.copyWith(currentTabScreen: CurrentTabScreen.values[index]));
}

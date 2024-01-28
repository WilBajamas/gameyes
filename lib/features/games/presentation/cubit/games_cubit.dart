import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'games_state.dart';

class GamesCubit extends Cubit<GamesState> {
  GamesCubit() : super(GamesInitial());
}

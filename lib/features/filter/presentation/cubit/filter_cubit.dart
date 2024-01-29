import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/features/filter/data/models/games_platform.dart';
import 'package:injectable/injectable.dart';

part 'filter_state.dart';

@injectable
class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterInitial());

  // void setInitialFilterValue(JobFilterValue? filterValue) {
  //   emit(
  //     state.copyWith(
  //       searchTerm: filterValue?.searchTerm,
  //       dateFrom: filterValue?.minSalary,
  //       dateTo: filterValue?.maxSalary,
  //       jobType: filterValue?.jobTypeSelected,
  //       contractType: filterValue?.contractTypeSelected,
  //       experienceType: filterValue?.experienceTypeSelected,
  //     ),
  //   );
  // }

  void changeSelectionValue({
    GamesPlatform? platform,
    GameOrdering? ordering,
    String? searchTerm,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) {
    emit(
      state.copyWith(
        gameOrdering: ordering,
        gamesPlatform: platform,
        searchTerm: searchTerm,
        dateFrom: dateFrom,
        dateTo: dateTo,
      ),
    );
  }
}

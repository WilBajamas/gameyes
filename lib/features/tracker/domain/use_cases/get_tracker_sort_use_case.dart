import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repositories/tracker_sort_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTrackerSortUseCase {
  final TrackerSortRepository _repository;

  GetTrackerSortUseCase(this._repository);

  SavedGameFilterTag call() => _repository.getSortTag();
}

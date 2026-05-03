import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_list_entity.dart';
import 'package:gaming_library_assessment_flutter/core/enums/featured_tag.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';

part 'featured_state.freezed.dart';

enum FeaturedStatus { initial, success, failed, empty, loading }

enum FeaturedNextPageStatus { initial, failed, loading }

@freezed
sealed class FeaturedState with _$FeaturedState {
  const factory FeaturedState({
    @Default(FeaturedTag.newAndTrending) FeaturedTag tag,
    @Default(<GamePlatform>{}) Set<GamePlatform> platformsSelected,
    @Default(FeaturedStatus.initial) FeaturedStatus? status,
    @Default(1) int currentPage,
    @Default(FeaturedNextPageStatus.initial)
    FeaturedNextPageStatus? nextPageStatus,
    GameListEntity? response,
    @Default(<GameEntity>[]) List<GameEntity> games,
    ErrorType? error,
    ErrorType? nextPageError,
  }) = _FeaturedState;
}

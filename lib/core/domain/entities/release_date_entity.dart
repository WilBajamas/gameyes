import 'package:freezed_annotation/freezed_annotation.dart';

part 'release_date_entity.freezed.dart';

@freezed
sealed class ReleaseDateEntity with _$ReleaseDateEntity {
  const factory ReleaseDateEntity({
    required DateTime date,
    required String human,
  }) = _ReleaseDateEntity;
}

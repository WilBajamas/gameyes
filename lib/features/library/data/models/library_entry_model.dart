import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/features/library/const.dart';
import 'package:gaming_library_assessment_flutter/features/library/data/models/library_status_column.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_entry_entity.dart';

part 'library_entry_model.freezed.dart';
part 'library_entry_model.g.dart';

@freezed
sealed class LibraryEntryModel with _$LibraryEntryModel {
  const LibraryEntryModel._();

  const factory LibraryEntryModel({
    @JsonKey(name: LibraryEntryConstants.id) required String id,
    @JsonKey(name: LibraryEntryConstants.userId) required String userId,
    @JsonKey(name: LibraryEntryConstants.igdbId) required int igdbId,
    @JsonKey(name: LibraryEntryConstants.title) required String title,
    @JsonKey(name: LibraryEntryConstants.coverUrl) String? coverUrl,
    @JsonKey(name: LibraryEntryConstants.releaseDate) DateTime? releaseDate,
    @JsonKey(name: LibraryEntryConstants.status) required String status,
    @JsonKey(name: LibraryEntryConstants.createdAt) required DateTime createdAt,
    @JsonKey(name: LibraryEntryConstants.platform) String? platform,
    @JsonKey(name: LibraryEntryConstants.rating) int? rating,
    @JsonKey(name: LibraryEntryConstants.playtimeHours) double? playtimeHours,
    @JsonKey(name: LibraryEntryConstants.progressPercent)
    double? progressPercent,
    @JsonKey(name: LibraryEntryConstants.genre) String? genre,
    @JsonKey(name: LibraryEntryConstants.updatedAt) required DateTime updatedAt,
  }) = _LibraryEntryModel;

  factory LibraryEntryModel.fromJson(Map<String, dynamic> json) =>
      _$LibraryEntryModelFromJson(json);

  LibraryEntryEntity toEntity() {
    final parsed = LibraryStatusColumn.fromColumnValue(status);
    // A status the app does not know is a broken row, not a reason to show
    // the person a status they never chose.
    if (parsed == null) {
      throw FormatException('Unknown library status', status);
    }

    return LibraryEntryEntity(
      id: id,
      igdbId: igdbId,
      title: title,
      coverUrl: coverUrl,
      releaseDate: releaseDate,
      status: parsed,
      createdAt: createdAt,
      platform: platform,
      rating: rating,
      playtimeHours: playtimeHours,
      progressPercent: progressPercent,
      genre: genre,
      updatedAt: updatedAt,
    );
  }
}

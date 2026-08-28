// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryEntryModel {

@JsonKey(name: LibraryEntryConstants.id) String get id;@JsonKey(name: LibraryEntryConstants.userId) String get userId;@JsonKey(name: LibraryEntryConstants.igdbId) int get igdbId;@JsonKey(name: LibraryEntryConstants.title) String get title;@JsonKey(name: LibraryEntryConstants.coverUrl) String? get coverUrl;@JsonKey(name: LibraryEntryConstants.releaseDate) DateTime? get releaseDate;@JsonKey(name: LibraryEntryConstants.status) String get status;@JsonKey(name: LibraryEntryConstants.createdAt) DateTime get createdAt;@JsonKey(name: LibraryEntryConstants.platform) String? get platform;@JsonKey(name: LibraryEntryConstants.rating) int? get rating;@JsonKey(name: LibraryEntryConstants.playtimeHours) double? get playtimeHours;@JsonKey(name: LibraryEntryConstants.progressPercent) double? get progressPercent;@JsonKey(name: LibraryEntryConstants.genre) String? get genre;@JsonKey(name: LibraryEntryConstants.updatedAt) DateTime get updatedAt;
/// Create a copy of LibraryEntryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryEntryModelCopyWith<LibraryEntryModel> get copyWith => _$LibraryEntryModelCopyWithImpl<LibraryEntryModel>(this as LibraryEntryModel, _$identity);

  /// Serializes this LibraryEntryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryEntryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.igdbId, igdbId) || other.igdbId == igdbId)&&(identical(other.title, title) || other.title == title)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.playtimeHours, playtimeHours) || other.playtimeHours == playtimeHours)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,igdbId,title,coverUrl,releaseDate,status,createdAt,platform,rating,playtimeHours,progressPercent,genre,updatedAt);

@override
String toString() {
  return 'LibraryEntryModel(id: $id, userId: $userId, igdbId: $igdbId, title: $title, coverUrl: $coverUrl, releaseDate: $releaseDate, status: $status, createdAt: $createdAt, platform: $platform, rating: $rating, playtimeHours: $playtimeHours, progressPercent: $progressPercent, genre: $genre, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $LibraryEntryModelCopyWith<$Res>  {
  factory $LibraryEntryModelCopyWith(LibraryEntryModel value, $Res Function(LibraryEntryModel) _then) = _$LibraryEntryModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: LibraryEntryConstants.id) String id,@JsonKey(name: LibraryEntryConstants.userId) String userId,@JsonKey(name: LibraryEntryConstants.igdbId) int igdbId,@JsonKey(name: LibraryEntryConstants.title) String title,@JsonKey(name: LibraryEntryConstants.coverUrl) String? coverUrl,@JsonKey(name: LibraryEntryConstants.releaseDate) DateTime? releaseDate,@JsonKey(name: LibraryEntryConstants.status) String status,@JsonKey(name: LibraryEntryConstants.createdAt) DateTime createdAt,@JsonKey(name: LibraryEntryConstants.platform) String? platform,@JsonKey(name: LibraryEntryConstants.rating) int? rating,@JsonKey(name: LibraryEntryConstants.playtimeHours) double? playtimeHours,@JsonKey(name: LibraryEntryConstants.progressPercent) double? progressPercent,@JsonKey(name: LibraryEntryConstants.genre) String? genre,@JsonKey(name: LibraryEntryConstants.updatedAt) DateTime updatedAt
});




}
/// @nodoc
class _$LibraryEntryModelCopyWithImpl<$Res>
    implements $LibraryEntryModelCopyWith<$Res> {
  _$LibraryEntryModelCopyWithImpl(this._self, this._then);

  final LibraryEntryModel _self;
  final $Res Function(LibraryEntryModel) _then;

/// Create a copy of LibraryEntryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? igdbId = null,Object? title = null,Object? coverUrl = freezed,Object? releaseDate = freezed,Object? status = null,Object? createdAt = null,Object? platform = freezed,Object? rating = freezed,Object? playtimeHours = freezed,Object? progressPercent = freezed,Object? genre = freezed,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,igdbId: null == igdbId ? _self.igdbId : igdbId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,playtimeHours: freezed == playtimeHours ? _self.playtimeHours : playtimeHours // ignore: cast_nullable_to_non_nullable
as double?,progressPercent: freezed == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as double?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LibraryEntryModel].
extension LibraryEntryModelPatterns on LibraryEntryModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryEntryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryEntryModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryEntryModel value)  $default,){
final _that = this;
switch (_that) {
case _LibraryEntryModel():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryEntryModel value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryEntryModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: LibraryEntryConstants.id)  String id, @JsonKey(name: LibraryEntryConstants.userId)  String userId, @JsonKey(name: LibraryEntryConstants.igdbId)  int igdbId, @JsonKey(name: LibraryEntryConstants.title)  String title, @JsonKey(name: LibraryEntryConstants.coverUrl)  String? coverUrl, @JsonKey(name: LibraryEntryConstants.releaseDate)  DateTime? releaseDate, @JsonKey(name: LibraryEntryConstants.status)  String status, @JsonKey(name: LibraryEntryConstants.createdAt)  DateTime createdAt, @JsonKey(name: LibraryEntryConstants.platform)  String? platform, @JsonKey(name: LibraryEntryConstants.rating)  int? rating, @JsonKey(name: LibraryEntryConstants.playtimeHours)  double? playtimeHours, @JsonKey(name: LibraryEntryConstants.progressPercent)  double? progressPercent, @JsonKey(name: LibraryEntryConstants.genre)  String? genre, @JsonKey(name: LibraryEntryConstants.updatedAt)  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryEntryModel() when $default != null:
return $default(_that.id,_that.userId,_that.igdbId,_that.title,_that.coverUrl,_that.releaseDate,_that.status,_that.createdAt,_that.platform,_that.rating,_that.playtimeHours,_that.progressPercent,_that.genre,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: LibraryEntryConstants.id)  String id, @JsonKey(name: LibraryEntryConstants.userId)  String userId, @JsonKey(name: LibraryEntryConstants.igdbId)  int igdbId, @JsonKey(name: LibraryEntryConstants.title)  String title, @JsonKey(name: LibraryEntryConstants.coverUrl)  String? coverUrl, @JsonKey(name: LibraryEntryConstants.releaseDate)  DateTime? releaseDate, @JsonKey(name: LibraryEntryConstants.status)  String status, @JsonKey(name: LibraryEntryConstants.createdAt)  DateTime createdAt, @JsonKey(name: LibraryEntryConstants.platform)  String? platform, @JsonKey(name: LibraryEntryConstants.rating)  int? rating, @JsonKey(name: LibraryEntryConstants.playtimeHours)  double? playtimeHours, @JsonKey(name: LibraryEntryConstants.progressPercent)  double? progressPercent, @JsonKey(name: LibraryEntryConstants.genre)  String? genre, @JsonKey(name: LibraryEntryConstants.updatedAt)  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _LibraryEntryModel():
return $default(_that.id,_that.userId,_that.igdbId,_that.title,_that.coverUrl,_that.releaseDate,_that.status,_that.createdAt,_that.platform,_that.rating,_that.playtimeHours,_that.progressPercent,_that.genre,_that.updatedAt);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: LibraryEntryConstants.id)  String id, @JsonKey(name: LibraryEntryConstants.userId)  String userId, @JsonKey(name: LibraryEntryConstants.igdbId)  int igdbId, @JsonKey(name: LibraryEntryConstants.title)  String title, @JsonKey(name: LibraryEntryConstants.coverUrl)  String? coverUrl, @JsonKey(name: LibraryEntryConstants.releaseDate)  DateTime? releaseDate, @JsonKey(name: LibraryEntryConstants.status)  String status, @JsonKey(name: LibraryEntryConstants.createdAt)  DateTime createdAt, @JsonKey(name: LibraryEntryConstants.platform)  String? platform, @JsonKey(name: LibraryEntryConstants.rating)  int? rating, @JsonKey(name: LibraryEntryConstants.playtimeHours)  double? playtimeHours, @JsonKey(name: LibraryEntryConstants.progressPercent)  double? progressPercent, @JsonKey(name: LibraryEntryConstants.genre)  String? genre, @JsonKey(name: LibraryEntryConstants.updatedAt)  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _LibraryEntryModel() when $default != null:
return $default(_that.id,_that.userId,_that.igdbId,_that.title,_that.coverUrl,_that.releaseDate,_that.status,_that.createdAt,_that.platform,_that.rating,_that.playtimeHours,_that.progressPercent,_that.genre,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LibraryEntryModel extends LibraryEntryModel {
  const _LibraryEntryModel({@JsonKey(name: LibraryEntryConstants.id) required this.id, @JsonKey(name: LibraryEntryConstants.userId) required this.userId, @JsonKey(name: LibraryEntryConstants.igdbId) required this.igdbId, @JsonKey(name: LibraryEntryConstants.title) required this.title, @JsonKey(name: LibraryEntryConstants.coverUrl) this.coverUrl, @JsonKey(name: LibraryEntryConstants.releaseDate) this.releaseDate, @JsonKey(name: LibraryEntryConstants.status) required this.status, @JsonKey(name: LibraryEntryConstants.createdAt) required this.createdAt, @JsonKey(name: LibraryEntryConstants.platform) this.platform, @JsonKey(name: LibraryEntryConstants.rating) this.rating, @JsonKey(name: LibraryEntryConstants.playtimeHours) this.playtimeHours, @JsonKey(name: LibraryEntryConstants.progressPercent) this.progressPercent, @JsonKey(name: LibraryEntryConstants.genre) this.genre, @JsonKey(name: LibraryEntryConstants.updatedAt) required this.updatedAt}): super._();
  factory _LibraryEntryModel.fromJson(Map<String, dynamic> json) => _$LibraryEntryModelFromJson(json);

@override@JsonKey(name: LibraryEntryConstants.id) final  String id;
@override@JsonKey(name: LibraryEntryConstants.userId) final  String userId;
@override@JsonKey(name: LibraryEntryConstants.igdbId) final  int igdbId;
@override@JsonKey(name: LibraryEntryConstants.title) final  String title;
@override@JsonKey(name: LibraryEntryConstants.coverUrl) final  String? coverUrl;
@override@JsonKey(name: LibraryEntryConstants.releaseDate) final  DateTime? releaseDate;
@override@JsonKey(name: LibraryEntryConstants.status) final  String status;
@override@JsonKey(name: LibraryEntryConstants.createdAt) final  DateTime createdAt;
@override@JsonKey(name: LibraryEntryConstants.platform) final  String? platform;
@override@JsonKey(name: LibraryEntryConstants.rating) final  int? rating;
@override@JsonKey(name: LibraryEntryConstants.playtimeHours) final  double? playtimeHours;
@override@JsonKey(name: LibraryEntryConstants.progressPercent) final  double? progressPercent;
@override@JsonKey(name: LibraryEntryConstants.genre) final  String? genre;
@override@JsonKey(name: LibraryEntryConstants.updatedAt) final  DateTime updatedAt;

/// Create a copy of LibraryEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryEntryModelCopyWith<_LibraryEntryModel> get copyWith => __$LibraryEntryModelCopyWithImpl<_LibraryEntryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryEntryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryEntryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.igdbId, igdbId) || other.igdbId == igdbId)&&(identical(other.title, title) || other.title == title)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.playtimeHours, playtimeHours) || other.playtimeHours == playtimeHours)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,igdbId,title,coverUrl,releaseDate,status,createdAt,platform,rating,playtimeHours,progressPercent,genre,updatedAt);

@override
String toString() {
  return 'LibraryEntryModel(id: $id, userId: $userId, igdbId: $igdbId, title: $title, coverUrl: $coverUrl, releaseDate: $releaseDate, status: $status, createdAt: $createdAt, platform: $platform, rating: $rating, playtimeHours: $playtimeHours, progressPercent: $progressPercent, genre: $genre, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$LibraryEntryModelCopyWith<$Res> implements $LibraryEntryModelCopyWith<$Res> {
  factory _$LibraryEntryModelCopyWith(_LibraryEntryModel value, $Res Function(_LibraryEntryModel) _then) = __$LibraryEntryModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: LibraryEntryConstants.id) String id,@JsonKey(name: LibraryEntryConstants.userId) String userId,@JsonKey(name: LibraryEntryConstants.igdbId) int igdbId,@JsonKey(name: LibraryEntryConstants.title) String title,@JsonKey(name: LibraryEntryConstants.coverUrl) String? coverUrl,@JsonKey(name: LibraryEntryConstants.releaseDate) DateTime? releaseDate,@JsonKey(name: LibraryEntryConstants.status) String status,@JsonKey(name: LibraryEntryConstants.createdAt) DateTime createdAt,@JsonKey(name: LibraryEntryConstants.platform) String? platform,@JsonKey(name: LibraryEntryConstants.rating) int? rating,@JsonKey(name: LibraryEntryConstants.playtimeHours) double? playtimeHours,@JsonKey(name: LibraryEntryConstants.progressPercent) double? progressPercent,@JsonKey(name: LibraryEntryConstants.genre) String? genre,@JsonKey(name: LibraryEntryConstants.updatedAt) DateTime updatedAt
});




}
/// @nodoc
class __$LibraryEntryModelCopyWithImpl<$Res>
    implements _$LibraryEntryModelCopyWith<$Res> {
  __$LibraryEntryModelCopyWithImpl(this._self, this._then);

  final _LibraryEntryModel _self;
  final $Res Function(_LibraryEntryModel) _then;

/// Create a copy of LibraryEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? igdbId = null,Object? title = null,Object? coverUrl = freezed,Object? releaseDate = freezed,Object? status = null,Object? createdAt = null,Object? platform = freezed,Object? rating = freezed,Object? playtimeHours = freezed,Object? progressPercent = freezed,Object? genre = freezed,Object? updatedAt = null,}) {
  return _then(_LibraryEntryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,igdbId: null == igdbId ? _self.igdbId : igdbId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,playtimeHours: freezed == playtimeHours ? _self.playtimeHours : playtimeHours // ignore: cast_nullable_to_non_nullable
as double?,progressPercent: freezed == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as double?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

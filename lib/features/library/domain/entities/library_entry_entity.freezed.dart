// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_entry_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LibraryEntryEntity {

 String get id; int get igdbId; String get title; String? get coverUrl; DateTime? get releaseDate; LibraryStatus get status; DateTime get createdAt; String? get platform; int? get rating; double? get playtimeHours; double? get progressPercent; String? get genre; DateTime get updatedAt;
/// Create a copy of LibraryEntryEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryEntryEntityCopyWith<LibraryEntryEntity> get copyWith => _$LibraryEntryEntityCopyWithImpl<LibraryEntryEntity>(this as LibraryEntryEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryEntryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.igdbId, igdbId) || other.igdbId == igdbId)&&(identical(other.title, title) || other.title == title)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.playtimeHours, playtimeHours) || other.playtimeHours == playtimeHours)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,igdbId,title,coverUrl,releaseDate,status,createdAt,platform,rating,playtimeHours,progressPercent,genre,updatedAt);

@override
String toString() {
  return 'LibraryEntryEntity(id: $id, igdbId: $igdbId, title: $title, coverUrl: $coverUrl, releaseDate: $releaseDate, status: $status, createdAt: $createdAt, platform: $platform, rating: $rating, playtimeHours: $playtimeHours, progressPercent: $progressPercent, genre: $genre, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $LibraryEntryEntityCopyWith<$Res>  {
  factory $LibraryEntryEntityCopyWith(LibraryEntryEntity value, $Res Function(LibraryEntryEntity) _then) = _$LibraryEntryEntityCopyWithImpl;
@useResult
$Res call({
 String id, int igdbId, String title, String? coverUrl, DateTime? releaseDate, LibraryStatus status, DateTime createdAt, String? platform, int? rating, double? playtimeHours, double? progressPercent, String? genre, DateTime updatedAt
});




}
/// @nodoc
class _$LibraryEntryEntityCopyWithImpl<$Res>
    implements $LibraryEntryEntityCopyWith<$Res> {
  _$LibraryEntryEntityCopyWithImpl(this._self, this._then);

  final LibraryEntryEntity _self;
  final $Res Function(LibraryEntryEntity) _then;

/// Create a copy of LibraryEntryEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? igdbId = null,Object? title = null,Object? coverUrl = freezed,Object? releaseDate = freezed,Object? status = null,Object? createdAt = null,Object? platform = freezed,Object? rating = freezed,Object? playtimeHours = freezed,Object? progressPercent = freezed,Object? genre = freezed,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,igdbId: null == igdbId ? _self.igdbId : igdbId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LibraryStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
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


/// Adds pattern-matching-related methods to [LibraryEntryEntity].
extension LibraryEntryEntityPatterns on LibraryEntryEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryEntryEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryEntryEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryEntryEntity value)  $default,){
final _that = this;
switch (_that) {
case _LibraryEntryEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryEntryEntity value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryEntryEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int igdbId,  String title,  String? coverUrl,  DateTime? releaseDate,  LibraryStatus status,  DateTime createdAt,  String? platform,  int? rating,  double? playtimeHours,  double? progressPercent,  String? genre,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryEntryEntity() when $default != null:
return $default(_that.id,_that.igdbId,_that.title,_that.coverUrl,_that.releaseDate,_that.status,_that.createdAt,_that.platform,_that.rating,_that.playtimeHours,_that.progressPercent,_that.genre,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int igdbId,  String title,  String? coverUrl,  DateTime? releaseDate,  LibraryStatus status,  DateTime createdAt,  String? platform,  int? rating,  double? playtimeHours,  double? progressPercent,  String? genre,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _LibraryEntryEntity():
return $default(_that.id,_that.igdbId,_that.title,_that.coverUrl,_that.releaseDate,_that.status,_that.createdAt,_that.platform,_that.rating,_that.playtimeHours,_that.progressPercent,_that.genre,_that.updatedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int igdbId,  String title,  String? coverUrl,  DateTime? releaseDate,  LibraryStatus status,  DateTime createdAt,  String? platform,  int? rating,  double? playtimeHours,  double? progressPercent,  String? genre,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _LibraryEntryEntity() when $default != null:
return $default(_that.id,_that.igdbId,_that.title,_that.coverUrl,_that.releaseDate,_that.status,_that.createdAt,_that.platform,_that.rating,_that.playtimeHours,_that.progressPercent,_that.genre,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _LibraryEntryEntity implements LibraryEntryEntity {
  const _LibraryEntryEntity({required this.id, required this.igdbId, required this.title, this.coverUrl, this.releaseDate, required this.status, required this.createdAt, this.platform, this.rating, this.playtimeHours, this.progressPercent, this.genre, required this.updatedAt});
  

@override final  String id;
@override final  int igdbId;
@override final  String title;
@override final  String? coverUrl;
@override final  DateTime? releaseDate;
@override final  LibraryStatus status;
@override final  DateTime createdAt;
@override final  String? platform;
@override final  int? rating;
@override final  double? playtimeHours;
@override final  double? progressPercent;
@override final  String? genre;
@override final  DateTime updatedAt;

/// Create a copy of LibraryEntryEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryEntryEntityCopyWith<_LibraryEntryEntity> get copyWith => __$LibraryEntryEntityCopyWithImpl<_LibraryEntryEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryEntryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.igdbId, igdbId) || other.igdbId == igdbId)&&(identical(other.title, title) || other.title == title)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.playtimeHours, playtimeHours) || other.playtimeHours == playtimeHours)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,igdbId,title,coverUrl,releaseDate,status,createdAt,platform,rating,playtimeHours,progressPercent,genre,updatedAt);

@override
String toString() {
  return 'LibraryEntryEntity(id: $id, igdbId: $igdbId, title: $title, coverUrl: $coverUrl, releaseDate: $releaseDate, status: $status, createdAt: $createdAt, platform: $platform, rating: $rating, playtimeHours: $playtimeHours, progressPercent: $progressPercent, genre: $genre, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$LibraryEntryEntityCopyWith<$Res> implements $LibraryEntryEntityCopyWith<$Res> {
  factory _$LibraryEntryEntityCopyWith(_LibraryEntryEntity value, $Res Function(_LibraryEntryEntity) _then) = __$LibraryEntryEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, int igdbId, String title, String? coverUrl, DateTime? releaseDate, LibraryStatus status, DateTime createdAt, String? platform, int? rating, double? playtimeHours, double? progressPercent, String? genre, DateTime updatedAt
});




}
/// @nodoc
class __$LibraryEntryEntityCopyWithImpl<$Res>
    implements _$LibraryEntryEntityCopyWith<$Res> {
  __$LibraryEntryEntityCopyWithImpl(this._self, this._then);

  final _LibraryEntryEntity _self;
  final $Res Function(_LibraryEntryEntity) _then;

/// Create a copy of LibraryEntryEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? igdbId = null,Object? title = null,Object? coverUrl = freezed,Object? releaseDate = freezed,Object? status = null,Object? createdAt = null,Object? platform = freezed,Object? rating = freezed,Object? playtimeHours = freezed,Object? progressPercent = freezed,Object? genre = freezed,Object? updatedAt = null,}) {
  return _then(_LibraryEntryEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,igdbId: null == igdbId ? _self.igdbId : igdbId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LibraryStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
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

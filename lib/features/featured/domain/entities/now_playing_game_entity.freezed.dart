// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'now_playing_game_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NowPlayingGameEntity {

 String get title; String? get coverUrl; double? get progressPercent; double? get playtimeHours;// Nothing writes this yet: library_entries has no average-completion
// column, so the card's middle progress branch cannot fire.
 double? get averageCompletionHours;
/// Create a copy of NowPlayingGameEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NowPlayingGameEntityCopyWith<NowPlayingGameEntity> get copyWith => _$NowPlayingGameEntityCopyWithImpl<NowPlayingGameEntity>(this as NowPlayingGameEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NowPlayingGameEntity&&(identical(other.title, title) || other.title == title)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.playtimeHours, playtimeHours) || other.playtimeHours == playtimeHours)&&(identical(other.averageCompletionHours, averageCompletionHours) || other.averageCompletionHours == averageCompletionHours));
}


@override
int get hashCode => Object.hash(runtimeType,title,coverUrl,progressPercent,playtimeHours,averageCompletionHours);

@override
String toString() {
  return 'NowPlayingGameEntity(title: $title, coverUrl: $coverUrl, progressPercent: $progressPercent, playtimeHours: $playtimeHours, averageCompletionHours: $averageCompletionHours)';
}


}

/// @nodoc
abstract mixin class $NowPlayingGameEntityCopyWith<$Res>  {
  factory $NowPlayingGameEntityCopyWith(NowPlayingGameEntity value, $Res Function(NowPlayingGameEntity) _then) = _$NowPlayingGameEntityCopyWithImpl;
@useResult
$Res call({
 String title, String? coverUrl, double? progressPercent, double? playtimeHours, double? averageCompletionHours
});




}
/// @nodoc
class _$NowPlayingGameEntityCopyWithImpl<$Res>
    implements $NowPlayingGameEntityCopyWith<$Res> {
  _$NowPlayingGameEntityCopyWithImpl(this._self, this._then);

  final NowPlayingGameEntity _self;
  final $Res Function(NowPlayingGameEntity) _then;

/// Create a copy of NowPlayingGameEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? coverUrl = freezed,Object? progressPercent = freezed,Object? playtimeHours = freezed,Object? averageCompletionHours = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,progressPercent: freezed == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as double?,playtimeHours: freezed == playtimeHours ? _self.playtimeHours : playtimeHours // ignore: cast_nullable_to_non_nullable
as double?,averageCompletionHours: freezed == averageCompletionHours ? _self.averageCompletionHours : averageCompletionHours // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [NowPlayingGameEntity].
extension NowPlayingGameEntityPatterns on NowPlayingGameEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NowPlayingGameEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NowPlayingGameEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NowPlayingGameEntity value)  $default,){
final _that = this;
switch (_that) {
case _NowPlayingGameEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NowPlayingGameEntity value)?  $default,){
final _that = this;
switch (_that) {
case _NowPlayingGameEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String? coverUrl,  double? progressPercent,  double? playtimeHours,  double? averageCompletionHours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NowPlayingGameEntity() when $default != null:
return $default(_that.title,_that.coverUrl,_that.progressPercent,_that.playtimeHours,_that.averageCompletionHours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String? coverUrl,  double? progressPercent,  double? playtimeHours,  double? averageCompletionHours)  $default,) {final _that = this;
switch (_that) {
case _NowPlayingGameEntity():
return $default(_that.title,_that.coverUrl,_that.progressPercent,_that.playtimeHours,_that.averageCompletionHours);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String? coverUrl,  double? progressPercent,  double? playtimeHours,  double? averageCompletionHours)?  $default,) {final _that = this;
switch (_that) {
case _NowPlayingGameEntity() when $default != null:
return $default(_that.title,_that.coverUrl,_that.progressPercent,_that.playtimeHours,_that.averageCompletionHours);case _:
  return null;

}
}

}

/// @nodoc


class _NowPlayingGameEntity implements NowPlayingGameEntity {
  const _NowPlayingGameEntity({required this.title, this.coverUrl, this.progressPercent, this.playtimeHours, this.averageCompletionHours});
  

@override final  String title;
@override final  String? coverUrl;
@override final  double? progressPercent;
@override final  double? playtimeHours;
// Nothing writes this yet: library_entries has no average-completion
// column, so the card's middle progress branch cannot fire.
@override final  double? averageCompletionHours;

/// Create a copy of NowPlayingGameEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NowPlayingGameEntityCopyWith<_NowPlayingGameEntity> get copyWith => __$NowPlayingGameEntityCopyWithImpl<_NowPlayingGameEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NowPlayingGameEntity&&(identical(other.title, title) || other.title == title)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.playtimeHours, playtimeHours) || other.playtimeHours == playtimeHours)&&(identical(other.averageCompletionHours, averageCompletionHours) || other.averageCompletionHours == averageCompletionHours));
}


@override
int get hashCode => Object.hash(runtimeType,title,coverUrl,progressPercent,playtimeHours,averageCompletionHours);

@override
String toString() {
  return 'NowPlayingGameEntity(title: $title, coverUrl: $coverUrl, progressPercent: $progressPercent, playtimeHours: $playtimeHours, averageCompletionHours: $averageCompletionHours)';
}


}

/// @nodoc
abstract mixin class _$NowPlayingGameEntityCopyWith<$Res> implements $NowPlayingGameEntityCopyWith<$Res> {
  factory _$NowPlayingGameEntityCopyWith(_NowPlayingGameEntity value, $Res Function(_NowPlayingGameEntity) _then) = __$NowPlayingGameEntityCopyWithImpl;
@override @useResult
$Res call({
 String title, String? coverUrl, double? progressPercent, double? playtimeHours, double? averageCompletionHours
});




}
/// @nodoc
class __$NowPlayingGameEntityCopyWithImpl<$Res>
    implements _$NowPlayingGameEntityCopyWith<$Res> {
  __$NowPlayingGameEntityCopyWithImpl(this._self, this._then);

  final _NowPlayingGameEntity _self;
  final $Res Function(_NowPlayingGameEntity) _then;

/// Create a copy of NowPlayingGameEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? coverUrl = freezed,Object? progressPercent = freezed,Object? playtimeHours = freezed,Object? averageCompletionHours = freezed,}) {
  return _then(_NowPlayingGameEntity(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,progressPercent: freezed == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as double?,playtimeHours: freezed == playtimeHours ? _self.playtimeHours : playtimeHours // ignore: cast_nullable_to_non_nullable
as double?,averageCompletionHours: freezed == averageCompletionHours ? _self.averageCompletionHours : averageCompletionHours // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_cover_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameCoverEntity {

 String? get url;
/// Create a copy of GameCoverEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameCoverEntityCopyWith<GameCoverEntity> get copyWith => _$GameCoverEntityCopyWithImpl<GameCoverEntity>(this as GameCoverEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameCoverEntity&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'GameCoverEntity(url: $url)';
}


}

/// @nodoc
abstract mixin class $GameCoverEntityCopyWith<$Res>  {
  factory $GameCoverEntityCopyWith(GameCoverEntity value, $Res Function(GameCoverEntity) _then) = _$GameCoverEntityCopyWithImpl;
@useResult
$Res call({
 String? url
});




}
/// @nodoc
class _$GameCoverEntityCopyWithImpl<$Res>
    implements $GameCoverEntityCopyWith<$Res> {
  _$GameCoverEntityCopyWithImpl(this._self, this._then);

  final GameCoverEntity _self;
  final $Res Function(GameCoverEntity) _then;

/// Create a copy of GameCoverEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = freezed,}) {
  return _then(_self.copyWith(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GameCoverEntity].
extension GameCoverEntityPatterns on GameCoverEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameCoverEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameCoverEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameCoverEntity value)  $default,){
final _that = this;
switch (_that) {
case _GameCoverEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameCoverEntity value)?  $default,){
final _that = this;
switch (_that) {
case _GameCoverEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameCoverEntity() when $default != null:
return $default(_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? url)  $default,) {final _that = this;
switch (_that) {
case _GameCoverEntity():
return $default(_that.url);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? url)?  $default,) {final _that = this;
switch (_that) {
case _GameCoverEntity() when $default != null:
return $default(_that.url);case _:
  return null;

}
}

}

/// @nodoc


class _GameCoverEntity implements GameCoverEntity {
  const _GameCoverEntity({this.url});
  

@override final  String? url;

/// Create a copy of GameCoverEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameCoverEntityCopyWith<_GameCoverEntity> get copyWith => __$GameCoverEntityCopyWithImpl<_GameCoverEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameCoverEntity&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'GameCoverEntity(url: $url)';
}


}

/// @nodoc
abstract mixin class _$GameCoverEntityCopyWith<$Res> implements $GameCoverEntityCopyWith<$Res> {
  factory _$GameCoverEntityCopyWith(_GameCoverEntity value, $Res Function(_GameCoverEntity) _then) = __$GameCoverEntityCopyWithImpl;
@override @useResult
$Res call({
 String? url
});




}
/// @nodoc
class __$GameCoverEntityCopyWithImpl<$Res>
    implements _$GameCoverEntityCopyWith<$Res> {
  __$GameCoverEntityCopyWithImpl(this._self, this._then);

  final _GameCoverEntity _self;
  final $Res Function(_GameCoverEntity) _then;

/// Create a copy of GameCoverEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = freezed,}) {
  return _then(_GameCoverEntity(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

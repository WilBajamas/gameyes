// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_cover.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameCover {

@JsonKey(name: 'url') String? get url;
/// Create a copy of GameCover
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameCoverCopyWith<GameCover> get copyWith => _$GameCoverCopyWithImpl<GameCover>(this as GameCover, _$identity);

  /// Serializes this GameCover to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameCover&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'GameCover(url: $url)';
}


}

/// @nodoc
abstract mixin class $GameCoverCopyWith<$Res>  {
  factory $GameCoverCopyWith(GameCover value, $Res Function(GameCover) _then) = _$GameCoverCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'url') String? url
});




}
/// @nodoc
class _$GameCoverCopyWithImpl<$Res>
    implements $GameCoverCopyWith<$Res> {
  _$GameCoverCopyWithImpl(this._self, this._then);

  final GameCover _self;
  final $Res Function(GameCover) _then;

/// Create a copy of GameCover
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = freezed,}) {
  return _then(_self.copyWith(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GameCover].
extension GameCoverPatterns on GameCover {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameCover value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameCover() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameCover value)  $default,){
final _that = this;
switch (_that) {
case _GameCover():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameCover value)?  $default,){
final _that = this;
switch (_that) {
case _GameCover() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'url')  String? url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameCover() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'url')  String? url)  $default,) {final _that = this;
switch (_that) {
case _GameCover():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'url')  String? url)?  $default,) {final _that = this;
switch (_that) {
case _GameCover() when $default != null:
return $default(_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameCover extends GameCover {
  const _GameCover({@JsonKey(name: 'url') this.url}): super._();
  factory _GameCover.fromJson(Map<String, dynamic> json) => _$GameCoverFromJson(json);

@override@JsonKey(name: 'url') final  String? url;

/// Create a copy of GameCover
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameCoverCopyWith<_GameCover> get copyWith => __$GameCoverCopyWithImpl<_GameCover>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameCoverToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameCover&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'GameCover(url: $url)';
}


}

/// @nodoc
abstract mixin class _$GameCoverCopyWith<$Res> implements $GameCoverCopyWith<$Res> {
  factory _$GameCoverCopyWith(_GameCover value, $Res Function(_GameCover) _then) = __$GameCoverCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'url') String? url
});




}
/// @nodoc
class __$GameCoverCopyWithImpl<$Res>
    implements _$GameCoverCopyWith<$Res> {
  __$GameCoverCopyWithImpl(this._self, this._then);

  final _GameCover _self;
  final $Res Function(_GameCover) _then;

/// Create a copy of GameCover
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = freezed,}) {
  return _then(_GameCover(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

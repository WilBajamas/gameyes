// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_keyword.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameKeyword {

 String? get name;
/// Create a copy of GameKeyword
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameKeywordCopyWith<GameKeyword> get copyWith => _$GameKeywordCopyWithImpl<GameKeyword>(this as GameKeyword, _$identity);

  /// Serializes this GameKeyword to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameKeyword&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'GameKeyword(name: $name)';
}


}

/// @nodoc
abstract mixin class $GameKeywordCopyWith<$Res>  {
  factory $GameKeywordCopyWith(GameKeyword value, $Res Function(GameKeyword) _then) = _$GameKeywordCopyWithImpl;
@useResult
$Res call({
 String? name
});




}
/// @nodoc
class _$GameKeywordCopyWithImpl<$Res>
    implements $GameKeywordCopyWith<$Res> {
  _$GameKeywordCopyWithImpl(this._self, this._then);

  final GameKeyword _self;
  final $Res Function(GameKeyword) _then;

/// Create a copy of GameKeyword
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GameKeyword].
extension GameKeywordPatterns on GameKeyword {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameKeyword value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameKeyword() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameKeyword value)  $default,){
final _that = this;
switch (_that) {
case _GameKeyword():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameKeyword value)?  $default,){
final _that = this;
switch (_that) {
case _GameKeyword() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameKeyword() when $default != null:
return $default(_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name)  $default,) {final _that = this;
switch (_that) {
case _GameKeyword():
return $default(_that.name);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name)?  $default,) {final _that = this;
switch (_that) {
case _GameKeyword() when $default != null:
return $default(_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameKeyword extends GameKeyword {
  const _GameKeyword({this.name}): super._();
  factory _GameKeyword.fromJson(Map<String, dynamic> json) => _$GameKeywordFromJson(json);

@override final  String? name;

/// Create a copy of GameKeyword
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameKeywordCopyWith<_GameKeyword> get copyWith => __$GameKeywordCopyWithImpl<_GameKeyword>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameKeywordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameKeyword&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'GameKeyword(name: $name)';
}


}

/// @nodoc
abstract mixin class _$GameKeywordCopyWith<$Res> implements $GameKeywordCopyWith<$Res> {
  factory _$GameKeywordCopyWith(_GameKeyword value, $Res Function(_GameKeyword) _then) = __$GameKeywordCopyWithImpl;
@override @useResult
$Res call({
 String? name
});




}
/// @nodoc
class __$GameKeywordCopyWithImpl<$Res>
    implements _$GameKeywordCopyWith<$Res> {
  __$GameKeywordCopyWithImpl(this._self, this._then);

  final _GameKeyword _self;
  final $Res Function(_GameKeyword) _then;

/// Create a copy of GameKeyword
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,}) {
  return _then(_GameKeyword(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

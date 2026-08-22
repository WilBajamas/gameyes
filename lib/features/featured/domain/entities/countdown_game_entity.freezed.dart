// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'countdown_game_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CountdownGameEntity {

 GameEntity? get game; bool get isWishlisted;
/// Create a copy of CountdownGameEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CountdownGameEntityCopyWith<CountdownGameEntity> get copyWith => _$CountdownGameEntityCopyWithImpl<CountdownGameEntity>(this as CountdownGameEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CountdownGameEntity&&(identical(other.game, game) || other.game == game)&&(identical(other.isWishlisted, isWishlisted) || other.isWishlisted == isWishlisted));
}


@override
int get hashCode => Object.hash(runtimeType,game,isWishlisted);

@override
String toString() {
  return 'CountdownGameEntity(game: $game, isWishlisted: $isWishlisted)';
}


}

/// @nodoc
abstract mixin class $CountdownGameEntityCopyWith<$Res>  {
  factory $CountdownGameEntityCopyWith(CountdownGameEntity value, $Res Function(CountdownGameEntity) _then) = _$CountdownGameEntityCopyWithImpl;
@useResult
$Res call({
 GameEntity? game, bool isWishlisted
});


$GameEntityCopyWith<$Res>? get game;

}
/// @nodoc
class _$CountdownGameEntityCopyWithImpl<$Res>
    implements $CountdownGameEntityCopyWith<$Res> {
  _$CountdownGameEntityCopyWithImpl(this._self, this._then);

  final CountdownGameEntity _self;
  final $Res Function(CountdownGameEntity) _then;

/// Create a copy of CountdownGameEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? game = freezed,Object? isWishlisted = null,}) {
  return _then(_self.copyWith(
game: freezed == game ? _self.game : game // ignore: cast_nullable_to_non_nullable
as GameEntity?,isWishlisted: null == isWishlisted ? _self.isWishlisted : isWishlisted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of CountdownGameEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameEntityCopyWith<$Res>? get game {
    if (_self.game == null) {
    return null;
  }

  return $GameEntityCopyWith<$Res>(_self.game!, (value) {
    return _then(_self.copyWith(game: value));
  });
}
}


/// Adds pattern-matching-related methods to [CountdownGameEntity].
extension CountdownGameEntityPatterns on CountdownGameEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CountdownGameEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CountdownGameEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CountdownGameEntity value)  $default,){
final _that = this;
switch (_that) {
case _CountdownGameEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CountdownGameEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CountdownGameEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GameEntity? game,  bool isWishlisted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CountdownGameEntity() when $default != null:
return $default(_that.game,_that.isWishlisted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GameEntity? game,  bool isWishlisted)  $default,) {final _that = this;
switch (_that) {
case _CountdownGameEntity():
return $default(_that.game,_that.isWishlisted);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GameEntity? game,  bool isWishlisted)?  $default,) {final _that = this;
switch (_that) {
case _CountdownGameEntity() when $default != null:
return $default(_that.game,_that.isWishlisted);case _:
  return null;

}
}

}

/// @nodoc


class _CountdownGameEntity implements CountdownGameEntity {
  const _CountdownGameEntity({required this.game, required this.isWishlisted});
  

@override final  GameEntity? game;
@override final  bool isWishlisted;

/// Create a copy of CountdownGameEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CountdownGameEntityCopyWith<_CountdownGameEntity> get copyWith => __$CountdownGameEntityCopyWithImpl<_CountdownGameEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CountdownGameEntity&&(identical(other.game, game) || other.game == game)&&(identical(other.isWishlisted, isWishlisted) || other.isWishlisted == isWishlisted));
}


@override
int get hashCode => Object.hash(runtimeType,game,isWishlisted);

@override
String toString() {
  return 'CountdownGameEntity(game: $game, isWishlisted: $isWishlisted)';
}


}

/// @nodoc
abstract mixin class _$CountdownGameEntityCopyWith<$Res> implements $CountdownGameEntityCopyWith<$Res> {
  factory _$CountdownGameEntityCopyWith(_CountdownGameEntity value, $Res Function(_CountdownGameEntity) _then) = __$CountdownGameEntityCopyWithImpl;
@override @useResult
$Res call({
 GameEntity? game, bool isWishlisted
});


@override $GameEntityCopyWith<$Res>? get game;

}
/// @nodoc
class __$CountdownGameEntityCopyWithImpl<$Res>
    implements _$CountdownGameEntityCopyWith<$Res> {
  __$CountdownGameEntityCopyWithImpl(this._self, this._then);

  final _CountdownGameEntity _self;
  final $Res Function(_CountdownGameEntity) _then;

/// Create a copy of CountdownGameEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? game = freezed,Object? isWishlisted = null,}) {
  return _then(_CountdownGameEntity(
game: freezed == game ? _self.game : game // ignore: cast_nullable_to_non_nullable
as GameEntity?,isWishlisted: null == isWishlisted ? _self.isWishlisted : isWishlisted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CountdownGameEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameEntityCopyWith<$Res>? get game {
    if (_self.game == null) {
    return null;
  }

  return $GameEntityCopyWith<$Res>(_self.game!, (value) {
    return _then(_self.copyWith(game: value));
  });
}
}

// dart format on

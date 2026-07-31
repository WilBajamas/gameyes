// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameDetailState {

 GameDetailStatus? get status; GameDetailEntity? get game; ErrorType? get error; bool get contentExpanded; SavedGame? get savedGame;
/// Create a copy of GameDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameDetailStateCopyWith<GameDetailState> get copyWith => _$GameDetailStateCopyWithImpl<GameDetailState>(this as GameDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.game, game) || other.game == game)&&(identical(other.error, error) || other.error == error)&&(identical(other.contentExpanded, contentExpanded) || other.contentExpanded == contentExpanded)&&(identical(other.savedGame, savedGame) || other.savedGame == savedGame));
}


@override
int get hashCode => Object.hash(runtimeType,status,game,error,contentExpanded,savedGame);

@override
String toString() {
  return 'GameDetailState(status: $status, game: $game, error: $error, contentExpanded: $contentExpanded, savedGame: $savedGame)';
}


}

/// @nodoc
abstract mixin class $GameDetailStateCopyWith<$Res>  {
  factory $GameDetailStateCopyWith(GameDetailState value, $Res Function(GameDetailState) _then) = _$GameDetailStateCopyWithImpl;
@useResult
$Res call({
 GameDetailStatus? status, GameDetailEntity? game, ErrorType? error, bool contentExpanded, SavedGame? savedGame
});


$GameDetailEntityCopyWith<$Res>? get game;$ErrorTypeCopyWith<$Res>? get error;

}
/// @nodoc
class _$GameDetailStateCopyWithImpl<$Res>
    implements $GameDetailStateCopyWith<$Res> {
  _$GameDetailStateCopyWithImpl(this._self, this._then);

  final GameDetailState _self;
  final $Res Function(GameDetailState) _then;

/// Create a copy of GameDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = freezed,Object? game = freezed,Object? error = freezed,Object? contentExpanded = null,Object? savedGame = freezed,}) {
  return _then(_self.copyWith(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GameDetailStatus?,game: freezed == game ? _self.game : game // ignore: cast_nullable_to_non_nullable
as GameDetailEntity?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ErrorType?,contentExpanded: null == contentExpanded ? _self.contentExpanded : contentExpanded // ignore: cast_nullable_to_non_nullable
as bool,savedGame: freezed == savedGame ? _self.savedGame : savedGame // ignore: cast_nullable_to_non_nullable
as SavedGame?,
  ));
}
/// Create a copy of GameDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameDetailEntityCopyWith<$Res>? get game {
    if (_self.game == null) {
    return null;
  }

  return $GameDetailEntityCopyWith<$Res>(_self.game!, (value) {
    return _then(_self.copyWith(game: value));
  });
}/// Create a copy of GameDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ErrorTypeCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $ErrorTypeCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameDetailState].
extension GameDetailStatePatterns on GameDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameDetailState value)  $default,){
final _that = this;
switch (_that) {
case _GameDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _GameDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GameDetailStatus? status,  GameDetailEntity? game,  ErrorType? error,  bool contentExpanded,  SavedGame? savedGame)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameDetailState() when $default != null:
return $default(_that.status,_that.game,_that.error,_that.contentExpanded,_that.savedGame);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GameDetailStatus? status,  GameDetailEntity? game,  ErrorType? error,  bool contentExpanded,  SavedGame? savedGame)  $default,) {final _that = this;
switch (_that) {
case _GameDetailState():
return $default(_that.status,_that.game,_that.error,_that.contentExpanded,_that.savedGame);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GameDetailStatus? status,  GameDetailEntity? game,  ErrorType? error,  bool contentExpanded,  SavedGame? savedGame)?  $default,) {final _that = this;
switch (_that) {
case _GameDetailState() when $default != null:
return $default(_that.status,_that.game,_that.error,_that.contentExpanded,_that.savedGame);case _:
  return null;

}
}

}

/// @nodoc


class _GameDetailState implements GameDetailState {
  const _GameDetailState({this.status, this.game, this.error, this.contentExpanded = false, this.savedGame});
  

@override final  GameDetailStatus? status;
@override final  GameDetailEntity? game;
@override final  ErrorType? error;
@override@JsonKey() final  bool contentExpanded;
@override final  SavedGame? savedGame;

/// Create a copy of GameDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameDetailStateCopyWith<_GameDetailState> get copyWith => __$GameDetailStateCopyWithImpl<_GameDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.game, game) || other.game == game)&&(identical(other.error, error) || other.error == error)&&(identical(other.contentExpanded, contentExpanded) || other.contentExpanded == contentExpanded)&&(identical(other.savedGame, savedGame) || other.savedGame == savedGame));
}


@override
int get hashCode => Object.hash(runtimeType,status,game,error,contentExpanded,savedGame);

@override
String toString() {
  return 'GameDetailState(status: $status, game: $game, error: $error, contentExpanded: $contentExpanded, savedGame: $savedGame)';
}


}

/// @nodoc
abstract mixin class _$GameDetailStateCopyWith<$Res> implements $GameDetailStateCopyWith<$Res> {
  factory _$GameDetailStateCopyWith(_GameDetailState value, $Res Function(_GameDetailState) _then) = __$GameDetailStateCopyWithImpl;
@override @useResult
$Res call({
 GameDetailStatus? status, GameDetailEntity? game, ErrorType? error, bool contentExpanded, SavedGame? savedGame
});


@override $GameDetailEntityCopyWith<$Res>? get game;@override $ErrorTypeCopyWith<$Res>? get error;

}
/// @nodoc
class __$GameDetailStateCopyWithImpl<$Res>
    implements _$GameDetailStateCopyWith<$Res> {
  __$GameDetailStateCopyWithImpl(this._self, this._then);

  final _GameDetailState _self;
  final $Res Function(_GameDetailState) _then;

/// Create a copy of GameDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = freezed,Object? game = freezed,Object? error = freezed,Object? contentExpanded = null,Object? savedGame = freezed,}) {
  return _then(_GameDetailState(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GameDetailStatus?,game: freezed == game ? _self.game : game // ignore: cast_nullable_to_non_nullable
as GameDetailEntity?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ErrorType?,contentExpanded: null == contentExpanded ? _self.contentExpanded : contentExpanded // ignore: cast_nullable_to_non_nullable
as bool,savedGame: freezed == savedGame ? _self.savedGame : savedGame // ignore: cast_nullable_to_non_nullable
as SavedGame?,
  ));
}

/// Create a copy of GameDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameDetailEntityCopyWith<$Res>? get game {
    if (_self.game == null) {
    return null;
  }

  return $GameDetailEntityCopyWith<$Res>(_self.game!, (value) {
    return _then(_self.copyWith(game: value));
  });
}/// Create a copy of GameDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ErrorTypeCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $ErrorTypeCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}

// dart format on

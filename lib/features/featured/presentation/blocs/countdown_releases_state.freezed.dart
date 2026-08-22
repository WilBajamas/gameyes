// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'countdown_releases_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CountdownReleasesState {

 CountdownReleasesStatus get status; GameEntity? get countdownGame; List<GameEntity> get outThisWeekGames; Duration? get durationRemaining; bool get isReleaseDay; bool get isWishlisted; String? get errorMessage; bool get isComingSoonLabel;
/// Create a copy of CountdownReleasesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CountdownReleasesStateCopyWith<CountdownReleasesState> get copyWith => _$CountdownReleasesStateCopyWithImpl<CountdownReleasesState>(this as CountdownReleasesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CountdownReleasesState&&(identical(other.status, status) || other.status == status)&&(identical(other.countdownGame, countdownGame) || other.countdownGame == countdownGame)&&const DeepCollectionEquality().equals(other.outThisWeekGames, outThisWeekGames)&&(identical(other.durationRemaining, durationRemaining) || other.durationRemaining == durationRemaining)&&(identical(other.isReleaseDay, isReleaseDay) || other.isReleaseDay == isReleaseDay)&&(identical(other.isWishlisted, isWishlisted) || other.isWishlisted == isWishlisted)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isComingSoonLabel, isComingSoonLabel) || other.isComingSoonLabel == isComingSoonLabel));
}


@override
int get hashCode => Object.hash(runtimeType,status,countdownGame,const DeepCollectionEquality().hash(outThisWeekGames),durationRemaining,isReleaseDay,isWishlisted,errorMessage,isComingSoonLabel);

@override
String toString() {
  return 'CountdownReleasesState(status: $status, countdownGame: $countdownGame, outThisWeekGames: $outThisWeekGames, durationRemaining: $durationRemaining, isReleaseDay: $isReleaseDay, isWishlisted: $isWishlisted, errorMessage: $errorMessage, isComingSoonLabel: $isComingSoonLabel)';
}


}

/// @nodoc
abstract mixin class $CountdownReleasesStateCopyWith<$Res>  {
  factory $CountdownReleasesStateCopyWith(CountdownReleasesState value, $Res Function(CountdownReleasesState) _then) = _$CountdownReleasesStateCopyWithImpl;
@useResult
$Res call({
 CountdownReleasesStatus status, GameEntity? countdownGame, List<GameEntity> outThisWeekGames, Duration? durationRemaining, bool isReleaseDay, bool isWishlisted, String? errorMessage, bool isComingSoonLabel
});


$GameEntityCopyWith<$Res>? get countdownGame;

}
/// @nodoc
class _$CountdownReleasesStateCopyWithImpl<$Res>
    implements $CountdownReleasesStateCopyWith<$Res> {
  _$CountdownReleasesStateCopyWithImpl(this._self, this._then);

  final CountdownReleasesState _self;
  final $Res Function(CountdownReleasesState) _then;

/// Create a copy of CountdownReleasesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? countdownGame = freezed,Object? outThisWeekGames = null,Object? durationRemaining = freezed,Object? isReleaseDay = null,Object? isWishlisted = null,Object? errorMessage = freezed,Object? isComingSoonLabel = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CountdownReleasesStatus,countdownGame: freezed == countdownGame ? _self.countdownGame : countdownGame // ignore: cast_nullable_to_non_nullable
as GameEntity?,outThisWeekGames: null == outThisWeekGames ? _self.outThisWeekGames : outThisWeekGames // ignore: cast_nullable_to_non_nullable
as List<GameEntity>,durationRemaining: freezed == durationRemaining ? _self.durationRemaining : durationRemaining // ignore: cast_nullable_to_non_nullable
as Duration?,isReleaseDay: null == isReleaseDay ? _self.isReleaseDay : isReleaseDay // ignore: cast_nullable_to_non_nullable
as bool,isWishlisted: null == isWishlisted ? _self.isWishlisted : isWishlisted // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isComingSoonLabel: null == isComingSoonLabel ? _self.isComingSoonLabel : isComingSoonLabel // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of CountdownReleasesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameEntityCopyWith<$Res>? get countdownGame {
    if (_self.countdownGame == null) {
    return null;
  }

  return $GameEntityCopyWith<$Res>(_self.countdownGame!, (value) {
    return _then(_self.copyWith(countdownGame: value));
  });
}
}


/// Adds pattern-matching-related methods to [CountdownReleasesState].
extension CountdownReleasesStatePatterns on CountdownReleasesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CountdownReleasesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CountdownReleasesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CountdownReleasesState value)  $default,){
final _that = this;
switch (_that) {
case _CountdownReleasesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CountdownReleasesState value)?  $default,){
final _that = this;
switch (_that) {
case _CountdownReleasesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CountdownReleasesStatus status,  GameEntity? countdownGame,  List<GameEntity> outThisWeekGames,  Duration? durationRemaining,  bool isReleaseDay,  bool isWishlisted,  String? errorMessage,  bool isComingSoonLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CountdownReleasesState() when $default != null:
return $default(_that.status,_that.countdownGame,_that.outThisWeekGames,_that.durationRemaining,_that.isReleaseDay,_that.isWishlisted,_that.errorMessage,_that.isComingSoonLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CountdownReleasesStatus status,  GameEntity? countdownGame,  List<GameEntity> outThisWeekGames,  Duration? durationRemaining,  bool isReleaseDay,  bool isWishlisted,  String? errorMessage,  bool isComingSoonLabel)  $default,) {final _that = this;
switch (_that) {
case _CountdownReleasesState():
return $default(_that.status,_that.countdownGame,_that.outThisWeekGames,_that.durationRemaining,_that.isReleaseDay,_that.isWishlisted,_that.errorMessage,_that.isComingSoonLabel);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CountdownReleasesStatus status,  GameEntity? countdownGame,  List<GameEntity> outThisWeekGames,  Duration? durationRemaining,  bool isReleaseDay,  bool isWishlisted,  String? errorMessage,  bool isComingSoonLabel)?  $default,) {final _that = this;
switch (_that) {
case _CountdownReleasesState() when $default != null:
return $default(_that.status,_that.countdownGame,_that.outThisWeekGames,_that.durationRemaining,_that.isReleaseDay,_that.isWishlisted,_that.errorMessage,_that.isComingSoonLabel);case _:
  return null;

}
}

}

/// @nodoc


class _CountdownReleasesState implements CountdownReleasesState {
  const _CountdownReleasesState({this.status = CountdownReleasesStatus.initial, this.countdownGame, final  List<GameEntity> outThisWeekGames = const <GameEntity>[], this.durationRemaining, this.isReleaseDay = false, this.isWishlisted = false, this.errorMessage, this.isComingSoonLabel = false}): _outThisWeekGames = outThisWeekGames;
  

@override@JsonKey() final  CountdownReleasesStatus status;
@override final  GameEntity? countdownGame;
 final  List<GameEntity> _outThisWeekGames;
@override@JsonKey() List<GameEntity> get outThisWeekGames {
  if (_outThisWeekGames is EqualUnmodifiableListView) return _outThisWeekGames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_outThisWeekGames);
}

@override final  Duration? durationRemaining;
@override@JsonKey() final  bool isReleaseDay;
@override@JsonKey() final  bool isWishlisted;
@override final  String? errorMessage;
@override@JsonKey() final  bool isComingSoonLabel;

/// Create a copy of CountdownReleasesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CountdownReleasesStateCopyWith<_CountdownReleasesState> get copyWith => __$CountdownReleasesStateCopyWithImpl<_CountdownReleasesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CountdownReleasesState&&(identical(other.status, status) || other.status == status)&&(identical(other.countdownGame, countdownGame) || other.countdownGame == countdownGame)&&const DeepCollectionEquality().equals(other._outThisWeekGames, _outThisWeekGames)&&(identical(other.durationRemaining, durationRemaining) || other.durationRemaining == durationRemaining)&&(identical(other.isReleaseDay, isReleaseDay) || other.isReleaseDay == isReleaseDay)&&(identical(other.isWishlisted, isWishlisted) || other.isWishlisted == isWishlisted)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isComingSoonLabel, isComingSoonLabel) || other.isComingSoonLabel == isComingSoonLabel));
}


@override
int get hashCode => Object.hash(runtimeType,status,countdownGame,const DeepCollectionEquality().hash(_outThisWeekGames),durationRemaining,isReleaseDay,isWishlisted,errorMessage,isComingSoonLabel);

@override
String toString() {
  return 'CountdownReleasesState(status: $status, countdownGame: $countdownGame, outThisWeekGames: $outThisWeekGames, durationRemaining: $durationRemaining, isReleaseDay: $isReleaseDay, isWishlisted: $isWishlisted, errorMessage: $errorMessage, isComingSoonLabel: $isComingSoonLabel)';
}


}

/// @nodoc
abstract mixin class _$CountdownReleasesStateCopyWith<$Res> implements $CountdownReleasesStateCopyWith<$Res> {
  factory _$CountdownReleasesStateCopyWith(_CountdownReleasesState value, $Res Function(_CountdownReleasesState) _then) = __$CountdownReleasesStateCopyWithImpl;
@override @useResult
$Res call({
 CountdownReleasesStatus status, GameEntity? countdownGame, List<GameEntity> outThisWeekGames, Duration? durationRemaining, bool isReleaseDay, bool isWishlisted, String? errorMessage, bool isComingSoonLabel
});


@override $GameEntityCopyWith<$Res>? get countdownGame;

}
/// @nodoc
class __$CountdownReleasesStateCopyWithImpl<$Res>
    implements _$CountdownReleasesStateCopyWith<$Res> {
  __$CountdownReleasesStateCopyWithImpl(this._self, this._then);

  final _CountdownReleasesState _self;
  final $Res Function(_CountdownReleasesState) _then;

/// Create a copy of CountdownReleasesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? countdownGame = freezed,Object? outThisWeekGames = null,Object? durationRemaining = freezed,Object? isReleaseDay = null,Object? isWishlisted = null,Object? errorMessage = freezed,Object? isComingSoonLabel = null,}) {
  return _then(_CountdownReleasesState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CountdownReleasesStatus,countdownGame: freezed == countdownGame ? _self.countdownGame : countdownGame // ignore: cast_nullable_to_non_nullable
as GameEntity?,outThisWeekGames: null == outThisWeekGames ? _self._outThisWeekGames : outThisWeekGames // ignore: cast_nullable_to_non_nullable
as List<GameEntity>,durationRemaining: freezed == durationRemaining ? _self.durationRemaining : durationRemaining // ignore: cast_nullable_to_non_nullable
as Duration?,isReleaseDay: null == isReleaseDay ? _self.isReleaseDay : isReleaseDay // ignore: cast_nullable_to_non_nullable
as bool,isWishlisted: null == isWishlisted ? _self.isWishlisted : isWishlisted // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isComingSoonLabel: null == isComingSoonLabel ? _self.isComingSoonLabel : isComingSoonLabel // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CountdownReleasesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameEntityCopyWith<$Res>? get countdownGame {
    if (_self.countdownGame == null) {
    return null;
  }

  return $GameEntityCopyWith<$Res>(_self.countdownGame!, (value) {
    return _then(_self.copyWith(countdownGame: value));
  });
}
}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracker_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackerDetailState {
  TrackerSavedGameEntity? get game;

  /// Create a copy of TrackerDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TrackerDetailStateCopyWith<TrackerDetailState> get copyWith =>
      _$TrackerDetailStateCopyWithImpl<TrackerDetailState>(
          this as TrackerDetailState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TrackerDetailState &&
            (identical(other.game, game) || other.game == game));
  }

  @override
  int get hashCode => Object.hash(runtimeType, game);

  @override
  String toString() {
    return 'TrackerDetailState(game: $game)';
  }
}

/// @nodoc
abstract mixin class $TrackerDetailStateCopyWith<$Res> {
  factory $TrackerDetailStateCopyWith(
          TrackerDetailState value, $Res Function(TrackerDetailState) _then) =
      _$TrackerDetailStateCopyWithImpl;
  @useResult
  $Res call({TrackerSavedGameEntity? game});

  $TrackerSavedGameEntityCopyWith<$Res>? get game;
}

/// @nodoc
class _$TrackerDetailStateCopyWithImpl<$Res>
    implements $TrackerDetailStateCopyWith<$Res> {
  _$TrackerDetailStateCopyWithImpl(this._self, this._then);

  final TrackerDetailState _self;
  final $Res Function(TrackerDetailState) _then;

  /// Create a copy of TrackerDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? game = freezed,
  }) {
    return _then(_self.copyWith(
      game: freezed == game
          ? _self.game
          : game // ignore: cast_nullable_to_non_nullable
              as TrackerSavedGameEntity?,
    ));
  }

  /// Create a copy of TrackerDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrackerSavedGameEntityCopyWith<$Res>? get game {
    if (_self.game == null) {
      return null;
    }

    return $TrackerSavedGameEntityCopyWith<$Res>(_self.game!, (value) {
      return _then(_self.copyWith(game: value));
    });
  }
}

/// Adds pattern-matching-related methods to [TrackerDetailState].
extension TrackerDetailStatePatterns on TrackerDetailState {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TrackerDetailState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrackerDetailState() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TrackerDetailState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackerDetailState():
        return $default(_that);
    }
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TrackerDetailState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackerDetailState() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(TrackerSavedGameEntity? game)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrackerDetailState() when $default != null:
        return $default(_that.game);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(TrackerSavedGameEntity? game) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackerDetailState():
        return $default(_that.game);
    }
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(TrackerSavedGameEntity? game)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackerDetailState() when $default != null:
        return $default(_that.game);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _TrackerDetailState implements TrackerDetailState {
  const _TrackerDetailState({this.game});

  @override
  final TrackerSavedGameEntity? game;

  /// Create a copy of TrackerDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TrackerDetailStateCopyWith<_TrackerDetailState> get copyWith =>
      __$TrackerDetailStateCopyWithImpl<_TrackerDetailState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TrackerDetailState &&
            (identical(other.game, game) || other.game == game));
  }

  @override
  int get hashCode => Object.hash(runtimeType, game);

  @override
  String toString() {
    return 'TrackerDetailState(game: $game)';
  }
}

/// @nodoc
abstract mixin class _$TrackerDetailStateCopyWith<$Res>
    implements $TrackerDetailStateCopyWith<$Res> {
  factory _$TrackerDetailStateCopyWith(
          _TrackerDetailState value, $Res Function(_TrackerDetailState) _then) =
      __$TrackerDetailStateCopyWithImpl;
  @override
  @useResult
  $Res call({TrackerSavedGameEntity? game});

  @override
  $TrackerSavedGameEntityCopyWith<$Res>? get game;
}

/// @nodoc
class __$TrackerDetailStateCopyWithImpl<$Res>
    implements _$TrackerDetailStateCopyWith<$Res> {
  __$TrackerDetailStateCopyWithImpl(this._self, this._then);

  final _TrackerDetailState _self;
  final $Res Function(_TrackerDetailState) _then;

  /// Create a copy of TrackerDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? game = freezed,
  }) {
    return _then(_TrackerDetailState(
      game: freezed == game
          ? _self.game
          : game // ignore: cast_nullable_to_non_nullable
              as TrackerSavedGameEntity?,
    ));
  }

  /// Create a copy of TrackerDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrackerSavedGameEntityCopyWith<$Res>? get game {
    if (_self.game == null) {
      return null;
    }

    return $TrackerSavedGameEntityCopyWith<$Res>(_self.game!, (value) {
      return _then(_self.copyWith(game: value));
    });
  }
}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'games_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GamesState {
  GamesStatus get status;
  GamesNextPageStatus? get nextPageStatus;
  GameListEntity? get response;
  List<GameEntity> get games;
  ErrorType? get error;
  ErrorType? get nextPageError;
  FilterState get filterState;

  /// Create a copy of GamesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GamesStateCopyWith<GamesState> get copyWith =>
      _$GamesStateCopyWithImpl<GamesState>(this as GamesState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GamesState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.nextPageStatus, nextPageStatus) ||
                other.nextPageStatus == nextPageStatus) &&
            (identical(other.response, response) ||
                other.response == response) &&
            const DeepCollectionEquality().equals(other.games, games) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.nextPageError, nextPageError) ||
                other.nextPageError == nextPageError) &&
            (identical(other.filterState, filterState) ||
                other.filterState == filterState));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      nextPageStatus,
      response,
      const DeepCollectionEquality().hash(games),
      error,
      nextPageError,
      filterState);

  @override
  String toString() {
    return 'GamesState(status: $status, nextPageStatus: $nextPageStatus, response: $response, games: $games, error: $error, nextPageError: $nextPageError, filterState: $filterState)';
  }
}

/// @nodoc
abstract mixin class $GamesStateCopyWith<$Res> {
  factory $GamesStateCopyWith(
          GamesState value, $Res Function(GamesState) _then) =
      _$GamesStateCopyWithImpl;
  @useResult
  $Res call(
      {GamesStatus status,
      GamesNextPageStatus? nextPageStatus,
      GameListEntity? response,
      List<GameEntity> games,
      ErrorType? error,
      ErrorType? nextPageError,
      FilterState filterState});

  $GameListEntityCopyWith<$Res>? get response;
  $ErrorTypeCopyWith<$Res>? get error;
  $ErrorTypeCopyWith<$Res>? get nextPageError;
  $FilterStateCopyWith<$Res> get filterState;
}

/// @nodoc
class _$GamesStateCopyWithImpl<$Res> implements $GamesStateCopyWith<$Res> {
  _$GamesStateCopyWithImpl(this._self, this._then);

  final GamesState _self;
  final $Res Function(GamesState) _then;

  /// Create a copy of GamesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? nextPageStatus = freezed,
    Object? response = freezed,
    Object? games = null,
    Object? error = freezed,
    Object? nextPageError = freezed,
    Object? filterState = null,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as GamesStatus,
      nextPageStatus: freezed == nextPageStatus
          ? _self.nextPageStatus
          : nextPageStatus // ignore: cast_nullable_to_non_nullable
              as GamesNextPageStatus?,
      response: freezed == response
          ? _self.response
          : response // ignore: cast_nullable_to_non_nullable
              as GameListEntity?,
      games: null == games
          ? _self.games
          : games // ignore: cast_nullable_to_non_nullable
              as List<GameEntity>,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as ErrorType?,
      nextPageError: freezed == nextPageError
          ? _self.nextPageError
          : nextPageError // ignore: cast_nullable_to_non_nullable
              as ErrorType?,
      filterState: null == filterState
          ? _self.filterState
          : filterState // ignore: cast_nullable_to_non_nullable
              as FilterState,
    ));
  }

  /// Create a copy of GamesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameListEntityCopyWith<$Res>? get response {
    if (_self.response == null) {
      return null;
    }

    return $GameListEntityCopyWith<$Res>(_self.response!, (value) {
      return _then(_self.copyWith(response: value));
    });
  }

  /// Create a copy of GamesState
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

  /// Create a copy of GamesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ErrorTypeCopyWith<$Res>? get nextPageError {
    if (_self.nextPageError == null) {
      return null;
    }

    return $ErrorTypeCopyWith<$Res>(_self.nextPageError!, (value) {
      return _then(_self.copyWith(nextPageError: value));
    });
  }

  /// Create a copy of GamesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FilterStateCopyWith<$Res> get filterState {
    return $FilterStateCopyWith<$Res>(_self.filterState, (value) {
      return _then(_self.copyWith(filterState: value));
    });
  }
}

/// Adds pattern-matching-related methods to [GamesState].
extension GamesStatePatterns on GamesState {
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
    TResult Function(_GamesState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GamesState() when $default != null:
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
    TResult Function(_GamesState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GamesState():
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
    TResult? Function(_GamesState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GamesState() when $default != null:
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
    TResult Function(
            GamesStatus status,
            GamesNextPageStatus? nextPageStatus,
            GameListEntity? response,
            List<GameEntity> games,
            ErrorType? error,
            ErrorType? nextPageError,
            FilterState filterState)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GamesState() when $default != null:
        return $default(_that.status, _that.nextPageStatus, _that.response,
            _that.games, _that.error, _that.nextPageError, _that.filterState);
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
    TResult Function(
            GamesStatus status,
            GamesNextPageStatus? nextPageStatus,
            GameListEntity? response,
            List<GameEntity> games,
            ErrorType? error,
            ErrorType? nextPageError,
            FilterState filterState)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GamesState():
        return $default(_that.status, _that.nextPageStatus, _that.response,
            _that.games, _that.error, _that.nextPageError, _that.filterState);
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
    TResult? Function(
            GamesStatus status,
            GamesNextPageStatus? nextPageStatus,
            GameListEntity? response,
            List<GameEntity> games,
            ErrorType? error,
            ErrorType? nextPageError,
            FilterState filterState)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GamesState() when $default != null:
        return $default(_that.status, _that.nextPageStatus, _that.response,
            _that.games, _that.error, _that.nextPageError, _that.filterState);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _GamesState implements GamesState {
  const _GamesState(
      {this.status = GamesStatus.initial,
      this.nextPageStatus = GamesNextPageStatus.initial,
      this.response,
      final List<GameEntity> games = const <GameEntity>[],
      this.error,
      this.nextPageError,
      this.filterState = const FilterState()})
      : _games = games;

  @override
  @JsonKey()
  final GamesStatus status;
  @override
  @JsonKey()
  final GamesNextPageStatus? nextPageStatus;
  @override
  final GameListEntity? response;
  final List<GameEntity> _games;
  @override
  @JsonKey()
  List<GameEntity> get games {
    if (_games is EqualUnmodifiableListView) return _games;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_games);
  }

  @override
  final ErrorType? error;
  @override
  final ErrorType? nextPageError;
  @override
  @JsonKey()
  final FilterState filterState;

  /// Create a copy of GamesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GamesStateCopyWith<_GamesState> get copyWith =>
      __$GamesStateCopyWithImpl<_GamesState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GamesState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.nextPageStatus, nextPageStatus) ||
                other.nextPageStatus == nextPageStatus) &&
            (identical(other.response, response) ||
                other.response == response) &&
            const DeepCollectionEquality().equals(other._games, _games) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.nextPageError, nextPageError) ||
                other.nextPageError == nextPageError) &&
            (identical(other.filterState, filterState) ||
                other.filterState == filterState));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      nextPageStatus,
      response,
      const DeepCollectionEquality().hash(_games),
      error,
      nextPageError,
      filterState);

  @override
  String toString() {
    return 'GamesState(status: $status, nextPageStatus: $nextPageStatus, response: $response, games: $games, error: $error, nextPageError: $nextPageError, filterState: $filterState)';
  }
}

/// @nodoc
abstract mixin class _$GamesStateCopyWith<$Res>
    implements $GamesStateCopyWith<$Res> {
  factory _$GamesStateCopyWith(
          _GamesState value, $Res Function(_GamesState) _then) =
      __$GamesStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {GamesStatus status,
      GamesNextPageStatus? nextPageStatus,
      GameListEntity? response,
      List<GameEntity> games,
      ErrorType? error,
      ErrorType? nextPageError,
      FilterState filterState});

  @override
  $GameListEntityCopyWith<$Res>? get response;
  @override
  $ErrorTypeCopyWith<$Res>? get error;
  @override
  $ErrorTypeCopyWith<$Res>? get nextPageError;
  @override
  $FilterStateCopyWith<$Res> get filterState;
}

/// @nodoc
class __$GamesStateCopyWithImpl<$Res> implements _$GamesStateCopyWith<$Res> {
  __$GamesStateCopyWithImpl(this._self, this._then);

  final _GamesState _self;
  final $Res Function(_GamesState) _then;

  /// Create a copy of GamesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? nextPageStatus = freezed,
    Object? response = freezed,
    Object? games = null,
    Object? error = freezed,
    Object? nextPageError = freezed,
    Object? filterState = null,
  }) {
    return _then(_GamesState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as GamesStatus,
      nextPageStatus: freezed == nextPageStatus
          ? _self.nextPageStatus
          : nextPageStatus // ignore: cast_nullable_to_non_nullable
              as GamesNextPageStatus?,
      response: freezed == response
          ? _self.response
          : response // ignore: cast_nullable_to_non_nullable
              as GameListEntity?,
      games: null == games
          ? _self._games
          : games // ignore: cast_nullable_to_non_nullable
              as List<GameEntity>,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as ErrorType?,
      nextPageError: freezed == nextPageError
          ? _self.nextPageError
          : nextPageError // ignore: cast_nullable_to_non_nullable
              as ErrorType?,
      filterState: null == filterState
          ? _self.filterState
          : filterState // ignore: cast_nullable_to_non_nullable
              as FilterState,
    ));
  }

  /// Create a copy of GamesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameListEntityCopyWith<$Res>? get response {
    if (_self.response == null) {
      return null;
    }

    return $GameListEntityCopyWith<$Res>(_self.response!, (value) {
      return _then(_self.copyWith(response: value));
    });
  }

  /// Create a copy of GamesState
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

  /// Create a copy of GamesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ErrorTypeCopyWith<$Res>? get nextPageError {
    if (_self.nextPageError == null) {
      return null;
    }

    return $ErrorTypeCopyWith<$Res>(_self.nextPageError!, (value) {
      return _then(_self.copyWith(nextPageError: value));
    });
  }

  /// Create a copy of GamesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FilterStateCopyWith<$Res> get filterState {
    return $FilterStateCopyWith<$Res>(_self.filterState, (value) {
      return _then(_self.copyWith(filterState: value));
    });
  }
}

// dart format on

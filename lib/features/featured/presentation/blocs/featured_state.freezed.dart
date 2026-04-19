// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'featured_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeaturedState {
  FeaturedTag get tag;
  Set<GamePlatform> get platformsSelected;
  FeaturedStatus? get status;
  FeaturedNextPageStatus? get nextPageStatus;
  GamesResponse? get response;
  List<Game> get games;
  ErrorType? get error;
  ErrorType? get nextPageError;

  /// Create a copy of FeaturedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeaturedStateCopyWith<FeaturedState> get copyWith =>
      _$FeaturedStateCopyWithImpl<FeaturedState>(
          this as FeaturedState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeaturedState &&
            (identical(other.tag, tag) || other.tag == tag) &&
            const DeepCollectionEquality()
                .equals(other.platformsSelected, platformsSelected) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.nextPageStatus, nextPageStatus) ||
                other.nextPageStatus == nextPageStatus) &&
            (identical(other.response, response) ||
                other.response == response) &&
            const DeepCollectionEquality().equals(other.games, games) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.nextPageError, nextPageError) ||
                other.nextPageError == nextPageError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      tag,
      const DeepCollectionEquality().hash(platformsSelected),
      status,
      nextPageStatus,
      response,
      const DeepCollectionEquality().hash(games),
      error,
      nextPageError);

  @override
  String toString() {
    return 'FeaturedState(tag: $tag, platformsSelected: $platformsSelected, status: $status, nextPageStatus: $nextPageStatus, response: $response, games: $games, error: $error, nextPageError: $nextPageError)';
  }
}

/// @nodoc
abstract mixin class $FeaturedStateCopyWith<$Res> {
  factory $FeaturedStateCopyWith(
          FeaturedState value, $Res Function(FeaturedState) _then) =
      _$FeaturedStateCopyWithImpl;
  @useResult
  $Res call(
      {FeaturedTag tag,
      Set<GamePlatform> platformsSelected,
      FeaturedStatus? status,
      FeaturedNextPageStatus? nextPageStatus,
      GamesResponse? response,
      List<Game> games,
      ErrorType? error,
      ErrorType? nextPageError});

  $GamesResponseCopyWith<$Res>? get response;
  $ErrorTypeCopyWith<$Res>? get error;
  $ErrorTypeCopyWith<$Res>? get nextPageError;
}

/// @nodoc
class _$FeaturedStateCopyWithImpl<$Res>
    implements $FeaturedStateCopyWith<$Res> {
  _$FeaturedStateCopyWithImpl(this._self, this._then);

  final FeaturedState _self;
  final $Res Function(FeaturedState) _then;

  /// Create a copy of FeaturedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tag = null,
    Object? platformsSelected = null,
    Object? status = freezed,
    Object? nextPageStatus = freezed,
    Object? response = freezed,
    Object? games = null,
    Object? error = freezed,
    Object? nextPageError = freezed,
  }) {
    return _then(_self.copyWith(
      tag: null == tag
          ? _self.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as FeaturedTag,
      platformsSelected: null == platformsSelected
          ? _self.platformsSelected
          : platformsSelected // ignore: cast_nullable_to_non_nullable
              as Set<GamePlatform>,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as FeaturedStatus?,
      nextPageStatus: freezed == nextPageStatus
          ? _self.nextPageStatus
          : nextPageStatus // ignore: cast_nullable_to_non_nullable
              as FeaturedNextPageStatus?,
      response: freezed == response
          ? _self.response
          : response // ignore: cast_nullable_to_non_nullable
              as GamesResponse?,
      games: null == games
          ? _self.games
          : games // ignore: cast_nullable_to_non_nullable
              as List<Game>,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as ErrorType?,
      nextPageError: freezed == nextPageError
          ? _self.nextPageError
          : nextPageError // ignore: cast_nullable_to_non_nullable
              as ErrorType?,
    ));
  }

  /// Create a copy of FeaturedState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GamesResponseCopyWith<$Res>? get response {
    if (_self.response == null) {
      return null;
    }

    return $GamesResponseCopyWith<$Res>(_self.response!, (value) {
      return _then(_self.copyWith(response: value));
    });
  }

  /// Create a copy of FeaturedState
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

  /// Create a copy of FeaturedState
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
}

/// Adds pattern-matching-related methods to [FeaturedState].
extension FeaturedStatePatterns on FeaturedState {
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
    TResult Function(_FeaturedState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeaturedState() when $default != null:
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
    TResult Function(_FeaturedState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeaturedState():
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
    TResult? Function(_FeaturedState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeaturedState() when $default != null:
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
            FeaturedTag tag,
            Set<GamePlatform> platformsSelected,
            FeaturedStatus? status,
            FeaturedNextPageStatus? nextPageStatus,
            GamesResponse? response,
            List<Game> games,
            ErrorType? error,
            ErrorType? nextPageError)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeaturedState() when $default != null:
        return $default(
            _that.tag,
            _that.platformsSelected,
            _that.status,
            _that.nextPageStatus,
            _that.response,
            _that.games,
            _that.error,
            _that.nextPageError);
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
            FeaturedTag tag,
            Set<GamePlatform> platformsSelected,
            FeaturedStatus? status,
            FeaturedNextPageStatus? nextPageStatus,
            GamesResponse? response,
            List<Game> games,
            ErrorType? error,
            ErrorType? nextPageError)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeaturedState():
        return $default(
            _that.tag,
            _that.platformsSelected,
            _that.status,
            _that.nextPageStatus,
            _that.response,
            _that.games,
            _that.error,
            _that.nextPageError);
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
            FeaturedTag tag,
            Set<GamePlatform> platformsSelected,
            FeaturedStatus? status,
            FeaturedNextPageStatus? nextPageStatus,
            GamesResponse? response,
            List<Game> games,
            ErrorType? error,
            ErrorType? nextPageError)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeaturedState() when $default != null:
        return $default(
            _that.tag,
            _that.platformsSelected,
            _that.status,
            _that.nextPageStatus,
            _that.response,
            _that.games,
            _that.error,
            _that.nextPageError);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FeaturedState implements FeaturedState {
  const _FeaturedState(
      {this.tag = FeaturedTag.newAndTrending,
      final Set<GamePlatform> platformsSelected = const <GamePlatform>{},
      this.status = FeaturedStatus.initial,
      this.nextPageStatus = FeaturedNextPageStatus.initial,
      this.response,
      final List<Game> games = const <Game>[],
      this.error,
      this.nextPageError})
      : _platformsSelected = platformsSelected,
        _games = games;

  @override
  @JsonKey()
  final FeaturedTag tag;
  final Set<GamePlatform> _platformsSelected;
  @override
  @JsonKey()
  Set<GamePlatform> get platformsSelected {
    if (_platformsSelected is EqualUnmodifiableSetView)
      return _platformsSelected;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_platformsSelected);
  }

  @override
  @JsonKey()
  final FeaturedStatus? status;
  @override
  @JsonKey()
  final FeaturedNextPageStatus? nextPageStatus;
  @override
  final GamesResponse? response;
  final List<Game> _games;
  @override
  @JsonKey()
  List<Game> get games {
    if (_games is EqualUnmodifiableListView) return _games;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_games);
  }

  @override
  final ErrorType? error;
  @override
  final ErrorType? nextPageError;

  /// Create a copy of FeaturedState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FeaturedStateCopyWith<_FeaturedState> get copyWith =>
      __$FeaturedStateCopyWithImpl<_FeaturedState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FeaturedState &&
            (identical(other.tag, tag) || other.tag == tag) &&
            const DeepCollectionEquality()
                .equals(other._platformsSelected, _platformsSelected) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.nextPageStatus, nextPageStatus) ||
                other.nextPageStatus == nextPageStatus) &&
            (identical(other.response, response) ||
                other.response == response) &&
            const DeepCollectionEquality().equals(other._games, _games) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.nextPageError, nextPageError) ||
                other.nextPageError == nextPageError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      tag,
      const DeepCollectionEquality().hash(_platformsSelected),
      status,
      nextPageStatus,
      response,
      const DeepCollectionEquality().hash(_games),
      error,
      nextPageError);

  @override
  String toString() {
    return 'FeaturedState(tag: $tag, platformsSelected: $platformsSelected, status: $status, nextPageStatus: $nextPageStatus, response: $response, games: $games, error: $error, nextPageError: $nextPageError)';
  }
}

/// @nodoc
abstract mixin class _$FeaturedStateCopyWith<$Res>
    implements $FeaturedStateCopyWith<$Res> {
  factory _$FeaturedStateCopyWith(
          _FeaturedState value, $Res Function(_FeaturedState) _then) =
      __$FeaturedStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {FeaturedTag tag,
      Set<GamePlatform> platformsSelected,
      FeaturedStatus? status,
      FeaturedNextPageStatus? nextPageStatus,
      GamesResponse? response,
      List<Game> games,
      ErrorType? error,
      ErrorType? nextPageError});

  @override
  $GamesResponseCopyWith<$Res>? get response;
  @override
  $ErrorTypeCopyWith<$Res>? get error;
  @override
  $ErrorTypeCopyWith<$Res>? get nextPageError;
}

/// @nodoc
class __$FeaturedStateCopyWithImpl<$Res>
    implements _$FeaturedStateCopyWith<$Res> {
  __$FeaturedStateCopyWithImpl(this._self, this._then);

  final _FeaturedState _self;
  final $Res Function(_FeaturedState) _then;

  /// Create a copy of FeaturedState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? tag = null,
    Object? platformsSelected = null,
    Object? status = freezed,
    Object? nextPageStatus = freezed,
    Object? response = freezed,
    Object? games = null,
    Object? error = freezed,
    Object? nextPageError = freezed,
  }) {
    return _then(_FeaturedState(
      tag: null == tag
          ? _self.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as FeaturedTag,
      platformsSelected: null == platformsSelected
          ? _self._platformsSelected
          : platformsSelected // ignore: cast_nullable_to_non_nullable
              as Set<GamePlatform>,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as FeaturedStatus?,
      nextPageStatus: freezed == nextPageStatus
          ? _self.nextPageStatus
          : nextPageStatus // ignore: cast_nullable_to_non_nullable
              as FeaturedNextPageStatus?,
      response: freezed == response
          ? _self.response
          : response // ignore: cast_nullable_to_non_nullable
              as GamesResponse?,
      games: null == games
          ? _self._games
          : games // ignore: cast_nullable_to_non_nullable
              as List<Game>,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as ErrorType?,
      nextPageError: freezed == nextPageError
          ? _self.nextPageError
          : nextPageError // ignore: cast_nullable_to_non_nullable
              as ErrorType?,
    ));
  }

  /// Create a copy of FeaturedState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GamesResponseCopyWith<$Res>? get response {
    if (_self.response == null) {
      return null;
    }

    return $GamesResponseCopyWith<$Res>(_self.response!, (value) {
      return _then(_self.copyWith(response: value));
    });
  }

  /// Create a copy of FeaturedState
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

  /// Create a copy of FeaturedState
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
}

// dart format on

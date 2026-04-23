// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_screenshot_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameScreenshotState {
  ScreenshotsStatus get status;
  GameScreenshotEntity? get response;
  ErrorType? get error;

  /// Create a copy of GameScreenshotState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GameScreenshotStateCopyWith<GameScreenshotState> get copyWith =>
      _$GameScreenshotStateCopyWithImpl<GameScreenshotState>(
          this as GameScreenshotState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GameScreenshotState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, response, error);

  @override
  String toString() {
    return 'GameScreenshotState(status: $status, response: $response, error: $error)';
  }
}

/// @nodoc
abstract mixin class $GameScreenshotStateCopyWith<$Res> {
  factory $GameScreenshotStateCopyWith(
          GameScreenshotState value, $Res Function(GameScreenshotState) _then) =
      _$GameScreenshotStateCopyWithImpl;
  @useResult
  $Res call(
      {ScreenshotsStatus status,
      GameScreenshotEntity? response,
      ErrorType? error});

  $GameScreenshotEntityCopyWith<$Res>? get response;
  $ErrorTypeCopyWith<$Res>? get error;
}

/// @nodoc
class _$GameScreenshotStateCopyWithImpl<$Res>
    implements $GameScreenshotStateCopyWith<$Res> {
  _$GameScreenshotStateCopyWithImpl(this._self, this._then);

  final GameScreenshotState _self;
  final $Res Function(GameScreenshotState) _then;

  /// Create a copy of GameScreenshotState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? response = freezed,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ScreenshotsStatus,
      response: freezed == response
          ? _self.response
          : response // ignore: cast_nullable_to_non_nullable
              as GameScreenshotEntity?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as ErrorType?,
    ));
  }

  /// Create a copy of GameScreenshotState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameScreenshotEntityCopyWith<$Res>? get response {
    if (_self.response == null) {
      return null;
    }

    return $GameScreenshotEntityCopyWith<$Res>(_self.response!, (value) {
      return _then(_self.copyWith(response: value));
    });
  }

  /// Create a copy of GameScreenshotState
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

/// Adds pattern-matching-related methods to [GameScreenshotState].
extension GameScreenshotStatePatterns on GameScreenshotState {
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
    TResult Function(_GameScreenshotState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GameScreenshotState() when $default != null:
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
    TResult Function(_GameScreenshotState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameScreenshotState():
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
    TResult? Function(_GameScreenshotState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameScreenshotState() when $default != null:
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
    TResult Function(ScreenshotsStatus status, GameScreenshotEntity? response,
            ErrorType? error)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GameScreenshotState() when $default != null:
        return $default(_that.status, _that.response, _that.error);
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
    TResult Function(ScreenshotsStatus status, GameScreenshotEntity? response,
            ErrorType? error)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameScreenshotState():
        return $default(_that.status, _that.response, _that.error);
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
    TResult? Function(ScreenshotsStatus status, GameScreenshotEntity? response,
            ErrorType? error)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameScreenshotState() when $default != null:
        return $default(_that.status, _that.response, _that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _GameScreenshotState implements GameScreenshotState {
  const _GameScreenshotState(
      {this.status = ScreenshotsStatus.loading, this.response, this.error});

  @override
  @JsonKey()
  final ScreenshotsStatus status;
  @override
  final GameScreenshotEntity? response;
  @override
  final ErrorType? error;

  /// Create a copy of GameScreenshotState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GameScreenshotStateCopyWith<_GameScreenshotState> get copyWith =>
      __$GameScreenshotStateCopyWithImpl<_GameScreenshotState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GameScreenshotState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, response, error);

  @override
  String toString() {
    return 'GameScreenshotState(status: $status, response: $response, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$GameScreenshotStateCopyWith<$Res>
    implements $GameScreenshotStateCopyWith<$Res> {
  factory _$GameScreenshotStateCopyWith(_GameScreenshotState value,
          $Res Function(_GameScreenshotState) _then) =
      __$GameScreenshotStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {ScreenshotsStatus status,
      GameScreenshotEntity? response,
      ErrorType? error});

  @override
  $GameScreenshotEntityCopyWith<$Res>? get response;
  @override
  $ErrorTypeCopyWith<$Res>? get error;
}

/// @nodoc
class __$GameScreenshotStateCopyWithImpl<$Res>
    implements _$GameScreenshotStateCopyWith<$Res> {
  __$GameScreenshotStateCopyWithImpl(this._self, this._then);

  final _GameScreenshotState _self;
  final $Res Function(_GameScreenshotState) _then;

  /// Create a copy of GameScreenshotState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? response = freezed,
    Object? error = freezed,
  }) {
    return _then(_GameScreenshotState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ScreenshotsStatus,
      response: freezed == response
          ? _self.response
          : response // ignore: cast_nullable_to_non_nullable
              as GameScreenshotEntity?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as ErrorType?,
    ));
  }

  /// Create a copy of GameScreenshotState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameScreenshotEntityCopyWith<$Res>? get response {
    if (_self.response == null) {
      return null;
    }

    return $GameScreenshotEntityCopyWith<$Res>(_self.response!, (value) {
      return _then(_self.copyWith(response: value));
    });
  }

  /// Create a copy of GameScreenshotState
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

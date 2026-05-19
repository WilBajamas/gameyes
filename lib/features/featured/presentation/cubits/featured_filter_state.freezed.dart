// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'featured_filter_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeaturedFilterState {
  Set<GamePlatform> get platformsSelected;
  Set<GamePlatform> get tempPlatformsSelected;

  /// Create a copy of FeaturedFilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeaturedFilterStateCopyWith<FeaturedFilterState> get copyWith =>
      _$FeaturedFilterStateCopyWithImpl<FeaturedFilterState>(
          this as FeaturedFilterState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeaturedFilterState &&
            const DeepCollectionEquality()
                .equals(other.platformsSelected, platformsSelected) &&
            const DeepCollectionEquality()
                .equals(other.tempPlatformsSelected, tempPlatformsSelected));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(platformsSelected),
      const DeepCollectionEquality().hash(tempPlatformsSelected));

  @override
  String toString() {
    return 'FeaturedFilterState(platformsSelected: $platformsSelected, tempPlatformsSelected: $tempPlatformsSelected)';
  }
}

/// @nodoc
abstract mixin class $FeaturedFilterStateCopyWith<$Res> {
  factory $FeaturedFilterStateCopyWith(
          FeaturedFilterState value, $Res Function(FeaturedFilterState) _then) =
      _$FeaturedFilterStateCopyWithImpl;
  @useResult
  $Res call(
      {Set<GamePlatform> platformsSelected,
      Set<GamePlatform> tempPlatformsSelected});
}

/// @nodoc
class _$FeaturedFilterStateCopyWithImpl<$Res>
    implements $FeaturedFilterStateCopyWith<$Res> {
  _$FeaturedFilterStateCopyWithImpl(this._self, this._then);

  final FeaturedFilterState _self;
  final $Res Function(FeaturedFilterState) _then;

  /// Create a copy of FeaturedFilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? platformsSelected = null,
    Object? tempPlatformsSelected = null,
  }) {
    return _then(_self.copyWith(
      platformsSelected: null == platformsSelected
          ? _self.platformsSelected
          : platformsSelected // ignore: cast_nullable_to_non_nullable
              as Set<GamePlatform>,
      tempPlatformsSelected: null == tempPlatformsSelected
          ? _self.tempPlatformsSelected
          : tempPlatformsSelected // ignore: cast_nullable_to_non_nullable
              as Set<GamePlatform>,
    ));
  }
}

/// Adds pattern-matching-related methods to [FeaturedFilterState].
extension FeaturedFilterStatePatterns on FeaturedFilterState {
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
    TResult Function(_FeaturedFilterState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeaturedFilterState() when $default != null:
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
    TResult Function(_FeaturedFilterState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeaturedFilterState():
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
    TResult? Function(_FeaturedFilterState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeaturedFilterState() when $default != null:
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
    TResult Function(Set<GamePlatform> platformsSelected,
            Set<GamePlatform> tempPlatformsSelected)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeaturedFilterState() when $default != null:
        return $default(_that.platformsSelected, _that.tempPlatformsSelected);
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
    TResult Function(Set<GamePlatform> platformsSelected,
            Set<GamePlatform> tempPlatformsSelected)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeaturedFilterState():
        return $default(_that.platformsSelected, _that.tempPlatformsSelected);
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
    TResult? Function(Set<GamePlatform> platformsSelected,
            Set<GamePlatform> tempPlatformsSelected)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeaturedFilterState() when $default != null:
        return $default(_that.platformsSelected, _that.tempPlatformsSelected);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FeaturedFilterState implements FeaturedFilterState {
  const _FeaturedFilterState(
      {final Set<GamePlatform> platformsSelected = const <GamePlatform>{},
      final Set<GamePlatform> tempPlatformsSelected = const <GamePlatform>{}})
      : _platformsSelected = platformsSelected,
        _tempPlatformsSelected = tempPlatformsSelected;

  final Set<GamePlatform> _platformsSelected;
  @override
  @JsonKey()
  Set<GamePlatform> get platformsSelected {
    if (_platformsSelected is EqualUnmodifiableSetView)
      return _platformsSelected;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_platformsSelected);
  }

  final Set<GamePlatform> _tempPlatformsSelected;
  @override
  @JsonKey()
  Set<GamePlatform> get tempPlatformsSelected {
    if (_tempPlatformsSelected is EqualUnmodifiableSetView)
      return _tempPlatformsSelected;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_tempPlatformsSelected);
  }

  /// Create a copy of FeaturedFilterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FeaturedFilterStateCopyWith<_FeaturedFilterState> get copyWith =>
      __$FeaturedFilterStateCopyWithImpl<_FeaturedFilterState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FeaturedFilterState &&
            const DeepCollectionEquality()
                .equals(other._platformsSelected, _platformsSelected) &&
            const DeepCollectionEquality()
                .equals(other._tempPlatformsSelected, _tempPlatformsSelected));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_platformsSelected),
      const DeepCollectionEquality().hash(_tempPlatformsSelected));

  @override
  String toString() {
    return 'FeaturedFilterState(platformsSelected: $platformsSelected, tempPlatformsSelected: $tempPlatformsSelected)';
  }
}

/// @nodoc
abstract mixin class _$FeaturedFilterStateCopyWith<$Res>
    implements $FeaturedFilterStateCopyWith<$Res> {
  factory _$FeaturedFilterStateCopyWith(_FeaturedFilterState value,
          $Res Function(_FeaturedFilterState) _then) =
      __$FeaturedFilterStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Set<GamePlatform> platformsSelected,
      Set<GamePlatform> tempPlatformsSelected});
}

/// @nodoc
class __$FeaturedFilterStateCopyWithImpl<$Res>
    implements _$FeaturedFilterStateCopyWith<$Res> {
  __$FeaturedFilterStateCopyWithImpl(this._self, this._then);

  final _FeaturedFilterState _self;
  final $Res Function(_FeaturedFilterState) _then;

  /// Create a copy of FeaturedFilterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? platformsSelected = null,
    Object? tempPlatformsSelected = null,
  }) {
    return _then(_FeaturedFilterState(
      platformsSelected: null == platformsSelected
          ? _self._platformsSelected
          : platformsSelected // ignore: cast_nullable_to_non_nullable
              as Set<GamePlatform>,
      tempPlatformsSelected: null == tempPlatformsSelected
          ? _self._tempPlatformsSelected
          : tempPlatformsSelected // ignore: cast_nullable_to_non_nullable
              as Set<GamePlatform>,
    ));
  }
}

// dart format on

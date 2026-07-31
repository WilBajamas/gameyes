// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracker_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackerState {
  SavedGameFilterTag get tag;
  String? get searchTerm;

  /// Create a copy of TrackerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TrackerStateCopyWith<TrackerState> get copyWith =>
      _$TrackerStateCopyWithImpl<TrackerState>(
          this as TrackerState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TrackerState &&
            (identical(other.tag, tag) || other.tag == tag) &&
            (identical(other.searchTerm, searchTerm) ||
                other.searchTerm == searchTerm));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tag, searchTerm);

  @override
  String toString() {
    return 'TrackerState(tag: $tag, searchTerm: $searchTerm)';
  }
}

/// @nodoc
abstract mixin class $TrackerStateCopyWith<$Res> {
  factory $TrackerStateCopyWith(
          TrackerState value, $Res Function(TrackerState) _then) =
      _$TrackerStateCopyWithImpl;
  @useResult
  $Res call({SavedGameFilterTag tag, String? searchTerm});
}

/// @nodoc
class _$TrackerStateCopyWithImpl<$Res> implements $TrackerStateCopyWith<$Res> {
  _$TrackerStateCopyWithImpl(this._self, this._then);

  final TrackerState _self;
  final $Res Function(TrackerState) _then;

  /// Create a copy of TrackerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tag = null,
    Object? searchTerm = freezed,
  }) {
    return _then(_self.copyWith(
      tag: null == tag
          ? _self.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as SavedGameFilterTag,
      searchTerm: freezed == searchTerm
          ? _self.searchTerm
          : searchTerm // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TrackerState].
extension TrackerStatePatterns on TrackerState {
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
    TResult Function(_TrackerState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrackerState() when $default != null:
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
    TResult Function(_TrackerState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackerState():
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
    TResult? Function(_TrackerState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackerState() when $default != null:
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
    TResult Function(SavedGameFilterTag tag, String? searchTerm)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrackerState() when $default != null:
        return $default(_that.tag, _that.searchTerm);
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
    TResult Function(SavedGameFilterTag tag, String? searchTerm) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackerState():
        return $default(_that.tag, _that.searchTerm);
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
    TResult? Function(SavedGameFilterTag tag, String? searchTerm)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackerState() when $default != null:
        return $default(_that.tag, _that.searchTerm);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _TrackerState implements TrackerState {
  const _TrackerState(
      {this.tag = SavedGameFilterTag.recentlyChanged, this.searchTerm});

  @override
  @JsonKey()
  final SavedGameFilterTag tag;
  @override
  final String? searchTerm;

  /// Create a copy of TrackerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TrackerStateCopyWith<_TrackerState> get copyWith =>
      __$TrackerStateCopyWithImpl<_TrackerState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TrackerState &&
            (identical(other.tag, tag) || other.tag == tag) &&
            (identical(other.searchTerm, searchTerm) ||
                other.searchTerm == searchTerm));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tag, searchTerm);

  @override
  String toString() {
    return 'TrackerState(tag: $tag, searchTerm: $searchTerm)';
  }
}

/// @nodoc
abstract mixin class _$TrackerStateCopyWith<$Res>
    implements $TrackerStateCopyWith<$Res> {
  factory _$TrackerStateCopyWith(
          _TrackerState value, $Res Function(_TrackerState) _then) =
      __$TrackerStateCopyWithImpl;
  @override
  @useResult
  $Res call({SavedGameFilterTag tag, String? searchTerm});
}

/// @nodoc
class __$TrackerStateCopyWithImpl<$Res>
    implements _$TrackerStateCopyWith<$Res> {
  __$TrackerStateCopyWithImpl(this._self, this._then);

  final _TrackerState _self;
  final $Res Function(_TrackerState) _then;

  /// Create a copy of TrackerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? tag = null,
    Object? searchTerm = freezed,
  }) {
    return _then(_TrackerState(
      tag: null == tag
          ? _self.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as SavedGameFilterTag,
      searchTerm: freezed == searchTerm
          ? _self.searchTerm
          : searchTerm // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on

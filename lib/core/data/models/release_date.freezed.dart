// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'release_date.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReleaseDate {
  int? get date;
  String? get human;

  /// Create a copy of ReleaseDate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReleaseDateCopyWith<ReleaseDate> get copyWith =>
      _$ReleaseDateCopyWithImpl<ReleaseDate>(this as ReleaseDate, _$identity);

  /// Serializes this ReleaseDate to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReleaseDate &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.human, human) || other.human == human));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, human);

  @override
  String toString() {
    return 'ReleaseDate(date: $date, human: $human)';
  }
}

/// @nodoc
abstract mixin class $ReleaseDateCopyWith<$Res> {
  factory $ReleaseDateCopyWith(
          ReleaseDate value, $Res Function(ReleaseDate) _then) =
      _$ReleaseDateCopyWithImpl;
  @useResult
  $Res call({int? date, String? human});
}

/// @nodoc
class _$ReleaseDateCopyWithImpl<$Res> implements $ReleaseDateCopyWith<$Res> {
  _$ReleaseDateCopyWithImpl(this._self, this._then);

  final ReleaseDate _self;
  final $Res Function(ReleaseDate) _then;

  /// Create a copy of ReleaseDate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = freezed,
    Object? human = freezed,
  }) {
    return _then(_self.copyWith(
      date: freezed == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as int?,
      human: freezed == human
          ? _self.human
          : human // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ReleaseDate].
extension ReleaseDatePatterns on ReleaseDate {
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
    TResult Function(_ReleaseDate value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReleaseDate() when $default != null:
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
    TResult Function(_ReleaseDate value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReleaseDate():
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
    TResult? Function(_ReleaseDate value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReleaseDate() when $default != null:
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
    TResult Function(int? date, String? human)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReleaseDate() when $default != null:
        return $default(_that.date, _that.human);
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
    TResult Function(int? date, String? human) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReleaseDate():
        return $default(_that.date, _that.human);
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
    TResult? Function(int? date, String? human)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReleaseDate() when $default != null:
        return $default(_that.date, _that.human);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ReleaseDate extends ReleaseDate {
  const _ReleaseDate({this.date, this.human}) : super._();
  factory _ReleaseDate.fromJson(Map<String, dynamic> json) =>
      _$ReleaseDateFromJson(json);

  @override
  final int? date;
  @override
  final String? human;

  /// Create a copy of ReleaseDate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReleaseDateCopyWith<_ReleaseDate> get copyWith =>
      __$ReleaseDateCopyWithImpl<_ReleaseDate>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ReleaseDateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReleaseDate &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.human, human) || other.human == human));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, human);

  @override
  String toString() {
    return 'ReleaseDate(date: $date, human: $human)';
  }
}

/// @nodoc
abstract mixin class _$ReleaseDateCopyWith<$Res>
    implements $ReleaseDateCopyWith<$Res> {
  factory _$ReleaseDateCopyWith(
          _ReleaseDate value, $Res Function(_ReleaseDate) _then) =
      __$ReleaseDateCopyWithImpl;
  @override
  @useResult
  $Res call({int? date, String? human});
}

/// @nodoc
class __$ReleaseDateCopyWithImpl<$Res> implements _$ReleaseDateCopyWith<$Res> {
  __$ReleaseDateCopyWithImpl(this._self, this._then);

  final _ReleaseDate _self;
  final $Res Function(_ReleaseDate) _then;

  /// Create a copy of ReleaseDate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = freezed,
    Object? human = freezed,
  }) {
    return _then(_ReleaseDate(
      date: freezed == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as int?,
      human: freezed == human
          ? _self.human
          : human // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'screenshot_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScreenshotResponse {
  List<Screenshot> get results;

  /// Create a copy of ScreenshotResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScreenshotResponseCopyWith<ScreenshotResponse> get copyWith =>
      _$ScreenshotResponseCopyWithImpl<ScreenshotResponse>(
          this as ScreenshotResponse, _$identity);

  /// Serializes this ScreenshotResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScreenshotResponse &&
            const DeepCollectionEquality().equals(other.results, results));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(results));

  @override
  String toString() {
    return 'ScreenshotResponse(results: $results)';
  }
}

/// @nodoc
abstract mixin class $ScreenshotResponseCopyWith<$Res> {
  factory $ScreenshotResponseCopyWith(
          ScreenshotResponse value, $Res Function(ScreenshotResponse) _then) =
      _$ScreenshotResponseCopyWithImpl;
  @useResult
  $Res call({List<Screenshot> results});
}

/// @nodoc
class _$ScreenshotResponseCopyWithImpl<$Res>
    implements $ScreenshotResponseCopyWith<$Res> {
  _$ScreenshotResponseCopyWithImpl(this._self, this._then);

  final ScreenshotResponse _self;
  final $Res Function(ScreenshotResponse) _then;

  /// Create a copy of ScreenshotResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = null,
  }) {
    return _then(_self.copyWith(
      results: null == results
          ? _self.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<Screenshot>,
    ));
  }
}

/// Adds pattern-matching-related methods to [ScreenshotResponse].
extension ScreenshotResponsePatterns on ScreenshotResponse {
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
    TResult Function(_ScreenshotResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScreenshotResponse() when $default != null:
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
    TResult Function(_ScreenshotResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScreenshotResponse():
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
    TResult? Function(_ScreenshotResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScreenshotResponse() when $default != null:
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
    TResult Function(List<Screenshot> results)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScreenshotResponse() when $default != null:
        return $default(_that.results);
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
    TResult Function(List<Screenshot> results) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScreenshotResponse():
        return $default(_that.results);
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
    TResult? Function(List<Screenshot> results)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScreenshotResponse() when $default != null:
        return $default(_that.results);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ScreenshotResponse extends ScreenshotResponse {
  const _ScreenshotResponse({required final List<Screenshot> results})
      : _results = results,
        super._();
  factory _ScreenshotResponse.fromJson(Map<String, dynamic> json) =>
      _$ScreenshotResponseFromJson(json);

  final List<Screenshot> _results;
  @override
  List<Screenshot> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  /// Create a copy of ScreenshotResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ScreenshotResponseCopyWith<_ScreenshotResponse> get copyWith =>
      __$ScreenshotResponseCopyWithImpl<_ScreenshotResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ScreenshotResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ScreenshotResponse &&
            const DeepCollectionEquality().equals(other._results, _results));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_results));

  @override
  String toString() {
    return 'ScreenshotResponse(results: $results)';
  }
}

/// @nodoc
abstract mixin class _$ScreenshotResponseCopyWith<$Res>
    implements $ScreenshotResponseCopyWith<$Res> {
  factory _$ScreenshotResponseCopyWith(
          _ScreenshotResponse value, $Res Function(_ScreenshotResponse) _then) =
      __$ScreenshotResponseCopyWithImpl;
  @override
  @useResult
  $Res call({List<Screenshot> results});
}

/// @nodoc
class __$ScreenshotResponseCopyWithImpl<$Res>
    implements _$ScreenshotResponseCopyWith<$Res> {
  __$ScreenshotResponseCopyWithImpl(this._self, this._then);

  final _ScreenshotResponse _self;
  final $Res Function(_ScreenshotResponse) _then;

  /// Create a copy of ScreenshotResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? results = null,
  }) {
    return _then(_ScreenshotResponse(
      results: null == results
          ? _self._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<Screenshot>,
    ));
  }
}

// dart format on

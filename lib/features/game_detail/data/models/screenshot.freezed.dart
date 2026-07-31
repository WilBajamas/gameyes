// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'screenshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Screenshot {
  String? get image;

  /// Create a copy of Screenshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScreenshotCopyWith<Screenshot> get copyWith =>
      _$ScreenshotCopyWithImpl<Screenshot>(this as Screenshot, _$identity);

  /// Serializes this Screenshot to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Screenshot &&
            (identical(other.image, image) || other.image == image));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, image);

  @override
  String toString() {
    return 'Screenshot(image: $image)';
  }
}

/// @nodoc
abstract mixin class $ScreenshotCopyWith<$Res> {
  factory $ScreenshotCopyWith(
          Screenshot value, $Res Function(Screenshot) _then) =
      _$ScreenshotCopyWithImpl;
  @useResult
  $Res call({String? image});
}

/// @nodoc
class _$ScreenshotCopyWithImpl<$Res> implements $ScreenshotCopyWith<$Res> {
  _$ScreenshotCopyWithImpl(this._self, this._then);

  final Screenshot _self;
  final $Res Function(Screenshot) _then;

  /// Create a copy of Screenshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? image = freezed,
  }) {
    return _then(_self.copyWith(
      image: freezed == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Screenshot].
extension ScreenshotPatterns on Screenshot {
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
    TResult Function(_Screenshot value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Screenshot() when $default != null:
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
    TResult Function(_Screenshot value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Screenshot():
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
    TResult? Function(_Screenshot value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Screenshot() when $default != null:
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
    TResult Function(String? image)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Screenshot() when $default != null:
        return $default(_that.image);
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
    TResult Function(String? image) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Screenshot():
        return $default(_that.image);
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
    TResult? Function(String? image)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Screenshot() when $default != null:
        return $default(_that.image);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Screenshot implements Screenshot {
  const _Screenshot({this.image});
  factory _Screenshot.fromJson(Map<String, dynamic> json) =>
      _$ScreenshotFromJson(json);

  @override
  final String? image;

  /// Create a copy of Screenshot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ScreenshotCopyWith<_Screenshot> get copyWith =>
      __$ScreenshotCopyWithImpl<_Screenshot>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ScreenshotToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Screenshot &&
            (identical(other.image, image) || other.image == image));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, image);

  @override
  String toString() {
    return 'Screenshot(image: $image)';
  }
}

/// @nodoc
abstract mixin class _$ScreenshotCopyWith<$Res>
    implements $ScreenshotCopyWith<$Res> {
  factory _$ScreenshotCopyWith(
          _Screenshot value, $Res Function(_Screenshot) _then) =
      __$ScreenshotCopyWithImpl;
  @override
  @useResult
  $Res call({String? image});
}

/// @nodoc
class __$ScreenshotCopyWithImpl<$Res> implements _$ScreenshotCopyWith<$Res> {
  __$ScreenshotCopyWithImpl(this._self, this._then);

  final _Screenshot _self;
  final $Res Function(_Screenshot) _then;

  /// Create a copy of Screenshot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? image = freezed,
  }) {
    return _then(_Screenshot(
      image: freezed == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on

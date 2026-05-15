// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'platform_logo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlatformLogo {
  String? get url;

  /// Create a copy of PlatformLogo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlatformLogoCopyWith<PlatformLogo> get copyWith =>
      _$PlatformLogoCopyWithImpl<PlatformLogo>(
          this as PlatformLogo, _$identity);

  /// Serializes this PlatformLogo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PlatformLogo &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url);

  @override
  String toString() {
    return 'PlatformLogo(url: $url)';
  }
}

/// @nodoc
abstract mixin class $PlatformLogoCopyWith<$Res> {
  factory $PlatformLogoCopyWith(
          PlatformLogo value, $Res Function(PlatformLogo) _then) =
      _$PlatformLogoCopyWithImpl;
  @useResult
  $Res call({String? url});
}

/// @nodoc
class _$PlatformLogoCopyWithImpl<$Res> implements $PlatformLogoCopyWith<$Res> {
  _$PlatformLogoCopyWithImpl(this._self, this._then);

  final PlatformLogo _self;
  final $Res Function(PlatformLogo) _then;

  /// Create a copy of PlatformLogo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
  }) {
    return _then(_self.copyWith(
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PlatformLogo].
extension PlatformLogoPatterns on PlatformLogo {
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
    TResult Function(_PlatformLogo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlatformLogo() when $default != null:
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
    TResult Function(_PlatformLogo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlatformLogo():
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
    TResult? Function(_PlatformLogo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlatformLogo() when $default != null:
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
    TResult Function(String? url)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlatformLogo() when $default != null:
        return $default(_that.url);
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
    TResult Function(String? url) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlatformLogo():
        return $default(_that.url);
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
    TResult? Function(String? url)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlatformLogo() when $default != null:
        return $default(_that.url);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PlatformLogo extends PlatformLogo {
  const _PlatformLogo({this.url}) : super._();
  factory _PlatformLogo.fromJson(Map<String, dynamic> json) =>
      _$PlatformLogoFromJson(json);

  @override
  final String? url;

  /// Create a copy of PlatformLogo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PlatformLogoCopyWith<_PlatformLogo> get copyWith =>
      __$PlatformLogoCopyWithImpl<_PlatformLogo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PlatformLogoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PlatformLogo &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url);

  @override
  String toString() {
    return 'PlatformLogo(url: $url)';
  }
}

/// @nodoc
abstract mixin class _$PlatformLogoCopyWith<$Res>
    implements $PlatformLogoCopyWith<$Res> {
  factory _$PlatformLogoCopyWith(
          _PlatformLogo value, $Res Function(_PlatformLogo) _then) =
      __$PlatformLogoCopyWithImpl;
  @override
  @useResult
  $Res call({String? url});
}

/// @nodoc
class __$PlatformLogoCopyWithImpl<$Res>
    implements _$PlatformLogoCopyWith<$Res> {
  __$PlatformLogoCopyWithImpl(this._self, this._then);

  final _PlatformLogo _self;
  final $Res Function(_PlatformLogo) _then;

  /// Create a copy of PlatformLogo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? url = freezed,
  }) {
    return _then(_PlatformLogo(
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on

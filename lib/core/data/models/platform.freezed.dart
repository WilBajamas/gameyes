// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'platform.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Platform {
  int? get id;
  String? get name;
  String? get abbreviation;
  @JsonKey(name: 'platform_logo')
  PlatformLogo? get platformLogo;

  /// Create a copy of Platform
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlatformCopyWith<Platform> get copyWith =>
      _$PlatformCopyWithImpl<Platform>(this as Platform, _$identity);

  /// Serializes this Platform to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Platform &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.abbreviation, abbreviation) ||
                other.abbreviation == abbreviation) &&
            (identical(other.platformLogo, platformLogo) ||
                other.platformLogo == platformLogo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, abbreviation, platformLogo);

  @override
  String toString() {
    return 'Platform(id: $id, name: $name, abbreviation: $abbreviation, platformLogo: $platformLogo)';
  }
}

/// @nodoc
abstract mixin class $PlatformCopyWith<$Res> {
  factory $PlatformCopyWith(Platform value, $Res Function(Platform) _then) =
      _$PlatformCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? abbreviation,
      @JsonKey(name: 'platform_logo') PlatformLogo? platformLogo});

  $PlatformLogoCopyWith<$Res>? get platformLogo;
}

/// @nodoc
class _$PlatformCopyWithImpl<$Res> implements $PlatformCopyWith<$Res> {
  _$PlatformCopyWithImpl(this._self, this._then);

  final Platform _self;
  final $Res Function(Platform) _then;

  /// Create a copy of Platform
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? abbreviation = freezed,
    Object? platformLogo = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      abbreviation: freezed == abbreviation
          ? _self.abbreviation
          : abbreviation // ignore: cast_nullable_to_non_nullable
              as String?,
      platformLogo: freezed == platformLogo
          ? _self.platformLogo
          : platformLogo // ignore: cast_nullable_to_non_nullable
              as PlatformLogo?,
    ));
  }

  /// Create a copy of Platform
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlatformLogoCopyWith<$Res>? get platformLogo {
    if (_self.platformLogo == null) {
      return null;
    }

    return $PlatformLogoCopyWith<$Res>(_self.platformLogo!, (value) {
      return _then(_self.copyWith(platformLogo: value));
    });
  }
}

/// Adds pattern-matching-related methods to [Platform].
extension PlatformPatterns on Platform {
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
    TResult Function(_Platform value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Platform() when $default != null:
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
    TResult Function(_Platform value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Platform():
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
    TResult? Function(_Platform value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Platform() when $default != null:
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
    TResult Function(int? id, String? name, String? abbreviation,
            @JsonKey(name: 'platform_logo') PlatformLogo? platformLogo)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Platform() when $default != null:
        return $default(
            _that.id, _that.name, _that.abbreviation, _that.platformLogo);
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
    TResult Function(int? id, String? name, String? abbreviation,
            @JsonKey(name: 'platform_logo') PlatformLogo? platformLogo)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Platform():
        return $default(
            _that.id, _that.name, _that.abbreviation, _that.platformLogo);
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
    TResult? Function(int? id, String? name, String? abbreviation,
            @JsonKey(name: 'platform_logo') PlatformLogo? platformLogo)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Platform() when $default != null:
        return $default(
            _that.id, _that.name, _that.abbreviation, _that.platformLogo);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Platform extends Platform {
  const _Platform(
      {this.id,
      this.name,
      this.abbreviation,
      @JsonKey(name: 'platform_logo') this.platformLogo})
      : super._();
  factory _Platform.fromJson(Map<String, dynamic> json) =>
      _$PlatformFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? abbreviation;
  @override
  @JsonKey(name: 'platform_logo')
  final PlatformLogo? platformLogo;

  /// Create a copy of Platform
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PlatformCopyWith<_Platform> get copyWith =>
      __$PlatformCopyWithImpl<_Platform>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PlatformToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Platform &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.abbreviation, abbreviation) ||
                other.abbreviation == abbreviation) &&
            (identical(other.platformLogo, platformLogo) ||
                other.platformLogo == platformLogo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, abbreviation, platformLogo);

  @override
  String toString() {
    return 'Platform(id: $id, name: $name, abbreviation: $abbreviation, platformLogo: $platformLogo)';
  }
}

/// @nodoc
abstract mixin class _$PlatformCopyWith<$Res>
    implements $PlatformCopyWith<$Res> {
  factory _$PlatformCopyWith(_Platform value, $Res Function(_Platform) _then) =
      __$PlatformCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? abbreviation,
      @JsonKey(name: 'platform_logo') PlatformLogo? platformLogo});

  @override
  $PlatformLogoCopyWith<$Res>? get platformLogo;
}

/// @nodoc
class __$PlatformCopyWithImpl<$Res> implements _$PlatformCopyWith<$Res> {
  __$PlatformCopyWithImpl(this._self, this._then);

  final _Platform _self;
  final $Res Function(_Platform) _then;

  /// Create a copy of Platform
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? abbreviation = freezed,
    Object? platformLogo = freezed,
  }) {
    return _then(_Platform(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      abbreviation: freezed == abbreviation
          ? _self.abbreviation
          : abbreviation // ignore: cast_nullable_to_non_nullable
              as String?,
      platformLogo: freezed == platformLogo
          ? _self.platformLogo
          : platformLogo // ignore: cast_nullable_to_non_nullable
              as PlatformLogo?,
    ));
  }

  /// Create a copy of Platform
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlatformLogoCopyWith<$Res>? get platformLogo {
    if (_self.platformLogo == null) {
      return null;
    }

    return $PlatformLogoCopyWith<$Res>(_self.platformLogo!, (value) {
      return _then(_self.copyWith(platformLogo: value));
    });
  }
}

// dart format on

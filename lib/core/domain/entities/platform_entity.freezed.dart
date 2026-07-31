// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'platform_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlatformEntity {
  int get id;
  String get name;
  String get abbreviation;
  PlatformLogoEntity? get platformLogo;

  /// Create a copy of PlatformEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlatformEntityCopyWith<PlatformEntity> get copyWith =>
      _$PlatformEntityCopyWithImpl<PlatformEntity>(
          this as PlatformEntity, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PlatformEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.abbreviation, abbreviation) ||
                other.abbreviation == abbreviation) &&
            (identical(other.platformLogo, platformLogo) ||
                other.platformLogo == platformLogo));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, abbreviation, platformLogo);

  @override
  String toString() {
    return 'PlatformEntity(id: $id, name: $name, abbreviation: $abbreviation, platformLogo: $platformLogo)';
  }
}

/// @nodoc
abstract mixin class $PlatformEntityCopyWith<$Res> {
  factory $PlatformEntityCopyWith(
          PlatformEntity value, $Res Function(PlatformEntity) _then) =
      _$PlatformEntityCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String name,
      String abbreviation,
      PlatformLogoEntity? platformLogo});

  $PlatformLogoEntityCopyWith<$Res>? get platformLogo;
}

/// @nodoc
class _$PlatformEntityCopyWithImpl<$Res>
    implements $PlatformEntityCopyWith<$Res> {
  _$PlatformEntityCopyWithImpl(this._self, this._then);

  final PlatformEntity _self;
  final $Res Function(PlatformEntity) _then;

  /// Create a copy of PlatformEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? abbreviation = null,
    Object? platformLogo = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      abbreviation: null == abbreviation
          ? _self.abbreviation
          : abbreviation // ignore: cast_nullable_to_non_nullable
              as String,
      platformLogo: freezed == platformLogo
          ? _self.platformLogo
          : platformLogo // ignore: cast_nullable_to_non_nullable
              as PlatformLogoEntity?,
    ));
  }

  /// Create a copy of PlatformEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlatformLogoEntityCopyWith<$Res>? get platformLogo {
    if (_self.platformLogo == null) {
      return null;
    }

    return $PlatformLogoEntityCopyWith<$Res>(_self.platformLogo!, (value) {
      return _then(_self.copyWith(platformLogo: value));
    });
  }
}

/// Adds pattern-matching-related methods to [PlatformEntity].
extension PlatformEntityPatterns on PlatformEntity {
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
    TResult Function(_PlatformEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlatformEntity() when $default != null:
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
    TResult Function(_PlatformEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlatformEntity():
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
    TResult? Function(_PlatformEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlatformEntity() when $default != null:
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
    TResult Function(int id, String name, String abbreviation,
            PlatformLogoEntity? platformLogo)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlatformEntity() when $default != null:
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
    TResult Function(int id, String name, String abbreviation,
            PlatformLogoEntity? platformLogo)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlatformEntity():
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
    TResult? Function(int id, String name, String abbreviation,
            PlatformLogoEntity? platformLogo)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlatformEntity() when $default != null:
        return $default(
            _that.id, _that.name, _that.abbreviation, _that.platformLogo);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PlatformEntity implements PlatformEntity {
  const _PlatformEntity(
      {required this.id,
      required this.name,
      required this.abbreviation,
      this.platformLogo});

  @override
  final int id;
  @override
  final String name;
  @override
  final String abbreviation;
  @override
  final PlatformLogoEntity? platformLogo;

  /// Create a copy of PlatformEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PlatformEntityCopyWith<_PlatformEntity> get copyWith =>
      __$PlatformEntityCopyWithImpl<_PlatformEntity>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PlatformEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.abbreviation, abbreviation) ||
                other.abbreviation == abbreviation) &&
            (identical(other.platformLogo, platformLogo) ||
                other.platformLogo == platformLogo));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, abbreviation, platformLogo);

  @override
  String toString() {
    return 'PlatformEntity(id: $id, name: $name, abbreviation: $abbreviation, platformLogo: $platformLogo)';
  }
}

/// @nodoc
abstract mixin class _$PlatformEntityCopyWith<$Res>
    implements $PlatformEntityCopyWith<$Res> {
  factory _$PlatformEntityCopyWith(
          _PlatformEntity value, $Res Function(_PlatformEntity) _then) =
      __$PlatformEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String abbreviation,
      PlatformLogoEntity? platformLogo});

  @override
  $PlatformLogoEntityCopyWith<$Res>? get platformLogo;
}

/// @nodoc
class __$PlatformEntityCopyWithImpl<$Res>
    implements _$PlatformEntityCopyWith<$Res> {
  __$PlatformEntityCopyWithImpl(this._self, this._then);

  final _PlatformEntity _self;
  final $Res Function(_PlatformEntity) _then;

  /// Create a copy of PlatformEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? abbreviation = null,
    Object? platformLogo = freezed,
  }) {
    return _then(_PlatformEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      abbreviation: null == abbreviation
          ? _self.abbreviation
          : abbreviation // ignore: cast_nullable_to_non_nullable
              as String,
      platformLogo: freezed == platformLogo
          ? _self.platformLogo
          : platformLogo // ignore: cast_nullable_to_non_nullable
              as PlatformLogoEntity?,
    ));
  }

  /// Create a copy of PlatformEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlatformLogoEntityCopyWith<$Res>? get platformLogo {
    if (_self.platformLogo == null) {
      return null;
    }

    return $PlatformLogoEntityCopyWith<$Res>(_self.platformLogo!, (value) {
      return _then(_self.copyWith(platformLogo: value));
    });
  }
}

// dart format on

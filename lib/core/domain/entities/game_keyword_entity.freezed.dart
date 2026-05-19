// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_keyword_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameKeywordEntity {
  String get name;

  /// Create a copy of GameKeywordEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GameKeywordEntityCopyWith<GameKeywordEntity> get copyWith =>
      _$GameKeywordEntityCopyWithImpl<GameKeywordEntity>(
          this as GameKeywordEntity, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GameKeywordEntity &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name);

  @override
  String toString() {
    return 'GameKeywordEntity(name: $name)';
  }
}

/// @nodoc
abstract mixin class $GameKeywordEntityCopyWith<$Res> {
  factory $GameKeywordEntityCopyWith(
          GameKeywordEntity value, $Res Function(GameKeywordEntity) _then) =
      _$GameKeywordEntityCopyWithImpl;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$GameKeywordEntityCopyWithImpl<$Res>
    implements $GameKeywordEntityCopyWith<$Res> {
  _$GameKeywordEntityCopyWithImpl(this._self, this._then);

  final GameKeywordEntity _self;
  final $Res Function(GameKeywordEntity) _then;

  /// Create a copy of GameKeywordEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [GameKeywordEntity].
extension GameKeywordEntityPatterns on GameKeywordEntity {
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
    TResult Function(_GameKeywordEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GameKeywordEntity() when $default != null:
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
    TResult Function(_GameKeywordEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameKeywordEntity():
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
    TResult? Function(_GameKeywordEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameKeywordEntity() when $default != null:
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
    TResult Function(String name)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GameKeywordEntity() when $default != null:
        return $default(_that.name);
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
    TResult Function(String name) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameKeywordEntity():
        return $default(_that.name);
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
    TResult? Function(String name)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameKeywordEntity() when $default != null:
        return $default(_that.name);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _GameKeywordEntity implements GameKeywordEntity {
  const _GameKeywordEntity({required this.name});

  @override
  final String name;

  /// Create a copy of GameKeywordEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GameKeywordEntityCopyWith<_GameKeywordEntity> get copyWith =>
      __$GameKeywordEntityCopyWithImpl<_GameKeywordEntity>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GameKeywordEntity &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name);

  @override
  String toString() {
    return 'GameKeywordEntity(name: $name)';
  }
}

/// @nodoc
abstract mixin class _$GameKeywordEntityCopyWith<$Res>
    implements $GameKeywordEntityCopyWith<$Res> {
  factory _$GameKeywordEntityCopyWith(
          _GameKeywordEntity value, $Res Function(_GameKeywordEntity) _then) =
      __$GameKeywordEntityCopyWithImpl;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$GameKeywordEntityCopyWithImpl<$Res>
    implements _$GameKeywordEntityCopyWith<$Res> {
  __$GameKeywordEntityCopyWithImpl(this._self, this._then);

  final _GameKeywordEntity _self;
  final $Res Function(_GameKeywordEntity) _then;

  /// Create a copy of GameKeywordEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
  }) {
    return _then(_GameKeywordEntity(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_screenshot_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameScreenshotEntity {
  List<String> get imageUrls;

  /// Create a copy of GameScreenshotEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GameScreenshotEntityCopyWith<GameScreenshotEntity> get copyWith =>
      _$GameScreenshotEntityCopyWithImpl<GameScreenshotEntity>(
          this as GameScreenshotEntity, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GameScreenshotEntity &&
            const DeepCollectionEquality().equals(other.imageUrls, imageUrls));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(imageUrls));

  @override
  String toString() {
    return 'GameScreenshotEntity(imageUrls: $imageUrls)';
  }
}

/// @nodoc
abstract mixin class $GameScreenshotEntityCopyWith<$Res> {
  factory $GameScreenshotEntityCopyWith(GameScreenshotEntity value,
          $Res Function(GameScreenshotEntity) _then) =
      _$GameScreenshotEntityCopyWithImpl;
  @useResult
  $Res call({List<String> imageUrls});
}

/// @nodoc
class _$GameScreenshotEntityCopyWithImpl<$Res>
    implements $GameScreenshotEntityCopyWith<$Res> {
  _$GameScreenshotEntityCopyWithImpl(this._self, this._then);

  final GameScreenshotEntity _self;
  final $Res Function(GameScreenshotEntity) _then;

  /// Create a copy of GameScreenshotEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageUrls = null,
  }) {
    return _then(_self.copyWith(
      imageUrls: null == imageUrls
          ? _self.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [GameScreenshotEntity].
extension GameScreenshotEntityPatterns on GameScreenshotEntity {
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
    TResult Function(_GameScreenshotEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GameScreenshotEntity() when $default != null:
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
    TResult Function(_GameScreenshotEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameScreenshotEntity():
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
    TResult? Function(_GameScreenshotEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameScreenshotEntity() when $default != null:
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
    TResult Function(List<String> imageUrls)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GameScreenshotEntity() when $default != null:
        return $default(_that.imageUrls);
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
    TResult Function(List<String> imageUrls) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameScreenshotEntity():
        return $default(_that.imageUrls);
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
    TResult? Function(List<String> imageUrls)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameScreenshotEntity() when $default != null:
        return $default(_that.imageUrls);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _GameScreenshotEntity implements GameScreenshotEntity {
  const _GameScreenshotEntity({final List<String> imageUrls = const []})
      : _imageUrls = imageUrls;

  final List<String> _imageUrls;
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  /// Create a copy of GameScreenshotEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GameScreenshotEntityCopyWith<_GameScreenshotEntity> get copyWith =>
      __$GameScreenshotEntityCopyWithImpl<_GameScreenshotEntity>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GameScreenshotEntity &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_imageUrls));

  @override
  String toString() {
    return 'GameScreenshotEntity(imageUrls: $imageUrls)';
  }
}

/// @nodoc
abstract mixin class _$GameScreenshotEntityCopyWith<$Res>
    implements $GameScreenshotEntityCopyWith<$Res> {
  factory _$GameScreenshotEntityCopyWith(_GameScreenshotEntity value,
          $Res Function(_GameScreenshotEntity) _then) =
      __$GameScreenshotEntityCopyWithImpl;
  @override
  @useResult
  $Res call({List<String> imageUrls});
}

/// @nodoc
class __$GameScreenshotEntityCopyWithImpl<$Res>
    implements _$GameScreenshotEntityCopyWith<$Res> {
  __$GameScreenshotEntityCopyWithImpl(this._self, this._then);

  final _GameScreenshotEntity _self;
  final $Res Function(_GameScreenshotEntity) _then;

  /// Create a copy of GameScreenshotEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? imageUrls = null,
  }) {
    return _then(_GameScreenshotEntity(
      imageUrls: null == imageUrls
          ? _self._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on

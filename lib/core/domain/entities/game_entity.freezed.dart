// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameEntity {
  int get id;
  String? get name;
  String? get slug;
  String? get releaseDate;
  String? get imageUrl;
  int? get metacritic;
  List<GamePlatform>? get platforms;

  /// Create a copy of GameEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GameEntityCopyWith<GameEntity> get copyWith =>
      _$GameEntityCopyWithImpl<GameEntity>(this as GameEntity, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GameEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.metacritic, metacritic) ||
                other.metacritic == metacritic) &&
            const DeepCollectionEquality().equals(other.platforms, platforms));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, slug, releaseDate,
      imageUrl, metacritic, const DeepCollectionEquality().hash(platforms));

  @override
  String toString() {
    return 'GameEntity(id: $id, name: $name, slug: $slug, releaseDate: $releaseDate, imageUrl: $imageUrl, metacritic: $metacritic, platforms: $platforms)';
  }
}

/// @nodoc
abstract mixin class $GameEntityCopyWith<$Res> {
  factory $GameEntityCopyWith(
          GameEntity value, $Res Function(GameEntity) _then) =
      _$GameEntityCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String? name,
      String? slug,
      String? releaseDate,
      String? imageUrl,
      int? metacritic,
      List<GamePlatform>? platforms});
}

/// @nodoc
class _$GameEntityCopyWithImpl<$Res> implements $GameEntityCopyWith<$Res> {
  _$GameEntityCopyWithImpl(this._self, this._then);

  final GameEntity _self;
  final $Res Function(GameEntity) _then;

  /// Create a copy of GameEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? slug = freezed,
    Object? releaseDate = freezed,
    Object? imageUrl = freezed,
    Object? metacritic = freezed,
    Object? platforms = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      releaseDate: freezed == releaseDate
          ? _self.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      metacritic: freezed == metacritic
          ? _self.metacritic
          : metacritic // ignore: cast_nullable_to_non_nullable
              as int?,
      platforms: freezed == platforms
          ? _self.platforms
          : platforms // ignore: cast_nullable_to_non_nullable
              as List<GamePlatform>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [GameEntity].
extension GameEntityPatterns on GameEntity {
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
    TResult Function(_GameEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GameEntity() when $default != null:
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
    TResult Function(_GameEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameEntity():
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
    TResult? Function(_GameEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameEntity() when $default != null:
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
    TResult Function(int id, String? name, String? slug, String? releaseDate,
            String? imageUrl, int? metacritic, List<GamePlatform>? platforms)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GameEntity() when $default != null:
        return $default(_that.id, _that.name, _that.slug, _that.releaseDate,
            _that.imageUrl, _that.metacritic, _that.platforms);
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
    TResult Function(int id, String? name, String? slug, String? releaseDate,
            String? imageUrl, int? metacritic, List<GamePlatform>? platforms)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameEntity():
        return $default(_that.id, _that.name, _that.slug, _that.releaseDate,
            _that.imageUrl, _that.metacritic, _that.platforms);
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
    TResult? Function(int id, String? name, String? slug, String? releaseDate,
            String? imageUrl, int? metacritic, List<GamePlatform>? platforms)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameEntity() when $default != null:
        return $default(_that.id, _that.name, _that.slug, _that.releaseDate,
            _that.imageUrl, _that.metacritic, _that.platforms);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _GameEntity extends GameEntity {
  const _GameEntity(
      {required this.id,
      this.name,
      this.slug,
      this.releaseDate,
      this.imageUrl,
      this.metacritic,
      final List<GamePlatform>? platforms})
      : _platforms = platforms,
        super._();

  @override
  final int id;
  @override
  final String? name;
  @override
  final String? slug;
  @override
  final String? releaseDate;
  @override
  final String? imageUrl;
  @override
  final int? metacritic;
  final List<GamePlatform>? _platforms;
  @override
  List<GamePlatform>? get platforms {
    final value = _platforms;
    if (value == null) return null;
    if (_platforms is EqualUnmodifiableListView) return _platforms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of GameEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GameEntityCopyWith<_GameEntity> get copyWith =>
      __$GameEntityCopyWithImpl<_GameEntity>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GameEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.metacritic, metacritic) ||
                other.metacritic == metacritic) &&
            const DeepCollectionEquality()
                .equals(other._platforms, _platforms));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, slug, releaseDate,
      imageUrl, metacritic, const DeepCollectionEquality().hash(_platforms));

  @override
  String toString() {
    return 'GameEntity(id: $id, name: $name, slug: $slug, releaseDate: $releaseDate, imageUrl: $imageUrl, metacritic: $metacritic, platforms: $platforms)';
  }
}

/// @nodoc
abstract mixin class _$GameEntityCopyWith<$Res>
    implements $GameEntityCopyWith<$Res> {
  factory _$GameEntityCopyWith(
          _GameEntity value, $Res Function(_GameEntity) _then) =
      __$GameEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String? name,
      String? slug,
      String? releaseDate,
      String? imageUrl,
      int? metacritic,
      List<GamePlatform>? platforms});
}

/// @nodoc
class __$GameEntityCopyWithImpl<$Res> implements _$GameEntityCopyWith<$Res> {
  __$GameEntityCopyWithImpl(this._self, this._then);

  final _GameEntity _self;
  final $Res Function(_GameEntity) _then;

  /// Create a copy of GameEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? slug = freezed,
    Object? releaseDate = freezed,
    Object? imageUrl = freezed,
    Object? metacritic = freezed,
    Object? platforms = freezed,
  }) {
    return _then(_GameEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      releaseDate: freezed == releaseDate
          ? _self.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      metacritic: freezed == metacritic
          ? _self.metacritic
          : metacritic // ignore: cast_nullable_to_non_nullable
              as int?,
      platforms: freezed == platforms
          ? _self._platforms
          : platforms // ignore: cast_nullable_to_non_nullable
              as List<GamePlatform>?,
    ));
  }
}

// dart format on

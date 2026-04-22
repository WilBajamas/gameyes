// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_detail_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameDetailEntity {
  int get id;
  String get name;
  String? get slug;
  int? get metacritic;
  String? get releaseDate;
  String? get description;
  String? get imageUrl;
  String? get additionalImageUrl;
  List<GamePlatform>? get platforms;
  List<String>? get developers;
  List<String>? get genres;
  List<String>? get publishers;

  /// Create a copy of GameDetailEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GameDetailEntityCopyWith<GameDetailEntity> get copyWith =>
      _$GameDetailEntityCopyWithImpl<GameDetailEntity>(
          this as GameDetailEntity, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GameDetailEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.metacritic, metacritic) ||
                other.metacritic == metacritic) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.additionalImageUrl, additionalImageUrl) ||
                other.additionalImageUrl == additionalImageUrl) &&
            const DeepCollectionEquality().equals(other.platforms, platforms) &&
            const DeepCollectionEquality()
                .equals(other.developers, developers) &&
            const DeepCollectionEquality().equals(other.genres, genres) &&
            const DeepCollectionEquality()
                .equals(other.publishers, publishers));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      slug,
      metacritic,
      releaseDate,
      description,
      imageUrl,
      additionalImageUrl,
      const DeepCollectionEquality().hash(platforms),
      const DeepCollectionEquality().hash(developers),
      const DeepCollectionEquality().hash(genres),
      const DeepCollectionEquality().hash(publishers));

  @override
  String toString() {
    return 'GameDetailEntity(id: $id, name: $name, slug: $slug, metacritic: $metacritic, releaseDate: $releaseDate, description: $description, imageUrl: $imageUrl, additionalImageUrl: $additionalImageUrl, platforms: $platforms, developers: $developers, genres: $genres, publishers: $publishers)';
  }
}

/// @nodoc
abstract mixin class $GameDetailEntityCopyWith<$Res> {
  factory $GameDetailEntityCopyWith(
          GameDetailEntity value, $Res Function(GameDetailEntity) _then) =
      _$GameDetailEntityCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String name,
      String? slug,
      int? metacritic,
      String? releaseDate,
      String? description,
      String? imageUrl,
      String? additionalImageUrl,
      List<GamePlatform>? platforms,
      List<String>? developers,
      List<String>? genres,
      List<String>? publishers});
}

/// @nodoc
class _$GameDetailEntityCopyWithImpl<$Res>
    implements $GameDetailEntityCopyWith<$Res> {
  _$GameDetailEntityCopyWithImpl(this._self, this._then);

  final GameDetailEntity _self;
  final $Res Function(GameDetailEntity) _then;

  /// Create a copy of GameDetailEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = freezed,
    Object? metacritic = freezed,
    Object? releaseDate = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? additionalImageUrl = freezed,
    Object? platforms = freezed,
    Object? developers = freezed,
    Object? genres = freezed,
    Object? publishers = freezed,
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
      slug: freezed == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      metacritic: freezed == metacritic
          ? _self.metacritic
          : metacritic // ignore: cast_nullable_to_non_nullable
              as int?,
      releaseDate: freezed == releaseDate
          ? _self.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalImageUrl: freezed == additionalImageUrl
          ? _self.additionalImageUrl
          : additionalImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      platforms: freezed == platforms
          ? _self.platforms
          : platforms // ignore: cast_nullable_to_non_nullable
              as List<GamePlatform>?,
      developers: freezed == developers
          ? _self.developers
          : developers // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      genres: freezed == genres
          ? _self.genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      publishers: freezed == publishers
          ? _self.publishers
          : publishers // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [GameDetailEntity].
extension GameDetailEntityPatterns on GameDetailEntity {
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
    TResult Function(_GameDetailEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GameDetailEntity() when $default != null:
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
    TResult Function(_GameDetailEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameDetailEntity():
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
    TResult? Function(_GameDetailEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameDetailEntity() when $default != null:
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
    TResult Function(
            int id,
            String name,
            String? slug,
            int? metacritic,
            String? releaseDate,
            String? description,
            String? imageUrl,
            String? additionalImageUrl,
            List<GamePlatform>? platforms,
            List<String>? developers,
            List<String>? genres,
            List<String>? publishers)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GameDetailEntity() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.slug,
            _that.metacritic,
            _that.releaseDate,
            _that.description,
            _that.imageUrl,
            _that.additionalImageUrl,
            _that.platforms,
            _that.developers,
            _that.genres,
            _that.publishers);
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
    TResult Function(
            int id,
            String name,
            String? slug,
            int? metacritic,
            String? releaseDate,
            String? description,
            String? imageUrl,
            String? additionalImageUrl,
            List<GamePlatform>? platforms,
            List<String>? developers,
            List<String>? genres,
            List<String>? publishers)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameDetailEntity():
        return $default(
            _that.id,
            _that.name,
            _that.slug,
            _that.metacritic,
            _that.releaseDate,
            _that.description,
            _that.imageUrl,
            _that.additionalImageUrl,
            _that.platforms,
            _that.developers,
            _that.genres,
            _that.publishers);
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
    TResult? Function(
            int id,
            String name,
            String? slug,
            int? metacritic,
            String? releaseDate,
            String? description,
            String? imageUrl,
            String? additionalImageUrl,
            List<GamePlatform>? platforms,
            List<String>? developers,
            List<String>? genres,
            List<String>? publishers)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameDetailEntity() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.slug,
            _that.metacritic,
            _that.releaseDate,
            _that.description,
            _that.imageUrl,
            _that.additionalImageUrl,
            _that.platforms,
            _that.developers,
            _that.genres,
            _that.publishers);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _GameDetailEntity extends GameDetailEntity {
  const _GameDetailEntity(
      {required this.id,
      required this.name,
      this.slug,
      this.metacritic,
      this.releaseDate,
      this.description,
      this.imageUrl,
      this.additionalImageUrl,
      final List<GamePlatform>? platforms,
      final List<String>? developers,
      final List<String>? genres,
      final List<String>? publishers})
      : _platforms = platforms,
        _developers = developers,
        _genres = genres,
        _publishers = publishers,
        super._();

  @override
  final int id;
  @override
  final String name;
  @override
  final String? slug;
  @override
  final int? metacritic;
  @override
  final String? releaseDate;
  @override
  final String? description;
  @override
  final String? imageUrl;
  @override
  final String? additionalImageUrl;
  final List<GamePlatform>? _platforms;
  @override
  List<GamePlatform>? get platforms {
    final value = _platforms;
    if (value == null) return null;
    if (_platforms is EqualUnmodifiableListView) return _platforms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _developers;
  @override
  List<String>? get developers {
    final value = _developers;
    if (value == null) return null;
    if (_developers is EqualUnmodifiableListView) return _developers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _genres;
  @override
  List<String>? get genres {
    final value = _genres;
    if (value == null) return null;
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _publishers;
  @override
  List<String>? get publishers {
    final value = _publishers;
    if (value == null) return null;
    if (_publishers is EqualUnmodifiableListView) return _publishers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of GameDetailEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GameDetailEntityCopyWith<_GameDetailEntity> get copyWith =>
      __$GameDetailEntityCopyWithImpl<_GameDetailEntity>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GameDetailEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.metacritic, metacritic) ||
                other.metacritic == metacritic) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.additionalImageUrl, additionalImageUrl) ||
                other.additionalImageUrl == additionalImageUrl) &&
            const DeepCollectionEquality()
                .equals(other._platforms, _platforms) &&
            const DeepCollectionEquality()
                .equals(other._developers, _developers) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            const DeepCollectionEquality()
                .equals(other._publishers, _publishers));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      slug,
      metacritic,
      releaseDate,
      description,
      imageUrl,
      additionalImageUrl,
      const DeepCollectionEquality().hash(_platforms),
      const DeepCollectionEquality().hash(_developers),
      const DeepCollectionEquality().hash(_genres),
      const DeepCollectionEquality().hash(_publishers));

  @override
  String toString() {
    return 'GameDetailEntity(id: $id, name: $name, slug: $slug, metacritic: $metacritic, releaseDate: $releaseDate, description: $description, imageUrl: $imageUrl, additionalImageUrl: $additionalImageUrl, platforms: $platforms, developers: $developers, genres: $genres, publishers: $publishers)';
  }
}

/// @nodoc
abstract mixin class _$GameDetailEntityCopyWith<$Res>
    implements $GameDetailEntityCopyWith<$Res> {
  factory _$GameDetailEntityCopyWith(
          _GameDetailEntity value, $Res Function(_GameDetailEntity) _then) =
      __$GameDetailEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String? slug,
      int? metacritic,
      String? releaseDate,
      String? description,
      String? imageUrl,
      String? additionalImageUrl,
      List<GamePlatform>? platforms,
      List<String>? developers,
      List<String>? genres,
      List<String>? publishers});
}

/// @nodoc
class __$GameDetailEntityCopyWithImpl<$Res>
    implements _$GameDetailEntityCopyWith<$Res> {
  __$GameDetailEntityCopyWithImpl(this._self, this._then);

  final _GameDetailEntity _self;
  final $Res Function(_GameDetailEntity) _then;

  /// Create a copy of GameDetailEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = freezed,
    Object? metacritic = freezed,
    Object? releaseDate = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? additionalImageUrl = freezed,
    Object? platforms = freezed,
    Object? developers = freezed,
    Object? genres = freezed,
    Object? publishers = freezed,
  }) {
    return _then(_GameDetailEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: freezed == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      metacritic: freezed == metacritic
          ? _self.metacritic
          : metacritic // ignore: cast_nullable_to_non_nullable
              as int?,
      releaseDate: freezed == releaseDate
          ? _self.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalImageUrl: freezed == additionalImageUrl
          ? _self.additionalImageUrl
          : additionalImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      platforms: freezed == platforms
          ? _self._platforms
          : platforms // ignore: cast_nullable_to_non_nullable
              as List<GamePlatform>?,
      developers: freezed == developers
          ? _self._developers
          : developers // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      genres: freezed == genres
          ? _self._genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      publishers: freezed == publishers
          ? _self._publishers
          : publishers // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

// dart format on

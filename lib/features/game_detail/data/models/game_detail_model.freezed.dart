// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameDetailModel {
  int? get id;
  String? get name;
  String? get slug;
  int? get metacritic;
  String? get released;
  @JsonKey(name: 'background_image')
  String? get backgroundImage;
  @JsonKey(name: 'background_image_additional')
  String? get backgroundImageAdditional;
  List<PlatformItem>? get platforms;
  List<Developer>? get developers;
  List<Genre>? get genres;
  List<Publisher>? get publishers;
  @JsonKey(name: 'description_raw')
  String? get description;

  /// Create a copy of GameDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GameDetailModelCopyWith<GameDetailModel> get copyWith =>
      _$GameDetailModelCopyWithImpl<GameDetailModel>(
          this as GameDetailModel, _$identity);

  /// Serializes this GameDetailModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GameDetailModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.metacritic, metacritic) ||
                other.metacritic == metacritic) &&
            (identical(other.released, released) ||
                other.released == released) &&
            (identical(other.backgroundImage, backgroundImage) ||
                other.backgroundImage == backgroundImage) &&
            (identical(other.backgroundImageAdditional,
                    backgroundImageAdditional) ||
                other.backgroundImageAdditional == backgroundImageAdditional) &&
            const DeepCollectionEquality().equals(other.platforms, platforms) &&
            const DeepCollectionEquality()
                .equals(other.developers, developers) &&
            const DeepCollectionEquality().equals(other.genres, genres) &&
            const DeepCollectionEquality()
                .equals(other.publishers, publishers) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      slug,
      metacritic,
      released,
      backgroundImage,
      backgroundImageAdditional,
      const DeepCollectionEquality().hash(platforms),
      const DeepCollectionEquality().hash(developers),
      const DeepCollectionEquality().hash(genres),
      const DeepCollectionEquality().hash(publishers),
      description);

  @override
  String toString() {
    return 'GameDetailModel(id: $id, name: $name, slug: $slug, metacritic: $metacritic, released: $released, backgroundImage: $backgroundImage, backgroundImageAdditional: $backgroundImageAdditional, platforms: $platforms, developers: $developers, genres: $genres, publishers: $publishers, description: $description)';
  }
}

/// @nodoc
abstract mixin class $GameDetailModelCopyWith<$Res> {
  factory $GameDetailModelCopyWith(
          GameDetailModel value, $Res Function(GameDetailModel) _then) =
      _$GameDetailModelCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? slug,
      int? metacritic,
      String? released,
      @JsonKey(name: 'background_image') String? backgroundImage,
      @JsonKey(name: 'background_image_additional')
      String? backgroundImageAdditional,
      List<PlatformItem>? platforms,
      List<Developer>? developers,
      List<Genre>? genres,
      List<Publisher>? publishers,
      @JsonKey(name: 'description_raw') String? description});
}

/// @nodoc
class _$GameDetailModelCopyWithImpl<$Res>
    implements $GameDetailModelCopyWith<$Res> {
  _$GameDetailModelCopyWithImpl(this._self, this._then);

  final GameDetailModel _self;
  final $Res Function(GameDetailModel) _then;

  /// Create a copy of GameDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? slug = freezed,
    Object? metacritic = freezed,
    Object? released = freezed,
    Object? backgroundImage = freezed,
    Object? backgroundImageAdditional = freezed,
    Object? platforms = freezed,
    Object? developers = freezed,
    Object? genres = freezed,
    Object? publishers = freezed,
    Object? description = freezed,
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
      slug: freezed == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      metacritic: freezed == metacritic
          ? _self.metacritic
          : metacritic // ignore: cast_nullable_to_non_nullable
              as int?,
      released: freezed == released
          ? _self.released
          : released // ignore: cast_nullable_to_non_nullable
              as String?,
      backgroundImage: freezed == backgroundImage
          ? _self.backgroundImage
          : backgroundImage // ignore: cast_nullable_to_non_nullable
              as String?,
      backgroundImageAdditional: freezed == backgroundImageAdditional
          ? _self.backgroundImageAdditional
          : backgroundImageAdditional // ignore: cast_nullable_to_non_nullable
              as String?,
      platforms: freezed == platforms
          ? _self.platforms
          : platforms // ignore: cast_nullable_to_non_nullable
              as List<PlatformItem>?,
      developers: freezed == developers
          ? _self.developers
          : developers // ignore: cast_nullable_to_non_nullable
              as List<Developer>?,
      genres: freezed == genres
          ? _self.genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<Genre>?,
      publishers: freezed == publishers
          ? _self.publishers
          : publishers // ignore: cast_nullable_to_non_nullable
              as List<Publisher>?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [GameDetailModel].
extension GameDetailModelPatterns on GameDetailModel {
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
    TResult Function(_GameDetailModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GameDetailModel() when $default != null:
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
    TResult Function(_GameDetailModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameDetailModel():
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
    TResult? Function(_GameDetailModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameDetailModel() when $default != null:
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
            int? id,
            String? name,
            String? slug,
            int? metacritic,
            String? released,
            @JsonKey(name: 'background_image') String? backgroundImage,
            @JsonKey(name: 'background_image_additional')
            String? backgroundImageAdditional,
            List<PlatformItem>? platforms,
            List<Developer>? developers,
            List<Genre>? genres,
            List<Publisher>? publishers,
            @JsonKey(name: 'description_raw') String? description)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GameDetailModel() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.slug,
            _that.metacritic,
            _that.released,
            _that.backgroundImage,
            _that.backgroundImageAdditional,
            _that.platforms,
            _that.developers,
            _that.genres,
            _that.publishers,
            _that.description);
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
            int? id,
            String? name,
            String? slug,
            int? metacritic,
            String? released,
            @JsonKey(name: 'background_image') String? backgroundImage,
            @JsonKey(name: 'background_image_additional')
            String? backgroundImageAdditional,
            List<PlatformItem>? platforms,
            List<Developer>? developers,
            List<Genre>? genres,
            List<Publisher>? publishers,
            @JsonKey(name: 'description_raw') String? description)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameDetailModel():
        return $default(
            _that.id,
            _that.name,
            _that.slug,
            _that.metacritic,
            _that.released,
            _that.backgroundImage,
            _that.backgroundImageAdditional,
            _that.platforms,
            _that.developers,
            _that.genres,
            _that.publishers,
            _that.description);
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
            int? id,
            String? name,
            String? slug,
            int? metacritic,
            String? released,
            @JsonKey(name: 'background_image') String? backgroundImage,
            @JsonKey(name: 'background_image_additional')
            String? backgroundImageAdditional,
            List<PlatformItem>? platforms,
            List<Developer>? developers,
            List<Genre>? genres,
            List<Publisher>? publishers,
            @JsonKey(name: 'description_raw') String? description)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameDetailModel() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.slug,
            _that.metacritic,
            _that.released,
            _that.backgroundImage,
            _that.backgroundImageAdditional,
            _that.platforms,
            _that.developers,
            _that.genres,
            _that.publishers,
            _that.description);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GameDetailModel extends GameDetailModel {
  const _GameDetailModel(
      {this.id,
      this.name,
      this.slug,
      this.metacritic,
      this.released,
      @JsonKey(name: 'background_image') this.backgroundImage,
      @JsonKey(name: 'background_image_additional')
      this.backgroundImageAdditional,
      final List<PlatformItem>? platforms,
      final List<Developer>? developers,
      final List<Genre>? genres,
      final List<Publisher>? publishers,
      @JsonKey(name: 'description_raw') this.description})
      : _platforms = platforms,
        _developers = developers,
        _genres = genres,
        _publishers = publishers,
        super._();
  factory _GameDetailModel.fromJson(Map<String, dynamic> json) =>
      _$GameDetailModelFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? slug;
  @override
  final int? metacritic;
  @override
  final String? released;
  @override
  @JsonKey(name: 'background_image')
  final String? backgroundImage;
  @override
  @JsonKey(name: 'background_image_additional')
  final String? backgroundImageAdditional;
  final List<PlatformItem>? _platforms;
  @override
  List<PlatformItem>? get platforms {
    final value = _platforms;
    if (value == null) return null;
    if (_platforms is EqualUnmodifiableListView) return _platforms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Developer>? _developers;
  @override
  List<Developer>? get developers {
    final value = _developers;
    if (value == null) return null;
    if (_developers is EqualUnmodifiableListView) return _developers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Genre>? _genres;
  @override
  List<Genre>? get genres {
    final value = _genres;
    if (value == null) return null;
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Publisher>? _publishers;
  @override
  List<Publisher>? get publishers {
    final value = _publishers;
    if (value == null) return null;
    if (_publishers is EqualUnmodifiableListView) return _publishers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'description_raw')
  final String? description;

  /// Create a copy of GameDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GameDetailModelCopyWith<_GameDetailModel> get copyWith =>
      __$GameDetailModelCopyWithImpl<_GameDetailModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GameDetailModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GameDetailModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.metacritic, metacritic) ||
                other.metacritic == metacritic) &&
            (identical(other.released, released) ||
                other.released == released) &&
            (identical(other.backgroundImage, backgroundImage) ||
                other.backgroundImage == backgroundImage) &&
            (identical(other.backgroundImageAdditional,
                    backgroundImageAdditional) ||
                other.backgroundImageAdditional == backgroundImageAdditional) &&
            const DeepCollectionEquality()
                .equals(other._platforms, _platforms) &&
            const DeepCollectionEquality()
                .equals(other._developers, _developers) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            const DeepCollectionEquality()
                .equals(other._publishers, _publishers) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      slug,
      metacritic,
      released,
      backgroundImage,
      backgroundImageAdditional,
      const DeepCollectionEquality().hash(_platforms),
      const DeepCollectionEquality().hash(_developers),
      const DeepCollectionEquality().hash(_genres),
      const DeepCollectionEquality().hash(_publishers),
      description);

  @override
  String toString() {
    return 'GameDetailModel(id: $id, name: $name, slug: $slug, metacritic: $metacritic, released: $released, backgroundImage: $backgroundImage, backgroundImageAdditional: $backgroundImageAdditional, platforms: $platforms, developers: $developers, genres: $genres, publishers: $publishers, description: $description)';
  }
}

/// @nodoc
abstract mixin class _$GameDetailModelCopyWith<$Res>
    implements $GameDetailModelCopyWith<$Res> {
  factory _$GameDetailModelCopyWith(
          _GameDetailModel value, $Res Function(_GameDetailModel) _then) =
      __$GameDetailModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? slug,
      int? metacritic,
      String? released,
      @JsonKey(name: 'background_image') String? backgroundImage,
      @JsonKey(name: 'background_image_additional')
      String? backgroundImageAdditional,
      List<PlatformItem>? platforms,
      List<Developer>? developers,
      List<Genre>? genres,
      List<Publisher>? publishers,
      @JsonKey(name: 'description_raw') String? description});
}

/// @nodoc
class __$GameDetailModelCopyWithImpl<$Res>
    implements _$GameDetailModelCopyWith<$Res> {
  __$GameDetailModelCopyWithImpl(this._self, this._then);

  final _GameDetailModel _self;
  final $Res Function(_GameDetailModel) _then;

  /// Create a copy of GameDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? slug = freezed,
    Object? metacritic = freezed,
    Object? released = freezed,
    Object? backgroundImage = freezed,
    Object? backgroundImageAdditional = freezed,
    Object? platforms = freezed,
    Object? developers = freezed,
    Object? genres = freezed,
    Object? publishers = freezed,
    Object? description = freezed,
  }) {
    return _then(_GameDetailModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      metacritic: freezed == metacritic
          ? _self.metacritic
          : metacritic // ignore: cast_nullable_to_non_nullable
              as int?,
      released: freezed == released
          ? _self.released
          : released // ignore: cast_nullable_to_non_nullable
              as String?,
      backgroundImage: freezed == backgroundImage
          ? _self.backgroundImage
          : backgroundImage // ignore: cast_nullable_to_non_nullable
              as String?,
      backgroundImageAdditional: freezed == backgroundImageAdditional
          ? _self.backgroundImageAdditional
          : backgroundImageAdditional // ignore: cast_nullable_to_non_nullable
              as String?,
      platforms: freezed == platforms
          ? _self._platforms
          : platforms // ignore: cast_nullable_to_non_nullable
              as List<PlatformItem>?,
      developers: freezed == developers
          ? _self._developers
          : developers // ignore: cast_nullable_to_non_nullable
              as List<Developer>?,
      genres: freezed == genres
          ? _self._genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<Genre>?,
      publishers: freezed == publishers
          ? _self._publishers
          : publishers // ignore: cast_nullable_to_non_nullable
              as List<Publisher>?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on

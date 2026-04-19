// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Game {
  int? get id;
  String? get slug;
  String? get name;
  String? get released;
  @JsonKey(name: 'background_image')
  String? get backgroundImage;
  int? get metacritic;
  List<PlatformItem>? get platforms;

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GameCopyWith<Game> get copyWith =>
      _$GameCopyWithImpl<Game>(this as Game, _$identity);

  /// Serializes this Game to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Game &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.released, released) ||
                other.released == released) &&
            (identical(other.backgroundImage, backgroundImage) ||
                other.backgroundImage == backgroundImage) &&
            (identical(other.metacritic, metacritic) ||
                other.metacritic == metacritic) &&
            const DeepCollectionEquality().equals(other.platforms, platforms));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      slug,
      name,
      released,
      backgroundImage,
      metacritic,
      const DeepCollectionEquality().hash(platforms));

  @override
  String toString() {
    return 'Game(id: $id, slug: $slug, name: $name, released: $released, backgroundImage: $backgroundImage, metacritic: $metacritic, platforms: $platforms)';
  }
}

/// @nodoc
abstract mixin class $GameCopyWith<$Res> {
  factory $GameCopyWith(Game value, $Res Function(Game) _then) =
      _$GameCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? slug,
      String? name,
      String? released,
      @JsonKey(name: 'background_image') String? backgroundImage,
      int? metacritic,
      List<PlatformItem>? platforms});
}

/// @nodoc
class _$GameCopyWithImpl<$Res> implements $GameCopyWith<$Res> {
  _$GameCopyWithImpl(this._self, this._then);

  final Game _self;
  final $Res Function(Game) _then;

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? slug = freezed,
    Object? name = freezed,
    Object? released = freezed,
    Object? backgroundImage = freezed,
    Object? metacritic = freezed,
    Object? platforms = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      slug: freezed == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      released: freezed == released
          ? _self.released
          : released // ignore: cast_nullable_to_non_nullable
              as String?,
      backgroundImage: freezed == backgroundImage
          ? _self.backgroundImage
          : backgroundImage // ignore: cast_nullable_to_non_nullable
              as String?,
      metacritic: freezed == metacritic
          ? _self.metacritic
          : metacritic // ignore: cast_nullable_to_non_nullable
              as int?,
      platforms: freezed == platforms
          ? _self.platforms
          : platforms // ignore: cast_nullable_to_non_nullable
              as List<PlatformItem>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Game].
extension GamePatterns on Game {
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
    TResult Function(_Game value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Game() when $default != null:
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
    TResult Function(_Game value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Game():
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
    TResult? Function(_Game value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Game() when $default != null:
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
            String? slug,
            String? name,
            String? released,
            @JsonKey(name: 'background_image') String? backgroundImage,
            int? metacritic,
            List<PlatformItem>? platforms)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Game() when $default != null:
        return $default(_that.id, _that.slug, _that.name, _that.released,
            _that.backgroundImage, _that.metacritic, _that.platforms);
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
            String? slug,
            String? name,
            String? released,
            @JsonKey(name: 'background_image') String? backgroundImage,
            int? metacritic,
            List<PlatformItem>? platforms)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Game():
        return $default(_that.id, _that.slug, _that.name, _that.released,
            _that.backgroundImage, _that.metacritic, _that.platforms);
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
            String? slug,
            String? name,
            String? released,
            @JsonKey(name: 'background_image') String? backgroundImage,
            int? metacritic,
            List<PlatformItem>? platforms)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Game() when $default != null:
        return $default(_that.id, _that.slug, _that.name, _that.released,
            _that.backgroundImage, _that.metacritic, _that.platforms);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Game extends Game {
  const _Game(
      {this.id,
      this.slug,
      this.name,
      this.released,
      @JsonKey(name: 'background_image') this.backgroundImage,
      this.metacritic,
      final List<PlatformItem>? platforms})
      : _platforms = platforms,
        super._();
  factory _Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  @override
  final int? id;
  @override
  final String? slug;
  @override
  final String? name;
  @override
  final String? released;
  @override
  @JsonKey(name: 'background_image')
  final String? backgroundImage;
  @override
  final int? metacritic;
  final List<PlatformItem>? _platforms;
  @override
  List<PlatformItem>? get platforms {
    final value = _platforms;
    if (value == null) return null;
    if (_platforms is EqualUnmodifiableListView) return _platforms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GameCopyWith<_Game> get copyWith =>
      __$GameCopyWithImpl<_Game>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GameToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Game &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.released, released) ||
                other.released == released) &&
            (identical(other.backgroundImage, backgroundImage) ||
                other.backgroundImage == backgroundImage) &&
            (identical(other.metacritic, metacritic) ||
                other.metacritic == metacritic) &&
            const DeepCollectionEquality()
                .equals(other._platforms, _platforms));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      slug,
      name,
      released,
      backgroundImage,
      metacritic,
      const DeepCollectionEquality().hash(_platforms));

  @override
  String toString() {
    return 'Game(id: $id, slug: $slug, name: $name, released: $released, backgroundImage: $backgroundImage, metacritic: $metacritic, platforms: $platforms)';
  }
}

/// @nodoc
abstract mixin class _$GameCopyWith<$Res> implements $GameCopyWith<$Res> {
  factory _$GameCopyWith(_Game value, $Res Function(_Game) _then) =
      __$GameCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? slug,
      String? name,
      String? released,
      @JsonKey(name: 'background_image') String? backgroundImage,
      int? metacritic,
      List<PlatformItem>? platforms});
}

/// @nodoc
class __$GameCopyWithImpl<$Res> implements _$GameCopyWith<$Res> {
  __$GameCopyWithImpl(this._self, this._then);

  final _Game _self;
  final $Res Function(_Game) _then;

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? slug = freezed,
    Object? name = freezed,
    Object? released = freezed,
    Object? backgroundImage = freezed,
    Object? metacritic = freezed,
    Object? platforms = freezed,
  }) {
    return _then(_Game(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      slug: freezed == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      released: freezed == released
          ? _self.released
          : released // ignore: cast_nullable_to_non_nullable
              as String?,
      backgroundImage: freezed == backgroundImage
          ? _self.backgroundImage
          : backgroundImage // ignore: cast_nullable_to_non_nullable
              as String?,
      metacritic: freezed == metacritic
          ? _self.metacritic
          : metacritic // ignore: cast_nullable_to_non_nullable
              as int?,
      platforms: freezed == platforms
          ? _self._platforms
          : platforms // ignore: cast_nullable_to_non_nullable
              as List<PlatformItem>?,
    ));
  }
}

// dart format on

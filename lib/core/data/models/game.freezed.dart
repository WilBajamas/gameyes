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
  String? get name;
  GameCover? get cover;
  @JsonKey(name: 'game_modes')
  List<GameMode>? get gameModes;
  List<GameKeyword>? get keywords;
  List<Platform>? get platforms;
  @JsonKey(name: 'release_dates')
  List<ReleaseDate>? get releaseDates;
  @JsonKey(name: 'total_rating')
  double? get criticScore;
  int? get hypes;
  List<int>? get genres;

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
            (identical(other.name, name) || other.name == name) &&
            (identical(other.cover, cover) || other.cover == cover) &&
            const DeepCollectionEquality().equals(other.gameModes, gameModes) &&
            const DeepCollectionEquality().equals(other.keywords, keywords) &&
            const DeepCollectionEquality().equals(other.platforms, platforms) &&
            const DeepCollectionEquality()
                .equals(other.releaseDates, releaseDates) &&
            (identical(other.criticScore, criticScore) ||
                other.criticScore == criticScore) &&
            (identical(other.hypes, hypes) || other.hypes == hypes) &&
            const DeepCollectionEquality().equals(other.genres, genres));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      cover,
      const DeepCollectionEquality().hash(gameModes),
      const DeepCollectionEquality().hash(keywords),
      const DeepCollectionEquality().hash(platforms),
      const DeepCollectionEquality().hash(releaseDates),
      criticScore,
      hypes,
      const DeepCollectionEquality().hash(genres));

  @override
  String toString() {
    return 'Game(id: $id, name: $name, cover: $cover, gameModes: $gameModes, keywords: $keywords, platforms: $platforms, releaseDates: $releaseDates, criticScore: $criticScore, hypes: $hypes, genres: $genres)';
  }
}

/// @nodoc
abstract mixin class $GameCopyWith<$Res> {
  factory $GameCopyWith(Game value, $Res Function(Game) _then) =
      _$GameCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? name,
      GameCover? cover,
      @JsonKey(name: 'game_modes') List<GameMode>? gameModes,
      List<GameKeyword>? keywords,
      List<Platform>? platforms,
      @JsonKey(name: 'release_dates') List<ReleaseDate>? releaseDates,
      @JsonKey(name: 'total_rating') double? criticScore,
      int? hypes,
      List<int>? genres});

  $GameCoverCopyWith<$Res>? get cover;
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
    Object? name = freezed,
    Object? cover = freezed,
    Object? gameModes = freezed,
    Object? keywords = freezed,
    Object? platforms = freezed,
    Object? releaseDates = freezed,
    Object? criticScore = freezed,
    Object? hypes = freezed,
    Object? genres = freezed,
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
      cover: freezed == cover
          ? _self.cover
          : cover // ignore: cast_nullable_to_non_nullable
              as GameCover?,
      gameModes: freezed == gameModes
          ? _self.gameModes
          : gameModes // ignore: cast_nullable_to_non_nullable
              as List<GameMode>?,
      keywords: freezed == keywords
          ? _self.keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<GameKeyword>?,
      platforms: freezed == platforms
          ? _self.platforms
          : platforms // ignore: cast_nullable_to_non_nullable
              as List<Platform>?,
      releaseDates: freezed == releaseDates
          ? _self.releaseDates
          : releaseDates // ignore: cast_nullable_to_non_nullable
              as List<ReleaseDate>?,
      criticScore: freezed == criticScore
          ? _self.criticScore
          : criticScore // ignore: cast_nullable_to_non_nullable
              as double?,
      hypes: freezed == hypes
          ? _self.hypes
          : hypes // ignore: cast_nullable_to_non_nullable
              as int?,
      genres: freezed == genres
          ? _self.genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ));
  }

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameCoverCopyWith<$Res>? get cover {
    if (_self.cover == null) {
      return null;
    }

    return $GameCoverCopyWith<$Res>(_self.cover!, (value) {
      return _then(_self.copyWith(cover: value));
    });
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
            String? name,
            GameCover? cover,
            @JsonKey(name: 'game_modes') List<GameMode>? gameModes,
            List<GameKeyword>? keywords,
            List<Platform>? platforms,
            @JsonKey(name: 'release_dates') List<ReleaseDate>? releaseDates,
            @JsonKey(name: 'total_rating') double? criticScore,
            int? hypes,
            List<int>? genres)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Game() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.cover,
            _that.gameModes,
            _that.keywords,
            _that.platforms,
            _that.releaseDates,
            _that.criticScore,
            _that.hypes,
            _that.genres);
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
            GameCover? cover,
            @JsonKey(name: 'game_modes') List<GameMode>? gameModes,
            List<GameKeyword>? keywords,
            List<Platform>? platforms,
            @JsonKey(name: 'release_dates') List<ReleaseDate>? releaseDates,
            @JsonKey(name: 'total_rating') double? criticScore,
            int? hypes,
            List<int>? genres)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Game():
        return $default(
            _that.id,
            _that.name,
            _that.cover,
            _that.gameModes,
            _that.keywords,
            _that.platforms,
            _that.releaseDates,
            _that.criticScore,
            _that.hypes,
            _that.genres);
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
            GameCover? cover,
            @JsonKey(name: 'game_modes') List<GameMode>? gameModes,
            List<GameKeyword>? keywords,
            List<Platform>? platforms,
            @JsonKey(name: 'release_dates') List<ReleaseDate>? releaseDates,
            @JsonKey(name: 'total_rating') double? criticScore,
            int? hypes,
            List<int>? genres)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Game() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.cover,
            _that.gameModes,
            _that.keywords,
            _that.platforms,
            _that.releaseDates,
            _that.criticScore,
            _that.hypes,
            _that.genres);
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
      this.name,
      this.cover,
      @JsonKey(name: 'game_modes') final List<GameMode>? gameModes,
      final List<GameKeyword>? keywords,
      final List<Platform>? platforms,
      @JsonKey(name: 'release_dates') final List<ReleaseDate>? releaseDates,
      @JsonKey(name: 'total_rating') this.criticScore,
      this.hypes,
      final List<int>? genres})
      : _gameModes = gameModes,
        _keywords = keywords,
        _platforms = platforms,
        _releaseDates = releaseDates,
        _genres = genres,
        super._();
  factory _Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final GameCover? cover;
  final List<GameMode>? _gameModes;
  @override
  @JsonKey(name: 'game_modes')
  List<GameMode>? get gameModes {
    final value = _gameModes;
    if (value == null) return null;
    if (_gameModes is EqualUnmodifiableListView) return _gameModes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<GameKeyword>? _keywords;
  @override
  List<GameKeyword>? get keywords {
    final value = _keywords;
    if (value == null) return null;
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Platform>? _platforms;
  @override
  List<Platform>? get platforms {
    final value = _platforms;
    if (value == null) return null;
    if (_platforms is EqualUnmodifiableListView) return _platforms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ReleaseDate>? _releaseDates;
  @override
  @JsonKey(name: 'release_dates')
  List<ReleaseDate>? get releaseDates {
    final value = _releaseDates;
    if (value == null) return null;
    if (_releaseDates is EqualUnmodifiableListView) return _releaseDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'total_rating')
  final double? criticScore;
  @override
  final int? hypes;
  final List<int>? _genres;
  @override
  List<int>? get genres {
    final value = _genres;
    if (value == null) return null;
    if (_genres is EqualUnmodifiableListView) return _genres;
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
            (identical(other.name, name) || other.name == name) &&
            (identical(other.cover, cover) || other.cover == cover) &&
            const DeepCollectionEquality()
                .equals(other._gameModes, _gameModes) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords) &&
            const DeepCollectionEquality()
                .equals(other._platforms, _platforms) &&
            const DeepCollectionEquality()
                .equals(other._releaseDates, _releaseDates) &&
            (identical(other.criticScore, criticScore) ||
                other.criticScore == criticScore) &&
            (identical(other.hypes, hypes) || other.hypes == hypes) &&
            const DeepCollectionEquality().equals(other._genres, _genres));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      cover,
      const DeepCollectionEquality().hash(_gameModes),
      const DeepCollectionEquality().hash(_keywords),
      const DeepCollectionEquality().hash(_platforms),
      const DeepCollectionEquality().hash(_releaseDates),
      criticScore,
      hypes,
      const DeepCollectionEquality().hash(_genres));

  @override
  String toString() {
    return 'Game(id: $id, name: $name, cover: $cover, gameModes: $gameModes, keywords: $keywords, platforms: $platforms, releaseDates: $releaseDates, criticScore: $criticScore, hypes: $hypes, genres: $genres)';
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
      String? name,
      GameCover? cover,
      @JsonKey(name: 'game_modes') List<GameMode>? gameModes,
      List<GameKeyword>? keywords,
      List<Platform>? platforms,
      @JsonKey(name: 'release_dates') List<ReleaseDate>? releaseDates,
      @JsonKey(name: 'total_rating') double? criticScore,
      int? hypes,
      List<int>? genres});

  @override
  $GameCoverCopyWith<$Res>? get cover;
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
    Object? name = freezed,
    Object? cover = freezed,
    Object? gameModes = freezed,
    Object? keywords = freezed,
    Object? platforms = freezed,
    Object? releaseDates = freezed,
    Object? criticScore = freezed,
    Object? hypes = freezed,
    Object? genres = freezed,
  }) {
    return _then(_Game(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      cover: freezed == cover
          ? _self.cover
          : cover // ignore: cast_nullable_to_non_nullable
              as GameCover?,
      gameModes: freezed == gameModes
          ? _self._gameModes
          : gameModes // ignore: cast_nullable_to_non_nullable
              as List<GameMode>?,
      keywords: freezed == keywords
          ? _self._keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<GameKeyword>?,
      platforms: freezed == platforms
          ? _self._platforms
          : platforms // ignore: cast_nullable_to_non_nullable
              as List<Platform>?,
      releaseDates: freezed == releaseDates
          ? _self._releaseDates
          : releaseDates // ignore: cast_nullable_to_non_nullable
              as List<ReleaseDate>?,
      criticScore: freezed == criticScore
          ? _self.criticScore
          : criticScore // ignore: cast_nullable_to_non_nullable
              as double?,
      hypes: freezed == hypes
          ? _self.hypes
          : hypes // ignore: cast_nullable_to_non_nullable
              as int?,
      genres: freezed == genres
          ? _self._genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ));
  }

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameCoverCopyWith<$Res>? get cover {
    if (_self.cover == null) {
      return null;
    }

    return $GameCoverCopyWith<$Res>(_self.cover!, (value) {
      return _then(_self.copyWith(cover: value));
    });
  }
}

// dart format on

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
  String? get summary;
  GameCover? get cover;
  @JsonKey(name: 'game_modes')
  List<GameMode>? get gameModes;
  List<GameKeyword>? get keywords;
  List<Platform>? get platforms;
  @JsonKey(name: 'release_dates')
  List<ReleaseDate>? get releaseDates;

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
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.cover, cover) || other.cover == cover) &&
            const DeepCollectionEquality().equals(other.gameModes, gameModes) &&
            const DeepCollectionEquality().equals(other.keywords, keywords) &&
            const DeepCollectionEquality().equals(other.platforms, platforms) &&
            const DeepCollectionEquality()
                .equals(other.releaseDates, releaseDates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      summary,
      cover,
      const DeepCollectionEquality().hash(gameModes),
      const DeepCollectionEquality().hash(keywords),
      const DeepCollectionEquality().hash(platforms),
      const DeepCollectionEquality().hash(releaseDates));

  @override
  String toString() {
    return 'GameDetailModel(id: $id, name: $name, summary: $summary, cover: $cover, gameModes: $gameModes, keywords: $keywords, platforms: $platforms, releaseDates: $releaseDates)';
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
      String? summary,
      GameCover? cover,
      @JsonKey(name: 'game_modes') List<GameMode>? gameModes,
      List<GameKeyword>? keywords,
      List<Platform>? platforms,
      @JsonKey(name: 'release_dates') List<ReleaseDate>? releaseDates});

  $GameCoverCopyWith<$Res>? get cover;
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
    Object? summary = freezed,
    Object? cover = freezed,
    Object? gameModes = freezed,
    Object? keywords = freezed,
    Object? platforms = freezed,
    Object? releaseDates = freezed,
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
      summary: freezed == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
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
    ));
  }

  /// Create a copy of GameDetailModel
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
            String? summary,
            GameCover? cover,
            @JsonKey(name: 'game_modes') List<GameMode>? gameModes,
            List<GameKeyword>? keywords,
            List<Platform>? platforms,
            @JsonKey(name: 'release_dates') List<ReleaseDate>? releaseDates)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GameDetailModel() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.summary,
            _that.cover,
            _that.gameModes,
            _that.keywords,
            _that.platforms,
            _that.releaseDates);
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
            String? summary,
            GameCover? cover,
            @JsonKey(name: 'game_modes') List<GameMode>? gameModes,
            List<GameKeyword>? keywords,
            List<Platform>? platforms,
            @JsonKey(name: 'release_dates') List<ReleaseDate>? releaseDates)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameDetailModel():
        return $default(
            _that.id,
            _that.name,
            _that.summary,
            _that.cover,
            _that.gameModes,
            _that.keywords,
            _that.platforms,
            _that.releaseDates);
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
            String? summary,
            GameCover? cover,
            @JsonKey(name: 'game_modes') List<GameMode>? gameModes,
            List<GameKeyword>? keywords,
            List<Platform>? platforms,
            @JsonKey(name: 'release_dates') List<ReleaseDate>? releaseDates)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameDetailModel() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.summary,
            _that.cover,
            _that.gameModes,
            _that.keywords,
            _that.platforms,
            _that.releaseDates);
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
      this.summary,
      this.cover,
      @JsonKey(name: 'game_modes') final List<GameMode>? gameModes,
      final List<GameKeyword>? keywords,
      final List<Platform>? platforms,
      @JsonKey(name: 'release_dates') final List<ReleaseDate>? releaseDates})
      : _gameModes = gameModes,
        _keywords = keywords,
        _platforms = platforms,
        _releaseDates = releaseDates,
        super._();
  factory _GameDetailModel.fromJson(Map<String, dynamic> json) =>
      _$GameDetailModelFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? summary;
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
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.cover, cover) || other.cover == cover) &&
            const DeepCollectionEquality()
                .equals(other._gameModes, _gameModes) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords) &&
            const DeepCollectionEquality()
                .equals(other._platforms, _platforms) &&
            const DeepCollectionEquality()
                .equals(other._releaseDates, _releaseDates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      summary,
      cover,
      const DeepCollectionEquality().hash(_gameModes),
      const DeepCollectionEquality().hash(_keywords),
      const DeepCollectionEquality().hash(_platforms),
      const DeepCollectionEquality().hash(_releaseDates));

  @override
  String toString() {
    return 'GameDetailModel(id: $id, name: $name, summary: $summary, cover: $cover, gameModes: $gameModes, keywords: $keywords, platforms: $platforms, releaseDates: $releaseDates)';
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
      String? summary,
      GameCover? cover,
      @JsonKey(name: 'game_modes') List<GameMode>? gameModes,
      List<GameKeyword>? keywords,
      List<Platform>? platforms,
      @JsonKey(name: 'release_dates') List<ReleaseDate>? releaseDates});

  @override
  $GameCoverCopyWith<$Res>? get cover;
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
    Object? summary = freezed,
    Object? cover = freezed,
    Object? gameModes = freezed,
    Object? keywords = freezed,
    Object? platforms = freezed,
    Object? releaseDates = freezed,
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
      summary: freezed == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
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
    ));
  }

  /// Create a copy of GameDetailModel
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

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
  String get name;
  GameCoverEntity get cover;
  List<GameModeEntity>? get gameModes;
  List<GameKeywordEntity>? get gameKeywords;
  List<PlatformEntity>? get platforms;
  List<ReleaseDateEntity>? get releaseDates;

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
            (identical(other.cover, cover) || other.cover == cover) &&
            const DeepCollectionEquality().equals(other.gameModes, gameModes) &&
            const DeepCollectionEquality()
                .equals(other.gameKeywords, gameKeywords) &&
            const DeepCollectionEquality().equals(other.platforms, platforms) &&
            const DeepCollectionEquality()
                .equals(other.releaseDates, releaseDates));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      cover,
      const DeepCollectionEquality().hash(gameModes),
      const DeepCollectionEquality().hash(gameKeywords),
      const DeepCollectionEquality().hash(platforms),
      const DeepCollectionEquality().hash(releaseDates));

  @override
  String toString() {
    return 'GameEntity(id: $id, name: $name, cover: $cover, gameModes: $gameModes, gameKeywords: $gameKeywords, platforms: $platforms, releaseDates: $releaseDates)';
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
      String name,
      GameCoverEntity cover,
      List<GameModeEntity>? gameModes,
      List<GameKeywordEntity>? gameKeywords,
      List<PlatformEntity>? platforms,
      List<ReleaseDateEntity>? releaseDates});

  $GameCoverEntityCopyWith<$Res> get cover;
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
    Object? name = null,
    Object? cover = null,
    Object? gameModes = freezed,
    Object? gameKeywords = freezed,
    Object? platforms = freezed,
    Object? releaseDates = freezed,
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
      cover: null == cover
          ? _self.cover
          : cover // ignore: cast_nullable_to_non_nullable
              as GameCoverEntity,
      gameModes: freezed == gameModes
          ? _self.gameModes
          : gameModes // ignore: cast_nullable_to_non_nullable
              as List<GameModeEntity>?,
      gameKeywords: freezed == gameKeywords
          ? _self.gameKeywords
          : gameKeywords // ignore: cast_nullable_to_non_nullable
              as List<GameKeywordEntity>?,
      platforms: freezed == platforms
          ? _self.platforms
          : platforms // ignore: cast_nullable_to_non_nullable
              as List<PlatformEntity>?,
      releaseDates: freezed == releaseDates
          ? _self.releaseDates
          : releaseDates // ignore: cast_nullable_to_non_nullable
              as List<ReleaseDateEntity>?,
    ));
  }

  /// Create a copy of GameEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameCoverEntityCopyWith<$Res> get cover {
    return $GameCoverEntityCopyWith<$Res>(_self.cover, (value) {
      return _then(_self.copyWith(cover: value));
    });
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
    TResult Function(
            int id,
            String name,
            GameCoverEntity cover,
            List<GameModeEntity>? gameModes,
            List<GameKeywordEntity>? gameKeywords,
            List<PlatformEntity>? platforms,
            List<ReleaseDateEntity>? releaseDates)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GameEntity() when $default != null:
        return $default(_that.id, _that.name, _that.cover, _that.gameModes,
            _that.gameKeywords, _that.platforms, _that.releaseDates);
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
            GameCoverEntity cover,
            List<GameModeEntity>? gameModes,
            List<GameKeywordEntity>? gameKeywords,
            List<PlatformEntity>? platforms,
            List<ReleaseDateEntity>? releaseDates)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameEntity():
        return $default(_that.id, _that.name, _that.cover, _that.gameModes,
            _that.gameKeywords, _that.platforms, _that.releaseDates);
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
            GameCoverEntity cover,
            List<GameModeEntity>? gameModes,
            List<GameKeywordEntity>? gameKeywords,
            List<PlatformEntity>? platforms,
            List<ReleaseDateEntity>? releaseDates)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameEntity() when $default != null:
        return $default(_that.id, _that.name, _that.cover, _that.gameModes,
            _that.gameKeywords, _that.platforms, _that.releaseDates);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _GameEntity extends GameEntity {
  const _GameEntity(
      {required this.id,
      required this.name,
      required this.cover,
      final List<GameModeEntity>? gameModes,
      final List<GameKeywordEntity>? gameKeywords,
      final List<PlatformEntity>? platforms,
      final List<ReleaseDateEntity>? releaseDates})
      : _gameModes = gameModes,
        _gameKeywords = gameKeywords,
        _platforms = platforms,
        _releaseDates = releaseDates,
        super._();

  @override
  final int id;
  @override
  final String name;
  @override
  final GameCoverEntity cover;
  final List<GameModeEntity>? _gameModes;
  @override
  List<GameModeEntity>? get gameModes {
    final value = _gameModes;
    if (value == null) return null;
    if (_gameModes is EqualUnmodifiableListView) return _gameModes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<GameKeywordEntity>? _gameKeywords;
  @override
  List<GameKeywordEntity>? get gameKeywords {
    final value = _gameKeywords;
    if (value == null) return null;
    if (_gameKeywords is EqualUnmodifiableListView) return _gameKeywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<PlatformEntity>? _platforms;
  @override
  List<PlatformEntity>? get platforms {
    final value = _platforms;
    if (value == null) return null;
    if (_platforms is EqualUnmodifiableListView) return _platforms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ReleaseDateEntity>? _releaseDates;
  @override
  List<ReleaseDateEntity>? get releaseDates {
    final value = _releaseDates;
    if (value == null) return null;
    if (_releaseDates is EqualUnmodifiableListView) return _releaseDates;
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
            (identical(other.cover, cover) || other.cover == cover) &&
            const DeepCollectionEquality()
                .equals(other._gameModes, _gameModes) &&
            const DeepCollectionEquality()
                .equals(other._gameKeywords, _gameKeywords) &&
            const DeepCollectionEquality()
                .equals(other._platforms, _platforms) &&
            const DeepCollectionEquality()
                .equals(other._releaseDates, _releaseDates));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      cover,
      const DeepCollectionEquality().hash(_gameModes),
      const DeepCollectionEquality().hash(_gameKeywords),
      const DeepCollectionEquality().hash(_platforms),
      const DeepCollectionEquality().hash(_releaseDates));

  @override
  String toString() {
    return 'GameEntity(id: $id, name: $name, cover: $cover, gameModes: $gameModes, gameKeywords: $gameKeywords, platforms: $platforms, releaseDates: $releaseDates)';
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
      String name,
      GameCoverEntity cover,
      List<GameModeEntity>? gameModes,
      List<GameKeywordEntity>? gameKeywords,
      List<PlatformEntity>? platforms,
      List<ReleaseDateEntity>? releaseDates});

  @override
  $GameCoverEntityCopyWith<$Res> get cover;
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
    Object? name = null,
    Object? cover = null,
    Object? gameModes = freezed,
    Object? gameKeywords = freezed,
    Object? platforms = freezed,
    Object? releaseDates = freezed,
  }) {
    return _then(_GameEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      cover: null == cover
          ? _self.cover
          : cover // ignore: cast_nullable_to_non_nullable
              as GameCoverEntity,
      gameModes: freezed == gameModes
          ? _self._gameModes
          : gameModes // ignore: cast_nullable_to_non_nullable
              as List<GameModeEntity>?,
      gameKeywords: freezed == gameKeywords
          ? _self._gameKeywords
          : gameKeywords // ignore: cast_nullable_to_non_nullable
              as List<GameKeywordEntity>?,
      platforms: freezed == platforms
          ? _self._platforms
          : platforms // ignore: cast_nullable_to_non_nullable
              as List<PlatformEntity>?,
      releaseDates: freezed == releaseDates
          ? _self._releaseDates
          : releaseDates // ignore: cast_nullable_to_non_nullable
              as List<ReleaseDateEntity>?,
    ));
  }

  /// Create a copy of GameEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameCoverEntityCopyWith<$Res> get cover {
    return $GameCoverEntityCopyWith<$Res>(_self.cover, (value) {
      return _then(_self.copyWith(cover: value));
    });
  }
}

// dart format on

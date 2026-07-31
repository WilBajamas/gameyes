// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracker_saved_game_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackerSavedGameEntity {
  int get id;
  String? get name;
  String? get imageUrl;
  int? get gameId;
  String? get gameSlug;
  DateTime? get dateSaved;
  bool get completed;
  List<PlatformEntity>? get platforms;
  List<PlatformEntity>? get availablePlatforms;
  DateTime? get dateModified;
  List<TrackerGroupTaskEntity> get groupTasks;

  /// Create a copy of TrackerSavedGameEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TrackerSavedGameEntityCopyWith<TrackerSavedGameEntity> get copyWith =>
      _$TrackerSavedGameEntityCopyWithImpl<TrackerSavedGameEntity>(
          this as TrackerSavedGameEntity, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TrackerSavedGameEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.gameSlug, gameSlug) ||
                other.gameSlug == gameSlug) &&
            (identical(other.dateSaved, dateSaved) ||
                other.dateSaved == dateSaved) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            const DeepCollectionEquality().equals(other.platforms, platforms) &&
            const DeepCollectionEquality()
                .equals(other.availablePlatforms, availablePlatforms) &&
            (identical(other.dateModified, dateModified) ||
                other.dateModified == dateModified) &&
            const DeepCollectionEquality()
                .equals(other.groupTasks, groupTasks));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      imageUrl,
      gameId,
      gameSlug,
      dateSaved,
      completed,
      const DeepCollectionEquality().hash(platforms),
      const DeepCollectionEquality().hash(availablePlatforms),
      dateModified,
      const DeepCollectionEquality().hash(groupTasks));

  @override
  String toString() {
    return 'TrackerSavedGameEntity(id: $id, name: $name, imageUrl: $imageUrl, gameId: $gameId, gameSlug: $gameSlug, dateSaved: $dateSaved, completed: $completed, platforms: $platforms, availablePlatforms: $availablePlatforms, dateModified: $dateModified, groupTasks: $groupTasks)';
  }
}

/// @nodoc
abstract mixin class $TrackerSavedGameEntityCopyWith<$Res> {
  factory $TrackerSavedGameEntityCopyWith(TrackerSavedGameEntity value,
          $Res Function(TrackerSavedGameEntity) _then) =
      _$TrackerSavedGameEntityCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String? name,
      String? imageUrl,
      int? gameId,
      String? gameSlug,
      DateTime? dateSaved,
      bool completed,
      List<PlatformEntity>? platforms,
      List<PlatformEntity>? availablePlatforms,
      DateTime? dateModified,
      List<TrackerGroupTaskEntity> groupTasks});
}

/// @nodoc
class _$TrackerSavedGameEntityCopyWithImpl<$Res>
    implements $TrackerSavedGameEntityCopyWith<$Res> {
  _$TrackerSavedGameEntityCopyWithImpl(this._self, this._then);

  final TrackerSavedGameEntity _self;
  final $Res Function(TrackerSavedGameEntity) _then;

  /// Create a copy of TrackerSavedGameEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? imageUrl = freezed,
    Object? gameId = freezed,
    Object? gameSlug = freezed,
    Object? dateSaved = freezed,
    Object? completed = null,
    Object? platforms = freezed,
    Object? availablePlatforms = freezed,
    Object? dateModified = freezed,
    Object? groupTasks = null,
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
      imageUrl: freezed == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      gameId: freezed == gameId
          ? _self.gameId
          : gameId // ignore: cast_nullable_to_non_nullable
              as int?,
      gameSlug: freezed == gameSlug
          ? _self.gameSlug
          : gameSlug // ignore: cast_nullable_to_non_nullable
              as String?,
      dateSaved: freezed == dateSaved
          ? _self.dateSaved
          : dateSaved // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completed: null == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      platforms: freezed == platforms
          ? _self.platforms
          : platforms // ignore: cast_nullable_to_non_nullable
              as List<PlatformEntity>?,
      availablePlatforms: freezed == availablePlatforms
          ? _self.availablePlatforms
          : availablePlatforms // ignore: cast_nullable_to_non_nullable
              as List<PlatformEntity>?,
      dateModified: freezed == dateModified
          ? _self.dateModified
          : dateModified // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      groupTasks: null == groupTasks
          ? _self.groupTasks
          : groupTasks // ignore: cast_nullable_to_non_nullable
              as List<TrackerGroupTaskEntity>,
    ));
  }
}

/// Adds pattern-matching-related methods to [TrackerSavedGameEntity].
extension TrackerSavedGameEntityPatterns on TrackerSavedGameEntity {
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
    TResult Function(_TrackerSavedGameEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrackerSavedGameEntity() when $default != null:
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
    TResult Function(_TrackerSavedGameEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackerSavedGameEntity():
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
    TResult? Function(_TrackerSavedGameEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackerSavedGameEntity() when $default != null:
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
            String? name,
            String? imageUrl,
            int? gameId,
            String? gameSlug,
            DateTime? dateSaved,
            bool completed,
            List<PlatformEntity>? platforms,
            List<PlatformEntity>? availablePlatforms,
            DateTime? dateModified,
            List<TrackerGroupTaskEntity> groupTasks)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrackerSavedGameEntity() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.imageUrl,
            _that.gameId,
            _that.gameSlug,
            _that.dateSaved,
            _that.completed,
            _that.platforms,
            _that.availablePlatforms,
            _that.dateModified,
            _that.groupTasks);
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
            String? name,
            String? imageUrl,
            int? gameId,
            String? gameSlug,
            DateTime? dateSaved,
            bool completed,
            List<PlatformEntity>? platforms,
            List<PlatformEntity>? availablePlatforms,
            DateTime? dateModified,
            List<TrackerGroupTaskEntity> groupTasks)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackerSavedGameEntity():
        return $default(
            _that.id,
            _that.name,
            _that.imageUrl,
            _that.gameId,
            _that.gameSlug,
            _that.dateSaved,
            _that.completed,
            _that.platforms,
            _that.availablePlatforms,
            _that.dateModified,
            _that.groupTasks);
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
            String? name,
            String? imageUrl,
            int? gameId,
            String? gameSlug,
            DateTime? dateSaved,
            bool completed,
            List<PlatformEntity>? platforms,
            List<PlatformEntity>? availablePlatforms,
            DateTime? dateModified,
            List<TrackerGroupTaskEntity> groupTasks)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackerSavedGameEntity() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.imageUrl,
            _that.gameId,
            _that.gameSlug,
            _that.dateSaved,
            _that.completed,
            _that.platforms,
            _that.availablePlatforms,
            _that.dateModified,
            _that.groupTasks);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _TrackerSavedGameEntity implements TrackerSavedGameEntity {
  const _TrackerSavedGameEntity(
      {required this.id,
      this.name,
      this.imageUrl,
      this.gameId,
      this.gameSlug,
      this.dateSaved,
      this.completed = false,
      final List<PlatformEntity>? platforms,
      final List<PlatformEntity>? availablePlatforms,
      this.dateModified,
      final List<TrackerGroupTaskEntity> groupTasks = const []})
      : _platforms = platforms,
        _availablePlatforms = availablePlatforms,
        _groupTasks = groupTasks;

  @override
  final int id;
  @override
  final String? name;
  @override
  final String? imageUrl;
  @override
  final int? gameId;
  @override
  final String? gameSlug;
  @override
  final DateTime? dateSaved;
  @override
  @JsonKey()
  final bool completed;
  final List<PlatformEntity>? _platforms;
  @override
  List<PlatformEntity>? get platforms {
    final value = _platforms;
    if (value == null) return null;
    if (_platforms is EqualUnmodifiableListView) return _platforms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<PlatformEntity>? _availablePlatforms;
  @override
  List<PlatformEntity>? get availablePlatforms {
    final value = _availablePlatforms;
    if (value == null) return null;
    if (_availablePlatforms is EqualUnmodifiableListView)
      return _availablePlatforms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? dateModified;
  final List<TrackerGroupTaskEntity> _groupTasks;
  @override
  @JsonKey()
  List<TrackerGroupTaskEntity> get groupTasks {
    if (_groupTasks is EqualUnmodifiableListView) return _groupTasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_groupTasks);
  }

  /// Create a copy of TrackerSavedGameEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TrackerSavedGameEntityCopyWith<_TrackerSavedGameEntity> get copyWith =>
      __$TrackerSavedGameEntityCopyWithImpl<_TrackerSavedGameEntity>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TrackerSavedGameEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.gameSlug, gameSlug) ||
                other.gameSlug == gameSlug) &&
            (identical(other.dateSaved, dateSaved) ||
                other.dateSaved == dateSaved) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            const DeepCollectionEquality()
                .equals(other._platforms, _platforms) &&
            const DeepCollectionEquality()
                .equals(other._availablePlatforms, _availablePlatforms) &&
            (identical(other.dateModified, dateModified) ||
                other.dateModified == dateModified) &&
            const DeepCollectionEquality()
                .equals(other._groupTasks, _groupTasks));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      imageUrl,
      gameId,
      gameSlug,
      dateSaved,
      completed,
      const DeepCollectionEquality().hash(_platforms),
      const DeepCollectionEquality().hash(_availablePlatforms),
      dateModified,
      const DeepCollectionEquality().hash(_groupTasks));

  @override
  String toString() {
    return 'TrackerSavedGameEntity(id: $id, name: $name, imageUrl: $imageUrl, gameId: $gameId, gameSlug: $gameSlug, dateSaved: $dateSaved, completed: $completed, platforms: $platforms, availablePlatforms: $availablePlatforms, dateModified: $dateModified, groupTasks: $groupTasks)';
  }
}

/// @nodoc
abstract mixin class _$TrackerSavedGameEntityCopyWith<$Res>
    implements $TrackerSavedGameEntityCopyWith<$Res> {
  factory _$TrackerSavedGameEntityCopyWith(_TrackerSavedGameEntity value,
          $Res Function(_TrackerSavedGameEntity) _then) =
      __$TrackerSavedGameEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String? name,
      String? imageUrl,
      int? gameId,
      String? gameSlug,
      DateTime? dateSaved,
      bool completed,
      List<PlatformEntity>? platforms,
      List<PlatformEntity>? availablePlatforms,
      DateTime? dateModified,
      List<TrackerGroupTaskEntity> groupTasks});
}

/// @nodoc
class __$TrackerSavedGameEntityCopyWithImpl<$Res>
    implements _$TrackerSavedGameEntityCopyWith<$Res> {
  __$TrackerSavedGameEntityCopyWithImpl(this._self, this._then);

  final _TrackerSavedGameEntity _self;
  final $Res Function(_TrackerSavedGameEntity) _then;

  /// Create a copy of TrackerSavedGameEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? imageUrl = freezed,
    Object? gameId = freezed,
    Object? gameSlug = freezed,
    Object? dateSaved = freezed,
    Object? completed = null,
    Object? platforms = freezed,
    Object? availablePlatforms = freezed,
    Object? dateModified = freezed,
    Object? groupTasks = null,
  }) {
    return _then(_TrackerSavedGameEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      gameId: freezed == gameId
          ? _self.gameId
          : gameId // ignore: cast_nullable_to_non_nullable
              as int?,
      gameSlug: freezed == gameSlug
          ? _self.gameSlug
          : gameSlug // ignore: cast_nullable_to_non_nullable
              as String?,
      dateSaved: freezed == dateSaved
          ? _self.dateSaved
          : dateSaved // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completed: null == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      platforms: freezed == platforms
          ? _self._platforms
          : platforms // ignore: cast_nullable_to_non_nullable
              as List<PlatformEntity>?,
      availablePlatforms: freezed == availablePlatforms
          ? _self._availablePlatforms
          : availablePlatforms // ignore: cast_nullable_to_non_nullable
              as List<PlatformEntity>?,
      dateModified: freezed == dateModified
          ? _self.dateModified
          : dateModified // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      groupTasks: null == groupTasks
          ? _self._groupTasks
          : groupTasks // ignore: cast_nullable_to_non_nullable
              as List<TrackerGroupTaskEntity>,
    ));
  }
}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracker_task_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackerTaskEntity {
  int get id;
  int? get savedGameId;
  int? get gameId;
  String? get title;
  String? get description;
  bool? get completed;
  String? get timeToComplete;
  bool? get pinned;
  int get currentStepIndex;
  List<TrackerTaskStepEntity> get steps;
  bool get setReminder;

  /// Create a copy of TrackerTaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TrackerTaskEntityCopyWith<TrackerTaskEntity> get copyWith =>
      _$TrackerTaskEntityCopyWithImpl<TrackerTaskEntity>(
          this as TrackerTaskEntity, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TrackerTaskEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.savedGameId, savedGameId) ||
                other.savedGameId == savedGameId) &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.timeToComplete, timeToComplete) ||
                other.timeToComplete == timeToComplete) &&
            (identical(other.pinned, pinned) || other.pinned == pinned) &&
            (identical(other.currentStepIndex, currentStepIndex) ||
                other.currentStepIndex == currentStepIndex) &&
            const DeepCollectionEquality().equals(other.steps, steps) &&
            (identical(other.setReminder, setReminder) ||
                other.setReminder == setReminder));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      savedGameId,
      gameId,
      title,
      description,
      completed,
      timeToComplete,
      pinned,
      currentStepIndex,
      const DeepCollectionEquality().hash(steps),
      setReminder);

  @override
  String toString() {
    return 'TrackerTaskEntity(id: $id, savedGameId: $savedGameId, gameId: $gameId, title: $title, description: $description, completed: $completed, timeToComplete: $timeToComplete, pinned: $pinned, currentStepIndex: $currentStepIndex, steps: $steps, setReminder: $setReminder)';
  }
}

/// @nodoc
abstract mixin class $TrackerTaskEntityCopyWith<$Res> {
  factory $TrackerTaskEntityCopyWith(
          TrackerTaskEntity value, $Res Function(TrackerTaskEntity) _then) =
      _$TrackerTaskEntityCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      int? savedGameId,
      int? gameId,
      String? title,
      String? description,
      bool? completed,
      String? timeToComplete,
      bool? pinned,
      int currentStepIndex,
      List<TrackerTaskStepEntity> steps,
      bool setReminder});
}

/// @nodoc
class _$TrackerTaskEntityCopyWithImpl<$Res>
    implements $TrackerTaskEntityCopyWith<$Res> {
  _$TrackerTaskEntityCopyWithImpl(this._self, this._then);

  final TrackerTaskEntity _self;
  final $Res Function(TrackerTaskEntity) _then;

  /// Create a copy of TrackerTaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? savedGameId = freezed,
    Object? gameId = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? completed = freezed,
    Object? timeToComplete = freezed,
    Object? pinned = freezed,
    Object? currentStepIndex = null,
    Object? steps = null,
    Object? setReminder = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      savedGameId: freezed == savedGameId
          ? _self.savedGameId
          : savedGameId // ignore: cast_nullable_to_non_nullable
              as int?,
      gameId: freezed == gameId
          ? _self.gameId
          : gameId // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      completed: freezed == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool?,
      timeToComplete: freezed == timeToComplete
          ? _self.timeToComplete
          : timeToComplete // ignore: cast_nullable_to_non_nullable
              as String?,
      pinned: freezed == pinned
          ? _self.pinned
          : pinned // ignore: cast_nullable_to_non_nullable
              as bool?,
      currentStepIndex: null == currentStepIndex
          ? _self.currentStepIndex
          : currentStepIndex // ignore: cast_nullable_to_non_nullable
              as int,
      steps: null == steps
          ? _self.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<TrackerTaskStepEntity>,
      setReminder: null == setReminder
          ? _self.setReminder
          : setReminder // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [TrackerTaskEntity].
extension TrackerTaskEntityPatterns on TrackerTaskEntity {
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
    TResult Function(_TrackerTaskEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrackerTaskEntity() when $default != null:
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
    TResult Function(_TrackerTaskEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackerTaskEntity():
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
    TResult? Function(_TrackerTaskEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackerTaskEntity() when $default != null:
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
            int? savedGameId,
            int? gameId,
            String? title,
            String? description,
            bool? completed,
            String? timeToComplete,
            bool? pinned,
            int currentStepIndex,
            List<TrackerTaskStepEntity> steps,
            bool setReminder)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrackerTaskEntity() when $default != null:
        return $default(
            _that.id,
            _that.savedGameId,
            _that.gameId,
            _that.title,
            _that.description,
            _that.completed,
            _that.timeToComplete,
            _that.pinned,
            _that.currentStepIndex,
            _that.steps,
            _that.setReminder);
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
            int? savedGameId,
            int? gameId,
            String? title,
            String? description,
            bool? completed,
            String? timeToComplete,
            bool? pinned,
            int currentStepIndex,
            List<TrackerTaskStepEntity> steps,
            bool setReminder)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackerTaskEntity():
        return $default(
            _that.id,
            _that.savedGameId,
            _that.gameId,
            _that.title,
            _that.description,
            _that.completed,
            _that.timeToComplete,
            _that.pinned,
            _that.currentStepIndex,
            _that.steps,
            _that.setReminder);
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
            int? savedGameId,
            int? gameId,
            String? title,
            String? description,
            bool? completed,
            String? timeToComplete,
            bool? pinned,
            int currentStepIndex,
            List<TrackerTaskStepEntity> steps,
            bool setReminder)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackerTaskEntity() when $default != null:
        return $default(
            _that.id,
            _that.savedGameId,
            _that.gameId,
            _that.title,
            _that.description,
            _that.completed,
            _that.timeToComplete,
            _that.pinned,
            _that.currentStepIndex,
            _that.steps,
            _that.setReminder);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _TrackerTaskEntity implements TrackerTaskEntity {
  const _TrackerTaskEntity(
      {required this.id,
      this.savedGameId,
      this.gameId,
      this.title,
      this.description,
      this.completed,
      this.timeToComplete,
      this.pinned,
      this.currentStepIndex = 0,
      final List<TrackerTaskStepEntity> steps = const [],
      this.setReminder = false})
      : _steps = steps;

  @override
  final int id;
  @override
  final int? savedGameId;
  @override
  final int? gameId;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final bool? completed;
  @override
  final String? timeToComplete;
  @override
  final bool? pinned;
  @override
  @JsonKey()
  final int currentStepIndex;
  final List<TrackerTaskStepEntity> _steps;
  @override
  @JsonKey()
  List<TrackerTaskStepEntity> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  @override
  @JsonKey()
  final bool setReminder;

  /// Create a copy of TrackerTaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TrackerTaskEntityCopyWith<_TrackerTaskEntity> get copyWith =>
      __$TrackerTaskEntityCopyWithImpl<_TrackerTaskEntity>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TrackerTaskEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.savedGameId, savedGameId) ||
                other.savedGameId == savedGameId) &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.timeToComplete, timeToComplete) ||
                other.timeToComplete == timeToComplete) &&
            (identical(other.pinned, pinned) || other.pinned == pinned) &&
            (identical(other.currentStepIndex, currentStepIndex) ||
                other.currentStepIndex == currentStepIndex) &&
            const DeepCollectionEquality().equals(other._steps, _steps) &&
            (identical(other.setReminder, setReminder) ||
                other.setReminder == setReminder));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      savedGameId,
      gameId,
      title,
      description,
      completed,
      timeToComplete,
      pinned,
      currentStepIndex,
      const DeepCollectionEquality().hash(_steps),
      setReminder);

  @override
  String toString() {
    return 'TrackerTaskEntity(id: $id, savedGameId: $savedGameId, gameId: $gameId, title: $title, description: $description, completed: $completed, timeToComplete: $timeToComplete, pinned: $pinned, currentStepIndex: $currentStepIndex, steps: $steps, setReminder: $setReminder)';
  }
}

/// @nodoc
abstract mixin class _$TrackerTaskEntityCopyWith<$Res>
    implements $TrackerTaskEntityCopyWith<$Res> {
  factory _$TrackerTaskEntityCopyWith(
          _TrackerTaskEntity value, $Res Function(_TrackerTaskEntity) _then) =
      __$TrackerTaskEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      int? savedGameId,
      int? gameId,
      String? title,
      String? description,
      bool? completed,
      String? timeToComplete,
      bool? pinned,
      int currentStepIndex,
      List<TrackerTaskStepEntity> steps,
      bool setReminder});
}

/// @nodoc
class __$TrackerTaskEntityCopyWithImpl<$Res>
    implements _$TrackerTaskEntityCopyWith<$Res> {
  __$TrackerTaskEntityCopyWithImpl(this._self, this._then);

  final _TrackerTaskEntity _self;
  final $Res Function(_TrackerTaskEntity) _then;

  /// Create a copy of TrackerTaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? savedGameId = freezed,
    Object? gameId = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? completed = freezed,
    Object? timeToComplete = freezed,
    Object? pinned = freezed,
    Object? currentStepIndex = null,
    Object? steps = null,
    Object? setReminder = null,
  }) {
    return _then(_TrackerTaskEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      savedGameId: freezed == savedGameId
          ? _self.savedGameId
          : savedGameId // ignore: cast_nullable_to_non_nullable
              as int?,
      gameId: freezed == gameId
          ? _self.gameId
          : gameId // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      completed: freezed == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool?,
      timeToComplete: freezed == timeToComplete
          ? _self.timeToComplete
          : timeToComplete // ignore: cast_nullable_to_non_nullable
              as String?,
      pinned: freezed == pinned
          ? _self.pinned
          : pinned // ignore: cast_nullable_to_non_nullable
              as bool?,
      currentStepIndex: null == currentStepIndex
          ? _self.currentStepIndex
          : currentStepIndex // ignore: cast_nullable_to_non_nullable
              as int,
      steps: null == steps
          ? _self._steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<TrackerTaskStepEntity>,
      setReminder: null == setReminder
          ? _self.setReminder
          : setReminder // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
